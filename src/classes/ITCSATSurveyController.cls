public with sharing class ITCSATSurveyController {
	
	public boolean toShowPanel {get;set;}
	public Survey__c surveyObj {get;set;}
	
	public ITCSATSurveyController() {
		try {
			toShowPanel = true;
			surveyObj = new Survey__c();
			if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id') != '') {
				surveyObj = [SELECT Id, Name, SurveyType__c, Responded__c, Response_Date__c, CreatedDate,Agent_Email__c,
								Timely_ITHelpdesk__c, Resolution_ITHelpdesk__c, Quality_ITHelpdesk__c, Knowledge_ITHelpdesk__c, 
								Informed_ITHelpdesk__c, Comments_ITHelpdesk__c, Average_ITHelpdesk__c, Attitude_ITHelpdesk__c 
          						FROM Survey__c 
          		WHERE id=:ApexPages.currentPage().getParameters().get('id') limit 1];
          		if(surveyObj != null && (surveyObj.SurveyType__c == 'IT Helpdesk CSAT')) {
          				setResponseValue();
          				if(checkSurveyAlreadyFilled()) {
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
	
	public void setResponseValue() {								// For Showing Preview.
		try {
			if(surveyObj.Knowledge_ITHelpdesk__c != null) {
				answer1 = String.valueOf(surveyObj.Knowledge_ITHelpdesk__c); 
			} 
			if(surveyObj.Attitude_ITHelpdesk__c != null) {
				answer2 = String.valueOf(surveyObj.Attitude_ITHelpdesk__c);
			}
			if(surveyObj.Informed_ITHelpdesk__c != null) {
				answer3 = String.valueOf(surveyObj.Informed_ITHelpdesk__c);
			}
			if(surveyObj.Resolution_ITHelpdesk__c != null) {
				answer4 = String.valueOf(surveyObj.Resolution_ITHelpdesk__c);
			}
			if(surveyObj.Timely_ITHelpdesk__c != null) {
				answer5 = String.valueOf(surveyObj.Timely_ITHelpdesk__c);
			}
			if(surveyObj.Quality_ITHelpdesk__c != null) {
				answer6 = String.valueOf(surveyObj.Quality_ITHelpdesk__c);
			}
			if(surveyObj.Comments_ITHelpdesk__c != null) {
				answer7 = String.valueOf(surveyObj.Comments_ITHelpdesk__c);
			}
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
		}
	}
	
	
	public string answer1 {get;set;}
	public string answer2 {get;set;}
	public string answer3 {get;set;}
	public string answer4 {get;set;}
	public string answer5 {get;set;}
	public string answer6 {get;set;}
	public string answer7 {get;set;}
	
	public List<SelectOption> getValues1() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1.00',' ')); 
        options.add(new SelectOption('2.00',' ')); 
        options.add(new SelectOption('3.00',' ')); 
        options.add(new SelectOption('4.00',' '));
        options.add(new SelectOption('5.00',' '));  
        return options; 
    }
    
    public PageReference save() {
    	try {
    		
    		if(answer1 == NULL || answer2 == NULL  || answer3 == NULL || answer4 == NULL || answer5 == NULL ||
    			answer6 == NULL) { 
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b><span style="color:Red;font-size: 12px;">*</span> Please '+ 
    											'fill all the mandatory questions.</b>'));
				  return null;	
    		} 
    		if(answer7 != null && answer7 != '' && (answer7).length() > 2000) {
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b>Please enter upto only 2000 characters on Comment field.</b>'));
				return null;	
    		}
    		
    		surveyObj.Knowledge_ITHelpdesk__c = Decimal.valueOf(answer1);
    		surveyObj.Attitude_ITHelpdesk__c = Decimal.valueOf(answer2);
    		surveyObj.Informed_ITHelpdesk__c = Decimal.valueOf(answer3);
    		surveyObj.Resolution_ITHelpdesk__c = Decimal.valueOf(answer4);
    		surveyObj.Timely_ITHelpdesk__c = Decimal.valueOf(answer5);
    		surveyObj.Quality_ITHelpdesk__c = Decimal.valueOf(answer6);
    		surveyObj.Comments_ITHelpdesk__c = answer7;
    		surveyObj.Average_ITHelpdesk__c = Double.valueof((surveyObj.Knowledge_ITHelpdesk__c + surveyObj.Attitude_ITHelpdesk__c
    											+ surveyObj.Informed_ITHelpdesk__c + surveyObj.Resolution_ITHelpdesk__c 
    											+ surveyObj.Timely_ITHelpdesk__c + surveyObj.Quality_ITHelpdesk__c)/6);
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
    
   /* @isTest
    static void itcsatSurveyTest() {
    	Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.RecordTypeId  = '01280000000UERq';
        insert acctest; 
        
        Contact contObj = new Contact();
	    contObj.AccountId =  acctest.Id;
	    contObj.Email = 'test@test.com';
	    contObj.LastName = 'Test Last1';
	    contObj.FirstName = 'Test First1';
      	insert contObj;
	      	
    	Survey__c surveyObj1 = new Survey__c();
    	surveyObj1.SurveyType__c = 'IT Helpdesk CSAT';
    	surveyObj1.Name = 'Test Impl';
    	surveyObj1.Contact__c = contObj.Id;
    	surveyObj1.Contact_Email__c = 'test@test.com';
    	insert surveyObj1;
    	
    	Survey__c surveyObj2 = new Survey__c();
    	surveyObj2.SurveyType__c = 'IT Helpdesk CSAT';
    	surveyObj2.Name = 'Test Impl';
    	surveyObj2.Contact__c = contObj.Id;
    	surveyObj2.Contact_Email__c = 'test@test.com';
    	insert surveyObj2;
    	
    	Test.startTest();
    	
    	ITCSATSurveyController itcsatsurvey2 = new ITCSATSurveyController();
	    ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        ITCSATSurveyController itcsatsurvey1 = new ITCSATSurveyController();
        itcsatsurvey1.getValues1();
        itcsatsurvey1.save();
        itcsatsurvey1.answer1 = '1.00';
        itcsatsurvey1.answer2 = '2.00';
        itcsatsurvey1.answer3 = '2.00';
        itcsatsurvey1.answer4 = '2.00';
        itcsatsurvey1.answer5 = '3.00';
        itcsatsurvey1.answer6 = '3.00';
        itcsatsurvey1.answer7 = 'Test';
        itcsatsurvey1.save();
        itcsatsurvey1.setResponseValue();
        itcsatsurvey1.checkSurveyAlreadyFilled();
        new ITCSATSurveyController();
        ApexPages.currentPage().getParameters().put('id', surveyObj2.id);
        ITCSATSurveyController itcsatsurvey3 = new ITCSATSurveyController();
        
        Test.stopTest();
    }*/
}