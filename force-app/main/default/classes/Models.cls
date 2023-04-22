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
}