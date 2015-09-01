@isTest
public class TestCaseSolveSellOppController {

    static testMethod void myUnitTest() {
    	
    	RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Account' Limit 1];
    	Account accObj = new Account();
	    accObj.Name = 'TestAccount';
	    accObj.Number_of_DL_s__c = 5;
	    accObj.RecordTypeId = rt.Id;
	    accObj.Type ='Partner';
	    accObj.Partner_ID__c = '12345';
	    TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
	    insert accObj;
	    TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
	    
	    Opportunity Oppval = new Opportunity();
        Oppval.Name = 'Test Opp';
        Oppval.AccountId = accObj.Id;
        Oppval.Type = 'Existing Business';
        Oppval.StageName = OpportunityHelper.defaultOpportunityStage;
        Oppval.Sales_Model__c = 'Direct';
        Oppval.CloseDate = System.Today() + 10;
        Oppval.CurrencyIsoCode = 'USD';
        Oppval.Brand_Name__c= 'RingCentral';
        Oppval.OwnerId = Userinfo.getUserId();
        Oppval.RC_User_ID__c = Userinfo.getUserId();
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
        insert Oppval;
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT = true;
        
        Contact contactObj = new Contact();
        contactObj.AccountId =  accObj.Id;
        contactObj.Email = 'test@test.com';
        contactObj.Phone = '9910106804';
        contactObj.LastName = 'TestLast';
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
        insert contactObj;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
        
    	OpportunityContactRole oppContactRoleObj = new OpportunityContactRole(OpportunityId=Oppval.Id,ContactId=contactObj.id);
    	insert oppContactRoleObj;
    	/*Campaign campObj = new Campaign(BMID__c='SOLVETHENSELL',IsActive=true,Name='testCamp');
    	insert campObj;
    	
    	CampaignMember campMember = new CampaignMember(CampaignId=campObj.id,ContactId=contactObj.Id);
    	insert campMember;*/
    	
    	Case caseObj = new Case(ContactId=contactObj.Id, AccountId=accObj.id,Subject='Test',status='Open',Priority='P3',Description='Test Description');
    	TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
    	insert caseObj;  	
    	TriggerHandler.BY_PASS_CASE_ON_INSERT = true;    	
    	      
    	ApexPages.currentPage().getParameters().put('userid',UserInfo.getUserId());
    	ApexPages.currentPage().getParameters().put('caseid',caseObj.Id);
    	ApexPages.StandardController sc = new ApexPages.StandardController(Oppval);    	
    	CaseSolveSellOppController classObj = new CaseSolveSellOppController(sc);  
    	classObj.updateContact();   
    	classObj.strAgentEmail = 'test@test.com';
    	classObj.saveOpportunity();   
    }
}