/*

Author:     Mickael Pham <mickael.pham@zuora.com>

Created:    May 6, 2013

Modified:   May 13, 2013

Comment:    This is the controller class to allow multiple selection of product
            and product rate plans (instead of going with x1 product and then
            x1 product rate plans) and add them all at once on the associated quote

*/

public with sharing class Z_MultiSelectProductWrappedController {

    // ------------------------------------------------------------------------
    // Public VF Attributes
    // ------------------------------------------------------------------------
    
    /* Boolean to show error if quote is already expired 
    public Boolean isExpiredQuote { get; set; }
    
    
    /* Boolean to know whether Discount is editable or not
    public Boolean discountsEnabled { get; set; }
    
    /*Boolean to see if its salesagreement or simple quote
    public Boolean isSalesAgreement { get; set; }
    
    /* Boolean to render the whole form (all tables) if the initialization went OK 
    public Boolean initSuccess { get; set; }
    
    /* The Z-Quote context (quote we are adding products for) 
    public zqu__Quote__c quote { get; set; }
    
    /* List of products displayed on the VF page 
    public List<zqu__ZProduct__c> productList { get; set; }
    
    /* List of selected product IDs 
    public List<ID> selectedProductIds { get; set; }
    
    /* List of product rate plans displayed on the VF page 
    public List<zqu__ProductRatePlan__c> ratePlanList { get; set; }
    
    /* List of selected rate plan IDs 
    public List<ID> selectedRatePlanIds { get; set; }
    
    /* Boolean to render the product panel 
    public Boolean displayProductsPanel { get; set; }
    
    /* Boolean to render the product rate plan panel 
    public Boolean displayProductRatePlanPanel { get; set; }
    
    /* Boolean to render the charge group panel 
    public Boolean displayChargeGroupPanel { get; set; }
    
    /* --- FOR TEST ONLY --- Throw an exception during test? 
    public Boolean throwException { get; set; }
    
    /* List of zChargeGroup (based on selected rate plans) 
    public List<zqu.zChargeGroup> chargeGroupList { get; set; }
    
    /* Wrapped Charge Groups to store Wrapped Charges 
    public List<wChargeGroup> wChargeGroupList {get;set;}
    
    /*quote charge type
    public Map<String,String> mapPlanChargeType{get;set;}
    
    public class wChargeGroup {
        public zqu.zChargeGroup zChargeGroup {get;set;}
        public List<wCharge> wCharges {get;set;}
    }
    
    /* Wrapped Charge to store Custom Fields 
    public class wCharge {
        public zqu.zCharge zCharge {get;set;}
        public String PAccess {get;set;}
    }
    
    public static List<String> FILTER_NAMES = new List<String>{'filter3__c', 'filter4__c', 'filter1__c', 'filter2__c'};
    
    /* List of ProductRatePlan custom fields and values on which to filter. 
    public class RatePlanFilter {
        public String name {get;set;}
        public String label {get;set;}
        public String selected {get;set;}
        public List<SelectOption> options {get;set;}
    }
    
    public List<RatePlanFilter> planFilters {get;set;}
    
    // ------------------------------------------------------------------------
    // Private Attributes
    // ------------------------------------------------------------------------
    
    /* The standard controller (quote) passed in parameter 
    private ApexPages.StandardController controller;
    
    
    // ------------------------------------------------------------------------
    // Public Methods
    // ------------------------------------------------------------------------

    /**
     *  The constructor
     
    public Z_MultiSelectProductWrappedController(ApexPages.StandardController controller) {
        
        Id userId = UserInfo.getUserId();
        if(userId != null){
            List<User> usrList = [Select id,Discounts_Enabled__c FROM User WHERE Id =:userId limit 1];
            if(usrList.size()>0){
                this.discountsEnabled = usrList[0].Discounts_Enabled__c;    
            }else{
                this.discountsEnabled = false;
            }   
        }
        
        this.isExpiredQuote = false;
        
        this.isSalesAgreement = false;
        
        // Set the controller in attribute
        this.controller = controller;
        
        // Before validation
        this.initSuccess = false;
        
        // Don't throw a test exception
        throwException = false;
        if (!validate())
            return;
        refreshProducts();

        // Gather select options for RatePlan filters.
        createRatePlanFilterLists();
        
        // After validation
        this.initSuccess = true;
    }
    
    
    /**
     *  Get the list of product rate plans for the selected products
     
    public PageReference displayProductRatePlan() {
        
        // Get the IDs of the selected product(s) on the VF page
        Set<Id> selectedProductIds = new Set<Id>();
        
        for (zqu__ZProduct__c product : productList) {
            
            if (product.Selected_for_Quote__c)
                selectedProductIds.add(product.Id);
        }
        
        // Get the associated rate plans
        this.ratePlanList = getFilteredRatePlanList(
            selectedProductIds,
            quote.zqu__Currency__c,
            quote.zqu__StartDate__c
        );
        
        this.displayProductRatePlanPanel = true;
        this.displayChargeGroupPanel = false;
        this.chargeGroupList = new List<zqu.zChargeGroup>();
        
        return null;
    }
    
    /**
     *  Construct RatePlanFilter list based on picklist descriptions.
     
    
    public void createRatePlanFilterLists(){    
        planFilters = new List<RatePlanFilter>();   
        for(String filterName : FILTER_NAMES){
            // For each filter Name, create a RatePlanFilter class to store filter criteria
            RatePlanFilter filter = new RatePlanFilter();
            
            // Populate options with a list of options from that field
            List<SelectOption> options = new List<SelectOption>();

            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType productrateplanSchema = schemaMap.get('zqu__ProductRatePlan__c');
            Map<String, Schema.SObjectField> prpFieldMap = productrateplanSchema.getDescribe().fields.getMap();
            
            // Populate name with the API Name of the field
            filter.name = filterName;
            List<Schema.PicklistEntry> pleList;
            
            Schema.DescribeFieldResult fieldDescription = prpFieldMap.get(filterName).getDescribe();
            Schema.DescribeFieldResult valueFieldDescription = prpFieldMap.get('values_' + filterName).getDescribe();
            
            // Populate label with the readable name of the filter
            filter.label = fieldDescription.getLabel();
            pleList = valueFieldDescription.getPicklistValues();
    
            options.add(new SelectOption('', 'All Options'));
            for( Schema.PicklistEntry f : pleList){
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            filter.options = options;
            
            // Populate the Selected value with whatever exists on the Quote
            SObject SOquote = (SObject) quote;
            String selVal = (String) SOquote.get(filterName);
            filter.selected = selVal;
            
            // Add filter to list
            planFilters.add(filter);
            System.debug('Filter Name = ' + filter.label);
            System.debug('Filter Values = ' + filter.options);
            // Filters will be searched using a Contains filter. IE. a value of Fax will match "Office|Pro|Fax".
            // Uses filter WHERE filer1__c like '%VALUE%'
        }
    }

    /**
     *  Get all the charge group associated with the selected rate plans
     
    public PageReference displayChargeGroup() {
        // Get the IDs of the selected rate plan(s) on the VF page
        List<Id> selectedRatePlanIds = new List<Id>();
        
        
        for (zqu__ProductRatePlan__c ratePlan : ratePlanList) {
            if(ratePlanList != null) {
                if (ratePlan.Selected_for_Quote__c)
                    selectedRatePlanIds.add(ratePlan.Id);
            }
        }
        
        // Get the associated charge groups
        if (selectedRatePlanIds.size() > 0) {
            try {
                this.chargeGroupList = zqu.zQuoteUtil.getChargeGroups(quote.Id, selectedRatePlanIds);
            } catch(Exception e) {}
            if(this.chargeGroupList == null) {
                this.chargeGroupList = new List<zqu.zChargeGroup>();   
            } else {
                // Validate the quote (to display errror message if any)
                Z_QuoteValidator.Z_CheckResult result = Z_QuoteValidator.validateQuote(quote.Id, chargeGroupList);
                if (result != null && !result.isValid) {
                    for (String msg : result.msgList) {
                        appendMessage(ApexPages.Severity.ERROR, msg);
                    }
                }
            }
        } else {
            // Reset the list
            this.chargeGroupList = new List<zqu.zChargeGroup>();    
        }
        
        // Display the charge group panel
        this.displayChargeGroupPanel = true;
    /*preparing quote charge type map
        Set<String> setPRODUCTRATEPLANCHARGESFDCID=new Set<String>();
        mapPlanChargeType=new Map<String,String>();
        for(zqu.zChargeGroup currentChargeGroup:chargeGroupList){
            for(zqu.zCharge objzCharges:currentChargeGroup.zCharges){  
              setPRODUCTRATEPLANCHARGESFDCID.add(objzCharges.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID);
             }
         }
        for(zqu__ProductRatePlanCharge__c objProductRatePlanCharge:[Select id,ChargeType__c from zqu__ProductRatePlanCharge__c where id IN:setPRODUCTRATEPLANCHARGESFDCID]){
            mapPlanChargeType.put(objProductRatePlanCharge.id,(objProductRatePlanCharge.ChargeType__c==null?'':objProductRatePlanCharge.ChargeType__c));
        }
        /*check all map key correspondind to PRODUCT_RATE_PLAN_CHARGE_SFDC_ID
        /*for(String str:setPRODUCTRATEPLANCHARGESFDCID){
            if(mapPlanChargeType.get(str)==null){
                mapPlanChargeType.put(str,'');
            }
        }
        return null;
    }
    /**
     * On quantity change
     
    public string strChangeValue{get;set;}
    public void quantityChange() {
        strChangeValue='';
        for (zqu.zChargeGroup currentChargeGroup : chargeGroupList) {
            for(zqu.zCharge objzCharges:currentChargeGroup.zCharges){  
             strChangeValue=strChangeValue+objzCharges.QUANTITY;
           }
        }
        for (zqu.zChargeGroup currentChargeGroup : chargeGroupList) {
            List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnQuantityChange(currentChargeGroup.zCharges);
            currentChargeGroup.zCharges = charges;
            for(zqu.zCharge objzCharges:currentChargeGroup.zCharges){ 
                system.debug('@@@@@@@@@@@@@@@@'+ objzCharges.DISCOUNT);
            }
        }
    }
    public String qchargeID{get;set;}
    /*
    *   Discount update
    
    public PageReference discountChangeAction() {
        
    /*  for(zqu.zChargeGroup currentChargeGroup : chargeGroupList){
            for(zqu.zCharge objzCharges : currentChargeGroup.zCharges){  
                if(objzCharges.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID==qchargeID){
                    Decimal dc = Decimal.valueOf(objzCharges.DISCOUNT);
                    Decimal LIST_PRICE=Decimal.valueOf(objzCharges.LIST_PRICE);
                    Decimal Disct =     dc/LIST_PRICE * 100;
                    objzCharges.DISCOUNT = string.valueOf(Disct);
                }
            }
            zqu.ZChargeGroup updatedChargeGroup = null;
            try {
                updatedChargeGroup = zqu.zQuoteUtil.updateChargeGroup(currentChargeGroup);
            } catch (zqu.ZQException e) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                ApexPages.addMessage(msg);
                return null;
            }
            for (Integer i = 0; i < this.chargeGroupList.size(); i++) {
                zqu.ZChargeGroup zchargeGrp = this.chargeGroupList.get(i);
                if (updatedChargeGroup.groupId == zchargeGrp.groupId) {
                    this.chargeGroupList.set(i, updatedChargeGroup);
                }
            }
        } 
        
                    
      
        for (zqu.zChargeGroup currentChargeGroup : chargeGroupList) {
            List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnDiscountChange(currentChargeGroup.zCharges);
            currentChargeGroup.zCharges = charges;
        }
        
        return null;
      /*
      zqu__ProductRatePlanCharge__c objProductRatePlanCharge =[SELECT id,zqu__DefaultQuantity__c,zqu__ListPrice__c,ChargeType__c,
      zqu__Discount_Apply_Type__c FROM zqu__ProductRatePlanCharge__c WHERE id =:qchargeID];
      
    /*  for(zqu.zChargeGroup currentChargeGroup : chargeGroupList){
            for(zqu.zCharge objzCharges : currentChargeGroup.zCharges){  
                if(objzCharges.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID==qchargeID){
                    // objzCharges.TOTAL='200';
                    Decimal LIST_PRICE=Decimal.valueOf(objzCharges.LIST_PRICE);
                    Decimal DISCOUNT=Decimal.valueOf(objzCharges.DISCOUNT);
                    Decimal QUANTITY=Decimal.valueOf(objzCharges.QUANTITY);
                    objzCharges.EFFECTIVE_PRICE = string.valueOf(LIST_PRICE == null ? 0 : (LIST_PRICE - ((LIST_PRICE * (DISCOUNT == null ? 0 : DISCOUNT))/100)));
                    Decimal EFFECTIVE_PRICE=Decimal.valueOf(objzCharges.EFFECTIVE_PRICE);
                    objzCharges.TOTAL = string.valueOf((EFFECTIVE_PRICE * (QUANTITY == null ? 1 : QUANTITY)));
                    
                    // System.debug(zqu.ZQChargeCalculator.DisplayListPrice);
                    // system.debug(objzCharges.ZQChargeCalculator.DisplayDiscount);
                    /*ZQChargeCalculator.DisplayDiscount=0.00;
                    ZQChargeCalculator.DisplayEffectivePrice=64.99;
                    ZQChargeCalculator.DisplayListPrice=64.99;
                    ZQChargeCalculator.DisplayListTotal=64.99;
                    ZQChargeCalculator.DisplayQuantity=1;
                    ZQChargeCalculator.DisplayTotal=64.99;
                    
                    /*  break;
                }
            } 
        }
        return null;
    }
    
    
    /**
     * On effective price change
     
    public void effectiveChange() {
        for (zqu.zChargeGroup currentChargeGroup : chargeGroupList) {
            List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnEffectivePriceChange(
                currentChargeGroup.zCharges
            );
            currentChargeGroup.zCharges = charges;
        }
    }
    
    
    /**
     *  Save the charge groups to the quote
     
    public PageReference saveCharges() {
        return saveCharges(false);
    }
    
    /**
     *  Save the charge groups to the quote and return to the product selector
     
    public PageReference saveAndNewCharges() {
        return saveCharges(true);
    }
    
    public PageReference saveCharges(boolean continueEditing){

        // Store filter values on the Quote upon saving charges.
        updateQuoteWithFilterValues();
                
        // Validate the charges to be added
        Z_QuoteValidator.Z_CheckResult result = Z_QuoteValidator.validateQuote(quote.Id, chargeGroupList);
        
        if (result.isValid) {
            // Add the charges to the quote
            try {
                List<zqu.zChargeGroup> chargeGroup = zqu.zQuoteUtil.addChargeGroups(chargeGroupList);
                
                if (Test.isRunningTest() && throwException)
                    throw new zqu.ZQException('test exception');
        

            } catch (zqu.ZQException e) {
                appendMessage(ApexPages.Severity.ERROR, e.getMessage());

                return null;
            }
            
            if(continueEditing){
                // Get back to the product selector
                //PageReference pageRef = Page.Z_MultiSelectProduct;
                //PageReference pageRef = Page.Z_MultiSelectProductWrapped;
                PageReference pageRef = Page.QuoteDetails;
                pageRef.getParameters().put('Id', this.quote.Id);
                pageRef.setRedirect(true);
                
                return pageRef;
            } else {
                // Get back to the quote detail page
                PageReference pageRef = new PageReference('/' + quote.Id);
                pageRef.setRedirect(true);
                return pageRef;
            }
        } else {
            // The quote is invalid, display the message and stay on the page
            for (String msg : result.msgList) {
                appendMessage(ApexPages.Severity.ERROR, msg);
            }
        }

        return null;
    }
    
    
    // ------------------------------------------------------------------------
    // Private Methods
    // ------------------------------------------------------------------------
    
    /**
     *  Display a message in the VF page
     
    private static void appendMessage(ApexPages.Severity messageType, String message) {
        ApexPages.addMessage(new ApexPages.Message(messageType, message));
    }

    /**
     *  Validate the context (existing quote of type 'Default') and display error message
     *  (if any) back on the VF page
     
    private Boolean validate() {
        return validateQuote();
    }
    
    public pageReference validateQuoteBeforeProducts(){
        boolean ch = validateQuote();
        return null;
    }
    
    public boolean validateQuote(){
        // Check if we are passing a quote ID in parameter (cf. controller)
        if (null == controller.getRecord() || null == controller.getRecord().Id) {
            appendMessage(ApexPages.Severity.ERROR,
                    'No quote found, you can\'t add product rate plans to an inexisting quote.');
            return false;
        }
        
        ID quoteId = controller.getRecord().Id;
        
        // Get the quote information
        List<zqu__Quote__c> quoteList = [
            SELECT
                zqu__StartDate__c,
                zqu__Opportunity__c,
                zqu__BillToContact__c,
                zqu__ValidUntil__c,
                zqu__InitialTerm__c,
                zqu__RenewalTerm__c,
                zqu__AutoRenew__c,
                zqu__Terms__c,
                Name,
                QuoteType__c,
                zqu__Currency__c,
                zqu__SubscriptionType__c,
                filter1__c,
                filter2__c,
                filter3__c,
                filter4__c
            FROM
                zqu__Quote__c
            WHERE
                Id = :quoteId
        ];
        
        // Check if we retrieved the quote
        if (1 != quoteList.size()) {
            appendMessage(ApexPages.Severity.ERROR,
                    'No quote found with this ID (' + quoteId + '). You might want to check '
                    + 'with your administrator if you have access to the record');
            return false;
        }
        
        // Set the quote in attribute
        this.quote = quoteList[0];
        
        //Check if its salesAgreement or simple quote
        if(this.quote.QuoteType__c == 'Sales Agreement'){
            isSalesAgreement = true;    
        }else{
            isSalesAgreement = false;
        }
        // Check if quote is already expired 
        if (this.quote.zqu__ValidUntil__c < System.today()) {
            this.isExpiredQuote = true;
            appendMessage(ApexPages.Severity.ERROR,
                    'This Quote has been expired and cannot be edited. Extend the "Valid Until" date to add products.');
            return false;
        }
        // All test passed
        return true;
        
    }
    
    /**
     *  Refresh the list of product displayed
     
    private void refreshProducts() {
        
        // Get the list of all product for the given currency and start date
        this.productList = getFilteredZProductList(this.quote.zqu__Currency__c, this.quote.zqu__StartDate__c);
        
        // Since no product rate plans should be selected (neither any charge group) reset the sublists
        this.selectedProductIds     = new List<Id>();
        this.ratePlanList           = new List<zqu__ProductRatePlan__c>();
        this.selectedRatePlanIds    = new List<Id>();
        this.chargeGroupList        = new List<zqu.zChargeGroup>();
        
        // Only display the product panel
        this.displayProductsPanel           = true;
        this.displayProductRatePlanPanel    = false;
        this.displayChargeGroupPanel        = false;
    }
    
    
    /**
     *  Filter the product list
     
    private List<zqu__ZProduct__c> getFilteredZProductList(String zCurrency, Date zStartDate) {
        
        // The currency is stored at the product rate plan charge TIER level
        AggregateResult[] groupedResults = [
            SELECT
                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.Id
            FROM
                zqu__ProductRatePlanChargeTier__c
            WHERE
                zqu__Currency__c = : zCurrency
            AND
                zqu__Deleted__c = false
            GROUP BY
                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.ProductSortOrder__c,
                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.ID
            ORDER BY 
                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.ProductSortOrder__c              
        ];
        
        // Get the list of product Ids out of this aggregated query
        List<ID> productIds = new List<Id>();
        
        for (AggregateResult result : groupedResults)
            productIds.add(result.Id);
        
        // Query information from the product table
        List<zqu__ZProduct__c> products = [
            SELECT
                Name,
                zqu__Description__c,
                MinRatePlan__c,
                MaxRatePlan__c,
                ProductSortOrder__c,
                Selected_for_Quote__c,
                zqu__SKU__c
            FROM
                zqu__ZProduct__c
            WHERE
                Id IN :productIds
            AND
                zqu__Deleted__c = false
            AND
                zqu__EffectiveStartDate__c <= :zStartDate
            AND
                zqu__EffectiveEndDate__c >= :zStartDate
            ORDER BY
                ProductSortOrder__c ASC
            LIMIT
                10000
        ];
        
        System.debug('#### ' + products.size() + ' product(s) retrieved in the database');
        
        return products;
    }
    
    
    /**
     *  Return the list of filtered product rate plan Ids, while passing a set of product Ids
     
    private List<zqu__ProductRatePlan__c> getFilteredRatePlanList(Set<Id> zProductId, String zCurrency, Date zStartDate) {
    
        // Filter String is constructed based on the values selected in the Multiselect Picklists.
        // RegEx: (\(<FilterName>=\'<FilterValue>\'\) OR)* (<FilterName>=\'<FilterValue>\')\) AND)*
        String filterSoql = ' AND ';
        for(RatePlanFilter planFilter : planFilters){
            if(planFilter.selected != null && planFilter.selected != ''){
                filterSoql += '(';
                String fname = planFilter.name;
                String selectedValue = planFilter.selected;
                filterSoql += 'zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.' + planFilter.name + ' like \'%'+ selectedValue + '%\'';
                filterSoql += ') AND ';
            }
        }
        System.debug(filterSoql);

        // Create a Soql String to gather data based on default conditions, plus filter conditions.
        String groupedResultsSoql = 
            'SELECT '+
                'zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.Id '+
            'FROM '+
                'zqu__ProductRatePlanChargeTier__c '+
            'WHERE '+
                'zqu__Currency__c = :zCurrency '+
            filterSoql+
                'zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.Id IN : zProductID '+
            'GROUP BY '+
                'zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.Id';
        
                
        AggregateResult[] groupedResults = Database.query(groupedResultsSoql);

        /*
        String ProdIdString = '';
        for(ID id : zProductID){ ProdIdString += id + ' '; }
        appendMessage(ApexPages.Severity.INFO, 'Prod Ids: '+ProdIdString);
        appendMessage(ApexPages.Severity.INFO, 'Currency: '+zCurrency);
        appendMessage(ApexPages.Severity.INFO, groupedResultsSoql);
        String ReturnedPlanString ='';
        for(AggregateResult r : groupedResults){ ReturnedPlanString += r + ' '; }
        appendMessage(ApexPages.Severity.INFO, 'Returned Plans: ' + ReturnedPlanString);
        //


        
        // Get the list of rate plan Ids out of the aggregated results
        List <ID> ratePlanIds = new List <ID>();
        
        for (AggregateResult gr: groupedResults)
            ratePlanIds.add(gr.Id);
        
        // Get information for those rate plans
        List <zqu__ProductRatePlan__c> ratePlans =[
            SELECT
                Name,
                zqu__Description__c,
                Selected_for_Quote__c,
                zqu__ZProduct__r.Name
            FROM
                zqu__ProductRatePlan__c
            WHERE
                Id IN :ratePlanIds
            AND
                zqu__Deleted__c = false
            AND
                zqu__EffectiveStartDate__c <= :zStartDate
            AND
                zqu__EffectiveEndDate__c >= :zStartDate
            ORDER BY
                zqu__ZProduct__r.Name, Name ASC
            LIMIT
                10000
        ];
        
        System.debug('#### ' + ratePlans.size() + ' rate plan(s) retrieved in the database');
        
        return ratePlans;
    }
    
    private boolean updateQuoteWithFilterValues(){
        SObject s = [SELECT ID FROM zqu__Quote__c WHERE ID=:quote.Id LIMIT 1];
        for(RatePlanFilter rpf : planFilters){
            s.put(rpf.name, rpf.selected);
        }
        try{
            TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
            TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
            update s;
            TriggerHandler.RESET_VARIABLES();
            return true;
        } catch (Exception e){
            System.debug(e.getMessage());
        }
        return false;
    }*/
}