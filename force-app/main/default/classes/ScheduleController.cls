public with sharing class ScheduleController {
	@AuraEnabled
	public static List<Models.Event> getScheduleData(String audience) {
		try {
			List<Models.Event> data = new List<Models.Event>();
			List<Course__c> courses = new List<Course__c>();
			if (audience == 'Teacher') {
				courses = DataProvider.getAllCourses();
			} else {
				courses = DataProvider.getStudentCourses();
			}
			for (Course__c course : courses) {
				for (Lecture__c lecture : course.Lectures__r) {
					Models.Event event = new Models.Event();
					event.id = lecture.Id;
					event.name = lecture.Name;
					event.link = lecture.ConferenceLink__c;
					event.startTime = lecture.StartTime__c?.addHours(1);
					event.endTime = lecture.EndTime__c?.addHours(1);
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
					event.startTime = assignment.StartTime__c?.addHours(1);
					event.endTime = assignment.EndTime__c?.addHours(1);
					event.teacherName = assignment.Teacher__r.Name;
					event.teacherId = assignment.Teacher__c;
					event.type = SchemaUtils.getRecordTypeName('Assignment__c', assignment.RecordTypeId);
					data.add(event);
				}
			}
			return data;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}