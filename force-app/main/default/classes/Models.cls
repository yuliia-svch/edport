public class Models {
	public class Course {
		@AuraEnabled
		public String id;
		@AuraEnabled
		public String link;
		@AuraEnabled
		public String name;
		@AuraEnabled
		public Decimal credits;
	}

	public class Assignment {
		@AuraEnabled
		public String name;
		@AuraEnabled
		public String id;
		@AuraEnabled
		public String teacherName;
		@AuraEnabled
		public String courseName;
	}

	public class Task {
		@AuraEnabled
		public String id;
		@AuraEnabled
		public String name;
		@AuraEnabled
		public String studentName;
	}

	public class Event {
		@AuraEnabled
		public String id;
		@AuraEnabled
		public DateTime startTime;
		@AuraEnabled
		public DateTime endTime;
		@AuraEnabled
		public String name;
		@AuraEnabled
		public String link;
		@AuraEnabled
		public String teacherName;
		@AuraEnabled
		public String teacherId;
		@AuraEnabled
		public String type;
	}

	public class File {
		@AuraEnabled
		public String name;
		@AuraEnabled
		public String link;
		@AuraEnabled
		public String fileId;
	}

	public class CourseGrades {
		@AuraEnabled
		public String courseName;
		@AuraEnabled
		public Decimal gradePoint;
		@AuraEnabled
		public Decimal credits;
		@AuraEnabled
		public List<AssignmentGrade> assignmentGrades;
	}

	public class AssignmentGrade {
		@AuraEnabled
		public String assignmentName;
		@AuraEnabled
		public Decimal grade;
		@AuraEnabled
		public Decimal maximum;
	}
}