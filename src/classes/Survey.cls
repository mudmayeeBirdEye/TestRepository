/*************************************************
Survey class
Along with SalesCSat.page and SEcSat.page used in public sites allows customers to fill in cSat surveys
There are Sales and Implementations Surveys. When created the customer is emailed a link to survey.page with survey record Id.
Find survey record and records answers entered through page.
/************************************************/

public class Survey {
        
    private final Survey__c s;
    private final Contact c;
    private final Opportunity o;
    private final Account a;    
    PageReference pageRef = new PageReference('http://www.ringcentral.com');
    public Boolean submitted = false;
    public Boolean allAnswered = false;  
    Integer q1Value = Null;
    Integer q2Value = Null;
    Integer q3Value = Null;
    Integer q4Value = Null;       
    String comment;
    
    public String repEmail { get; set; }
    public Boolean alreadyFilled {get;set;}
    public Boolean IsFilled {get;set;}
    
    /*
    Take Id from URL and finds survey record. If record's fields(answers) are not blank then show them on page 
    */
    public Survey() {
            try{
                s = [SELECT Id,Name,Q1_Score__c,Q2_Score__c,Q3_Score__c,Q4_Score__c,Average_Score__c,Comments__c,SurveyType__c,Account__c,
                			Contact__c,Opportunity__c,Agent__c,Responded__c,Response_Date__c, Agent_Email__c
                	FROM Survey__c 
                	WHERE id=:ApexPages.currentPage().getParameters().get('id')];
                
                repEmail = s.Agent_Email__c;
                 	
                c = [SELECT Id,Name,Email FROM Contact WHERE id=:s.Contact__c];
                
                if(s.Q1_Score__c != Null){
                    q1Value = s.Q1_Score__c.intValue();
                }
                if(s.Q2_Score__c != Null){
                    q2Value = s.Q2_Score__c.intValue();
                }
                if(s.Q3_Score__c != Null){
                    q3Value = s.Q3_Score__c.intValue(); 
                }
                if(s.Q4_Score__c != Null){
                    q4Value = s.Q4_Score__c.intValue(); 
                }        

                comment = s.Comments__c;
                
                 if(s.SurveyType__c=='Sales'){
			                if(s.Q1_Score__c != NULL && s.Q2_Score__c != NULL && s.Q3_Score__c != NULL){
			                    alreadyFilled = true;
							  }
						 }else if(s.SurveyType__c=='Implementation'){
			                if(s.Q1_Score__c != NULL && s.Q2_Score__c != NULL && s.Q3_Score__c != NULL && s.Q4_Score__c != NULL){
			                    alreadyFilled = true;
			                }
				         }else if(s.SurveyType__c=='ATT Implementation'){
			                if(s.Q1_Score__c != NULL && s.Q2_Score__c != NULL && s.Q3_Score__c != NULL && s.Q4_Score__c != NULL){
			                    alreadyFilled = true;
			                }
				}
            }
            catch(Exception e)  {
             	if( e.getMessage().contains('List has no rows for assignment to SObject'))  
            		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Required parameters are missing.'));           
             }
        
    }
    
    public Boolean getAnswered(){
        if(allAnswered == false && submitted == true){
            return true;
        }
        return false;
    }
           
    public Boolean getIsEmpty() {
       if(s != null){ 
	        if(s.SurveyType__c=='Sales'){
	                if(q1Value == NULL || q2Value == NULL || q3Value == NULL){
	                    return true;
	                }
	        }
	        else if(s.SurveyType__c=='Implementation'){
	                if(q1Value == NULL || q2Value == NULL || q3Value == NULL || q4Value == NULL){
	                    return true;
	                }
	        }else if(s.SurveyType__c=='ATT Implementation'){
	                if(q1Value == NULL || q2Value == NULL || q3Value == NULL || q4Value == NULL){
	                    return true;
	                }
	        }
       }
        return false;
    }
   
   /* public Boolean getIsFilled() {
        if(s.SurveyType__c=='Sales'){
                if(s.Q1_Score__c != NULL && s.Q2_Score__c != NULL && s.Q3_Score__c != NULL){
                    return true;
                }
        }
        else if(s.SurveyType__c=='Implementation'){
                if(s.Q1_Score__c != NULL && s.Q2_Score__c != NULL && s.Q3_Score__c != NULL && s.Q4_Score__c != NULL){
                    return true;
                }
        }else if(s.SurveyType__c=='ATT Implementation'){
                if(s.Q1_Score__c != NULL && s.Q2_Score__c != NULL && s.Q3_Score__c != NULL && s.Q4_Score__c != NULL){
                    return true;
                }
        }
        return false;
    }*/
    
    
    public Boolean getIsFilled(){
    	return IsFilled;
    }
    
    
    public String getComments(){
        return comment;
    }

    public void setComments(String c){
        this.comment = c;
        s.Comments__c = c;
    }
    
    public Integer getQ1Value(){
        return q1Value;
    }

    public void setQ1Value(Integer value){
        this.q1Value = value;
        s.Q1_Score__c = value;
    }
    
