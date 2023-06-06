@IsTest
public class FileControllerTest {
    @isTest
	public static void should_createContentDistributions() {
		User teacher = TestUtil.buildPortalTeacherUser();
		Course__c course = (Course__c) TestUtil.createRecord('Course__c', new Map<String, Object> {
			'Name' => TestUtil.getRandomString(5),
			'Credits__c' => 5
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
		FileController.createContentDistributions(new List<Id>{contentLink.ContentDocumentId}, contentlink.LinkedEntityId);
		List<Models.File> files = FileController.getFiles(lecture.Id);
        Test.stopTest();

		Assert.areEqual(1, files.size());
	}

    @isTest
	public static void should_deleteFile() {
        User teacher = TestUtil.buildPortalTeacherUser();
		Course__c course = (Course__c) TestUtil.createRecord('Course__c', new Map<String, Object> {
			'Name' => TestUtil.getRandomString(5),
			'Credits__c' => 5
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
		FileController.createContentDistributions(new List<Id>{contentLink.ContentDocumentId}, contentlink.LinkedEntityId);
		FileController.deleteFile(contentLink.ContentDocumentId);
        List<Models.File> files = FileController.getFiles(lecture.Id);
        Test.stopTest();

		Assert.areEqual(0, files.size());
    }
}