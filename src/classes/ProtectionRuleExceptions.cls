/*************************************************
ProtectionRuleExceptions class
ProtectionRuleExceptions checks for certain predefined conditions and returns whether to use protection rules or not.
/************************************************/
public with sharing class ProtectionRuleExceptions {
	Lead leadToCheck;
	Boolean returnCheck;
	Map<String, String> mapProtectedEmailAddresses = new Map<String, String>{
			'fake@email.com' => 'fake@email.com', 'fake@fake.com' => 'fake@fake.com'};	
	Map<String, String> mapProtectedBrands = new Map<String, String>{
			'ringcentral office@hand from at&t' => 'RingCentral Office@Hand from AT&T',
			'at&t office@hand' => 'AT&T Office@Hand', 'rogers' => 'Rogers'};	
    Map<String, String> mapPRLeadSource = new Map<String, String> {
    'about to be cancelled' => 'About To Be Cancelled', 'about to be cancelled uk' => 'About To Be Cancelled UK'
    };
    
	public ProtectionRuleExceptions(Lead leadToCheck){
        this.leadToCheck = leadToCheck;
        returnCheck = true;
    }
	
	public Boolean useProtectionRuleCheck (){
		try{
			returnCheck = (fakeEmailCheck() && brandCheck() && leadSourceCheck());//Do and of all conditions, if any of them is false, return with false
			
		}catch(Exception exp){
			return returnCheck;
		}
		
		return returnCheck;
	}
	
	private Boolean fakeEmailCheck(){
		return ((leadToCheck.Email != null && mapProtectedEmailAddresses.get(leadToCheck.Email.trim().toLowerCase()) != null)? false : true);
	}
	
	private Boolean brandCheck(){
		return ((leadToCheck.Lead_Brand_Name__c != null 
			&& mapProtectedBrands.get(leadToCheck.Lead_Brand_Name__c.trim().toLowerCase()) != null)? false : true);		
	}
	private Boolean leadSourceCheck() {
		//Boolean returnCheckVal = ((leadToCheck.LeadSource != null && mapPRLeadSource.get(leadToCheck.LeadSource.trim().toLowerCase()) != null)? false : true);
		// System.debug('##### LEAD SOURCE CHECK = ' + returnCheckVal);
    	return ((leadToCheck.LeadSource != null && mapPRLeadSource.get(leadToCheck.LeadSource.trim().toLowerCase()) != null)? false : true);
    }
/*	public static testMethod void ProtectionRuleExceptions(){
		try {
			ProtectionRuleExceptions pre ;
			Lead lTest1 = new Lead();
			Boolean bFireProtectionRules;
	        lTest1.firstname = 'firstname';
	        lTest1.lastname = 'lastname';
	        lTest1.company = 'leadcompany';
	        lTest1.phone = '9874569877';
	        lTest1.phone = '9874569877';
	        lTest1.email = 'fake@email.com';
	        lTest1.Lead_Brand_Name__c = 'Rogers';
	        insert lTest1;
	        
	        pre = new ProtectionRuleExceptions(lTest1);
	        bFireProtectionRules = pre.useProtectionRuleCheck();
	        Boolean brandCheck = pre.brandCheck();
	        Boolean emailCheck = pre.fakeEmailCheck();
	        Boolean leadSourceCheck = pre.leadSourceCheck();
	        
	        Lead lTest2 = new Lead();
			lTest2.firstname = 'firstname';
	        lTest2.lastname = 'lastname';
	        lTest2.company = 'leadcompany';
	        lTest2.phone = '9874569877';
	        lTest2.phone = '9874569877';
	        lTest2.email = 'fake@fake.com';
	        lTest2.Lead_Brand_Name__c = 'AT&T Office@Hand';
	        insert lTest2;
	        
	        pre = new ProtectionRuleExceptions(lTest2);
	        bFireProtectionRules = pre.useProtectionRuleCheck();
	        brandCheck = pre.brandCheck();
	        emailCheck = pre.fakeEmailCheck();
	        leadSourceCheck = pre.leadSourceCheck();
		} catch(Exception e){}
	}*/
	
}