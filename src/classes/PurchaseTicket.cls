public without sharing class PurchaseTicket {

    public PurchaseTicket() {}

    public Case caseObj {get; set;}
    public string subject {get;set;}
 	public string strDate {get;set;}
    public string description {get;set;}
    public static Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    public static Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
    public static Map<String,Schema.RecordTypeInfo> rtMapByRecName = result.getRecordTypeInfosByName();
    
    /********************************************* Method to submit Purchase Ticket Cases ****************************************/
    public PageReference submitCase() {
        String loggedInUser;
        List<User> userObj = new list<User>();
        try {
            loggedInUser = UserInfo.getUserId();
            userObj = [SELECT ContactId, Contact.AccountId FROM User WHERE Id = :loggedInUser];
            caseObj = new Case();
            caseObj.RecordTypeId  = rtMapByRecName.get('IT Helpdesk').getRecordTypeId();
            caseObj.ContactId = userObj[0].ContactId;
            caseObj.AccountId = userObj[0].Contact.AccountId;
            System.Debug('>>>>123>>');
            System.Debug('>>>>12344>>'+ strDate);
            if(!string.isBlank(strDate)) {
            	caseObj.Business_Services_Expected_Release_Date__c = Date.parse(strDate);
            }
            caseObj.Status = 'New';
            caseObj.Subject = subject; 
            caseObj.Request_Type__c = 'Procurement';
            caseObj.Description = description;
            caseObj.OwnerId = [select id from User where Name = 'RC Support Agent' and Profile.Name = 'System Administrator' limit 1].id;
            caseObj.origin = 'Web';
            insert caseObj;
            PageReference returnPage = new PageReference('/helpdesk/' + caseObj.Id); 
            returnPage.setRedirect(true);
            return returnPage;
         } catch (Exception e) {
            System.Debug('>>>>12344>>'+ e.getMessage());
         }
         return null;
    }
}