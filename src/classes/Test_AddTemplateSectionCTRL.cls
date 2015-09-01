@isTest
private class Test_AddTemplateSectionCTRL {

    static testMethod void myUnitTest() {
    	
    	TemplateSections__c templateSecObj = new TemplateSections__c(Name='testSection',Content_1__c='testDatatestDatatestDatatestData',Description__c='testDescription');
    	insert templateSecObj;
    	
    	insert new Merge_Fields_Mapping__c(Name = 'Account',Display_Name__c='Account',Dependency__c='Opportunity',Dependent_Relationship_Name__c='AccountId');
    	
    	ApexPages.StandardController controller = new ApexPages.StandardController(templateSecObj);
    	
        AddTemplateSectionCTRL classObj = new AddTemplateSectionCTRL(controller);
        AddTemplateSectionCTRL.TemplateSectionWrapper test = new AddTemplateSectionCTRL.TemplateSectionWrapper();
        classObj.saveSection();
        classObj.cancelRecord();
    }
}