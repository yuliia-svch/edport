public with sharing class CourseController {
	@AuraEnabled
	public static List<Models.Course> getStudentCourses() {
		List<Models.Course> courses = new List<Models.Course>();
		for (Course__c course : DataProvider.getStudentCourses()) {
		Models.Course courseModel = new Models.Course();
			courseModel.id = course.Id;
			courseModel.link = '/course/' + course.Id;
			courseModel.name = course.Name;
			courseModel.credits = course.Credits__c;
			courses.add(courseModel);
		}
		return courses;
	}

	@AuraEnabled
	public static List<Models.Event> getStudentTodayEvents() {
		List<Course__c> courses = DataProvider.getStudentTodayEvents();
		List<Models.Event> data = new List<Models.Event>();
		for (Course__c course : courses) {
			for (Lecture__c lecture : course.Lectures__r) {
				Models.Event event = new Models.Event();
				event.id = lecture.Id;
				event.name = lecture.Name;
				event.link = lecture.ConferenceLink__c;
				event.startTime = lecture.StartTime__c;
				event.endTime = lecture.EndTime__c;
				event.teacherName = lecture.Teacher__r.Name;
				event.teacherId = lecture.Teacher__c;
				event.type = 'Lecture';
				data.add(event);
			}
			for (Assignment__c assignment : course.Assignments__r) {
				Models.Event event = new Models.Event();
				event.id = assignment.Id;
				event.name = assignment.Name;
				event.link = assignment.ConferenceLink__c;
				event.startTime = assignment.StartTime__c;
				event.endTime = assignment.EndTime__c;
				event.teacherName = assignment.Teacher__r.Name;
				event.teacherId = assignment.Teacher__c;
				event.type = SchemaUtils.getRecordTypeName('Assignment__c', assignment.RecordTypeId);
				data.add(event);
			}
		}
		return data;
	}

	@AuraEnabled
	public static List<Models.Event> getTeacherEvents() {
		List<Models.Event> events = new List<Models.Event>();
		List<Lecture__c> lectures = DataProvider.getTeacherLectures();
		List<Assignment__c> assignments = DataProvider.getTeacherAssignments();
		for (Lecture__c lecture : lectures) {
			Models.Event event = new Models.Event();
			event.id = lecture.Id;
			event.name = lecture.Name;
			event.link = lecture.ConferenceLink__c;
			event.startTime = lecture.StartTime__c;
			event.endTime = lecture.EndTime__c;
			event.teacherName = lecture.Teacher__r.Name;
			event.teacherId = lecture.Teacher__c;
			event.type = 'Lecture';
			events.add(event);
		}
		for (Assignment__c assignment : assignments) {
			Models.Event event = new Models.Event();
			event.id = assignment.Id;
			event.name = assignment.Name;
			event.link = assignment.ConferenceLink__c;
			event.startTime = assignment.StartTime__c;
			event.endTime = assignment.EndTime__c;
			event.teacherName = assignment.Teacher__r.Name;
			event.teacherId = assignment.Teacher__c;
			event.type = SchemaUtils.getRecordTypeName('Assignment__c', assignment.RecordTypeId);
			events.add(event);
		}
		return events;
	}

	@AuraEnabled
	public static List<Models.CourseGrades> getGradeList() {
		return DataProvider.getCoursesGrades();
	}

	@AuraEnabled
	public static List<Models.Task> getTasksToGrade() {
		List<Models.Task> tasks = new List<Models.Task>();
		for (Task__c task : DataProvider.getTasksToGrade()) {
			Models.Task taskModel = new Models.Task();
			taskModel.id = task.Id;
			taskModel.name = task.Assignment__r.Name;
			taskModel.studentName = task.Owner.FirstName + ' ' + task.Owner.LastName;
			tasks.add(taskModel);
		}
		return tasks;
	}

	@AuraEnabled
	public static List<Models.Assignment> getAssignmentsDue() {
		List<Models.Assignment> assignments = new  List<Models.Assignment>();
		for (Assignment__c assignment : DataProvider.getAssignmentsDue()) {
			if (assignment.Assignments__r.isEmpty()) {
				Models.Assignment assignmentModel = new Models.Assignment();
				assignmentModel.courseName = assignment.Course__r.Name;
				assignmentModel.id = assignment.Id;
				assignmentModel.name = assignment.Name;
				assignmentModel.teacherName = assignment.Teacher__r.Name;
				assignments.add(assignmentModel);
			}
		}
		return assignments;
	}
}