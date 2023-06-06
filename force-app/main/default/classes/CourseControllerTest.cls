@IsTest
public class CourseControllerTest {
	@IsTest
	static void should_getStudentCourses() {
		Group__c group1 = (Group__c) TestUtil.createRecord('Group__c', new Map<String, Object>{
			'Name' => TestUtil.getRandomString(5)
		});
		User student = TestUtil.buildPortalStudentUser(group1.Id);
		User teacher = TestUtil.buildPortalTeacherUser();
		Course__c course = (Course__c) TestUtil.createRecord('Course__c', new Map<String, Object> {
			'Name' => TestUtil.getRandomString(5),
			'Credits__c' => 5
		});
		Course__c course2 = (Course__c) TestUtil.createRecord('Course__c', new Map<String, Object> {
			'Name' => TestUtil.getRandomString(5),
			'Credits__c' => 4
		});
		Group_Course__c groupCourse = (Group_Course__c) TestUtil.createRecord('Group_Course__c', new Map<String, Object> {
			'Group__c' => group1.Id,
			'Course__c' => course.Id
		});
		Group_Course__c groupCourse2 = (Group_Course__c) TestUtil.createRecord('Group_Course__c', new Map<String, Object> {
			'Group__c' => group1.Id,
			'Course__c' => course2.Id
		});
		System.runAs(student) {
			List<Models.Course> courses = CourseController.getStudentCourses();
			Assert.areEqual(2, courses.size());
		}
	}

	@IsTest
	static void should_getStudentTodayEvents() {
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
			'Maximum_Score__c' => 4,
			'StartTime__c' => datetime.now(),
			'EndTime__c' => datetime.now().addHours(1)
		});
		System.runAs(student) {
			List<Models.Event> events = CourseController.getStudentTodayEvents();
			Assert.areEqual(2, events.size());
		}
	}

	@IsTest
	static void should_getTeacherEvents() {
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
		Assignment__c assignment = (Assignment__c) TestUtil.createRecord('Assignment__c', new Map<String, Object> {
			'Name' => 'Assignment 1',
			'Course__c' => course.Id,
			'Teacher__c' => teacher.ContactId,
			'Maximum_Score__c' => 4,
			'StartTime__c' => datetime.now(),
			'EndTime__c' => datetime.now().addHours(1)
		});
		System.runAs(teacher) {
			List<Models.Event> events = CourseController.getTeacherEvents();
			Assert.areEqual(2, events.size());
		}
	}

	@IsTest
	static void should_getGradeList() {
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
		Assignment__c assignment = (Assignment__c) TestUtil.createRecord('Assignment__c', new Map<String, Object> {
			'Name' => 'Assignment 1',
			'Course__c' => course.Id,
			'Teacher__c' => teacher.ContactId,
			'Maximum_Score__c' => 4,
			'StartTime__c' => datetime.now(),
			'EndTime__c' => datetime.now().addHours(1)
		});

		Task__c task = (Task__c) TestUtil.createRecord('Task__c', new Map<String, Object> {
			'Assignment__c' => assignment.Id,
			'OwnerId' => student.Id,
			'Grade__c' => 3
		});
		System.runAs(student) {
			List<Models.CourseGrades> grades = CourseController.getGradeList();
			Assert.areEqual(1, grades.size());
		}
	}

	@IsTest
	static void should_getTasksToGrade() {
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
		Assignment__c assignment = (Assignment__c) TestUtil.createRecord('Assignment__c', new Map<String, Object> {
			'Name' => 'Assignment 1',
			'Course__c' => course.Id,
			'Teacher__c' => teacher.ContactId,
			'Maximum_Score__c' => 4,
			'StartTime__c' => datetime.now(),
			'EndTime__c' => datetime.now().addHours(1)
		});

		Task__c task = (Task__c) TestUtil.createRecord('Task__c', new Map<String, Object> {
			'Assignment__c' => assignment.Id,
			'OwnerId' => student.Id
		});
		System.runAs(teacher) {
			List<Models.Task> tasks = CourseController.getTasksToGrade();
			Assert.areEqual(1, tasks.size());
		}
	}

	@IsTest
	static void should_getAssignmentsDue() {
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
		Assignment__c assignment = (Assignment__c) TestUtil.createRecord('Assignment__c', new Map<String, Object> {
			'Name' => 'Assignment 1',
			'Course__c' => course.Id,
			'Teacher__c' => teacher.ContactId,
			'Maximum_Score__c' => 4,
			'StartTime__c' => datetime.now().addDays(-1),
			'EndTime__c' => datetime.now().addDays(-1)
		});

		System.runAs(student) {
			List<Models.Assignment> assignments = CourseController.getAssignmentsDue();
			Assert.areEqual(1, assignments.size());
		}
	}
}