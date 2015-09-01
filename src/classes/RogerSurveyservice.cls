/*************************************************
Survey class
Along with SupportCSATSurvey.page and SupportCSATSurvey.page used in public sites allows customers to fill in CSAT surveys
There are Support CSAT Surveys. When created the customer is emailed a link to survey.page with survey record Id.
Find survey record and records answers entered through page.
/************************************************/

public class RogerSurveyservice{

public Boolean commentLength = false;

   public Boolean getCommentLength() {
       return commentLength;
       }  
 
 
 
    private final Survey__c s;
    private final Contact c;
    private final Opportunity o;
    private final Account a;    
    PageReference pageRef = new PageReference('http://www.ringcentral.com');
    public Boolean submitted = false;
    public Boolean allAnswered = false;
    public Boolean surveyExist = false;
   // public Boolean CommentLength = false;  
    Integer q1Value = Null;
    Integer q2Value = Null;
    Integer q3Value = Null;
    Integer q4Value = Null;   
    Integer q5Value = Null;           
    String comment;
 //  public Boolean isSubmit{get;set;}
    
    
    /*
    Take Id from URL and finds survey record. If record's fields(answers) are not blank then show them on page 
    */
    public RogerSurveyservice() {
      try{
          s = [SELECT Id,Name,Q1_Score__c,Q2_Score__c,Q3_Score__c,Q4_Score__c,
          Q5_Score__c,Average_Score__c,Comments__c,SurveyType__c,Account__c,Contact__c,
          Opportunity__c,Agent__c,Responded__c,Response_Date__c  FROM Survey__c WHERE id=:ApexPages.currentPage().getParameters().get('id')];
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
       /*if(s.Q5_Score__c != Null){
              q5Value = s.Q5_Score__c.intValue(); 
          }  */
          comment = s.Comments__c;
      }
      catch(Exception e)
        {
            surveyExist= true;
        }
        
    }
    
    public Boolean getSurveyExist(){
        return surveyExist;
    }
    
    public Boolean getAnswered(){
        if(allAnswered == false && submitted == true){
            return true;
        }
               return false;
    }
           
    public Boolean getIsEmpty() {
      if(s.SurveyType__c=='Rogers Implementation'){
          //if(q1Value == NULL || q2Value == NULL || q3Value == NULL || q4Value == NULL ){
         if(s.Q1_Score__c == NULL || s.Q2_Score__c == NULL || s.Q3_Score__c == NULL || s.Q4_Score__c == NULL 
         /*|| s.Q5_Score__c == NULL*/
         ){
             
              return true;
          }
          if(comment!=null && comment!='' && comment.length()>2000){
         
            return true;
          }
          
          
      }
    
        return false;
    }
    
    
    
