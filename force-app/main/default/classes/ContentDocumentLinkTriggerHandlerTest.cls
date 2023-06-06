@isTest
public with sharing class ContentDocumentLinkTriggerHandlerTest {
	@isTest
	public static void should_setVisibility() {
		Group__c group1 = (Group__c) TestUtil.createRecord('Group__c', new Map<String, Object>{
			'Name' => TestUtil.getRandomString(5)
		});
		User student = TestUtil.buildPortalStudentUser(group1.Id);
		User teacher = TestUtil.buildPortalTeacherUser();
		Course__c course = (Course__c) TestUtil.createRecord('Course__c', new Map<String, Object> {
			'Name' => TestUtil.getRandomString(5),
			'Credits__c' => 5
		});
		Group_Course__c groupCourse = (Group_Course__c) TestUtil.createRecord('Group_Course__c', new Map<String, Object> {
			'Group__c' => group1.Id,
			'Course__c' => course.Id
		});
		Lecture__c lecture = (Lecture__c) TestUtil.createRecord('Lecture__c', new Map<String, Object> {
			'Name' => 'Lecture 1',
			'Course__c' => course.Id,
			'Teacher__c' => teacher.ContactId,
			'StartTime__c' => datetime.now(),
			'EndTime__c' => datetime.now().addHours(1)
		});

		ContentVersion content = new ContentVersion(); 
        content.Title = 'Loan Documents - test'; 
        content.PathOnClient = '/' + content.Title + '.jpg'; 
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData = bodyBlob; 
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = lecture.id;
        contentlink.contentdocumentid = [SELECT contentdocumentid FROM contentversion WHERE id =: content.id].contentdocumentid;
        contentlink.ShareType = 'V';

		Test.startTest();
        insert contentlink;
		Test.stopTest();

		ContentDocumentLink result = [SELECT Visibility FROM ContentDocumentLink WHERE Id = :contentlink.Id];
		Assert.areEqual('AllUsers', result.Visibility);
	}
}