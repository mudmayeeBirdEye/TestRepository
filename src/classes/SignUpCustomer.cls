public class SignUpCustomer {
 	String IEE = Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');// For IE9 
    public List<Id> finalList{get;set;}
    public Map<String, List<SelectOption>> currentMainServiceMap{get;set;}
    public Map<String, List<SelectOption>> retiredMainServiceMap{get;set;}
    public Map<String, Offer_Id__c> pidMap {get;set;}
    public Map<Id, SignUpLink__c> completeMainServicesMap{get;set;}
    public String ServiceValueTemp {get;set;}
    public String strUrlQueryString {get;set;}
    public String selectedMainService{get;set;}
     
    List<String> serviceValue;
    Map<Id,SignUpLink__c > serviceValueMaster;
    Map<String, String> CurrencyMap = new Map<String, String>{ 'US' => 'US', 'UK' => 'UK','CAN'=>'CAN'}; 
   
    public String selectedValueOffering;
    private final Opportunity opp;
    private String tabName = 'US';
    
    public boolean toShowSignUpPanel {get;set;}
    public string selectedPaymentMethod {get;set;}
    
    final string STR_CREDITCARD = 'CC';
    final string STR_INVOICE = 'INV';
    string billtype = STR_CREDITCARD;
    
    Campaign c;
    String BMID = '';
    String PID = '';
    String AID = '';
    String SPID;
    String SID = '';
    String promotion = '';
    String SAFID ='';
    String PartnerID ='';
    String strUrl;
    String strSignUpId;
    String strRedenderdValue;
  
    SignUpLink__c signUp = new SignUpLink__c();
    List<SignUpLink__c> signUpList;
    List<SignUpLink__c> partnerOffer;
    
    /*
    Find user SPID and information from the originatiing Opportunity.
    Determine is native Opportunity fields can be used for attribution if not then use campaignId passed from lead convert.
    */
    public boolean isPartnerUserPro {get;set;}
    public boolean isAdminOrNonPartnerPro {get;set;}
    public string oppBrandName {get;set;}
    public SignUpCustomer(ApexPages.StandardController controller){
 		toShowSignUpPanel = false;
 		isPartnerUserPro = false;
 		isAdminOrNonPartnerPro = false;	
     	serviceValueMaster = new Map<Id,SignUpLink__c>();
     	setUserProfileBasedVar();
       //SPID = [SELECT PID__c FROM User WHERE Id =: UserInfo.getUserId()].PID__c;
        
        opp = [select id, name, StageName, brand_name__c, tier_name__c, pid__c,ad__c,adgrpid__c,afn__c,aid__c,bmid__c,kid__c,oid__c,
                product__c,rckw__c,rcmt__c,sid__c,CampaignId, Partner_ID__c,AccountId,Account.Payment_Method__c,
                 Account.PID__c, Account.BMID__c, Account.AID__c,Account.Sid__c,
                (SELECT Status__c FROM Approvals__r where Status__c = 'Completed' and RecordType.Name = 'Invoicing Request' limit 1),
                (select Id from Quotes where status = 'Active' limit 1)
                from Opportunity where 
                id = :ApexPages.currentPage().getParameters().get('id')];
        system.debug('this is Att from OPP: ' + opp.BMID__c + '/' + opp.PID__c + '/' + opp.AID__c);
        if(opp != null && opp.Approvals__r != null && opp.Approvals__r.size() >0 && !string.isBlank(opp.Account.Payment_Method__c)) {
       		toShowSignUpPanel = true;
       		selectedPaymentMethod = STR_INVOICE;
     	}
     	if(opp != null) {
     		oppBrandName = opp.brand_name__c == null ? 'RingCentral': opp.brand_name__c;
     	}
     	
     	if(Userinfo.getUserType() == 'PowerPartner') {
     		User userObj = [SELECT contact.Account.Partner_ID__c,contact.Account.PID__c,contact.Account.AID__c,contact.Account.SID__c,
     						contact.Account.BMID__c 	 
     						FROM User WHERE Id =: UserInfo.getUserId()];
     		if(userObj != null) {
     			PartnerID = userObj.contact.Account.Partner_ID__c;
     			PID = userObj.contact.Account.PID__c;
     			BMID = userObj.contact.Account.BMID__c;
     			AID = userObj.contact.Account.AID__c;
     			SID = userObj.contact.Account.SID__c;
     		}
     	} else if(opp.Partner_ID__c != NULL) {
     		System.Debug('>>2>23>' + opp.Partner_ID__c);
     		List<Account> partnerAccDetObj = [select PID__c,BMID__c,AID__c,SID__c from account where Partner_ID__c = :opp.Partner_ID__c
     											and RecordType.Name = 'Partner Account' limit 1];
     		if(partnerAccDetObj != null && partnerAccDetObj.size() == 1) {
     			PartnerID = opp.Partner_ID__c;
     			PID = partnerAccDetObj[0].PID__c;
     			BMID = partnerAccDetObj[0].BMID__c;
     			AID = partnerAccDetObj[0].AID__c;
     			SID = partnerAccDetObj[0].SID__c;
     		}									
     	}
     	
       	/*Add PartnerID*/
        /*if(opp.Partner_ID__c != NULL) {
        	PartnerID = opp.Partner_ID__c;
        }
        if(opp.Account.PID__c != null) {
            PID = opp.Account.PID__c;
        } 
        if(opp.Account.BMID__c != null) {
            BMID = opp.Account.BMID__c;
        } 
        if(opp.Account.AID__c != null) {
            AID = opp.Account.AID__c;
        } 
        if(opp.Account.Sid__c != null) {
            SID = opp.Account.Sid__c;
        }*/       
        /*if(Opp.PID__c != null){
            //system.debug('PID IS NOT null');
        }
        if(Opp.PID__c != ''){
            //system.debug('PID IS NOT EMPTY');
        }
        // Check Opp fields to see if we can use for attribution
        if((opp.BMID__c != null && opp.BMID__c != '') && (opp.PID__c != null && opp.PID__c != '')){
            // all attribution fields are filled in
            BMID = opp.BMID__c;
            PID = opp.PID__c;
            AID = opp.AID__c;
            //system.debug('this is Att1: This is BMID/PID/AID: ' + BMID + '/' + PID + '/' + AID);
        }
        else if((opp.BMID__c != null && opp.BMID__c != '') && (opp.PID__c == null || opp.PID__c == '')){
            // only BMID field is filled in
            BMID = opp.BMID__c;
            PID = opp.PID__c;
            AID = opp.AID__c;
            //system.debug('this is Att2: This is BMID/PID/AID: ' + BMID + '/' + PID + '/' + AID);
        }
        else if((opp.BMID__c == null || opp.BMID__c == '') && (opp.PID__c != null && opp.PID__c != '')){
            // only PID field is filled in
            BMID = opp.PID__c;
            PID = '';
            AID = opp.AID__c;
            //system.debug('this is Att3: This is BMID/PID/AID: ' + BMID + '/' + PID + '/' + AID);
        }
        // even if AID has a value RC will not use it for attribution so skip to checking for campaign attribution
        else if(opp.CampaignId != null){
            // use campaign from primary campaign source field
            try{
                c = [SELECT Name,DNIS__c,AID__c,PID__c,BMID__c FROM Campaign WHERE id=:opp.CampaignId];
                system.debug('this is campaign name: ' + c.name + '. This is BMID/PID/AID: ' + c.BMID__c + '/' + c.PID__c + '/' + c.AID__c);
                
                if(c.BMID__c == null || c.BMID__c == ''){
                    if(c.PID__c == null || c.PID__c == ''){
                        BMID = '';
                        PID = '';      
                    }
                    else {
                        BMID = c.PID__c;
                        PID = c.PID__c;                 
                    }
                }
                else{
                    BMID = c.BMID__c;
                    
                    if(c.PID__c == null || c.PID__c == ''){
                        PID = '';
                    }
                    else{
                        PID = c.PID__c;
                    }
                }
                AID = c.AID__C;                       
                //system.debug('THIS IS BMID/PID/AID from campaign: ' + BMID + '/' + PID + '/' + AID);        
            }
            catch(System.Exception e){
                // could not find campaign based on ID      
            }
        }
        if(AID == null){
            AID = '';
        }*/
        if(!string.isBlank(opp.Account.Payment_Method__c) && opp.Account.Payment_Method__c == 'Invoice') {
             billtype = STR_INVOICE;
        }
        getCompleteMainServices();
     	prepareCurrentTabService();
        strRedenderdValue = 'false';
        setSelectTrial('30');
        SelectedValue = '';
    }
    
    public void setUserProfileBasedVar() {
    	try {
    		Profile profObj = [select Name from Profile where ID = :userInfo.getProfileId()]; 
	     	Map<string, PartnerSignUpProfile__c> customSettingPartnerProMap = PartnerSignUpProfile__c.getAll();
	     	Map<string, PartnerSignUpProfileAdmin__c> customSettingAdminProMap = PartnerSignUpProfileAdmin__c.getAll();
	     	System.Debug('>>customSettingAdminProMap>>'+ customSettingAdminProMap);
	     	System.Debug('>>profObj.Name>>'+ profObj.Name);
	     	if(customSettingPartnerProMap != null && profObj.Name != null && customSettingPartnerProMap.containskey(profObj.Name)) {
	     		isPartnerUserPro = true;
	     	} 
	     	if(customSettingAdminProMap != null && customSettingAdminProMap.containskey(profObj.Name)) {
	     		isAdminOrNonPartnerPro = true;
	     	}	
    	} catch(Exception ex) {}
    }
    
    public void setTabName(String n) {
       setSelectedValue(''); 
       selectPartnerOffer = null;
       selectedValueOffering = null;
       selectedValueRetired = null;
       strRedenderdValue = 'false';
       strUrl = null;
       tabName = n;
    }
            
    public String getTabName() {
      return tabName;
    }

    /*public void getCompleteMainServices() {
        finalList = new List<Id>();
        completeMainServicesMap = new Map<Id, SignUpLink__c>();
        for(SignUpLink__c signUpObj: [SELECT Id, Name,List_Order__c, SignUpURL__c, SAFID__c, CurrencyType__c , Status__c 
        		FROM SignUpLink__c WHERE Status__c != 'End-of-Life' AND SignUp_Link_Type__c includes ('Partner') 
        		ORDER BY List_Order__c ASC]) {
            completeMainServicesMap.put(signUpObj.Id, signUpObj);
         	serviceValueMaster.put(signUpObj.Id, signUpObj); 
            finalList.add(signUpObj.Id);
        }
    }*/
    
    public void getCompleteMainServices() {
        finalList = new List<Id>();
        completeMainServicesMap = new Map<Id, SignUpLink__c>();
        List<SignUpLink__c> lstSignUpLinks = new List<SignUpLink__c>();
        //System.debug('>>332323>>'+ opp);
        if(opp != null && opp.quotes != null && opp.quotes.size()>0) {
        	lstSignUpLinks = [SELECT Id, Name,List_Order__c, SignUpURL__c, SAFID__c, CurrencyType__c , Status__c 
        						FROM SignUpLink__c WHERE Status__c != 'End-of-Life' AND SignUp_Link_Type__c includes ('Partner') 
        						ORDER BY List_Order__c ASC];
        } else {
        	lstSignUpLinks = [SELECT Id, Name,List_Order__c, SignUpURL__c, SAFID__c, CurrencyType__c , Status__c 
        						FROM SignUpLink__c WHERE Status__c != 'End-of-Life' AND SignUp_Link_Type__c includes ('Partner') AND
        						SignUpType__c != 'Contract'
        						ORDER BY List_Order__c ASC];
        }
        for(SignUpLink__c signUpObj: lstSignUpLinks) {
            completeMainServicesMap.put(signUpObj.Id, signUpObj);
         	serviceValueMaster.put(signUpObj.Id, signUpObj); 
            finalList.add(signUpObj.Id);
        }
    }
    
    public void prepareCurrentTabService() {
   		currentMainServiceMap = new Map<String, List<SelectOption>>();
   		retiredMainServiceMap = new Map<String, List<SelectOption>>();
    	for(Id key : finalList) {
            SignUpLink__c signUpObj = completeMainServicesMap.get(key);
            String currencyType = signUpObj.CurrencyType__c;
            currencyType = (currencyType == null || currencyType == '' ? 'US' : currencyType);
            for(String currencyKey : CurrencyMap.keySet()) {
                if(currentMainServiceMap == null)
                    currentMainServiceMap.put(currencyKey, new List<SelectOption>());
                //if(retiredMainServiceMap == null)                   
                    //retiredMainServiceMap.put(currencyKey, new List<SelectOption>());
                if(currencyType.startsWith(currencyKey)) { 		// for coding purpose name is considered in coding
                	if((signUpObj.Status__c == null || signUpObj.Status__c == '') || signUpObj.Status__c.equalsIgnoreCase('Current')){
                		List<SelectOption> currentMainService = currentMainServiceMap.get(currencyKey);
                        if(currentMainService == null) {
                            currentMainService = new List<SelectOption>();
                        }
                        currentMainService.add(new SelectOption(signUpObj.Id, signUpObj.Name));
                        currentMainServiceMap.put(currencyKey, currentMainService);
                	}
                    
                    /*if((signUpObj.Status__c == null || signUpObj.Status__c == '') || signUpObj.Status__c.equalsIgnoreCase('Current')){
                        List<SelectOption> currentMainService = currentMainServiceMap.get(currencyKey);
                        if(currentMainService == null) {
                            currentMainService = new List<SelectOption>();
                        }
                        currentMainService.add(new SelectOption(signUpObj.Id, signUpObj.Name));
                        currentMainServiceMap.put(currencyKey, currentMainService);
                    } else if(signUpObj.Status__c.equalsIgnoreCase('Retired')){
                        List<SelectOption> retiredMainService = retiredMainServiceMap.get(currencyKey);
                        if(retiredMainService == null) {
                            retiredMainService = new List<SelectOption>();
                        }
                        retiredMainService.add(new SelectOption(signUpObj.Id, signUpObj.Name));
                        retiredMainServiceMap.put(currencyKey, retiredMainService);
                    }*/
                }
            }
        }
    }

   	public String getSelectedValueOffering(){
   		return selectedValueOffering;
   	}
   	
   	public void setSelectedValueOffering(String selectedValueOffering){
   		this.selectedValueOffering = selectedValueOffering;
   	}
   
   	public String selectedValueRetired;
   	public String getSelectedValueRetired(){
   		return selectedValueRetired;
   	}
   	public void setSelectedValueRetired(String selectedValueRetired){
   		this.selectedValueRetired = selectedValueRetired;
   	}
    
  
    public String getStrRedenderdValue() {
        return strRedenderdValue;
    }
    
    public void setStrRedenderdValue(String strRedenderdValue) {
        this.strRedenderdValue= strRedenderdValue;
    }
    //End Code added by India Team
    
 	public String getBillType() {
        return billtype;
    }
    
    public String getPartnerID(){
        return PartnerID;
    }
    public String getBMID(){
        return BMID;
    } 
    public void setBMID(string BMID){
       this.BMID = BMID;
    }  
    
    public String getAID(){
        return AID;
    }  
    public void setAID(string AID){
       this.AID = AID;
    }       
    
    public String getPID(){
        return PID;
    }
    
    public void setPID(string PID){
       this.PID = PID;
    } 
    
    public String getSID(){
        return SID;
    }
    
    public void setSID(string SID){
       this.SID = SID;
    }    
    
    public String getSPID(){
        return (SPID == null ? '' : SPID);
    }
    
    public String getPromotion(){
        return promotion;
    }
    
    public String getOPPID(){
        return opp.Id;
    } 
      
    public String getSAFID(){
        return SAFID;
    } 
    
    public Boolean getIsNotAvailable(){
        if(!OpportunityHelper.isClosedOpp(opp.StageName) && !OpportunityHelper.isActiveOpp(opp.StageName)){
            return true;
        } 
        return false;
    }
    
    //Code Added by India Team

    public String getStrUrl() {
        return strUrl;
    }
    
    public void setStrUrl(String strUrl) {
        this.strUrl= strUrl;
    }
    
    String selectTrial;
    public String getSelectTrial() {
        return selectTrial;
    }
    
    public void setSelectTrial(String selectTrial) {
        this.selectTrial= selectTrial;
    }
    
   	String selectedValue; 
    public String getSelectedValue() {
        return selectedValue;
    }
    
    public void setSelectedValue(String selectedValue) {
        this.selectedValue= selectedValue;
    }
     
    String strImageUrl;
    public String getStrImageUrl() {
        return strImageUrl;
    }
    
    public void setStrImageUrl(String strImageUrl) {
        this.strImageUrl= strImageUrl;
    }
    
    String selectPartnerOffer;
    public String getSelectPartnerOffer() {
        return selectPartnerOffer;
    }
    
    public void setSelectPartnerOffer(String selectPartnerOffer) {
        this.selectPartnerOffer= selectPartnerOffer;
    }
    
    Boolean blnSignUpType;
    public Boolean getBlnSignUpType() {
        return blnSignUpType;
    }
    
    public void setBlnSignUpType(Boolean blnSignUpType) {
        this.blnSignUpType= blnSignUpType;
    }
    
    public List<SelectOption> getServiceItemsOfferingUS() {
             return currentMainServiceMap.get('US');
    }
    
    public List<SelectOption> getServiceItemsRetiredUS() {
          return retiredMainServiceMap.get('US');
    }

    public List<SelectOption> getServiceItemsOfferingCAN() {
           return currentMainServiceMap.get('CAN');
    }
    
    public List<SelectOption> getServiceItemsRetiredCAN() {
          return retiredMainServiceMap.get('CAN');
    }
     
    public List<SelectOption> getServiceItemsOfferingUK() {
           return currentMainServiceMap.get('UK');
    }
    
    public List<SelectOption> getServiceItemsRetiredUK() {
           return retiredMainServiceMap.get('UK');
    }

    // Added by India Team
 	public List<SignUpLink__c>  getPartnerOffer(){
       List<String> options = new List<String>();
       signUpList = [SELECT Name  FROM SignUpLink__c  where SignType__c = 0 ORDER BY List_Order__c ASC];
       return signUpList;
 	}
     
     // Added by India Team
 	public List<SelectOption>  getTrialItems(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('7D','7D Trial')); 
       options.add(new SelectOption('30D','30D Trial'));     
       options.add(new SelectOption('30','Buy Now')); 
       return options;
 	}
     
 	public List<SelectOption> getPaymentItems(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(STR_INVOICE,'Invoice'));     
       options.add(new SelectOption(STR_CREDITCARD,'Credit Card')); 
       return options;
 	}
    
    // Added by India Team
	public List<SelectOption> getPartnerOfferItems() {
    	List<SelectOption> options = new List<SelectOption>();
    	partnerOffer =  getPartnerOffer();
   		for(SignUpLink__c partOffer : partnerOffer){
       		serviceValueMaster.put( partOffer.id , partOffer);
       		options.add(new SelectOption(partOffer.id , partOffer.Name)); 
       	}
   		return options;
	} 
    
    public PageReference doSearch() { 
        promotionsList = getPromotionItems();
        return null;
    }

    public String getStrSignUpId() {
        return strSignUpId;
    }
    
    public void setStrSignUpId(String strSignUpId) {
        this.strSignUpId= strSignUpId;
    }
    
    string strBillingFreq;
    public List<SelectOption> promotionsList{get;set;}
    public string serviceValueIndex {get;set;}
    public List<SelectOption> getPromotionItems() {
    	List<SelectOption> options = new List<SelectOption>();
    	try {
	    	serviceValueIndex = '';
	        List<Offer_Id__c> offerData = new  List<Offer_Id__c>();
	        pidMap = new Map<String, Offer_Id__c>(); 
	        ServiceValueTemp = '';
	        
	       if(getSelectedValue()!= null && getSelectedValue()!=''){
	            ServiceValueTemp = getSelectedValue();
	            blnSignUpType = true;
	        } else if(getSelectPartnerOffer()!= null){
	            ServiceValueTemp = getSelectPartnerOffer();
	            blnSignUpType = false;
	        } else if(selectedValueOffering != null){
	            ServiceValueTemp = selectedValueOffering;
	            blnSignUpType = true;
	        } else  if(selectedValueRetired != null){
	            ServiceValueTemp = selectedValueRetired;
	            blnSignUpType = true;
	        }
	        strRedenderdValue = 'true';
	        strImageUrl = '';
	        if(ServiceValueTemp !='' && ServiceValueTemp != null && serviceValueMaster.get(ServiceValueTemp).Name.indexOf('Fax') > 0 ){
	            strImageUrl = '/servlet/servlet.FileDownload?file=01580000000pYrP';
	            serviceValueIndex = 'FAX';
	        }
	        if(ServiceValueTemp !='' && ServiceValueTemp != null && serviceValueMaster.get(ServiceValueTemp).Name.indexOf('Mobile') > 0 ){
	            strImageUrl = '/servlet/servlet.FileDownload?file=01580000000pYrQ';
	            serviceValueIndex = 'Mobile';
	        }
	        if(ServiceValueTemp !='' && ServiceValueTemp != null && serviceValueMaster.get(ServiceValueTemp).Name.indexOf('Office') > 0){
	            strImageUrl = '/servlet/servlet.FileDownload?file=01580000000pYrR';
	            serviceValueIndex = 'Office';
	        }
	     	if( ServiceValueTemp != NULL && ServiceValueTemp != ''){
	        	String STRTEST = 'SELECT Name,Promotion_Name__c, Description__c, OID__c, Tier_Type__c, Number_of_Lines__c  from Offer_Id__c ';
	       		STRTEST += ' where ProductName__c = '+ '\''+  ServiceValueTemp +'\''; 
	            List<SignUpLink__c> signUpListUrl = [SELECT id , SignUpURL__c, SAFID__c, Billing_Frequency__c  
	            											FROM SignUpLink__c where ID = :ServiceValueTemp ]; 
	            if(signUpListUrl!=null && signUpListUrl.size()>0){
	                strUrl = signUpListUrl.get(0).SignUpURL__c; 
	                strSignUpId = signUpListUrl.get(0).id;
	                strBillingFreq = signUpListUrl.get(0).Billing_Frequency__c;
	                if(signUpListUrl.get(0).SAFID__c != null){
	                    SAFID = signUpListUrl.get(0).SAFID__c;
	                    System.debug('----------->'+ SAFID);
	                } 
	            }
	         	STRTEST += ' ORDER BY List_Order__c ASC NULLS last';
	            try	{
	                offerData = Database.query(STRTEST);
	            } catch(exception ex){} 
	        }
	         
	        if(offerData!= null && offerData.size()>0){
	           for(Integer counter=0;counter<offerData.size();counter++) {
	                    pidMap.put(offerData.get(counter).Name, offerData.get(counter));
	                    options.add(new SelectOption(offerData.get(counter).Name,
	                    offerData.get(counter).Description__c
	                   /* +'(Name = '+offerData.get(counter).Promotion_Name__c
	                    +', OID='+(offerData.get(counter).OID__C == null ? '' : offerData.get(counter).OID__C)
	                    +', Tier Type='+(offerData.get(counter).Tier_Type__c == null ? '' : ''+Integer.valueOf(''+offerData.get(counter).Tier_Type__c))
	                    +')'*/
	                    ));  
	           }
	       }
   		} catch(Exception ex) {}
      return options;
    }
 	
 	public String createParam(String strUrlQueryString, String inputParam, String inputValue) {
        if((inputValue != null && inputValue.trim().length() != 0) || (inputParam == 'SPID')) {
            return (strUrlQueryString != null & strUrlQueryString.indexOf('?') != -1 ? '&' : '?') + inputParam + inputValue;
        }
        return '';
    }
   	
   	public String selectedPromotion{get;set;}
    // Added by India Team
    public PageReference doSAve() {
      	String strMainServiceUrl = getStrUrl();
   		strUrlQueryString = '';
   		if(selectTrial != null && toShowSignUpPanel == true && (selectTrial.equals('30D') || selectTrial.equals('7D'))
   				&& isAdminOrNonPartnerPro) {
      		selectedPaymentMethod = STR_CREDITCARD;			
  		}
        if(blnSignUpType != null && blnSignUpType == true) {
            if(getSelectTrial().equals('30D')){
                strUrlQueryString += '?action=trial30';
            }
         	strUrlQueryString += createParam(strUrlQueryString, 'BMID=', getBMID());
         	strUrlQueryString += createParam(strUrlQueryString, 'PID=' , getPID());
         	strUrlQueryString += createParam(strUrlQueryString, 'AID=' , getAID());
         	strUrlQueryString += createParam(strUrlQueryString, 'SPID=' , getSPID());
         	strUrlQueryString += createParam(strUrlQueryString, 'SID=' , getSID());
         	strUrlQueryString += createParam(strUrlQueryString, 'OPPID=' ,getOPPID());
         	strUrlQueryString += createParam(strUrlQueryString, 'PartnerID=' ,getPartnerID());
         	strUrlQueryString += createParam(strUrlQueryString, 'Brand=' ,oppBrandName);
         	strUrlQueryString += createParam(strUrlQueryString, 'CID=' ,'reseller');
         	if(isAdminOrNonPartnerPro) {
         		strUrlQueryString += createParam(strUrlQueryString, 'billtype=' ,selectedPaymentMethod); 
            	if(!String.isBlank(strBillingFreq) && strBillingFreq == 'Annual') {
  					strUrlQueryString += createParam(strUrlQueryString, 'annual=' ,'true'); 
          		}
         	}
            if(selectedPromotion != null) {
                if(pidMap != null) {
                    strUrlQueryString+= createParam(strUrlQueryString,'OID=', pidMap.get(selectedPromotion).OID__C);
                    strUrlQueryString+= createParam(strUrlQueryString,'TierType=', (pidMap.get(selectedPromotion).Tier_Type__c == null ? '' : '' + Integer.valueOf(''+pidMap.get(selectedPromotion).Tier_Type__c)) );
                    strUrlQueryString+= createParam(strUrlQueryString,'sa_lines=', (pidMap.get(selectedPromotion).Number_of_Lines__c == null ? '' : '' + Integer.valueOf(''+pidMap.get(selectedPromotion).Number_of_Lines__c)) );
                }
        	}
        	if(selectedValueOffering != null && completeMainServicesMap!= null && completeMainServicesMap.get(selectedValueOffering)!= null && 
      			completeMainServicesMap.get(selectedValueOffering).Name != null && 
      			completeMainServicesMap.get(selectedValueOffering).Name.containsIgnoreCase('Contract')) { 
      			strUrlQueryString += createParam(strUrlQueryString, 'contract=' ,'true');
      		}
      		/*if(selectedValueRetired != null && completeMainServicesMap!= null && completeMainServicesMap.get(selectedValueRetired)!= null && 
      			completeMainServicesMap.get(selectedValueRetired).Name != null && 
      			completeMainServicesMap.get(selectedValueRetired).Name.containsIgnoreCase('Contract')) { 
      			strUrlQueryString += createParam(strUrlQueryString, 'contract=' ,'true');
      		}*/
        } /*else {
            strUrlQueryString+= createParam(strUrlQueryString,'OPPID=', getOPPID());
            strUrlQueryString+= createParam(strUrlQueryString,'SPID=', getSPID());
            strUrlQueryString+= createParam(strUrlQueryString, 'PartnerID=' ,getPartnerID());
            // strUrlQueryString += '&OPPID='+getOPPID()+'&SPID='+getSPID();
            strUrlQueryString += createParam(strUrlQueryString, 'billtype=' ,selectedPaymentMethod);
            if(!String.isBlank(strBillingFreq) && strBillingFreq == 'Annual') {
  				 strUrlQueryString += createParam(strUrlQueryString, 'annual=' ,'true'); 
          	} 
          	if(selectedValueOffering != null && completeMainServicesMap!= null && completeMainServicesMap.get(selectedValueOffering)!= null && 
      			completeMainServicesMap.get(selectedValueOffering).Name != null && 
      			completeMainServicesMap.get(selectedValueOffering).Name.containsIgnoreCase('Contract')) { 
      			strUrlQueryString += createParam(strUrlQueryString, 'contract=' ,'true');
      		}
      		if(selectedValueRetired != null && completeMainServicesMap!= null && completeMainServicesMap.get(selectedValueRetired)!= null && 
      			completeMainServicesMap.get(selectedValueRetired).Name != null && 
      			completeMainServicesMap.get(selectedValueRetired).Name.containsIgnoreCase('Contract')) { 
      			strUrlQueryString += createParam(strUrlQueryString, 'contract=' ,'true');
      		}
        }*/
        if(getSAFID() != NULL && getSAFID() != '') {
            System.debug('----------->'+ SAFID);
            strUrlQueryString+= createParam(strUrlQueryString,'SAFID=',getSAFID());
            //strUrlQueryString+= createParam(strUrlQueryString, 'PartnerID=' ,getPartnerID());
        }
        String strHardCodeUrl = 'http://www.ringcentral.com/salesforce_redirect.html?redir=';
        PageReference opptyPage = new PageReference(strHardCodeUrl+strMainServiceUrl+strUrlQueryString);
        
        System.debug('#############################'+strUrlQueryString);
        System.debug('############################'+opptyPage.getUrl());
        System.debug('############################'+getPartnerID());
        
        strUrlQueryString = strHardCodeUrl+strMainServiceUrl+strUrlQueryString;
        try {
	        SignupHistory__c insertUser = new SignupHistory__c();
	        String userNm = UserInfo.getUserId();
	        User activeUser = [Select Email From User where id = :userNm];
	        String userEmail = '';
	        if(activeUser!=null && activeUser.Email!=null) {
	            userEmail = activeUser.Email;
	        }
	        insertUser.UserEmail__c = userEmail;
	        insertUser.SignUpLink__c = strMainServiceUrl+strUrlQueryString;
	        insertUser.LaunchDate__c = Date.today();
	        insertUser.Opportunity__c = getOPPID();
	       	insert insertUser;
        } catch(Exception e) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString() )); }
  		//   catch(Exception e) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString() ));  
   		opptyPage.setRedirect(true);
  		return opptyPage;
 		//return null;
	}
   	
   	public PageReference resetAll(){
 		return null;
   	}
   	
   	public PageReference selectTab() {
   		return null;
    }
}