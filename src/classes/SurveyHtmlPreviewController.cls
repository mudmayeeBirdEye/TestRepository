public with sharing class SurveyHtmlPreviewController {
	
	public Survey__c surveyObj {get;set;}
	private string surveyId;
	public boolean toShowPanel {get;set;}
	public string outputTextStr {get;set;}
	public string btnTitle {get;set;}
	public string pageDir {get;set;}
	
	public SurveyHtmlPreviewController() {
		try {
			pageDir = 'pagedirection';
			surveyObj = new Survey__c();
			toShowPanel = false;
			if(ApexPages.currentPage().getParameters().get('SurveyId') != null && ApexPages.currentPage().getParameters().get('SurveyId') != '') {
				surveyId = ApexPages.currentPage().getParameters().get('SurveyId');
				surveyObj =  [select Id,SurveyType__c,Contact__r.Name,Name, Who_to_contact__c, Resolution__c, Quality_and_Reliability__c, 
								Print_Printers_Service__c, New_Hire_Process__c, Mobility_cell_phone_Service__c, 
       							Mac_Support_Services__c, Initial_response__c, Email_Outlook_Service__c, Customer_service_attitude__c, 
       							Communicates__c , Responded__c ,Comments__c, Comments_IT_Survey__c ,
       							Q1_Score__c,Q2_Score__c,Q3_Score__c,Q4_Score__c,Q5_Score__c from Survey__c where Id= :surveyId];
				toShowPanel = true;
				btnTitle = 'Submit Your Answers';
				getQuestionAndOption();
			}
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+ex.getLineNumber()));
		}
	}
	
	public List<QuestionOptionWrapper> wrQuesOptionList{get;set;}
	
	public void getQuestionAndOption() {
		try {
			wrQuesOptionList = new List<QuestionOptionWrapper>();
			if(surveyObj.SurveyType__c == 'Rogers Implementation' || surveyObj.SurveyType__c == 'ATT Implementation' 
				|| surveyObj.SurveyType__c == 'Implementation')  {					// SurveyType__c == 'Rogers Implementation'
					outputTextStr = 'Hello '+ (surveyObj != NULL  && surveyObj.Contact__r != NULL ? surveyObj.Contact__r.Name : '') + 
                    '. Thank you for taking the time to fill out our simple survey and helping us learn how to best help you.'+ 
                    '<br/><br/>The questions below pertain to your implementation experience and the Advisor that helped you with that process.<p/>';
       				btnTitle = 'Save';
       				QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					if(surveyObj.SurveyType__c == 'Rogers Implementation') {
						wrQuestionOpObj1.questionStr = '<b> The Implementation Advisor was knowledgeable concerning Rogers products and services.</b>';
					} else if(surveyObj.SurveyType__c == 'ATT Implementation') {
						wrQuestionOpObj1.questionStr = '<b> The Implementation Advisor was knowledgeable concerning Office@Hand products and services.</b>';
					} else if(surveyObj.SurveyType__c == 'Implementation') {
						wrQuestionOpObj1.questionStr = '<b> The Implementation Advisor was knowledgeable concerning RingCentral products and services.</b>';
					}
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuestionOpObj1.answerValue = String.valueOf(surveyObj.Q1_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Implementation Advisor assisted me in setting up the right solution for my business needs.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuestionOpObj2.answerValue = String.valueOf(surveyObj.Q2_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'What is your satisfaction level with the Implementation process?';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Satisfaction Level';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuestionOpObj3.answerValue = String.valueOf(surveyObj.Q3_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'The Implementation Advisor displayed a friendly and helpful attitude towards myself and my company.';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Knowledge';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuestionOpObj4.answerValue = String.valueOf(surveyObj.Q4_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'Comments/What could have we done to serve you better?';
					wrQuestionOpObj5.answerType = 'TextArea';
					wrQuestionOpObj5.answerValue = surveyObj.Comments__c;
					wrQuesOptionList.add(wrQuestionOpObj5); 
			} else if(surveyObj.SurveyType__c == 'Sales') {			// Survey Type == 'Sales'
					outputTextStr = 'Hello ' + (surveyObj != NULL  && surveyObj.Contact__r != NULL ? surveyObj.Contact__r.Name : '') + '. Thank you '+
									'for taking the time to fill out our simple survey and helping us learn how '+ 
									'to best help you.<br/><br/>The questions below pertain to your sales experience and the Sales Agent '+
									'that helped you with that process.<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'The Sales Agent was knowledgeable concerning RingCentral products and services.';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuestionOpObj1.answerValue = String.valueOf(surveyObj.Q1_Score__c);
					//wrQuestionOpObj1.answerValue = '2.00';
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Sales Agent assisted me in selecting the right solution for my business needs.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Right Solution';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuestionOpObj2.answerValue = String.valueOf(surveyObj.Q2_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'What is your satisfaction level with the overall sales process?';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Satisfaction Level';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuestionOpObj3.answerValue = String.valueOf(surveyObj.Q3_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'Comments/What could have we done to serve you better?';
					wrQuestionOpObj5.answerType = 'TextArea';
					wrQuestionOpObj5.answerValue = surveyObj.Comments__c;
					wrQuesOptionList.add(wrQuestionOpObj5); 
			} else if(surveyObj.SurveyType__c=='Support CSAT' || surveyObj.SurveyType__c=='VAR Support CSAT') {  //SurveyType__c=='Support CSAT'
					outputTextStr = 'Thank you for using RingCentral for your communication needs!<br/><br/>Please tell us how we'+  '\'' +'re '+ 
									'doing by answering a few quick questions on your recent service incident.<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'My issue was resolved to my satisfaction:';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuestionOpObj1.answerValue = String.valueOf(surveyObj.Q3_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The agent was very knowledgeable concerning RingCentral' +  '\'' +'s products and services.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Right Solution';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuestionOpObj2.answerValue = String.valueOf(surveyObj.Q1_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'The RingCentral agent displayed a friendly and helpful attitude towards me and my company.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Submission';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuestionOpObj3.answerValue = String.valueOf(surveyObj.Q4_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'How likely is it that you would recommend RingCentral to a friend or colleague?';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Recommendation';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuestionOpObj4.answerValue = String.valueOf(surveyObj.Q5_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'The help I received resolved my issue right away:';
					wrQuestionOpObj5.answerType = 'Radio';
					wrQuestionOpObj5.questionType = 'Satisfaction';
					wrQuestionOpObj5.IsMandatory = true;
					wrQuestionOpObj5.answerValue = String.valueOf(surveyObj.Q2_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj5);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuestionOpObj6.answerValue = surveyObj.Comments__c;
					wrQuesOptionList.add(wrQuestionOpObj6);
			} else if(surveyObj.SurveyType__c=='Support Rogers') {   //SurveyType__c=='Support Rogers'
					outputTextStr = 'Thank you for using Rogers for your communications needs!<br/><br/>Please tell us how we'+'\''+'re doing by '+ 
					'answering a few quick questions on your recent service incident.<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'My issue was resolved to my satisfaction:';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.answerValue = String.valueOf(surveyObj.Q3_Score__c);
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Business Consultant was very knowledgeable concerning Rogers Hosted IP Voice.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Right Solution';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuestionOpObj2.answerValue = String.valueOf(surveyObj.Q1_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'The Business Consultant displayed a friendly and helpful attitude to my needs and my company.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Submission';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuestionOpObj3.answerValue = String.valueOf(surveyObj.Q4_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'How likely is it that you would recommend Rogers to a friend or colleague?';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Recommendation';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuestionOpObj4.answerValue = String.valueOf(surveyObj.Q5_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'The help I received resolved my issue right away:';
					wrQuestionOpObj5.answerType = 'Radio';
					wrQuestionOpObj5.questionType = 'Satisfaction';
					wrQuestionOpObj5.IsMandatory = true;
					wrQuestionOpObj5.answerValue = String.valueOf(surveyObj.Q2_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj5);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuestionOpObj6.answerValue = surveyObj.Comments__c;
					wrQuesOptionList.add(wrQuestionOpObj6); 
			} else if(surveyObj.SurveyType__c =='Porting Phone Support') {   //SurveyType__c =='Porting Phone Support'
					outputTextStr = 'Thank you for using RingCentral for your communication needs!<br/><br/> '+
                      				'Please tell us how we'+'\''+'re doing by answering a few quick questions on your recent service incident. ' +
                					'<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'I am very satisfied with how my Number Transfer queries were addressed .';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuestionOpObj1.answerValue = String.valueOf(surveyObj.Q3_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Number Transfer agent was very knowledgeable concerning my Number Transfer Issues.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuestionOpObj2.answerValue = String.valueOf(surveyObj.Q1_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'The Number Transfer agent displayed a friendly and helpful attitude towards me and my company.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Knowledge';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuestionOpObj3.answerValue = String.valueOf(surveyObj.Q4_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'The Number Transfer agent was able to provide a resolution to my concerns.';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Knowledge';
					wrQuestionOpObj4.answerValue = String.valueOf(surveyObj.Q2_Score__c);
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuestionOpObj6.answerValue = surveyObj.Comments__c;
					wrQuesOptionList.add(wrQuestionOpObj6); 
			} else if(surveyObj.SurveyType__c == 'Saves CSAT') {    //SurveyType__c == 'Saves CSAT'
					outputTextStr = 'Thank you for using RingCentral for your communication needs!<br/><br/> '+
                      				'Please tell us how we'+'\''+'re doing by answering a few quick questions on your recent service incident. ' +
                					'<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'My issue was resolved to my satisfaction';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuestionOpObj1.answerValue = String.valueOf(surveyObj.Q3_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The help I received resolved my issue right away.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuestionOpObj2.answerValue = String.valueOf(surveyObj.Q2_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'The Solutions Specialist displayed a friendly and helpful attitude to my needs.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Knowledge';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuestionOpObj3.answerValue = String.valueOf(surveyObj.Q4_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuestionOpObj6.answerValue = surveyObj.Comments__c;
					wrQuesOptionList.add(wrQuestionOpObj6); 
					
			} else if(surveyObj.SurveyType__c == 'RC - IT Internal Survey') {		//SurveyType__c == 'RC - IT Internal Survey'
					outputTextStr = '<h1>Please provide your feedback and have a Coffee on us!!!!</h1>';
					btnTitle = 'Submit';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = '<b> Overall, I am satisfied with the <u>quality and reliability</u> of services provided by IT.</b>';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'ITValue1';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuestionOpObj1.answerValue = String.valueof(surveyObj.Quality_and_Reliability__c);
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = '<b> I know <u>who to contact</u> when I have a technology question or problem.</b>';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'ITValue2';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuestionOpObj2.answerValue =  String.valueOf(surveyObj.Who_to_contact__c);
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = '<b> Please rate IT team’s timeliness of <u>initial response</u> to Help Desk request. (5 being highest)</b>';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'ITValue3';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuestionOpObj3.answerValue = String.valueOf(surveyObj.Initial_response__c);
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = '<b> Please rate IT team’s timeliness of <u>resolution</u> to Help Desk request. (5 being highest).</b>';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'ITValue3';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuestionOpObj4.answerValue = String.valueOf(surveyObj.Resolution__c);
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = '<b> IT staff is courteous and demonstrates <u>customer service attitude</u>.</b>';
					wrQuestionOpObj5.answerType = 'Radio';
					wrQuestionOpObj5.questionType = 'ITValue2';
					wrQuestionOpObj5.IsMandatory = true;
					wrQuestionOpObj5.answerValue = String.valueOf(surveyObj.Customer_service_attitude__c);
					wrQuesOptionList.add(wrQuestionOpObj5);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = '<b> IT team <u>communicates</u> the service downtime/change windows timely and effectively.</b>';
					wrQuestionOpObj6.answerType = 'Radio';
					wrQuestionOpObj6.questionType = 'ITValue2';
					wrQuestionOpObj6.IsMandatory = true;
					wrQuestionOpObj6.answerValue = String.valueOf(surveyObj.Communicates__c);
					wrQuesOptionList.add(wrQuestionOpObj6);
					
					QuestionOptionWrapper wrQuestionOpObj7 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj7.questionStr = '<b> Overall, I am satisfied with <u>New Hire Process</u> at RingCentral.</b>';
					wrQuestionOpObj7.answerType = 'Radio';
					wrQuestionOpObj7.questionType = 'ITValue1';
					wrQuestionOpObj7.answerValue = String.valueOf(surveyObj.New_Hire_Process__c);
					wrQuestionOpObj7.IsMandatory = true;
					
					wrQuesOptionList.add(wrQuestionOpObj7);
					
					QuestionOptionWrapper wrQuestionOpObj8 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj8.questionStr = '<b> Overall, I am satisfied with <u>Mac Support/Services</u>.</b>';
					wrQuestionOpObj8.answerType = 'Radio';
					wrQuestionOpObj8.questionType = 'ITValue1';
					wrQuestionOpObj8.IsMandatory = true;
					wrQuestionOpObj8.answerValue = String.valueOf(surveyObj.Mac_Support_Services__c);
					wrQuesOptionList.add(wrQuestionOpObj8);
					
					QuestionOptionWrapper wrQuestionOpObj9 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj9.questionStr = '<b> Overall, I am satisfied with <u>Email/Outlook</u> Service.</b>';
					wrQuestionOpObj9.answerType = 'Radio';
					wrQuestionOpObj9.questionType = 'ITValue1';
					wrQuestionOpObj9.IsMandatory = true;
					wrQuestionOpObj9.answerValue = String.valueOf(surveyObj.Email_Outlook_Service__c);
					wrQuesOptionList.add(wrQuestionOpObj9);
					
					QuestionOptionWrapper wrQuestionOpObj10 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj10.questionStr = '<b> Overall, I am satisfied with <u>Print/Printers</u> Service.</b>';
					wrQuestionOpObj10.answerType = 'Radio';
					wrQuestionOpObj10.questionType = 'ITValue1';
					wrQuestionOpObj10.IsMandatory = true;
					wrQuestionOpObj10.answerValue = String.valueOf(surveyObj.Print_Printers_Service__c);
					wrQuesOptionList.add(wrQuestionOpObj10);
					
					QuestionOptionWrapper wrQuestionOpObj11 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj11.questionStr = '<b> Overall, I am satisfied with <u>mobility (cell phone)</u> Service.</b>';
					wrQuestionOpObj11.answerType = 'Radio';
					wrQuestionOpObj11.questionType = 'ITValue1';
					wrQuestionOpObj11.IsMandatory = true;
					wrQuestionOpObj11.answerValue = String.valueOf(surveyObj.Mobility_cell_phone_Service__c) ;
					wrQuesOptionList.add(wrQuestionOpObj11);
					
					QuestionOptionWrapper wrQuestionOpObj12 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj12.questionStr = '<b> Please enter any additional comments you may have about your level of satisfaction with IT services.</b>';
					wrQuestionOpObj12.answerType = 'TextArea';
					wrQuestionOpObj12.answerValue = surveyObj.Comments_IT_Survey__c;
					wrQuesOptionList.add(wrQuestionOpObj12); 
				
			} else if(surveyObj.SurveyType__c == 'Porting') {				//SurveyType__c == 'Porting'
					outputTextStr = 'Hello ' + (surveyObj != NULL  && surveyObj.Contact__r != NULL ? surveyObj.Contact__r.Name : '') +'.<br/><br/>Thank'+ 
					'you for telling us how we are doing by answering these simple questions. '+   
					'The questions below pertain to your experience transferring your phone number(s) to RingCentral..<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'My transfer request was processed and completed in a timely manner.';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuestionOpObj1.answerValue = String.valueOf(surveyObj.Q4_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'My transfer request was processed and completed accurately.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuestionOpObj2.answerValue = String.valueOf(surveyObj.Q4_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'It was easy to submit my transfer request to RingCentral.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Knowledge';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuestionOpObj3.answerValue = String.valueOf(surveyObj.Q4_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'I am completely satisfied with the overall number transfer process.';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Satisfaction Level';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuestionOpObj4.answerValue = String.valueOf(surveyObj.Q4_Score__c);
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments/What could have we done to serve you better?';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuestionOpObj6.answerValue = surveyObj.Comments__c;
					wrQuesOptionList.add(wrQuestionOpObj6); 
			} else {
				toShowPanel = false;
			}
		} catch(Exception ex) {
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+ex.getLineNumber()));
			toShowPanel = false;
		}
	}
	
	
	public class QuestionOptionWrapper {
		public string questionStr {get;set;}
		public string questionType {get;set;}
		public string answerType {get;set;}
		public Boolean IsMandatory  { get;set; }
		Survey__c surveyObj1;
		public string answerValue {get;set;}
		
		public QuestionOptionWrapper(Survey__c SurveyObjParam) {
			surveyObj1 = new Survey__c();
			surveyObj1 = SurveyObjParam;
		}
		
		public List<SelectOption> getValues() {
	    	List<SelectOption> options = new List<SelectOption>(); 
	    	if(questionType == 'Knowledge' || questionType == 'Right Solution' || questionType == 'Submission') {
	    		options.add(new SelectOption('5.00','Strongly Agree')); 
        		options.add(new SelectOption('4.00','Somewhat Agree')); 
        		options.add(new SelectOption('3.00','Neither Agree nor Disagree')); 
        		options.add(new SelectOption('2.00','Somewhat Disagree'));
        		options.add(new SelectOption('1.00','Strongly Disagree')); 
	    	} else if(questionType == 'Satisfaction Level') {
	    		options.add(new SelectOption('5.00','Completely Satisfied')); 
        		options.add(new SelectOption('4.00','Somewhat Satisfied')); 
        		options.add(new SelectOption('3.00','Neutral')); 
        		options.add(new SelectOption('2.00','Somewhat Dissatisfied'));
        		options.add(new SelectOption('1.00','Completely Dissatisfied')); 
	    	} else if(questionType == 'Recommendation') {
	    		options.add(new SelectOption('10.00','10 Extremely Likely')); 
		        options.add(new SelectOption('9.00','9')); 
		        options.add(new SelectOption('8.00','8')); 
		        options.add(new SelectOption('7.00','7'));
		        options.add(new SelectOption('6.00','6')); 
		        options.add(new SelectOption('5.00','5 Neutral')); 
		        options.add(new SelectOption('4.00','4')); 
		        options.add(new SelectOption('3.00','3')); 
		        options.add(new SelectOption('2.00','2'));
		        options.add(new SelectOption('1.00','1')); 
		        options.add(new SelectOption('0.00','0 Extremely Unlikely')); 
	    	} else if(questionType == 'Satisfaction') {
	    		options.add(new SelectOption('1.00','Yes')); 
        		options.add(new SelectOption('0.00','No')); 
	    	} else if(questionType == 'ITValue1') {
	    		options.add(new SelectOption('5','Very satisfied')); 
		        options.add(new SelectOption('4','Somewhat satisfied')); 
		        options.add(new SelectOption('3','Neither satisfied nor dissatisfied')); 
		        options.add(new SelectOption('2','Somewhat dissatisfied'));
		        options.add(new SelectOption('1','Very dissatisfied')); 
	    	} else if(questionType == 'ITValue2') {
	    		options.add(new SelectOption('5','Strongly Agree')); 
		        options.add(new SelectOption('4','Agree')); 
		        options.add(new SelectOption('3','Neutral')); 
		        options.add(new SelectOption('2','Disagree'));
		        options.add(new SelectOption('1','Strongly Disagree')); 
	    	} else if(questionType == 'ITValue3') {
	    		options.add(new SelectOption('5','5')); 
		        options.add(new SelectOption('4','4')); 
		        options.add(new SelectOption('3','3')); 
		        options.add(new SelectOption('2','2'));
		        options.add(new SelectOption('1','1'));
	    	}	
    	return options; 
    	}
	}
}
	
	
	
	
	
	
	/*public void getQuestionAndOption() {
		try {
			wrQuesOptionList = new List<QuestionOptionWrapper>();
			if(surveyObj.SurveyType__c == 'Rogers Implementation') {	// SurveyType__c == 'Rogers Implementation'
					outputTextStr = 'Hello '+ (surveyObj != NULL  && surveyObj.Contact__r != NULL ? surveyObj.Contact__r.Name : '') + 
                    '. Thank you for taking the time to fill out our simple survey and helping us learn how to best help you.'+ 
                    '<br/><br/>The questions below pertain to your implementation experience and the Advisor that helped you with that process.<p/>';
       				btnTitle = 'Save';
       				QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = '<b> The Implementation Advisor was knowledgeable concerning Rogers products and services.</b>';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Implementation Advisor assisted me in setting up the right solution for my business needs.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'What is your satisfaction level with the Implementation process?';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Satisfaction Level';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'The Implementation Advisor displayed a friendly and helpful attitude towards myself and my company.';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Knowledge';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'Comments/What could have we done to serve you better?';
					wrQuestionOpObj5.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj5); 
			} else if(surveyObj.SurveyType__c == 'ATT Implementation') {	//SurveyType__c == 'ATT Implementation'
				outputTextStr = 'Hello '+ (surveyObj != NULL  && surveyObj.Contact__r != NULL ? surveyObj.Contact__r.Name : '') + 
                    '. Thank you for taking the time to fill out our simple survey and helping us learn how to best help you.'+ 
                    '<br/><br/>The questions below pertain to your implementation experience and the Advisor that helped you with that process.<p/>';
       				btnTitle = 'Save';
       				QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = '<b> The Implementation Advisor was knowledgeable concerning Office@Hand products and services.</b>';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Implementation Advisor assisted me in setting up the right solution for my business needs.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'What is your satisfaction level with the Implementation process?';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Satisfaction Level';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'The Implementation Advisor displayed a friendly and helpful attitude towards myself and my company.';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Knowledge';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'Comments/What could have we done to serve you better?';
					wrQuestionOpObj5.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj5);
			} else if(surveyObj.SurveyType__c == 'Implementation') {	//SurveyType__c == 'Implementation'
				outputTextStr = 'Hello '+ (surveyObj != NULL  && surveyObj.Contact__r != NULL ? surveyObj.Contact__r.Name : '') + 
                    '. Thank you for taking the time to fill out our simple survey and helping us learn how to best help you.'+ 
                    '<br/><br/>The questions below pertain to your implementation experience and the Advisor that helped you with that process.<p/>';
       				btnTitle = 'Save';
       				QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = '<b> The Implementation Advisor was knowledgeable concerning RingCentral products and services.</b>';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Implementation Advisor assisted me in setting up the right solution for my business needs.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'What is your satisfaction level with the Implementation process?';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Satisfaction Level';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'The Implementation Advisor displayed a friendly and helpful attitude towards myself and my company.';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Knowledge';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'Comments/What could have we done to serve you better?';
					wrQuestionOpObj5.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj5);
			}else if(surveyObj.SurveyType__c == 'Sales') {			// Survey Type == 'Sales'
					outputTextStr = 'Hello ' + (surveyObj != NULL  && surveyObj.Contact__r != NULL ? surveyObj.Contact__r.Name : '') + '. Thank you'+
									'for taking the time to fill out our simple survey and helping us learn how '+ 
									'to best help you.<br/><br/>The questions below pertain to your sales experience and the Sales Agent '+
									'that helped you with that process.<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'The Sales Agent was knowledgeable concerning RingCentral products and services.';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Sales Agent assisted me in selecting the right solution for my business needs.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Right Solution';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'What is your satisfaction level with the overall sales process?';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Satisfaction Level';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'Comments/What could have we done to serve you better?';
					wrQuestionOpObj5.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj5); 
			} else if(surveyObj.SurveyType__c=='Support CSAT') {  //SurveyType__c=='Support CSAT'
					outputTextStr = 'Thank you for using RingCentral for your communication needs!<br/><br/>Please tell us how we'+  '\'' +'re '+ 
									'doing by answering a few quick questions on your recent service incident.<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'My issue was resolved to my satisfaction:';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The agent was very knowledgeable concerning RingCentral' +  '\'' +'s products and services.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Right Solution';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'The RingCentral agent displayed a friendly and helpful attitude towards me and my company.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Submission';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'How likely is it that you would recommend RingCentral to a friend or colleague?';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Recommendation';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'The help I received resolved my issue right away:';
					wrQuestionOpObj5.answerType = 'Radio';
					wrQuestionOpObj5.questionType = 'Satisfaction';
					wrQuestionOpObj5.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj5);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj6);
			} else if(surveyObj.SurveyType__c=='VAR Support CSAT') {  //SurveyType__c=='VAR Support CSAT'
					outputTextStr = 'Thank you for using RingCentral for your communication needs!<br/><br/>Please tell us how we'+  '\'' +'re '+ 
									'doing by answering a few quick questions on your recent service incident.<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'My issue was resolved to my satisfaction:';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The agent was very knowledgeable concerning RingCentral' +  '\'' +'s products and services.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Right Solution';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'The RingCentral agent displayed a friendly and helpful attitude towards me and my company.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Submission';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'How likely is it that you would recommend RingCentral to a friend or colleague?';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Recommendation';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'The help I received resolved my issue right away:';
					wrQuestionOpObj5.answerType = 'Radio';
					wrQuestionOpObj5.questionType = 'Satisfaction';
					wrQuestionOpObj5.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj5);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj6);  		  
			} else if(surveyObj.SurveyType__c=='Support Rogers') {   //SurveyType__c=='Support Rogers'
					outputTextStr = 'Thank you for using Rogers for your communications needs!<br/><br/>Please tell us how we'+'\''+'re doing by '+ 
					'answering a few quick questions on your recent service incident.<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'My issue was resolved to my satisfaction:';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Business Consultant was very knowledgeable concerning Rogers Hosted IP Voice.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Right Solution';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'The Business Consultant displayed a friendly and helpful attitude to my needs and my company.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Submission';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'How likely is it that you would recommend Rogers to a friend or colleague?';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Recommendation';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = 'The help I received resolved my issue right away:';
					wrQuestionOpObj5.answerType = 'Radio';
					wrQuestionOpObj5.questionType = 'Satisfaction';
					wrQuestionOpObj5.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj5);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj6); 
			} else if(surveyObj.SurveyType__c =='Porting Phone Support') {   //SurveyType__c =='Porting Phone Support'
					outputTextStr = 'Thank you for using RingCentral for your communication needs!<br/><br/> '+
                      				'Please tell us how we'+'\''+'re doing by answering a few quick questions on your recent service incident. ' +
                					'<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'I am very satisfied with how my Number Transfer queries were addressed .';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The Number Transfer agent was very knowledgeable concerning my Number Transfer Issues.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'The Number Transfer agent displayed a friendly and helpful attitude towards me and my company.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Knowledge';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'The Number Transfer agent was able to provide a resolution to my concerns.';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Knowledge';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj6); 
			} else if(surveyObj.SurveyType__c == 'Saves CSAT') {    //SurveyType__c == 'Saves CSAT'
					outputTextStr = 'Thank you for using RingCentral for your communication needs!<br/><br/> '+
                      				'Please tell us how we'+'\''+'re doing by answering a few quick questions on your recent service incident. ' +
                					'<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'My issue was resolved to my satisfaction';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'The help I received resolved my issue right away.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'The Solutions Specialist displayed a friendly and helpful attitude to my needs.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Knowledge';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj6); 
					
			} else if(surveyObj.SurveyType__c == 'RC - IT Internal Survey') {		//SurveyType__c == 'RC - IT Internal Survey'
					outputTextStr = '<h1>Please provide your feedback and have a Coffee on us!!!!</h1>';
					btnTitle = 'Submit';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = '<b> Overall, I am satisfied with the <u>quality and reliability</u> of services provided by IT.</b>';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'ITValue1';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = '<b> I know <u>who to contact</u> when I have a technology question or problem.</b>';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'ITValue2';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = '<b> Please rate IT team’s timeliness of <u>initial response</u> to Help Desk request. (5 being highest)</b>';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'ITValue3';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = '<b> Please rate IT team’s timeliness of <u>resolution</u> to Help Desk request. (5 being highest).</b>';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'ITValue3';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj5 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj5.questionStr = '<b> IT staff is courteous and demonstrates <u>customer service attitude</u>.</b>';
					wrQuestionOpObj5.answerType = 'Radio';
					wrQuestionOpObj5.questionType = 'ITValue2';
					wrQuestionOpObj5.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj5);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = '<b> IT team <u>communicates</u> the service downtime/change windows timely and effectively.</b>';
					wrQuestionOpObj6.answerType = 'Radio';
					wrQuestionOpObj6.questionType = 'ITValue2';
					wrQuestionOpObj6.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj6);
					
					QuestionOptionWrapper wrQuestionOpObj7 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj7.questionStr = '<b> Overall, I am satisfied with <u>New Hire Process</u> at RingCentral.</b>';
					wrQuestionOpObj7.answerType = 'Radio';
					wrQuestionOpObj7.questionType = 'ITValue1';
					wrQuestionOpObj7.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj7);
					
					QuestionOptionWrapper wrQuestionOpObj8 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj8.questionStr = '<b> Overall, I am satisfied with <u>Mac Support/Services</u>.</b>';
					wrQuestionOpObj8.answerType = 'Radio';
					wrQuestionOpObj8.questionType = 'ITValue1';
					wrQuestionOpObj8.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj8);
					
					QuestionOptionWrapper wrQuestionOpObj9 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj9.questionStr = '<b> Overall, I am satisfied with <u>Email/Outlook</u> Service.</b>';
					wrQuestionOpObj9.answerType = 'Radio';
					wrQuestionOpObj9.questionType = 'ITValue1';
					wrQuestionOpObj9.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj9);
					
					QuestionOptionWrapper wrQuestionOpObj10 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj10.questionStr = '<b> Overall, I am satisfied with <u>Print/Printers</u> Service.</b>';
					wrQuestionOpObj10.answerType = 'Radio';
					wrQuestionOpObj10.questionType = 'ITValue1';
					wrQuestionOpObj10.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj10);
					
					QuestionOptionWrapper wrQuestionOpObj11 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj11.questionStr = '<b> Overall, I am satisfied with <u>mobility (cell phone)</u> Service.</b>';
					wrQuestionOpObj11.answerType = 'Radio';
					wrQuestionOpObj11.questionType = 'ITValue1';
					wrQuestionOpObj11.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj11);
					
					QuestionOptionWrapper wrQuestionOpObj12 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj12.questionStr = '<b> Please enter any additional comments you may have about your level of satisfaction with IT services.</b>';
					wrQuestionOpObj12.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj12); 
				
			} else if(surveyObj.SurveyType__c == 'Porting') {				//SurveyType__c == 'Porting'
					outputTextStr = 'Hello ' + (surveyObj != NULL  && surveyObj.Contact__r != NULL ? surveyObj.Contact__r.Name : '') +'.<br/><br/>Thank'+ 
					'you for telling us how we are doing by answering these simple questions. '+   
					'The questions below pertain to your experience transferring your phone number(s) to RingCentral..<br/><br/>';
					QuestionOptionWrapper wrQuestionOpObj1 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj1.questionStr = 'My transfer request was processed and completed in a timely manner.';
					wrQuestionOpObj1.answerType = 'Radio';
					wrQuestionOpObj1.questionType = 'Knowledge';
					wrQuestionOpObj1.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj1);
					
					QuestionOptionWrapper wrQuestionOpObj2 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj2.questionStr = 'My transfer request was processed and completed accurately.';
					wrQuestionOpObj2.answerType = 'Radio';
					wrQuestionOpObj2.questionType = 'Knowledge';
					wrQuestionOpObj2.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj2);
					
					QuestionOptionWrapper wrQuestionOpObj3 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj3.questionStr = 'It was easy to submit my transfer request to RingCentral.';
					wrQuestionOpObj3.answerType = 'Radio';
					wrQuestionOpObj3.questionType = 'Knowledge';
					wrQuestionOpObj3.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj3);
					
					QuestionOptionWrapper wrQuestionOpObj4 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj4.questionStr = 'I am completely satisfied with the overall number transfer process.';
					wrQuestionOpObj4.answerType = 'Radio';
					wrQuestionOpObj4.questionType = 'Satisfaction Level';
					wrQuestionOpObj4.IsMandatory = true;
					wrQuesOptionList.add(wrQuestionOpObj4);
					
					QuestionOptionWrapper wrQuestionOpObj6 = new QuestionOptionWrapper(surveyObj);
					wrQuestionOpObj6.questionStr = 'Comments/What could have we done to serve you better?';
					wrQuestionOpObj6.answerType = 'TextArea';
					wrQuesOptionList.add(wrQuestionOpObj6); 
			} else {
				toShowPanel = false;
			}
		} catch(Exception ex) {
			toShowPanel = false;
		}
	}*/