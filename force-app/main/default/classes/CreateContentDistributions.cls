public with sharing class CreateContentDistributions {
	public class InputVariable {
		@InvocableVariable
		public List<Id> docIds;
		@InvocableVariable
		public Id recordId;
	}

	@InvocableMethod(label='Create Content Distributions')
	public static void createContentDistributions(List<InputVariable> input) {
		DocumentUtil.createContentDistributions(input);
	}
}