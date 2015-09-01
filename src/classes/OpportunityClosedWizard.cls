public with sharing class OpportunityClosedWizard {
	public List<string> errorMsgList {get;set;} 
	public boolean toshowerrorMsg {get;set;}
	public Opportunity opportunityObj{get;set;}
	public string strSelectedWhoDidWeBeat {get;set;}
	public String strsectedHostedPBXdetail{get;set;}
	public String strsectedOnPremisePBXdetail{get;set;}
	public List<string> tempList {get;set;}
	public Map<String,List<String>> mapBrandAndHostedPBX{get;set;}
	List<String> BrandRingCentralUSOrCanada{get;set;}
	List<String> BrandRingCentralUK{get;set;}
	
	public String strvalOtherHostedPBX1{get;set;}	
	public String strvalOtherWonReasonIntegrations{get;set;}           
	public String strvalOtherOnWonReasonServiceAndFeatures{get;set;}
	public String strvalOtherOnWonReasonAll{get;set;}
	public String strvalOtherHostedPBX{get;set;}
	public String strvalOtherOnPremisePBX{get;set;}
	public String strvalOtherOnPremisePBX1{get;set;}
	
	public string strSelectedWhoDidWeBeat1 {get;set;}
	public string strSelectedWhoDidWeWin {get;set;}
	public String strsectedWonReasonServiceAndFeatures{get;set;}
    public String strsectedHostedPBXdetail1{get;set;}
    public String strsectedWonReasonIntegrations {get;set;}
     public String strselectedWonReasonAll {get;set;}
	public String strsectedOnPremisePBXdetail1{get;set;}
	public String strsectiontOtherWhoDidWeBeat{get;set;}	
	
	public boolean toshowHostedPBX{get;set;}
	
	
	public boolean toshowHostedPBX1{get;set;}
	public boolean toshowOnPremisePBX{get;set;}
	public boolean toshowOnPremisePBX1{get;set;}
	public boolean toOtherWhoDidWeBeat{get;set;}
	
	public boolean toOtherWonReasonIntegrations{get;set;}
	public boolean toOtherWonReasonServiceAndFeature{get;set;}
	public boolean toOtherWonReasonAll{get;set;}
	public boolean toOnPremisePBX{get;set;}	
	  
	public boolean toOtherOnPremisePBX{get;set;}
	public boolean toOtherOnPremisePBX1{get;set;}
	
	public boolean toshowWonReasonIntegrations{get;set;}
	public boolean toshowWonReasonServiceAndFeatures{get;set;}
	public boolean toshowWonReasonAll{get;set;}
	public boolean toOtherHostedPBX1 {get;set;}
	public boolean toOtherHostedPBX {get;set;}
	/* Fields for Implementation Scheduler */
	public Boolean toShowImplementationScheduler {get; set;}
	public Id implementationContact {get; set;}
	public String opportunityId {get; set;}
	public Opportunity holdOpp {get; set;}
	
	public OpportunityClosedWizard(ApexPages.StandardController controller) {
		try {
			opportunityObj = new Opportunity();
			if(controller.getId() != null) {
				controller.addFields(new List<String> {'Account.Most_Recent_Implementation_Contact__c','Account.Number_of_DL_s__c',
					                                   'Account.Do_Not_Creation_Implementation__c','Forecasted_Users__c',
					                                   'AccountId','Brand_Name__c','Type','Tier_Name__c'});
	 			this.opportunityObj = (Opportunity)controller.getRecord();
	 			//system.debug('@@@ opportunityObj'+opportunityObj.Brand_Name__c);
	 	        errorMsgList = new List<string>();
		        tempList = new List<string>();
		        tempList.add('test');
		        mapBrandAndHostedPBX = new Map<String,List<String>> ();
		        toshowerrorMsg = false;
		        getHostedPBXRCandRCCanada();
		        getHostedPBXRCUK();
			}	
		} catch(Exception ex) {}
	}
   
    public void showtoOtherOnPremisePBX1() {
 		toshowerrorMsg = false;
    	strvalOtherOnPremisePBX1 = '';
    	system.debug('strsectedOnPremisePBXdetail1 :'+ strsectedOnPremisePBXdetail1);
    	if(strsectedOnPremisePBXdetail1 =='Other (provide detailed reason)'){
	 		toOtherOnPremisePBX1 = true;
    	} else {
	 		toOtherOnPremisePBX1 = false;
    	}
    }
    
    public void showtoOtherHostedPBX1(){
	 	toshowerrorMsg = false;
    	strvalOtherHostedPBX1 = '';
		if(strsectedHostedPBXdetail1 =='Other (provide detailed reason)'){
	 		toOtherHostedPBX1 = true; 
    	} else {
	 		toOtherHostedPBX1 = false;
    	}
    }  
      
    public void showtoOtheronPremisePBX(){
	 	toshowerrorMsg = false;
  		strvalOtherOnPremisePBX ='';
    	if(strsectedOnPremisePBXdetail =='Other (provide detailed reason)'){
	 		toOtherOnPremisePBX = true;
    	} else{
	 		toOtherOnPremisePBX = false;
    	}
    }
    
    public void showtoOtherHostedPBX(){
	 	toshowerrorMsg = false;
    	strvalOtherHostedPBX = '';
		if(strsectedHostedPBXdetail =='Other (provide detailed reason)'){
	 		toOtherHostedPBX = true;
    	} else{
	 		toOtherHostedPBX = false;
    	}
    }   
    
      public void showtoOtherWonReasonIntegrations() {
 		toshowerrorMsg = false;
    	strvalOtherWonReasonIntegrations = '';
    	//	system.debug('strsectedOnPremisePBXdetail1 :'+ strsectedOnPremisePBXdetail1);
    	if(strsectedWonReasonIntegrations =='Other (provide detailed reason)'){
	 		toOtherWonReasonIntegrations = true;
    	} else {
	 		toOtherWonReasonIntegrations = false;
    	}
    }
   
    public void showSubSectionOfWhoDidWeBeat() { 
	 	toshowerrorMsg = false;
		strsectedHostedPBXdetail = '';
		strsectedOnPremisePBXdetail = '';
		strvalOtherHostedPBX = '';
		strvalOtherOnPremisePBX = '';
		toOtherHostedPBX = false;
		toOtherOnPremisePBX = false;
        if(strSelectedWhoDidWeBeat == 'Hosted PBX') {
	        toshowHostedPBX = true;
	        toshowOnPremisePBX = false; 
	        toOtherWhoDidWeBeat = false;                
        } else if(strSelectedWhoDidWeBeat == 'On-Premise PBX'){ 
        	toshowHostedPBX = false;
            toshowOnPremisePBX = true; 
            toOtherWhoDidWeBeat = false;
        } else if(strSelectedWhoDidWeBeat == 'Other'){
        	toshowHostedPBX = false;
            toshowOnPremisePBX = false; 
            toOtherWhoDidWeBeat = true;              
        } else {
        	toshowHostedPBX = false;
            toshowOnPremisePBX = false;
            toOtherWhoDidWeBeat = false;
        }   
	} 
		
     public void showSubSectionOfWhoDidWeBeat1() {
        toshowerrorMsg = false;
   		strsectedHostedPBXdetail1 = '';
		strsectedOnPremisePBXdetail1 = '';
		strvalOtherHostedPBX1 = '';
		strvalOtherOnPremisePBX1 ='';
		toOtherHostedPBX1 = false;
		toOtherOnPremisePBX1 = false;
        if(strSelectedWhoDidWeBeat1 == 'Hosted PBX') {
            toshowHostedPBX1 = true;
            toshowOnPremisePBX1 = false; 
        } else if(strSelectedWhoDidWeBeat1 == 'On-Premise PBX'){
            toshowHostedPBX1 = false;
            toshowOnPremisePBX1 = true;
        } else {
        	toshowHostedPBX1 = false;
            toshowOnPremisePBX1 = false;
        }
     }
     
	  public void showSubSectionOfWhoDidWeWin() {
        toshowerrorMsg = false;
		strsectedWonReasonServiceAndFeatures='';
		strsectedWonReasonIntegrations='';
		strselectedWonReasonAll ='';
   		strvalOtherWonReasonIntegrations ='';
   		strvalOtherOnWonReasonAll ='';
		strvalOtherOnWonReasonServiceAndFeatures ='';
	    toOtherWonReasonIntegrations =false ;
		toOtherWonReasonServiceAndFeature = false ;
		toOtherWonReasonAll = false;
        if(strSelectedWhoDidWeWin == 'Services and Features') {
            toshowWonReasonServiceAndFeatures = true;
            toshowWonReasonIntegrations = false; 
             toshowWonReasonAll = false;
        } else if(strSelectedWhoDidWeWin == 'Integrations'){            
            toshowWonReasonIntegrations = true;
            toshowWonReasonServiceAndFeatures = false; 
            toshowWonReasonAll = false;
        } else if (strSelectedWhoDidWeWin == 'Won Reason - All') {
        	toshowWonReasonAll = true ;
        	toshowWonReasonServiceAndFeatures = false;
            toshowWonReasonIntegrations = false;
        } else {
        	toshowWonReasonAll = false;
        	toshowWonReasonServiceAndFeatures = false;
            toshowWonReasonIntegrations = false;
        }
     }
	 
    public PageReference OpportunityUpdate(){
    	
    	// Initializing variables.
    	holdOpp = new Opportunity();
    	errorMsgList = new List<string>();
	 	toshowerrorMsg = false;
	    opportunityObj.Who_Did_We_Beat__c = '';
		opportunityObj.Why_did_we_win__c ='';
        opportunityObj.Who_What_are_we_replacing__c = '';
		opportunityObj.WhoDidWeBeatOther__c = '';
		opportunityObj.Competitor_Who_did_we_beat__c = '';
		opportunityObj.Other_Competitor_Who_did_we_beat__c = ''; 
		opportunityObj.Competitor_Who_What_are_we_replacing__c = ''; 
		opportunityObj.OtherCompetitorWho_What_are_we_replacing__c = '';
		toShowImplementationScheduler = false;
    	
    	try {
	    	if(opportunityObj != null){
	    		if(strSelectedWhoDidWeBeat == null || strSelectedWhoDidWeBeat == '') {
	    			errorMsgList.add('Please select &quot;Who did we beat?&quot;');
	    		} else {
	    			if (strSelectedWhoDidWeBeat == 'Other' && string.isBlank(strsectiontOtherWhoDidWeBeat)) {
	    				errorMsgList.add('Please enter the other value for &quot;Who did we beat?&quot;');
	    			} else {
	    				if(strSelectedWhoDidWeBeat == 'On-Premise PBX' && string.isBlank(strsectedOnPremisePBXdetail)) {
	    					errorMsgList.add('Please select the competitor value for &quot;On-Premise PBX&quot;');
	    				} else if(strSelectedWhoDidWeBeat == 'Hosted PBX' && string.isBlank(strsectedHostedPBXdetail)) {
	    					errorMsgList.add('Please select the competitor value for &quot;Hosted PBX&quot;');
	    				} else if(strSelectedWhoDidWeBeat == 'On-Premise PBX' && strsectedOnPremisePBXdetail == 'Other (provide detailed reason)' &&
	    					string.isBlank(strvalOtherOnPremisePBX)) {
	    					errorMsgList.add('Please enter the other value for &quot;On-Premise PBX&quot;');
	    				} else if(strSelectedWhoDidWeBeat == 'Hosted PBX' && strsectedHostedPBXdetail == 'Other (provide detailed reason)' &&
	    					string.isBlank(strvalOtherHostedPBX)) {
	    					errorMsgList.add('Please enter the other value for &quot;Hosted PBX&quot;');
	    				} 
	    			}
	    		}
	    		
	    		if(strSelectedWhoDidWeBeat1 == null || strSelectedWhoDidWeBeat1 == '') {
	    			errorMsgList.add('Please select &quot;Who/What are we replacing?&quot;');
	    		} else {
					if(strSelectedWhoDidWeBeat1 == 'On-Premise PBX' && string.isBlank(strsectedOnPremisePBXdetail1)) {
						errorMsgList.add('Please select the competitor value for &quot;On-Premise PBX&quot;');
					} else if(strSelectedWhoDidWeBeat1 == 'Hosted PBX' && string.isBlank(strsectedHostedPBXdetail1)) {
						errorMsgList.add('Please select the competitor value for &quot;Hosted PBX&quot;');
					} else if(strSelectedWhoDidWeBeat1 == 'On-Premise PBX' && strsectedOnPremisePBXdetail1 == 'Other (provide detailed reason)' &&
						string.isBlank(strvalOtherOnPremisePBX1)) {
						errorMsgList.add('Please enter the other value for &quot;On-Premise PBX&quot;');
					} else if(strSelectedWhoDidWeBeat1 == 'Hosted PBX' && strsectedHostedPBXdetail1 == 'Other (provide detailed reason)' &&
						string.isBlank(strvalOtherHostedPBX1)) {
						errorMsgList.add('Please enter the other value for &quot;Hosted PBX&quot;');
					} 
	    		}
				
				if(strSelectedWhoDidWeWin == null || strSelectedWhoDidWeWin == '') {
	    			errorMsgList.add('Please select &quot;Why Did We win?&quot;');
	    		} else {
					if(strSelectedWhoDidWeWin == 'Integrations' && string.isBlank(strsectedWonReasonIntegrations)) {
						errorMsgList.add('Please select the competitor value for &quot;Integrations&quot;');
					} else if(strSelectedWhoDidWeWin == 'Services and Features' && string.isBlank(strsectedWonReasonServiceAndFeatures)) {
						errorMsgList.add('Please select the competitor value for &quot;Services and Features&quot;');
					}  else if(strSelectedWhoDidWeWin == 'Won Reason - All' && string.isBlank(strselectedWonReasonAll)) {
						errorMsgList.add('Please select the competitor value for &quot;Won Reason - All&quot;');
					}
	    		}
	    		
				
			    system.debug('errorMsgList'+errorMsgList);
		        if(errorMsgList.size()>0){
		        	 toshowerrorMsg = true;
		        	 return null;
		        }
		        opportunityObj.StageName = '7. Closed Won';//'8. Closed Won';
		        opportunityObj.Probability = 100;
		        opportunityObj.Who_Did_We_Beat__c = strSelectedWhoDidWeBeat;
		        opportunityObj.Why_did_we_win__c = strSelectedWhoDidWeWin;
		        opportunityObj.Who_What_are_we_replacing__c = strSelectedWhoDidWeBeat1;
				opportunityObj.WhoDidWeBeatOther__c = strsectiontOtherWhoDidWeBeat;
				if(opportunityObj.Who_Did_We_Beat__c == 'On-Premise PBX') {
					opportunityObj.Competitor_Who_did_we_beat__c = strsectedOnPremisePBXdetail;
					if(opportunityObj.Competitor_Who_did_we_beat__c == 'Other (provide detailed reason)') {
						opportunityObj.Other_Competitor_Who_did_we_beat__c = strvalOtherOnPremisePBX; 
						opportunityObj.Competitor_Who_did_we_beat__c = 'Other' + ' - ' + opportunityObj.Who_Did_We_Beat__c; 
					}
				} else if(opportunityObj.Who_Did_We_Beat__c == 'Hosted PBX') {
					opportunityObj.Competitor_Who_did_we_beat__c = strsectedHostedPBXdetail;
					if(opportunityObj.Competitor_Who_did_we_beat__c == 'Other (provide detailed reason)') {
						opportunityObj.Other_Competitor_Who_did_we_beat__c = strvalOtherHostedPBX; 
						opportunityObj.Competitor_Who_did_we_beat__c = 'Other' + ' - ' + opportunityObj.Who_Did_We_Beat__c; 
					}
				}
				
				if(opportunityObj.Who_What_are_we_replacing__c == 'On-Premise PBX') {
					opportunityObj.Competitor_Who_What_are_we_replacing__c = strsectedOnPremisePBXdetail1;
					if(opportunityObj.Competitor_Who_What_are_we_replacing__c == 'Other (provide detailed reason)') {
						opportunityObj.OtherCompetitorWho_What_are_we_replacing__c = strvalOtherOnPremisePBX1; 
						opportunityObj.Competitor_Who_What_are_we_replacing__c = 'Other' + ' - ' + opportunityObj.Who_What_are_we_replacing__c; 
					}
				} else if(opportunityObj.Who_What_are_we_replacing__c == 'Hosted PBX') {
					opportunityObj.Competitor_Who_What_are_we_replacing__c = strsectedHostedPBXdetail1;
					if(opportunityObj.Competitor_Who_What_are_we_replacing__c == 'Other (provide detailed reason)') {
						opportunityObj.OtherCompetitorWho_What_are_we_replacing__c = strvalOtherHostedPBX1; 
						opportunityObj.Competitor_Who_What_are_we_replacing__c = 'Other' + ' - ' + opportunityObj.Who_What_are_we_replacing__c; 
					}
				}  
				
				
				if(opportunityObj.Why_did_we_win__c == 'Services and Features') {
					opportunityObj.Competitor_Who_did_we_Win__c = strsectedWonReasonServiceAndFeatures;
					/*if(opportunityObj.Competitor_Who_did_we_Win__c == 'Other (provide detailed reason)') {
						opportunityObj.Competitor_Who_did_we_Win__c = strsectedWonReasonServiceAndFeatures; 
						opportunityObj.Competitor_Who_did_we_Win__c = 'Other' + ' - ' + opportunityObj.Why_did_we_win__c; 
					}*/
				} else if(opportunityObj.Why_did_we_win__c == 'Integrations') {
					opportunityObj.Competitor_Who_did_we_Win__c = strsectedWonReasonIntegrations;
					/*if(opportunityObj.Competitor_Who_did_we_Win__c == 'Other (provide detailed reason)') {
						opportunityObj.Competitor_Who_did_we_Win__c = strsectedWonReasonIntegrations; 
						opportunityObj.Competitor_Who_did_we_Win__c = 'Other' + ' - ' + opportunityObj.Why_did_we_win__c; 
					}*/
				}  
				
				else if(opportunityObj.Why_did_we_win__c == 'Won Reason - All') {
					opportunityObj.Competitor_Who_did_we_Win__c = strselectedWonReasonAll;
					/*if(opportunityObj.Competitor_Who_did_we_Win__c == 'Other (provide detailed reason)') {
						opportunityObj.Competitor_Who_did_we_Win__c = strvalOtherOnWonReasonAll; 
						opportunityObj.Competitor_Who_did_we_Win__c = 'Other' + ' - ' + opportunityObj.Why_did_we_win__c; 
					}*/
				}  
				
		        system.debug('#### opportunity to update - '+opportunityObj);
		        update opportunityObj;
		        
		        /* 
				Below logic is to set the Implementation Scheduler, pop-up for 
				        	- Opportunity Record Type = Sales Opportunity, Sales Opportunity – zQuote
				        	- Account No of DLs = 1, if null, refer Opportunity forcasted user = 1
				        	- Account Do Not Create Implementation is not true 
				        	- Implementation is not completed
				        	- Tier as in custom setting.
				        	- Business Type as in custom setting.
				        	- Brand as in custom setting.
				*/
		        toShowImplementationScheduler = toShowImplementationAppointment(opportunityObj);
		        holdOpp.Primary_Opportunity_Contact__c = getImplementationContact(opportunityObj);
		        system.debug('#### toShowImplementationScheduler - '+toShowImplementationScheduler);
		        system.debug('#### ContactId - '+holdOpp.Primary_Opportunity_Contact__c);
		        implementationContact = holdOpp.Primary_Opportunity_Contact__c; 
		        
	    	} else {
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured');
				ApexPages.addMessage(myMsg);
	    	}
			/* If Implementaion is closed, no need to show the implementation Scheduler Appointment page, 
               redirect to Opportunity page. */
            if(toShowImplementationScheduler == null || !toShowImplementationScheduler){
                string oppId = '/'+opportunityObj.id;
                PageReference rtrnPage = new PageReference(oppId) ;
                rtrnPage.setRedirect(true);
                return rtrnPage;
            } 
    	} catch(Exception ex) {
    		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
			ApexPages.addMessage(myMsg);
    	}
    	return null;
    }
    
	public List<SelectOption> getWhoDidWeBeat() {
	   List<SelectOption> options = getOptionList('Who_Did_We_Beat__c');
       return options; 
	}
    
     public List<SelectOption> getWhoDidWeWin() {
	   List<SelectOption> options = getOptionList('Why_did_we_win__c');
       return options; 
	}
    public List<SelectOption> getWhoWhatAreWeReplacing() {
       List<SelectOption> options = getOptionList('Who_What_are_we_replacing__c');
       return options; 
    }
    
    public List<SelectOption> getOnPremisePBX(){
    	List<SelectOption> options = getOptionList('On_Premise_PBX__c');
    	return options;
    }
    
    public List<SelectOption> getHostedPBX(){
    	List<SelectOption> options = new List<SelectOption>();	//getOptionList('Hosted_PBX__c');
    	String OppId = ApexPages.currentPage().getParameters().get('Id');
    	opportunityObj = [select Brand_Name__c from Opportunity where id =: OppId];
    	getHostedPBXRCUK();
    	getHostedPBXRCandRCCanada();
    	for(SelectOption option:getOptionList('Hosted_PBX__c')){
    		if(opportunityObj.Brand_Name__c == 'RingCentral UK'){
				if(setHostedPBXRCUK.contains(String.valueOf(option.getValue()))){
					options.add(option);
				}
			} else {
			//if(opportunityObj.Brand_Name__c == 'RingCentral' || opportunityObj.Brand_Name__c == 'RingCentral Canada'){
				if(setHostedPBXRCandRCCanada.contains(String.valueOf(option.getValue()))){
					options.add(option);
				}
			//}
    		}
		}
		return options;
    }
    
 	public List<SelectOption> getOnPremisePBX1(){
    	List<SelectOption> options = getOptionList('On_Premise_PBX__c');
    	return options;
    }
    
    public List<SelectOption> getHostedPBX1(){
    	List<SelectOption> options = getOptionList('Hosted_PBX__c');
    	return options;
    }
	
	 public List<SelectOption> getWonReasonServiceAndFeatures(){
    	List<SelectOption> options = getOptionList('Won_Reason_Service_and_Features__c');
    	return options;
    }
	
	 public List<SelectOption> getWonReasonIntegrations(){
    	List<SelectOption> options = getOptionList('Won_Reason_Integrations__c');
    	return options;
    }
    
     public List<SelectOption> getWonReasonAll(){
    	List<SelectOption> options = getOptionList('Won_Reason_All__c');
    	return options;
    }
    
	public List<SelectOption> getOptionList(string fieldApi) {                     
   		List<SelectOption> options = new List<SelectOption>(); 
   		try {
            Schema.sObjectType sobjectType = Opportunity.getSObjectType(); 
            Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe(); 
            Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap(); 
            List<Schema.PicklistEntry> pickListValues = fieldMap.get(fieldApi).getDescribe().getPickListValues(); 
            for (Schema.PicklistEntry picklstval : pickListValues) { 
            	options.add(new selectOption(picklstval.getvalue(), picklstval.getvalue())); 
            }
		} catch(Exception ex) {}
   		return options; 
    }
	
	public PageReference cancel() { 
        PageReference rtrnPage;
        try {
            if(ApexPages.currentPage().getParameters().get('retURL') != null) {
                string pgref = ApexPages.currentPage().getParameters().get('retURL');
                rtrnPage = new PageReference(pgref);
            } else {
            	string oppId = '/'+ApexPages.currentPage().getParameters().get('Id');  
            	rtrnPage = new PageReference(oppId);
            }
        }
        catch(Exception ex) {}
        return rtrnPage;
    }
    
    public set<String> setHostedPBXRCUK{get;set;}// = new set<String>();
 	public set<String> setHostedPBXRCandRCCanada{get;set;}// = new set<String>();
    public void getHostedPBXRCandRCCanada(){
    	setHostedPBXRCandRCCanada = new Set<String>();
    	setHostedPBXRCandRCCanada.add('8x8');
    	setHostedPBXRCandRCCanada.add('Avaya Live');
		setHostedPBXRCandRCCanada.add('Vonage Business Services');
		setHostedPBXRCandRCCanada.add('eVoice');
		setHostedPBXRCandRCCanada.add('Fonality');
		setHostedPBXRCandRCCanada.add('Jive');
		setHostedPBXRCandRCCanada.add('Megapath');
		setHostedPBXRCandRCCanada.add('Microsoft Lync');
		setHostedPBXRCandRCCanada.add('Nextiva');
		setHostedPBXRCandRCCanada.add('Phone.com');
		setHostedPBXRCandRCCanada.add('ShoreTel Sky');
		setHostedPBXRCandRCCanada.add('Other (provide detailed reason)');
	//return setHostedPBX;
	}
	
	 public void getHostedPBXRCUK(){
    	setHostedPBXRCUK = new Set<String>();
    	setHostedPBXRCUK.add('8x8');
    	setHostedPBXRCUK.add('BT');
		setHostedPBXRCUK.add('Simple Signal');
		setHostedPBXRCUK.add('Sipgate');
		setHostedPBXRCUK.add('Soho66');
		setHostedPBXRCUK.add('Vodaphone - One Net');
		setHostedPBXRCUK.add('Other (provide detailed reason)');
	//return setHostedPBX;
	}
	
	/*********************************************************************************************
	* @Description : get Implementation contact.                                                 * 
	* @Params      : opportunity                                                                 *
	* @Return      : Id                                                                          * 
	*********************************************************************************************/
    public Id getImplementationContact(Opportunity opportunityObj){
    	
    	Id contactId;
    	try{
    		//string oppId = '/'+opportunityObj.id;
    		Opportunity opportunityDetails =  new Opportunity();
    		opportunityDetails = [SELECT Account.Most_Recent_Implementation_Contact__c, AccountId, 
										(SELECT ContactId, IsPrimary, LastModifiedDate 
										 FROM OpportunityContactRoles 
										 WHERE IsPrimary = true order by LastModifiedDate asc) 
								  FROM Opportunity WHERE Id =: opportunityObj.Id];
    		
    		system.debug('#### Opportunity Details - '+opportunityDetails);	
    		system.debug('#### Opportunity Contact Role Details - '+opportunityDetails.OpportunityContactRoles);								  
			if(opportunityDetails.OpportunityContactRoles != null && opportunityDetails.OpportunityContactRoles.size() > 0){
				contactId = opportunityDetails.OpportunityContactRoles[0].contactId; 	
			}else if(opportunityDetails.Account.Most_Recent_Implementation_Contact__c != null){
				contactId = opportunityDetails.Account.Most_Recent_Implementation_Contact__c;
			}else{
				contactId = [SELECT Id,LastModifiedDate 
							 FROM Contact 
							 WHERE AccountId =: opportunityDetails.AccountId order by LastModifiedDate asc limit 1].Id; 	
			}
			system.debug('#### Contact Id - '+contactId);
    	}catch(Exception ex){}
    	return contactId;	
    }
    
    /*********************************************************************************************
	* @Description : If implementation is completed or not.                                      * 
	* @Params      : Id                                                                          *
	* @Return      : Boolean                                                                     * 
	*********************************************************************************************/
    public Boolean isImplementationCompleted(Id accountId){
    	for(Implementation__c thisRecord : [SELECT Id,Implementation_Status_2__c FROM Implementation__c WHERE Account__r.Id =: accountId]){
    		if(thisRecord.Implementation_Status_2__c != null && thisRecord.Implementation_Status_2__c.contains('Completed')){
    			return true;
    		}
    	}	
    	return false;
    }
    
    /*********************************************************************************************
	* @Description : Method to check if the opportunity meets the criteria for displaying,       *
	*				 the Implementation Scheduler pop-up.                                        * 
	* @Params      : Opportunity                                                                 *
	* @Return      : Boolean                                                                     * 
	*********************************************************************************************/    
    public Boolean toShowImplementationAppointment(Opportunity opportunityRecord){
    	// Declaring variables to contain custom setting values.
    	Set<String> availableOpportunityRecordType = new Set<String>();
    	Set<String> availableBrand = new Set<String>();
    	Set<String> availableBusinessType = new Set<String>();
    	Set<String> availableTier = new Set<String>();
    	Decimal numberOfDLs;
    	
    	// Fetch opportunity record types 
   		Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
   		Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
    	
    	// Fetch the opportunity record types value in a set, for which the Advisor block need to be visible.
    	if(Implementation_Scheduler__c.getValues('Opportunity Record Types') != null && 
           Implementation_Scheduler__c.getValues('Opportunity Record Types').Values__c != null ){
   				
   			availableOpportunityRecordType.addAll(Implementation_Scheduler__c.getValues('Opportunity Record Types').Values__c.split(',',0));
        }
        
		// Fetch Brands, for which the Advisor block need to be visible.
        if(Implementation_Scheduler__c.getValues('Brand') != null && 
           Implementation_Scheduler__c.getValues('Brand').Values__c != null ){
   				
   			availableBrand.addAll(Implementation_Scheduler__c.getValues('Brand').Values__c.split(',',0));
        }
        
        // Fetch Business Type, for which the Advisor block need to be visible.
        if(Implementation_Scheduler__c.getValues('Business Type') != null && 
           Implementation_Scheduler__c.getValues('Business Type').Values__c != null ){
   				
   			availableBusinessType.addAll(Implementation_Scheduler__c.getValues('Business Type').Values__c.split(',',0));
        }
        
        // Fetch Tier, for which the Advisor block need to be visible.
        if(Implementation_Scheduler__c.getValues('Tier') != null && 
           Implementation_Scheduler__c.getValues('Tier').Values__c != null ){
   				
   			availableTier.addAll(Implementation_Scheduler__c.getValues('Tier').Values__c.split(',',0));
        }
        
        // Fetch Number of Dls, for which the Advisor block need to be visible.
        if(Implementation_Scheduler__c.getValues('Number of DLs') != null && 
		   Implementation_Scheduler__c.getValues('Number of DLs').Values__c != null ){
				           		
        	numberOfDLs = Decimal.valueOf(Implementation_Scheduler__c.getValues('Number of DLs').Values__c);
		}
		
		/* System Debugs for Custom Setting Set. */
		system.debug('#### Code at toShowImplementationAppointment - availableOpportunityRecordType - '+availableOpportunityRecordType);
		system.debug('#### Code at toShowImplementationAppointment - availableBrand - '+availableBrand);
		system.debug('#### Code at toShowImplementationAppointment - availableBusinessType - '+availableBusinessType);
		system.debug('#### Code at toShowImplementationAppointment - availableTier - '+availableTier);
		system.debug('#### Code at toShowImplementationAppointment - numberOfDLs - '+numberOfDLs);
		
		/* System Debugs for Opportunity Field values. */
		system.debug('#### Code at toShowImplementationAppointment - Record Type Id - '+opportunityRecord.recordTypeId);
		system.debug('#### Code at toShowImplementationAppointment - Brand - '+opportunityRecord.Brand_Name__c);
		system.debug('#### Code at toShowImplementationAppointment - Type - '+opportunityRecord.Type);
		system.debug('#### Code at toShowImplementationAppointment - Tier - '+opportunityRecord.Tier_Name__c);
		system.debug('#### Code at toShowImplementationAppointment - Number of Dls - '+opportunityRecord.Account.Number_of_DL_s__c);
		system.debug('#### Code at toShowImplementationAppointment - Implementation Completed - '+isImplementationCompleted(opportunityObj.AccountId));
		system.debug('#### Code at toShowImplementationAppointment - Forecasted User - '+opportunityRecord.Forecasted_Users__c);
		
		
		// Validations to show the Implementation block.
		/* 
		Below logic is to set the Implementation Scheduler, pop-up for 
		        	- Opportunity Record Type = Sales Opportunity, Sales Opportunity – zQuote
		        	- Account No of DLs = 1, if null, refer Opportunity forcasted user = 1
		        	- Account Do Not Create Implementation is not true 
		        	- Implementation is not completed
		        	- Tier as in custom setting.
		        	- Business Type as in custom setting.
		        	- Brand as in custom setting.
		*/
		if(availableOpportunityRecordType.contains(rtMapById.get(opportunityRecord.recordTypeId).Name) && 
		  (availableBrand.contains(opportunityRecord.Brand_Name__c)) && (availableBusinessType.contains(opportunityRecord.Type)) && 
		  (availableTier.contains(opportunityRecord.Tier_Name__c)) && !opportunityObj.Account.Do_Not_Creation_Implementation__c && 
		   !isImplementationCompleted(opportunityObj.AccountId) && 
   		   ((opportunityObj.Account.Number_of_DL_s__c != null && opportunityRecord.Account.Number_of_DL_s__c > numberOfDLs) || 
   		    (opportunityObj.Account.Number_of_DL_s__c == null && opportunityRecord.Forecasted_Users__c != null && opportunityRecord.Forecasted_Users__c > numberOfDLs))){
   				
   				system.debug('#### TRUE');
   				return true;
   		}
   		system.debug('#### FALSE');
   		return false;		
    }
}