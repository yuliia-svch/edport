public class TestUtil {
	public static User buildPortalTeacherUser() {
		Account accountRecord = (Account) createRecord('Account', new Map<String, Object>{
				'Name' => getRandomString(5)
		});

		Contact contactRecord = (Contact) createRecord('Contact', new Map<String, Object>{
				'LastName' => getRandomString(5),
				'AccountId' => accountRecord.Id
		});

		User portalUser = buildUser('Educational Portal - Teacher', false);
		portalUser.ContactId = contactRecord.Id;
		Database.insert(portalUser);
		return portalUser;
	}

	public static User buildPortalStudentUser(Id groupId) {
		Account accountRecord = (Account) createRecord('Account', new Map<String, Object>{
				'Name' => getRandomString(5)
		});

		Contact contactRecord = (Contact) createRecord('Contact', new Map<String, Object>{
				'LastName' => getRandomString(5),
				'AccountId' => accountRecord.Id,
				'Group__c' => groupId
		});

		User portalUser = buildUser('Educational Portal - Student', false);
		portalUser.ContactId = contactRecord.Id;
		Database.insert(portalUser);
		return portalUser;
	}

	public static User buildUser(String profileName, Boolean doInsert) {
		User userRecord = new User();
		userRecord.Username = getRandomEmail();
		userRecord.ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1]?.Id;
		userRecord.IsActive = true;
		userRecord.Email = getRandomEmail();
		userRecord.FirstName = getRandomString(5);
		userRecord.LastName = getRandomString(5);
		userRecord.Alias = getRandomString(5);
		userRecord.EmailEncodingKey = 'ISO-8859-1';
		userRecord.TimeZoneSidKey = 'America/Los_Angeles';
		userRecord.LanguageLocaleKey = 'en_US';
		userRecord.LocaleSidKey = 'en_US';
		userRecord.CommunityNickname = getRandomString(5);

		if (doInsert) {
			Database.insert(userRecord);
		}

		return userRecord;
	}

	public static String getRandomString(Integer length) {
		String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
		String result = '';
		while (result.length() < length) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			result += chars.substring(idx, idx + 1);
		}
		return result;
	}

	public static String getRandomEmail() {
		return (getRandomString(4) + '@' + getRandomString(4) + '.' + getRandomString(3)).toLowerCase();
	}

	public static SObject createRecord(String objectName, Map<String, Object> valuesByFields) {
		Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
		SObject record = sObjectType.newSObject();
		for (String field : valuesByFields.keySet()) {
			record.put(field, valuesByFields.get(field));
		}
		Database.insert(record);
		return record;
	}
}