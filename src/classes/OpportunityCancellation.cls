public with sharing class OpportunityCancellation {
	
	public List<string> lstsectedCancReasons {get;set;}
 	public List<string> lstselectedCouldnotworkingdetail {get;set;}
 	public List<string> lstsectedmissingfeature {get;set;}
 	public List<string> lstsectedQOsdetail {get;set;}                          //QoS Voice
 	public List<string> lstsectedFax {get;set;}                                //QoS Fax
 	public List<string> lstsectedCXDetaildetail {get;set;}
 	public List<string> lstsectedCompanyDetaildetail {get;set;}
 	public List<string> lstsectedHostedPBXdetail {get;set;}
 	public List<string> lstsectedOnPremisePBXdetail {get;set;}                //On-PrimiseBPX
 	public List<string> lstselectedCellPhoneOnly{get;set;}                    //CellPhoneOnly
 	public List<string> lstSelectedLandLine{get;set;}                         //Land Line
 	public List<string> lstSelectedTraditional{get;set;}                       //Tradtional
 	public List<String> lstselectedcostDetail {get;set;} 
 	public List<string> lstselectedNothing {get;set;}     
 	public List<string> lstConsolidatingAccount{get;set;}  					//	RingCentral – Consolidating Account            
 	public boolean toshowmissingfeature {get;set;}
 	public boolean toshowCouldnotworkingdetail {get;set;}
 	public boolean toshowQOsdetail {get;set;}
 	public boolean toshowPricedetail {get;set;}
 	public boolean toshowFax {get;set;}
 	public boolean toshowotherdetail {get;set;}
 	public boolean toshowSalesExpectation{get;set;}
 	public boolean toshowSuppCustomerCare{get;set;}
 	public boolean toshowerrorMsg {get;set;} 
 	public boolean toshowcostdetail {get;set;}
 	public boolean toshowOutage {get;set;}
 	public List<string> errorMsgList {get;set;} 
 	public Opportunity oppCancelObj {get;set;}
 	public List<string> tempList {get;set;}
 	public string selectedCancellationRsn {get;set;}
 	public boolean toShowAccountUId {get;set;}
 	public boolean toShowBusinessMortality {get;set;}
 	public boolean toShowOtherSubDownGrade {get;set;}
 	public string selectedBusinessMortality {get;set;}
 	public string selectedSubDownGradeReason {get;set;}
 	public string selectedCXDetail {get;set;}
 	public string selectedSubCXDetail {get;set;}
	
	public OpportunityCancellation(ApexPages.StandardController controller) {
		lstsectedCancReasons = new List<string>();
        lstselectedCouldnotworkingdetail = new List<string>();
        lstsectedmissingfeature = new List<string>(); 
        lstsectedQOsdetail = new List<string>();                                        //QoS Voice
        lstsectedFax = new List<string>();     
        lstConsolidatingAccount = new List<string>(); //RingCentral – Consolidating Account                                         //Fax
        lstsectedCXDetaildetail = new List<string>();
        lstsectedCompanyDetaildetail = new List<string>();
        lstsectedHostedPBXdetail = new List<string>();                                //HostedPBX
        lstsectedOnPremisePBXdetail = new List<string>();                             //On-premisePBX
        lstselectedCellPhoneOnly = new List<string>();                                //CellPhoneOnly
        lstSelectedLandLine = new List<string>();                                     //Land Line
        lstSelectedTraditional = new List<string>();                                  //Tradtional
        lstselectedcostDetail = new List<string>(); 
        lstselectedNothing = new List<string>(); 
        errorMsgList = new List<string>();
        toshowCouldnotworkingdetail = false;
        toshowmissingfeature = false;
        toshowQOsdetail = false;                                                     //QoS Voice
        toshowFax=false;                                                             //QoS Fax
        toshowHostedPBX = false;                                                     //HostedPBX
        toshowOnPremisePBX = false;                                                  //On-PremisePBX
        toshowCellPhoneOnly = false;                                                 //cellPhoneOnly
        toshowLandline = false;                                                      //Land Line
        toshowTraditional = false;                                                   //Traditional
        toshowotherdetail = false;
        //toshowSpecifyValue = false;////other(please specify) 
        toShowCustomerSection = false;
        toshowerrorMsg = false;
        toshowcostdetail = false;
        toshowOutage = false;
        toShowAccountUId = false;
        toShowBusinessMortality = false;
        toShowOtherSubDownGrade = false;
        toshowPricedetail = false;
        toshowSalesExpectation = false;
        toshowSuppCustomerCare = false;
        oppCancelObj = new Opportunity();
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
	        		oppCancelObj.Specify_other__c = '';
	        	}
    			if(selectedCXDetail =='Hosted PBX' && (selectedSubCXDetail == null || selectedSubCXDetail == '')) {
                     toshowerrorMsg = true;
                     errorMsgList.add('Please select &quot;Hosted PBX?&quot;');
                }
                /*if(selectedCXDetail == 'Cell phone only' && (selectedSubCXDetail == null || selectedSubCXDetail == '')) {
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
                if(selectedCXDetail == 'Other' && string.isBlank(oppCancelObj.Specify_other__c)) {
                    toshowerrorMsg = true;
                    errorMsgList.add('Please provide value in Other.');
                }
                if(selectedSubCXDetail == 'Other (provide detailed reason)' && string.isBlank(oppCancelObj.Other_SubCompetitors__c)) {
                    toshowerrorMsg = true;
                    errorMsgList.add('Please provide value in Other (provide detailed reason).');
                }
            }
	        
	        if(toshowerrorMsg == false) {
	            PageReference rtrnPage;
	            string keyPrefix = '/' + Schema.getGlobalDescribe().get('Opportunity').getDescribe().getKeyPrefix() + '/e';
	            PageReference rtrnTempPage = null;
	            if(selectedCancellationRsn != null || selectedSubDownGradeReason != null ||
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
	            /*if(lstselectedChangingReasons.size()>0) {
	                rtrnTempPage.getParameters().put('00N80000005Hc4B',getwhatsChangingPicListValue());
	            }*/
	            if(selectedCancellationRsn != null && selectedCancellationRsn != '') {
	                 rtrnTempPage.getParameters().put('00N80000005Hgg5',selectedCancellationRsn);
	            }
	            if(selectedCancellationRsn == 'Business Mortality' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00N80000005I1X3',selectedSubDownGradeReason);
	            }
	            if(selectedCancellationRsn == 'Consolidating into other RC account' && oppCancelObj.New_Account_UID__c != null) {
	                 rtrnTempPage.getParameters().put('00N80000005I1X8',oppCancelObj.New_Account_UID__c);
	            }
	            if(selectedCancellationRsn == 'Couldn\'t get it working' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3I',selectedSubDownGradeReason);
	            }
	            if(selectedCancellationRsn == 'Missing critical feature' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3d',selectedSubDownGradeReason);
	            }
	            if(selectedCancellationRsn == 'Price' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00N80000005I1Wy',selectedSubDownGradeReason);
	            }
	            if(selectedCancellationRsn == 'QoS Voice' && selectedSubDownGradeReason != '') {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3m',selectedSubDownGradeReason);
	            } 
	            if(selectedCancellationRsn == 'Qos Fax' && selectedSubDownGradeReason != '') {
	                rtrnTempPage.getParameters().put('00N80000005Hc3N',selectedSubDownGradeReason);
	            }
	            if(selectedCancellationRsn == 'Sales Expectations' && selectedSubDownGradeReason != '') {
	                rtrnTempPage.getParameters().put('00N80000005I1Wt',selectedSubDownGradeReason);
	            }
	            if(selectedCancellationRsn == 'Support/Customer Care' && selectedSubDownGradeReason != '') {
	                rtrnTempPage.getParameters().put('00N80000005I1Wo',selectedSubDownGradeReason);
	            }
	             if(selectedSubDownGradeReason == 'Other (provide detailed reason)') {
	                rtrnTempPage.getParameters().put('00N80000005I1We',oppCancelObj.Other_SubDowngrade_Reason__c);
	            }
	            if(!string.isBlank(oppCancelObj.Other_details__c)) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3i',oppCancelObj.Other_details__c);
	            }
	            if(oppCancelObj.Outage_Date__c != null) {
	            	 String formatedDate = createformatDate(oppCancelObj.Outage_Date__c);
	                 rtrnTempPage.getParameters().put('00N80000005HdaX', formatedDate);						// other(please specify) 
	            }
	            if(!string.isBlank(oppCancelObj.Specify_value__c)) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3w',oppCancelObj.Specify_value__c);	// other(please specify) 
	            }
	            if((!string.isBlank(oppCancelObj.Sub_Downgrade_Reason_Other__c))) {
	                 rtrnTempPage.getParameters().put('00N80000005I1Wj',oppCancelObj.Sub_Downgrade_Reason_Other__c);	// other(please specify) 
	            }
	            
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
	            if(!string.isBlank(oppCancelObj.Specify_other__c) && toshowSpecifyOthers == true) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3r',oppCancelObj.Specify_other__c);
	            }
	            if(!string.isBlank(oppCancelObj.Other_Cloud_PBX__c) && toshowOtherCloudPBX == true) {
	                 rtrnTempPage.getParameters().put('00N80000005HdaS',oppCancelObj.Other_Cloud_PBX__c);	
	            }
	            if(oppCancelObj.OtherCloudPBX_Prefers_not_to_say__c == true && toshowOtherCloudPBX == true) {
        			rtrnTempPage.getParameters().put('00N80000005HevC','1');
   				}
   				if(oppCancelObj.Other_SubCompetitors__c != null && oppCancelObj.Other_SubCompetitors__c != '') {
        			rtrnTempPage.getParameters().put('00N80000005I1WZ', oppCancelObj.Other_SubCompetitors__c);
   				}
	            rtrnPage = rtrnTempPage;
	            rtrnPage.setRedirect(true);
	            return rtrnPage;
	        }	
     	} catch(Exception ex) {
     		toshowerrorMsg = true;
            errorMsgList.add(ex.getMessage() + ex.getLineNumber());
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
     
     public String getCanCelreasonsPicListValue(){
            String strPram='';
              for(String str:lstsectedCancReasons){
                  if(strPram==''){
                            strPram=str;
                        }else{
                            strPram=strPram+'&00N80000005Hgg5='+str;
                        }
                      
                    } 
          return strPram;  
    }
    
    public String getCostPicListValue(){
        String strPram='';
        for(String str: lstselectedcostDetail) {
            if(strPram == '') {
                    strPram = str;
                } else {
                    strPram=strPram + '&00N80000005HdaD='+str;
            }
        } 
      return strPram;  
    }
    
    
    public String getColuldNotPicListValue(){
        String strPram='';
          for(String str:lstselectedCouldnotworkingdetail){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00N80000005Hc3I='+str;
                    }
            }  
            return strPram;
    }
    
    public String getMissingPicListValue(){
            String strPram='';
              for(String str:lstsectedmissingfeature){
                  if(strPram==''){
                            strPram=str;
                        }else{
                            strPram=strPram+'&00N80000005Hc3d='+str;
                        }
                      
                    } 
          return strPram; 
    }
    
    
    public String getQOsListValue(){                                                //QoS Voice
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
    
    public String getFaxListValue(){                                                 //QoS Fax
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
	        } else {
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
 	
 	public String getCellPhoneOnlyListValue(){                                            //CellPhoneOnly
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
    
    public String getLandLineListValue(){                                              //Land Line
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
    
    public String getTraditionalListValue(){                                          //Traditional 
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
    
	public String getNothingListValue() {                                          //Traditional 
      	String strPram='';
      	for(String str : lstselectedNothing) {
        	if(strPram=='') {
           		strPram=str;
        	} 	else {
           		strPram=strPram+'&00N80000005HdaI='+str;
        	}
      	}  
      	return strPram;
	}
   	
   	public String getConsolidatingAccount(){  	//	RingCentral – Consolidating Account
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
            String retURL = ApexPages.currentPage().getParameters().get('retURL');
        	if(String.isNotBlank(retURL)) {
            	rtrnPage =  new PageReference(retURL);
	        } else {
	            rtrnPage = new PageReference('/006/o'); 
	        }
        }
        catch(Exception ex) {}
        return rtrnPage;
    }
    
    public PageReference next() {
        toShowCustomerSection = true;
        toshowerrorMsg = false;
        errorMsgList = new List<string>();
        if(selectedCancellationRsn == null) {
    	 	toshowerrorMsg = true;
            toShowCustomerSection = false;
            errorMsgList.add('Please select &quot; Why is cx downselling?&quot');
        } else {
        	if(selectedCancellationRsn == 'Business Mortality' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
	    		toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;Business Mortality&quot;');
        	}
        	if(selectedCancellationRsn == 'Consolidating into other RC account' && (oppCancelObj.New_Account_UID__c == null || oppCancelObj.New_Account_UID__c == '')) {
	    		toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please provide  &quot;New Account UID&quot;');
        	}
            if(selectedCancellationRsn == 'Couldn\'t get it working' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select Couldn’t get it working.');
            }
            if(selectedCancellationRsn == 'Missing critical feature' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
		        toshowerrorMsg = true;
		        toShowCustomerSection = false;
		        errorMsgList.add('Please select Missing critical feature.');
            } 
            if(selectedCancellationRsn == 'Price' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
		        toshowerrorMsg = true;
		        toShowCustomerSection = false;
		        errorMsgList.add('Please select Price.');
            } 
         	if(selectedCancellationRsn == 'QoS Voice' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;QoS Voice &quot;'); 
            }
        	if(selectedCancellationRsn == 'Qos Fax' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {//updated
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;QoS Fax&quot;');
        	}
        	if(selectedCancellationRsn == 'Sales Expectations' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {//updated
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;Sales Expectations&quot;');
        	}
        	if(selectedCancellationRsn == 'Support/Customer Care' && (finalsubDownGradeReason == null || finalsubDownGradeReason == '')) {//updated

	            toShowCustomerSection = false;
	            errorMsgList.add('Please select &quot;Support/Customer Care&quot;');
        	}
        	if(selectedCancellationRsn == 'Other (provide detailed reason)' && string.isBlank(oppCancelObj.Other_details__c)) {
	            toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please provide value in Other (provide detailed reason).');
        	}
        	if(finalsubDownGradeReason != null && finalsubDownGradeReason == 'Other (provide detailed reason)' && 
        			String.isBlank(oppCancelObj.Other_SubDowngrade_Reason__c)) {
        		toshowerrorMsg = true;
	            toShowCustomerSection = false;
	            errorMsgList.add('Please provide value in Other (provide detailed reason).');
        	}
        } 
        return null;
     }
     
 	/*public PageReference next() {
        toShowCustomerSection = true;
        toshowerrorMsg = false;
        errorMsgList = new List<string>();
        if(lstsectedCancReasons != null && lstsectedCancReasons.size()>0) {
            for(string str : lstsectedCancReasons) {
                if(str == 'Cost' && lstselectedcostDetail != null && lstselectedcostDetail.size() == 0) {
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in &quot;Cost&quot;');
                }
                if(str == 'Couldn\'t get it working' && lstselectedCouldnotworkingdetail != null && lstselectedCouldnotworkingdetail.size() == 0) {
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in &quot;Couldn’t get it working&quot;');
                }
                if(str == 'Missing critical feature' && lstsectedmissingfeature != null && lstsectedmissingfeature.size() == 0) {
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in &quot;Missing critical feature&quot;');
                } 
                if(str == 'QoS Voice' && lstsectedQOsdetail != null && lstsectedQOsdetail.size() == 0) {     //Qos Voice
                    toshowerrorMsg = true; 
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in &quot;QoS Voice&quot;');
                }
                if(str == 'QoS Fax' && lstsectedFax != null && lstsectedFax.size() == 0) {                   //QoS Fax
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please select atleast one value in &quot;QoS Fax&quot;');
                }
                if(str == 'Other (provide detailed reason)' && string.isBlank(oppCancelObj.Other_details__c)) {
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please provide value in &quot;Other (provide detailed reason)&quot;');
                }
            }
            if(lstsectedmissingfeature != null && lstsectedmissingfeature.size()>0) {   //other(please specify)
                for(string str1 : lstsectedmissingfeature) {
                    if(str1 == 'Other (Please Specify)'&& string.isBlank(oppCancelObj.Specify_value__c)) {
                        toshowerrorMsg = true;
                        toShowCustomerSection = false;
                        errorMsgList.add('Please provide value in &quot;Other (Please Specify)&quot;');
                    }
                        }
            }
            if(toshowotherdetail == false) {
                oppCancelObj.Other_details__c = '';
            }
            if(toshowSpecifyValue == false) {
                oppCancelObj.Specify_value__c = '';
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
                oppCancelObj.Outage_Date__c = null;
            }
        } else {
            toshowerrorMsg = true;
            toShowCustomerSection = false;
            errorMsgList.add('Please select atleast one value in &quot;Cancellation Reasons&quot;');
        }
        return null;
 	}*/
     
  	public PageReference back() { //** back PAGE
        toShowCustomerSection =false;
        errorMsgList.clear();
        toshowerrorMsg = false;
     	return null;
 	}
 	
 	public void skip() {
        selectedCancellationRsn = '';
        oppCancelObj.Other_details__c = '';
        oppCancelObj.Outage_Date__c = null;
        oppCancelObj.Specify_value__c = '';
        errorMsgList.clear();
        toshowerrorMsg = false;
        toShowCustomerSection = true;
        toShowOtherSubDownGrade = false;
    	finalsubDownGradeReason = '';
    	selectedSubDownGradeReason = '';
    	toshowOutage = false;
    	toshowPricedetail = false;
      	selectedCancellationRsn = '';
      	oppCancelObj.Other_SubDowngrade_Reason__c = '';
      	toShowSubDownGradeOtherMissing = false;
      	oppCancelObj.Sub_Downgrade_Reason_Other__c = '';
 	}
     
    public void showdetailCall() {
    	oppCancelObj.Other_SubDowngrade_Reason__c = '';
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
		oppCancelObj.Sub_Downgrade_Reason_Other__c = '';
		oppCancelObj.Other_SubDowngrade_Reason__c = '';
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
     	if(selectedCancellationRsn == 'Business Mortality') {
     		toShowBusinessMortality = true;
     	}
     }
     
     public void showAccountUID() {
     	toShowAccountUId = false;
     	if(selectedCancellationRsn == 'Consolidating into other RC account') {
     		toShowAccountUId = true;
     	}
     }
     
     public void showFaxCall() {
        toshowFax = false;
        if(selectedCancellationRsn == 'Qos Fax') {
        	toshowFax = true;
        }
     }
     
 	//public boolean toshowcostdetail {get;set;}
    public void showCostDetails() {
        toshowcostdetail = false;
        if(selectedCancellationRsn == 'Cost') {
        	toshowcostdetail = true;
        }
     }
     
     //public boolean toshowOutage {get;set;}
     public void showOutage() {
     	toshowOutage = false;
     	if(selectedCancellationRsn == 'Outages') {
        	toshowOutage = true;
        }
     }
     
     public void showCouldnotworkingdetailCall() {
        toshowCouldnotworkingdetail = false;
        if(selectedCancellationRsn == 'Couldn\'t get it working') {
        	toshowCouldnotworkingdetail = true;
        }
     }
     
     public void showmissingfeatureCall() {
        toshowmissingfeature = false;
        if(selectedCancellationRsn == 'Missing critical feature') {
            toshowmissingfeature = true;
        } 
     }
     
     public void showQOsdetailCall() {
        toshowQOsdetail = false;
        if(selectedCancellationRsn == 'QoS Voice') {
            toshowQOsdetail = true;
        }
     }
     
     public void showPriceDetail() {
        toshowPricedetail = false;
        if(selectedCancellationRsn == 'Price') {
            toshowPricedetail = true;
        }
     }
     
     public void showSalesExpectation() {
        toshowSalesExpectation = false;
        if(selectedCancellationRsn == 'Sales Expectations') {
            toshowSalesExpectation = true;
        }
     }
     
     public void showSuppCustomerCare() {
        toshowSuppCustomerCare = false;
        if(selectedCancellationRsn == 'Support/Customer Care') {
            toshowSuppCustomerCare = true;
        }
     }
     
     public void showOtherdetailCall() {
        toshowotherdetail = false;
        if(selectedCancellationRsn == 'Other (provide detailed reason)') { 
            toshowotherdetail = true;
        }
     }
     
     /****************************************************************************************************************/
    
	public void showcompanyCall() {
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
        oppCancelObj.Other_SubCompetitors__c = '';
        //showConsolidatingAccount(); 	//	RingCentral -Consolidating Account
        //showOtherProDetRes();      
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
    
    public boolean toshowOther_PDR {get;set;}	//	Other (provide detailed reason)- RingCentral – Consolidating Account
 	public void showOtherProDetRes() {
        toshowOther_PDR = false;
        if(lstConsolidatingAccount.size()>0) {           
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
		oppCancelObj.Other_SubCompetitors__c = '';
		if(selectedSubCXDetail == 'Other (provide detailed reason)') {
			toShowOtherSubCompetitorBox = true;
		}
	}    
	
	/*public List<SelectOption> getCancellationReasonOption(){
        List<SelectOption> options = getOptionList('Cancellation_Reason__c');
        return options; 
    }*/
    
    public List<SelectOption> getCancellationReasonOption(){
       List<SelectOption> options = getOptionList('Cancellation_Reason__c');
       List<SelectOption> newOptions = new List<SelectOption>();
       for(SelectOption selectOption : options) {
       		if(selectOption.getLabel() != 'Cost' && selectOption.getLabel() != 'Fewer employees' && selectOption.getLabel() != 'Going out of business' 
       			&& selectOption.getLabel() != 'Preferred number unavailable' && selectOption.getLabel() != 'Switching devices' &&
       			selectOption.getLabel() != 'Too many unwanted calls') {
       			newOptions.add(new selectOption(selectOption.getvalue(), selectOption.getvalue()));
       		}	
       }
       return newOptions; 
    }
    
   	public List<SelectOption> getBusinessMortality() {
       List<SelectOption> options = getOptionList('Business_Mortality__c');
       return options; 
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
    
    public List<SelectOption> getQOsdetailOption() {                              //QoS Voice
       List<SelectOption> options = getOptionList('QoS_details__c');  
       //options.sort();
       return options; 
    }
    
    public List<SelectOption> getFaxOption() {                                     //QoS Fax
       List<SelectOption> options = getOptionList('Fax__c');   
       options.sort(); 
       return options; 
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
        		|| (sOp.getValue()=='On-Premise PBX') || sOp.getValue() == 'Keep Existing'
        		|| sOp.getValue()=='Other' || sOp.getValue()=='Prefers not to say')
        	{
        		optionsNew.add(new SelectOption(sOp.getValue(),sOp.getValue()));	
        	}
       }
       return optionsNew; 
	}
 
     public List<SelectOption> getHostedPBXOption() {                            //HostedPBX
       List<SelectOption> options = getOptionList('Hosted_PBX__c'); 
       //options.sort();
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
    
    public List<SelectOption> getCellPhoneOnlyOption(){                      //cell Phone Only
       List<SelectOption> options = getOptionList('Cell_phone_only__c'); 
       options.sort();
       return options; 
    }
    
    public List<SelectOption> getLandLineOption(){                           //Land Line 
       List<SelectOption> options = getOptionList('Land_line__c');  
       options.sort();
       return options; 
    }
    
    public List<SelectOption> getTraditionalOption(){                      //Tradtional
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
        } catch(Exception ex) { }
       return options; 
    }
}