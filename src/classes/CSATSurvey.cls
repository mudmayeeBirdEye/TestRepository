public class CSATSurvey {
    /*********************** VARIABLE DECLARATION *********************/
    public boolean toShowPanel {get;set;}
    public Survey__c surveyObj {get;set;}
    public boolean isExpired {get;set;}
    
    public String answer01{get;set;} 
    public String answer011{get;set;}
    public String answer012{get;set;}
    public String answer013{get;set;}
    public String answer014{get;set;}
    
    public string Comment {get;set;}                            
    public string answer1 {get;set;}
    public string answer2 {get;set;}
    public string answer31 {get;set;}
    public string answer32 {get;set;}
    public string answer33 {get;set;}
    public string answer34 {get;set;}
    public string answer4 {get;set;}
    public string answer5 {get;set;}                            
    
    public CSATSurvey() {
        try {
            toShowPanel = true; 
            isExpired= false;
            surveyObj = new Survey__c();
            if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id') != '') {
                surveyObj = [SELECT Id,Comments__c, Name, SurveyType__c, Responded__c, Response_Date__c, CreatedDate, X7_Survey__c, 
                                X6_Survey__c, X5_Survey__c, X4_Survey__c, X3_Survey_Average__c, X3_4_Survey__c, X3_3_Survey__c, X3_2_Survey__c, 
                                X3_1_Survey__c, X2_Survey__c, X1_Survey__c, Agent_Email__c, X4_1_Survey__c,Implementation_Advisor_Communication__c,Case_Number__c,Case_Subject__c,Implementation_Materials_provided__c,
                                Implementation_Advisor_Satisfaction__c,Implementation_Advisor_s_ability__c,Implementation_Experience__c
                                ,Account__r.Number_of_DL_s__c,Account__r.RC_Service_name__c FROM Survey__c 
                WHERE id=:ApexPages.currentPage().getParameters().get('id') limit 1];
                if(surveyObj != null && (surveyObj.SurveyType__c == 'Implementation' || surveyObj.SurveyType__c == 'Support CSAT' || 
                    surveyObj.SurveyType__c == 'Porting' || surveyObj.SurveyType__c == 'VAR Support CSAT' 
                    || surveyObj.SurveyType__c == 'ATT Implementation')) {
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
            isSurveyExpired();
	        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=10'); 
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
            if(noOfDays > 30) {
                if((surveyObj.SurveyType__c == 'Implementation')|| (surveyObj.SurveyType__c == 'ATT Implementation')) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'<b>This link has expired. If you need any help, '+ 
                                                            'please contact "Implementation Advisors"  at "(866) 737-7704".</b>'));
            
                } else if(surveyObj.SurveyType__c == 'Support CSAT' || surveyObj.SurveyType__c == 'VAR Support CSAT') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'<b>This link has expired. If you need any help, '+ 
                                                            'please contact "General Support" at "(888) 898-4591".</b>'));
        
                } else if(surveyObj.SurveyType__c == 'Porting') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'<b>This link has expired. If you need any help, '+ 
                                                            'please contact "Number Transfer Department" at "(866) 738-4405".</b>'));
                }
                return true;
            }
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
        }
        return false;
    }
    
    public void setResponseValue() {                                // For Showing Preview.
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
            if(surveyObj.X3_4_Survey__c != null) {
                answer34 = String.valueOf(surveyObj.X3_4_Survey__c);
            }
            if(surveyObj.X4_1_Survey__c != null) {
                answer4  = String.valueOf(surveyObj.X4_1_Survey__c);
            }
            if(surveyObj.X5_Survey__c != null) {
                answer5 = String.valueOf(surveyObj.X5_Survey__c);
            }
            if(surveyObj.Implementation_Experience__c != null) {
                answer01 = String.valueOf(surveyObj.Implementation_Experience__c);
            }
            if(surveyObj.Implementation_Advisor_Satisfaction__c != null) {
                answer011 = String.valueOf(surveyObj.Implementation_Advisor_Satisfaction__c);
            }
            if(surveyObj.Implementation_Advisor_s_ability__c != null) {
                answer012 = String.valueOf(surveyObj.Implementation_Advisor_s_ability__c);
            }
            if(surveyObj.Implementation_Advisor_Communication__c != null) {
                answer013 = String.valueOf(surveyObj.Implementation_Advisor_Communication__c);
            }
            if(surveyObj.Implementation_Materials_provided__c != null) {
                answer014 = String.valueOf(surveyObj.Implementation_Materials_provided__c);
                System.debug('%%%%%%'+surveyObj.Implementation_Materials_provided__c);
                System.debug('################'+answer014);
            }
             comment = surveyObj.Comments__c;
             system.debug('========>'+comment);
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
        }
    }
    
    public PageReference save() {
        try {
            
            /*if(answer31 == NULL || answer32 == NULL || answer33 == NULL || 
                answer34 == NULL || answer1 == NULL || answer2 == NULL  || surveyObj.X4_Survey__c == NULL ||
                answer5 == NULL  || surveyObj.X6_Survey__c == NULL) { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b><span style="color:Red;font-size: 12px;">*</span> Please '+ 
                                                'fill all the mandatory questions.</b>'));
                  return null;  
            }*/
            /*if((answer011 == NULL||answer012 == NULL||answer013 == NULL||answer014 == NULL)&&(surveyObj.SurveyType__c == 'ATT Implementation')){
            	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b><span style="color:Red;font-size: 12px;">*</span> Please '+ 
                                                'fill all the mandatory questions.</b>'));
                  return null;  
            }else if((answer01 == NULL || answer31 == NULL || answer34 == NULL || answer1 == NULL || answer2 == NULL ||answer5 == NULL )&&(surveyObj.SurveyType__c != 'ATT Implementation')  ||                 //surveyObj.X4_Survey__c == NULL ||
                (answer4 == NULL && surveyObj.SurveyType__c == 'Porting') ||
                     (surveyObj.X4_Survey__c == NULL && surveyObj.SurveyType__c != 'Porting')) { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b><span style="color:Red;font-size: 12px;">*</span> Please '+ 
                                                'fill all the mandatory questions.</b>'));
                  return null;  
            } */
            system.debug('@@@@@@'+(surveyObj.X4_Survey__c == NULL && (surveyObj.SurveyType__c != 'Porting'&& surveyObj.SurveyType__c != 'ATT Implementation')));
            if(((answer31 == NULL || answer34 == NULL || answer1 == NULL || answer2 == NULL ||answer5 == NULL)&&(surveyObj.SurveyType__c != 'ATT Implementation'))  || 				//surveyObj.X4_Survey__c == NULL ||
    			(answer4 == NULL && surveyObj.SurveyType__c == 'Porting') ||((answer011 == NULL||answer012 == NULL||answer013 == NULL||answer014 == NULL)&&(surveyObj.SurveyType__c == 'ATT Implementation'))
    				 || (surveyObj.X4_Survey__c == NULL && (surveyObj.SurveyType__c != 'Porting'&& surveyObj.SurveyType__c != 'ATT Implementation'))) { 
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b><span style="color:Red;font-size: 12px;">*</span> Please '+ 
    											'fill all the mandatory questions.</b>'));
				  return null;	
    		}   
            if(surveyObj.Comments__c != null && surveyObj.Comments__c != '' && (surveyObj.Comments__c).length() > 2000) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'<b>Please enter upto only 2000 characters on Comment field.</b>'));
                return null;    
            }
            if(surveyObj.SurveyType__c == 'ATT Implementation'){
	            surveyObj.Implementation_Advisor_Communication__c = Decimal.valueOf(answer013);
	            surveyObj.Implementation_Advisor_s_ability__c = Decimal.valueOf(answer012);
	            surveyObj.Implementation_Materials_provided__c = Decimal.valueOf(answer014);           
	            surveyObj.Implementation_Advisor_Satisfaction__c = Decimal.valueOf(answer011);
	            
	           // system.debug('-----------222--------'+ Comment);
	           // system.debug('-----------333--------'+surveyObj.Account__r.RC_Service_name__c);
	            if(surveyObj.Account__r.Number_of_DL_s__c != null){
	           		 surveyObj.Snapshot_Number_of_DLs__c = surveyObj.Account__r.Number_of_DL_s__c;   
	            }
	            if(surveyObj.Account__r.RC_Service_name__c != null){       
	            	surveyObj.Snapshot_Service_Name__c = surveyObj.Account__r.RC_Service_name__c; 
	            }
	            //system.debug('-----------222--------'+surveyObj.Account__r.Number_of_DL_s__c);
           		// system.debug('-----------333--------'+surveyObj.Account__r.RC_Service_name__c);
            }
            surveyObj.Comments__c = Comment;
          
            if(surveyObj.SurveyType__c != 'ATT Implementation'){
	            surveyObj.X1_Survey__c = Decimal.valueOf(answer1);
	            surveyObj.X2_Survey__c = Decimal.valueOf(answer2);
	            surveyObj.X3_1_Survey__c = Decimal.valueOf(answer31);
	            surveyObj.X3_4_Survey__c = Decimal.valueOf(answer34);
            }
            if(surveyObj.SurveyType__c == 'Porting') {
                surveyObj.X4_1_Survey__c = Decimal.valueOf(answer4);
            }
            if(surveyObj.SurveyType__c != 'ATT Implementation'){
            	surveyObj.X5_Survey__c = Decimal.valueOf(answer5);
            	surveyObj.X3_Survey_Average__c = Double.valueof((surveyObj.X3_1_Survey__c + surveyObj.X3_4_Survey__c)/2);
            }
            surveyObj.Responded__c = 1;
            surveyObj.Response_Date__c = System.today();
            update surveyObj;
            toShowPanel = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'<b>Thank you for filling out our survey.</b>'));
            return ApexPages.currentPage();
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+ex.getLineNumber())); 
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
    
    public List<SelectOption> getValues1_Porting() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('5.00','5')); 
        options.add(new SelectOption('4.00','4'));  
        options.add(new SelectOption('3.00','3'));
        options.add(new SelectOption('2.00','2'));
        options.add(new SelectOption('1.00','1'));  
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
     
    public List<SelectOption> getValues3_Porting() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('10.00','10'));   
        options.add(new SelectOption('9.00','9')); 
        options.add(new SelectOption('8.00','8'));  
        options.add(new SelectOption('7.00','7'));
        options.add(new SelectOption('6.00','6'));
        options.add(new SelectOption('5.00','5'));
        options.add(new SelectOption('4.00','4'));  
        options.add(new SelectOption('3.00','3'));  
        options.add(new SelectOption('2.00','2'));  
        options.add(new SelectOption('1.00','1'));  
        options.add(new SelectOption('0.00','0'));    
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
   /* public void isSurveyExpired(){
        if((surveyObj.CreatedDate.day() - system.now().day())>=0){
            //surveyObj.Status__c = 'closed';
            isExpired = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'<b>Sorry, Your survey link has been expired.</b>'));
        
        }
     }*/
     
    public void isSurveyExpired(){  
		System.debug('^^^^^^');
        if(surveyObj != null){
        	Date createdDate = surveyObj.CreatedDate.date();
	        Date todaysDate = System.Today();
	        Integer days = createdDate.daysBetween(todaysDate);
	        system.debug('@@@@>>>> days = '+days );
	        if(days >=30 && surveyObj.Responded__c == NULL){
	            //s.Status__c = 'closed';
	            isExpired = true;
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'<b>Sorry, Your survey link has been expired.</b>'));
	        }	
        }
  	}
   	public Boolean getIsEmpty() {
      	if(surveyObj.SurveyType__c == 'ATT Implementation'){
          //if(q1Value == NULL || q2Value == NULL || q3Value == NULL || q4Value == NULL ){
         	if(surveyObj.Implementation_Advisor_Communication__c == NULL || surveyObj.Implementation_Advisor_s_ability__c == NULL || surveyObj.Implementation_Advisor_Satisfaction__c == NULL|| surveyObj.Implementation_Experience__c == NULL || surveyObj.Implementation_Materials_provided__c == NULL
         	/*|| s.Q5_Score__c == NULL*/
         	){return true;}
		}
       	return false;
    }
}