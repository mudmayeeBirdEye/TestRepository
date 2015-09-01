public with sharing class competitiveInfoExt {
	public Competitive_Info__c RCCompInfo{get;set;}
	public competitiveInfoExt(ApexPages.StandardController controller){
		try {
			RCCompInfo = new Competitive_Info__c();
			RCCompInfo = [SELECT id, name,  Competitor__c, Competitor_s_Website__c, Competitor_s_Strengths__c, Competitor_Weakness__c, Our_Strength_Detail__c, Our_Strength_Exp__c,
								 Our_Strength_Pricing__c, Our_Strength_Setup__c, Our_Strength_Support__c, Our_Strength_Contracts__c,Our_Strength_Phones__c,
								 Overcome_Objections__c, Resource_URL__c, RingCentral__c, Strengths__c, Weakness_Exp__c, Weakness_Pricing__c, Weakness_Setup__c,
								 Weakness_Support__c, Weakness_Contracts__c, Weakness_Phones__c, What_s_New_w_Competitor__c
	     	  			  FROM Competitive_Info__c
	          			  WHERE id =: ApexPages.currentPage().getParameters().get('id')];
	          			  
		} catch(exception ex){}
	}
}
//Brand_Tag__c,