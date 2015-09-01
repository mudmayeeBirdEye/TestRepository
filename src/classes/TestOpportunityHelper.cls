@istest
public class TestOpportunityHelper{
static Map<String, Id> oppRecordTypeMap = new Map<String, Id>();
    static testMethod void UnitOpportunityHelper() {
    	Test.startTest(); 
   		User pu = getPortalUser(PortalType.PowerPartner, null, true);
   		Test.stopTest();   
     	Account acc = new Account(name = 'test1',Permitted_Brands__c='RingCentral',Partner_ID__c='122sdf001', 
                                  recordTypeId=OpportunityHelper.getOppRecordTypeMap('Partner Account'));     
     	insert acc ;            
     	Opportunity  opp = new Opportunity(name ='test2',AccountId=acc.id,Sales_Model__c='direct',Type='New Business',StageName='Qualified',CloseDate=System.today());
     	insert opp;
     	
     	
       
     	List<Opportunity> newoppList = new List<Opportunity>();
     	OpportunityHelper.getOppRecordTypeMap('Sales Oportunity');
     	oppRecordTypeMap = null;
     	OpportunityHelper.getOppRecordTypeMap('Saves Oportunity');            
     	OpportunityHelper.isActiveOpp('4. Discovery');
     	OpportunityHelper.isClosedOpp('4. Closed');
     	OpportunityHelper.getApprovedBrandList(newoppList);
     	
     	System.RunAs(pu) {
    		OpportunityHelper.getApprovedBrandList(newoppList);
        } 
             
    }
    
    
    
    enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    
    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
        /* Make sure the running user has a role otherwise an exception 
           will be thrown. */
        if(userWithRole == null) {   
            if(UserInfo.getUserRoleId() == null) {
                UserRole r = new UserRole(name = 'TEST ROLE');
                Database.insert(r);
                
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest2.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole2@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            
            System.assert(userWithRole.userRoleId != null, 
                          'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }

        Account a;
        Contact c;
        System.runAs(userWithRole) {
			Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    	    Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
    	    
    	    Account accObj2 = new Account();
	        accObj2.Name = 'Test Account Parent ';
	        accObj2.Partner_ID__c = '12346';
	        accObj2.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
	        insert accObj2;	
            
            a = new Account();
            a.Name = 'Test Account';
        	a.Partner_ID__c = '12348';
        	a.ParentId = accObj2.id;
        	a.RecordTypeId = rtMapById.get('Partner Account').getRecordTypeID(); 
            Database.insert(a);
        
	        Account accObj1 = new Account();
	        accObj1.Name = 'Test Account Customer';
	        accObj1.Partner_ID__c = '12348';
	        accObj1.RecordTypeId = rtMapById.get('Customer Account').getRecordTypeID(); 
	        insert accObj1;
            
            c = new Contact(AccountId = a.id, lastname = 'lastname');
            Database.insert(c);
        }
        
        /* Get any profile for the given type.*/
        Profile p = [select id 
                      from profile 
                     where usertype = :portalType.name() 
                     limit 1];   
        
        String testemail = 'puser001@amamama.com';
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = c.id);
        
        if(doInsert) {
            Database.insert(pu);
        }
        return pu;
    }
}