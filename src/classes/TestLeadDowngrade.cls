@isTest
private class TestLeadDowngrade {

    static testMethod void leadDownGradeTest() {
    	try {
    		 Schema.DescribeSObjectResult result = Lead.SObjectType.getDescribe();
    		 Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
			 Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
			 Lead_Opp_Downgrade_RT__c csObj = new Lead_Opp_Downgrade_RT__c();
			 csObj.Name = 'Sales Leads';
			 insert csObj;
    		 LeadDowngrade leadDownGradeObj = new LeadDowngrade(new ApexPages.StandardController(new Lead()));
    		 Lead leadObjNew = new Lead(); 
    		 leadObjNew.FirstName = 'TestFNAMe12';
    		 leadObjNew.LastName = 'TestLName12';
    		 leadObjNew.Email = 'Testemail12@test.com';
    		 leadObjNew.Title = 'TestT';
    		 leadObjNew.Company = 'TestCompany12Name';
    		 leadObjNew.Phone = '9812121233';
    		 leadObjNew.RecordTypeId = rtMapById.get('Sales Leads').getRecordTypeId();
    		 leadObjNew.Lead_Brand_Name__c = 'RingCentral';
    		 insert leadObjNew;
    		 Test.startTest();
    		 ApexPages.currentPage().getParameters().put('Id',leadObjNew.id);
    		 LeadDowngrade leadDownGradeObj1 = new LeadDowngrade(new ApexPages.StandardController(leadObjNew));
    		 leadDownGradeObj1.createformatDate(System.today());
    		 leadDownGradeObj1.getCellPhoneOnlyListValue();
    		 //leadDownGradeObj1.getCouldnotworkingdetailOption();
    		 leadDownGradeObj1.getdowngradeReasonOptionLead();
    		 leadDownGradeObj1.getdowngradeReasonOptionRingATNT();
    		 leadDownGradeObj1.getdowngradeReasonOptionRingCentral();
    		 leadDownGradeObj1.getSubDowngradeReasonNotBANT();
    		 leadDownGradeObj1.getSubDowngradeReasonUnableContact();
    		 leadDownGradeObj1.getSubDowngradeReasonNotNew();
    		 leadDownGradeObj1.getSubDowngradeReasonBandwidth();
    		 leadDownGradeObj1.getSubDowngradeReasonConcernsAbout();
    		 leadDownGradeObj1.getSubDowngradeReasonMissingCriti();
    		 leadDownGradeObj1.getSubDowngradeReasonPrice();
    		 leadDownGradeObj1.getSubDowngradeReasonReviews();
    		 leadDownGradeObj1.getWhichCXDetailOption();
    		 leadDownGradeObj1.getHostedPBXOption();
    		 leadDownGradeObj1.getOnPremisePBXOption();
    		 leadDownGradeObj1.getDelayedReasonOption();
    		 leadDownGradeObj1.getdowngradeReasonOptionRetention();
    		 leadDownGradeObj1.getHostedPBXOption();
    		 leadDownGradeObj1.getOnPremisePBXListValue();
    		 leadDownGradeObj1.getLandLineListValue();
    		 leadDownGradeObj1.getNothingListValue();
    		 leadDownGradeObj1.getTraditionalListValue();
    		 leadDownGradeObj1.getConsolidatingAccount();
    		 leadDownGradeObj1.cancel();
    		 ApexPages.currentPage().getParameters().put('retURL',leadObjNew.id);
			 leadDownGradeObj1.cancel();
		     leadDownGradeObj1.lstselectedCellPhoneOnly = 'Verizon';
		     leadDownGradeObj1.lstsectedHostedPBXdetail = 'Fonality' ;
		     leadDownGradeObj1.lstSelectedLandLine = 'Comcast';
		     leadDownGradeObj1.lstsectedOnPremisePBXdetail = 'Barracuda';
	         leadDownGradeObj1.lstSelectedTraditional.add('CBeyond');      
		     leadDownGradeObj1.cancel();
		     leadDownGradeObj1.back();
		     leadDownGradeObj1.onChangeReason();
		     leadDownGradeObj1.selectedDowngradeReasons = 'Not BANT qualified';
		     leadDownGradeObj1.onChangeReason();
		     leadDownGradeObj1.selectedDowngradeReasons = 'Unable to contact';
		     leadDownGradeObj1.onChangeReason();
		     leadDownGradeObj1.selectedDowngradeReasons = 'Not a new prospect';
		     leadDownGradeObj1.onChangeReason();
		     leadDownGradeObj1.selectedDowngradeReasons = 'Bandwidth / Wiring';
		     leadDownGradeObj1.onChangeReason(); 
		     leadDownGradeObj1.selectedDowngradeReasons = 'Concerns about reliability / usability / support';
		     leadDownGradeObj1.onChangeReason();
		     leadDownGradeObj1.selectedDowngradeReasons = 'Missing critical features';
		     leadDownGradeObj1.onChangeReason();
		     leadDownGradeObj1.selectedDowngradeReasons = 'Price';
		     leadDownGradeObj1.onChangeReason();
		     leadDownGradeObj1.selectedDowngradeReasons = 'Reviews';
		     leadDownGradeObj1.onChangeReason();
		     leadDownGradeObj1.updateLead();
		     //leadDownGradeObj1.selectedDowngradeReasons = 'Other';
		     //leadDownGradeObj1.onChangeReason();
		     //leadDownGradeObj1.leadObj.Downgrade_Reason_Other__c = 'Test Other';
		     //leadDownGradeObj1.onChangeSubReason();
		     //leadDownGradeObj1.Next();
		     leadDownGradeObj1.selectedDowngradeReasons = 'Hosted PBX';
		     leadDownGradeObj1.onChangeSubReason();
		     leadDownGradeObj1.sectedSubDowngradeReason = 'Aviya';
		     leadDownGradeObj1.Next();
		     leadDownGradeObj1.strSelectedIssueWithRC = 'leadDownGradeObj1';
		     leadDownGradeObj1.onChangeIssueWithRC();
		     leadDownGradeObj1.strSelectedSubIssueWithRC = 'Location not wired for Ethernet';
		     leadDownGradeObj1.onChangeSubIssueWithRC();
		     leadDownGradeObj1.updateLead();
		     Test.stopTest();
		} catch(Exception ex) {}
       
    }
}