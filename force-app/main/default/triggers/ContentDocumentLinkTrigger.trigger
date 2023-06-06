trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
	if (Trigger.isBefore) {
		ContentDocumentLinkTriggerHandler.setVisibility(Trigger.new);
	}
}