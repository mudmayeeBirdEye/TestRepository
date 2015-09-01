@isTest
public class Test_ProductCatalogControlPanelCTRL {

	static testMethod void myUnitTest() {
		RC_Product__c objProduct1 = new RC_Product__c();
        objProduct1.Name ='Service1';
        objProduct1.Category__c = 'Service';
        objProduct1.Charge_Term__c = 'Annual';
        objProduct1.Service_Type__c = 'Office';
        objProduct1.SKU__c  = 'SKU10';
        objProduct1.Dependent_SKUs__c = 'SKU2';	        
        insert objProduct1;
        
        RC_Product_Line_Item__c objProductLinItm1 = new RC_Product_Line_Item__c();
		objProductLinItm1.Name = 'test1';
		objProductLinItm1.RC_Product__c= objProduct1.id;
		objProductLinItm1.Lower_Limit__c = 0;
		objProductLinItm1.Upper_Limit__c = 10;
		objProductLinItm1.Price__c = 10;
		objProductLinItm1.RC_Currency__c = 'USD';
		objProductLinItm1.isActive__c = true;
		objProductLinItm1.Allowed_Record_Type__c = 'Sales Opportunity';
		objProductLinItm1.Max_Discount__c = 1;			
		insert objProductLinItm1;
		
		TemplateSections__c templateSecObj = new TemplateSections__c(Name='testSection',Content_1__c='testDatatestDatatestDatatestData',Description__c='testDescription');
    	insert templateSecObj;
    	
    	RC_Quote_Template__c quoteTemplate = new RC_Quote_Template__c(Name='testTemplate',Brand__c='RingCentral',Description__c='testDescription',Type__c='Quote; Agreement');
    	insert quoteTemplate;
    	
    	ProductCatalogControlPanelCTRL classObj = new ProductCatalogControlPanelCTRL();
    	classObj.selectedTemplate = quoteTemplate.Id;
    	classObj.removeTemplate();
    	classObj.selectedSection = templateSecObj.id;
    	classObj.removeSection();
	}

}