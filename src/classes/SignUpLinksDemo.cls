public class SignUpLinksDemo {
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
    String promotion = '';
    String SAFID ='';
    String PartnerID ='';
    String strUrl;
    String strSignUpId;
    String strRedenderdValue;
  
    SignUpLink__c signUp = new SignUpLink__c();
    List<SignUpLink__c> signUpList;
    List<SignUpLink__c> partnerOffer;
    
    
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
        for(SignUpLink__c signUpObj: [SELECT Id, Name,List_Order__c, SignUpURL__c, SAFID__c, CurrencyType__c , 
        								Status__c FROM SignUpLink__c WHERE SignType__c = 1 AND Status__c != 'End-of-Life'
        								AND SignUp_Link_Type__c includes ('Customer')  
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
        //System.debug('>>332323>>'+ opp.quotes);
        if(opp != null && opp.quotes != null && opp.quotes.size()>0) {
        	lstSignUpLinks = [SELECT Id, Name,List_Order__c, SignUpURL__c, SAFID__c, CurrencyType__c , Status__c 
        						FROM SignUpLink__c WHERE SignType__c = 1 AND Status__c != 'End-of-Life' AND SignUp_Link_Type__c includes ('Customer') 
        						ORDER BY List_Order__c ASC];
        } else {
        	lstSignUpLinks = [SELECT Id, Name,List_Order__c, SignUpURL__c, SAFID__c, CurrencyType__c , Status__c 
        						FROM SignUpLink__c WHERE SignType__c = 1 AND Status__c != 'End-of-Life' AND SignUp_Link_Type__c 
        						includes ('Customer') AND SignUpType__c != 'Contract'
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
                if(retiredMainServiceMap == null)                   
                    retiredMainServiceMap.put(currencyKey, new List<SelectOption>());
//                if(signUpObj.Name.startsWith(currencyKey)){
                if(currencyType.startsWith(currencyKey)){ // for coding purpose name is considered in coding
                    if((signUpObj.Status__c == null || signUpObj.Status__c == '') || signUpObj.Status__c.equalsIgnoreCase('Current')){
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
                    }
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
    
    /*
    Find user SPID and information from the originatiing Opportunity.
    Determine is native Opportunity fields can be used for attribution if not then use campaignId passed from lead convert.
    */
    public SignUpLinksDemo(ApexPages.StandardController controller){
 		toShowSignUpPanel = false;	
     	serviceValueMaster = new Map<Id,SignUpLink__c>();
     //	Code added by India Team
        strRedenderdValue = 'false';
        setSelectTrial('30');
        SelectedValue = '';
    //	End Code added by India Team       
        
        SPID = [SELECT PID__c FROM User WHERE Id =: UserInfo.getUserId()].PID__c;
        opp = [select id, name, StageName, brand_name__c, tier_name__c, pid__c,ad__c,adgrpid__c,afn__c,aid__c,bmid__c,kid__c,oid__c,
                product__c,rckw__c,rcmt__c,sid__c,CampaignId, Partner_ID__c,AccountId,Account.Payment_Method__c, Account.Number_of_POC_Users__c,
                (SELECT Status__c FROM Approvals__r where Status__c = 'Completed' and RecordType.Name = 'Invoicing Request' limit 1),
                (select Id from Quotes where status = 'Active' limit 1)
                from Opportunity where 
                id = :ApexPages.currentPage().getParameters().get('id')];
        system.debug('this is Att from OPP: ' + opp.BMID__c + '/' + opp.PID__c + '/' + opp.AID__c);
        if(opp != null && opp.Approvals__r != null && opp.Approvals__r.size() >0 && !string.isBlank(opp.Account.Payment_Method__c)) {
       		toShowSignUpPanel = true;
       		selectedPaymentMethod = STR_INVOICE;
     	}
       /*Add PartnerID*/
        if(opp.Partner_ID__c != NULL) {
        PartnerID = opp.Partner_ID__c;
        }       
        if(Opp.PID__c != null){
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
        }
        
        if(!string.isBlank(opp.Account.Payment_Method__c) && opp.Account.Payment_Method__c == 'Invoice') {
             billtype = STR_INVOICE;
        }
     // prepareServiceList();
     	getCompleteMainServices();
     	prepareCurrentTabService();  
    }
    
 	public String getBillType() {
        return billtype;
    }
    
    public String getPartnerID(){
        return PartnerID;
    }
    public String getBMID(){
        return BMID;
    }   
    
    public String getAID(){
        return AID;
    }       
    
    public String getPID(){
        return PID;
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
    
   /* String selectPromotions;
    public String getSelectPromotions() {
        return selectPromotions;
    }
    
    public void setSelectPromotions(String selectPromotions) {
        this.selectPromotions= selectPromotions;
    }*/
    
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
       	if(opp.Account.Number_of_POC_Users__c != null && opp.Account.Number_of_POC_Users__c != 0){ 
			options.add(new SelectOption('trial30nocc','POC Account')); 
       	}   
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
            
       for(SignUpLink__c partOffer : partnerOffer ){
           serviceValueMaster.put( partOffer.id , partOffer );
           options.add(new SelectOption(partOffer.id , partOffer.Name)); 
       }
       return options;
    } 
    
    public PageReference doSearch()
    { 
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
    public List<SelectOption> getPromotionItems() {
        List<Offer_Id__c> offerData = new  List<Offer_Id__c>();
        pidMap = new Map<String, Offer_Id__c>();
        List<SelectOption> options = new List<SelectOption>();
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
        
        //String SelectTrialTemp = getSelectTrial();
        //System.Debug('---'+SelectTrialTemp);
        strRedenderdValue = 'true';
        strImageUrl = '';
        if(ServiceValueTemp !='' && ServiceValueTemp != null && serviceValueMaster.get(ServiceValueTemp).Name.indexOf('Fax') > 0 ){
            strImageUrl = '/servlet/servlet.FileDownload?file=01580000000pYrP';
        }
        if(ServiceValueTemp !='' && ServiceValueTemp != null && serviceValueMaster.get(ServiceValueTemp).Name.indexOf('Mobile') > 0 ){
            strImageUrl = '/servlet/servlet.FileDownload?file=01580000000pYrQ';
        }
        if(ServiceValueTemp !='' && ServiceValueTemp != null && serviceValueMaster.get(ServiceValueTemp).Name.indexOf('Office') > 0){
            strImageUrl = '/servlet/servlet.FileDownload?file=01580000000pYrR';
        }
        // String STRTEST = 'SELECT Name,Promotion_Name__c, Description__c from Offer_Id__c ';
       //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ServiceValueTemp ));
        if( ServiceValueTemp != NULL && ServiceValueTemp != ''){
            String STRTEST = 'SELECT Name,Promotion_Name__c, Description__c, OID__c, Tier_Type__c, Number_of_Lines__c  from Offer_Id__c ';
          //  STRTEST += ' where ProductName__r.Name = :'+ serviceValueMaster.get(ServiceValueTemp).Name;
           STRTEST += ' where ProductName__c = '+ '\''+  ServiceValueTemp +'\''; 
            //;serviceValueMaster.get(ServiceValueTemp).Name; 
            
           //List<SignUpLink__c> signUpListUrl = [SELECT id,SignUpURL__c, SAFID__c  FROM SignUpLink__c where NAME = :serviceValueMaster.get(ServiceValueTemp).Name];
            //  List<SignUpLink__c> signUpListUrl = [SELECT id,SignUpURL__c, SAFID__c  FROM SignUpLink__c where Name = :ServiceValueTemp ];
            List<SignUpLink__c> signUpListUrl = [SELECT id , SignUpURL__c, SAFID__c, Billing_Frequency__c  FROM SignUpLink__c where ID = :ServiceValueTemp ];
            if(signUpListUrl!=null && signUpListUrl.size()>0){
                strUrl = signUpListUrl.get(0).SignUpURL__c; 
                strSignUpId = signUpListUrl.get(0).id;
                strBillingFreq = signUpListUrl.get(0).Billing_Frequency__c;
                if(signUpListUrl.get(0).SAFID__c != null){
                    SAFID = signUpListUrl.get(0).SAFID__c;
                    System.debug('----------->'+ SAFID);
                } 
            }
            
           // STRTEST += ' order by Promotion_Name__c';
           STRTEST += ' ORDER BY List_Order__c ASC NULLS last';
            try{
             // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, STRTEST +'-----'+ServiceValueTemp +'-------'+getSelectedValue()));
                offerData = Database.query(STRTEST);
         //     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(offerData)  ));  
            }catch(exception ex){
                
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception---------->'+ex.getMessage() ));
                //System.assert(false, STRTEST );           
            } 
        }
        //offerData = [SELECT Description__c from Offer_Id__c where ProductName__r.Name='RC OFFICE'];
        // options.add(new SelectOption('','None'));
         
        if(offerData!= null && offerData.size()>0){
           for( Integer counter=0;counter<offerData.size();counter++) {
                // options.add(new SelectOption(offerData.get(counter).Name,offerData.get(counter).Description__c+'(Name = '+offerData.get(counter).Promotion_Name__c+', OID='+offerData.get(counter).Name+')'));
                    pidMap.put(offerData.get(counter).Name, offerData.get(counter));
                    options.add(new SelectOption(offerData.get(counter).Name,
                    offerData.get(counter).Description__c
                    +'(Name = '+offerData.get(counter).Promotion_Name__c
                    +', OID='+(offerData.get(counter).OID__C == null ? '' : offerData.get(counter).OID__C)
                    +', Tier Type='+(offerData.get(counter).Tier_Type__c == null ? '' : ''+Integer.valueOf(''+offerData.get(counter).Tier_Type__c))
                    //+', Number of Lines='+(offerData.get(counter).Number_of_Lines__c == null ? '' : ''+Integer.valueOf(''+offerData.get(counter).Number_of_Lines__c))
                    +')'
                    ));  
           }
       }
       // setSelectPromotions('');
       
       /* setSelectedValue('');
        selectPartnerOffer = null;
        selectedValueOffering = null;
        selectedValueRetired = null;*/
        
       return options;
    }
     public String createParam(String strUrlQueryString, String inputParam, String inputValue) {
        if((inputValue != null && inputValue.trim().length() != 0) || (inputParam == 'SPID')) {
            return (strUrlQueryString != null & strUrlQueryString.indexOf('?') != -1 ? '&' : '?') + inputParam + inputValue;
        }
        return '';
    }
   public String selectedPromotion{get;set;}
  /* public PageReference setPromo() {
   		SelectPromotions = selectedPromotion;
   		return null;
   }*/
   
    // Added by India Team
    public PageReference doSAve() {
      	String strMainServiceUrl = getStrUrl();
   		strUrlQueryString = '';
   		if(selectTrial != null && toShowSignUpPanel == true && (selectTrial.equals('30D') || selectTrial.equals('7D'))) {
      		selectedPaymentMethod = STR_CREDITCARD;			
  		}
        if(blnSignUpType != null && blnSignUpType == true) {
            if(getSelectTrial().equals('30D')){
                strUrlQueryString += '?action=trial30';
            }
            if(getSelectTrial().equals('trial30nocc')){
            	strUrlQueryString += '?action=trial30nocc';
            }
         	strUrlQueryString += createParam(strUrlQueryString, 'BMID=', getBMID());
         	strUrlQueryString += createParam(strUrlQueryString, 'PID=' , getPID());
         	strUrlQueryString += createParam(strUrlQueryString, 'AID=' , getAID());
         	strUrlQueryString += createParam(strUrlQueryString, 'SPID=' , getSPID());
         	strUrlQueryString += createParam(strUrlQueryString, 'OPPID=' ,getOPPID());
         	strUrlQueryString += createParam(strUrlQueryString, 'PartnerID=' ,getPartnerID());
         	strUrlQueryString += createParam(strUrlQueryString, 'billtype=' ,selectedPaymentMethod); 
            if(!String.isBlank(strBillingFreq) && strBillingFreq == 'Annual') {
  				strUrlQueryString += createParam(strUrlQueryString, 'annual=' ,'true'); 
          	}
            if(selectedPromotion != null) {
                if(pidMap != null) {
                    strUrlQueryString+= createParam(strUrlQueryString,'OID=', pidMap.get(selectedPromotion).OID__C);
                    strUrlQueryString+= createParam(strUrlQueryString,'TierType=', (pidMap.get(selectedPromotion).Tier_Type__c == null ? '' : '' + Integer.valueOf(''+pidMap.get(selectedPromotion).Tier_Type__c)) );
                    strUrlQueryString+= createParam(strUrlQueryString,'sa_lines=', (pidMap.get(selectedPromotion).Number_of_Lines__c == null ? '' : '' + Integer.valueOf(''+pidMap.get(selectedPromotion).Number_of_Lines__c)) );
                }
        	}
        	if(!String.isBlank(selectedValueOffering) && completeMainServicesMap!= null && completeMainServicesMap.get(selectedValueOffering)!= null && 
      			completeMainServicesMap.get(selectedValueOffering).Name != null && 
      			completeMainServicesMap.get(selectedValueOffering).Name.containsIgnoreCase('Contract')) { 
      			strUrlQueryString += createParam(strUrlQueryString, 'contract=' ,'true');
      		}
      		if(!String.isBlank(selectedValueRetired) && completeMainServicesMap!= null && completeMainServicesMap.get(selectedValueRetired)!= null && 
      			completeMainServicesMap.get(selectedValueRetired).Name != null && 
      			completeMainServicesMap.get(selectedValueRetired).Name.containsIgnoreCase('Contract')) { 
      			strUrlQueryString += createParam(strUrlQueryString, 'contract=' ,'true');
      		}
        } else {
            strUrlQueryString+= createParam(strUrlQueryString,'OPPID=', getOPPID());
            strUrlQueryString+= createParam(strUrlQueryString,'SPID=', getSPID());
            strUrlQueryString+= createParam(strUrlQueryString, 'PartnerID=' ,getPartnerID());
            // strUrlQueryString += '&OPPID='+getOPPID()+'&SPID='+getSPID();
            strUrlQueryString += createParam(strUrlQueryString, 'billtype=' ,selectedPaymentMethod);
            if(!String.isBlank(strBillingFreq) && strBillingFreq == 'Annual') {
  				 strUrlQueryString += createParam(strUrlQueryString, 'annual=' ,'true'); 
          	} 
          	if(!string.isBlank(selectedValueOffering) && completeMainServicesMap!= null && completeMainServicesMap.get(selectedValueOffering)!= null && 
      			completeMainServicesMap.get(selectedValueOffering).Name != null && 
      			completeMainServicesMap.get(selectedValueOffering).Name.containsIgnoreCase('Contract')) { 
      			strUrlQueryString += createParam(strUrlQueryString, 'contract=' ,'true');
      		}
      		if(!string.isBlank(selectedValueRetired) && completeMainServicesMap!= null && completeMainServicesMap.get(selectedValueRetired)!= null && 
      			completeMainServicesMap.get(selectedValueRetired).Name != null && 
      			completeMainServicesMap.get(selectedValueRetired).Name.containsIgnoreCase('Contract')) { 
      			strUrlQueryString += createParam(strUrlQueryString, 'contract=' ,'true');
      		}
        }
        if(getSAFID() != NULL && getSAFID() != '') {
            System.debug('----------->'+ SAFID);
            strUrlQueryString+= createParam(strUrlQueryString,'SAFID=',getSAFID());
            strUrlQueryString+= createParam(strUrlQueryString, 'PartnerID=' ,getPartnerID());
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
        User activeUser = [Select Email From User where id = :userNm ];
        String userEmail = '';
        if(activeUser!=null && activeUser.Email!=null) {
            userEmail = activeUser.Email;
        }
        insertUser.UserEmail__c = userEmail;
        insertUser.SignUpLink__c = strMainServiceUrl+strUrlQueryString;
        insertUser.LaunchDate__c = Date.today();
        insertUser.Opportunity__c = getOPPID();
        
        //if(!Test.isRunningTest())
           insert insertUser;
        //
        } catch(Exception e) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString() )); }
  //   catch(Exception e) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString() ));  
   opptyPage.setRedirect(true);
  return opptyPage;
 //return null;
    }
   public PageReference resetAll(){
       /*setSelectedValue(''); 
       selectPartnerOffer = null;
       selectedValueOffering = null;
       selectedValueRetired = null;
       getPromotionItems();
       strRedenderdValue = 'false';*/
     return null;
   }
   public PageReference selectTab() {
           return null;
    }

	/*test Method*/
	/*@isTest(SeeAllData=true)
	static void testSignUpDemo() {
		
	try{		SignUpLink__c signUpObj1 = new SignUpLink__c(Name='Signup001 Fax',
			List_Order__c=1,
			SignUpURL__c='http://www.ringcentral.com/' ,
			SAFID__c='Signup002',
			CurrencyType__c='US' ,
			SignType__c=1,
			Status__c='Current');
			
			SignUpLink__c signUpObj2 = new SignUpLink__c(Name='Signup002 Mobile',
			List_Order__c=2,
			SignUpURL__c='http://www.ringcentral.com/' ,
			SAFID__c='Signup003',
			CurrencyType__c='CAN' ,
			SignType__c=1,
			Status__c='Retired');
			
			SignUpLink__c signUpObj3 = new SignUpLink__c(Name='Signup003 Office',
			List_Order__c=3,
			SignUpURL__c='http://www.ringcentral.com/' ,
			SAFID__c='Signup004',
			CurrencyType__c='UK' ,
			SignType__c=1,
			Status__c='Retired');
			
			SignUpLink__c signUpObj4 = new SignUpLink__c(Name='Signup004 Fax',
			List_Order__c=4,
			SignUpURL__c='http://www.ringcentral.com/' ,
			SAFID__c='Signup004',
			CurrencyType__c='UK' ,
			SignType__c=0,
			Status__c='Retired');
			
			insert signUpObj1;
			insert signUpObj2;
			insert signUpObj3;
			insert signUpObj4;
		
			Offer_Id__c offer1 = new Offer_Id__c (
			Promotion_Name__c='offer001',
			List_Order__c=1,
			Description__c='offer003',
			OID__c='offer004',
			Tier_Type__c= 1,
			ProductName__c=signUpObj1.Id);
			Offer_Id__c offer2 = new Offer_Id__c (
			Promotion_Name__c='offer002',
			List_Order__c=2,
			Description__c='offer003',
			OID__c='offer004',
			Tier_Type__c=1,
			ProductName__c=signUpObj2.Id);
			Offer_Id__c offer3 = new Offer_Id__c (
			Promotion_Name__c='offer003',
			List_Order__c=3,
			Description__c='offer003',
			OID__c='offer004',
			Tier_Type__c=1,
			ProductName__c=signUpObj3.Id);
			Offer_Id__c offer4 = new Offer_Id__c (
			Promotion_Name__c='offer004',
			List_Order__c=4,
			Description__c='offer003',
			OID__c='offer004',
			Tier_Type__c=1,
			ProductName__c=signUpObj4.Id);
			
			insert offer1;
			insert offer2;
			insert offer3;
			insert offer4;
		
		Opportunity opp0 = new Opportunity();
		/*id, name, StageName, brand_name__c, tier_name__c, pid__c,ad__c,adgrpid__c,afn__c,aid__c,bmid__c,kid__c,oid__c,
                product__c,rckw__c,rcmt__c,sid__c,CampaignId, Partner_ID__c*/
		
		/*opp0.Name ='test';
		opp0.StageName = OpportunityHelper.defaultOpportunityStage;
		opp0.CloseDate = System.today()+ 3;
		opp0.Partner_ID__c = '111';
		opp0.AID__c = '222';
		opp0.BMID__c = '333';
		opp0.PID__c ='444';
		
		insert opp0;
		
		ApexPages.currentPage().getParameters().put('id', opp0.id); 
		SignUpLinksDemo suDemo0 = new SignUpLinksDemo(null);
		suDemo0.doSAve();
		Opportunity opp1 = new Opportunity();
		/*id, name, StageName, brand_name__c, tier_name__c, pid__c,ad__c,adgrpid__c,afn__c,aid__c,bmid__c,kid__c,oid__c,
                product__c,rckw__c,rcmt__c,sid__c,CampaignId, Partner_ID__c*/
		
		/*opp1.Name ='test';
		opp1.StageName = OpportunityHelper.defaultOpportunityStage;
		opp1.CloseDate = System.today()+ 3;
		opp1.Partner_ID__c = '111';
		opp1.AID__c = '222';
		opp1.BMID__c = '333';
		opp1.PID__c ='';
		
		insert opp1;
		
		Campaign campaignObj = new Campaign(Name='TestCampaign',
		DNIS__c='Test006',
		AID__c='Test007',
		PID__c='Test008',
		BMID__c='Test009');
		insert campaignObj;
		
		
		ApexPages.currentPage().getParameters().put('id', opp1.id); 
		SignUpLinksDemo suDemo1 = new SignUpLinksDemo(null);
		suDemo1.setSelectedValue('');
		suDemo1.getTrialItems();
		suDemo1.strRedenderdValue = 'false';
		suDemo1.doSAve();
		suDemo1.setTabName('US');
		suDemo1.getTabName();*/
		
		//Opportunity opp2 = new Opportunity();
		/*id, name, StageName, brand_name__c, tier_name__c, pid__c,ad__c,adgrpid__c,afn__c,aid__c,bmid__c,kid__c,oid__c,
                product__c,rckw__c,rcmt__c,sid__c,CampaignId, Partner_ID__c*/
		
		/*opp2.Name ='test';
		opp2.StageName = OpportunityHelper.defaultOpportunityStage;
		opp2.CloseDate = System.today() + 3;
		opp2.Partner_ID__c = '111';
		opp2.AID__c = '222';
		opp2.BMID__c = '';
		opp2.PID__c ='444';
		opp2.CampaignId = campaignObj.id;
		insert opp2;
		
		ApexPages.currentPage().getParameters().put('id', opp2.id); 
		SignUpLinksDemo suDemo2 = new SignUpLinksDemo(null);
		suDemo2.strRedenderdValue = 'false';
		suDemo2.doSAve();
		suDemo2.setSelectedValueOffering(signUpObj1.id);
		suDemo2.getStrRedenderdValue();
		suDemo2.setStrRedenderdValue('false');
		suDemo2.getSelectedValueOffering();
		suDemo2.setSelectedValueRetired(signUpObj2.id);
		suDemo2.getSelectedValueRetired();
		suDemo2.getStrImageUrl();
		suDemo2.setStrImageUrl('tset');
		suDemo2.setSelectPartnerOffer(signUpObj3.id) ;
		suDemo2.getBlnSignUpType();
		suDemo2.setBlnSignUpType(true);
		suDemo2.getServiceItemsOfferingUS();
		suDemo2.getServiceItemsRetiredUS();
		suDemo2.getServiceItemsOfferingCAN();
		suDemo2.getServiceItemsRetiredCAN();
		suDemo2.getServiceItemsOfferingUK();
		suDemo2.getServiceItemsRetiredUK();
		suDemo2.getPartnerOffer();
		suDemo2.getPartnerOfferItems();
		suDemo2.getSelectTrial();
		suDemo2.getPartnerID();
		suDemo2.getBMID();
		suDemo2.getAID();
		suDemo2.getPID();
		suDemo2.getSPID();
		suDemo2.getPromotion();
		suDemo2.getOPPID();
		suDemo2.getSAFID();
		suDemo2.getIsNotAvailable();
		suDemo2.getStrUrl();
		suDemo2.setStrUrl('www.google.com');
		suDemo2.getSelectTrial();
		suDemo2.doSearch();
		suDemo2.getStrSignUpId();
		suDemo2.setStrSignUpId(signUpObj4.id);
		suDemo2.createParam('test','test','test');
		
		Campaign campaignObj2 = new Campaign(Name='TestCampaign',
		DNIS__c='Test007',
		AID__c='Test008',
		PID__c='Test009',
		BMID__c='Test090');
		
		insert campaignObj2;
		
		Opportunity opp4 = new Opportunity();
		
		opp4.Name ='test';
		opp4.StageName = OpportunityHelper.defaultOpportunityStage;
		opp4.CloseDate = System.today() + 3;*/
		/*opp4.Partner_ID__c = '';
		opp4.AID__c = '';
		opp4.BMID__c = '';
		opp4.PID__c ='';*/
		/*opp4.CampaignId = campaignObj2.id;
		insert opp4;
		
	    ApexPages.currentPage().getParameters().put('id', opp4.id); 
		SignUpLinksDemo suDemo4 = new SignUpLinksDemo(null);
	    suDemo4.SelectedValue = signUpObj1.id;
	    suDemo4.getSelectedValue();
	    suDemo4.strRedenderdValue = 'true';
	    suDemo4.doSAve();
	    suDemo4.strRedenderdValue = 'false';
	    suDemo4.doSAve();
	    suDemo4.selectTab();
	    suDemo4.resetAll();
	} catch (exception e){}
		
		//setBlnSignUpType(true);
		//setSelectedValue(signUpObj1.id);
		//setSelectedValueOffering(signUpObj2.id);
		
	}*/    
}