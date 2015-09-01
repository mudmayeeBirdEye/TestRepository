/*************************************************
SignUpLinks class
Along with SignUpLinks.page allows users to select Service based on Country and an available promotion code to signup customer.
Takes information from the Opportunity is was launched from and passes it to signup Funnel
Passing of information to funnel is important for sync'ing Account and using correct attribution information.
Advanced functions added by India team
/************************************************/

public class SignUpLinks {

 /*   public SignUpLinks(){
    }*/
    
  /*  private final Opportunity opp;
    
    Campaign c;

    String BMID = '';
    String PID = '';
    String AID = '';
    String SPID;
    String promotion = '';
    String SAFID ='';
    String PartnerID ='';
    
    //Code Added by India Team
    String strRedenderdValue;
    public String getStrRedenderdValue() {
        return strRedenderdValue;
    }
    
    public void setStrRedenderdValue(String strRedenderdValue) {
        this.strRedenderdValue= strRedenderdValue;
    }
    //End Code added by India Team*/
	
	/*
	Find user SPID and information from the originatiing Opportunity.
	Determine is native Opportunity fields can be used for attribution if not then use campaignId passed from lead convert.
	*/
   /* public SignUpLinks(ApexPages.StandardController controller){
        //Code added by India Team
        strRedenderdValue = 'false';
        setSelectTrial('7D');
        setSelectedValue('RC US Mobile'); 
        getPromotionItems(); 
        //End Code added by India Team       
        
        SPID = [SELECT PID__c FROM User WHERE Id =: UserInfo.getUserId()].PID__c;
        opp = [select id, name, StageName, brand_name__c, tier_name__c, pid__c,ad__c,adgrpid__c,afn__c,aid__c,bmid__c,kid__c,oid__c,
        		product__c,rckw__c,rcmt__c,sid__c,CampaignId, Partner_ID__c  from Opportunity where id = :ApexPages.currentPage().getParameters().get('id')];
        system.debug('this is Att from OPP: ' + opp.BMID__c + '/' + opp.PID__c + '/' + opp.AID__c);*/
       /*Add PartnerID*/
       /* if(opp.Partner_ID__c != NULL) {
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
        if(opp.StageName != '4. Closed' && opp.StageName != '3. ActivePipe'){
            return true;
        }
        return false;
    }
    
    //Code Added by India Team
    
    String strUrl;
    public String getStrUrl() {
        return strUrl;
    }
    
    public void setStrUrl(String strUrl) {
        this.strUrl= strUrl;
    }
    
    String selectPromotions;
    public String getSelectPromotions() {
        return selectPromotions;
    }
    
    public void setSelectPromotions(String selectPromotions) {
        this.selectPromotions= selectPromotions;
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
    
    
    List<String> serviceValue;
    List<String> partnerOffer;
    SignUpLink__c signUp = new SignUpLink__c();
    List<SignUpLink__c> signUpList;
    
    List<Offer_Id__c> offerData;
    
    // Added by India Team
    public List<String>  getServiceValues(){
       List<String> options = new List<String>();
       signUpList = [SELECT Name  FROM SignUpLink__c where SignType__c = 1 ORDER BY List_Order__c ASC];
       if(signUpList!=null && signUpList.size()>0){
           for( Integer counter=0;counter<signUpList.size();counter++)
           {
                options.add(signUpList.get(counter).Name); 
           }
       }
       
       serviceValue = options;
       return serviceValue;
     }
     
     // Added by India Team
     public List<String>  getPartnerOffer(){
       List<String> options = new List<String>();
       signUpList = [SELECT Name  FROM SignUpLink__c  where SignType__c = 0 ORDER BY List_Order__c ASC];
       if(signUpList!=null && signUpList.size()>0){
           for( Integer counter=0;counter<signUpList.size();counter++)
           {
                options.add(signUpList.get(counter).Name); 
           }
       }
       
       serviceValue = options;
       return serviceValue;
     }
     
     // Added by India Team
     public List<SelectOption>  getTrialItems(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption('7D','7D Trial')); 
       options.add(new SelectOption('30D','30D Trial'));     
       options.add(new SelectOption('30','Buy Now')); 
       return options;
     }
     
    // Added by India Team      
    public List<SelectOption> getServiceItems() {
        List<SelectOption> options = new List<SelectOption>();
        serviceValue =  getServiceValues();
        if(serviceValue != null)
        {
           for(Integer counter=0;counter<serviceValue.size();counter++)
           {          
               options.add(new SelectOption(serviceValue.get(counter),serviceValue.get(counter)));       
           }        
       }
       return options;
    }  
    
    // Added by India Team
    public List<SelectOption> getPartnerOfferItems() {
        List<SelectOption> options = new List<SelectOption>();
        partnerOffer=  getPartnerOffer();
        if(partnerOffer != null)
        {
           for(Integer counter=0;counter<partnerOffer.size();counter++)
           {          
               options.add(new SelectOption(partnerOffer.get(counter),partnerOffer.get(counter)));       
           }        
       }
       return options;
    } 
    
    public PageReference doSearch()
    { 
        getPromotionItems();
        
        return null;
    }
    
    String strSignUpId;
    public String getStrSignUpId() {
        return strSignUpId;
    }
    
    public void setStrSignUpId(String strSignUpId) {
        this.strSignUpId= strSignUpId;
    }
    public Map<String, Offer_Id__c> pidMap {get;set;}
    // Added by India Team
    public List<SelectOption> getPromotionItems() {
    	//
    	pidMap = new Map<String, Offer_Id__c>();
        List<SelectOption> options = new List<SelectOption>();
        String ServiceValueTemp = '';
        if(getSelectedValue()!=null){
            ServiceValueTemp = getSelectedValue();
            blnSignUpType = true;
        }
        if(getSelectPartnerOffer()!=null){
            ServiceValueTemp = getSelectPartnerOffer();
            blnSignUpType = false;
        }
        //String SelectTrialTemp = getSelectTrial();
        //System.Debug('---'+SelectTrialTemp);
        strRedenderdValue = 'true';
        if(ServiceValueTemp.indexOf('Fax')>0){
            strImageUrl = '/servlet/servlet.FileDownload?file=01580000000pYrP';
        }
        if(ServiceValueTemp.indexOf('Mobile')>0){
            strImageUrl = '/servlet/servlet.FileDownload?file=01580000000pYrQ';
        }
        if(ServiceValueTemp.indexOf('Office')>0){
            strImageUrl = '/servlet/servlet.FileDownload?file=01580000000pYrR';
        }
        // String STRTEST = 'SELECT Name,Promotion_Name__c, Description__c from Offer_Id__c ';
        String STRTEST = 'SELECT Name,Promotion_Name__c, Description__c, OID__c, Tier_Type__c from Offer_Id__c ';
        if(!ServiceValueTemp.equals('')){
            STRTEST += ' where ProductName__r.Name = :ServiceValueTemp ';
            List<SignUpLink__c> signUpListUrl = [SELECT id,SignUpURL__c, SAFID__c  FROM SignUpLink__c where Name = :ServiceValueTemp ];
            if(signUpListUrl!=null && signUpListUrl.size()>0){
                strUrl = signUpListUrl.get(0).SignUpURL__c; 
                strSignUpId = signUpListUrl.get(0).id;
                if(signUpListUrl.get(0).SAFID__c != null){
	                SAFID = signUpListUrl.get(0).SAFID__c;
	                System.debug('----------->'+ SAFID);
                } 
            }
            
        }
       // STRTEST += ' order by Promotion_Name__c';
       STRTEST += ' ORDER BY List_Order__c ASC NULLS last';
        try{
            offerData = Database.query(STRTEST);
        }catch(exception ex){
            //System.assert(false, STRTEST );           
        } 
        //offerData = [SELECT Description__c from Offer_Id__c where ProductName__r.Name='RC OFFICE'];
        // options.add(new SelectOption('','None'));
         
        if(offerData!=null && offerData.size()>0){
           for( Integer counter=0;counter<offerData.size();counter++) {
                // options.add(new SelectOption(offerData.get(counter).Name,offerData.get(counter).Description__c+'(Name = '+offerData.get(counter).Promotion_Name__c+', OID='+offerData.get(counter).Name+')'));
                    pidMap.put(offerData.get(counter).Name, offerData.get(counter));
	                options.add(new SelectOption(offerData.get(counter).Name,
	                offerData.get(counter).Description__c
	                +'(Name = '+offerData.get(counter).Promotion_Name__c
	                +', OID='+(offerData.get(counter).OID__C == null ? '' : offerData.get(counter).OID__C)
	                +', Tier Type='+(offerData.get(counter).Tier_Type__c == null ? '' : ''+Integer.valueOf(''+offerData.get(counter).Tier_Type__c))
	                +')'
	                ));  
           }
       }
       // setSelectPromotions('');
       return options;
    }
     public String createParam(String strUrlQueryString, String inputParam, String inputValue) {
        if((inputValue != null && inputValue.trim().length() != 0) || (inputParam == 'SPID')) {
            return (strUrlQueryString != null & strUrlQueryString.indexOf('?') != -1 ? '&' : '?') + inputParam + inputValue;
        }
        return '';
    }
    // Added by India Team
    public PageReference doSAve() {
    
        String strMainServiceUrl = getStrUrl();
        
        String strUrlQueryString = '';
        //String ServiceValueTemp = getSelectedValue();
        if(blnSignUpType){
            if(getSelectTrial().equals('30D')){
                strUrlQueryString += '?action=trial30';
            }
             strUrlQueryString+= createParam(strUrlQueryString, 'BMID=', getBMID());
             strUrlQueryString+= createParam(strUrlQueryString, 'PID=' , getPID());
             strUrlQueryString+= createParam(strUrlQueryString, 'AID=' , getAID());
             strUrlQueryString+= createParam(strUrlQueryString, 'SPID=' , getSPID());
             strUrlQueryString+= createParam(strUrlQueryString, 'OPPID=' ,getOPPID());
             strUrlQueryString+= createParam(strUrlQueryString, 'PartnerID=' ,getPartnerID());
             
            
            if(getSelectPromotions()!=null && !getSelectPromotions().equals('')){
                // strUrlQueryString += '&OID='+getSelectPromotions();
               //strUrlQueryString+= createParam(strUrlQueryString,'OID=', pidMap.get(getSelectPromotions());
                if(pidMap != null) {
                	strUrlQueryString+= createParam(strUrlQueryString,'OID=', pidMap.get(getSelectPromotions()).OID__C);
                    strUrlQueryString+= createParam(strUrlQueryString,'TierType=', (pidMap.get(getSelectPromotions()).Tier_Type__c == null ? '' : '' + Integer.valueOf(''+pidMap.get(getSelectPromotions()).Tier_Type__c)) );
                    
                }
                    // strUrlQueryString += '&TierType='+ pidTierMap.get(getSelectPromotions());
            }
        }else{
        	strUrlQueryString+= createParam(strUrlQueryString,'OPPID=', getOPPID());
            strUrlQueryString+= createParam(strUrlQueryString,'SPID=', getSPID());
            strUrlQueryString+= createParam(strUrlQueryString, 'PartnerID=' ,getPartnerID());
            // strUrlQueryString += '&OPPID='+getOPPID()+'&SPID='+getSPID();
        }
        if(getSAFID() != NULL && getSAFID() != ''){
        	System.debug('----------->'+ SAFID);
            strUrlQueryString+= createParam(strUrlQueryString,'SAFID=',getSAFID());
            strUrlQueryString+= createParam(strUrlQueryString, 'PartnerID=' ,getPartnerID());
        }
        
        String strHardCodeUrl = 'http://www.ringcentral.com/salesforce_redirect.html?redir=';
        PageReference opptyPage = new PageReference(strHardCodeUrl+strMainServiceUrl+strUrlQueryString);
        System.debug('#############################'+strUrlQueryString);
        System.debug('############################'+opptyPage.getUrl());
         System.debug('############################'+getPartnerID());
        
        opptyPage.setRedirect(true);
        
        try {
        SignupHistory__c insertUser = new SignupHistory__c();
        String userNm = UserInfo.getUserId();
        User activeUser = [Select Email From User where id = :userNm ];
        String userEmail = '';
        if(activeUser!=null && activeUser.Email!=null){
            userEmail = activeUser.Email;
        }
        insertUser.UserEmail__c = userEmail;
        insertUser.SignUpLink__c = strMainServiceUrl+strUrlQueryString;
        insertUser.LaunchDate__c = Date.today();
        insertUser.Opportunity__c = getOPPID();
        
        //if(!Test.isRunningTest()){
           insert insertUser;
        //}
        } catch(Exception e) {}
        return opptyPage;
    }
    
    // End Code added by India Team
     static testMethod void testSignUpLinks() {
        try{
          
            Opportunity o=[Select Name ,AccountId ,Type,CloseDate ,StageName,OwnerId ,
                            RC_User_ID__c,Partner_ID__c,CampaignId from Opportunity   limit 1];
              Campaign camp =[Select Name,BMID__c,PID__c, AID__c from Campaign  limit 1];
           
            ApexPages.currentPage().getParameters().put('id', o.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(o);
            
            SignUpLinks sul = new SignUpLinks(sc);
            //sul.getIsAvailable();
            sul.getIsNotAvailable();
            
            camp.BMID__c='1234';
            camp.PID__c='';
            //update camp;
            sul = new SignUpLinks(sc);
            
            o.StageName = '4. Closed';
            //update o;
            //sul.getIsAvailable();
            sul.getIsNotAvailable();
            
            sul.setSelectedValue('RC US Office'); 
            sul.getPromotionItems(); 
            
            sul.setSelectedValue('RC UK Fax'); 
            sul.getPromotionItems(); 
    
            sul.setSelectedValue('RC CAN Mobile'); 
            sul.getPromotionItems();
            
            sul.setSelectTrial('30D');
            try{
               sul.getServiceValues();
               }catch(Exception e){}
                try{
                    sul.doSearch();
               }catch(Exception e){}
            try{
               sul.getPartnerOfferItems();
               }catch(Exception e){}
                try{
               sul.getServiceItems();
               }catch(Exception e){}

           try{
               sul.getTrialItems();
               }catch(Exception e){}
           SignUpLinks obj=new SignUpLinks();
           sul.setStrRedenderdValue('test');      
           String str=sul.getStrRedenderdValue();    
                      
            PageReference pr = sul.doSAve();    
            sul.getPromotion();
              sul.setStrUrl('test');
              sul.setSelectPromotions('test');
              sul.getSelectPromotions();
              sul.getStrImageUrl();
              
              sul.setStrImageUrl('test');
              sul.setSelectPartnerOffer('test');
              sul.getBlnSignUpType();
              sul.getStrSignUpId();   
              
              sul.setBlnSignUpType(true);
               sul.setStrSignUpId('test');   
               SignUpLinksTest objTest=new SignUpLinksTest();
               objTest.testingSignUpLinks01();
               objTest.testingSignUpLinks02();
               objTest.testingSignUpLinks03();
               objTest.testingSignUpLinks04();
               objTest.testingSignUpLinks05();
               objTest.testingSignUpLinks06();
               objTest.testingSignUpLinks07();
               objTest.testingSignUpLinks08();
               objTest.testingSignUpLinks09();
                objTest.testingSignUpLinks10();
               objTest.testingSignUpLinks11();
               objTest.testingSignUpLinks12();
               objTest.testingSignUpLinks13();
               objTest.testingSignUpLinks14();
               objTest.testingSignUpLinks15();
               objTest.testingSignUpLinks16();
               objTest.testingSignUpLinks17();
               objTest.testingSignUpLinks18();
               objTest.testingSignUpLinks19();
               objTest.testingSignUpLinks20();
               objTest.testingSignUpLinks21();
               objTest.testingSignUpLinks22();
               objTest.testingSignUpLinks23();
               objTest.testingSignUpLinks24();
               objTest.testingSignUpLinks25();
               objTest.testingSignUpLinks26();
               objTest.testingSignUpLinks27();
               objTest.testingSignUpLinks28();
               objTest.testingSignUpLinks29();
               objTest.testingSignUpLinks30();
               
               //objTest.testingSignUpLinks012();
        } catch (Exception exp){
            
        }
      }   
    public class SignUpLinksTest{ 
       public void testingSignUpLinks01()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
        string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks02()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
      public void testingSignUpLinks03()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
      public void testingSignUpLinks04()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
        string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
      public void testingSignUpLinks05()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
      public void testingSignUpLinks06()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    } 
      public void testingSignUpLinks07()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       
        string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }    
     public void testingSignUpLinks08()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks09()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
        string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks10()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks11()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
     string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }  
     public void testingSignUpLinks12()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks13()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
    string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks14()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks15()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks16()       
            {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }   
       public void testingSignUpLinks17()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
                 datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }   
      public void testingSignUpLinks18()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }     
       public void testingSignUpLinks19()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks20()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
     string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks21()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
     string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
     public void testingSignUpLinks22()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
    string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }   
     public void testingSignUpLinks23()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }    
     public void testingSignUpLinks24()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    } 
     public void testingSignUpLinks25()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }     
      public void testingSignUpLinks26()       
          {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }   
      public void testingSignUpLinks27()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
       string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }
      public void testingSignUpLinks28()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }   
      public void testingSignUpLinks29()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
           datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    } 
      public void testingSignUpLinks30()       
        {
        datetime myDtOne = datetime.now();
        string mydtStrOne = myDtOne.format();
        string yearOne = '2010';         
        string monthOne = '12';
        string dayOne = '2';
        string hourOne = '12';
        string minOne = '30';
        string secsOne = '25';
      string stringDateOne = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate2One = yearOne 
          + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate3One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate4One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate5One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate6One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate7One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate8One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate9One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate10One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate11One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate12One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate13One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate14One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate15One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate16One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate17One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate18One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate19One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        string stringDate20One = yearOne 
           + '-'  + monthOne + '-' + dayOne + ' ' +hourOne + ':' + minOne + ':' + secsOne;
        datetime myDtParsedOne = datetime.valueOf(stringDateOne);
    }     
  }  */
}