@isTest
private class TestOpportunityAll {
     
    static testMethod void myUnitTest1() {
          
       Cancel_Request__c objCRC = new Cancel_Request__c();
       list<string> lstCXDetaildetail =new list<string>{'cell Phone only','Hosted PBX','Land line','Nothing','On-Premise PBX','Other Cloud PBX',
                                                        'Traditional','Prefers not to say'};                                          
       list<string> lstCancReasons = new list<string>{'Couldn\'t get it working','Missing critical feature','Outages','QoS Voice','QoS Fax','Going out of business',
                                                      'Business slowing down / Closing location','Fewer employees','Temporary need / Testing','Too Expensive / Not worth the cost',
                                                      'Preferred number unavailable','Consolidating into other RC account','Switching devices','Not comfortable stating reason'};                                             
       list<string> lstHosted = new list<string>{'8x8','Fonality','Jive','Megapath'};          
       ApexPages.StandardController controller = new ApexPages.StandardController(objCRC );
       CancellationReasonsController testCRC= new CancellationReasonsController(controller );
       testCRC.lstsectedFax.add('Distorted image') ;
       testCRC.lstsectedQOsdetail.add('Echo');
       testCRC.lstsectedCXDetaildetail = lstCXDetaildetail;
       system.assertNotEquals(testCRC.lstsectedCXDetaildetail, null);
       testCRC.lstsectedCancReasons = lstCancReasons;
       system.assertNotEquals(testCRC.lstsectedCancReasons, null);
       testCRC.lstsectedmissingfeature.add('Intercom');
       testCRC.lstselectedCouldnotworkingdetail.add('Product');
       testCRC.showcompanyCall();
       testCRC.showdetailCall();      
       testCRC.lstselectedCellPhoneOnly.add('Verizon');
       testCRC.lstsectedHostedPBXdetail = lstCancReasons;
       testcrc.lstSelectedLandLine.add('Comcast');
       testCRC.lstsectedOnPremisePBXdetail.add('Barracuda');
       testCRC.lstSelectedTraditional.add('CBeyond');
       testCRC.cancel();
       testCRC.create();
       testCRC.skip();
       testCRC.Next();        
       testCRC.getHostedPBXOption();
       system.assertNotEquals(testCRC.getHostedPBXOption(), null);
       testCRC.getTraditionalOption();
       system.assertNotEquals(testCRC.getTraditionalOption(), null);
       testCRC.getQOsdetailOption();
       system.assertNotEquals( testCRC.getQOsdetailOption(), null);
       testCRC.getOnPremisePBXOption();
       system.assertNotEquals(testCRC.getOnPremisePBXOption(), null);
       testCRC.getQOsdetailOption();
       system.assertNotEquals(testCRC.getQOsdetailOption(), null);
       testCRC.getCancellationReasonOption();
       system.assertNotEquals(testCRC.getCancellationReasonOption(), null);
       testCRC.getWhichCXDetailOption();
       system.assertNotEquals(testCRC.getWhichCXDetailOption(), null);
       testCRC.getFaxOption();
       system.assertNotEquals(testCRC.getFaxOption(), null);
       testCRC.getmissingfeaturedetailOption();
       system.assertNotEquals( testCRC.getmissingfeaturedetailOption(), null);
       testCRC.getCouldnotworkingdetailOption();
       system.assertNotEquals(testCRC.getCouldnotworkingdetailOption(), null);
       testCRC.getLandLineOption();
       system.assertNotEquals(testCRC.getLandLineOption(), null);
       testCRC.getCellPhoneOnlyOption();
       system.assertNotEquals(testCRC.getCellPhoneOnlyOption(), null); 
       testCRC.getCostOption(); 
       testCRC.getNothingOption();        
     }
     
