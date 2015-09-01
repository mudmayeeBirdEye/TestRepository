@isTest
private class Test_Lead_Campaign_Deal_Opp {
	
	static testMethod void TerritoryChangeControllertest() {
		TerritoryChangeController obj = new TerritoryChangeController();
	}
   
    
    static testMethod void TestupdateleadAtbc() {
        
        	User userObj = new User(alias = 'portr', email='portaluser@testorg.com', emailencodingkey='UTF-8', lastname='portaluser', 
		                   ProfileId=[SELECT Id FROM Profile WHERE Name='system administrator' LIMIT 1].Id, languagelocalekey='en_US',
	                       localesidkey='en_US', country='United States',timezonesidkey='America/Los_Angeles',username='testuse@testorg.com', 
					       IsActive=true );
			insert userObj;
					 
        	Account objAcc = new Account();
        	objAcc.RC_User_ID__c = '123874';
        	objAcc.Name = 'testAccount';
        	
        	objAcc.Next_Renewal_Date__c = date.parse('12/12/2017');
        	insert objAcc;
        	
			Set<String> lUser = new Set<String>();
			Lead leadObj = new Lead();
			leadObj.Account__c =objAcc.Id;
    		leadObj.FirstName = 'FName';
	        leadObj.Email= 'abc@test.com';
	        leadObj.LastName = 'LastName'; 
	        leadObj.Company  ='TestCompany';
	        leadObj.phone = '12222223321';
	        leadObj.Downgrade_Reason__c  = 'Not Enough Info';
	        leadObj.User_ID__c ='123874';
	        leadObj.Website = 'test.com';
	        leadObj.NumberOfEmployees = 5;
	        leadObj.Industry = 'Consulting: IT';
	        leadObj.NumberOfEmployees__c='2-19';
	        leadObj.Number_of_Locations__c ='2-4'; 
	        leadObj.LeadSource ='About To be Cancelled';
	        leadObj.ATBC_Stage__c = 'new' ;  
	        leadObj.IsConverted = false;
			insert leadObj;
			
			lUser.add(leadObj.User_ID__c);
			
			updateleadAtbc objupdateLATBC =new updateleadAtbc(new ApexPages.Standardcontroller(leadObj));
			objupdateLATBC.getAccounts(lUser);
        
    }
        static testMethod void TestValidateLeadDuplicacy() {
        
    	try {
	     	Test.startTest();
	     	List<Lead> leadObjList = new List<Lead>();
			Lead leadObj1 = new Lead();
			leadObj1.FirstName = 'Virendra';
			leadObj1.LastName = 'Singh';
			leadObj1.Phone = '9910106823';
			leadObj1.Email = 'lead005@lead005.com';
			leadObj1.Company = 'TestIndiaLead'; //
			leadObj1.Status = '1.5 Call Out';
			leadObj1.LeadSource = 'Inbound Call';
			leadObjList.add(leadObj1);
			
			Lead leadObj2 = new Lead();
			leadObj2.FirstName = 'Virendra';
			leadObj2.LastName = 'Singh';
			leadObj2.Phone = '9910106823';
			leadObj2.Email = 'lead005@lead005.com';
			leadObj2.Company = 'TestIndiaLead'; //
			leadObj2.Status = '1.5 Call Out';
			leadObj2.LeadSource = 'Inbound Call';
			leadObjList.add(leadObj2);
	     	
	     	insert leadObjList;
	     	ValidateLeadDuplicacy.validatePerToday(leadObjList);
	     	
	     	Lead leadObj3 = new Lead();
			leadObj3.FirstName = 'Virendra';
			leadObj3.LastName = 'Singh';
			leadObj3.Phone = '9910106823';
			leadObj3.Email = 'resr@test.com';
			leadObj3.Company = 'TestIndiaLead'; //
			leadObj3.Status = '1.5 Call Out';
			leadObj3.LeadSource = 'Inbound Chat';
			leadObjList.add(leadObj3);
			
	     	ValidateLeadDuplicacy.validatePerStages(leadObjList);
	     	Test.stopTest();
    	} catch(Exception e) {}
    }
    static testMethod void TestCampaignSelectionController() {
		try{
        	 // Record Type = Saves Opportunity
      
	      ApexPages.currentPage().getParameters().put('RecordType','01280000000UEtu');
	      CampaignSelectionController CampSelectionCtrlObj1 = new CampaignSelectionController(new ApexPages.StandardController(new opportunity())); 
	      CampSelectionCtrlObj1.callDispatcher();    
	   
	   // Record Type = Sales Opportunity
	      
	      Account accVal = new  Account ();
	      accVal.Name = 'Test Account Name';
	      insert accVal;
	      
	      Order__c orderVal = new  Order__c();
	      orderVal.Name = '12345678';
	      insert  orderVal;
       
	      Campaign campObj2 = new Campaign();
	      campObj2.IsActive = true;
	      campObj2.CurrencyIsoCode = 'USD';
	      campObj2.Name = 'Test Camp 3';
	    //  campObj2.Sell_Type__c = CampSelectionCtrlObj1.NEW_BUSINESS;
	      campObj2.DNIS__c = '12345680';
	      insert campObj2;
	       
  		  ApexPages.currentPage().getParameters().put('RecordType','01280000000UEtz');
	      ApexPages.currentPage().getParameters().put('accId',accVal.Id);
	      ApexPages.currentPage().getParameters().put('CF00N80000004jUBx_lkid',orderVal.Id);
	      ApexPages.currentPage().getParameters().put('campid',campObj2.Id);
	      
	      CampaignSelectionController CampSelectionCtrlObj2 = new CampaignSelectionController(new ApexPages.StandardController(new opportunity()));
	      CampSelectionCtrlObj2.callDispatcher();
	      CampSelectionCtrlObj2.getSellTypeItems();
	      
	      Campaign campObj = new Campaign();
	      campObj.IsActive = true;
	      campObj.CurrencyIsoCode = 'USD';
	      campObj.Name = 'Test Camp 1';
	     // campObj.Sell_Type__c = CampSelectionCtrlObj2.NEW_BUSINESS;
	      campObj.DNIS__c = '12345678';
	      insert campObj;
	      
	      Campaign campObj1 = new Campaign();
  		  campObj1.IsActive = true;
	      campObj1.CurrencyIsoCode = 'USD';
	      campObj1.Name = 'Test Camp 2';
	      //campObj1.Sell_Type__c = CampSelectionCtrlObj2.EXISTING_BUSINESS;
	      campObj1.DNIS__c = '12345679';
	      insert campObj1;
	      
	      CampSelectionCtrlObj2.callCampaignList();
	      CampSelectionCtrlObj2.getCampaignListOptions();
	      
	     // CampSelectionCtrlObj2.sellType = CampSelectionCtrlObj2.EXISTING_BUSINESS;
	      CampSelectionCtrlObj2.inputTxtSearch = '679'; 
      
	      List<SelectOption> lstOption =  CampSelectionCtrlObj2.getCampaignListOptions();
	      if(lstOption.size() > 0) {
	          string selectOption = lstOption.get(0).getvalue();
	          if(selectOption != null) {
	                CampSelectionCtrlObj2.selectedPmrCamp = new List<string>();
	                CampSelectionCtrlObj2.selectedPmrCamp.add(selectOption);
	                CampSelectionCtrlObj2.callsetToPrimaryCampaign();
	          }
	      }
	      CampSelectionCtrlObj2.createOpportunity();
	      CampSelectionCtrlObj2.removePrimaryCampaign();
	        
	      System.assertEquals(false, CampSelectionCtrlObj2.toShowErrorMsg);
	      
	      PageReference pgRef = new PageReference('/006/o');
	      ApexPages.currentPage().getParameters().put('retURL',pgRef.getUrl());
	      CampSelectionCtrlObj2.cancel();
	        	
        }catch(exception ex){}
    }
    static testMethod void DealRigstrationHelpertest() {
    	try{
    		// TO DO: implement unit test        
		  VAR_Deal_Registration__c newDealobj = new VAR_Deal_Registration__c();
		  VAR_Deal_Registration__c oldDealobj = new VAR_Deal_Registration__c();
		  DealRigstrationHelper.IsChanged( newDealobj , oldDealobj );
		  
		  VAR_Deal_Registration__c newDealobj0 = new VAR_Deal_Registration__c();
		  newDealobj0.Description__c ='test';
		  VAR_Deal_Registration__c oldDealobj0 = new VAR_Deal_Registration__c();
		  DealRigstrationHelper.IsChanged( newDealobj0 , oldDealobj0 );
    	}catch(exception ex){}
    }
    static testMethod void OpportunityDownselltest() {
    	try{
    		// TO DO: implement unit test
        
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
    	}catch(exception ex){}
    }
    static testMethod void TOTDtest() {
        // TO DO: implement unit test
		try{
			TOTD__c objData=new TOTD__c();
			objData.Day__c='Monday';
			objData.Content__c='Test';
			objData.Image__c='<img />';
			insert objData;
		   
			ApexPages.currentPage().getParameters().put('dayName','Monday');
			TOTD obj=new TOTD();
			objData=new TOTD__c();
		    objData.Day__c='Monday';
		    objData.Content__c='Test';
		    objData.Image__c='test image';
		    insert objData;
		    
		    ApexPages.currentPage().getParameters().put('dayName','Monday');
		    obj=new TOTD();
			objData.Day__c='MondayTest';
			ApexPages.currentPage().getParameters().put('dayName','Monday2');
			upsert objData;
		  
			obj=new TOTD();
		}catch(Exception e){}
    }
}