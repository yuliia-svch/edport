public with sharing class DataProvider {
	public static List<Course__c> getStudentCourses() {
		Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()]?.ContactId;
		Id groupId = [SELECT Group__c FROM Contact WHERE Id = :contactId]?.Group__c;
		return [
			SELECT Name, Credits__c, 
			(SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c FROM Lectures__r),
			(SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c, RecordTypeId FROM Assignments__r) 
			FROM Course__c 
			WHERE Id IN 
				(SELECT Course__c 
				FROM Group_Course__c 
				WHERE Group__c = :groupId)
		];
	}

	public static List<Course__c> getAllCourses() {
		return [
			SELECT Name, Credits__c, 
			(SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c FROM Lectures__r),
			(SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c, RecordTypeId FROM Assignments__r) 
			FROM Course__c
		];
	}
}