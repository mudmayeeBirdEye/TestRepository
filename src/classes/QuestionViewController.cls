public with sharing class QuestionViewController {
	 
	 public ApexPages.StandardController controller {get;set;}
	 public QuestionAndAnswers__c questionObj {get;set;}
	 public boolean toShowAnswer {get;set;}
	 public  List<string> answerOption {get;set;}
	 //public static String Bullet_CHAR {get;set;}
	 
	 private static final String Bullet_CHAR = '&#149;';
     
     public String getBulletChar() {
        return Bullet_CHAR;
     }
	
	
	 public QuestionViewController(ApexPages.StandardController controller) {
	 	try {
	 		//Bullet_CHAR = '&#x25B4;';
	 		this.controller = controller;
	 		if(controller.getId() != null) {
	 			questionObj = new QuestionAndAnswers__c();
	 			questionObj = [select Subject__c, Option_Type__c, Answers__c from QuestionAndAnswers__c where Id = :controller.getId()];
	 			system.Debug('>>1>>'+questionObj.Option_Type__c);
	 			if(questionObj.Option_Type__c == 'Checkbox' || questionObj.Option_Type__c == 'Radio') {
	 				system.Debug('>>2>>'+questionObj.Answers__c);
	 				if(questionObj.Answers__c != null) {
	 					answerOption = new List<string>();
	 					answerOption = questionObj.Answers__c.trim().split(';');
	 					//for(string str : answerOption1) {
	 						//answerOption.add(str);
	 					//}
	 					system.Debug('>>#@!'+answerOption);
	 				}
	 			}
	 		}
	 	} catch(exception ex) {
	 		
	 	}
	 }
	 
	 public PageReference returnToBackPage() {
	 	if(ApexPages.currentPage().getParameters().get('rturl') != null && 
	 		ApexPages.currentPage().getParameters().get('rturl') != '' &&
	 		ApexPages.currentPage().getParameters().get('returnPageName') != null &&
	 		ApexPages.currentPage().getParameters().get('returnPageName') != '') {
		 		string returnUrl = ApexPages.currentPage().getParameters().get('rturl');
		 		string returnPageName = ApexPages.currentPage().getParameters().get('returnPageName');
		 		PageReference pf = new PageReference('/apex/'+returnPageName+'?Id='+returnUrl);
		 		pf.setRedirect(true);
		 		return pf;	
	 	}
	 	return null;
	 } 
	
}