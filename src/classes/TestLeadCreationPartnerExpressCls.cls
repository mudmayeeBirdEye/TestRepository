@isTest
private class TestLeadCreationPartnerExpressCls {
	static LeadCreationPartnerExpressCls ctrlObj;
	
	enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    
    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert ,string profileId, string ranDomStr) {
        /* Make sure the running user has a role otherwise an exception 
           will be thrown. */
        if(userWithRole == null) {   
            if(UserInfo.getUserRoleId() == null) {
                UserRole r = new UserRole(name = 'TEST ROLE');
                Database.insert(r);
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest9.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole9@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            System.assert(userWithRole.userRoleId != null, 
                          'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }

        Account acc1;
        Contact contact1;
        System.runAs(userWithRole) {
            Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
            Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
            
            acc1 = new Account();
            acc1.Name = 'Test Account';
            acc1.Partner_ID__c = '12349';
            acc1.Current_Owner_Email__c = [select Email from User where Id = :UserInfo.getUserId()].Email;
            acc1.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
            Database.insert(acc1);
            
            contact1 = new Contact(AccountId = acc1.id, lastname = 'lastname9',email='testcontact9@test.com');
            Database.insert(contact1);
        }
        
        /* Get any profile for the given type.*/
        Profile p = [select id from profile where Id  = :profileId limit 1];   
        
        String testemail = 'puser00111@amamama.com';
        User pu; 
        //if(ranDomStr == 'C') {
        	pu = new User(profileId = p.id, username = 'testlead9@test.com', email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='test9', lastname='lastname', contactId = contact1.id);
        //} 
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
    }
	
	static testMethod void myUnitTest() {
		TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
        TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
        TriggerHandler.BY_PASS_CONTACT_ON_UPDATE =  true;
		Profile p1 = [select id ,name from profile where name = 'RC Partner Express' limit 1];
        User pu = getPortalUser(PortalType.PowerPartner,null,true,p1.id,'C');
		System.Debug('>>>>>pu>>>' + pu.UserType);
		System.Debug('>>>>>pu>>>' + pu.profileId);
		System.runAs(pu) {
			LeadCreationPartnerExpressCls leadCreationObj = new LeadCreationPartnerExpressCls();
	        ApexPages.StandardController sc = new ApexPages.standardController(new Lead()); 
	        ctrlObj = new LeadCreationPartnerExpressCls(sc);
	        ctrlObj.getDecisionMaker();
	        ctrlObj.getHasPurchasedBefore();
	        ctrlObj.getHavePhoneBill();
	        ctrlObj.getIsUnderContract();
	        ctrlObj.getRecordTypeIdByName();
	        ctrlObj.cancelLead();
	        
	        ctrlObj.newLead.LeadPartnerID__c = '12349';
	        ctrlObj.newLead.Partner_Owner__c = pu.id;
	        ctrlObj.createNew();
	        
	        createTestLeadRecords();
	        ctrlObj.newLead.Email = 'testlead26@test.com';
	        ctrlObj.createNew();
	        //ctrlObj.newLead = new Lead();
	        //ctrlObj.newLeadQualification = new Lead_Qualification__c();
	        ctrlObj.newLead.id = null;
	        createTestLeadRecords();
	        ctrlObj.newLead.LeadPartnerID__c = '12349';
	        ctrlObj.newLead.Partner_Owner__c = pu.id;
	        ctrlObj.newLead.Email = 'testlead26@test.com';
	        ctrlObj.createNew();
	        ctrlObj.createLeadApprovalRecord('Lead Found',new User(Id = userInfo.getUserId()));
	        ctrlObj.newLead = new Lead();
	        ctrlObj.newLeadQualification = new Lead_Qualification__c();
	        ctrlObj.newLeadQualification.Decision_Maker_Partner__c = 'Same as Contact';
	        ctrlObj.createNew();
	        createTestLeadRecords();
	        ctrlObj.newLeadQualification.Decision_Maker_Email__c = ctrlObj.newLead.Email;
	        ctrlObj.newLeadQualification.Decision_Maker_Partner__c = 'Details Below';
	        ctrlObj.createNew();
	        ctrlObj.redirectNewLead();
	        ctrlObj.isFakeEmail('fake@email.com');
	        ctrlObj.clearPickListValue();
		}
    }
    
    private static void createTestLeadRecords(){
    	//Lead Record
    	ctrlObj.newLead.FirstName = 'Test_FName';
        ctrlObj.newLead.LastName = 'Test_LName';
        ctrlObj.newLead.Company = 'Test Company';
        ctrlObj.newLead.Email = 'testemail@testemail.com';
        ctrlObj.newLead.Phone = '1111111111';
        ctrlObj.newLead.State__c = 'California';
        ctrlObj.newLead.City__c = 'CA';
        ctrlObj.newLead.Lead_Brand_Name__c = 'RingCentral';
        ctrlObj.newLead.Lead_Tier_Name__c = 'Fax';
        ctrlObj.rcUsers = '2';
        ctrlObj.newLead.Number_of_Users__c = Double.valueOf(ctrlObj.rcUsers);
        ctrlObj.newLead.NumberOfEmployees__c = '2-19';
        ctrlObj.newLead.Number_of_Locations__c = '1';
        ctrlObj.newLead.Industry = 'Advertising,Marketing,Media,PR';
        ctrlObj.newLead.Estimated_Close_Date__c = system.today();
        ctrlObj.newLead.How_did_you_acquire_this_Lead__c = 'Test';
        ctrlObj.newLead.Description = 'Test Description';
        
        //Lead Qualification Record
        ctrlObj.newLeadQualification.Decision_Maker_Partner__c = 'Same as Contact';
        ctrlObj.newLeadQualification.Decision_Maker_First_Name__c = ctrlObj.newLead.FirstName;
        ctrlObj.newLeadQualification.Decision_Maker_Last_Name__c = ctrlObj.newLead.LastName;
        ctrlObj.newLeadQualification.Decision_Maker_Email__c = ctrlObj.newLead.Email;
        ctrlObj.newLeadQualification.Decision_Maker_Phone__c = ctrlObj.newLead.Phone;
        ctrlObj.newLeadQualification.Explain_the_Lead_s_Need__c = '0';
        ctrlObj.newLeadQualification.Budget_per_Month__c = '$100 - $200';
        ctrlObj.newLeadQualification.How_many_phones_are_needed__c = '1-5';
        ctrlObj.newLeadQualification.Timeframe__c = 'ASAP';
        ctrlObj.newLeadQualification.Have_copy_of_current_phone_bill__c = 'No';
        ctrlObj.newLeadQualification.Currently_under_contract__c = 'No';
        ctrlObj.newLeadQualification.Has_this_Lead_purchased_services_before__c = 'No';
    }
    
   
}