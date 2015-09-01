public class HelpdeskTicket {

    public HelpdeskTicket() {}

    public Case caseObj {get; set;}
    public string subject {get;set;}
    public string description {get;set;}
    public static Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    public static Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
    public static Map<String,Schema.RecordTypeInfo> rtMapByRecName = result.getRecordTypeInfosByName();
    
    /********************************** Method to create IT Helpdesk Ticket **********************************************************/
    public PageReference submitCase() {
        String loggedInUser;
        List<User> userObj = new list<User>();
        try {
        	TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
        	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = true;
        	System.Debug('>>>12345>>');
            loggedInUser = UserInfo.getUserId();
            userObj = [SELECT ContactId, Contact.AccountId FROM User WHERE Id = :loggedInUser];
            caseObj = new Case();
            caseObj.RecordTypeId  = rtMapByRecName.get('IT Helpdesk').getRecordTypeId();
            caseObj.ContactId = userObj[0].ContactId;
            caseObj.AccountId = userObj[0].Contact.AccountId;
            caseObj.Status = 'New';
            caseObj.Subject = subject;
            caseObj.Description = description;
            caseObj.OwnerId = [select id from User where Name = 'RC Support Agent' and Profile.Name = 'System Administrator' limit 1].id;
            caseObj.origin = 'Web';
            insert caseObj;
            PageReference returnPage = new PageReference('/helpdesk/' + caseObj.Id); 
            returnPage.setRedirect(true);
            return returnPage;
            //return null;
         } catch (Exception e) {
        	return null;
         }
    }
}