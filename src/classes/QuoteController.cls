public class QuoteController {
    /*public String oppId{get;set;}
    public String quoteType{get;set;}
    public String subTitle{get;set;}
    public String accountURL{get;set;}
    public String accountName{get;set;}
    public List<String> pageErrorMessages{get;set;}
    public zqu__Quote__c quoteObj{get;set;}
    public List<String> valueRequiredMessage{get;set;}
    public Boolean requireServiceActivation{get;set;}
    public Boolean requireCustomerAcceptance{get;set;}
    public Boolean isSoldToNull{get;set;}
    public Boolean isBillToNull{get;set;}
    public Opportunity oppObj{get;set;}
    public boolean showRest{get;set;}
    private void initializeVariables() {
        showRest = true;
        oppId = '';
        subTitle = '';
        accountURL = '';
        requireServiceActivation = true;
        requireCustomerAcceptance = true;
        isSoldToNull = false;
        isBillToNull = false;
        pageErrorMessages = new List<String>();
        valueRequiredMessage = new List<String>();
    }
    public QuoteController(ApexPages.StandardController controller) {
        initializeVariables();
        //controller.getId();//
        oppId = ApexPages.currentPage().getParameters().get('eid');
        quoteType = ApexPages.currentPage().getParameters().get('quoteType');
        oppObj = new Opportunity();
        List<opportunity> oppList = [SELECT Id, Name, Account.Name, CurrencyIsoCode, AccountId, (SELECT Id, IsPrimary, ContactId FROM OpportunityContactRoles ORDER BY LastModifiedDate DESC LIMIT 1000) FROM Opportunity WHERE Id=: oppId limit 1];
        if(oppList.size()>0){
            oppObj = oppList[0];
        }else if(oppId == null ||  oppId == '' || oppList.size()<1){ 
            showRest = false;   
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Id value is not valid for the Opportunity standard controller.'));
        }
        quoteObj = new zqu__Quote__c();
        quoteObj.zqu__Opportunity__c = oppObj.Id;
        quoteObj.zqu__AutoRenew__c = true;
        
        if(quoteType=='salesAgreement'){
            quoteObj.Name = 'Sales Agreement for '+ oppObj.Name;
            quoteObj.SalesAgreementStatus__c = 'Draft';
            quoteObj.QuoteType__c = 'Sales Agreement';
        }else{
            quoteObj.Name = 'Quote for '+ oppObj.Name;  
        }
        
        accountURL = '/'+oppObj.AccountId;
        accountName = oppObj.Account.Name;
        
        if(oppObj.OpportunityContactRoles != null && oppObj.OpportunityContactRoles.size() != 0) {
            // quoteObj.zqu__BillToContact__c = oppObj.OpportunityContactRoles.get(0).ContactId;
            Id contactFound = oppObj.OpportunityContactRoles.get(0).ContactId;
            for(OpportunityContactRole oppRoleObj : oppObj.OpportunityContactRoles) {
                if(oppRoleObj.IsPrimary) {
                    contactFound = oppRoleObj.ContactId;
                    break;
                }
            }
            quoteObj.zqu__BillToContact__c = contactFound;
        }
        quoteObj.zqu__Currency__c = oppObj.CurrencyIsoCode;
    }
    /*private Opportunity getOpportunityDetails() {
        return new opportunity(); 
    }
    public PageReference save() {
        Boolean isError = false;
        try{
            if(quoteObj.zqu__StartDate__c < System.today()) {
                // pageErrorMessages.add('Start Date cannot be less than today.');
                isError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date cannot be less than today.')); 
                // return null; 
            }
            if(quoteObj.zqu__ValidUntil__c < System.today()) {
                // pageErrorMessages.add('Valid Until Date cannot be less than today.');
                isError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Valid Until Date cannot be less than today.'));
                // return null;
            }
            if(isError) {
                return null;
            }
            insert quoteObj;
            if(quoteType=='salesAgreement'){
                return new PageReference('/apex/QuoteDetails?id='+ quoteObj.Id+'&showStep=1&quoteType=salesAgreement'); 
            }else{
                return new PageReference('/apex/QuoteDetails?id='+ quoteObj.Id+'&showStep=1&quoteType=quote');
            }
        }catch(exception e){
            isError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,e.getdmlMessage(0));
            ApexPages.addMessage(myMsg);
            return null;
        }
        
    }
    public PageReference cancel() {
        return new ApexPages.StandardController(oppObj).view();//new PageReference('/'+ oppId);
    }*/
    
}