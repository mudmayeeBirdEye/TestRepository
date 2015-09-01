/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Z_MultiSelectProduct_TEST {

    /*static testMethod void testDisplayNoQuoteFound() {
        
        Test.startTest();
        
        ApexPages.Standardcontroller stdController = new ApexPages.StandardController(new zqu__Quote__c());
        Z_MultiSelectProductWrappedController ctl = new Z_MultiSelectProductWrappedController(stdController);
        
        Test.stopTest();
    }
    
    
    static testMethod void testDisplayWrongQuoteId() {
        EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
              if(mycs == null) {
                mycs = new EntitlementEnable__c();
                mycs.IsEntitlementsEnabled__c = true;
                mycs.Name = 'IsEntitlementsEnabled';
                insert mycs;
            }
        // Create a non-quote object (to get a correct ID but wrong object)
        Account acc = Z_TestFactory.makeAccount();
        
        Test.startTest();
        
        ApexPages.Standardcontroller stdController = new ApexPages.StandardController(acc);
        Z_MultiSelectProductWrappedController ctl = new Z_MultiSelectProductWrappedController(stdController);
        
        Test.stopTest();
    }
    
    
    static testMethod void testDisplayNoProduct() {
        EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
              if(mycs == null) {
                mycs = new EntitlementEnable__c();
                mycs.IsEntitlementsEnabled__c = true;
                mycs.Name = 'IsEntitlementsEnabled';
                insert mycs;
            }
        // Create the quote object
        Account acc = Z_TestFactory.makeAccount();
        Opportunity opp = Z_TestFactory.makeOpportunity(acc);
        zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
        
        Test.startTest();
        
        ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
        Z_MultiSelectProductWrappedController ctl = new Z_MultiSelectProductWrappedController(stdController);
        
        Test.stopTest();
    }
    
    
    static testMethod void testDisplayProducts() {
        
        EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
              if(mycs == null) {
                mycs = new EntitlementEnable__c();
                mycs.IsEntitlementsEnabled__c = true;
                mycs.Name = 'IsEntitlementsEnabled';
                insert mycs;
            }
        // Setup the product catalog
        zqu__ZProduct__c product = Z_TestDataSetup.prepareProductCatalog();
        
        // Create the quote object
        Account acc = Z_TestFactory.makeAccount();
        Opportunity opp = Z_TestFactory.makeOpportunity(acc);
        zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
        
        // Update quote information
        quote.zqu__Currency__c = 'USD';
        quote.zqu__StartDate__c = Date.today().addDays(1);
        update quote;
        
        Test.startTest();
        
        ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
        Z_MultiSelectProductWrappedController ctl = new Z_MultiSelectProductWrappedController(stdController);
        
        // Select the product in the VF page
        for (zqu__ZProduct__c p : ctl.productList)
            p.Selected_for_Quote__c = true;
        
        // Display the product rate plan
        ctl.displayProductRatePlan();
        
        // Display the charge group (no rate plan selected)
        ctl.displayChargeGroup();
        
        // Select all rate plans
        for (zqu__ProductRatePlan__c prp : ctl.ratePlanList) {
            prp.Selected_for_Quote__c = true;
        }
        
        // Display the charge groups 
        ctl.displayChargeGroup();
        Test.stopTest();
    }
    
    // Negative tests
    static testMethod void testDisplayProducts3() {
        
        EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
              if(mycs == null) {
                mycs = new EntitlementEnable__c();
                mycs.IsEntitlementsEnabled__c = true;
                mycs.Name = 'IsEntitlementsEnabled';
                insert mycs;
            }
        // Setup the product catalog
        zqu__ZProduct__c product = Z_TestDataSetup.prepareProductCatalog();
        
        // Create the quote object
        Account acc = Z_TestFactory.makeAccount();
        Opportunity opp = Z_TestFactory.makeOpportunity(acc);
        zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
        
        // Update quote information
        quote.zqu__Currency__c = 'USD';
        quote.zqu__StartDate__c = Date.today().addDays(1);
        update quote; 
        
        Test.startTest();
        
        ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
        Z_MultiSelectProductWrappedController ctl = new Z_MultiSelectProductWrappedController(stdController);
        // Select the product in the VF page
        for (zqu__ZProduct__c p : ctl.productList)
            p.Selected_for_Quote__c = true;
        
        // Display the product rate plan
        ctl.displayProductRatePlan();
        
        // Display the charge group (no rate plan selected)
        ctl.displayChargeGroup();
        
        // Select all rate plans
        for (zqu__ProductRatePlan__c prp : ctl.ratePlanList) {
            system.debug(' @@@@@@@@@@@@ ' + prp.Selected_for_Quote__c+ ' @@@@@@@@@@@@');
            prp.Selected_for_Quote__c = true;
        }
        
        // Display the charge groups 
        ctl.displayChargeGroup();
        Test.stopTest();
    }    
        
    
    static testMethod void testDisplayProducts1() {
         EntitlementEnable__c mycs = EntitlementEnable__c.getValues('IsEntitlementsEnabled__c');
              if(mycs == null) {
                mycs = new EntitlementEnable__c();
                mycs.IsEntitlementsEnabled__c = true;
                mycs.Name = 'IsEntitlementsEnabled';
                insert mycs;
            }
        zqu__ZProduct__c product = Z_TestDataSetup.prepareProductCatalog();
        
        // Create the quote object
        Account acc = Z_TestFactory.makeAccount();
        Opportunity opp = Z_TestFactory.makeOpportunity(acc);
        zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
        
        // Update quote information
        quote.zqu__Currency__c = 'USD';
        quote.zqu__StartDate__c = Date.today().addDays(1);
        update quote;
        
        Test.startTest();
        
        ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
        Z_MultiSelectProductWrappedController ctl = new Z_MultiSelectProductWrappedController(stdController);
        
        // Change the charge group values (qty, price, etc.)
        ctl.quantityChange();
        ctl.effectiveChange();
        
        // Add the charges to the quote
        ctl.saveAndNewCharges();
        ctl.saveCharges();
        
        // Add the charges to the quote (with exception throwing)
        ctl.throwException = true;
        ctl.saveAndNewCharges();
        ctl.saveCharges();
        
        Test.stopTest();
    }*/
    

}