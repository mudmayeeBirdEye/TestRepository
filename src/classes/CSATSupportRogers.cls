/*************************************************
Survey class
Along with SupportCSATSurvey.page and SupportCSATSurvey.page used in public sites allows customers to fill in CSAT surveys
There are Support Rogers Surveys. When created the customer is emailed a link to survey.page with survey record Id.
Find survey record and records answers entered through page.
/************************************************/

public class CSATSupportRogers {
	public boolean toShowPanel {get;set;}
	public Survey__c surveyObj {get;set;}
	
	public CSATSupportRogers() {
		try {
			toShowPanel = true;
			surveyObj = new Survey__c();
			if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id') != '') {
				surveyObj = [SELECT Id, Name, SurveyType__c, Responded__c, Response_Date__c, CreatedDate, X7_Survey__c, 
          						X6_Survey__c, X5_Survey__c, X4_Survey__c, X3_Survey_Average__c, X3_4_Survey__c, X3_3_Survey__c, X3_2_Survey__c, 
          						X3_1_Survey__c, X2_Survey__c, X1_Survey__c, Agent_Email__c 
          						FROM Survey__c 
          		WHERE id=:ApexPages.currentPage().getParameters().get('id') limit 1];
          		if(surveyObj != null && (surveyObj.SurveyType__c == 'Support Rogers')) {
          				setResponseValue();
          				if(checkSurveyValidity()  || checkSurveyAlreadyFilled()) {
          					toShowPanel = false; 
          				}	
          		} else {
          			toShowPanel = false;
          			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Survey Type.'));
          		}
          		
       		} else {
       			toShowPanel = false;
     			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Survey Id.'));
     		}
		} catch(Exception ex) {
			toShowPanel = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Survey.'));
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+ex.getLineNumber()));
		}
	}
	
	public boolean checkSurveyAlreadyFilled() {
		try {
			if(surveyObj.Responded__c == 1) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'<b>You have already filled this survey.</b>'));
				return true;
			}
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
		}
		return false;
	}
	
	public Integer noOfDays {get;set;}
	public boolean checkSurveyValidity() {
		try {
			Long totalHrsDiff = DateTime.now().getTime() - surveyObj.CreatedDate.getTime();
			noOfDays = Integer.valueOf(totalHrsDiff/(1000 * 60 * 24 * 60));   //Returns the number of milliseconds since January 1, 1970, 00:00:00 GMT
			if(noOfDays > 7) {
				if(surveyObj.SurveyType__c == 'Support Rogers') {
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'<b>This link has expired. If you need any help, '+ 
															'please contact "General Support" at "(888) 898-4591".</b>'));
		
				} 
				return true;
			}
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
		}
		return false;
	}
	        						
    public string answer1 {get;set;}
	public string answer2 {get;set;}
	public string answer31 {get;set;}
	public string answer32 {get;set;}
	public string answer33 {get;set;}
	public string answer34 {get;set;}
	public string answer5 {get;set;}      						
	
	public void setResponseValue() {								// For Showing Preview.
		try {
			if(surveyObj.X1_Survey__c != null) {
				answer1 = String.valueOf(surveyObj.X1_Survey__c);
			} 
			if(surveyObj.X2_Survey__c != null) {
				answer2 = String.valueOf(surveyObj.X2_Survey__c);
			}
			if(surveyObj.X3_1_Survey__c != null) {
				answer31 = String.valueOf(surveyObj.X3_1_Survey__c);
			}
			//if(surveyObj.X3_2_Survey__c != null) {
				//answer32 = String.valueOf(surveyObj.X3_2_Survey__c);
			//}
			/*if(surveyObj.X3_3_Survey__c != null) {
				answer33 = String.valueOf(surveyObj.X3_3_Survey__c);
			}*/
			if(surveyObj.X3_4_Survey__c != null) {
				answer34 = String.valueOf(surveyObj.X3_4_Survey__c);
			}
			if(surveyObj.X5_Survey__c != null) {
				answer5 = String.valueOf(surveyObj.X5_Survey__c);
			}
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
		}
	}
	
	public PageReference save() {
    	try {
    		
    		if(answer31 == NUll || answer34 == NULL || answer1 == NULL || answer2 == NULL  || surveyObj.X4_Survey__c == NULL ||
    			answer5 == NULL) { 
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b><span style="color:Red;font-size: 12px;">*</span> Please '+ 
    											'fill all the mandatory questions.</b>'));
				  return null;	
    		} 
    		if(surveyObj.X7_Survey__c != null && surveyObj.X7_Survey__c != '' && (surveyObj.X7_Survey__c).length() > 2000) {
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b>Please enter upto only 2000 characters on Comment field.</b>'));
				return null;	
    		}
    		
    		surveyObj.X1_Survey__c = Decimal.valueOf(answer1);
    		surveyObj.X2_Survey__c = Decimal.valueOf(answer2);
    		surveyObj.X3_1_Survey__c = Decimal.valueOf(answer31);
    		//surveyObj.X3_2_Survey__c = Decimal.valueOf(answer32);
    		//surveyObj.X3_3_Survey__c = Decimal.valueOf(answer33);
    		surveyObj.X3_4_Survey__c = Decimal.valueOf(answer34);
    		surveyObj.X5_Survey__c = Decimal.valueOf(answer5);
    		surveyObj.X3_Survey_Average__c = Double.valueof((surveyObj.X3_1_Survey__c + surveyObj.X3_4_Survey__c)/2);
    		surveyObj.Responded__c = 1;
    		surveyObj.Response_Date__c = System.today();
    		update surveyObj;
    		toShowPanel = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'<b>Thank you for filling out our survey.</b>'));
			return ApexPages.currentPage();
    	} catch(Exception ex) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
    		//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+ex.getLineNumber())); 
			return null;
    	}
    	return null;
    }
	
	public List<SelectOption> getValues1() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1.00','1')); 
        options.add(new SelectOption('2.00','2'));  
        options.add(new SelectOption('3.00','3'));
        options.add(new SelectOption('4.00','4'));
        options.add(new SelectOption('5.00','5'));  
        return options; 
    }
    
    public List<SelectOption> getValues2() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }
    
    public List<SelectOption> getValues3() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0.00','0'));  
        options.add(new SelectOption('1.00','1')); 
        options.add(new SelectOption('2.00','2'));  
        options.add(new SelectOption('3.00','3'));
        options.add(new SelectOption('4.00','4'));
        options.add(new SelectOption('5.00','5'));
        options.add(new SelectOption('6.00','6'));  
        options.add(new SelectOption('7.00','7'));  
        options.add(new SelectOption('8.00','8'));  
        options.add(new SelectOption('9.00','9'));  
        options.add(new SelectOption('10.00','10'));    
        return options; 
    }
    
    public List<SelectOption> getValues4() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('None','None')); 
        options.add(new SelectOption('Low','Low')); 
        options.add(new SelectOption('Moderate','Moderate')); 
        options.add(new SelectOption('High','High'));
        options.add(new SelectOption('Very High','Very High'));  
        return options; 
    }
}