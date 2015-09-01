public  class SaveCSATSurveyController {
	
    private final Survey__c surveyObj;
    private final Contact contactObj;
    private final Opportunity oppObj;
    private final Account accountObj;    
    
    PageReference pageRef = new PageReference('http://www.ringcentral.com');
    
    public Boolean submitted = false;
    public Boolean allAnswered = false;  
    Boolean commentLength1 = false;
    
    Integer q1Value = Null;
    Integer q2Value = Null;
    Integer q3Value = Null;
    Integer q4Value = Null;   
    Integer q5Value = Null;   
            
    String comment;
    

    public Boolean getCommentLength() {
       if(comment!=NULL){
       {
        if(comment.length()>2000){
            commentLength1=true;
            return commentLength1;
        }
     }
    } return commentLength1; }  
    
    
 
    
    /*
    Take Id from URL and finds survey record. If record's fields(answers) are not blank then show them on page 
    */
    public SaveCSATSurveyController() {
      try{
          surveyObj = [SELECT Id,Name,Q1_Score__c,Q2_Score__c,Q3_Score__c,Q4_Score__c,Q5_Score__c,Average_Score__c,Comments__c,SurveyType__c,Account__c,Contact__c,Opportunity__c,Agent__c,Responded__c,Response_Date__c  FROM Survey__c WHERE id=:ApexPages.currentPage().getParameters().get('id')];
          if(surveyObj != null) {
          	 if(surveyObj.Contact__c != null) {
	            contactObj = [SELECT Id,Name,Email FROM Contact WHERE id=:surveyObj.Contact__c];
          	   }
	          if(surveyObj.Q2_Score__c != Null){
	              q2Value = surveyObj.Q2_Score__c.intValue();
	          }
	          if(surveyObj.Q3_Score__c != Null){
	              q3Value = surveyObj.Q3_Score__c.intValue(); 
	          }
	          if(surveyObj.Q4_Score__c != Null){
	              q4Value = surveyObj.Q4_Score__c.intValue(); 
	          }        
	          comment = surveyObj.Comments__c;
	        }
       }
      catch(Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Survey Not Exists'));
       }
     }
    
    
    
    public Boolean getAnswered(){
        if(allAnswered == false && submitted == true){
            return true;
        }
        return false;
    }
           
    public Boolean getIsEmpty() {
      if(surveyObj.SurveyType__c=='Saves CSAT'){
         if( surveyObj.Q2_Score__c == NULL || surveyObj.Q3_Score__c == NULL || surveyObj.Q4_Score__c == NULL ){
              return true;
          }
          if(comment!=null && comment!='' && comment.length()>2000){
              return true;
          }
        }
        return false;
      }
    
    
    
    public Boolean getIsFilled() {
        if(surveyObj.SurveyType__c=='Saves CSAT'){
          if( surveyObj.Q2_Score__c != NULL && surveyObj.Q3_Score__c != NULL && surveyObj.Q4_Score__c != NULL  && (comment == NULL || comment.length() < 2000)){
               return true;
          }
        }
        return false;
      }
    
    public String getComments(){
        return comment;
    }

    public void setComments(String c){
        this.comment = c;
        if(comment.length()<2000){
            surveyObj.Comments__c = c;
        }
    }
    
    public Integer getQ1Value(){
        return q1Value;
    }

    public void setQ1Value(Integer value){
        this.q1Value = value;
        surveyObj.Q1_Score__c = value;
    }
    
    public Integer getQ2Value(){
        return q2Value;
    }

    public void setQ2Value(Integer value){
        this.q2Value = value;
        surveyObj.Q2_Score__c = value;
    }
    
    public Integer getQ3Value(){
        return q3Value;
    }

    public void setQ3Value(Integer value){
        this.q3Value = value;
        surveyObj.Q3_Score__c = value;
    }        
    
    public Integer getQ4Value(){
        return q4Value;
    }

    public void setQ4Value(Integer value){
        this.q4Value = value;
        surveyObj.Q4_Score__c = value;
    }        
        
         public Integer getQ5Value(){
        return q5Value;
    }

    public void setQ5Value(Integer value){
        this.q5Value = value;
        surveyObj.Q5_Score__c = value;
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
    
    public Survey__c getSurvey() {
            return surveyObj;
    }
  
  /*
  Validate and save entered answers to survey record. Set responded fields and calculate average score based on type of survey.
  */
  
    public PageReference save() {
    	try {
	        submitted = true;
	        allAnswered = true;
	        if(surveyObj.SurveyType__c=='Saves CSAT'){
	        if( surveyObj.Q2_Score__c == NULL || surveyObj.Q3_Score__c == NULL || surveyObj.Q4_Score__c == NULL ){
	         allAnswered = false;
	         return ApexPages.currentPage();
	        }
	        if(comment.length()> 2000){
	          allAnswered = true;
	          return ApexPages.currentPage();
	        }
		    surveyObj.Comments__c = comment;
		    surveyObj.Responded__c = 1;
		    surveyObj.Response_Date__c = Date.today();
		    surveyObj.Average_Score__c = surveyObj.Q3_Score__c;
	      }
	      update surveyObj;
       }
       catch(DMLException ex) {}
       return ApexPages.currentPage();
     }
    
    
    public string getContactName(){
        return contactObj.name;
    }
    
 /*Test Method START*/   
 
    /*static testMethod void testSurveyController() {
    // Add parameters to page URL
  	 Survey__c surObj = new Survey__c();
  	 surObj.Contact__c = [Select Id, Name From Contact Limit 1].id;	
  	 surObj.SurveyType__c='Saves CSAT';
  	 insert surObj;
  	 
  	 ApexPages.currentPage().getParameters().put('id',surObj.id);
    
	// Instantiate a new controller with all parameters in the page
   SaveCSATSurveyController sur = new SaveCSATSurveyController();
   sur.comment='test';
   sur.save();
   
   sur.setQ1Value(3);
   sur.setQ2Value(2);
   sur.setQ3Value(4);
   sur.setQ4Value(4);
   sur.setQ5Value(4);
   sur.getQ1Value();
   sur.getQ2Value();
   sur.getQ3Value();
   sur.getQ4Value();
   sur.getQ5Value();
   sur.getValues();
   sur.getContactName();
   sur.getAnswered();
   sur.getCommentLength();
   sur.getComments();
   sur.getIsEmpty();
   sur.getIsFilled();
   sur.setComments('test111');
   sur.save(); 
   sur.comment ='';
    for(Integer i=0; i<101;i++) {
    	sur.comment+='testtesttesttesttest';
    }
     sur.getCommentLength();
  
     sur.save(); 
    sur.getSurvey();  
    
    Survey__c sur1 = new Survey__c();
    sur1.Q2_Score__c = 1;
    sur1.Q3_Score__c = 3;
    sur1.Q4_Score__c = 4;
    sur1.Comments__c = 'test';
    insert sur1 ;
    
    
    ApexPages.currentPage().getParameters().put('id',sur1 .id);
    SaveCSATSurveyController surC1 = new SaveCSATSurveyController();
    
    surC1.allAnswered =true;
    surC1.submitted = false;
    surc1.getAnswered();
    
    
    ApexPages.currentPage().getParameters().put('id','111111111111111');
    SaveCSATSurveyController surC2 = new SaveCSATSurveyController();
    
    Survey__c sur2 = new Survey__c();
    sur2.SurveyType__c = 'Saves CSAT';
   
    insert sur2 ;
    ApexPages.currentPage().getParameters().put('id',sur2.id);
     SaveCSATSurveyController surC3 = new SaveCSATSurveyController();
     surC3.comment ='';
     for(Integer i=0; i<101;i++) {
    	surC3.comment+='testtesttesttesttest';
     }
     surC3.getIsEmpty();
     
    Survey__c sur3 = new Survey__c();
    sur3.SurveyType__c = 'Saves CSAT';
    sur3.Q2_Score__c = 1;
    sur3.Q3_Score__c = 3;
    sur3.Q4_Score__c = 4;
    insert sur3 ;
    ApexPages.currentPage().getParameters().put('id',sur3.id);
     
     SaveCSATSurveyController surC4 = new SaveCSATSurveyController();
     surC4.comment ='';
     for(Integer i=0; i<101;i++) {
    	surC4.comment+='testtesttesttesttest';
     }
     surC4.getIsEmpty();
     
     Survey__c sur4 = new Survey__c();
      insert sur4;
      
     ApexPages.currentPage().getParameters().put('id',sur4.id);
     SaveCSATSurveyController surC5 = new SaveCSATSurveyController();
     surC5.getIsFilled();
     
        
  } */ 
 /*END*/   
}