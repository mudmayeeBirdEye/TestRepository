public with sharing class OpportunityDownsell {
    
    public List<string> lstselectedChangingReasons {get;set;}
     public List<string> lstsectedDownsellReasons {get;set;}
     public List<string> lstselectedCouldnotworkingdetail {get;set;}
     public List<string> lstsectedmissingfeature {get;set;}
     public List<string> lstsectedQOsdetail {get;set;}
     public List<string> lstsectedCXDetaildetail {get;set;}
     public List<string> lstsectedCompanyDetaildetail {get;set;}
     public List<string> lstsectedHostedPBXdetail {get;set;}
     public List<string> lstsectedOnPremisePBXdetail {get;set;}
     public List<string> lstselectedCellPhoneOnly{get;set;}//CellPhoneOnly
     public List<string> lstSelectedLandLine{get;set;}//Land Line
     public List<string> lstSelectedTraditional{get;set;}//Tradtional
     public List<string> lstsectedFax {get;set;}//Fax
     public List<String> lstselectedcostDetail {get;set;} 
  	 public List<string> lstselectedNothing {get;set;}  
  	 public List<string> lstConsolidatingAccount{get;set;}    //RingCentral – Consolidating Account
     public boolean toshowmissingfeature {get;set;}
     public boolean toshowCouldnotworkingdetail {get;set;}
     public boolean toshowQOsdetail {get;set;}
     public boolean toshowPricedetail {get;set;}
     public boolean toshowotherdetail {get;set;}
     public boolean toshowFax{get;set;}
     public boolean toshowSalesExpectation{get;set;}
     public boolean toshowSuppCustomerCare{get;set;}
     public boolean toshowerrorMsg {get;set;}
     public List<string> errorMsgList {get;set;} 
     public Opportunity oppObj {get;set;}
     public List<string> tempList {get;set;}
     public string selectedDowngradeRsn {get;set;}
     public boolean toShowAccountUId {get;set;}
     public boolean toShowBusinessMortality {get;set;}
     public boolean toShowOtherSubDownGrade {get;set;}
     public string selectedBusinessMortality {get;set;}
     public string selectedSubDownGradeReason {get;set;}
     public string selectedCXDetail {get;set;}
     public string selectedSubCXDetail {get;set;}
     
     public OpportunityDownsell(ApexPages.StandardController controller) {
        lstselectedChangingReasons = new List<string>();
        lstsectedDownsellReasons = new List<string>();
        lstselectedCouldnotworkingdetail = new List<string>();
        lstsectedmissingfeature = new List<string>(); 
        lstsectedQOsdetail = new List<string>();
        lstsectedCXDetaildetail = new List<string>();
        lstsectedCompanyDetaildetail = new List<string>();
        errorMsgList = new List<string>();
        lstsectedOnPremisePBXdetail = new List<string>();//
        lstselectedCellPhoneOnly = new List<string>();//CellPhoneOnly
        lstSelectedLandLine = new List<string>();//Land Line
        lstSelectedTraditional = new List<string>();//Tradtional
        lstsectedFax = new List<string>();//Fax
        lstsectedHostedPBXdetail = new List<string>();
        lstselectedcostDetail = new List<string>();
        lstselectedNothing = new List<string>(); 
        lstConsolidatingAccount = new List<string>(); //RingCentral – Consolidating Account
        toshowCouldnotworkingdetail = false;
        //toshowSpecifyValue = false;
        toshowmissingfeature = false;
        toshowQOsdetail = false;
        toshowotherdetail = false;
        toShowCustomerSection = false;
        toshowerrorMsg = false;
        toshowFax = false;
        toShowAccountUId = false;
        toShowBusinessMortality = false;
        toShowOtherSubDownGrade = false;
        toshowPricedetail = false;
        toshowSalesExpectation = false;
        toshowSuppCustomerCare = false;
        oppObj = new Opportunity();
        tempList = new List<string>();
        tempList.add('test');
     }
     
     public boolean toShowCustomerSection {get;set;}
     public PageReference create() {
     	try {
 		 	toshowerrorMsg = false;
	        errorMsgList = new List<string>();
	        if(selectedCXDetail != 'Prefers not to say' && (selectedCXDetail == null || selectedCXDetail == '')) {
	            toshowerrorMsg = true;
	            errorMsgList.add('Please select &quot;What will cx use instead?&quot;');
	        } 
	        else {
	        	if(selectedCXDetail == 'Prefers not to say') {
	        		oppObj.Specify_other__c = '';
	        	}
    			if(selectedCXDetail =='Hosted PBX' && (selectedSubCXDetail == null || selectedSubCXDetail == '')) {
                     toshowerrorMsg = true;
                     errorMsgList.add('Please select &quot;Hosted PBX?&quot;');
                }
               /* if(selectedCXDetail == 'Cell phone only' && (selectedSubCXDetail == null || selectedSubCXDetail == '')) {
                         toshowerrorMsg = true;
                         errorMsgList.add('Please select &quot;Cell phone only?&quot;');
                }
                if(selectedCXDetail =='Land line' && (selectedSubCXDetail == null || selectedSubCXDetail == '')) {
                         toshowerrorMsg = true;
                         errorMsgList.add('Please select &quot;Land line?&quot;');
                }*/
                if(selectedCXDetail =='On-Premise PBX' && (selectedSubCXDetail == null || selectedSubCXDetail == '')) {
                         toshowerrorMsg = true;
                         errorMsgList.add('Please select &quot;On-Premise PBX?&quot;');
                }
                /*if(str=='Traditional'&&lstSelectedTraditional.size() == 0) {
                         toshowerrorMsg = true;
                         errorMsgList.add('Please select atleast one value in &quot;Traditional?&quot;');
                }*/
                if(selectedCXDetail == 'Other' && string.isBlank(oppObj.Specify_other__c)) {
                    toshowerrorMsg = true;
                    errorMsgList.add('Please provide value in Other.');
                }
                if(selectedSubCXDetail == 'Other (provide detailed reason)' && string.isBlank(oppObj.Other_SubCompetitors__c)) {
                    toshowerrorMsg = true;
                    errorMsgList.add('Please provide value in Other (provide detailed reason).');
                }
                /*if(str == 'Nothing' && lstselectedNothing.size() == 0) {                               
                         toshowerrorMsg = true;
                         errorMsgList.add('Please select atleast one value in &quot;Nothing&quot;');
                }
				if(str == 'RingCentral – Consolidating Account' && lstConsolidatingAccount.size() == 0) {
						toshowerrorMsg = true;
						errorMsgList.add('Please select atleast one value in &quot;RingCentral – Consolidating Account&quot;');
				}*/
	            /*for(string str : lstsectedCXDetaildetail) {
	                if(str == 'Prefers not to say') {
	                    toshowerrorMsg = false;
	                    oppObj.Specify_other__c = '';
	                    lstsectedCompanyDetaildetail = new List<string>();
	                    break;  
	                }
	                if(str=='Hosted PBX'&&lstsectedHostedPBXdetail.size() == 0) {
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Hosted PBX?&quot;');
	                    }
	                if(str=='Cell phone only'&&lstselectedCellPhoneOnly.size() == 0) {
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Cell phone only?&quot;');
	                    }
	                if(str=='Land line'&&lstSelectedLandLine.size() == 0) {
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Land line?&quot;');
	                    }
	                if(str=='On-Premise PBX'&&lstsectedOnPremisePBXdetail.size() == 0) {
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;On-Premise PBX?&quot;');
	                    }
	                if(str=='Traditional'&&lstSelectedTraditional.size() == 0) {
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Traditional?&quot;');
	                    }
	                if(str == 'Other' && string.isBlank(oppObj.Specify_other__c)) {
	                    toshowerrorMsg = true;
	                    errorMsgList.add('Please provide value in Other.');
	                }
	                if(str == 'Nothing' && lstselectedNothing.size() == 0) {                               
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Nothing&quot;');
	                }
					if(str == 'RingCentral – Consolidating Account' && lstConsolidatingAccount.size() == 0) {
							toshowerrorMsg = true;
							errorMsgList.add('Please select atleast one value in &quot;RingCentral – Consolidating Account&quot;');
					}
	            }*/ 
	        }
	        
	        if(toshowerrorMsg == false) {
	            PageReference rtrnPage;
	            string keyPrefix = '/' + Schema.getGlobalDescribe().get('Opportunity').getDescribe().getKeyPrefix() + '/e';
	            PageReference rtrnTempPage = null;
	            /*if(lstsectedCompanyDetaildetail.size()>0 || lstsectedCXDetaildetail.size()>0 || lstsectedDownsellReasons.size()>0 
	                || lstselectedCouldnotworkingdetail.size()>0 || lstsectedmissingfeature.size()>0 || lstsectedQOsdetail.size()>0
	                || lstselectedChangingReasons.size()>0) {
	                keyPrefix = '/apex/redirectOppPage';
	            }*/
	            if(lstselectedChangingReasons.size()>0 || selectedDowngradeRsn != null || selectedSubDownGradeReason != null ||
	            	selectedCXDetail != null || selectedSubCXDetail != null) {
	            	keyPrefix = '/apex/redirectOppPage';
	            }
	            rtrnTempPage = new PageReference(keyPrefix);
	            rtrnTempPage.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType'));
	            rtrnTempPage.getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
	            rtrnTempPage.getParameters().put('opp4',ApexPages.currentPage().getParameters().get('opp4'));
	            rtrnTempPage.getParameters().put('opp4_lkid',ApexPages.currentPage().getParameters().get('opp4_lkid'));
	            rtrnTempPage.getParameters().put('CF00N80000004jUBx',ApexPages.currentPage().getParameters().get('CF00N80000004jUBx'));
	            rtrnTempPage.getParameters().put('CF00N80000004jUBx_lkid',ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid'));
	            rtrnTempPage.getParameters().put('opp17',ApexPages.currentPage().getParameters().get('opp17'));
	            rtrnTempPage.getParameters().put('opp17_lkid',ApexPages.currentPage().getParameters().get('opp17_lkid'));
	            rtrnTempPage.getParameters().put('nooverride','1');
	            if(lstselectedChangingReasons.size()>0) {
	                rtrnTempPage.getParameters().put('00N80000005Hc4B',getwhatsChangingPicListValue());
	            }
	            if(selectedDowngradeRsn != null && selectedDowngradeRsn != '') {
	                 rtrnTempPage.getParameters().put('00N80000005Hc4V',selectedDowngradeRsn);
	            }
	            if(selectedDowngradeRsn == 'Business Mortality' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00Nn0000000FteQ',selectedSubDownGradeReason);
	            }
	            if(selectedDowngradeRsn == 'Consolidating into other RC account' && oppObj.New_Account_UID__c != null) {
	                 rtrnTempPage.getParameters().put('00Nn0000000FteL',oppObj.New_Account_UID__c);
	            }
	            if(selectedDowngradeRsn == 'Couldn\'t get it working' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3I',selectedSubDownGradeReason);
	            }
	            if(selectedDowngradeRsn == 'Missing critical feature' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3d',selectedSubDownGradeReason);
	            }
	            if(selectedDowngradeRsn == 'Price' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00Nn0000000Ftgg',selectedSubDownGradeReason);
	            }
	            if(selectedDowngradeRsn == 'QoS Voice' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3m',selectedSubDownGradeReason);
	            } 
	            if(selectedDowngradeRsn == 'Qos Fax' && selectedSubDownGradeReason != '') {
	                rtrnTempPage.getParameters().put('00N80000005Hc3N',selectedSubDownGradeReason);
	            }
	            if(selectedDowngradeRsn == 'Sales Expectations' && selectedSubDownGradeReason != '') {
	                rtrnTempPage.getParameters().put('00Nn0000000Ftgv',selectedSubDownGradeReason);
	            }
	            if(selectedDowngradeRsn == 'Support/Customer Care' && selectedSubDownGradeReason != '') {
	                rtrnTempPage.getParameters().put('00Nn0000000Fth0',selectedSubDownGradeReason);
	            }
	             if(selectedSubDownGradeReason == 'Other (provide detailed reason)') {
	                rtrnTempPage.getParameters().put('00N80000005I1We',oppObj.Other_SubDowngrade_Reason__c);
	            }
	            if(!string.isBlank(oppObj.Other_details__c)) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3i',oppObj.Other_details__c);
	            }
	            if(oppObj.Outage_Date__c != null) {
	            	 String formatedDate = createformatDate(oppObj.Outage_Date__c);
	                 rtrnTempPage.getParameters().put('00N80000005HdaX', formatedDate);						// other(please specify) 
	            }
	            if(!string.isBlank(oppObj.Specify_value__c)) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3w',oppObj.Specify_value__c);	// other(please specify) 
	            }
	            if(!string.isBlank(oppObj.Sub_Downgrade_Reason_Other__c)) {
	                 rtrnTempPage.getParameters().put('00N80000005I1Wj',oppObj.Sub_Downgrade_Reason_Other__c);	// other(please specify) 
	            }
	            
	            /*if(lstsectedDownsellReasons.size()>0) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc4V',getDownsellPicListValue());
	            }
	            if(lstselectedCouldnotworkingdetail.size()>0) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3I',getColuldNotPicListValue());
	            }
	            if(lstsectedmissingfeature.size()>0) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3d',getMissingPicListValue());
	            }
	            if(lstsectedQOsdetail.size()>0) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3m',getQOsListValue());
	            } 
	            if(lstsectedFax.size()>0)	//Fax
	            {
	                rtrnTempPage.getParameters().put('00N80000005Hc3N',getFaxListValue());
	            }
	            if(!string.isBlank(oppObj.Other_details__c)) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3i',oppObj.Other_details__c);
	            }
	            if(lstselectedcostDetail.size()>0) {
	        		rtrnTempPage.getParameters().put('00N80000005HdaD',getCostPicListValue());
	            }
	            if(oppObj.Outage_Date__c != null) {
	            	 String formatedDate = createformatDate(oppObj.Outage_Date__c);
	                 rtrnTempPage.getParameters().put('00N80000005HdaX', formatedDate);						// other(please specify) 
	            }
	            if(!string.isBlank(oppObj.Specify_value__c)) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3w',oppObj.Specify_value__c);	// other(please specify) 
	            }*/
	            
	            /********************************************* Customer List *************************************************/
	            
	           
	            if(selectedCXDetail != null && selectedCXDetail != '') {
	                 rtrnTempPage.getParameters().put('00N80000005Hc4G',selectedCXDetail);
	            }
	            if(selectedCXDetail == 'Hosted PBX' && !String.isBlank(selectedSubCXDetail) && toshowHostedPBX == true) {
	                rtrnTempPage.getParameters().put('00N80000005Hc3X',selectedSubCXDetail);
	            }
	            if(selectedCXDetail == 'On-Premise PBX' && !String.isBlank(selectedSubCXDetail) && toshowOnPremisePBX == true) {
	                rtrnTempPage.getParameters().put('00N80000005Hc3h',selectedSubCXDetail);
	            }
	            if(selectedCXDetail == 'Cell phone only' && !String.isBlank(selectedSubCXDetail) && toshowCellPhoneOnly == true) { //CellPhoneOnly
	                 rtrnTempPage.getParameters().put('00N80000005Hc38',selectedSubCXDetail); //CellPhone
	            }
	            if(selectedCXDetail == 'Land line' && !String.isBlank(selectedSubCXDetail) && toshowLandline == true) { //Land Line
	                 rtrnTempPage.getParameters().put('00N80000005Hc3c',selectedSubCXDetail); //Land Line
	            }
	            if(!string.isBlank(oppObj.Specify_other__c) && toshowSpecifyOthers == true) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3r',oppObj.Specify_other__c);
	            }
	            if(!string.isBlank(oppObj.Other_Cloud_PBX__c) && toshowOtherCloudPBX == true) {
	                 rtrnTempPage.getParameters().put('00N80000005HdaS',oppObj.Other_Cloud_PBX__c);	
	            }
	            if(oppObj.OtherCloudPBX_Prefers_not_to_say__c == true && toshowOtherCloudPBX == true) {
        			rtrnTempPage.getParameters().put('00N80000005HevC','1');
   				}
   				if(oppObj.Other_SubCompetitors__c != null && oppObj.Other_SubCompetitors__c != '') {
        			rtrnTempPage.getParameters().put('00N80000005I1WZ', oppObj.Other_SubCompetitors__c);
   				}
	         	
	            /*if(lstSelectedTraditional.size()>0 && toshowTraditional == true) {//Traditional
	                 rtrnTempPage.getParameters().put('00N80000005Hc41',selectedSubCXDetail());//Traditional
	            }
	            if(lstselectedNothing.size()>0 && toshowNothing == true) { 
	            	rtrnTempPage.getParameters().put('00N80000005HdaI',selectedSubCXDetail());
	            }*/
				/*if(lstConsolidatingAccount.size()>0 && toshowConsolidatingAccount == true) { //RingCentral – Consolidating Account        
					rtrnTempPage.getParameters().put('00N80000004OBFW',getConsolidatingAccount());
				}
				if(!string.isBlank(oppObj.Consolidating_Account__c)) {
					rtrnTempPage.getParameters().put('00N80000004OBFb',oppObj.Consolidating_Account__c); //RingCentral – Consolidating Account -other
				}*/
	            rtrnPage = rtrnTempPage;
	            rtrnPage.setRedirect(true);
	            return rtrnPage;
	        }	
     	} catch(Exception ex) {
     		toshowerrorMsg = true;
            errorMsgList.add(ex.getMessage());
     	}
        return null;
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
          for(String str:lstselectedChangingReasons){
            if(strPram== '') {
                    strPram=str;
                } else {
                    strPram=strPram+'&00N80000005Hc4B='+str;
                }
                  
         } 
       return strPram;  
    }
     
     public String getDownsellPicListValue(){
          String strPram = '';
           strPram= strPram +'&00N80000005Hc4V='+selectedDowngradeRsn;
          /*for(String str : lstsectedDownsellReasons){
            if(strPram== '') {
                    strPram = str;
                } else {
                    strPram=strPram+'&00N80000005Hc4V='+str;
                }
          }*/ 
         return strPram;  
    }
    
    public String getCostPicListValue(){
    	String strPram='';
    	strPram=strPram + '&00N80000005HdaD='+selectedSubDownGradeReason;
      	/*for(String str: lstselectedcostDetail) {
      		if(strPram == '') {
                    strPram = str;
                } else {
                	strPram=strPram + '&00N80000005HdaD='+str;
        	}
    	}*/ 
      return strPram;  
    }
    
    
    public String getColuldNotPicListValue(){
        String strPram='';
        strPram=strPram+'&00N80000005Hc3I='+selectedSubDownGradeReason;
          /*for(String str:lstselectedCouldnotworkingdetail){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00N80000005Hc3I='+str;
                    }
            } */ 
    	return strPram;
    }
    
    public String getMissingPicListValue(){
            String strPram='';
            //strPram=strPram+'&00N80000005Hc3d='+str;
              /*for(String str:lstsectedmissingfeature){
                  if(strPram==''){
                            strPram=str;
                        }else{
                            strPram=strPram+'&00N80000005Hc3d='+str;
                        }
                      
                    }*/ 
          return strPram; 
    }
    
    public String getQOsListValue(){
        String strPram='';
          for(String str:lstsectedQOsdetail){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00N80000005Hc3m='+str;
                    }
            }  
            return strPram;
    }
     public String getFaxListValue(){//Fax
        String strPram='';
          for(String str:lstsectedFax){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00N80000005Hc3N='+str;
                    }
            }  
            return strPram;
    }
     
     public String getCXDetailPicListValue(){
            String strPram='';
              for(String str:lstsectedCXDetaildetail){
                  if(strPram==''){
                            strPram=str;
                        }else{
                            strPram=strPram+'&00N80000005Hc4G='+str;
                        }
                      
                    } 
          return strPram; 
    }
     public String getHostedPBXListValue(){
        String strPram='';
          for(String str:lstsectedHostedPBXdetail){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00N80000005Hc3X='+str;
                    }
            }  
            return strPram;
    }
    public String getOnPremisePBXListValue(){
        String strPram='';
          for(String str:lstsectedOnPremisePBXdetail){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00N80000005Hc3h='+str;
                    }
            }  
            return strPram;
    }
     public String getCellPhoneOnlyListValue(){//CellPhoneOnly
        String strPram='';
          for(String str:lstselectedCellPhoneOnly){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00N80000005Hc38='+str;
                    }
            }  
            return strPram;
    }
    public String getLandLineListValue(){//Land Line
        String strPram='';
          for(String str:lstSelectedLandLine){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00N80000005Hc3c='+str;
                    }
            }  
            return strPram;
    }
    public String getTraditionalListValue(){    //Traditional 
        String strPram='';
          for(String str:lstSelectedTraditional){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00N80000005Hc41='+str;
                    }
            }  
            return strPram;
    }
    
    public String getNothingListValue(){                                          //Traditional 
      String strPram='';
      for(String str : lstselectedNothing) {
      	if(strPram=='') {
           strPram=str;
        } else {
           strPram=strPram+'&00N80000005HdaI='+str;
        }
      }  
      return strPram;
    }
	public String getConsolidatingAccount(){  //RingCentral – Consolidating Account
	  String strPram='';
      for(String str : lstConsolidatingAccount) {
        if(strPram=='') {
           strPram=str;
         } else {
            strPram=strPram+'&00N80000004OBFW='+str;
        }
	}
	return strPram;
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
     
 	public PageReference next() {
        toShowCustomerSection = true;
        toshowerrorMsg = false;
        errorMsgList = new List<string>();
        if((lstselectedChangingReasons == null) || (lstselectedChangingReasons != null && lstselectedChangingReasons.size() == 0)) {
            toshowerrorMsg = true;
            toShowCustomerSection = false;
            errorMsgList.add('Please select atleast one value in &quot;What\'s Changing?&quot;');
        }
        if(selectedDowngradeRsn == null) {
    	 	toshowerrorMsg = true;
            toShowCustomerSection = false;
            errorMsgList.add('Please select &quot; Why is cx downselling?&quot');
        } else {
        	if(selectedDowngradeRsn == 'Business Mortality' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
	    		toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;Business Mortality&quot;');
        	}
        	if(selectedDowngradeRsn == 'Consolidating into other RC account' && (oppObj.New_Account_UID__c == null || oppObj.New_Account_UID__c == '')) {
	    		toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please provide  &quot;New Account UID&quot;');
        	}
            if(selectedDowngradeRsn == 'Couldn\'t get it working' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select Couldn’t get it working.');
            }
            if(selectedDowngradeRsn == 'Missing critical feature' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
		        toshowerrorMsg = true;
		        toShowCustomerSection = false;
		        errorMsgList.add('Please select Missing critical feature.');
            } 
            if(selectedDowngradeRsn == 'Price' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
		        toshowerrorMsg = true;
		        toShowCustomerSection = false;
		        errorMsgList.add('Please select Price.');
            } 
         	if(selectedDowngradeRsn == 'QoS Voice' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;QoS Voice &quot;'); 
            }
        	if(selectedDowngradeRsn == 'Qos Fax' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {//updated
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;QoS Fax&quot;');
        	}
        	if(selectedDowngradeRsn == 'Sales Expectations' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {//updated
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;Sales Expectations&quot;');
        	}
        	if(selectedDowngradeRsn == 'Support/Customer Care' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {//updated

	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;Support/Customer Care&quot;');
        	}
        	if(selectedDowngradeRsn == 'Other (provide detailed reason)' && string.isBlank(oppObj.Other_details__c)) {
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please provide value in Other (provide detailed reason).');
        	}
        	if(finalsubDownGradeReason != null && finalsubDownGradeReason == 'Other (provide detailed reason)' && 
        			String.isBlank(oppObj.Other_SubDowngrade_Reason__c)) {
        		toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please provide value in Other (provide detailed reason).');
        	}
        } 
        /*if((lstsectedDownsellReasons == null) || (lstsectedDownsellReasons != null && lstsectedDownsellReasons.size() == 0)) {
            toshowerrorMsg = true;
            toShowCustomerSection = false;
            errorMsgList.add('Please select atleast one value in &quot; Why is cx downselling?&quot');
        } else if(lstsectedDownsellReasons != null && lstsectedDownsellReasons.size()>0) {
            for(string str : lstsectedDownsellReasons) {
            	if(str == 'Cost' && lstselectedcostDetail != null && lstselectedcostDetail.size() == 0) {
            		toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in &quot;Cost&quot;');
            	}
                if(str == 'Couldn\'t get it working' && lstselectedCouldnotworkingdetail != null && lstselectedCouldnotworkingdetail.size() == 0) {
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in Couldn’t get it working.');
                }
                if(str == 'Missing critical feature' && lstsectedmissingfeature != null && lstsectedmissingfeature.size() == 0) {
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in Missing critical feature.');
                } 
                 if(str == 'QoS Voice' && lstsectedQOsdetail != null && lstsectedQOsdetail.size() == 0) {
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in &quot;QoS Voice &quot;'); 
                }
                if(str == 'Qos Fax' && lstsectedFax != null && lstsectedFax.size() == 0) {//updated
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in &quot;QoS Fax&quot;');
                }
                if(str == 'Other (provide detailed reason)' && string.isBlank(oppObj.Other_details__c)) {
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please provide value in Other (provide detailed reason).');
                }
            } 
            if(lstsectedmissingfeature!=null&&lstsectedmissingfeature.size()>0)	{ //other(please specify) 
                for(string str1:lstsectedmissingfeature){
                    if(str1 == 'Other (Please Specify)'&& string.isBlank(oppObj.Specify_value__c)) {
                        toshowerrorMsg = true;
                        toShowCustomerSection = false;
                        errorMsgList.add('Please provide value in &quot;Other (Please Specify)&quot;');
                    }
                }
            }
            if(toshowotherdetail == false) {
            	oppObj.Other_details__c = '';
            }
            if(toshowCouldnotworkingdetail == false) {
            	lstselectedCouldnotworkingdetail.clear();
            }
            if(toshowcostdetail == false) {
            	lstselectedcostDetail.clear();
            }
            if(toshowmissingfeature == false) {
            	lstsectedmissingfeature.clear();
            }
            if(toshowQOsdetail == false) {
            	lstsectedQOsdetail.clear();
            }
            if(toshowFax == false) {
            	lstsectedFax.clear();
            }
            if(toshowOutage == false) {
            	oppObj.Outage_Date__c = null;
            }
        }*/ 
        return null;
     }
   	
   	public PageReference back() { //** PREVIOUS PAGE
        toShowCustomerSection = false;
        errorMsgList.clear();
        toshowerrorMsg = false;
     	return null;
 	}
     
 	public void skip() {
        lstselectedChangingReasons = new List<string>();
        oppObj.Other_details__c = '';
        oppObj.Outage_Date__c = null;
        oppObj.Specify_value__c = '';
        errorMsgList.clear();   
        toshowerrorMsg = false;
        toShowCustomerSection = true;
        toShowOtherSubDownGrade = false;
    	finalsubDownGradeReason = '';
    	selectedSubDownGradeReason = '';
    	toshowOutage = false;
    	toshowPricedetail = false;
      	selectedDowngradeRsn = '';
      	oppObj.Other_SubDowngrade_Reason__c = '';
      	toShowSubDownGradeOtherMissing = false;
      	oppObj.Sub_Downgrade_Reason_Other__c = '';
 	}
      
    public void showdetailCall() {
    	oppObj.Other_SubDowngrade_Reason__c = '';
    	toShowOtherSubDownGrade = false;
    	finalsubDownGradeReason = '';
    	selectedSubDownGradeReason = '';
        showCouldnotworkingdetailCall();
        showmissingfeatureCall();
        showQOsdetailCall();
        showFaxCall();
        showSalesExpectation();
        showSuppCustomerCare();
        showOtherdetailCall();
        showCostDetails();
        showOutage();
        showAccountUID();
        showBusinessMortality();
        showPriceDetail();
 	}
    
    public string finalsubDownGradeReason; 
    public boolean toShowSubDownGradeOtherMissing {get;set;}
	public void changeSubDownGrade() {
		toShowOtherSubDownGrade = false;
		toShowSubDownGradeOtherMissing = false;
		oppObj.Sub_Downgrade_Reason_Other__c = '';
		oppObj.Other_SubDowngrade_Reason__c = '';
		finalsubDownGradeReason = selectedSubDownGradeReason;
		if(finalsubDownGradeReason == 'Other (provide detailed reason)') {
			toShowOtherSubDownGrade = true;
		}
		if(finalsubDownGradeReason == 'Call Center Functionality' || finalsubDownGradeReason == 'CRM Integration' ||
			finalsubDownGradeReason == 'Large Account MGMT / UI limitations' || finalsubDownGradeReason == 'Mobile features') {
			toShowSubDownGradeOtherMissing = true;
		}
	} 
     
     public void showBusinessMortality() {
     	toShowBusinessMortality = false;
     	if(selectedDowngradeRsn == 'Business Mortality') {
     		toShowBusinessMortality = true;
     	}
     }
     
     public void showAccountUID() {
     	toShowAccountUId = false;
     	if(selectedDowngradeRsn == 'Consolidating into other RC account') {
     		toShowAccountUId = true;
     	}
     }
     
     public void showFaxCall() {
        toshowFax = false;
        if(selectedDowngradeRsn == 'Qos Fax') {
        	toshowFax = true;
        }
     }
     
 	public boolean toshowcostdetail {get;set;}
    public void showCostDetails() {
        toshowcostdetail = false;
        if(selectedDowngradeRsn == 'Cost') {
        	toshowcostdetail = true;
        }
     }
     
     public boolean toshowOutage {get;set;}
     public void showOutage() {
     	toshowOutage = false;
     	if(selectedDowngradeRsn == 'Outages') {
        	toshowOutage = true;
        }
     }
     
     public void showCouldnotworkingdetailCall() {
        toshowCouldnotworkingdetail = false;
        if(selectedDowngradeRsn == 'Couldn\'t get it working') {
        	toshowCouldnotworkingdetail = true;
        }
     }
     
     public void showmissingfeatureCall() {
        toshowmissingfeature = false;
        if(selectedDowngradeRsn == 'Missing critical feature') {
            toshowmissingfeature = true;
        } 
     }
     
     public void showQOsdetailCall() {
        toshowQOsdetail = false;
        if(selectedDowngradeRsn == 'QoS Voice') {
            toshowQOsdetail = true;
        }
     }
     
     public void showPriceDetail() {
        toshowPricedetail = false;
        if(selectedDowngradeRsn == 'Price') {
            toshowPricedetail = true;
        }
     }
     
     public void showSalesExpectation() {
        toshowSalesExpectation = false;
        if(selectedDowngradeRsn == 'Sales Expectations') {
            toshowSalesExpectation = true;
        }
     }
     
     public void showSuppCustomerCare() {
        toshowSuppCustomerCare = false;
        if(selectedDowngradeRsn == 'Support/Customer Care') {
            toshowSuppCustomerCare = true;
        }
     }
     
     public void showOtherdetailCall() {
        toshowotherdetail = false;
        if(selectedDowngradeRsn == 'Other (provide detailed reason)') { 
            toshowotherdetail = true;
        }
     }
     
     
     
     
 	/*public boolean toshowSpecifyValue {get;set;}	//other(please specify) 
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
 	}*/
    
    
    
    /********************************************************************************************************/
 	 
     public void showcompanyCall() { //new update
        showHostedPBX();
        showOnPremisePBX();
        showCellPhoneOnly();
        showLandline();
        showTraditional();
        showspecifyOthers();
        showNothing();
        showotherCloudPBX();
        selectedSubCXDetail = '';
        toShowOtherSubCompetitorBox = false;
        oppObj.Other_SubCompetitors__c = '';
        //showConsolidatingAccount(); //RingCentral -Consolidating Account
        //showOtherProDetRes();       //Other(provide deatil Reaion)- RingCentral -Consolidating Account
        
     }
     
 	public boolean toshowSpecifyOthers {get;set;}//other
 	public void showspecifyOthers() {
		toshowSpecifyOthers = false;
		if(selectedCXDetail == 'Other') {
            toshowSpecifyOthers = true;
        }
 	}
     
     public boolean toshowHostedPBX{get;set;}//updated
     public void showHostedPBX() {
        toshowHostedPBX = false;
        if(selectedCXDetail == 'Hosted PBX') {
            toshowHostedPBX = true;
        } 
     }
     public boolean toshowOnPremisePBX{get;set;}
     public void showOnPremisePBX() {
        toshowOnPremisePBX = false;
        if(selectedCXDetail == 'On-Premise PBX') {
            toshowOnPremisePBX = true;
        } 
     }
	public boolean toshowCellPhoneOnly{get;set;}//cell Phone Only 
 	public void showCellPhoneOnly() {
        toshowCellPhoneOnly = false;
        if(selectedCXDetail == 'Cell phone only') {
            toshowCellPhoneOnly = true;
        }
 	}
    
    public boolean toshowLandline{get;set;}//LandLine
     public void showLandline() {
        toshowLandline = false;
        if(selectedCXDetail == 'Land line') {
            toshowLandline = true;
        }
     }
     public boolean toshowTraditional{get;set;}//Traditional
     public void showTraditional() {          //Traditional
     	toshowTraditional = false;
     	if(selectedCXDetail == 'Traditional') {
            toshowTraditional = true;
        }
     }
     
 	public boolean toshowNothing{get;set;}                          
 	public void showNothing() {          
     	toshowNothing = false;
     	if(selectedCXDetail == 'Nothing') {
            toshowNothing = true;
        }
  	}
 	
 	public boolean toshowOtherCloudPBX{get;set;}                          
 	public void showotherCloudPBX() {          
     	toshowOtherCloudPBX = false;
     	if(selectedCXDetail == 'Other Cloud PBX') {
            toshowOtherCloudPBX = true;
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
	
	public boolean toshowOther_PDR {get;set;}	//Other (provide detailed reason)- RingCentral – Consolidating Account
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
	
	public boolean toShowOtherSubCompetitorBox {get;set;}
	public void showOtherSubCompetitorBox() {
		toShowOtherSubCompetitorBox = false;
		oppObj.Other_SubCompetitors__c = '';
		if(selectedSubCXDetail == 'Other (provide detailed reason)') {
			toShowOtherSubCompetitorBox = true;
		}
	} 
    
    public List<SelectOption> getBusinessMortality() {
       List<SelectOption> options = getOptionList('Business_Mortality__c');
       return options; 
    }
     
 	public List<SelectOption> getchangingOption() {
       List<SelectOption> options = getOptionList('What_s_changing__c');
       return options; 
    }
     
 	public List<SelectOption> getDownsellReasonOption(){
       List<SelectOption> options = getOptionList('Why_is_cx_downselling__c');
       List<SelectOption> newOptions = new List<SelectOption>();
       for(SelectOption selectOption : options) {
       		if(selectOption.getLabel() != 'Cost' && selectOption.getLabel() != 'Fewer employees' && selectOption.getLabel() != 'Going out of business' 
       			&& selectOption.getLabel() != 'Preferred number unavailable' && selectOption.getLabel() != 'Switching devices') {
       			newOptions.add(new selectOption(selectOption.getvalue(), selectOption.getvalue()));
       		}	
       }
       return newOptions; 
    }
 	
 	public List<SelectOption> getCouldnotworkingdetailOption() {
       List<SelectOption> options = getOptionList('Couldn_t_get_it_working_details__c');
       List<SelectOption> newOptions = new List<SelectOption>();
       for(SelectOption selectOption : options) {
       		if(selectOption.getLabel() != 'Network/Firewall/VPN' && selectOption.getLabel() != 'Sales Expectations' 
       				&& selectOption.getLabel() != 'Support/Customer Care') {
       			newOptions.add(new selectOption(selectOption.getvalue(), selectOption.getvalue()));
       		}	
       }
       return newOptions; 
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
    
    public List<SelectOption> getSalesExpectationOption(){
      	List<SelectOption> options = getOptionList('Sales_Expectation__c');  
   		//options.sort();
   		return options; 
    }
    
    public List<SelectOption> getCustomerCareOption(){
      	List<SelectOption> options = getOptionList('Support_Customer_Care__c');  
   		//options.sort();
   		return options; 
    }
    
    public List<SelectOption> getQOsdetailOption(){
      	List<SelectOption> options = getOptionList('QoS_details__c');  
   		//options.sort();
   		return options; 
    }
 	
 	public List<SelectOption> getFaxOption(){//updated
       List<SelectOption> options = getOptionList('Fax__c');   
       //options.sort(); 
       return options; 
    }
    
    public List<SelectOption> getPriceOption(){//updated
       List<SelectOption> options = getOptionList('Price_Subdowngrade__c');   
       //options.sort(); 
       return options; 
    }
    
	public List<SelectOption> getWhichCXDetailOption(){
       List<SelectOption> options = getOptionList('What_will_cx_use_for_their_phone_system__c'); 
       List<SelectOption> optionsNew = new List<SelectOption>(); 
       for(SelectOption sOp : options){
        	if(sOp.getValue()=='Cell phone only' || sOp.getValue()=='Land line' || sOp.getValue()=='Hosted PBX'
        		|| (sOp.getValue() =='On-Premise PBX') || sOp.getValue() == 'Keep Existing'
        		|| sOp.getValue()=='Other' || sOp.getValue()=='Prefers not to say')
        	{
        		optionsNew.add(new SelectOption(sOp.getValue(),sOp.getValue()));	
        	}
       }
       return optionsNew; 
	}
    
    public List<SelectOption> getHostedPBXOption(){
       List<SelectOption> options = getOptionList('Hosted_PBX__c'); 
       return options; 
    }
    
    public List<SelectOption> getOnPremisePBXOption(){
       List<SelectOption> options = getOptionList('On_Premise_PBX__c');  
       List<SelectOption> optionsNew = new List<SelectOption>(); 
       for(SelectOption sOp : options){
        	if(sOp.getLabel() != 'Barracuda') {
        		optionsNew.add(new SelectOption(sOp.getValue(),sOp.getValue()));	
        	}
       }
       return optionsNew; 
    }
    public List<SelectOption> getCellPhoneOnlyOption(){          					//cell Phone Only
    	List<SelectOption> options = getOptionList('Cell_phone_only__c'); 
       	options.sort();
       	return options; 
    }
    public List<SelectOption> getLandLineOption(){             						//Land Line 
    	List<SelectOption> options = getOptionList('Land_line__c');  
        options.sort();
        return options; 
    }
    public List<SelectOption> getTraditionalOption(){             					//Tradtional
       List<SelectOption> options = getOptionList('Traditional__c'); 
       options.sort();
       return options; 
    }
    
    public List<SelectOption> getCostOption() {                      	//Cost
       List<SelectOption> options = getOptionList('Cost__c');
       return options; 
    }
    
    public List<SelectOption> getNothingOption() {                      	//Cost
       List<SelectOption> options = getOptionList('Nothing__c');
       return options; 
    }
    
    public List<SelectOption> getConsolidatingAccountOption() {                          //Cost
       List<SelectOption> options = getOptionList('RingCentral_Consolidating_Account__c');
       return options; 
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
 }