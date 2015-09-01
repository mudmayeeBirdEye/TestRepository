@isTest
private class TestLeadCreationPartnerVAR {
    
    enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    
    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert ,string profileId, string ranDomStr) {
        /* Make sure the running user has a role otherwise an exception 
           will be thrown. */
        if(userWithRole == null) {   
            if(UserInfo.getUserRoleId() == null) {
                UserRole r = new UserRole(name = 'TEST ROLE');
                Database.insert(r);
                
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            
            System.assert(userWithRole.userRoleId != null, 
                          'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }

        Account acc1;
        Account acc2;
        Contact contact1;
        Contact contact2;
        System.runAs(userWithRole) {
            Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
            Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
            
            acc1 = new Account();
            acc1.Name = 'Test Account';
            acc1.Partner_ID__c = '1234';
            acc1.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
            Database.insert(acc1);
            
            acc2 = new Account();
            acc2.Name = 'Test Account';
            acc2.Partner_ID__c = '12345';
            acc2.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
            Database.insert(acc2);
            
            contact1 = new Contact(AccountId = acc1.id, lastname = 'lastname1',email='testcontact1@test.com');
            Database.insert(contact1);
            
            contact2 = new Contact(AccountId = acc2.id, lastname = 'lastname2',email='testcontact2@test.com');
            Database.insert(contact2);
        }
        
        /* Get any profile for the given type.*/
        Profile p = [select id from profile where Id  = :profileId limit 1];   
        
        String testemail = 'puser000@amamama.com';
        User pu; 
        if(ranDomStr == 'A') {
        	pu = new User(profileId = p.id, username = ranDomStr + testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = contact1.id);
        } else if(ranDomStr == 'B') {
        	pu = new User(profileId = p.id, username = ranDomStr + testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = contact2.id);
        }
        
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
    }
   

    static testMethod void myUnitTest() {
         try{
            TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
            TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
            TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
            TriggerHandler.BY_PASS_CONTACT_ON_UPDATE =  true;
            
            Profile p1 = [select id ,name from profile where name = 'RC Partner User'
                            limit 1];
                      
            Profile p2 = [select id, name from profile  where name = 'RC Partner Express'
                            limit 1];
            
            User pu = getPortalUser(PortalType.PowerPartner,null,true,p1.id,'A'); /// RC Partner User
            User pu1 = getPortalUser(PortalType.PowerPartner,null,true,p2.id,'B'); /// RC Partner User Express
         
            Schema.DescribeSObjectResult result = Lead.SObjectType.getDescribe();
   			Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
             
            ApexPages.StandardController sc = new ApexPages.standardController(new Lead()); 
            LeadCreationPartnerVAR leadObj = new LeadCreationPartnerVAR(sc);
            
            Test.startTest();
            
            leadObj.getRCPartnerBrandItems();
            leadObj.getRCPartnerBrandTierItems();
            leadObj.getCurrentUser(UserInfo.getuserid());
            leadObj.checkInputFieldLength();
            leadObj.isFakeEmail('test@salesforce.com');
            leadObj.selectedPartnerOwnerId = pu.id;
            leadObj.strSelectedBrand = 'RingCentral';
            leadObj.strSelectedTier = 'Pro';
            leadObj.fillPartnerID();   
            
            leadObj.newLead.RecordTypeId = rtMapById.get('Partner Leads').getRecordTypeId();
            leadObj.newLead.FirstName= 'AbcTest';
            leadObj.newLead.LastName='Last11';
            leadObj.newLead.Company='Company11';
            leadObj.newLead.Phone='9810546382';
            leadObj.newLead.Email='abc@simplion.com';
            leadObj.newLead.LeadSource = 'Inbound Call';
            leadObj.newLead.Notes__c = 'Test Notes'; 
            leadObj.newLead.Website = 'http://test.com';
            leadObj.newLead.NumberOfEmployees = 123;
            leadObj.newLead.Industry = 'Test';
            leadObj.newLead.NumberOfEmployees__c = '2-19';
            leadObj.newLead.Number_of_Locations__c = '2-4';
            leadObj.newLead.Description ='testing this ';
            leadObj.newLead.Country__c = 'United state';
            leadObj.newLead.State__c = 'california';
            leadObj.newLead.City__c = 'california';
            leadObj.newLead.LeadPartnerID__c ='1234';            
            leadObj.newLead.Lead_Brand_Name__c = leadObj.strSelectedBrand;
            leadObj.newLead.Lead_Tier_Name__c = leadObj.strSelectedTier;
            leadObj.newLead.Estimated_Close_Date__c = system.today();
            leadObj.newLead.How_did_you_acquire_this_Lead__c ='Test123';
            leadObj.rcUsers = string.valueof('10');
            leadObj.newLead.Partner_Lead_Owner__c = pu1.id;
            leadObj.createNew();
            leadObj.newLead.Partner_Lead_Owner__c = pu.id; 
            leadObj.createNew();
            leadObj.resetErrorVariables();
            leadObj.resetFieldValue();
            leadObj.cancel();
            Test.stopTest();
            
            ApexPages.StandardController sc1 = new ApexPages.standardController(new Lead()); 
            LeadCreationPartnerVAR leadObj1 = new LeadCreationPartnerVAR(sc1);
            leadObj.getRCPartnerBrandItems();
            leadObj.getRCPartnerBrandTierItems();
            leadObj.getCurrentUser(UserInfo.getuserid());
            leadObj.checkInputFieldLength();
            leadObj.isFakeEmail('test@salesforce.com');
            leadObj.selectedPartnerOwnerId = pu.id;
            leadObj.strSelectedBrand = 'RingCentral';
            leadObj.strSelectedTier = 'Pro';
            leadObj.fillPartnerID();   
            
            leadObj.newLead.RecordTypeId = rtMapById.get('Partner Leads').getRecordTypeId();
            leadObj.newLead.FirstName= 'AbcTest';
            leadObj.newLead.LastName='Last11';
            leadObj.newLead.Company='Company11';
            leadObj.newLead.Phone='9810546382';
            leadObj.newLead.Email='virendra@singhs@implion.com';
            leadObj.newLead.LeadSource = 'Inbound Call';
            leadObj.newLead.Notes__c = 'Test Notes'; 
            leadObj.newLead.Website = 'http://test.com';
            leadObj.newLead.NumberOfEmployees = 123;
            leadObj.newLead.Industry = 'Test';
            leadObj.newLead.NumberOfEmployees__c = '2-19';
            leadObj.newLead.Number_of_Locations__c = '2-4';
            leadObj.newLead.Description ='testing this ';
            leadObj.newLead.Country__c = 'United state';
            leadObj.newLead.State__c = 'california';
            leadObj.newLead.City__c = 'california';
            leadObj.newLead.LeadPartnerID__c ='12344';            
            leadObj.newLead.Lead_Brand_Name__c = leadObj.strSelectedBrand;
            leadObj.newLead.Lead_Tier_Name__c = leadObj.strSelectedTier;
            leadObj.newLead.Estimated_Close_Date__c = system.today();
            leadObj.newLead.How_did_you_acquire_this_Lead__c ='Test123';
            leadObj.newLead.Partner_Lead_Owner__c = pu.id; 
            leadObj.rcUsers = string.valueof('10');
            leadObj.createNew();  
           } catch(Exception ex) {}
	}
    
 	static testMethod void myUnitTest1() {
     	try {
     		ApexPages.StandardController sc = new ApexPages.standardController(new Lead()); 
            LeadCreationPartnerVAR leadObj = new LeadCreationPartnerVAR(sc);
            leadObj.rcUsers = 'Test';
            leadObj.createNew();
            Test.startTest();
            Test.stopTest();
     	} catch(Exception ex) {}
 	}   
 }