    public Integer getQ2Value(){
        return q2Value;
    }

    public void setQ2Value(Integer value){
        this.q2Value = value;
        s.Q2_Score__c = value;
    }
    
    public Integer getQ3Value(){
        return q3Value;
    }

    public void setQ3Value(Integer value){
        this.q3Value = value;
        s.Q3_Score__c = value;
    }        
    
    public Integer getQ4Value(){
        return q4Value;
    }

    public void setQ4Value(Integer value){
        this.q4Value = value;
        s.Q4_Score__c = value;
    }        
           
         
    public List<SelectOption> getValues() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('5','Strongly Agree')); 
        options.add(new SelectOption('4','Somewhat Agree')); 
        options.add(new SelectOption('3','Neither Agree nor Disagree')); 
        options.add(new SelectOption('2','Somewhat Disagree'));
        options.add(new SelectOption('1','Strongly Disagree'));  
        return options; 
    }    

    public List<SelectOption> getValues2() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('5','Completely Satisfied')); 
        options.add(new SelectOption('4','Somewhat Satisfied')); 
        options.add(new SelectOption('3','Neutral')); 
        options.add(new SelectOption('2','Somewhat Dissatisfied'));
        options.add(new SelectOption('1','Completely Dissatisfied'));  
        return options; 
    }    

    public Survey__c getSurvey() {
            return s;
    }
        
        /*
        Validate and save entered answers to survey record.
        Set responded fields and calculate average score based on type of survey.
        */
    public PageReference save() {
          submitted = true;
        if(s.SurveyType__c=='Sales'){
                        if(s.Q1_Score__c == NULL || s.Q2_Score__c == NULL || s.Q3_Score__c == NULL ){
                                allAnswered = false;
                    return ApexPages.currentPage();
                }
                        allAnswered = true;
                        IsFilled = true;
                        s.Responded__c = 1;
                        s.Response_Date__c = Date.today();
                s.Average_Score__c = (s.Q1_Score__c + s.Q2_Score__c + s.Q3_Score__c) / 3;
        }
        else if(s.SurveyType__c=='Implementation'){
                if(s.Q1_Score__c == NULL || s.Q2_Score__c == NULL || s.Q3_Score__c == NULL || s.Q4_Score__c == NULL){
                    allAnswered = false;
                    return ApexPages.currentPage();
                }               
                allAnswered = true;
                  IsFilled = true;
                        s.Responded__c = 1;
                        s.Response_Date__c = Date.today();              
                        s.Average_Score__c = (s.Q1_Score__c + s.Q2_Score__c + s.Q3_Score__c + s.Q4_Score__c) / 4;
        }else if(s.SurveyType__c=='ATT Implementation'){
                if(s.Q1_Score__c == NULL || s.Q2_Score__c == NULL || s.Q3_Score__c == NULL || s.Q4_Score__c == NULL){
                    allAnswered = false;
                    return ApexPages.currentPage();
                }               
                allAnswered = true;
                  IsFilled = true;
                        s.Responded__c = 1;
                        s.Response_Date__c = Date.today();              
                        s.Average_Score__c = (s.Q1_Score__c + s.Q2_Score__c + s.Q3_Score__c + s.Q4_Score__c) / 4;
        }

        s.Comments__c = comment;
        update s;
        return ApexPages.currentPage();
    }
    
    public string getContactName(){
        return c.name;
    }
    
  /*  static testMethod void testSurveyController() {
        //PageReference pageRef = Page.SalesCSat;
        //Test.setCurrentPage(pageRef);
        
        //Survey sur = new Survey();
                //String nextPage = sur.save().getUrl();
                
                // Verify that page fails without parameters
                //System.assertEquals('/apex/failure?error=noParam', nextPage);
                
                // Add parameters to page URL
            try {
           		Survey__c  surveyObj = (Survey__c)SmartFactory.createSObject('Survey__c', true);
           		upsert surveyObj;
                ApexPages.currentPage().getParameters().put('id', ''+surveyObj.Id);
                
                // Instantiate a new controller with all parameters in the page
                Survey sur = new Survey();
                sur.setQ1Value(3);
                sur.setQ2Value(2);
                sur.setQ3Value(4);
                sur.setQ4Value(5);
                sur.setComments('these are my comments');
                
                System.assertEquals(3, sur.getQ1Value());
                System.assertEquals(2, sur.getQ2Value());
                System.assertEquals(4, sur.getQ3Value());
                System.assertEquals(5, sur.getQ4Value());
                System.assertEquals('these are my comments', sur.getComments());
                
                Boolean a = sur.getIsEmpty();
                Boolean b = sur.getIsFilled();
                List<SelectOption> l1 = sur.getValues();
                List<SelectOption> l2 = sur.getValues2();
                
                sur.save();
                } catch(Exception e) {}                     
                //nextPage = controller.save().getUrl();
                // Verify that the success page displays
                //System.assertEquals('/apex/success', nextPage);
                //Lead[] leads = [select id, email from lead where Company = 'acme'];
                //System.assertEquals('firstlast@acme.com', leads[0].email);
    }    */
}