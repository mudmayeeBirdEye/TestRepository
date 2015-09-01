/*

Author:     Mickael Pham <mickael.pham@zuora.com>

Created:    May 6, 2013

Modified:   May 13, 2013

Comment:    This is the controller class to allow multiple selection of product
            and product rate plans (instead of going with x1 product and then
            x1 product rate plans) and add them all at once on the associated quote

*/

public with sharing class Z_MultiSelectProduct {

    // ------------------------------------------------------------------------
    // Public VF Attributes
    // ------------------------------------------------------------------------
    
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
    public class wChargeGroup {
        public zqu.zChargeGroup zChargeGroup {get;set;}
        public List<wCharge> wCharges {get;set;}
    }
    
    /* Wrapped Charge to store Custom Fields 
    public class wCharge {
        public zqu.zCharge zCharge {get;set;}
        public String PAccess {get;set;}
    }
    
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
     
    public Z_MultiSelectProduct(ApexPages.StandardController controller) {
        
        // Set the controller in attribute
        this.controller = controller;
        
        // Before validation
        this.initSuccess = false;
        
        // Don't throw a test exception
        throwException = false;
        
        if (!validate())
            return;
        
        refreshProducts();
        
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
     *  Get all the charge group associated with the selected rate plans
     
    public PageReference displayChargeGroup() {
        
        // Get the IDs of the selected rate plan(s) on the VF page
        List<Id> selectedRatePlanIds = new List<Id>();
        
        for (zqu__ProductRatePlan__c ratePlan : ratePlanList) {
            
            if (ratePlan.Selected_for_Quote__c)
                selectedRatePlanIds.add(ratePlan.Id);
            
        }
        
        // Get the associated charge groups
        if (selectedRatePlanIds.size() > 0) {
            this.chargeGroupList = zqu.zQuoteUtil.getChargeGroups(quote.Id, selectedRatePlanIds);
            
            // Validate the quote (to display errror message if any)
            Z_QuoteValidator.Z_CheckResult result = Z_QuoteValidator.validateQuote(quote.Id, chargeGroupList);
            
            if (!result.isValid) {
                for (String msg : result.msgList) {
                    appendMessage(ApexPages.Severity.ERROR, msg);
                }
            }
            
        } else {
            // Reset the list
            this.chargeGroupList = new List<zqu.zChargeGroup>();    
        }
        
        // Display the charge group panel
        this.displayChargeGroupPanel = true;
        
        return null;
    }
    /**
     * On quantity change
     
    public void quantityChange() {
        for (zqu.zChargeGroup currentChargeGroup : chargeGroupList) {
            List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnQuantityChange(
                currentChargeGroup.zCharges
            );
            currentChargeGroup.zCharges = charges;
        }
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
            
            // Get back to the quote
            PageReference pageRef = new PageReference('/' + quote.Id);
            return pageRef;
        
        } else {
            
            // The quote is invalid, display the message and stay on the page
            for (String msg : result.msgList) {
                appendMessage(ApexPages.Severity.ERROR, msg);
            }
            
        }
        
        return null;
    }
    
    /**
     *  Save the charge groups to the quote and return to the product selector
     
    public PageReference saveAndNewCharges() {
        
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
            
            // Get back to the product selector
            PageReference pageRef = Page.Z_MultiSelectProduct;
            pageRef.getParameters().put('Id', this.quote.Id);
            pageRef.setRedirect(true);
            
            return pageRef;
        
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
                zqu__Currency__c
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
                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.Id
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
                Name ASC
            LIMIT
                10000
        ];
        
        System.debug('#### ' + products.size() + ' product(s) retrieved in the database');
        
        return products;
    }
    
    
    /**
     *  Return the list of filtered product rate plan Ids, while passing a set of product Ids
     
    private List<zqu__ProductRatePlan__c> getFilteredRatePlanList(Set<Id> zProductId, String zCurrency, Date zStartDate) {
    
        AggregateResult[] groupedResults = [
            SELECT
                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.Id
            FROM
                zqu__ProductRatePlanChargeTier__c
            WHERE
                zqu__Currency__c = : zCurrency
            AND
                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.Id IN : zProductID
            GROUP BY
                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.Id
        ];
        
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
    }*/

}