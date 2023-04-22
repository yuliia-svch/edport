@IsTest
public class ScheduleControllerTest {
	@IsTest
	static void should_getScheduleData() {
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
		Assignment__c assignment = (Assignment__c) TestUtil.createRecord('Assignment__c', new Map<String, Object> {
			'Name' => 'Assignment 1',
			'Course__c' => course.Id,
			'Teacher__c' => teacher.ContactId,
			'StartTime__c' => datetime.now(),
			'EndTime__c' => datetime.now().addHours(1)
		});
		System.runAs(student) {
			List<Models.Event> events = ScheduleController.getScheduleData();
			Assert.areEqual(2, events.size());
		}
	}
}