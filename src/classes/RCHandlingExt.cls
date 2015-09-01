public with sharing class RCHandlingExt {
	public Handling_Objection__c RCHandlingObjections{get;set;}
	public String redirectUrl {public get; private set;}
	public RCHandlingExt(ApexPages.StandardController controller){
		try {
			RCHandlingObjections = new Handling_Objection__c();
			RCHandlingObjections = [SELECT id, name, Question_1__c, Answer_1__c, Question_2__c, Answer_2__c, Question_3__c,Answer_3__c, Resource_URL__c
	     	  			  			FROM Handling_Objection__c
	          			  			WHERE id =: ApexPages.currentPage().getParameters().get('id')];
	          			  
	        redirectUrl = RCHandlingObjections.Resource_URL__c;
		}catch(exception ex){}
	}
}