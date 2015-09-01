public with sharing class LiveAgentOfflineController {
	public Lead leadObj {get;set;}
	public string selectedEmployeeRange {get;set;}
	public List<SelectOption> employeeRangeItems {get;set;}
	
	
	public LiveAgentOfflineController() {
		leadObj = new Lead();
		employeeRangeItems = new List<SelectOption>();
		getEmployeeItems();
	}
	
	public void getEmployeeItems() {
		employeeRangeItems.add(new SelectOption('How many employees do you have?','How many employees do you have?'));
		employeeRangeItems.add(new SelectOption('Just me','Just me'));
		employeeRangeItems.add(new SelectOption('2-9','2-9'));
		employeeRangeItems.add(new SelectOption('10-19','10-19'));
		employeeRangeItems.add(new SelectOption('20-49','20-49'));
		employeeRangeItems.add(new SelectOption('50-99','50-99'));
		employeeRangeItems.add(new SelectOption('100-249','100-249'));
		employeeRangeItems.add(new SelectOption('250-500','250-500'));
		employeeRangeItems.add(new SelectOption('500+','500+'));
		selectedEmployeeRange = String.valueOf(employeeRangeItems[0]);
	}
	
	public pageReference createLead() {
		try {
			//leadObj = new Lead();
			if(selectedEmployeeRange != 'How many employees do you have?') {
				leadObj.LeadSource = 'BT WebLead';
				leadObj.Company = 'Test Company';
				leadObj.NumberOfEmployees__c = selectedEmployeeRange;
				if(leadObj.Comments__c != null && leadObj.Comments__c != '') {
					if(leadObj.Comments__c == 'How can we help?') {
						leadObj.Comments__c = '';	
					} else {
						Integer commentLength =  leadObj.Comments__c.length();
						if(commentLength > 250) {
							ApexPages.addMessage(new ApexPages.Message
							(ApexPages.Severity.ERROR,'Comment field value length is greater than 250. Please modify the comment value.')); 
							return null;	
						}
					  }	
				}
				insert leadObj;
				leadObj = new Lead();
			}
			else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the number of employees.')); 
				return null;
			}
			leadObj.FirstName = '';
			leadObj.LastName = '';
			leadObj.Email = '';
			leadObj.Phone = '';
			leadObj.Comments__c = '';
			selectedEmployeeRange = 'How many employees do you have?';
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
			return null;
		}
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Information Saved Successfully.'));
		return null;
	}
	
	/***Test Method**/
/*    @IsTest public static void testLiveAgentOfflineController() {
	
		LiveAgentOfflineController liveAgentOfflineCtrlObj = new LiveAgentOfflineController();
		liveAgentOfflineCtrlObj.leadObj.FirstName  = 'TestLead10';
		liveAgentOfflineCtrlObj.leadObj.LastName  = 'TestLeadLast10';
		liveAgentOfflineCtrlObj.leadObj.Email  = 'TestLead10@test.com';
		liveAgentOfflineCtrlObj.leadObj.Phone  = '123456789';
		liveAgentOfflineCtrlObj.leadObj.LeadSource = 'BT WebLead';
		liveAgentOfflineCtrlObj.leadObj.Company = 'Test Company';
		liveAgentOfflineCtrlObj.selectedEmployeeRange = '250-500';
		liveAgentOfflineCtrlObj.leadObj.NumberOfEmployees__c = liveAgentOfflineCtrlObj.selectedEmployeeRange;
		liveAgentOfflineCtrlObj.leadObj.Comments__c = 'Test Comments';	
		liveAgentOfflineCtrlObj.createLead();    
	}*/
}