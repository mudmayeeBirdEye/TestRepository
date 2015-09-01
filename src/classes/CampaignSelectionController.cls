public with sharing class CampaignSelectionController {
    public string sellType {get;set;}
    public string inputTxtSearch {get;set;}
    public string txtPrimaryCampaign {get;set;}
    public string hdnPrimaryCampaignId {get;set;}
    public boolean showSearchForm {get;set;}
    public String recordType{get;set;}
    public List<String> selectedPmrCamp {get;set;}
    public boolean toShowErrorMsg {get;set;}
    public string errorMsg {get;set;}
    public List<SelectOption> campaignList{get;set;}
    public List<string> tempList {get;set;}
    public string accId {get;set;}
    public string accountName {get;set;}
    public string orderId {get;set;}
    public string orderName {get;set;}
    public Map<String, String> campToSellTypeMap{get;set;}
    public ApexPages.StandardController controller {get;set;}
   
    final String NEW_BUSINESS = 'New Business';
    final String EXISTING_BUSINESS = 'Existing Business';
 
    public Map<id,Campaign> campaignMap = new Map<id,Campaign>();
    
    
    public CampaignSelectionController(ApexPages.StandardController controller) {
        try {
        	this.controller = controller;
            selectedPmrCamp = new List<string>();
            campToSellTypeMap = new Map<String, String>();
            tempList = new List<string>();
            tempList.add('test');
            getSellTypeItems(); 
            campaignList = getCampaignListOptions();
        } catch(Exception ex) { }
    } 
    
    public PageReference callDispatcher() {
    	Id rcIdDown = OpportunityHelper.getOppRecordTypeMap('Saves Downsell');
    	Id rcIdCancel = OpportunityHelper.getOppRecordTypeMap('Cancel Opportunity'); 
    	string keyPrefix = '/' + Schema.getGlobalDescribe().get('Opportunity').getDescribe().getKeyPrefix() + '/e'; 
    	if(UserInfo.getUserType().containsIgnoreCase('Partner')) {
    		PageReference objPage2=new PageReference(keyPrefix);
    		if(ApexPages.currentPage().getParameters().get('accid') != null && ApexPages.currentPage().getParameters().get('accid') != '') {
                accId = ApexPages.currentPage().getParameters().get('accid');
	            List<Account> accObj = [select name from account where Id = :accId limit 1];
	            if(accObj != Null && accObj.size() >0 && accObj[0].Name != null) {
	            	accountName = accobj[0].Name;
	            	objPage2.getParameters().put('opp4',accountName);
	            	objPage2.getParameters().put('opp4_lkid',AccId);
	            }
		    }
    		objPage2.getParameters().put('nooverride','1');
	        objPage2.setRedirect(true);
	        return objPage2;
    	}
	    PageReference oppPage = new PageReference(keyPrefix);
	    if(ApexPages.currentPage().getParameters().get('RecordType') != null && 
	    	(rcIdDown == ApexPages.currentPage().getParameters().get('RecordType'))) {
      		oppPage = new PageReference('/apex/OpportunityDownsell');
      	} else if(ApexPages.currentPage().getParameters().get('RecordType') != null && 
      				rcIdCancel == ApexPages.currentPage().getParameters().get('RecordType')) {
      		oppPage = new PageReference('/apex/OpportunityCancellation');
      }
        string strRtnUrl = new PageReference('/006/o').getUrl();
    	if(ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL') != '') {
            strRtnUrl = ApexPages.currentPage().getParameters().get('retURL');
    	}
	    try {
	        oppPage.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType'));
	        recordType = ApexPages.currentPage().getParameters().get('RecordType');
	        oppPage.getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
	        if(ApexPages.currentPage().getParameters().get('accid') != null && ApexPages.currentPage().getParameters().get('accid') != '') {
                accId = ApexPages.currentPage().getParameters().get('accid');
	            List<Account> accObj = [select name from account where Id = :accId limit 1];
	            if(accObj != Null && accObj.size() >0 && accObj[0].Name != null) {
	            	accountName = accobj[0].Name;
	            	oppPage.getParameters().put('opp4',accountName);
	            	oppPage.getParameters().put('opp4_lkid',AccId);
	            }
		    }
	        if(ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid') != null && 
	        		ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid') != '') {
                orderId = ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid');
	            List<Order__c> orderObj = [select name from order__c where Id = :orderId limit 1];
	            if(orderObj != null && orderObj.size()>0 && orderObj[0].Name != null) {
	            	orderName = orderObj[0].Name;
	            	oppPage.getParameters().put('CF00N80000004jUBx',orderName);
	            	oppPage.getParameters().put('CF00N80000004jUBx_lkid',orderId);
	            }
	    	}
	        if(ApexPages.currentPage().getParameters().get('campid') != null && ApexPages.currentPage().getParameters().get('campid') != '') {
		      	string campId = ApexPages.currentPage().getParameters().get('campid');
	        	List<Campaign> campObj = [select name from Campaign where Id = :campId Limit 1];
	        	if(campObj != null && campObj.size()>0 && campObj[0].Name != null) {
	        		oppPage.getParameters().put('opp17',campObj[0].Name);
	       		    oppPage.getParameters().put('opp17_lkid',campId);
	        	}
    		}
	        if(recordType != null && recordType != '') {
	            Id rcId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');
	            if(rcId != null && rcId == recordType) {
	                showSearchForm = true; 
	                return null;
	            } else if(rcIdDown != null && rcIdDown == recordType) {
              		oppPage.setRedirect(true);
                  	return oppPage;
                } else if(rcIdCancel != null && rcIdCancel == recordType) {
              		oppPage.setRedirect(true);
                  	return oppPage;
              	} else {
	                oppPage.getParameters().put('nooverride','1');
	                oppPage.setRedirect(true);
	                return oppPage;
	            }
	        } else {
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'RecordType Id is missing from Url. Please click <a href="'+strRtnUrl+'" style="font-size:13px;color:Red;">here</a> to re-create the opportunity.'));
        		return null;	
	        } 
	    } catch(Exception ex) {
	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception has occured. Please click <a href="'+strRtnUrl+'" style="font-size:13px;color:Red;">here</a> to re-create the opportunity.'));
        	return null;
	    } 
       return oppPage;  
    }
    
    public List<SelectOption> getSellTypeItems() {
        List<SelectOption> sellTypeItemList = new List<SelectOption>();
        try {
            Schema.sObjectType sobjectType = Campaign.getSObjectType(); 
            Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe(); 
            Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap(); 
            List<Schema.PicklistEntry> pickListValues = fieldMap.get('Sell_Type__c').getDescribe().getPickListValues(); 
            for (Schema.PicklistEntry picklstval : pickListValues) { 
                sellTypeItemList.add(new selectOption(picklstval.getvalue(), picklstval.getvalue())); 
            }
            if(sellType == null && sellTypeItemList.size() > 0)
                sellType = sellTypeItemList[0].getvalue();
        } catch(Exception ex) { }
        return sellTypeItemList;
    }
    
 
    public List<SelectOption> getCampaignListOptions() {
        campaignMap.Clear();
        List<SelectOption> campaignListOption = new List<SelectOption>();
        List<Campaign> campaignList = new  List<Campaign>();
         String searchCondition = '';
         if(sellType != null && inputTxtSearch != null && inputTxtSearch != '') {
            if(sellType == NEW_BUSINESS) {
                searchCondition = ' AND ((Name like ' 
                + '\'%'+ String.escapeSingleQuotes(inputTxtSearch.trim()) + '%\'' + ')' + 'or (DNIS__c like ' + '\'%' + String.escapeSingleQuotes(inputTxtSearch.trim()) + '%\'' + ')) '; 
            } else if(sellType == EXISTING_BUSINESS) {
                searchCondition = ' AND ((Name like ' 
                + '\'%'+ String.escapeSingleQuotes(inputTxtSearch.trim()) + '%\'' + ')' + 'or (DNIS__c like ' + '\'%' + String.escapeSingleQuotes(inputTxtSearch.trim()) + '%\'' + ')) ';
            }
        }
        
        String strquery = 'SELECT id,name FROM Campaign '; 
        if(sellType == NEW_BUSINESS) {
            strquery += 'WHERE Sell_Type__c =  \''+sellType+'\' AND IsActive = true '+searchCondition+' ORDER BY Name LIMIT 10000'; 
        } else if(sellType == EXISTING_BUSINESS) {
            strquery += 'WHERE (Sell_Type__c = \'\' or Sell_Type__c = ' +  '\'' + sellType + '\''  + ' ) AND IsActive = true '+searchCondition+' ORDER BY Name LIMIT 10000';
        }  
        try {
            campaignList = DataBase.query(strquery);
        } catch(DMLException ex) { 
            Exception_And_Notification_History__c exceptionObj = new Exception_And_Notification_History__c();
			exceptionObj.Object_Type__c = 'Exception';
			exceptionObj.content_label_01__c = 'CampaignSelectionController';
			exceptionObj.content_label_02__c = '127';
			exceptionObj.content_label_03__c = 'Exception';
			exceptionObj.content_label_04__c = 'Get Stack Trace String';
			exceptionObj.content_label_05__c = 'Details';
			exceptionObj.content_var_01__c ='CampaignSelectionController';
			exceptionObj.File_Associated__c = 'CampaignSelectionController';
			ExceptionAndNotificationHelper.trackExceptions(exceptionObj, ex);
        }
        for(Campaign campObj : campaignList) {
            if(campObj != null) {
                campaignListOption.add(new SelectOption(campObj.Id,campObj.Name));
                campaignMap.put(campObj.Id,campObj);
            }
        }
        return campaignListOption;
    }
    
    public void callCampaignList() {
        campaignList = getCampaignListOptions();
    }
    
    map<id,Campaign> selectedPmrCampaignMap = new map<id,Campaign>();
    public void callsetToPrimaryCampaign() {
        if(selectedPmrCamp.size() > 0) {
            for(string strPmrCamp : selectedPmrCamp) {
                if(strPmrCamp != null && strPmrCamp != '') {
                    txtPrimaryCampaign = campaignMap.get(strPmrCamp).Name;
                    hdnPrimaryCampaignId = strPmrCamp;
                    selectedPmrCampaignMap.put(strPmrCamp,campaignMap.get(strPmrCamp));
                    campToSellTypeMap.put(hdnPrimaryCampaignId, sellType);
                    toShowErrorMsg = false;
                    break;
                }
            }
        } else if(txtPrimaryCampaign == null || txtPrimaryCampaign=='') {
            toShowErrorMsg = true;
              errorMsg = Label.Please_select_the_Primary_Campaign;
            
        }
    }
     
    public void removePrimaryCampaign() {
        txtPrimaryCampaign = '';
        hdnPrimaryCampaignId = '';
        selectedPmrCamp.clear();
        selectedPmrCampaignMap.clear();
     }
    
    public PageReference createOpportunity() {
        PageReference rtrnPage;
        if(txtPrimaryCampaign == null || txtPrimaryCampaign=='') {
            errorMsg = Label.Please_select_a_primary_campaign_before_creating_the_opportunity;
            toShowErrorMsg = true;
            rtrnPage =  null;
        } else {
        	try {
	            toShowErrorMsg = false;
	            string keyPrefix = '/' + Schema.getGlobalDescribe().get('Opportunity').getDescribe().getKeyPrefix() + '/e'; 
	            PageReference rtrnOppPage = new PageReference(keyPrefix);
	            rtrnOppPage.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType'));
	            rtrnOppPage.getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
	            rtrnOppPage.getParameters().put('nooverride','1');
	            rtrnOppPage.getParameters().put('opp17',selectedPmrCampaignMap.get(hdnPrimaryCampaignId).Name);
	            rtrnOppPage.getParameters().put('opp17_lkid',hdnPrimaryCampaignId);
	            if(accId != null && accountName != null) {
	                rtrnOppPage.getParameters().put('opp4',accountName);
	                rtrnOppPage.getParameters().put('opp4_lkid',AccId);
	            }
	            if(orderId != null && orderName != null) {
	                rtrnOppPage.getParameters().put('CF00N80000004jUBx',orderName);
	                rtrnOppPage.getParameters().put('CF00N80000004jUBx_lkid',orderId);
	            }
	            if(sellType != null) {
	                rtrnOppPage.getParameters().put('opp5',
	                (campToSellTypeMap == null || campToSellTypeMap.size() == 0 ? sellType :campToSellTypeMap.get(hdnPrimaryCampaignId)));
	            }
	            rtrnPage = rtrnOppPage;
        	} catch(Exception e) {  }
         }
         return rtrnPage;
    }
    
    public PageReference cancel() {
        PageReference rtrnPage;
        try {
            if(ApexPages.currentPage().getParameters().get('retURL') != null) {
                string pgref = ApexPages.currentPage().getParameters().get('retURL');
                rtrnPage = new PageReference(pgref);
            }
        }
        catch(Exception ex) {}
        return rtrnPage;
    }
    
    
    /***Test Method**/
 /*   @IsTest public static void testCampaignSelectionController() {
    
   // Record Type = Saves Opportunity
      
      ApexPages.currentPage().getParameters().put('RecordType','01280000000UEtu');
      CampaignSelectionController CampSelectionCtrlObj1 = new CampaignSelectionController(new ApexPages.StandardController(new opportunity())); 
      CampSelectionCtrlObj1.callDispatcher();    
   
   // Record Type = Sales Opportunity
      
      Account accVal = new  Account ();
      accVal.Name = ' Account Name';
      insert accVal;
      
      Order__c orderVal = new  Order__c();
      orderVal.Name = '12345678';
      insert  orderVal;
       
      Campaign campObj2 = new Campaign();
      campObj2.IsActive = true;
      campObj2.CurrencyIsoCode = 'USD';
      campObj2.Name = 'Test Camp 3';
      campObj2.Sell_Type__c = CampSelectionCtrlObj1.NEW_BUSINESS;
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
      campObj.Sell_Type__c = CampSelectionCtrlObj2.NEW_BUSINESS;
      campObj.DNIS__c = '12345678';
      insert campObj;
      
      Campaign campObj1 = new Campaign();
      campObj1.IsActive = true;
      campObj1.CurrencyIsoCode = 'USD';
      campObj1.Name = 'Test Camp 2';
      campObj1.Sell_Type__c = CampSelectionCtrlObj2.EXISTING_BUSINESS;
      campObj1.DNIS__c = '12345679';
      insert campObj1;
      
      CampSelectionCtrlObj2.callCampaignList();
      CampSelectionCtrlObj2.getCampaignListOptions();
      
      CampSelectionCtrlObj2.sellType = CampSelectionCtrlObj2.EXISTING_BUSINESS;
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
  }  */
}