public with sharing class CourseController {
	@AuraEnabled
	public static List<Models.Course> getStudentCourses() {
		try {
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
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}