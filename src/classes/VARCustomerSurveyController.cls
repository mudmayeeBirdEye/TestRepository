public class VARCustomerSurveyController {
	public boolean toShowPanel {get;set;}
	public Survey__c surveyObj {get;set;}
	public boolean toshowDealerExpQues {get;set;}
	
	public VARCustomerSurveyController() { 
		try {
			toShowPanel = true;
			toshowDealerExpQues = false;
			surveyObj = new Survey__c();
			if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id') != '') {
				surveyObj = [SELECT Id, Name, SurveyType__c, Responded__c, Response_Date__c, CreatedDate, X7_Survey__c, 
          						Q1_Score__c, Q2_Score__c,Q5_Score__c,Q3_Score__c,
          						Dealer_Experience__c ,Agent_Email__c, Contact__r.Name, Comments__c,satisfaction__c ,IsDealerImplementSurvice__c
          						FROM Survey__c 
          		WHERE id=:ApexPages.currentPage().getParameters().get('id') limit 1];
          		if(surveyObj != null && (surveyObj.SurveyType__c == 'VAR Customer')) {
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
	
	public PageReference showdealerExpCall() {
		if(answer32 == 'Yes') {
			toshowDealerExpQues = true;
		} else {
			toshowDealerExpQues = false;
		}
		return null;
	}
	        						
    public string answer1 {get;set;}
	public string answer2 {get;set;}
	public string answer31 {get;set;}
	public string answer32 {get;set;}
	public string answer33 {get;set;}
	public string answer5 {get;set;}      						
	
	public void setResponseValue() {								// For Showing Preview.
		try {
			if(surveyObj.Q1_Score__c != null) {
				answer1 = String.valueOf(surveyObj.Q1_Score__c);
			} 
			if(surveyObj.Q2_Score__c != null) {
				answer2 = String.valueOf(surveyObj.Q2_Score__c);
			}
			if(surveyObj.satisfaction__c != null) {
				answer31 = String.valueOf(surveyObj.satisfaction__c);
			}
			if(surveyObj.IsDealerImplementSurvice__c != null) {
				answer32 = String.valueOf(surveyObj.IsDealerImplementSurvice__c);
				if(answer32 == 'Yes') {
					toshowDealerExpQues = true;
				}
			}
			if(surveyObj.Dealer_Experience__c != null) {
				answer33 = String.valueOf(surveyObj.Dealer_Experience__c);
			}
			if(surveyObj.Q5_Score__c != null) {
				answer5 = String.valueOf(surveyObj.Q5_Score__c);
			}
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
		}
	}
	
	public PageReference save() {
    	try {
    		
    		if(answer31 == NUll || answer1 == NULL || answer2 == NULL  || answer32 == NULL || 
    			answer5 == NULL) { 
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b><span style="color:Red;font-size: 12px;">*</span> Please '+ 
    											'fill all the mandatory questions.</b>'));
				  return null;	
    		}
    		if(answer32 != NULL && answer32 =='Yes' && answer33 == NULL) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b><span style="color:Red;font-size: 12px;">*</span> Please '+ 
    											'fill experience with the RingCentral Dealer.</b>'));
				  return null;	
    		} 
    		if(surveyObj.Comments__c != null && surveyObj.Comments__c != '' && (surveyObj.Comments__c).length() > 2000) {
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b>Please enter upto only 2000 characters on Comment field.</b>'));
				return null;	
    		}
    		surveyObj.Q1_Score__c = Decimal.ValueOf(answer1);
    		surveyObj.Q2_Score__c = Decimal.ValueOf(answer2);
    		surveyObj.satisfaction__c = Decimal.ValueOf(answer31);
    		surveyObj.Q3_Score__c = surveyObj.satisfaction__c;
    		surveyObj.IsDealerImplementSurvice__c = answer32;
    		if(!String.IsBlank(answer32) && answer32 == 'Yes') {
    			surveyObj.Dealer_Experience__c = answer33;
    		} else if(!String.IsBlank(answer32) && answer32 == 'No') {
    			surveyObj.Dealer_Experience__c = '';
    		}
    		surveyObj.Q5_Score__c = Decimal.valueOf(answer5);
    		surveyObj.Average_Score__c = (surveyObj.Q1_Score__c + surveyObj.Q2_Score__c + surveyObj.satisfaction__c) / 3;
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
        options.add(new SelectOption('5.00','Completely Satisfied')); 
        options.add(new SelectOption('4.00','Somewhat Satisfied')); 
        options.add(new SelectOption('3.00','Neutral')); 
        options.add(new SelectOption('2.00','Somewhat Dissatisfied'));
        options.add(new SelectOption('1.00','Completely Dissatisfied'));  
        return options; 
    }
    
    public List<SelectOption> getValues5() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5.00','Strongly Agree')); 
        options.add(new SelectOption('4.00','Somewhat Agree'));  
        options.add(new SelectOption('3.00','Neither Agree nor Disagree')); 
        options.add(new SelectOption('2.00','Somewhat Disagree')); 
        options.add(new SelectOption('1.00','Strongly Disagree')); 
        return options; 
    }
    
   /* @isTest
    public static void varSurveyTest() {
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
    	surveyObj1.SurveyType__c = 'VAR Customer';
    	surveyObj1.Name = 'Test Impl';
    	surveyObj1.Contact__c = contObj.Id;
    	surveyObj1.Contact_Email__c = 'test@test.com';
    	insert surveyObj1;
    	
    	Survey__c surveyObj2 = new Survey__c();
    	surveyObj2.SurveyType__c = 'Sales1';
    	surveyObj2.Name = 'Test Impl';
    	surveyObj2.Contact__c = contObj.Id;
    	surveyObj2.Contact_Email__c = 'test@test.com';
    	insert surveyObj2;
    	
    	Test.startTest();
    	
    	VARCustomerSurveyController csatsurvey2 = new VARCustomerSurveyController();
	    ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        VARCustomerSurveyController csatsurvey1 = new VARCustomerSurveyController();
        csatsurvey1.getValues1();
        csatsurvey1.getValues2();
        csatsurvey1.getValues3();
        csatsurvey1.getValues4();
        csatsurvey1.getValues5();
        csatsurvey1.save();
        csatsurvey1.answer1 = '1.00';
        csatsurvey1.answer2 = '2.00';
        csatsurvey1.answer31 = '2.00';
        csatsurvey1.answer32 = 'Yes';
        csatsurvey1.showdealerExpCall();
        csatsurvey1.answer33 = '3.00';
        //csatsurvey1.answer34 = '3.00';
        //csatsurvey1.surveyObj.X4_Survey__c = 'Yes';
        csatsurvey1.answer5 = '3.00';
        csatsurvey1.surveyObj.Comments__c = 'Test Comment';
        csatsurvey1.save();
        csatsurvey1.setResponseValue();
        csatsurvey1.checkSurveyAlreadyFilled();
        new VARCustomerSurveyController();
        ApexPages.currentPage().getParameters().put('id', surveyObj2.id);
        VARCustomerSurveyController csatsurvey3 = new VARCustomerSurveyController();
        Test.stopTest();
    }  */ 
}