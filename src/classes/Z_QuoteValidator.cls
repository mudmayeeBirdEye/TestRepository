/*

Author:         Mickael Pham <mickael.pham@zuora.com>

Date created:   May 15, 2013

Date modified:  May 16, 2013

Comment:        This class is an utility class with methods to validate a quote
                either before adding charge(s) to a quote or before sending it
                to Z-Billing.

*/

public with sharing class Z_QuoteValidator {

    //public static List<String> FILTER_NAMES = new List<String>{'filter1__c', 'filter2__c', 'filter3__c', 'filter4__c'};
    
    // ------------------------------------------------------------------------
    // Public static method(s)
    // ------------------------------------------------------------------------
    
    /*
       Validate that a list of charge group can be added to the quote
     
    public static Z_CheckResult validateQuote(String quoteId, List<zqu.ZChargeGroup> chargeGroupsToAdd) {
        
        // Check if all the charge to be added are of TYPE_PRODUCT_NEW
        for (zqu.ZChargeGroup chargeGroup : chargeGroupsToAdd) {
            if (chargeGroup.groupType != zqu.ZChargeGroup.TYPE_PRODUCT_NEW) {
                // Exit and return an error message
                return new Z_CheckResult(false,
                        'All the charge groups to be added must be of type [new product]');
            }
        }
        
        // Get the list of existing charge(s) associated with the quote
        List<zqu.ZChargeGroup> existingChargeGroups = zqu.ZQuoteUtil.getChargeGroups(quoteId);
        
        // Combine both list so we can query for all product(s)
        List<zqu.ZChargeGroup> allChargeGroups = new List<zqu.ZChargeGroup>();
        allChargeGroups.addAll(chargeGroupsToAdd);
        allChargeGroups.addAll(existingChargeGroups);
        
        // Set the product map (associate a product SFDC ID with it's MAX and MIN values)
        Map<String, ProductRange> productRangeMap = getProductRangeMap(allChargeGroups);
        
        // From a list of charge group, get the list of associated product rate plan
        List<zqu__ProductRatePlan__c> prpToAdd = getProductRatePlanList(chargeGroupsToAdd, quoteId);
        List<zqu__ProductRatePlan__c> prpExisting = getProductRatePlanList(existingChargeGroups, quoteId);
        
        // Prepare a map to count the # of product rate plan / product
        Map<String, Integer> countProductRatePlan = new Map<String,Integer>();
        
        for (String key : productRangeMap.keySet()) {
            countProductRatePlan.put(key, 0);
        }
        
        // Prepare a map to get the required number of plans for ALL Products.
        Map<String, ProductRange> productMinMap = getProductMinMap();
        
        // Set the initial count of product rate plan (without the ones being added)
        for (zqu__ProductRatePlan__c prp : prpExisting) {
            Integer current = countProductRatePlan.get(prp.zqu__ZProduct__r.Id);
            countProductRatePlan.put(prp.zqu__ZProduct__r.Id, current + 1);
        }
        
        // Prepare a quote with all filters
        zqu__Quote__c quoteWithFilters = getQuoteFilterValues(quoteId);
        
        // Prepare the return object
        Z_CheckResult result = new Z_CheckResult(true);
        
        // Now, goes through the list of to be added product rate plan and log error if any
        for (zqu__ProductRatePlan__c prp : prpToAdd) {
            Integer current = countProductRatePlan.get(prp.zqu__ZProduct__r.Id);
            countProductRatePlan.put(prp.zqu__ZProduct__r.Id, current + 1);
        }

        // For each existing rateplan, ensure the current filters still agree with the filters set up for the Quote.
        boolean filterSuccess = true;

        for (zqu__ProductRatePlan__c prp : prpExisting){
            if(!checkFilterValuesAgainstPlan(quoteWithFilters, prp)){
                // This rateplan does not match one or more quote filters
                result.isValid = false;
                result.msgList.add('Product Rate Plan \''+ prp.Name + '\' does not match the filters identified for this quote.');
            }
        }

        // Log the error after adding all the charges in order to get all the error messages
        for (zqu__ProductRatePlan__c prp : prpToAdd) {
            Integer numPlans = countProductRatePlan.get(prp.zqu__ZProduct__r.Id);
            Integer maxPlans = productRangeMap.get(prp.zqu__ZProduct__r.Id).max;
            if (productRangeMap.get(prp.zqu__ZProduct__r.Id).max != 0
                    && numPlans > maxPlans) {
                
                // Too many rate plan under the same product
                result.isValid = false;
                
                result.msgList.add('Plan "' + prp.Name + '" can not be added to the quote. '
                        + 'The current number of plans ('+numPlans+') exceeds the maximum number ' 
                        + 'of plans (' + maxPlans
                        + ') for the Product Group "' + prp.zqu__ZProduct__r.Name
                        + '". Please remove "' + prp.Name + '" or another Plan '
                        + 'from the same Product Group to continue.');

            }
        }

        // For all Products in the Catalog, ensure the minimum requirement is met
        for(String prodKey : productMinMap.keyset()){
            // Print message if the Product's minimum value is less than the corresponding Rateplan count
            Integer pCount = countProductRatePlan.get(prodKey)!=null ? countProductRatePlan.get(prodKey) : 0;
            Integer minValue = productMinMap.get(prodKey).min;
            System.debug(
                'prod ' + productMinMap.get(prodKey).name + ' ' + minValue + ' count ' + pCount);
            if (minValue > pCount){
                
                // Not enough rate plans under the same product
                result.isValid = false;
                
                result.msgList.add('The minimum requirement for Product ('+productMinMap.get(prodKey).Name+') has not been reached. '
                        + 'Ensure that ' +minValue
                        + ' or more plans from this Product have '
                        + 'been added to this quote.');
            }
        }
        return result;
    }

    // ------------------------------------------------------------------------
    // Private method(s)
    // ------------------------------------------------------------------------
    
    /**
     *  Return the MIN and MAX value associated with each product from a charge group list
     
    private static Map<String, ProductRange> getProductRangeMap(List<zqu.ZChargeGroup> chargeGroupList) {
        
        // Get a set of SFDC ID for all product rate plan charge
        Set<ID> chargeIDs = new Set<ID>();
        
        for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
            for (zqu.ZCharge charge : chargeGroup.zCharges) {
                chargeIDs.add(charge.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID);
            }
        }
        
        // Get a set of SFDC ID for all product rate plan charge
        AggregateResult[] groupedResults = [
            SELECT
                zqu__ProductRatePlan__r.zqu__ZProduct__r.Id
            FROM
                zqu__ProductRatePlanCharge__c
            WHERE
                Id IN :chargeIDs
            GROUP BY
                zqu__ProductRatePlan__r.zqu__ZProduct__r.Id
        ];
        
        // Get the list of product Ids out of this aggregated query
        List<ID> productIds = new List<Id>();
        
        for (AggregateResult result : groupedResults)
            productIds.add(result.Id);
        
        // Query information from the product table
        List<zqu__ZProduct__c> productList = [
            SELECT
                MaxRatePlan__c,MinRatePlan__c
            FROM
                zqu__ZProduct__c
            WHERE
                Id IN :productIds
        ];
        
        // Generate the map to be returned
        Map<String, ProductRange> rangeMap = new Map<String, ProductRange>();
        
        for (zqu__ZProduct__c product : productList) {
            // Test the value stored in the custom field for Min
            Integer minValue = 0;
            if (String.isNotBlank(product.MinRatePlan__c) && product.MinRatePlan__c.isNumeric()) {
                minValue = Integer.valueOf(product.MinRatePlan__c);
            }
            // Test the value stored in the custom field for Max
            Integer maxValue = 0;
            if (String.isNotBlank(product.MaxRatePlan__c) && product.MaxRatePlan__c.isNumeric()) {
                maxValue = Integer.valueOf(product.MaxRatePlan__c);
            }
            ProductRange prodRange = new ProductRange(minValue, maxValue);
            rangeMap.put(product.Id, prodRange);
        }
        
        return rangeMap;
    }

    /**
     *  Return the MIN value associated with all Products with a requirement
     *
    private static Map<String, ProductRange> getProductMinMap() {
        
        // Get a set of SFDC ID for all product rate plan charge
        List<zqu__ZProduct__c> productList = [
            SELECT
                Id, MinRatePlan__c, MaxRatePlan__c, Name
            FROM
                zqu__ZProduct__c
            WHERE
                zqu__Deleted__c = false
        ];
        
        // Generate the map to be returned
        Map<String, ProductRange> productMinMap = new Map<String, ProductRange>();
        
        for (zqu__ZProduct__c product : productList) {
            // Test the value stored in the custom field for Min
            Integer minValue = 0;
            if (String.isNotBlank(product.MinRatePlan__c) && product.MinRatePlan__c.isNumeric()) {
                minValue = Integer.valueOf(product.MinRatePlan__c);
            }
            ProductRange productRange = new ProductRange(minValue,0);
            productRange.Name = product.Name;
            productMinMap.put(product.Id, productRange);
        }
        
        return productMinMap;
    }
    
    /**
     *  Return the product list based on a list of ZChargeGroup, removing the
     *  ZChargeGroup in a deleted status
     *
    private static zqu__Quote__c getQuoteFilterValues(String quoteId){
        String filterString = '';
        for(String filterName : FILTER_NAMES){
            filterString += filterName + ', ';
        }
        
        String filterValueSoql = 
            'SELECT '
                +filterString
                +'ID '
            +'FROM '
                +'zqu__Quote__c '
            +'WHERE '
                +'Id =\''+quoteId+'\' '
            +'LIMIT 1';
                
        zqu__Quote__c fquote = Database.query(filterValueSoql);
        
        return fquote;
    }
    
    private static boolean checkFilterValuesAgainstPlan(zqu__Quote__c fq, zqu__ProductRatePlan__c prp){
        for(String filterName : FILTER_NAMES){
            SObject sObjq = fq;
            SObject sObjp = prp;
            String fqs = (String) sObjq.get(filterName);
            String fps = (String) (sObjp.get(filterName)==null?'':sObjp.get(filterName));
            if(fqs!=null && !fps.contains(fqs)){
                return false;
            }
        }
        return true;
    }
    
    /**
     *  Return the product list based on a list of ZChargeGroup, removing the
     *  ZChargeGroup in a deleted status
     *
    private static List<zqu__ProductRatePlan__c> getProductRatePlanList(List<zqu.ZChargeGroup> chargeGroupList, String quoteId) {
        
        // Get a set of SFDC ID for all product rate plan charge
        Set<ID> chargeIDs = new Set<ID>();
        
        for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
            if (chargeGroup.groupType != zqu.ZChargeGroup.TYPE_AMENDMENT_REMOVEPRODUCT
                    && chargeGroup.groupType != zqu.ZChargeGroup.TYPE_RENEWAL_REMOVEPRODUCT) {
                for (zqu.ZCharge charge : chargeGroup.zCharges) {
                    chargeIDs.add(charge.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID);
                }
            }
        }
        
        // Get a set of product rate plan ID
        AggregateResult[] groupedResults = [
            SELECT
                zqu__ProductRatePlan__r.Id
            FROM
                zqu__ProductRatePlanCharge__c
            WHERE
                Id IN :chargeIDs
            GROUP BY
                zqu__ProductRatePlan__r.Id
        ];
        
        // Get the list of product rate plan IDs out of this aggregated query
        List<ID> prpIds = new List<ID>();
        
        for (AggregateResult result : groupedResults)
            prpIds.add(result.Id);
        
        String filterString = '';
        for(String filterName : FILTER_NAMES){
            filterString += filterName + ', ';
        }
        
        String filterValueSoql = 
            'SELECT '
                +'ID '
            +'FROM '
                +'zqu__Quote__c '
            +'WHERE '
                +'ID =\''+quoteId+'\' '
            +'LIMIT 1';
        
        
        // Query information from the product rate plan table
        String prpSoql =
            'SELECT '
                +filterString
                +'Name, '
                +'zqu__ZProduct__r.Id, '
                +'zqu__ZProduct__r.Name '
            +'FROM '
                +'zqu__ProductRatePlan__c '
            +'WHERE '
                +'Id IN :prpIds ';
        
        List<zqu__ProductRatePlan__c> prpList = Database.query(prpSoql);
        
        return prpList;
    }
    
    // ------------------------------------------------------------------------
    // Inner class(es)
    // ------------------------------------------------------------------------

    /**
     *  The inner class returned by the validator (give more information than
     *  a simple boolean)
     *
    public class Z_CheckResult {
        
        /* Flag, set to TRUE if the quote is valid 
        public Boolean isValid;
        
        /* List of messages during the validation process *
        public List<String> msgList;
        
        /**
         *  Constructor with a flag
         *
        public Z_CheckResult(Boolean isValid) {
            this.isValid = isValid;
            this.msgList = new List<String>();
        }
        
        /**
         *  Constructor with a flag and a message
         *
        public Z_CheckResult(Boolean isValid, String message) {
            this.isValid = isValid;
            this.msgList = new List<String> { message };
        }
        
    }
    
    /**
     * The inner class returned by the validator to map both min and max values of all rateplans being added.
     *
    public class ProductRange{
        public String name {get;set;}
        public Integer min {get;set;}
        public Integer max {get;set;}
        public ProductRange (Integer min, Integer max){
            this.min = min;
            this.max = max;
        }
    }*/
    
    
}