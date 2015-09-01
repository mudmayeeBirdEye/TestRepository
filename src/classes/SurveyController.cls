public class SurveyController {
    public List<SurveyQuestionJunction__c> questionAnswerList {get;set;}
    private String emailid;
    private String uid ;
    private String rid;
    private String exceptionObjId;
    public List<Integer> logoList {get;set;}
    public Integer logoPosition {get;set;}
    public Integer submitButtonPosition {get;set;}
    public boolean toshowErrorOrInfoMsg {get;set;}
    public boolean toshowFilledMsg {get;set;}
    
    public SurveyController () { 
        //emailid = ApexPages.currentPage().getParameters().get('eid');
        //uid = ApexPages.currentPage().getParameters().get('uid');
        //rid = ApexPages.currentPage().getParameters().get('id');
        if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id') != '') {
        	exceptionObjId = ApexPages.currentPage().getParameters().get('id');
        	getSurveyDetails();
        	checkAlreadyFilled();
        	questionUI();
        	isFilled = false;
        	logoList = new List<Integer>();
        	for(Integer i=0;i<3;i++) {
            	Integer a = 1; 
            	logoList.add(a++);
        	}
        } else {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Id.'));
        }
   }
   
   public void getSurveyDetails() {
   		try {
   			List<Exception_And_Notification_History__c> emailNotificationList = [select Id, To_Address_1__c,content_label_01__c,Unique_Servey_No__c,
   																				content_label_02__c 
   																				from Exception_And_Notification_History__c 
   																				where Id=:exceptionObjId];
   			if(emailNotificationList != null && emailNotificationList.size()>0) {
   				emailid = emailNotificationList[0].To_Address_1__c;
        		uid = emailNotificationList[0].Unique_Servey_No__c;
        		rid = emailNotificationList[0].content_label_01__c;
   			}																	
   		} catch(Exception ex) {
   			
   		}
   }
    
   public boolean isAlreadyfilled { get; set;}
    
   public void checkAlreadyFilled() {
        isAlreadyfilled = false;
        if(emailid != null && uid != null){ 
        Integer i = [SELECT COUNT() FROM SurveyUserJunction__c WHERE User_Email__c =: emailid AND Unique_Servey_No__c =: uid 
        			AND Survey_Details__c =:  rid LIMIT 1];
            if( i > 0){
                isAlreadyfilled = true;
                isFilled = true;
            }                   
        }
        //return null;
    }
    
    Map<Id,QuestionAndAnswers__c> quesAnswerMap;
    Map<id,Boolean> isMandatoryMap ;
    Set<Id> existingQuestionId = new Set<Id>();

    public List<QuestionAndAnswers__c> questionsSet{get;set;}
    public List<WrapperQuestionList> wQesList{get;set;}
    
    public void questionUI() {
            
     isMandatoryMap = new Map<id,Boolean>();
        if(questionsSet == null) {
            questionsSet = new List<QuestionAndAnswers__c>();
            wQesList = new List<WrapperQuestionList>();
        }
        
        questionAnswerList = [SELECT  Survey_Details__c, IsMandatory__c, Survey_Details__r.Title__c, QuestionAndAnswers__c, QuestionAndAnswers__r.Name, 
								QuestionAndAnswers__r.Subject__c, QuestionAndAnswers__r.Option_Type__c, QuestionAndAnswers__r.Answers__c, 
								Logo_Position__c, Submit_Button_Position__c From SurveyQuestionJunction__c Where Survey_Details__c = :rid 
                                order by Position__c asc];
            
            for( SurveyQuestionJunction__c surveyJunObj : questionAnswerList ) {
                existingQuestionId.add( surveyJunObj.QuestionAndAnswers__c );
                isMandatoryMap.put( surveyJunObj.QuestionAndAnswers__c, surveyJunObj.IsMandatory__c );
            }
            
            if(questionAnswerList != null && questionAnswerList.size()>0) {
                if(questionAnswerList[0].Logo_Position__c != null) {
                    logoPosition = Integer.valueOf(questionAnswerList[0].Logo_Position__c); 
                }
                if(questionAnswerList[0].Submit_Button_Position__c != null) {
                    submitButtonPosition = Integer.valueOf(questionAnswerList[0].Submit_Button_Position__c);    
                }
            }
            
            map<Id,QuestionAndAnswers__c> mapQuestionAnswer;
            if(existingQuestionId != null && existingQuestionId.size()>0) {
                mapQuestionAnswer = new map<Id,QuestionAndAnswers__c>([select Subject__c,Answers__c,Option_Type__c from QuestionAndAnswers__c 
                                                WHERE Id IN : existingQuestionId]); 
            }
            
            for(SurveyQuestionJunction__c surveyJunObj : questionAnswerList) {
                if(surveyJunObj.QuestionAndAnswers__c != null) {
                    List<String> ans = new List<String>();
                    if(surveyJunObj.QuestionAndAnswers__r.Answers__c != null && surveyJunObj.QuestionAndAnswers__r.Answers__c != '' ) {
                            ans = surveyJunObj.QuestionAndAnswers__r.Answers__c.split(';');
                    }
                    QuestionAndAnswers__c questionsObj = mapQuestionAnswer.get(surveyJunObj.QuestionAndAnswers__c);
                    WrapperQuestionList obj = new WrapperQuestionList( questionsObj, ans, isMandatoryMap.get( questionsObj.id ) );
                    wQesList.add(obj);  
                }
                //existingQuestionId.add(surveyJunObj.QuestionAndAnswers__c);
            }
    }
  
 /*
 * the Submit action
 */ 
    public Boolean getIsFilled(){
        return isFilled;
    }
    
    public Boolean isFilled ;
    
    public PageReference saveSurvey(){
        String answers ='';
        boolean filled = true;
        for(WrapperQuestionList responses : wQesList){
            if( responses.IsMandatory ){
                     if ( responses.questionsObj.Option_Type__c == 'Text' && ( responses.theTextValue == '' || responses.theTextValue == null ) ) {
                        filled = false;
                     } else  if ( responses.questionsObj.Option_Type__c == 'Radio'  && ( responses.theRadioValue == '' || responses.theRadioValue == null )) {
                        filled = false;
                     } else if ( responses.questionsObj.Option_Type__c == 'Checkbox' &&  responses.getTheCheckBoxValue().size() == 0  ) {
                        filled = false;
                     } else if ( responses.questionsObj.Option_Type__c == 'Textarea' && ( responses.theLongTextValue == '' || responses.theLongTextValue == null )) {
                        filled = false;
                     }
                }
        }   
        if( !filled ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill all the mandatory questions.'));
            toshowErrorOrInfoMsg = true;
            //Apexpages.currentPage().getParameters().put('eid' , emailid);
            //Apexpages.currentPage().getParameters().put('uid' , uid);
            //Apexpages.currentPage().getParameters().put('id' , rid);
            //return Apexpages.currentPage();
            //PageReference retPage = new Pagereference('/rcsurvey/Survey');
            //retPage.getParameters().put('Id',rid);
            //retPage.getParameters().put('uid',uid);
            //retPage.getParameters().put('eid',emailid);
            //retPage.setRedirect(true);
            //return retPage;
        } 
        if( filled ){ 
            //isFilled = true;
            saveResponse( wQesList ); 
            //Apexpages.currentPage().getParameters().put('eid' , emailid);
            //Apexpages.currentPage().getParameters().put('uid' , uid);
            //Apexpages.currentPage().getParameters().put('id' , rid);
            //return Apexpages.currentPage();
            //PageReference retPage = new Pagereference('/rcsurvey/Survey');
            //retPage.getParameters().put('Id',rid);
            //retPage.getParameters().put('uid',uid);
            //retPage.getParameters().put('eid',emailid);
            //retPage.setRedirect(false);
            //return retPage;
        }
        return null;
        //return Apexpages.currentPage();
    }

    
    public void saveResponse(List<WrapperQuestionList> responses){
        try {
        SurveyUserJunction__c suj = new SurveyUserJunction__c();
        suj.QuestionAnswered__c = '';
        
        for( WrapperQuestionList  questionAnswers : responses){
            String temp = '';
                    
                    if ( questionAnswers.questionsObj.Option_Type__c == 'Text' ) {
                        temp = questionAnswers.theTextValue;
                     } else  if ( questionAnswers.questionsObj.Option_Type__c == 'Radio'  ) {
                            temp = questionAnswers.theRadioValue;
                     } else if ( questionAnswers.questionsObj.Option_Type__c == 'Checkbox') {
                            temp = String.valueOf( questionAnswers.theCheckBoxValue );
                     } else if ( questionAnswers.questionsObj.Option_Type__c == 'Textarea') {
                            temp = questionAnswers.theLongTextValue;
                     }
            
            
        suj.QuestionAnswered__c = suj.QuestionAnswered__c + questionAnswers.questionsObj.id + ' -@- ' + temp +'#@#';    
        }
        suj.Survey_Details__c = rid;
        suj.User_Email__c = emailid;
        suj.Unique_Servey_No__c = uid;
        insert suj;
        toshowFilledMsg = true;
        isFilled = true;
        } catch(Exception e) {
            // isFilled = false;
            isFilled = true;
            toshowFilledMsg = false;
            toshowErrorOrInfoMsg = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Thank you for your interest in our survey. Our team will contact you soon.'));
        }
    }

