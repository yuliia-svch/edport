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

	public static List<Course__c> getStudentTodayEvents() {
		Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()]?.ContactId;
		Id groupId = [SELECT Group__c FROM Contact WHERE Id = :contactId]?.Group__c;
		return [
			SELECT Name, Credits__c, 
			(SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c FROM Lectures__r WHERE StartTime__c = TODAY ORDER BY StartTime__c),
			(SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c, RecordTypeId FROM Assignments__r WHERE StartTime__c = TODAY ORDER BY StartTime__c) 
			FROM Course__c 
			WHERE Id IN 
				(SELECT Course__c 
				FROM Group_Course__c 
				WHERE Group__c = :groupId)
		];
	}

	public static List<Models.CourseGrades> getCoursesGrades() {
		Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()]?.ContactId;
		Id groupId = [SELECT Group__c FROM Contact WHERE Id = :contactId]?.Group__c;
		Map<Id, Course__c> courses = new Map<Id, Course__c>([SELECT Id, Name, Credits__c 
									FROM Course__c 
									WHERE Id IN 
										(SELECT Course__c 
										FROM Group_Course__c 
										WHERE Group__c = :groupId)
		]);
		List<Assignment__c> assignments = [SELECT Name, Teacher__r.Name, Course__c, Maximum_Score__c,
											(SELECT Grade__c FROM Assignments__r WHERE OwnerId = :UserInfo.getUserId()) 
											FROM Assignment__c 
											WHERE Course__c IN :courses.keySet()];
		List<Models.CourseGrades> coursesGrades = new List<Models.CourseGrades>();
		for (Course__c course : courses.values()) {
			Models.CourseGrades courseGrades = new Models.CourseGrades();
			courseGrades.courseName = course.Name;
			Decimal overallGrade = 0;
			Decimal total = 0;
			courseGrades.assignmentGrades = new List<Models.AssignmentGrade>();
			for (Assignment__c assignment : assignments) {
				if(assignment.Course__c == course.Id) {
					Models.AssignmentGrade assignmentGrade = new Models.AssignmentGrade();
					assignmentGrade.assignmentName = assignment.Name;
					overallGrade += assignment.Maximum_Score__c;
					assignmentGrade.maximum = assignment.Maximum_Score__c;
					if (assignment.Assignments__r != null && !assignment.Assignments__r.isEmpty()) {
						assignmentGrade.grade = assignment.Assignments__r.get(0).Grade__c;
						total += assignmentGrade.grade != null? assignmentGrade.grade : 0;
					}
					courseGrades.assignmentGrades.add(assignmentGrade);
				}
			}
			courseGrades.credits = course.Credits__c;
			courseGrades.gradePoint = 0;
			if (overallGrade != 0 && !assignments.isEmpty()) {
				courseGrades.gradePoint = ((total * (overallGrade / courseGrades.assignmentGrades.size())) / overallGrade) * course.Credits__c;
			}
			coursesGrades.add(courseGrades);
		}
		return coursesGrades;
	}

	public static List<Course__c> getAllCourses() {
		return [
			SELECT Name, Credits__c, 
			(SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c FROM Lectures__r),
			(SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c, RecordTypeId FROM Assignments__r) 
			FROM Course__c
		];
	}

	public static List<Lecture__c> getTeacherLectures() {
		Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()]?.ContactId;
		return [SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c FROM Lecture__c WHERE Teacher__c = :contactId AND StartTime__c >= TODAY ORDER BY StartTime__c];
	}

	public static List<Assignment__c> getTeacherAssignments() {
		Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()]?.ContactId;
		return [SELECT Name, StartTime__c, EndTime__c, ConferenceLink__c, Teacher__r.Name, Teacher__c, RecordTypeId FROM Assignment__c WHERE Teacher__c = :contactId AND StartTime__c >= TODAY ORDER BY StartTime__c];
	}

	public static List<Task__c> getTasksToGrade() {
		Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()]?.ContactId;
		return [SELECT Owner.FirstName, Owner.LastName, Assignment__r.Name FROM Task__c WHERE Assignment__r.Teacher__c = :contactId AND Grade__c = NULL];
	}

	public static List<Assignment__c> getAssignmentsDue() {
		Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()]?.ContactId;
		Id groupId = [SELECT Group__c FROM Contact WHERE Id = :contactId]?.Group__c;
		Map<Id, Course__c> courses = new Map<Id, Course__c>([
			SELECT Id, Name, Credits__c
			FROM Course__c 
			WHERE Id IN 
				(SELECT Course__c 
				FROM Group_Course__c 
				WHERE Group__c = :groupId)
		]);
		return [
			SELECT Name, Course__r.Name, Teacher__r.Name,
			(SELECT Id FROM Assignments__r WHERE OwnerId = :UserInfo.getUserId()) 
			FROM Assignment__c 
			WHERE Course__c IN :courses.keySet() 
			AND StartTime__c < TODAY 
			ORDER BY StartTime__c
		];
	}
}