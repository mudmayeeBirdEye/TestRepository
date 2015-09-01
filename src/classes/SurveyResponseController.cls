public with sharing class SurveyResponseController {
	
	public map<string,string> questionAnswerMap {get;set;}
	public SurveyUserJunction__c surveyResponseObj {get;set;}
	public ApexPages.StandardController controller {get;set;}
	public SurveyResponseController(ApexPages.StandardController controller) { 
		surveyResponseObj = new SurveyUserJunction__c();
		this.controller = controller;
		questionAnswerMap = new map<string,string>();
		if(controller.getId() != null) {
			getAnswerDetails();
		}
	}
	
	public void getAnswerDetails() {
		try {
    		surveyResponseObj = [Select User_Email__c, Survey_Details__c, QuestionAnswered__c, 
    							LastModifiedDate From SurveyUserJunction__c where Id = :controller.getId()];
			if(surveyResponseObj != null && surveyResponseObj.QuestionAnswered__c !=null && surveyResponseObj.QuestionAnswered__c !='') {
				getQuestionAnswerResponse(surveyResponseObj.QuestionAnswered__c);				
			}	
    	} catch(Exception ex) { 
    		
    	}
	}
	
	Set<String> questionIdSet = new Set<String>();
	
	public void getQuestionAnswerResponse(string questionAnswer) {
		questionAnswerMap = new map<string,string>();
		List<string> questionSplit = questionAnswer.split('#@#'); 
		System.Debug('>>>##>>'+questionSplit);
        if(questionSplit != null && questionSplit.size()>0) {
        	List<string> questionSplit1 = new List<string>();
        	for(string strObj : questionSplit) {
				List<string> tempList =  strObj.split('-@-');
				for(string str : tempList) {
					questionSplit1.add(str);
				}
			} 
			System.Debug('>>>:::>>'+questionSplit1);
			for(Integer i=0;i<questionSplit1.size();i++) {
				//string questionId = '\'' +questionSplit1[i].trim()+ '\'';
				String currentId = questionSplit1[i];
				if(currentId.length() > 15) 
					currentId = currentId.substring(0, currentId.length()-4);
				questionIdSet.add(currentId);
				//string strQuestionId = '\'' +questionSplit1[i].trim()+ '\'';
				//string strQption = '\'' +questionSplit1[++i]+ '\'';
				questionAnswerMap.put(questionSplit1[i].trim(),questionSplit1[++i]);
			}
			getQuestionAnswerMasterDetails();
      	}	
	}
	
	public List<WrapperQuestionList> wQesList{get;set;}
	public void getQuestionAnswerMasterDetails() {
		wQesList = new List<WrapperQuestionList>();
		if(questionIdSet != null && questionIdSet.size()>0) {
			System.Debug('>>>>123>>'+questionIdSet);
			System.Debug('>>>>1234>>'+questionAnswerMap);
			map<Id,QuestionAndAnswers__c> mapQuestionAnswer = new map<Id,QuestionAndAnswers__c>([select Id,Subject__c,Answers__c,Option_Type__c 
															from QuestionAndAnswers__c 
															WHERE Id IN :questionIdSet]);
			
			/*map<Id,SurveyQuestionJunction__c> mapQuestionJunction = new map<Id,SurveyQuestionJunction__c>([Select Survey_Details__c, 
																			QuestionAndAnswers__c,QuestionAndAnswers__r.Name, 
                                    										QuestionAndAnswers__r.Subject__c, QuestionAndAnswers__r.Option_Type__c, 
                                    										QuestionAndAnswers__r.Answers__c,Position__c,
                                    										IsMandatory__c
                                   											From SurveyQuestionJunction__c 
																			where QuestionAndAnswers__c IN : questionIdSet and 
																			Survey_Details__c = :surveyResponseObj.Survey_Details__c 
																			order by Position__c asc]);*/
			
			
			if(mapQuestionAnswer != null && mapQuestionAnswer.size()>0) {
				for(QuestionAndAnswers__c surveyQuesTionObj : mapQuestionAnswer.values()) { 
                    List<String> ans = new List<String>();
                    string questionAnswerTemp;
                    if(surveyQuesTionObj.Answers__c != null && surveyQuesTionObj.Answers__c != '' ) {
	                        ans = surveyQuesTionObj.Answers__c.split(';');
                    }
                    boolean isMandatory;// = mapQuestionJunction.get(surveyQuesTionObj.Id).IsMandatory__c;
                    questionAnswerTemp = questionAnswerMap.get(String.valueOf(surveyQuesTionObj.Id));
                    String[] theCheckBoxValue1 = new String[]{};
                    if(surveyQuesTionObj.Option_Type__c == 'Checkbox') {
                    	string strCheckboxValue = questionAnswerTemp.substring(2,questionAnswerTemp.length()-1);
                    	System.debug('>>>#21'+strCheckboxValue);
                    	List<string> strList = strCheckboxValue.split(',');
                    	Integer i = 0;
                    	for(string strObj : strList) {
                    		/*if(i == 0) {
                    			theCheckBoxValue1.add(strObj.substring(2, strObj.length()));
                    		}
                    		else if(i == strList.size()-1) {
                    			theCheckBoxValue1.add(strObj.substring(1, strObj.length()-1));
                    		}
                    		else {
                    			theCheckBoxValue1.add(strObj);
                    		}
                    		i++;*/
                    		theCheckBoxValue1.add(strObj);
                    	}
            		}
                    WrapperQuestionList obj = new WrapperQuestionList(surveyQuesTionObj, ans,questionAnswerTemp,isMandatory,theCheckBoxValue1); 
                    wQesList.add(obj);	
	        	}
			}
		}
 	}
	
	public class WrapperQuestionList {
        public QuestionAndAnswers__c questionsObj {get;set;} 
        public List<String> answers{get;set;}
        public string questionAnswer {get;set;}
        public Boolean IsMandatory  { get;set; }
        public String[] theCheckBoxValue = new String[]{};
        
        public WrapperQuestionList (QuestionAndAnswers__c questionsObj1, List<String> answers1,string questionAnswer1,boolean isMandatory1,String[] theCheckBoxValue1) {
                questionsObj = questionsObj1;
                if(answers1 == null)
                    answers1 = new List<String>();
                answers = answers1;
                if(questionAnswer1 == null) {
                	questionAnswer1 = '';
                }
                questionAnswer = questionAnswer1.trim();
                IsMandatory = isMandatory1;
                if(theCheckBoxValue1 != null && theCheckBoxValue1.size()>0) {
                	System.Debug('>>Inner>>'+theCheckBoxValue1);
                	//theCheckBoxValue = theCheckBoxValue1;
                	for(string str : theCheckBoxValue1) {
                		//System.Debug('>>>Inner1>'+str);
                		theCheckBoxValue.add(str.trim());
                	}
                }
        }
        
        public List<SelectOption> getValues() {
	    	List<SelectOption> options = new List<SelectOption>(); 
	    	for(String temp: answers) {
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