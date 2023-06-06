public without sharing class FileController {

    @AuraEnabled
    public static void createContentDistributions(List<Id> docIds, Id recordId) {
        try {
            DocumentUtil.createContentDistributions(docIds, recordId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Models.File> getFiles(String recordId) {
		List<Models.File> files = new List<Models.File>();
		List<ContentDistribution> contentDistributions = [SELECT Id, Name, ContentDocumentId, DistributionPublicUrl FROM ContentDistribution WHERE RelatedRecordId = :recordId ORDER BY CreatedDate];
        for (ContentDistribution cd : contentDistributions) {
            Models.File file = new Models.File();
            file.link = cd.DistributionPublicUrl;
            file.name = cd.Name;
            file.fileId = cd.ContentDocumentId;
            files.add(file);
        }
        return files;
    }

    @AuraEnabled
    public static void deleteFile(String fileId) {
        try {
            Database.delete(fileId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}