/**
 * This class contains unit tests for validating the behavior of Apex class 'OpportunityDowngrade'
 * Created By: Simplion Technologies.
 */
@isTest
private class OpportunityDowngradeTest {
    static testMethod void myUnitTest() {
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
        Oppval12.Brand_Name__c = 'RingCentral';
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
        insert Oppval12;
        Test.startTest();
        System.Debug('>>>>Oppval12.id>'+ Oppval12.id);
        ApexPages.currentPage().getParameters().put('Id',Oppval12.id);
        list<string> lstCXDetaildetail =new list<string>{'cell Phone only','Hosted PBX','Land line','Nothing','On-Premise PBX','Other Cloud PBX',
                                                         'Traditional','Prefers not to say'};                                              
        list<string> lstDownsell = new list<string>{'Couldn\'t get it working','Missing critical feature','Outages','QoS Voice','QoS Fax','Going out of business',
                                                    'Business slowing down / Closing location','Fewer employees','Temporary need / Testing','Too Expensive / Not worth the cost',
                                                    'Preferred number unavailable','Consolidating into other RC account','Switching devices','Not comfortable stating reason'};                                               
        list<string> lstHosted = new list<string>{'8x8','Fonality','Jive','Megapath'};
        list<string> lstWhatChanging = new list<string>{'Digital line(s)','Device(s)','Phone number(s)','Toll Free Bundle(s)','Premium Support','Service Change'};      
        //PageReference pageRef = Page.OpportunityDowngrade;
        //Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(Oppval12);
        
        OpportunityDowngrade testCRC = new OpportunityDowngrade(controller);        
        testCRC.getTraditionalOption();
        testCRC.getQOsdetailOption();
        testCRC.getOnPremisePBXOption();
        testCRC.getHostedPBXOption();
        testCRC.getWhichCXDetailOption();
        testCRC.getQOsdetailOption();
        testCRC.getDownsellReasonOption();
        testCRC.getFaxOption();
        testCRC.getmissingfeaturedetailOption();
        testCRC.getCouldnotworkingdetailOption(); 
        testCRC.getLandLineOption();
        testCRC.getCellPhoneOnlyOption();
        testCRC.getNothingOption();
        testCRC.getCostOption(); 
        testCRC.createformatDate(system.today());
        testCRC.getwhatsChangingPicListValue();
        testCRC.getHostedPBXListValue();
        testCRC.getCellPhoneOnlyListValue(); 
        testCRC.getLandLineListValue();
        testCRC.getTraditionalListValue();
        testCRC.getNothingListValue();
        testCRC.getConsolidatingAccount();
        testCRC.getSubDowngradeReasonReviews();
        testCRC.getSubDowngradeReasonPrice();
        testCRC.getSubDowngradeReasonMissingCriti();
        testCRC.getSubDowngradeReasonConcernsAbout();
        testCRC.getSubDowngradeReasonBandwidth();
        testCRC.getSubDowngradeReasonNotNew();
        testCRC.getSubDowngradeReasonUnableContact();
        testCRC.getSubDowngradeReasonNotBANT();
        testCRC.getdowngradeReasonOptionRingATNT();
        testCRC.getdowngradeReasonOptionRetention();
        testCRC.getdowngradeReasonOptionRingCentral();
        testCRC.getdowngradeReasonOptionLead();
        testCRC.getDelayedReasonOption();
	 	testCRC.getdowngradeReasonOptionRetention();
	 	testCRC.getHostedPBXOption();
	 	testCRC.getOnPremisePBXListValue();
 		testCRC.getLandLineListValue();
	 	testCRC.getNothingListValue();
	 	testCRC.getTraditionalListValue();
	 	testCRC.getConsolidatingAccount();
	 	testCRC.getConsolidatingAccountOption();
        
        testCRC.lstsectedFax.add('Distorted image') ;
        testCRC.lstselectedChangingReasons=lstWhatChanging;
        testCRC.lstsectedQOsdetail.add('');
        testCRC.lstsectedCXDetaildetail = lstCXDetaildetail;
        testCRC.lstsectedDownsellReasons = lstDownsell ;
        testCRC.lstsectedmissingfeature.add('Intercom');
        testCRC.lstselectedCouldnotworkingdetail.add('Product');
        testCRC.showcompanyCall();
        testCRC.showdetailCall();     
        testCRC.lstselectedCellPhoneOnly='Verizon';
        testCRC.lstsectedHostedPBXdetail = 'Fonality' ;
        testcrc.lstSelectedLandLine ='Comcast';
        testCRC.lstsectedOnPremisePBXdetail='Barracuda';
        testCRC.lstSelectedTraditional.add('CBeyond');      
        testCRC.cancel();
        testCRC.back();
        testCRC.onChangeReason();
        testCRC.selectedDowngradeReasons = 'Not BANT qualified';
        testCRC.onChangeReason();
        testCRC.selectedDowngradeReasons = 'Unable to contact';
        testCRC.onChangeReason();
        testCRC.selectedDowngradeReasons = 'Not a new prospect';
        testCRC.onChangeReason();
        testCRC.selectedDowngradeReasons = 'Bandwidth / Wiring';
        testCRC.onChangeReason();
        testCRC.selectedDowngradeReasons = 'Concerns about reliability / usability / support';
        testCRC.onChangeReason();
        testCRC.selectedDowngradeReasons = 'Missing critical features';
        testCRC.onChangeReason();
        testCRC.selectedDowngradeReasons = 'Price';
        testCRC.onChangeReason();
        testCRC.selectedDowngradeReasons = 'Reviews';
        testCRC.onChangeReason();
        //testCRC.selectedDowngradeReasons = 'Other';
        //testCRC.onChangeReason();
        //testCRC.onChangeSubReason();
        testCRC.updateOpp();
        testCRC.selectedDowngradeReasons = 'Hosted PBX';
     	testCRC.onChangeSubReason();
     	testCRC.sectedSubDowngradeReason = 'Aviya';
     	testCRC.Next();
     	testCRC.strSelectedIssueWithRC = 'leadDownGradeObj1';
     	testCRC.onChangeIssueWithRC();
     	testCRC.strSelectedSubIssueWithRC = 'Location not wired for Ethernet';
     	testCRC.onChangeSubIssueWithRC();
     	testCRC.updateOpp();
        testCRC.Next();       
        testCRC.showOtherSubCompetitorBox();
        
        Test.stopTest();
    }
}