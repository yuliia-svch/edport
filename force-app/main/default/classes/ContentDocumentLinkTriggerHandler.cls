public inherited sharing class ContentDocumentLinkTriggerHandler {
	public static void setVisibility(List<ContentDocumentLink> cdlList) {
		for (ContentDocumentLink cdl : cdlList) {
			if (DocumentUtil.isLinked(cdl, 'Task__c') || DocumentUtil.isLinked(cdl, 'Assignment__c') || DocumentUtil.isLinked(cdl, 'Lecture__c')) {
				cdl.Visibility = 'AllUsers';
			}
		}
	}
}