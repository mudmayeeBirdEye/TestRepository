public class ConvertToSalesAgreementExtn {

    /* The Z-Quote context (quote we are adding products for) 
    public zqu__Quote__c quote { get; set; }
    /* The standard controller (quote) passed in parameter 
    private ApexPages.StandardController controller;
    
    public String quoteID{get;set;}
    public boolean menuFlag {get; set;} 
    public PageReference validateQuote() {
        menuFlag = false;
        if (quote != null) { 
            String startDate = string.valueOf(quote.zqu__StartDate__c);
            String initialTerm = string.valueOf(quote.zqu__InitialTerm__c);
            String renewalTerm = string.valueOf(quote.zqu__RenewalTerm__c);
            String validDate = string.valueOf(quote.zqu__ValidUntil__c);
            
            if(String.isBlank(startDate) || String.isBlank(validDate) || String.isBlank(initialTerm) || String.isBlank(renewalTerm)){
                menuFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Required field(s) missing.'));
            } else if(quote.zqu__StartDate__c < system.today()) {
                menuFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Start Date cannot be less than today.'));
            } else if(quote.zqu__ValidUntil__c < system.today()) {
                menuFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Valid Until Date cannot be less than today.'));
            }
        }  
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '================ ' + menuFlag));
        if(menuFlag == false) {
            quote.name = 'Sales Agreement for '+quote.zqu__Opportunity__r.name;
            quote.QuoteType__c = 'Sales Agreement'; 
            quote.SalesAgreementStatus__c = 'Draft'; 
            try {
                update quote;
            } catch(System.DmlException e) {
                menuFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getDmlMessage(0)));
                return null; 
            }
            return new PageReference('/'+this.quoteId);
        } 
        return null;
    }
    
    /**
     *  The constructor
     
    public ConvertToSalesAgreementExtn(ApexPages.StandardController controller) {
        /* Set the controller in attribute
        this.controller = controller;
        menuFlag = false;
        this.quoteId = controller.getRecord().Id;
        this.quote = [SELECT QuoteType__c, SalesAgreementStatus__c, zqu__StartDate__c, zqu__Opportunity__c,zqu__Opportunity__r.name,zqu__BillToContact__c,zqu__ValidUntil__c,zqu__InitialTerm__c,
                                 zqu__RenewalTerm__c, zqu__AutoRenew__c, zqu__Terms__c,Name,zqu__Currency__c,zqu__SubscriptionType__c
                                 FROM zqu__Quote__c WHERE Id = :quoteId ];
        
    }
    
    /* Back to Quote 
    public pageReference back(){
        return validateQuote();
    }*/
}