    static testMethod void  myUnitTest2() {
        Opportunity objOpp = new Opportunity();
        
        list<string> lstCXDetaildetail =new list<string>{'cell Phone only','Hosted PBX','Land line','Nothing','On-Premise PBX','Other Cloud PBX',
                                                         'Traditional','Prefers not to say'};                                              
        list<string> lstDownsell = new list<string>{'Couldn\'t get it working','Missing critical feature','Outages','QoS Voice','QoS Fax','Going out of business',
                                                    'Business slowing down / Closing location','Fewer employees','Temporary need / Testing','Too Expensive / Not worth the cost',
                                                    'Preferred number unavailable','Consolidating into other RC account','Switching devices','Not comfortable stating reason'};                                               
        list<string> lstHosted = new list<string>{'8x8','Fonality','Jive','Megapath'};
        list<string> lstWhatChanging = new list<string>{'Digital line(s)','Device(s)','Phone number(s)','Toll Free Bundle(s)','Premium Support','Service Change'};      
        ApexPages.StandardController controller = new ApexPages.StandardController(objOpp);
        OpportunityDownsell testCRC = new OpportunityDownsell(controller);        
        testCRC.lstsectedFax.add('Distorted image') ;
        testCRC.lstselectedChangingReasons=lstWhatChanging;
        testCRC.lstsectedQOsdetail.add('');
        testCRC.lstsectedCXDetaildetail = lstCXDetaildetail;
        testCRC.lstsectedDownsellReasons = lstDownsell ;
        testCRC.lstsectedmissingfeature.add('Intercom');
        testCRC.lstselectedCouldnotworkingdetail.add('Product');
        testCRC.showcompanyCall();
        testCRC.showdetailCall();     
        testCRC.lstselectedCellPhoneOnly.add('Verizon');
        testCRC.lstsectedHostedPBXdetail = lstHosted ;
        testcrc.lstSelectedLandLine.add('Comcast');
        testCRC.lstsectedOnPremisePBXdetail.add('Barracuda');
        testCRC.lstSelectedTraditional.add('CBeyond');      
        testCRC.cancel();
        testCRC.create();
        testCRC.skip();
        testCRC.Next();       
        testCRC.getTraditionalOption();
        testCRC.getQOsdetailOption();
        testCRC.getOnPremisePBXOption();
        testCRC.getHostedPBXOption();
        testCRC.getWhichCXDetailOption();
        testCRC.getQOsdetailOption();
        testCRC.getDownsellReasonOption();
        testCRC.getchangingOption();
        testCRC.getFaxOption();
        testCRC.getmissingfeaturedetailOption();
        testCRC.getCouldnotworkingdetailOption();
        testCRC.getLandLineOption();
        testCRC.getCellPhoneOnlyOption();
        testCRC.getNothingOption();
        testCRC.getCostOption();        
    }
    
