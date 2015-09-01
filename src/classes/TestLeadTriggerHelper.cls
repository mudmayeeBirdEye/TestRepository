@isTest
private class TestLeadTriggerHelper {
	
	enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    
    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert ,string profileId, string ranDomStr) {
        /* Make sure the running user has a role otherwise an exception 
           will be thrown. */
        if(userWithRole == null) {   
            if(UserInfo.getUserRoleId() == null) {
                UserRole r = new UserRole(name = 'TEST ROLE');
                Database.insert(r);
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest5.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole55@testorg.com');
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
            acc1.Partner_ID__c = '12346';
            acc1.Current_Owner_Email__c = [select Email from User where Id = :UserInfo.getUserId()].Email;
            acc1.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
            Database.insert(acc1);
            
            contact1 = new Contact(AccountId = acc1.id, lastname = 'lastname1',email='testcontact1@test.com');
            Database.insert(contact1);
        }
        
        /* Get any profile for the given type.*/
        Profile p = [select id from profile where Id  = :profileId limit 1];   
        
        String testemail = 'puser0011@amamama.com';
        User pu; 
        if(ranDomStr == 'A') {
        	pu = new User(profileId = p.id, username = ranDomStr + testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = contact1.id);
        } 
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
    }

    static testMethod void myUnitTest() {
        try {
        	Profile p1 = [select id ,name from profile where name = 'RC Partner User' limit 1];
        	User pu = getPortalUser(PortalType.PowerPartner,null,true,p1.id,'A'); /// RC Partner User
        	Schema.DescribeSObjectResult result = Lead.SObjectType.getDescribe();
   			Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
   			Test.startTest();
   			Lead leadObj = new Lead();
   			leadObj.RecordTypeId = rtMapById.get('Partner Leads').getRecordTypeId();
   			leadObj.FirstName = 'TestLead';
   			leadObj.Company = 'TestLead';
   			leadObj.LastName = 'TestLead';
   			leadObj.Email = 'TestLead@test.com';
   			leadObj.Phone = '9810546322';
   			leadObj.LeadPartnerID__c = '12346';
   			leadObj.Partner_Lead_Owner__c = pu.Id;
   			insert leadObj;
   			Test.stopTest();
        } catch(Exception ex) {}
    }
}