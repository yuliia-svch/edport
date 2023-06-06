@isTest
public class DocumentUtilTest {
	@isTest
	public static void should_checkIsLinked(){
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
		content.Title = 'PPM'; 
		content.PathOnClient = '/' + content.Title + '.jpg';
		content.VersionData = Blob.valueOf('Unit Test ContentVersion Body'); 
		content.origin = 'H';
		insert content;
		ContentDocumentLink contentlink = new ContentDocumentLink();
		contentlink.LinkedEntityId = lecture.Id;
		contentlink.contentdocumentid = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :content.Id].ContentDocumentId;
		contentlink.ShareType = 'V';
		contentlink.Visibility = 'AllUsers'; 
		insert contentlink;

		Test.startTest();
		Assert.isTrue(DocumentUtil.isLinked(contentLink, 'Lecture__c'));
		Test.stopTest();
	}

	@isTest
	public static void should_createContentDistributions(){
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
		content.Title = 'PPM'; 
		content.PathOnClient = '/' + content.Title + '.jpg';
		content.VersionData = Blob.valueOf('Unit Test ContentVersion Body'); 
		content.origin = 'H';
		insert content;
		ContentDocumentLink contentlink = new ContentDocumentLink();
		contentlink.LinkedEntityId = lecture.Id;
		contentlink.contentdocumentid = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :content.Id].ContentDocumentId;
		contentlink.ShareType = 'V';
		contentlink.Visibility = 'AllUsers'; 
		insert contentlink;

		Test.startTest();
		DocumentUtil.createContentDistributions(new List<Id>{contentLink.ContentDocumentId}, contentlink.LinkedEntityId);
		Test.stopTest();

		List<ContentDistribution> result = [SELECT Id FROM ContentDistribution];
		Assert.areEqual(1, result.size());
	}

}