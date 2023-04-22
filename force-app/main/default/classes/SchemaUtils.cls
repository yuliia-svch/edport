public inherited sharing class SchemaUtils {
	public static String getRecordTypeName(String objectName, Id recordTypeId) {
		return getRecordTypeNamesById(objectName).get(recordTypeId);
	}

	public static Map<Id, String> getRecordTypeNamesById(String objectName) {
		return getRecordTypeNamesById(objectName, true);
	}

	public static Map<Id, String> getRecordTypeNamesById(String objectName, Boolean getAllRecordTypes) {
		Map<Id, String> result = new Map<Id, String>();

		DescribeSObjectResult objectDescribe = Schema.describeSObjects(new List<String> { objectName })[0];

		if (objectDescribe != null) {
			for (Schema.RecordTypeInfo rt : objectDescribe.getRecordTypeInfos()) {
				if (getAllRecordTypes || rt.isAvailable()) {
					result.put(rt.getRecordTypeId(), rt.getName());
				}
			}
		}

		return result;
	}
}