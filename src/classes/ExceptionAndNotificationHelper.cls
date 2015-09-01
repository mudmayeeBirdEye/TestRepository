public with sharing class ExceptionAndNotificationHelper {
	public static final String EXCEPTION_RECORD_TYPE = 'Exception History';
	public static final String NOTIFICATION_RECORD_TYPE = 'Email Notification';
	public static Map<String,RecordType> rcMap = new Map<String, RecordType>();
	static {
		List<String> rcTypeList = new List<String>();
		rcTypeList.add(EXCEPTION_RECORD_TYPE);
		rcTypeList.add(NOTIFICATION_RECORD_TYPE);
		for(RecordType rcObj : [SELECT Id, Name FROM RecordType WHERE Name IN :rcTypeList ]) {
			rcMap.put(rcObj.Name, rcObj);
		}
		System.debug('#####=> '+ rcMap +'<=####');
	}

	public static String getRcId(String rcName) {
		
		if(rcMap.size() == 0) {
			List<String> rcTypeList = new List<String>(); 
			rcTypeList.add(EXCEPTION_RECORD_TYPE);
			rcTypeList.add(NOTIFICATION_RECORD_TYPE);
			for(RecordType rcObj : [SELECT Id, Name FROM RecordType WHERE Name IN :rcTypeList ]) {
				rcMap.put(rcObj.Name, rcObj);
			}
			System.debug('****=> '+ rcMap +'<=****');
		}
		
		return (rcMap.get(rcName) == null ? rcMap.values().get(0).Id : ''+rcMap.get(rcName).Id);
	}
	public static void notificationPerWorkflow(List<Exception_And_Notification_History__c> notificationList) {
		try {
			if(notificationList != null && notificationList.size() != 0) {
				insert notificationList;
			}
		} catch(Exception ex) { trackExceptions(notificationList, ex);}
	}
	public static void notificationPerWorkflow(Exception_And_Notification_History__c notificationItem) {
		try {
			if(notificationItem != null ) {
				insert notificationItem;
			}
		} catch(Exception ex) { trackExceptions(notificationItem, ex);}
	}
	public static void trackExceptions(Exception_And_Notification_History__c exceptionRecordObj, Exception exceptionObj ) {
		exceptionRecordObj.recordTypeId = getRcId(ExceptionAndNotificationHelper.EXCEPTION_RECORD_TYPE);
		exceptionRecordObj.content_var_02__c = exceptionObj.getLineNumber() +'';
        exceptionRecordObj.content_var_03__c = exceptionObj.getTypeName();
        exceptionRecordObj.content_var_04__c = exceptionObj.getStackTraceString();
        exceptionRecordObj.content_var_05__c = exceptionObj.getMessage();
        
        exceptionRecordObj.Line_Number__c = exceptionObj.getLineNumber();
        exceptionRecordObj.Exception__c = exceptionObj.getTypeName();
        exceptionRecordObj.stackTraceString__c = exceptionObj.getStackTraceString();
        exceptionRecordObj.Exception_Desc__c = exceptionObj.getMessage();
        exceptionRecordObj.Modified_By__c = UserInfo.getUserId();
		insert exceptionRecordObj;
	}
	public static void trackExceptions(List<Exception_And_Notification_History__c> exceptionList, Exception exceptionObj ) {
		for(Exception_And_Notification_History__c exceptionRecordObj: exceptionList) {
			exceptionRecordObj.recordTypeId = getRcId(ExceptionAndNotificationHelper.EXCEPTION_RECORD_TYPE);
			exceptionRecordObj.content_var_02__c = exceptionObj.getLineNumber() +'';
        	exceptionRecordObj.content_var_03__c = exceptionObj.getTypeName();
        	exceptionRecordObj.content_var_04__c = exceptionObj.getStackTraceString();
        	exceptionRecordObj.content_var_05__c = exceptionObj.getMessage();
        	
        	exceptionRecordObj.Line_Number__c = exceptionObj.getLineNumber();
        	exceptionRecordObj.Exception__c = exceptionObj.getTypeName();
        	exceptionRecordObj.stackTraceString__c = exceptionObj.getStackTraceString();
        	exceptionRecordObj.Exception_Desc__c = exceptionObj.getMessage();
        	exceptionRecordObj.Modified_By__c = UserInfo.getUserId();
		}
		insert exceptionList;
	}
}