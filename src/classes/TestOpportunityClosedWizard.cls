@isTest
private class TestOpportunityClosedWizard {

    static testMethod void opportunityWizardTest() { 
        Account acctest12 = new Account();
        acctest12.Name='TestAccount12';
        acctest12.RC_Attribution_Channel__c = 'National Accounts';
        acctest12.Partner_ID__c ='123';
        acctest12.RecordTypeId  = '01280000000UERq';
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        insert acctest12;
        Opportunity Oppval12 = new Opportunity();
        Oppval12.Name = 'Test Opp12';
        Oppval12.AccountId = acctest12.Id;
        Oppval12.Type = 'Existing Business';
        Oppval12.StageName = '3. ActivePipe';
        Oppval12.Sales_Model__c = 'Direct';
        Oppval12.CloseDate = System.Today() + 10;
        Oppval12.CurrencyIsoCode = 'USD';
        Oppval12.Brand_Name__c= 'RingCentral';
        Oppval12.RecordTypeId = '01280000000UEtu';
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
        insert Oppval12;
        
        Test.startTest(); 
        ApexPages.currentPage().getParameters().put('id', Oppval12.id);
        
        OpportunityClosedWizard obj = new OpportunityClosedWizard(new ApexPages.StandardController(Oppval12));
        obj.getHostedPBX();
        obj.getHostedPBX1();
        obj.getHostedPBXRCandRCCanada();
        obj.getHostedPBXRCUK();
        obj.getOnPremisePBX();
        obj.getOnPremisePBX1();
        obj.getWhoDidWeBeat();
        obj.getWhoWhatAreWeReplacing();
        obj.cancel();
        obj.showtoOtherOnPremisePBX1();
        obj.showtoOtherHostedPBX1();
        obj.showtoOtheronPremisePBX();
        obj.showtoOtherHostedPBX();
        obj.showSubSectionOfWhoDidWeBeat();
        obj.showSubSectionOfWhoDidWeBeat1();
        obj.strSelectedWhoDidWeBeat = 'On-Premise PBX';
        obj.strSelectedWhoDidWeBeat1 = 'On-Premise PBX';
        obj.showSubSectionOfWhoDidWeBeat();
        obj.showSubSectionOfWhoDidWeBeat1();
        obj.strSelectedWhoDidWeBeat = 'Hosted PBX';
        obj.strSelectedWhoDidWeBeat1 = 'Hosted PBX';
        obj.showSubSectionOfWhoDidWeBeat();
        obj.showSubSectionOfWhoDidWeBeat1();
        obj.OpportunityUpdate();
        obj.strSelectedWhoDidWeBeat = 'Land Lines';
        obj.strSelectedWhoDidWeBeat1 = 'Land Lines';
        obj.OpportunityUpdate();
        obj.strSelectedWhoDidWeBeat = 'On-Premise PBX';
        obj.strsectedOnPremisePBXdetail = 'Cisco';
        obj.strSelectedWhoDidWeBeat1 = 'Hosted PBX';
        obj.strsectedHostedPBXdetail1 = 'Mitel';
         obj.OpportunityUpdate();
        Test.stopTest();
    }
}