    public Boolean getIsFilled() {
        if(s.SurveyType__c=='Rogers Implementation'){
                  if(s.Q1_Score__c != NULL && s.Q2_Score__c != NULL && s.Q3_Score__c != NULL && s.Q4_Score__c != NULL && 
          /*s.Q5_Score__c != NULL && */ 
             (comment == NULL|| comment ==''|| comment.length() < 2000)){
                  
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
            s.Comments__c = c;
        }
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
        
    /*  public Integer getQ5Value(){
        return q5Value;
    }

    public void setQ5Value(Integer value){
        this.q5Value = value;
        s.Q5_Score__c = value;
    }   */   
         
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
       /* options.add(new SelectOption('10','10 Extremely Likely')); 
        options.add(new SelectOption('9','9')); 
        options.add(new SelectOption('8','8')); 
        options.add(new SelectOption('7','7'));
        options.add(new SelectOption('6','6')); 
        
        options.add(new SelectOption('5','5 Neutral')); 
        options.add(new SelectOption('4','4')); 
        options.add(new SelectOption('3','3')); 
        options.add(new SelectOption('2','2'));
        options.add(new SelectOption('1','1')); 
        options.add(new SelectOption('0','0 Extremely Unlikely')); */
        
        options.add(new SelectOption('5','Strongly Agree')); 
        options.add(new SelectOption('4','Somewhat Agree')); 
        options.add(new SelectOption('3','Neither Agree nor Disagree')); 
        options.add(new SelectOption('2','Somewhat Disagree'));
        options.add(new SelectOption('1','Strongly Disagree')); 
            
        return options; 
    }    
    
     public List<SelectOption> getValues3() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1','Yes')); 
        options.add(new SelectOption('0','No')); 
        
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
      if(s.SurveyType__c=='Rogers Implementation'){
      if(s.Q1_Score__c == NULL || s.Q2_Score__c == NULL || s.Q3_Score__c == NULL || s.Q4_Score__c == NULL 
     /* ||  s.Q5_Score__c == NULL*/ 
      ){
         allAnswered = false;
         return ApexPages.currentPage();
       }
       if(comment.length()>2000){
          allAnswered = true;
          commentLength = true;
          return ApexPages.currentPage();
       }
    
        s.Comments__c = comment;
     
          
      commentLength = false;   
      allAnswered = true;
      s.Responded__c = 1;
      s.Response_Date__c = Date.today();
      s.Average_Score__c = s.Q3_Score__c;
    //  s.Average_Score__c = (s.Q1_Score__c + s.Q2_Score__c + s.Q3_Score__c + s.Q4_Score__c+s.Q5_Score__c) / 5;
        }
        else if(s.SurveyType__c=='Rogers Implementation'){
          if(s.Q1_Score__c == NULL || s.Q2_Score__c == NULL || s.Q3_Score__c == NULL || s.Q4_Score__c == NULL 
          /*||  s.Q5_Score__c == NULL*/
          ){
              allAnswered = false;
              return ApexPages.currentPage();
          }            
      allAnswered = true;
      s.Responded__c = 1;
      s.Response_Date__c = Date.today(); 
      s.Average_Score__c = s.Q3_Score__c;         
   //   s.Average_Score__c = (s.Q1_Score__c + s.Q2_Score__c + s.Q3_Score__c + s.Q4_Score__c+s.Q5_Score__c) / 5;
        }

              
        update s;
        return ApexPages.currentPage();
    }
    
   
   
    public string getContactName(){
        return c.name;
    }
    
 /*static testMethod void testSurveyController() {
        //PageReference pageRef = Page.SalesCSat;
        
        //Test.setCurrentPage(pageRef);
        
        //Survey sur = new Survey();
    //String nextPage = sur.save().getUrl();
    
    // Verify that page fails without parameters
    //System.assertEquals('/apex/failure?error=noParam', nextPage);
    
    // Add parameters to page URL
    
   // Account acc = new Account();
    
    //upsert acc;
    
    Contact con = [Select id,name from Contact limit 1];
    //con.Name ='test';
   // con.Email = 'test@test.com';
   //con.AccountID = acc.id;
   //upsert con;
    
    Survey__c sr = new Survey__c();
    sr.Contact__c = con.id;
    upsert sr;
    
    system.Test.setCurrentPageReference(new PageReference('Page.SupportRogersImplementationSurvey'));
    ApexPages.currentPage().getParameters().put('id', sr.id);
    
    
    
    // Instantiate a new controller with all parameters in the page
   
    
    RogerSurveyservice rc = new RogerSurveyservice();   
    
    rc.getCommentLength(); 
    rc.getAnswered();
    rc.getIsFilled(); 
    rc.getIsEmpty();
    rc.getComments();
    rc.setComments('Hello Testing');
    rc.getQ1Value();
    rc.setQ1Value(1);
    rc.getQ2Value();
    rc.setQ2Value(2);
    rc.getQ3Value();
    rc.setQ3Value(2);
    rc.getQ4Value();
    rc.setQ4Value(2);
    
   //rc.getQ5Value();
   //rc.setQ5Value(1);
    rc.getValues();
    rc.getValues2();
    rc.getValues3();
    rc.getSurvey();
    rc.save();
    rc.getContactName();

    
    
       
    //nextPage = controller.save().getUrl();
    // Verify that the success page displays
    //System.assertEquals('/apex/success', nextPage);
    //Lead[] leads = [select id, email from lead where Company = 'acme'];
    //System.assertEquals('firstlast@acme.com', leads[0].email);
    }  */  
}