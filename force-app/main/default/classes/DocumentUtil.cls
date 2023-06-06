public inherited sharing class DocumentUtil {
	public static Boolean isLinked(ContentDocumentLink cdl, String objectName) {
		return cdl.LinkedEntityId.getSObjectType().getDescribe().getName() == objectName;
	}

	public static void createContentDistributions(List<Id> docIds, Id recordId) {
		List<ContentDistribution> ctDistrList = new List<ContentDistribution>();
		for (ContentVersion cv : [SELECT Title, FileExtension, VersionData, ContentDocumentId, FirstPublishLocationId FROM ContentVersion WHERE ContentDocumentId IN :docIds ORDER BY CreatedDate DESC]) {
			ContentDistribution ctDistr = new ContentDistribution();
			ctDistr.Name = cv.Title;
			ctDistr.ContentVersionId = cv.Id;
			ctDistr.RelatedRecordId = recordId;
			ctDistr.PreferencesAllowViewInBrowser = true;
			ctDistr.PreferencesNotifyOnVisit = false;
			ctDistr.PreferencesAllowOriginalDownload = true;
			ctDistr.PreferencesAllowPDFDownload = true;
			ctDistrList.add(ctDistr);
		}
		if (!ctDistrList.isEmpty()) {
			insert ctDistrList;
		}
	}

	public static void createContentDistributions(List<CreateContentDistributions.InputVariable> input) {
		if (input != null && !input[0].docIds.isEmpty() && input[0].recordId != null) {
			createContentDistributions(input[0].docIds, input[0].recordId);
		}
	}
}