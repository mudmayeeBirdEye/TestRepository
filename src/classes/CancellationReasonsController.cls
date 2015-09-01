public with sharing class CancellationReasonsController {
     
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
     public List<string> lstSelectedTraditional{get;set;} 						//Tradtional
     public List<String> lstselectedcostDetail {get;set;} 
     public List<string> lstselectedNothing {get;set;}  
     public List<string> lstConsolidatingAccount{get;set;}                      //RingCentral – Consolidating Account                
     public boolean toshowmissingfeature {get;set;}
     public boolean toshowCouldnotworkingdetail {get;set;}
     public boolean toshowQOsdetail {get;set;}
     public boolean toshowFax {get;set;}
     public boolean toshowotherdetail {get;set;}
     public boolean toshowerrorMsg {get;set;}
     public boolean toshowcostdetail {get;set;}
     public boolean toshowOutage {get;set;}
     public List<string> errorMsgList {get;set;} 
     public Cancel_Request__c cancelObj {get;set;}
     public List<string> tempList {get;set;}
     
     public CancellationReasonsController(ApexPages.StandardController controller) {
        lstsectedCancReasons = new List<string>();
        lstselectedCouldnotworkingdetail = new List<string>();
        lstsectedmissingfeature = new List<string>(); 
        lstsectedQOsdetail = new List<string>();                                        //QoS Voice
        lstsectedFax = new List<string>();                                              //Fax
        lstsectedCXDetaildetail = new List<string>();
        lstsectedCompanyDetaildetail = new List<string>();
        lstsectedHostedPBXdetail = new List<string>();                                //HostedPBX
        lstsectedOnPremisePBXdetail = new List<string>();                             //On-premisePBX
        lstselectedCellPhoneOnly = new List<string>();                                //CellPhoneOnly
        lstSelectedLandLine = new List<string>();                                     //Land Line
        lstSelectedTraditional = new List<string>();                                  //Tradtional
        lstselectedcostDetail = new List<string>(); 
        lstselectedNothing = new List<string>(); 
        lstConsolidatingAccount = new List<string>();                                 //RingCentral – Consolidating Account
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
        toshowSpecifyValue = false;////other(please specify) 
        toShowCustomerSection = false;
        toshowerrorMsg = false;
        toshowcostdetail = false;
        toshowOutage = false;
        cancelObj = new Cancel_Request__c();
        tempList = new List<string>();
        tempList.add('test');
     }
    
     
     public boolean toShowCustomerSection {get;set;}
     public PageReference create() {
     	try {
     		toshowerrorMsg = false;
	        errorMsgList = new List<string>();
	        if(lstsectedCXDetaildetail.size() == 0) {
	            toshowerrorMsg = true;
	            errorMsgList.add('Please select atleast one value in &quot; What will cx use for their phone system?&quot;');
	        }
	        if(lstsectedCXDetaildetail != null && lstsectedCXDetaildetail.size() > 0) {
	            for(string str : lstsectedCXDetaildetail) {
	                if(str == 'Prefers not to say') {
	                    toshowerrorMsg = false;
	                    cancelObj.Specify_other__c = '';
	                    lstsectedCompanyDetaildetail = new List<string>();
	                    break;  
	                }
	             	if(str=='Hosted PBX' && lstsectedHostedPBXdetail.size() == 0) {                            //  Hosted PBX
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Hosted PBX?&quot;');
	            	}
	                if(str=='Cell phone only'&& lstselectedCellPhoneOnly.size() == 0) {                         // Cell Phone ONLY
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Cell phone only?&quot;');
	                }
	                if(str=='Land line'&& lstSelectedLandLine.size() == 0) {                                     //Land Line 
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Land line?&quot;');
	                }
	                if(str=='On-Premise PBX'&& lstsectedOnPremisePBXdetail.size() == 0) {                        //On-premise
	                         toshowerrorMsg = true; 
	                         errorMsgList.add('Please select atleast one value in &quot;On-Premise PBX?&quot;');
	                }
	                if(str=='Traditional'&& lstSelectedTraditional.size() == 0) {                                 //Tradtional
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Traditional?&quot;');
	                }
	             	if(str == 'other'&& string.isBlank(cancelObj.Specify_other__c)) {                               
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please provide value in &quot;others&quot;');
	                }
	                if(str == 'Nothing' && lstselectedNothing.size() == 0) {                               
	                         toshowerrorMsg = true;
	                         errorMsgList.add('Please select atleast one value in &quot;Nothing&quot;');
	                }
	                if(str == 'RingCentral – Consolidating Account' && lstConsolidatingAccount.size() == 0) {
				             toshowerrorMsg = true;
				             errorMsgList.add('Please select atleast one value in &quot;RingCentral – Consolidating Account&quot;');
      			   }
	                /*if(str == 'Other Cloud PBX' && String.isBlank(cancelObj.Other_Cloud_PBX__c)) {
	                		toshowerrorMsg = true;
	                         errorMsgList.add('Please provide value in &quot;Other Cloud PBX&quot;');
	                }*/
				                 	/*if(toshowSpecifyOthers == true && string.isBlank(cancelObj.Specify_other__c)) {
				                        toshowerrorMsg = true;
				                        errorMsgList.add('Please provide value in &quot;specify others&quot;');
				                    }*/
	            } 
	            for(string str : lstsectedCXDetaildetail) {
	                if(str != 'Prefers not to say' && lstsectedCompanyDetaildetail != null && 
	                    lstsectedCompanyDetaildetail.size() > 0) {
	                    /*if(toshowSpecifyOthers == true && string.isBlank(cancelObj.Specify_other__c)) {
	                        toshowerrorMsg = true;
	                        errorMsgList.add('Please provide value in &quot;specify others&quot;');
	                        break;
	                    }*/
	                }
	            }   
	        }
	        if(toshowerrorMsg == false) {
	            PageReference rtrnPage;
	            string keyPrefix = '/' + Schema.getGlobalDescribe().get('Cancel_Request__c').getDescribe().getKeyPrefix() + '/e';
	            PageReference rtrnTempPage = null;
	            if(lstsectedCompanyDetaildetail.size()>0 || lstsectedCXDetaildetail.size()>0 || lstsectedCancReasons.size()>0 
	                || lstselectedCouldnotworkingdetail.size()>0 || lstsectedmissingfeature.size()>0 || lstsectedQOsdetail.size()>0|| lstsectedFax.size()>0
	                ) {
	                keyPrefix = '/apex/redirectCancelPage';
	            }
	            rtrnTempPage = new PageReference(keyPrefix);
	            rtrnTempPage.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType'));
	            rtrnTempPage.getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
	            rtrnTempPage.getParameters().put('CF00N80000004i7M3',ApexPages.currentPage().getParameters().get('CF00N80000004i7M3'));
	            rtrnTempPage.getParameters().put('CF00N80000004i7M3_lkid',ApexPages.currentPage().getParameters().get('CF00N80000004i7M3_lkid'));
	            rtrnTempPage.getParameters().put('00N80000004i7yH',ApexPages.currentPage().getParameters().get('00N80000004i7yH'));
	            rtrnTempPage.getParameters().put('nooverride','1');
	            if(lstsectedCancReasons.size()>0) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc3S',getCanCelreasonsPicListValue());
	            }
	         	if(lstsectedFax.size()>0) {  //Fax
	                rtrnTempPage.getParameters().put('00N80000005Hc4L',getFaxListValue());
	            }
	            if(lstselectedCouldnotworkingdetail.size()>0) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc46',getColuldNotPicListValue());
	            }
	            if(lstsectedmissingfeature.size()>0) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc4k',getMissingPicListValue());
	            }
	            if(lstsectedQOsdetail.size()>0) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc4u',getQOsListValue());
	            } 
	         	if(!string.isBlank(cancelObj.Other_details__c)) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc4p',cancelObj.Other_details__c);
	            }
	            if(lstselectedcostDetail.size()>0) {
	        		rtrnTempPage.getParameters().put('00N80000005HdZy',getCostPicListValue());
	            }
	            if(cancelObj.Outage_Date__c != null) {
	            	 String formatedDate = createformatDate(cancelObj.Outage_Date__c);
	                 rtrnTempPage.getParameters().put('00N80000005Hda4', formatedDate);						// other(please specify) 
	            }
	            if(!string.isBlank(cancelObj.Specify_value__c)) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc54',cancelObj.Specify_value__c);	// other(please specify) 
	            }
	            
	            /********************************************* Customer List *************************************************/
	            
	            if(lstsectedCXDetaildetail.size()>0) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc5J',getCXDetailPicListValue());
	            }
	         	if(!string.isBlank(cancelObj.Specify_other__c) && toshowSpecifyOthers == true) {
	                 rtrnTempPage.getParameters().put('00N80000005Hc4z',cancelObj.Specify_other__c);
	            }
	            if(!string.isBlank(cancelObj.Other_Cloud_PBX__c) && toshowOtherCloudPBX == true) {
	                 rtrnTempPage.getParameters().put('00N80000005Hda8',cancelObj.Other_Cloud_PBX__c);	
	            }
	            if(cancelObj.OtherCloudPBX_Prefers_not_to_say__c == true && toshowOtherCloudPBX == true) {
                 	rtrnTempPage.getParameters().put('00N80000005HevD','1');  
            	}
	            if(lstsectedHostedPBXdetail.size()>0 && toshowHostedPBX == true)                                                  // Hosted PBX
	            {
	                rtrnTempPage.getParameters().put('00N80000005Hc4a',getHostedPBXListValue());    
	            }
	            if(lstsectedOnPremisePBXdetail.size()>0 && toshowOnPremisePBX == true) {                                               //  On-permise PBX 
	                rtrnTempPage.getParameters().put('00N80000005Hc3x',getOnPremisePBXListValue());
	            }
	            if(lstselectedCellPhoneOnly.size()>0 && toshowCellPhoneOnly == true) {                                                //  CellPhoneOnly
	                rtrnTempPage.getParameters().put('00N80000005Hc34',getCellPhoneOnlyListValue());	
	            }
	            if(lstSelectedLandLine.size()>0 && toshowLandline == true) {                                                     //Land Line
	                rtrnTempPage.getParameters().put('00N80000005Hc4f',getLandLineListValue());
	            }
	            if(lstSelectedTraditional.size()>0 && toshowTraditional == true) {                                                 //Traditional
	                rtrnTempPage.getParameters().put('00N80000005Hc59',getTraditionalListValue());  
	            }
	            if(lstselectedNothing.size()>0 && toshowNothing == true) { 
	            	rtrnTempPage.getParameters().put('00N80000005Hda3',getNothingListValue());
	            }
				if(lstConsolidatingAccount.size()>0 && toshowConsolidatingAccount == true) { //RingCentral – Consolidating Account        
					rtrnTempPage.getParameters().put('00N80000004OBFM',getConsolidatingAccount());
				}
				if(!string.isBlank(cancelObj.Consolidating_Account__c)) {
					rtrnTempPage.getParameters().put('00N80000004OBFR',cancelObj.Consolidating_Account__c); //RingCentral – Consolidating Account -other
				}
	            rtrnPage = rtrnTempPage;
	            rtrnPage.setRedirect(true);
	            return rtrnPage;
	        }	
     	} catch(Exception ex) {}
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
	 public String getConsolidatingAccount(){  //RingCentral – Consolidating Account
	        String strPram='';
	        for(String str : lstConsolidatingAccount) {
	            if(strPram=='') {
	                strPram=str;
	            } else {
	                strPram=strPram+'&00N80000004OBFM='+str;
	            }
	 }
	
	return strPram;
	}
     
     public String getCanCelreasonsPicListValue(){
            String strPram='';
              for(String str:lstsectedCancReasons){
                  if(strPram==''){
                            strPram=str;
                        }else{
                            strPram=strPram+'&00N80000005Hc3S='+str;
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
                	strPram=strPram + '&00N80000005HdZy='+str;
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
                        strPram=strPram+'&00N80000005Hc46='+str;
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
                            strPram=strPram+'&00N80000005Hc4k='+str;
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
                        strPram=strPram+'&00N80000005Hc4u='+str;
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
                        strPram=strPram+'&00N80000005Hc4L='+str;
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
                        strPram=strPram+'&00N80000005Hc5J='+str;
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
                        strPram=strPram+'&00N80000005Hc4a='+str;
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
                        strPram=strPram+'&00N80000005Hc3x='+str;
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
                        strPram=strPram+'&00N80000005Hc34='+str;
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
                        strPram=strPram+'&00N80000005Hc4f='+str;
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
                        strPram=strPram+'&00N80000005Hc59='+str;
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
           strPram=strPram+'&00N80000005Hda3='+str;
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
                if(str == 'Other (provide detailed reason)' && string.isBlank(cancelObj.Other_details__c)) {
                    toshowerrorMsg = true;
                    toShowCustomerSection = false;
                    errorMsgList.add('Please provide value in &quot;Other (provide detailed reason)&quot;');
                }
            }
            if(lstsectedmissingfeature != null && lstsectedmissingfeature.size()>0) {	//other(please specify)
                for(string str1 : lstsectedmissingfeature) {
                    if(str1 == 'Other (Please Specify)'&& string.isBlank(cancelObj.Specify_value__c)) {
                        toshowerrorMsg = true;
                        toShowCustomerSection = false;
                        errorMsgList.add('Please provide value in &quot;Other (Please Specify)&quot;');
                    }
                }
            }
            if(toshowotherdetail == false) {
            	cancelObj.Other_details__c = '';
            }
            if(toshowSpecifyValue == false) {
            	cancelObj.Specify_value__c = '';
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
            	cancelObj.Outage_Date__c = null;
            }
        } else {
            toshowerrorMsg = true;
            toShowCustomerSection = false;
            errorMsgList.add('Please select atleast one value in &quot;Cancellation Reasons&quot;');
        }
        return null;
 	}
     
 	public PageReference back() { 		//** back PAGE
        toShowCustomerSection = false;
        errorMsgList.clear();
        toshowerrorMsg = false;
     	return null;
 	}
     
     public void skip() {
        lstsectedCancReasons = new List<string>();
        lstselectedCouldnotworkingdetail = new List<string>();
        lstsectedmissingfeature = new List<string>(); 
        lstsectedQOsdetail = new List<string>();
        lstsectedFax = new List<string>();
        lstselectedcostDetail = new List<string>();
        cancelObj.Other_details__c = '';
        cancelObj.Outage_Date__c = null;
        cancelObj.Specify_value__c = '';
        toShowCustomerSection = true;
        errorMsgList.clear();
        toshowerrorMsg = false;
     }
     
 	public void showdetailCall() {
     	showCostDetails();
        showCouldnotworkingdetailCall();
        showmissingfeatureCall();
        showQOsdetailCall();
        showFaxCall();
        showOtherdetailCall();
        showOutage();
        showspecifyValue();		//other(please specify) 
 	}  
  	
  	public void showcompanyCall() {
        showHostedPBX();
        showOnPremisePBX();
        showCellPhoneOnly();
        showLandline();
        showTraditional();
        showspecifyOthers();
        showNothing();
        showotherCloudPBX();
        showConsolidatingAccount(); //RingCentral -Consolidating Account
        showOtherProDetRes();
     }
     
      public void showCostDetails() {
        toshowcostdetail = false;
        for(string str : lstsectedCancReasons) {
            if(str == 'Cost') {
                toshowcostdetail = true;
                break;
            } else {
                toshowcostdetail = false;
            }
        }
     }
     
     public void showCouldnotworkingdetailCall() {
        toshowCouldnotworkingdetail = false;
        for(string str : lstsectedCancReasons) {
            if(str == 'Couldn\'t get it working') {
                toshowCouldnotworkingdetail = true;
                break;
            } else {
                toshowCouldnotworkingdetail = false;
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
    public boolean toshowOther_PDR {get;set;}//Other (provide detailed reason)- RingCentral – Consolidating Account
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
     public void showmissingfeatureCall() {
        toshowmissingfeature = false;
        for(string str : lstsectedCancReasons) {
            if(str == 'Missing critical feature') {
                toshowmissingfeature = true;
                break;
            } else {
                toshowmissingfeature = false;
            }
        }
     }
     
     public void showOutage() {
     	toshowOutage = false;
     	for(string str : lstsectedCancReasons) {
            if(str == 'Outages') {
                toshowOutage = true;
                break;
            } else {
                toshowOutage = false;
            }
        }
     }
     
     public void showQOsdetailCall() {                                       //Qos Voice
        toshowQOsdetail = false;
        for(string str : lstsectedCancReasons) {
            if(str == 'QoS Voice') {
                toshowQOsdetail = true;
                break;
            } else {
                toshowQOsdetail = false;
            }
        }
     }
     public void showFaxCall() {                                             //Qos Fax
        toshowFax = false;
        for(string str : lstsectedCancReasons) {
            if(str == 'QoS Fax') {
                toshowFax = true;
                break;
            } else {
                toshowFax = false;
            }
        }
     }
     
     public void showOtherdetailCall() {
        toshowotherdetail = false;
        for(string str : lstsectedCancReasons) {
            if(str == 'Other (provide detailed reason)') {
                toshowotherdetail = true;
                break;
            } else {
                toshowotherdetail = false;
            }
        }
     }
     
     public boolean toshowSpecifyOthers {get;set;}
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
      public boolean toshowHostedPBX{get;set;}                                //HostedPBX
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
     public boolean toshowOnPremisePBX{get;set;}                              //On-premise
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
    public boolean toshowCellPhoneOnly{get;set;}                              //cell Phone Only 
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
    public boolean toshowLandline{get;set;}                                   //LandLine
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
     public boolean toshowTraditional{get;set;}                             //Traditional
     public void showTraditional() {          
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
     
 	public boolean toshowNothing{get;set;}                          
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
     
 	public List<SelectOption> getCancellationReasonOption(){
        List<SelectOption> options = getOptionList('Cancellation_Reason__c');
        return options; 
    }
    
    public List<SelectOption> getCouldnotworkingdetailOption() {
       List<SelectOption> options = getOptionList('Couldn_t_get_it_working_details__c');
       return options; 
    }
    
    public List<SelectOption> getmissingfeaturedetailOption(){
       List<SelectOption> options = getOptionList('Missing_feature_details__c'); 
       //options.sort();
       return options; 
    }
    
    public List<SelectOption> getQOsdetailOption() {                              //QoS Voice
       List<SelectOption> options = getOptionList('QoS_details__c');  
       options.sort();
       return options; 
    }
    
    public List<SelectOption> getFaxOption() {                                     //QoS Fax
       List<SelectOption> options = getOptionList('Fax__c');   
       options.sort(); 
       return options; 
    }
    
    public List<SelectOption> getWhichCXDetailOption() {
       List<SelectOption> options = getOptionList('What_will_cx_use_for_their_phone_system__c');  
       //options.sort();
       return options; 
    }
 
     public List<SelectOption> getHostedPBXOption() {                            //HostedPBX
       List<SelectOption> options = getOptionList('Hosted_PBX__c'); 
       //options.sort();
       return options; 
    }
    public List<SelectOption> getOnPremisePBXOption() {                          //On-PremisePBX
       List<SelectOption> options = getOptionList('On_Premise_PBX__c');  
       options.sort();
       return options; 
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
    
    public List<SelectOption> getCostOption() {                      	//Cost
       List<SelectOption> options = getOptionList('Cost__c');
       return options; 
    }
    
    public List<SelectOption> getNothingOption() {                      	//Nothing
       List<SelectOption> options = getOptionList('Nothing__c');
       return options; 
    }
    
    public List<SelectOption> getConsolidatingAccountOption() {               //RingCentral-Consolidating
       List<SelectOption> options = getOptionList('RingCentral_Consolidating_Account__c');
       return options; 
    }
    
    public List<SelectOption> getOptionList(string fieldApi) {                     
           List<SelectOption> options = new List<SelectOption>(); 
           try{
            Schema.sObjectType sobjectType = Cancel_Request__c.getSObjectType(); 
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



 /*  public List<SelectOption> getWhichCompanydetailOption(){
           List<SelectOption> options = new List<SelectOption>(); 
           try{
            Schema.sObjectType sobjectType = Cancel_Request__c.getSObjectType(); 
            Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe(); 
            Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap(); 
            List<Schema.PicklistEntry> pickListValues = fieldMap.get('Which_company__c').getDescribe().getPickListValues(); 
            for (Schema.PicklistEntry picklstval : pickListValues) { 
                options.add(new selectOption(picklstval.getvalue(), picklstval.getvalue())); 
            }
        } catch(Exception ex) { }
       
       return options; 
    }*/
    
    
      
   /* public String getCompanyPicListValue(){
        String strPram='';
          for(String str:lstsectedCompanyDetaildetail){
              if(strPram==''){
                        strPram=str;
                    }else{
                        strPram=strPram+'&00NQ00000018G4L='+str;
                    }
            }  
            return strPram;
    }*/