    static testMethod void  myUnitTest3() {
       Opportunity objOpp1 = new Opportunity();
       list<string> lstCXDetaildetail =new list<string>{'cell Phone only','Hosted PBX','Land line','Nothing','On-Premise PBX','Other Cloud PBX',
                                                        'Traditional','Prefers not to say'};                                          
       list<string> lstCancReasons = new list<string>{'Couldn\'t get it working','Missing critical feature','Outages','QoS Voice','QoS Fax','Going out of business',
                                                      'Business slowing down / Closing location','Fewer employees','Temporary need / Testing','Too Expensive / Not worth the cost',
                                                      'Preferred number unavailable','Consolidating into other RC account','Switching devices','Not comfortable stating reason'};                                             
       list<string> lstHosted = new list<string>{'8x8','Fonality','Jive','Megapath'};   
          
       ApexPages.StandardController controller = new ApexPages.StandardController(objOpp1);
       OpportunityCancellation objOpp = new OpportunityCancellation(controller);
       objOpp.lstsectedFax.add('Distorted image') ;
       objOpp.lstsectedQOsdetail.add('Echo');
       objOpp.lstsectedCXDetaildetail = lstCXDetaildetail;
       system.assertNotEquals(objOpp.lstsectedCXDetaildetail, null);
       objOpp.lstsectedCancReasons = lstCancReasons;
       system.assertNotEquals(objOpp.lstsectedCancReasons, null);
       objOpp.lstsectedmissingfeature.add('Intercom');
       objOpp.lstselectedCouldnotworkingdetail.add('Product');
       objOpp.lstselectedNothing.add('Downsizing Company');
       objOpp.lstselectedcostDetail.add('Overall Cost'); 
       objOpp.showcompanyCall();
       objOpp.showdetailCall();      
       objOpp.lstselectedCellPhoneOnly.add('Verizon');
       objOpp.lstsectedHostedPBXdetail = lstCancReasons;
       objOpp.lstSelectedLandLine.add('Comcast');
       objOpp.lstsectedOnPremisePBXdetail.add('Barracuda');
       objOpp.lstSelectedTraditional.add('CBeyond');
       objOpp.cancel();
       objOpp.create();
       objOpp.skip();
       objOpp.Next();   
       objOpp.back();     
       objOpp.getHostedPBXOption();
       system.assertNotEquals(objOpp.getHostedPBXOption(), null);
       objOpp.getTraditionalOption();
       system.assertNotEquals(objOpp.getTraditionalOption(), null);
       objOpp.getQOsdetailOption();
       system.assertNotEquals( objOpp.getQOsdetailOption(), null);
       objOpp.getOnPremisePBXOption();
       system.assertNotEquals(objOpp.getOnPremisePBXOption(), null);
       objOpp.getQOsdetailOption();
       system.assertNotEquals(objOpp.getQOsdetailOption(), null);
       objOpp.getCancellationReasonOption();
       system.assertNotEquals(objOpp.getCancellationReasonOption(), null);
       objOpp.getWhichCXDetailOption();
       system.assertNotEquals(objOpp.getWhichCXDetailOption(), null);
       objOpp.getFaxOption();
       system.assertNotEquals(objOpp.getFaxOption(), null);
       objOpp.getmissingfeaturedetailOption();
       system.assertNotEquals( objOpp.getmissingfeaturedetailOption(), null);
       objOpp.getCouldnotworkingdetailOption();
       system.assertNotEquals(objOpp.getCouldnotworkingdetailOption(), null);
       objOpp.getLandLineOption();
       system.assertNotEquals(objOpp.getLandLineOption(), null);
       objOpp.getCellPhoneOnlyOption();
       system.assertNotEquals(objOpp.getCellPhoneOnlyOption(), null); 
       objOpp.getCostOption(); 
       objOpp.getNothingOption();    
       
       ApexPages.StandardController controller1 = new ApexPages.StandardController(objOpp1);
       OpportunityCancellation testOPPObj = new OpportunityCancellation(controller1);
       testOPPObj.lstsectedCancReasons = lstCancReasons;  
       testOPPObj.Next();
       testOPPObj.getConsolidatingAccountOption();
       testOPPObj.getPriceOption();
       testOPPObj.getCustomerCareOption();
       testOPPObj.getSalesExpectationOption();
       testOPPObj.getBusinessMortality();
       testOPPObj.showOtherSubCompetitorBox();
       testOPPObj.showOtherProDetRes();
       testOPPObj.showConsolidatingAccount();
       testOPPObj.changeSubDownGrade();
       testOPPObj.getConsolidatingAccount();
       testOPPObj.getNothingListValue();
       testOPPObj.getTraditionalListValue();
       testOPPObj.getLandLineListValue();
       testOPPObj.getCellPhoneOnlyListValue();
       testOPPObj.getOnPremisePBXListValue();
       testOPPObj.getHostedPBXListValue();
       testOPPObj.getCXDetailPicListValue();
       testOPPObj.getFaxListValue();
       testOPPObj.getQOsListValue();
       testOPPObj.getMissingPicListValue();
       testOPPObj.getColuldNotPicListValue();
       testOPPObj.getCostPicListValue();
       testOPPObj.getCanCelreasonsPicListValue();
       testOPPObj.createformatDate(system.today());          
              
       ApexPages.StandardController controller3 = new ApexPages.StandardController(objOpp1);
       OpportunityCancellation testOPPObj2 = new OpportunityCancellation(controller3);
       testOPPObj2.lstsectedCancReasons = lstCancReasons;  
       testOPPObj2.Next();
       testOPPObj2.toshowerrorMsg=false;
       testOPPObj2.selectedSubCXDetail = '';
       testOPPObj2.selectedCXDetail = 'Prefers not to say';
       testOPPObj2.create();
       testOPPObj2.selectedCXDetail = 'Hosted PBX';
       testOPPObj2.create();
       testOPPObj2.selectedCXDetail = 'On-Premise PBX';
       testOPPObj2.create();
       testOPPObj2.selectedCXDetail = 'Other';
       testOPPObj2.create();
       testOPPObj2.selectedCXDetail = 'Other (provide detailed reason)';
       testOPPObj2.create();
       testOPPObj2.toshowerrorMsg=false;
       testOPPObj2.selectedCXDetail = 'Prefers not to say';
       testOPPObj2.create();
       testOPPObj2.getConsolidatingAccountOption();
       testOPPObj2.getPriceOption();
       testOPPObj2.getCustomerCareOption();
       testOPPObj2.getSalesExpectationOption();
       testOPPObj2.getBusinessMortality();
       testOPPObj2.showOtherSubCompetitorBox();
       testOPPObj2.showOtherProDetRes();
       testOPPObj2.showConsolidatingAccount();
       testOPPObj2.changeSubDownGrade();
       testOPPObj2.getConsolidatingAccount();
       testOPPObj2.getNothingListValue();
       testOPPObj2.getTraditionalListValue();
       testOPPObj2.getLandLineListValue();
       testOPPObj2.getCellPhoneOnlyListValue();
       testOPPObj2.getOnPremisePBXListValue();
       testOPPObj2.getHostedPBXListValue();
       testOPPObj2.getCXDetailPicListValue();
       testOPPObj2.getFaxListValue();
       testOPPObj2.getQOsListValue();
       testOPPObj2.getMissingPicListValue();
       testOPPObj2.getColuldNotPicListValue();
       testOPPObj2.getCostPicListValue();
       testOPPObj2.getCanCelreasonsPicListValue();
       testOPPObj2.createformatDate(system.today());          
    }
    static testMethod void  myUnitTest4() {
       Opportunity objOpp1 = new Opportunity();
       list<string> lstCXDetaildetail =new list<string>{'cell Phone only','Hosted PBX','Land line','Nothing','On-Premise PBX','Other Cloud PBX',
                                                        'Traditional','Prefers not to say'};                                          
       list<string> lstCancReasons = new list<string>{'Couldn\'t get it working','Missing critical feature','Outages','QoS Voice','QoS Fax','Going out of business',
                                                      'Business slowing down / Closing location','Fewer employees','Temporary need / Testing','Too Expensive / Not worth the cost',
                                                      'Preferred number unavailable','Consolidating into other RC account','Switching devices','Not comfortable stating reason'};                                             
       list<string> lstHosted = new list<string>{'8x8','Fonality','Jive','Megapath'};   
          
       ApexPages.StandardController controller = new ApexPages.StandardController(objOpp1);
       OpportunityCancellation objOpp = new OpportunityCancellation(controller);
       objOpp.lstsectedFax.add('Distorted image') ;
       objOpp.lstsectedQOsdetail.add('Echo');
       objOpp.lstsectedCXDetaildetail = lstCXDetaildetail;
       system.assertNotEquals(objOpp.lstsectedCXDetaildetail, null);
       objOpp.lstsectedCancReasons = lstCancReasons;
       system.assertNotEquals(objOpp.lstsectedCancReasons, null);
       objOpp.lstsectedmissingfeature.add('Intercom');
       objOpp.lstselectedCouldnotworkingdetail.add('Product');
       objOpp.lstselectedNothing.add('Downsizing Company');
       objOpp.lstselectedcostDetail.add('Overall Cost'); 
       objOpp.showcompanyCall();
       objOpp.showdetailCall();      
       objOpp.lstselectedCellPhoneOnly.add('Verizon');
       objOpp.lstsectedHostedPBXdetail = lstCancReasons;
       objOpp.lstSelectedLandLine.add('Comcast');
       objOpp.lstsectedOnPremisePBXdetail.add('Barracuda');
       objOpp.lstSelectedTraditional.add('CBeyond');
       objOpp.cancel();
       objOpp.create();
       objOpp.skip();
       objOpp.Next();   
       objOpp.back();     
       objOpp.getHostedPBXOption();
       objOpp.selectedCancellationRsn = 'Business Mortality';
       objOpp.finalsubDownGradeReason = '';
       objOpp.Next(); 
       objOpp.selectedCancellationRsn = 'Consolidating into other RC account';
       objOpp.finalsubDownGradeReason = '';
       objOpp.Next();
       objOpp.selectedCancellationRsn = 'Couldn\'t get it working';
       objOpp.finalsubDownGradeReason = '';
       objOpp.Next();
       objOpp.selectedCancellationRsn = 'Missing critical feature';
       objOpp.finalsubDownGradeReason = '';
       objOpp.Next();
       objOpp.selectedCancellationRsn = 'Price';
       objOpp.finalsubDownGradeReason = '';
       objOpp.Next();
       objOpp.selectedCancellationRsn = 'QoS Voice';
       objOpp.finalsubDownGradeReason = '';
       objOpp.Next();
       objOpp.selectedCancellationRsn = 'Sales Expectations';
       objOpp.finalsubDownGradeReason = '';
       objOpp.Next();
       objOpp.selectedCancellationRsn = 'Support/Customer Care';
       objOpp.finalsubDownGradeReason = '';
       objOpp.Next();
       objOpp.selectedCancellationRsn = 'Other (provide detailed reason)';
       objOpp.finalsubDownGradeReason = '';
       objOpp.Next();
    }
    static testMethod void  myUnitTest5() {
        Opportunity objOpp = new Opportunity();
        
        list<string> lstCXDetaildetail =new list<string>{'cell Phone only','Hosted PBX','Land line','Nothing','On-Premise PBX','Other Cloud PBX',
                                                         'Traditional','Prefers not to say'};                                              
        list<string> lstDownsell = new list<string>{'Couldn\'t get it working','Missing critical feature','Outages','QoS Voice','QoS Fax','Going out of business',
                                                    'Business slowing down / Closing location','Fewer employees','Temporary need / Testing','Too Expensive / Not worth the cost',
                                                    'Preferred number unavailable','Consolidating into other RC account','Switching devices','Not comfortable stating reason'};                                               
        list<string> lstHosted = new list<string>{'8x8','Fonality','Jive','Megapath'};
        list<string> lstWhatChanging = new list<string>{'Digital line(s)','Device(s)','Phone number(s)','Toll Free Bundle(s)','Premium Support','Service Change'};      
        ApexPages.StandardController controller = new ApexPages.StandardController(objOpp);
        OpportunityDownsell testCRC = new OpportunityDownsell(controller);        
        testCRC.lstsectedFax.add('Distorted image') ;
        testCRC.lstselectedChangingReasons=lstWhatChanging;
        testCRC.lstsectedQOsdetail.add('');
        testCRC.lstsectedCXDetaildetail = lstCXDetaildetail;
        testCRC.lstsectedDownsellReasons = lstDownsell ;
        testCRC.lstsectedmissingfeature.add('Intercom');
        testCRC.lstselectedCouldnotworkingdetail.add('Product');
        testCRC.showcompanyCall();
        testCRC.showdetailCall();     
        testCRC.lstselectedCellPhoneOnly.add('Verizon');
        testCRC.lstsectedHostedPBXdetail = lstHosted ;
        testcrc.lstSelectedLandLine.add('Comcast');
        testCRC.lstsectedOnPremisePBXdetail.add('Barracuda');
        testCRC.lstSelectedTraditional.add('CBeyond');      
        testCRC.cancel();
        testCRC.create();
        testCRC.skip();
        testCRC.Next();       
        testCRC.selectedDowngradeRsn = 'Business Mortality';
        testCRC.finalsubDownGradeReason = '';
        testCRC.Next(); 
        testCRC.selectedDowngradeRsn = 'Consolidating into other RC account';
        testCRC.finalsubDownGradeReason = '';
        testCRC.Next();
        testCRC.selectedDowngradeRsn = 'Couldn\'t get it working';
        testCRC.finalsubDownGradeReason = '';
        testCRC.Next();
        testCRC.selectedDowngradeRsn = 'Missing critical feature';
        testCRC.finalsubDownGradeReason = '';
        testCRC.Next();
        testCRC.selectedDowngradeRsn = 'Price';
        testCRC.finalsubDownGradeReason = '';
        testCRC.Next();
        testCRC.selectedDowngradeRsn = 'QoS Voice';
        testCRC.finalsubDownGradeReason = '';
        testCRC.Next();
        testCRC.selectedDowngradeRsn = 'Sales Expectations';
        testCRC.finalsubDownGradeReason = '';
        testCRC.Next();
        testCRC.selectedDowngradeRsn = 'Support/Customer Care';
        testCRC.finalsubDownGradeReason = '';
        testCRC.Next();
        testCRC.selectedDowngradeRsn = 'Other (provide detailed reason)';
        testCRC.finalsubDownGradeReason = '';
        testCRC.Next();
         testCRC.toshowerrorMsg=false;
        testCRC.selectedSubCXDetail = '';
        testCRC.selectedCXDetail = 'Prefers not to say';
        testCRC.create();
        testCRC.selectedCXDetail = 'Hosted PBX';
        testCRC.create();
        testCRC.selectedCXDetail = 'On-Premise PBX';
        testCRC.create();
        testCRC.selectedCXDetail = 'Other';
        testCRC.create();
        testCRC.selectedCXDetail = 'Other (provide detailed reason)';
        testCRC.create();
        testCRC.toshowerrorMsg=false;
        testCRC.selectedCXDetail = 'Prefers not to say';
        testCRC.create();
        testCRC.getConsolidatingAccountOption();
        testCRC.getPriceOption();
        testCRC.getCustomerCareOption();
        testCRC.getSalesExpectationOption();
        testCRC.getBusinessMortality();
        testCRC.showOtherSubCompetitorBox();
        testCRC.showOtherProDetRes();
        testCRC.showConsolidatingAccount();
        testCRC.changeSubDownGrade();
        testCRC.getConsolidatingAccount();
        testCRC.getNothingListValue();
        testCRC.getTraditionalListValue();
        testCRC.getLandLineListValue();
        testCRC.getCellPhoneOnlyListValue();
        testCRC.getOnPremisePBXListValue();
        testCRC.getHostedPBXListValue();
        testCRC.getCXDetailPicListValue();
        testCRC.getFaxListValue();
        testCRC.getQOsListValue();
        testCRC.getMissingPicListValue();
        testCRC.getColuldNotPicListValue();
        testCRC.getCostPicListValue();
        testCRC.createformatDate(system.today());         
    }   
}