/*
    * WrapperQuestionList class take care of all question and its response.
*/
    public class WrapperQuestionList {
        public QuestionAndAnswers__c questionsObj {get;set;}
        public Boolean IsMandatory  { get;set; }
        public List<String> answers { get; set; }
        public String theRadioValue { get; set; }
        public String[] theCheckBoxValue = new String[]{};
        public String theTextValue { get; set;}
        public String theLongTextValue { get; set;}
        
        public WrapperQuestionList ( QuestionAndAnswers__c questionsObj1, List<String> answers1 , Boolean IsMandatory) {
                questionsObj = questionsObj1;
                if(answers1 == null)
                answers1 = new List<String>();
                answers = answers1;
                this.IsMandatory = IsMandatory;
        }

        /*
        * returns option list accordind to answers type radio/chackbox
        */
        public List<SelectOption> getValues() {
            List<SelectOption> options = new List<SelectOption>(); 
            for(String temp: answers ) {
                 options.add(new SelectOption( temp ,temp)); 
            }   
         return options; 
       }  
       
        public String[] getTheCheckBoxValue() {
            return theCheckBoxValue;
        }
          
        public void setTheCheckBoxValue(String[] theCheckBoxValue) {
            this.theCheckBoxValue = TheCheckBoxValue;
        }
    }
}