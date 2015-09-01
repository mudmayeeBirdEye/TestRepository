public with sharing class OpportunityDowngrade {
     public List<string> lstselectedChangingReasons {get;set;}
     public string selectedDowngradeReasons {get;set;}
     public string sectedSubDowngradeReason {get;set;}
     public List<string> lstsectedDownsellReasons {get;set;}
     public List<string> lstselectedCouldnotworkingdetail {get;set;}
     public List<string> lstsectedmissingfeature {get;set;}
     public List<string> lstsectedQOsdetail {get;set;}
     public List<string> lstsectedCXDetaildetail {get;set;}
     public string finalSelectedCXDetaildetail{get;set;}
     public List<string> lstsectedCompanyDetaildetail {get;set;}
     public string lstsectedHostedPBXdetail {get;set;}
     public string lstsectedOnPremisePBXdetail {get;set;}
     public string lstselectedCellPhoneOnly{get;set;}//CellPhoneOnly
     public string lstSelectedLandLine{get;set;}//Land Line
     public List<string> lstSelectedTraditional{get;set;}//Tradtional
     public List<string> lstsectedFax {get;set;}//Fax
     public List<String> lstselectedcostDetail {get;set;} 
     public List<string> lstselectedNothing {get;set;}  
     public List<string> lstConsolidatingAccount{get;set;}    //RingCentral – Consolidating Account
     public boolean toshowmissingfeature {get;set;} 
     public boolean toshowCouldnotworkingdetail {get;set;}
     public boolean toshowQOsdetail {get;set;}
     public boolean toshowotherdetail {get;set;}
     public boolean toshowFax{get;set;}
     public boolean toshowerrorMsg {get;set;}
     public List<string> errorMsgList {get;set;} 
     public Opportunity opportunityObj{get;set;}
     public List<string> tempList {get;set;}
     public boolean toshowOther_PDR {get;set;}//Other (provide detailed reason)- RingCentral – Consolidating Account
	 public boolean toshowNothing{get;set;}
	 public boolean toshowSpecifyOthers {get;set;}//other
	 public boolean toshowLandline{get;set;}//LandLine
	 public boolean toshowCellPhoneOnly{get;set;}//cell Phone Only 
	 public boolean toshowOnPremisePBX{get;set;}
	 public boolean toshowHostedPBX{get;set;}//updated
     public boolean atntSection{get;set;}
     public boolean retentionSection{get;set;}
     public boolean showTimeframeOther{get;set;}
     public boolean showMissingCriticalOther{get;set;}
     public boolean showSubDowngradeReasonNotBANT {get;set;}
     public boolean showSubDowngradeReasonUnableContact {get;set;}
     public boolean showSubDowngradeReasonNotNew {get;set;}
     public boolean showSubDowngradeReasonBandwidth {get;set;}
     public boolean showSubDowngradeReasonConcernsAbout {get;set;}
     public boolean showSubDowngradeReasonMissingCriti {get;set;}
     public boolean showSubDowngradeReasonPrice {get;set;}
     public boolean showSubDowngradeReasonReviews {get;set;}
     public boolean showOtherReason {get;set;}
     public boolean showSubOtherReason {get;set;}
     public string finalSelectedReason = '';
     public string seletedRsnforBnt {get;set;}
     public string finalSelectedSubReason = '';
     public string finalSelectedSubOther = '';
  	 public boolean toShowMainPanel {get;set;}
  	 public string brand;
  	 public string strDownGradeRsn;
     public string strSubDownGradeRsn;
     set<string> issueWithRingcentralSet = new set<string>();
     public String recordTypeName{get;set;}
     public OpportunityDowngrade(ApexPages.StandardController controller) {
     	try {
     		if(controller.getId() != null) {
     			this.opportunityObj = (Opportunity)controller.getRecord();
     			Opportunity oppObjNew = [select Downgrade_Reason_Opp__c,Sub_Downgrade_Reason__c,RecordType.Name
		        							from Opportunity where Id = :controller.getId()  limit 1];
		        if(oppObjNew != null && oppObjNew.RecordType != null) {
					recordTypeName = oppObjNew.RecordType.Name;
				}							
     			//brand = leadObjNew.Lead_Brand_Name__c != null? leadObjNew.Lead_Brand_Name__c : 'RingCentral';
     			strDownGradeRsn = oppObjNew.Downgrade_Reason_Opp__c;
     			strSubDownGradeRsn = oppObjNew.Sub_Downgrade_Reason__c;
     			toShowMainPanel = false;
		        checkIsRecordTypePermitted(opportunityObj.recordTypeID);
		        opportunityObj.What_will_cx_use_for_their_phone_system__c = '';
				opportunityObj.Hosted_PBX__c = '';
				opportunityObj.On_Premise_PBX__c = '';
				opportunityObj.Cell_phone_only__c = '';
				opportunityObj.Land_line__c = '';
				opportunityObj.Traditional__c = '';
				opportunityObj.Nothing__c = '';
				opportunityObj.Specify_other__c = '';
		        showMissingCriticalOther = false;
		        atntSection = false;
		        retentionSection = false;
		        showTimeframeOther = false;
		        showSubOtherReason=false;
		        showOtherReason =false;
		        showSubDowngradeReasonNotBANT = false;
		        showSubDowngradeReasonUnableContact = false;
		        showSubDowngradeReasonNotNew = false;
		        showSubDowngradeReasonBandwidth = false;
		        showSubDowngradeReasonConcernsAbout = false;
		        showSubDowngradeReasonMissingCriti = false;
		        showSubDowngradeReasonPrice = false;
		        finalSelectedCXDetaildetail = '';
		        showSubDowngradeReasonReviews = false;
		        lstselectedChangingReasons = new List<string>();
		        selectedDowngradeReasons = '';
		        sectedSubDowngradeReason='';
		        lstsectedDownsellReasons = new List<string>();
		        lstselectedCouldnotworkingdetail = new List<string>();
		        lstsectedmissingfeature = new List<string>(); 
		        lstsectedQOsdetail = new List<string>();
		        lstsectedCXDetaildetail = new List<string>();
		        lstsectedCompanyDetaildetail = new List<string>();
		        errorMsgList = new List<string>();
		        lstsectedOnPremisePBXdetail = '';//
		        lstselectedCellPhoneOnly = '';//CellPhoneOnly
		        lstSelectedLandLine = '';//Land Line
		        lstSelectedTraditional = new List<string>();//Tradtional
		        lstsectedFax = new List<string>();//Fax
		        lstsectedHostedPBXdetail = '';
		        lstselectedcostDetail = new List<string>();
		        lstselectedNothing = new List<string>(); 
		        lstConsolidatingAccount = new List<string>(); //RingCentral – Consolidating Account
		        toshowCouldnotworkingdetail = false;
		        toshowSpecifyValue = false;
		        toshowmissingfeature = false;
		        toshowQOsdetail = false;
		        toshowotherdetail = false;
		        toShowCustomerSection = false;
		        toshowerrorMsg = false;
		        toshowFax = false;
		        tempList = new List<string>();
		        tempList.add('test');
		        setIssueWithRingcentralValues();
                isIssueWithRingcentralSelected = false;       		
     		}
     	} catch(Exception ex) {}
     }
     
     public boolean isIssueWithRingcentralSelected {get;set;}
  	 public boolean isLostOpportunity {get;set;}
  	 public string strSubDowngradeRsnLabel {get;set;}  
     public void onChangeReason(){
     	toshowerrorMsg = false;
     	toshowHostedPBX = false;
     	toshowOnPremisePBX = false;
        toShowOtherSubCompetitorBox = false;
     	isIssueWithRingcentralSelected = false;
     	showSubDowngradeReasonNotBANT = false;
        showSubDowngradeReasonUnableContact = false;
        showSubDowngradeReasonNotNew = false;
        showSubDowngradeReasonBandwidth = false;
        showSubDowngradeReasonConcernsAbout = false;
        showSubDowngradeReasonMissingCriti = false;
        showSubDowngradeReasonPrice = false;
    	showSubDowngradeReasonReviews = false;
    	showOtherReason = false;
    	atntSection = false;
     	retentionSection =false;
     	isLostOpportunity = false;
     	showSubOtherReason = false;
     	showSubOtherReason = false;
     	showMissingCriticalOther = false;
        showTimeframeOther = false;
     	strSubDowngradeRsnLabel = 'Sub-Downgrade Reason';
     	finalSelectedReason = selectedDowngradeReasons;
     	sectedSubDowngradeReason = '';
     	finalSelectedSubReason = '';
        opportunityObj.Sub_Downgrade_Reason_Other__c = '';
        opportunityObj.Specify_other__c = '';
     	system.debug('11111111111111111111 '+selectedDowngradeReasons);
     	if(selectedDowngradeReasons == 'Not BANT qualified'){
     		showSubDowngradeReasonNotBANT = true;
	 	} else if(selectedDowngradeReasons == 'Unable to contact'){
     		showSubDowngradeReasonUnableContact = true;
     	} else if(selectedDowngradeReasons == 'Not a new prospect'){
     		showSubDowngradeReasonNotNew = true; 
    	} else if(selectedDowngradeReasons == 'Bandwidth / Wiring'){
     		showSubDowngradeReasonBandwidth = true; 
     	} else if(selectedDowngradeReasons == 'Concerns about reliability / usability / support'){
     		showSubDowngradeReasonConcernsAbout = true; 
     	} else if(selectedDowngradeReasons == 'Missing critical features'){
     		showSubDowngradeReasonMissingCriti = true;
     		strSubDowngradeRsnLabel = 'Missing critical features';
     	} else if(selectedDowngradeReasons == 'Hosted PBX') {
     		toshowHostedPBX = true;
            strSubDowngradeRsnLabel = 'Hosted PBX';
	        isLostOpportunity = true;
 		} else if(selectedDowngradeReasons == 'On-Premise PBX') {
 			toshowOnPremisePBX = true;
 	        isLostOpportunity = true;
	        strSubDowngradeRsnLabel = 'On-Premise PBX';
     	}  else if(selectedDowngradeReasons == 'Prefers not to say' || selectedDowngradeReasons == 'Other') {
     		isLostOpportunity = true;
            if(selectedDowngradeReasons == 'Other'){
	        	showOtherReason = true;
	        }
	        atntSection = true;	
	        retentionSection = true;
     	} else if(selectedDowngradeReasons == '' || selectedDowngradeReasons == 'Retention Opp Closed'
     				|| selectedDowngradeReasons=='AT&T Seller' || selectedDowngradeReasons=='Purchase Blocker' || 
     				selectedDowngradeReasons=='Doesn’t have mobility number' 
     				|| selectedDowngradeReasons == 'Lost Budget - project not funded' ||
	 				selectedDowngradeReasons == 'Too Much Risk' ||
	 				selectedDowngradeReasons == 'Project deprioritized' ||
	 				selectedDowngradeReasons == 'Sponsor left company' ||
	 				selectedDowngradeReasons == 'Just doing research stage' ||
	 				selectedDowngradeReasons == 'Future project - give a date - task' ||
	 				selectedDowngradeReasons == 'Building move delayed' ||
	 				selectedDowngradeReasons == 'Not enough bandwidth/infrastructure' ||
	 				selectedDowngradeReasons == 'Waiting for contract to end'){
            if(selectedDowngradeReasons == 'Other'){
	        	showOtherReason = true;
	        }
	        atntSection = true;
	        retentionSection = true;	
     	}else {
     		
     	}
     }
     
     public void onChangeSubReason(){
     	toshowerrorMsg = false;
     	opportunityObj.Downgrade_Reason_Other__c = '';
     	opportunityObj.Sub_Downgrade_Reason_Other__c = '';
     	showSubOtherReason = false;
     	showMissingCriticalOther = false;
        showTimeframeOther = false;
        toShowOtherSubCompetitorBox = false;
     	
     	finalSelectedSubReason = sectedSubDowngradeReason;
     	if(sectedSubDowngradeReason == 'Other (provide detailed reason)'){
     		if(isLostOpportunity) {
     			toShowOtherSubCompetitorBox = true;
     		} else if(!isLostOpportunity) {
     			showSubOtherReason = true;
     		}
     	} else if(sectedSubDowngradeReason == 'Time frame greater than X months'){
     		showTimeframeOther = true;
     	} else if(sectedSubDowngradeReason == 'Call Center Functionality' || sectedSubDowngradeReason == 'CRM Integration' 
     			 || sectedSubDowngradeReason == 'Large Account Management / UI limitations' || sectedSubDowngradeReason == 'Mobile features'
     			 || sectedSubDowngradeReason == 'Voicemail Transcription (VM to Text)'){
     		showMissingCriticalOther = true;
     		system.debug('@@@@@@ showMissingCriticalOther '+showMissingCriticalOther);
     	}
     	System.Debug('>>showSubOtherReason>>'+ showSubOtherReason);
     }
     
     public PageReference next() {
		toShowCustomerSection = true;
	    toshowerrorMsg = false;
	    errorMsgList = new List<string>();
	    if(finalSelectedReason == null || finalSelectedReason == '' ) {
	        toshowerrorMsg = true;
	        toShowCustomerSection = false;
	        errorMsgList.add('Please select Downgrade Reason.');
	    } else if((finalSelectedSubReason == null || finalSelectedSubReason == '') && finalSelectedReason != 'Prefers not to say') {
        	if(finalSelectedReason == 'Hosted PBX') {
        		toshowerrorMsg = true;
            	toShowCustomerSection = false;
        		errorMsgList.add('Please select Hosted PBX.');
        	} else if(finalSelectedReason == 'On-Premise PBX') {
        		toshowerrorMsg = true;
            	toShowCustomerSection = false;
        		errorMsgList.add('Please select On-Premise PBX.');
        	} else if(finalSelectedReason == 'Other' && (opportunityObj.Specify_other__c == '' || opportunityObj.Specify_other__c == null)) {
        		toshowerrorMsg = true;
            	toShowCustomerSection = false;
        		errorMsgList.add('Please select other value for Lost opportunity.');
        	}
        }
	    selectedDowngradeReasons = finalSelectedReason;
	    sectedSubDowngradeReason = finalSelectedSubReason;
	    return null;
     }
     
     public boolean toShowCustomerSection {get;set;}
     public PageReference updateOpp() {
        try {
            opportunityObj.Downgrade_Reason_Opp__c =  '';
	        opportunityObj.Sub_Downgrade_Reason__c =  '';
	        opportunityObj.Downgrade_Customer__c = '';
        	opportunityObj.Primary_Competitor__c = '';
        	opportunityObj.What_will_cx_use_for_their_phone_system__c = '';
        	opportunityObj.On_Premise_PBX__c = '';
        	opportunityObj.Hosted_PBX__c = '';
            toshowerrorMsg = false;
            errorMsgList = new List<string>();
            if(!toShowCustomerSection) {
            	if(finalSelectedReason == null || finalSelectedReason == '' ) {
		            toshowerrorMsg = true;
		            toShowCustomerSection = false;
		            errorMsgList.add('Please select the Downgrade Reason.');
		        } else if((finalSelectedSubReason == null || finalSelectedSubReason == '') && (finalSelectedReason != 'Other' && 
		                    finalSelectedReason != 'AT&T Seller' && finalSelectedReason != 'Purchase Blocker' && 
		                    finalSelectedReason != 'Retention Opp Closed' && 
		                    finalSelectedReason != 'Doesn’t have mobility number' &&
		                    finalSelectedReason != 'Lost Budget - project not funded' &&
			 				finalSelectedReason != 'Too Much Risk' &&
			 				finalSelectedReason != 'Project deprioritized' &&
			 				finalSelectedReason != 'Sponsor left company' &&
			 				finalSelectedReason != 'Just doing research stage' &&
			 				finalSelectedReason != 'Future project - give a date - task' &&
			 				finalSelectedReason != 'Building move delayed' &&
			 				finalSelectedReason != 'Not enough bandwidth/infrastructure' &&
			 				finalSelectedReason != 'Waiting for contract to end')){
		            toshowerrorMsg = true;
		            toShowCustomerSection = false;
		            errorMsgList.add('Please select Sub-Downgrade Reason.');
		        }
		        if(finalSelectedReason == 'Other' && (opportunityObj.Downgrade_Reason_Other__c == '' || opportunityObj.Downgrade_Reason_Other__c == null)){
		            toshowerrorMsg = true;
		            toShowCustomerSection = false;
		            errorMsgList.add('Please provide detailed reason.');
		        }
		        if(finalSelectedSubReason == 'Time frame greater than X months' && 
		           	(opportunityObj.Timeframe_greater_than_X_months__c == '' || opportunityObj.Timeframe_greater_than_X_months__c == null)){
		            toshowerrorMsg = true;
		            toShowCustomerSection = false;
		            errorMsgList.add('Please provide timeframe months detail.');
		        }
		        if(finalSelectedSubReason == 'Other (provide detailed reason)' && 
		           (opportunityObj.Sub_Downgrade_Reason_Other__c == '' || opportunityObj.Sub_Downgrade_Reason_Other__c == null)
		           ){
		            toshowerrorMsg = true; 
		            toShowCustomerSection = false;
		            errorMsgList.add('Please provide detailed sub-reason.');
		        }	
            } else if(toShowCustomerSection) {
                if(string.isBlank(strSelectedIssueWithRC)) {
                	toshowerrorMsg = true; 
		            errorMsgList.add('Please select the Downgrade Reason.');
                } else if(strSelectedIssueWithRC != 'Other' && string.isBlank(strSelectedSubIssueWithRC)) {
                	toshowerrorMsg = true; 
		            errorMsgList.add('Please select the Sub-Downgrade Reason.');
                } else if(strSelectedIssueWithRC == 'Other' && string.isBlank(opportunityObj.Downgrade_Reason_Other__c)) {
                	toshowerrorMsg = true; 
		            errorMsgList.add('Please specify the reason this record was Downgraded.');
                } else if(strSelectedIssueWithRC != null && strSelectedSubIssueWithRC == 'Other (provide detailed reason)' && 
		           (opportunityObj.Sub_Downgrade_Reason_Other__c == '' || opportunityObj.Sub_Downgrade_Reason_Other__c == null)
		           ){
		            toshowerrorMsg = true; 
		            errorMsgList.add('Please provide detailed sub-reason.');
		        }
            }
  
            
            if(toshowerrorMsg == false) {
        	 	if(finalSelectedSubReason != 'Time frame greater than X months') {
                    opportunityObj.Timeframe_greater_than_X_months__c = '';     
                } 
                if(finalSelectedReason != 'Other' && !isLostOpportunity) {
                	opportunityObj.Downgrade_Reason_Other__c = '';  
                }
                 
            	if(!isLostOpportunity) {
            		opportunityObj.Downgrade_Reason_Opp__c =  finalSelectedReason;
	         		opportunityObj.Sub_Downgrade_Reason__c =  finalSelectedSubReason;
            	} else if(isLostOpportunity) {
            		opportunityObj.What_will_cx_use_for_their_phone_system__c = finalSelectedReason;
            	    if(opportunityObj.What_will_cx_use_for_their_phone_system__c == 'Hosted PBX') {
        	    	 	opportunityObj.Hosted_PBX__c = finalSelectedSubReason;
                    	opportunityObj.Downgrade_Customer__c =   opportunityObj.Hosted_PBX__c;
                    	if(opportunityObj.Hosted_PBX__c == 'Prefers not to say') {
                        	opportunityObj.Primary_Competitor__c = opportunityObj.Hosted_PBX__c + ' - ' + opportunityObj.What_will_cx_use_for_their_phone_system__c;
                        	opportunityObj.Downgrade_Customer__c = opportunityObj.Hosted_PBX__c + ' - ' + opportunityObj.What_will_cx_use_for_their_phone_system__c;
	                    } else if(opportunityObj.Hosted_PBX__c == 'Other (provide detailed reason)') {
	                        opportunityObj.Primary_Competitor__c = 'Other' + ' - ' + opportunityObj.What_will_cx_use_for_their_phone_system__c;
	                        opportunityObj.Downgrade_Customer__c = 'Other' + ' - ' + opportunityObj.What_will_cx_use_for_their_phone_system__c;
	                    } else {
	                        opportunityObj.Primary_Competitor__c = opportunityObj.Hosted_PBX__c;
	                        opportunityObj.Downgrade_Customer__c = opportunityObj.Hosted_PBX__c;
	                    }
            	    } else if(opportunityObj.What_will_cx_use_for_their_phone_system__c == 'On-Premise PBX') {
            	    	opportunityObj.On_Premise_PBX__c = finalSelectedSubReason;
                    	opportunityObj.Downgrade_Customer__c =   opportunityObj.On_Premise_PBX__c;
                    	if(opportunityObj.On_Premise_PBX__c == 'Prefers not to say') {
                        	opportunityObj.Primary_Competitor__c = opportunityObj.On_Premise_PBX__c + ' - ' + opportunityObj.What_will_cx_use_for_their_phone_system__c;
                        	opportunityObj.Downgrade_Customer__c = opportunityObj.On_Premise_PBX__c + ' - ' + opportunityObj.What_will_cx_use_for_their_phone_system__c;
                     	} else if(opportunityObj.On_Premise_PBX__c == 'Other (provide detailed reason)') {
                        	opportunityObj.Primary_Competitor__c = 'Other' + ' - ' + opportunityObj.What_will_cx_use_for_their_phone_system__c;
                        	opportunityObj.Downgrade_Customer__c = 'Other' + ' - ' + opportunityObj.What_will_cx_use_for_their_phone_system__c;
                        } else {
                            opportunityObj.Primary_Competitor__c = opportunityObj.On_Premise_PBX__c;
                            opportunityObj.Downgrade_Customer__c = opportunityObj.On_Premise_PBX__c;
                    	}
                    } else {
                    	opportunityObj.Primary_Competitor__c = opportunityObj.What_will_cx_use_for_their_phone_system__c;
                        opportunityObj.Downgrade_Customer__c = opportunityObj.What_will_cx_use_for_their_phone_system__c;
                    }
                    opportunityObj.Other_SubCompetitors__c =  otherSubCompetitors;
                    opportunityObj.Downgrade_Reason_Opp__c =  strSelectedIssueWithRC;
	         		opportunityObj.Sub_Downgrade_Reason__c =  strSelectedSubIssueWithRC;
            	}
                opportunityObj.StageName = '0. Downgraded';
                update opportunityObj;
                return new pagereference('/'+opportunityObj.id);
        	}   
        } catch(Exception ex) {
            toshowerrorMsg = true;
            errorMsgList.add(ex.getMessage());
        }
        return null;
     }
     /*public PageReference updateOpp() {
        try {
        	opportunityObj.Downgrade_Customer__c = '';
        	opportunityObj.Primary_Competitor__c = '';
         	toshowerrorMsg = false;
            errorMsgList = new List<string>();
            if(!isIssueWithRingcentralSelected && !toShowCustomerSection) {
            	if(finalSelectedReason == null || finalSelectedReason == '' ) {
            		toshowerrorMsg = true;
            		toShowCustomerSection = false;
            		errorMsgList.add('Please select Downgrade Reason.');
		        } else if((finalSelectedSubReason == null || finalSelectedSubReason == '') && (finalSelectedReason != 'Retention Opp Closed' && finalSelectedReason != 'Other' && 
		        			finalSelectedReason != 'AT&T Seller' && finalSelectedReason != 'Purchase Blocker' &&  
		        			finalSelectedReason != 'Doesn’t have mobility number')){
		        	toshowerrorMsg = true;
		            toShowCustomerSection = false;
		            errorMsgList.add('Please select Sub-Downgrade Reason.');
		        }
		        if(finalSelectedReason == 'Other' && 
		            (opportunityObj.Downgrade_Reason_Other__c == '' || opportunityObj.Downgrade_Reason_Other__c == null)
		           ){
		        	toshowerrorMsg = true;
		            toShowCustomerSection = false;
		        	errorMsgList.add('Please provide detailed reason.');
		        }
		        if(finalSelectedSubReason == 'Time frame greater than X months' && 
		           (opportunityObj.Timeframe_greater_than_X_months__c == '' || opportunityObj.Timeframe_greater_than_X_months__c == null)
		           ){
		        	toshowerrorMsg = true;
		            toShowCustomerSection = false;
		        	errorMsgList.add('Please provide timeframe months detail.');
		        }
		        if(finalSelectedSubReason == 'Other (provide detailed reason)' && 
		           (opportunityObj.Sub_Downgrade_Reason_Other__c == '' || opportunityObj.Sub_Downgrade_Reason_Other__c == null)
		           ){
		        	toshowerrorMsg = true;
		            toShowCustomerSection = false;
		        	errorMsgList.add('Please provide detailed sub-reason.');
		        }		
            } else {
	            if(lstsectedCXDetaildetail.size() == 0) {
	                toshowerrorMsg = true;
	                errorMsgList.add('Please select &quot;What will cx use instead?&quot;');
	            } 
	            if(lstsectedCXDetaildetail != null && lstsectedCXDetaildetail.size() > 0) {
	                for(string str : lstsectedCXDetaildetail) {
	                    if(str == 'Prefers not to say') {
	                        toshowerrorMsg = false;
	                        opportunityObj.Specify_other__c = '';
	                        lstsectedCompanyDetaildetail = new List<string>();
	                        break;  
	                    }
	                    if(str=='Hosted PBX'&&(lstsectedHostedPBXdetail=='' || lstsectedHostedPBXdetail == null)) {
	                             toshowerrorMsg = true;
	                             errorMsgList.add('Please select &quot;Hosted PBX?&quot;');
	                    }
	                    if(str=='On-Premise PBX'&& (lstsectedOnPremisePBXdetail=='' || lstsectedOnPremisePBXdetail == NULL)) {
	                             toshowerrorMsg = true;
	                             errorMsgList.add('Please select &quot;On-Premise PBX?&quot;');
	                    }
	                    if(str == 'Other' && string.isBlank(opportunityObj.Specify_other__c)) {
	                        toshowerrorMsg = true;
	                        errorMsgList.add('Please provide value in Other.');
	                    }
	                    if((lstsectedOnPremisePBXdetail == 'Other (provide detailed reason)' ||  
	                    		lstsectedHostedPBXdetail == 'Other (provide detailed reason)')
	                        && String.isBlank(otherSubCompetitors)) {
			        		toshowerrorMsg = true;
				            errorMsgList.add('Please provide value in Other (provide detailed reason).');
	        			}
	                } 
	            }
            }
        	
        	if(toshowerrorMsg == false) {
               
                if(lstsectedCXDetaildetail != null) {
                     opportunityObj.What_will_cx_use_for_their_phone_system__c = getCXDetailPicListValue();
                }
                if((lstsectedHostedPBXdetail != '' && lstsectedHostedPBXdetail != null) && toshowHostedPBX == true) {
	                    opportunityObj.Hosted_PBX__c = getHostedPBXListValue();
	                    opportunityObj.Downgrade_Customer__c = opportunityObj.Hosted_PBX__c; 
                  if(opportunityObj.Hosted_PBX__c  == 'Prefers not to say') {
	                   	opportunityObj.Primary_Competitor__c = opportunityObj.Hosted_PBX__c +' - '+ opportunityObj.What_will_cx_use_for_their_phone_system__c; 
	                    opportunityObj.Downgrade_Customer__c= opportunityObj.Hosted_PBX__c +' - '+  opportunityObj.What_will_cx_use_for_their_phone_system__c;
                    } else if(opportunityObj.Hosted_PBX__c == 'Other (provide detailed reason)') {
	                     	opportunityObj.Primary_Competitor__c = 'Other' +' - '+ opportunityObj.What_will_cx_use_for_their_phone_system__c; 
	                     	opportunityObj.Downgrade_Customer__c= 'Other' +'-'+  opportunityObj.What_will_cx_use_for_their_phone_system__c;
                     	 } else {
                     	 	  opportunityObj.Primary_Competitor__c = opportunityObj.Hosted_PBX__c;
                       		  opportunityObj.Downgrade_Customer__c = opportunityObj.Hosted_PBX__c;
                     }
              }
                if(lstsectedOnPremisePBXdetail !='' && lstsectedOnPremisePBXdetail != null && toshowOnPremisePBX == true) {
	                    opportunityObj.On_Premise_PBX__c = getOnPremisePBXListValue();
	                    opportunityObj.Downgrade_Customer__c = opportunityObj.On_Premise_PBX__c;
                    if(opportunityObj.On_Premise_PBX__c   == 'Prefers not to say') {
	                   	opportunityObj.Primary_Competitor__c = opportunityObj.On_Premise_PBX__c  +' - '+ opportunityObj.What_will_cx_use_for_their_phone_system__c; 
	                    opportunityObj.Downgrade_Customer__c= opportunityObj.On_Premise_PBX__c  +' - '+  opportunityObj.What_will_cx_use_for_their_phone_system__c;
                    } else if(opportunityObj.On_Premise_PBX__c  == 'Other (provide detailed reason)') {
	                     	opportunityObj.Primary_Competitor__c = 'Other' +' - '+ opportunityObj.What_will_cx_use_for_their_phone_system__c; 
	                     	opportunityObj.Downgrade_Customer__c= 'Other' +' - '+  opportunityObj.What_will_cx_use_for_their_phone_system__c;
                     	 } else {
                     	 	  opportunityObj.Primary_Competitor__c = opportunityObj.On_Premise_PBX__c;
                       		  opportunityObj.Downgrade_Customer__c = opportunityObj.On_Premise_PBX__c ;
                     }
              }
                if(opportunityObj.What_will_cx_use_for_their_phone_system__c != 'On-Premise PBX' && 
                        opportunityObj.What_will_cx_use_for_their_phone_system__c != 'Hosted PBX') {
                        opportunityObj.Primary_Competitor__c = opportunityObj.What_will_cx_use_for_their_phone_system__c;
                        opportunityObj.Downgrade_Customer__c = opportunityObj.What_will_cx_use_for_their_phone_system__c;
                 }
                
                
                if(finalSelectedSubReason != 'Time frame greater than X months'){
                	opportunityObj.Timeframe_greater_than_X_months__c = '';	
                }
                if(finalSelectedReason != 'Other'){
                	opportunityObj.Downgrade_Reason_Other__c = '';	 
                } 
                //if(finalSelectedReason != null && finalSelectedReason != '') {
                	 opportunityObj.Downgrade_Reason_Opp__c =  finalSelectedReason;
                //}
               // if(finalSelectedSubReason != null && finalSelectedSubReason != '') {
                	 opportunityObj.Sub_Downgrade_Reason__c =  finalSelectedSubReason;
                //}
                opportunityObj.Other_SubCompetitors__c =  otherSubCompetitors;
                opportunityObj.StageName = '0. Downgraded';
                system.debug('$$$$$$$$$$$'+lstsectedCXDetaildetail);
                update opportunityObj;
                return new pagereference('/'+opportunityObj.id);
            }   
        } catch(Exception ex) {
        	toshowerrorMsg = true;
            errorMsgList.add(ex.getMessage());
        }
        
       
        return null;
     }*/
     
    
     
 	
     
     public PageReference back() { //** PREVIOUS PAGE
        toShowCustomerSection = false;
        errorMsgList.clear();
        toshowerrorMsg = false;
        /*finalSelectedReason = '';
        finalSelectedSubReason = '';
        opportunityObj.What_will_cx_use_for_their_phone_system__c = '';
		opportunityObj.Hosted_PBX__c = '';
		opportunityObj.Primary_Competitor__c = '';
		opportunityObj.Downgrade_Customer__c = '';
		opportunityObj.On_Premise_PBX__c = '';
		opportunityObj.Other_SubCompetitors__c = '';
		finalSelectedCXDetaildetail = '';
		lstsectedHostedPBXdetail = '';
		lstsectedOnPremisePBXdetail = '';
		lstsectedCXDetaildetail.clear();
		otherSubCompetitors = '';
		opportunityObj.Specify_other__c = '';*/
		showMissingCriticalOther = false;
        showTimeframeOther = false;
		showSubDowngradeReasonBandwidth = false; 
        showSubDowngradeReasonConcernsAbout = false;
        showSubDowngradeReasonMissingCriti = false;
        showSubDowngradeReasonPrice = false;
    	showSubDowngradeReasonReviews = false;
    	strSelectedIssueWithRC = '';
    	strSelectedSubIssueWithRC = '';
    	toShowIssueWithRCOther = false;
    	toShowSubIssueWithRCOther = false;
    	opportunityObj.Sub_Downgrade_Reason_Other__c = '';
        return null;
     }
     
     public string strSelectedIssueWithRC {get;set;}
     public string strSelectedSubIssueWithRC {get;set;}
     public string strSubIssueWithRCLbl {get;set;}
     public boolean toShowIssueWithRCOther {get;set;}
     public boolean toShowSubIssueWithRCOther {get;set;}
     public void onChangeIssueWithRC() {
 		showSubDowngradeReasonBandwidth = false; 
        showSubDowngradeReasonConcernsAbout = false;
        showSubDowngradeReasonMissingCriti = false;
        showSubDowngradeReasonPrice = false;
    	showSubDowngradeReasonReviews = false;
    	strSelectedSubIssueWithRC = '';
    	toShowIssueWithRCOther = false;
    	toShowSubIssueWithRCOther = false;
    	opportunityObj.Sub_Downgrade_Reason_Other__c = '';
     	if(strSelectedIssueWithRC == 'Bandwidth / Wiring'){
     		showSubDowngradeReasonBandwidth = true; 
     		strSubIssueWithRCLbl = 'Bandwidth / Wiring';
     	} else if(strSelectedIssueWithRC == 'Concerns about reliability / usability / support'){
     		showSubDowngradeReasonConcernsAbout = true; 
     		strSubIssueWithRCLbl = 'Concerns about reliability / usability / support';
     	} else if(strSelectedIssueWithRC == 'Missing critical features'){
     		strSubIssueWithRCLbl = 'Missing critical features';
     		showSubDowngradeReasonMissingCriti = true;
     	} else if(strSelectedIssueWithRC == 'Price'){
     		strSubIssueWithRCLbl = 'Price';
     		showSubDowngradeReasonPrice = true;  
     	} else if(strSelectedIssueWithRC == 'Reviews'){
     		strSubIssueWithRCLbl = 'Reviews';
     		showSubDowngradeReasonReviews = true;
     	} else if(strSelectedIssueWithRC == 'Other') {
     		toShowIssueWithRCOther = true;
     	}
     }
     
     public void onChangeSubIssueWithRC() {
     	toshowerrorMsg = false;
     	showMissingCriticalOther = false;
     	toShowSubIssueWithRCOther = false;
     	if(strSelectedSubIssueWithRC == 'Other (provide detailed reason)'){
     		toShowSubIssueWithRCOther = true;
     	} else if(strSelectedSubIssueWithRC == 'Call Center Functionality' || strSelectedSubIssueWithRC == 'CRM Integration' 
     			 || strSelectedSubIssueWithRC == 'Large Account Management / UI limitations' || strSelectedSubIssueWithRC == 'Mobile features'
     			 || strSelectedSubIssueWithRC == 'Voicemail Transcription (VM to Text)'){
     		showMissingCriticalOther = true;
     		system.debug('@@@@@@ showMissingCriticalOther '+ showMissingCriticalOther);
     	}
     }
     
     /*public void skip() {
        lstselectedChangingReasons = new List<string>();
        lstsectedDownsellReasons = new List<string>();
        lstselectedCouldnotworkingdetail = new List<string>();
        lstsectedmissingfeature = new List<string>(); 
        lstsectedQOsdetail = new List<string>();
        lstsectedFax = new List<string>();
        lstselectedcostDetail = new List<string>();
        opportunityObj.Other_details__c = '';
        opportunityObj.Outage_Date__c = null;
        opportunityObj.Specify_value__c = '';
        errorMsgList.clear();
        toshowerrorMsg = false;
        toShowCustomerSection = true;
        finalSelectedReason = strDownGradeRsn;
        finalSelectedSubReason = strSubDownGradeRsn;
 	}*/
      
    public void showdetailCall() {
        showCouldnotworkingdetailCall();
        showmissingfeatureCall();
        showQOsdetailCall();
        showFaxCall();
        showOtherdetailCall();
        showspecifyValue();
        showCostDetails();
        showOutage();
 	}
     
  	public void showcompanyCall() {
        toshowerrorMsg = false;
        errorMsgList.clear();
        lstsectedCXDetaildetail.clear();
        lstsectedCXDetaildetail.add(finalSelectedCXDetaildetail);
        lstselectedCellPhoneOnly='';
		lstsectedOnPremisePBXdetail='';
		lstsectedHostedPBXdetail='';
		lstSelectedLandLine='';
        unShowAll();
        showHostedPBX();
        showOnPremisePBX();
        showCellPhoneOnly();
        showLandline();
        showspecifyOthers();
        showNothing();
        showOtherProDetRes();       //Other(provide deatil Reaion)- RingCentral -Consolidating Account
        toShowOtherSubCompetitorBox = false;
  	}
  	
  	 public string createformatDate(Date dt) {
        string formatDate;
        try {
            formatDate = String.valueOf(dt.month()) + '/'+ String.valueOf(dt.day()) + '/' + String.valueOf(dt.year());
            return formatDate;
        } catch(Exception ex) {}
        return null;
     }
     
     public String getwhatsChangingPicListValue(){
        String strPram='';
        integer i=0;
          if(!lstselectedChangingReasons.isEmpty()){
          	for(String str:lstselectedChangingReasons){
            	if(i==0){
            		strPram = str;	
            	}else{
	            	strPram += ';'+str;
            	}
            	i++;
         	} 
          }
          
       return strPram;  
    }
     
 	public String createMultiSelectList(List<String> lstOptions){
     	String strPram='';
       	integer i=0;
       	if(!lstOptions.isEmpty()){
	      	for(String str:lstOptions){
	        	if(i==0){
	        		strPram = str;	
	        	}else{
	            	strPram += ';'+str;
	        	}
	        	i++;
	     	} 
        }
        return strPram;	
 	}
     
 	public String getCXDetailPicListValue(){
        return createMultiSelectList(lstsectedCXDetaildetail);
    }
 	
 	public String getHostedPBXListValue(){
        return lstsectedHostedPBXdetail;
    }
    public String getOnPremisePBXListValue(){
        return lstsectedOnPremisePBXdetail;
    }
 	
 	public String getCellPhoneOnlyListValue(){//CellPhoneOnly
        return lstselectedCellPhoneOnly;
    }
    public String getLandLineListValue(){//Land Line
        return lstSelectedLandLine;
    }
    public String getTraditionalListValue(){    //Traditional 
        return createMultiSelectList(lstSelectedTraditional);
    }
    public String getNothingListValue(){                                          //Traditional 
      	return createMultiSelectList(lstselectedNothing);
    }
    public String getConsolidatingAccount(){  //RingCentral – Consolidating Account
      	return createMultiSelectList(lstConsolidatingAccount);
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
     
     public void setIssueWithRingcentralValues() {
     	issueWithRingcentralSet.add('Bandwidth / Wiring');
     	issueWithRingcentralSet.add('Concerns about reliability / usability / support');
     	issueWithRingcentralSet.add('Missing critical features');
     	issueWithRingcentralSet.add('Price');
     	issueWithRingcentralSet.add('Reviews');
     	issueWithRingcentralSet.add('Other');
     }
     
     public boolean setIssueWithRingcentral() {
     	//System.debug('')
     	if(!String.isBlank(selectedDowngradeReasons) && issueWithRingcentralSet.contains(selectedDowngradeReasons)) {
     		return true;
     	}
     	return false;
     }
     
     public void showFaxCall() {
        toshowFax = false;
        for(string str : lstsectedDownsellReasons) {
            if(str == 'Qos Fax') {
                toshowFax = true;
                break;
            } else {
                toshowFax = false;
            }
        }
     }
     
    public boolean toshowcostdetail {get;set;}
    public void showCostDetails() {
        toshowcostdetail = false;
        for(string str : lstsectedDownsellReasons) {
            if(str == 'Cost') {
                toshowcostdetail = true;
                break;
            } else {
                toshowcostdetail = false;
            }
        }
     }
     
     public boolean toshowOutage {get;set;}
     public void showOutage() {
        toshowOutage = false;
        for(string str : lstsectedDownsellReasons) {
            if(str == 'Outages') {
                toshowOutage = true;
                break;
            } else {
                toshowOutage = false;
            }
        }
     }
     
     public void showCouldnotworkingdetailCall() {
        toshowCouldnotworkingdetail = false;
        for(string str : lstsectedDownsellReasons) {
            if(str == 'Couldn\'t get it working') {
                toshowCouldnotworkingdetail = true;
                break;
            } else {
                toshowCouldnotworkingdetail = false;
            }
        }
     }
     
     public void showmissingfeatureCall() {
        toshowmissingfeature = false;
        for(string str : lstsectedDownsellReasons) {
            if(str == 'Missing critical feature') {
                toshowmissingfeature = true;
                break;
            } else {
                toshowmissingfeature = false;
            }
        }
     }
     
     public void showQOsdetailCall() {
        toshowQOsdetail = false;
        for(string str : lstsectedDownsellReasons) {
            if(str == 'QoS Voice') {
                toshowQOsdetail = true;
                break;
            } else {
                toshowQOsdetail = false;
            }
        }
     }
     
     public void showOtherdetailCall() {
        toshowotherdetail = false;
        for(string str : lstsectedDownsellReasons) {
            if(str == 'Other (provide detailed reason)') {
                toshowotherdetail = true;
                break;
            } else {
                toshowotherdetail = false;
            }
        }
     }
     public void showspecifyOthers() {
        toshowSpecifyOthers = false;
        for(string str : lstsectedCXDetaildetail) {
            if(str == 'Other') {
                toshowSpecifyOthers = true;
                break;
            } else {
                toshowSpecifyOthers = false;
            }
        }
     }
      public boolean toshowSpecifyValue {get;set;}//other(please specify) 
     public void showspecifyValue() {
        toshowSpecifyValue = false;
        if(lstsectedmissingfeature.size()>0){           
            for(string str : lstsectedmissingfeature) {
                if(str == 'Other (Please Specify)') {
                    toshowSpecifyValue = true;
                    break;
                } else {
                    toshowSpecifyValue = false;
                }
            }
      }
     }
     
     public void showHostedPBX() {
        toshowHostedPBX = false;
        for(string str : lstsectedCXDetaildetail) {
            if(str == 'Hosted PBX') {
                toshowHostedPBX = true;
                break;
            } else {
                toshowHostedPBX = false;
            }
        }
     }
     
     public void showOnPremisePBX() {
        toshowOnPremisePBX = false;
        for(string str : lstsectedCXDetaildetail) {
            if(str == 'On-Premise PBX') {
                toshowOnPremisePBX = true;
                break;
            } else {
                toshowOnPremisePBX = false;
            }
        }
     }
    
     public void showCellPhoneOnly() {
        toshowCellPhoneOnly = false;
        for(string str : lstsectedCXDetaildetail) {
            if(str == 'Cell phone only') {
                toshowCellPhoneOnly = true;
                break;
            } else {
                toshowCellPhoneOnly = false;
            }
        }
     }
    
     public void showLandline() {
        toshowLandline = false;
        for(string str : lstsectedCXDetaildetail) {
            if(str == 'Land line') {
                toshowLandline = true;
                break;
            } else {
                toshowLandline = false;
            }
        }
     }
     public boolean toshowTraditional{get;set;}//Traditional
     public void showTraditional() {          //Traditional
         toshowTraditional = false;
        for(string str : lstsectedCXDetaildetail) {
            if(str == 'Traditional') {
                 toshowTraditional = true;
                break;
            } else {
                 toshowTraditional = false;
            }
        }
     }
     
                              
    public void showNothing() {          
        toshowNothing = false;
        for(string str : lstsectedCXDetaildetail) {
            if(str == 'Nothing') {
                 toshowNothing = true;
                break;
            } else {
                 toshowNothing = false;
            }
        }
    }
    
    public boolean toshowOtherCloudPBX{get;set;}                          
    public void showotherCloudPBX() {          
        toshowOtherCloudPBX = false;
        for(string str : lstsectedCXDetaildetail) {
            if(str == 'Other Cloud PBX') {
                 toshowOtherCloudPBX = true;
                break;
            } else {
                 toshowOtherCloudPBX = false;
            }
        }
    }
    public boolean toshowConsolidatingAccount{get;set;}   // RingCentral – Consolidating Account
    public void showConsolidatingAccount() {          
        toshowConsolidatingAccount = false;  
        for(string str : lstsectedCXDetaildetail) {
            if(str == 'RingCentral – Consolidating Account') {
                  toshowConsolidatingAccount = true;
                  break;
            } else {
                  toshowConsolidatingAccount = false;
            }
        }
    } 
    
    public void showOtherProDetRes() {
        toshowOther_PDR = false;
        if(lstConsolidatingAccount.size()>0){           
            for(string str : lstConsolidatingAccount) {
                if(str == 'Other (provide detailed reason)') {
                    toshowOther_PDR = true;
                    break;
                } else {
                    toshowOther_PDR = false;
                }
            }
        }
    }
    
    public void unShowAll(){
    	toshowHostedPBX = false;
		toshowOnPremisePBX = false;
		toshowCellPhoneOnly = false;
		toshowLandline = false;
		toshowSpecifyOthers = false;
		toshowNothing = false;
		toshowOther_PDR = false;
		toShowOtherSubCompetitorBox = false;
    }
    
    public boolean toShowOtherSubCompetitorBox {get;set;}
    public string otherSubCompetitors {get;set;}
	public void showOtherSubCompetitorBox() {
		toShowOtherSubCompetitorBox = false;
		opportunityObj.Other_SubCompetitors__c = '';
		otherSubCompetitors = '';
		if((lstsectedHostedPBXdetail == 'Other (provide detailed reason)') || lstsectedOnPremisePBXdetail == 'Other (provide detailed reason)') {
			toShowOtherSubCompetitorBox = true;
		}
	}  
     
    public List<SelectOption> getdowngradeReasonOptionLead() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('Not BANT qualified','Not BANT qualified'));
	    options.add(new SelectOption('Unable to contact','Unable to contact'));
	    options.add(new SelectOption('Not a new prospect','Not a new prospect'));
	    return options; 
    }
    
    public List<SelectOption> getdowngradeReasonOptionRingCentral() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('Bandwidth / Wiring','Bandwidth / Wiring'));
	    options.add(new SelectOption('Concerns about reliability / usability / support','Concerns about reliability / usability / support'));
	    options.add(new SelectOption('Missing critical features','Missing critical features'));
	    options.add(new SelectOption('Price','Price'));
	    options.add(new SelectOption('Reviews','Reviews'));
	    options.add(new SelectOption('Other','Other'));
	    return options; 
    }
    
    public List<SelectOption> getdowngradeReasonOptionRingATNT() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('AT&T Seller','AT&T Seller'));
	    options.add(new SelectOption('Purchase Blocker','Purchase Blocker'));
	    options.add(new SelectOption('Doesn’t have mobility number','Doesn’t have mobility number'));
	    return options;
    }
    
    public List<SelectOption> getdowngradeReasonOptionRetention() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('Retention Opp Closed','Retention Opp Closed'));
	    return options;
    }
    // Sub downgrade reasons
    public List<SelectOption> getSubDowngradeReasonNotBANT() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('No Authority','No Authority'));
	    options.add(new SelectOption('Time frame greater than X months','Time frame greater than X months'));
	    options.add(new SelectOption('No Budget','No Budget'));
	    options.add(new SelectOption('No Need','No Need'));
	    return options;
    }
    
    public List<SelectOption> getSubDowngradeReasonUnableContact() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('No response','No response'));
	    options.add(new SelectOption('Went dark','Went dark'));
	    options.add(new SelectOption('Invalid phone number','Invalid phone number'));
	    return options;
    }
    
    public List<SelectOption> getSubDowngradeReasonNotNew() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('Duplicate','Duplicate'));
	    options.add(new SelectOption('Customer','Customer'));
	    options.add(new SelectOption('Partner','Partner'));
	    options.add(new SelectOption('Competitors','Competitors'));
	    options.add(new SelectOption('Vendor','Vendor'));
	    options.add(new SelectOption('Trash (eg. Fake data, student)','Trash (eg. Fake data, student)'));
	    return options;
    }
    
    public List<SelectOption> getSubDowngradeReasonBandwidth() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('Location not wired for Ethernet','Location not wired for Ethernet'));
	    options.add(new SelectOption('Not enough bandwidth','Not enough bandwidth'));
	    options.add(new SelectOption('Poor QoS test','Poor QoS test'));
	    options.add(new SelectOption('Too expensive','Too expensive'));
	    //options.add(new SelectOption('Purchase Blocker','Purchase Blocker'));
	    //options.add(new SelectOption('Doesn’t have mobility number','Doesn’t have mobility number'));
	    options.add(new SelectOption('Other (provide detailed reason)','Other (provide detailed reason)'));
	    return options;
	}
	
    public List<SelectOption> getSubDowngradeReasonConcernsAbout() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('Concerns about call quality','Concerns about call quality'));
	    options.add(new SelectOption('Concerns about onboarding process','Concerns about onboarding process'));
	    options.add(new SelectOption('Concerns about support','Concerns about support'));
	    options.add(new SelectOption('Concerns about uptime','Concerns about uptime'));
	    options.add(new SelectOption('Not user friendly','Not user friendly'));
	    options.add(new SelectOption('Other (provide detailed reason)','Other (provide detailed reason)'));
	    return options;
    }
    
    public List<SelectOption> getSubDowngradeReasonMissingCriti() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('Advanced Reporting','Advanced Reporting'));
	    options.add(new SelectOption('Call Center Functionality','Call Center Functionality'));
	    options.add(new SelectOption('Cordless Phones','Cordless Phones'));
	    options.add(new SelectOption('CRM Integration','CRM Integration'));
	    options.add(new SelectOption('High Usage Plan (SIP Trunking)','High Usage Plan (SIP Trunking)'));
	    options.add(new SelectOption('Large Account Management / UI limitations','Large Account Management / UI limitations'));
	    options.add(new SelectOption('LDAP Integration / Global company directory','LDAP Integration / Global company directory'));
	    options.add(new SelectOption('Multi – level IVR','Multi – level IVR'));
	    options.add(new SelectOption('Mobile features','Mobile features'));
	   // options.add(new SelectOption('Paging','Paging'));
	    options.add(new SelectOption('Salesforce Mac Integration','Salesforce Mac Integration'));
	   // options.add(new SelectOption('Shared Lines','Shared Lines'));
	    options.add(new SelectOption('Softphone Mac Support','Softphone Mac Support'));
	    options.add(new SelectOption('User Permission limitation','User Permission limitation'));
	    options.add(new SelectOption('Voicemail Transcription (VM to Text)','Voicemail Transcription (VM to Text)'));
	    options.add(new SelectOption('Other (provide detailed reason)','Other (provide detailed reason)'));
	    return options;
    }
    
    public List<SelectOption> getSubDowngradeReasonPrice() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('Phones too expensive','Phones too expensive'));
	    options.add(new SelectOption('Service too expensive','Service too expensive'));
	    options.add(new SelectOption('Other (provide detailed reason)','Other (provide detailed reason)'));
	    return options;
    }
    
    public List<SelectOption> getSubDowngradeReasonReviews() {
        List<SelectOption> options = new List<SelectOption>();
	    options.add(new SelectOption('Facebook','Facebook'));
	    options.add(new SelectOption('Gartner','Gartner'));
	    options.add(new SelectOption('Glassdoor','Glassdoor'));
	    options.add(new SelectOption('Twitter','Twitter'));
	    options.add(new SelectOption('VoIP Review','VoIP Review'));
	    options.add(new SelectOption('Yelp','Yelp'));
	    options.add(new SelectOption('Other (provide detailed reason)','Other (provide detailed reason)'));
	    return options;
    }
     
    public List<SelectOption> getDownsellReasonOption(){
       List<SelectOption> options = getOptionList('Why_is_cx_downselling__c');
       return options; 
    }
    
    public List<SelectOption> getCouldnotworkingdetailOption() {
       List<SelectOption> options = getOptionList('Couldn_t_get_it_working_details__c');
       return options; 
    }
    
    public List<SelectOption> getmissingfeaturedetailOption() {
       List<SelectOption> options = getOptionList('Missing_feature_details__c'); 
       List<SelectOption> newOptions = new List<SelectOption>();
       for(SelectOption selectOption : options) {
       		if(selectOption.getLabel() != 'Robust Reporting' && selectOption.getLabel() != 'Multi-User Administration' 
       				&& selectOption.getLabel() != 'Mac Support' && selectOption.getLabel() != 'Intercom' && 
       				selectOption.getLabel() != 'Caller Id' && selectOption.getLabel() != 'Shared Lines' && selectOption.getLabel() != 'Paging') {
       			newOptions.add(new selectOption(selectOption.getvalue(), selectOption.getvalue()));
       		}	
       }
       return newOptions;  
    }
    
    public List<SelectOption> getQOsdetailOption(){
        List<SelectOption> options = getOptionList('QoS_details__c');  
        options.sort();
        return options; 
    }
    
    public List<SelectOption> getFaxOption(){//updated
       List<SelectOption> options = getOptionList('Fax__c');   
       options.sort(); 
       return options; 
    }
    
    public List<SelectOption> getWhichCXDetailOption(){
       List<SelectOption> options = getOptionList('What_will_cx_use_for_their_phone_system__c'); 
       List<SelectOption> optionsNew = new List<SelectOption>(); 
       for(SelectOption sOp : options){
        	if(sOp.getValue()=='Hosted PBX' || sOp.getValue()=='On-Premise PBX' 
        		|| sOp.getValue()=='Other' || sOp.getValue()=='Prefers not to say') {
        		optionsNew.add(new SelectOption(sOp.getValue(),sOp.getValue()));	
        	}
       }
       return optionsNew; 
    }
    
    public List<SelectOption> getHostedPBXOption(){
        List<SelectOption> options = new List<SelectOption>(); //getOptionList('Hosted_PBX__c');
        String OppId = ApexPages.currentPage().getParameters().get('Id');
        System.Debug('>>>OppId>>>>'+ OppId);
		opportunityObj = [select Brand_Name__c from Opportunity where id =:OppId];
    	getHostedPBXRCUK();
    	getHostedPBXRCandRCCanada();
    	for(SelectOption option:getOptionList('Hosted_PBX__c')){
    		if(opportunityObj.Brand_Name__c == 'RingCentral UK'){
				if(setHostedPBXRCUK.contains(String.valueOf(option.getValue()))){
					options.add(option);
				}
			} else {
				if(setHostedPBXRCandRCCanada.contains(String.valueOf(option.getValue()))){
					options.add(option);
				}
    		}
		}
       return options;  
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
		setHostedPBXRCUK.add('Vodafone - One Net');
		setHostedPBXRCUK.add('Other (provide detailed reason)');
	//return setHostedPBX;
	}
    
    public List<SelectOption> getOnPremisePBXOption(){
       List<SelectOption> options = getOptionList('On_Premise_PBX__c');
       List<SelectOption> optionsNew = new List<SelectOption>(); 
       for(SelectOption sOp : options){
        	if(sOp.getValue() != 'Barracuda' && sOp.getValue() != 'Prefers not to say') {
        		optionsNew.add(new SelectOption(sOp.getValue(),sOp.getValue()));	
        	}
       }
       return optionsNew; 
    }
    
    public List<SelectOption> getCellPhoneOnlyOption(){                             //cell Phone Only
        List<SelectOption> options = getOptionList('Cell_phone_only__c'); 
        options.sort();
        return options; 
    }
    public List<SelectOption> getLandLineOption(){                                  //Land Line 
        List<SelectOption> options = getOptionList('Land_line__c');  
        options.sort();
        return options; 
    }
    public List<SelectOption> getTraditionalOption(){                               //Tradtional
       List<SelectOption> options = getOptionList('Traditional__c'); 
       options.sort();
       return options; 
    }
    
    public List<SelectOption> getCostOption() {                         //Cost
       List<SelectOption> options = getOptionList('Cost__c');
       return options; 
    }
    
    public List<SelectOption> getNothingOption() {                          //Cost
       List<SelectOption> options = getOptionList('Nothing__c');
       return options; 
    }
    
    public List<SelectOption> getConsolidatingAccountOption() {                          //Cost
       List<SelectOption> options = getOptionList('RingCentral_Consolidating_Account__c');
       return options; 
    }
    
    public List<SelectOption> getDelayedReasonOption(){
   		List<SelectOption> options = getOptionList('Delayed_Reason__c');
    	List<SelectOption> optionsNew = new List<SelectOption>(); 
       	for(SelectOption sOp : options){
			optionsNew.add(new SelectOption(sOp.getValue(),sOp.getValue()));	
       	}
       return optionsNew; 
    }
    
    public List<SelectOption> getOptionList(string fieldApi) {                     
           List<SelectOption> options = new List<SelectOption>(); 
           try{
            Schema.sObjectType sobjectType = Opportunity.getSObjectType(); 
            Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe(); 
            Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap(); 
            List<Schema.PicklistEntry> pickListValues = fieldMap.get(fieldApi).getDescribe().getPickListValues(); 
            for (Schema.PicklistEntry picklstval : pickListValues) { 
                options.add(new selectOption(picklstval.getvalue(), picklstval.getvalue())); 
            }
        } catch(Exception ex) { }
       return options; 
    }
    
    public void checkIsRecordTypePermitted(string recordTypeID) {
     	try {
     		if(recordTypeID != null && recordTypeID != '') {
     			Schema.DescribeSObjectResult result = Opportunity.SObjectType.getDescribe(); 
     			Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
     			map<string,Lead_Opp_Downgrade_RT__c> csMap  = Lead_Opp_Downgrade_RT__c.getAll();
     			if(csMap != null && csMap.containsKey(rtMapByName.get(recordTypeID).getName())) {
     				toShowMainPanel = true;	
     			} else {
     				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Record Type.'));
     			}
     		} else {
     			toShowMainPanel = true;
     		}
     	} catch(Exception ex) {}	
     }
 }