public class RCSupportController2013 {
    //String IEE = Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8'); // For IE9 
    private static final String PAGE_PREFIX = '/apex';
    public static final String PAGE_HOME = 'RCSupportHome2013';
    public static final String PAGE_PRODUCT = 'ATTProduct';
    public static final String PAGE_SEARCH1 = 'RCSupportArtList2013?action=SearchAnswer';
    public static final String PAGE_Next = 'RCSupportArtList2013';
    public static final String PAGE_SEARCH = 'RCSupportArtList2013';
    public static final String PAGE_SEARCH_CUSTOM = 'RCSupportArtListNew';
    public static final String PAGE_SUPPORT_SERARCH='RCSupportSearch2013';
    public static final String PAGE_CONTACT_SUPPORT='RCSupportContactSupport2013';
    public static final String URL_HOME = PAGE_PREFIX + '/' + PAGE_HOME;
    public static final String URL_PRODUCT = PAGE_PREFIX + '/' + PAGE_PRODUCT;
    public static final String URL_SEARCH = PAGE_PREFIX + '/' + PAGE_SEARCH;
    public static final String URL_SEARCH1 = PAGE_SEARCH;
    //public static final String URL_PageSEARCH=PAGE_SEARCH1;
    public static final String URL_PageSEARCH=PAGE_Next;
    public static final String ARTICLE_TYPE_PARAMETER_NAME = 't';
    public static final String CATEGORY_PARAMETER_NAME = 'c';
    public static final String KEYWORD_PARAMETER_NAME = 'k';
    public static final String PAGE_NUMBER_PARAMETER_NAME = 'p';
    public static final String ARTICLE_TYPE_LABEL_PARAMETER_NAME = 'l';
    public static final String PAGE_SORT_BY='sortBy';

   public User objUser{get;set;}
    
    public RCSupportController2013 () {
       objUser=[SELECT AboutMe, IsActive, CommunityNickname, CompanyName, Country, CreatedDate, Department, Division, Email,  Name, IsPortalEnabled, LastLoginDate,
                UserType, Username,Profile.Name,UserRole.Name,FullPhotoUrl FROM User where id=:UserInfo.getUserId()];
    }
    
    public PageReference updateUserProfile() {
         try{
            update objUser;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Profile Successfully updated');
            ApexPages.addMessage(msg);
        }catch(Exception e ){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
            e.getMessage());
            ApexPages.addMessage(msg);
        }
     return null;
    }
    
    public String getCommunityId(){
        String strReturnString='false';
        for(Community objCommunity : [SELECT Id FROM Community WHERE Name = 'RingCentral Customer Community' limit 1 ]){
         strReturnString=objCommunity.id;
        }
        return strReturnString;
    }
    
    public String categoryParameterName {
        get {
            return CATEGORY_PARAMETER_NAME;
        }
    }
    public String keywordParameterName {
        get {
            return KEYWORD_PARAMETER_NAME;
        }
    }
    public String articleTypeParameterName {
        get {
            return ARTICLE_TYPE_PARAMETER_NAME;
        }
    }
    public String articleTypeLabelParameterName {
        get {
            return ARTICLE_TYPE_LABEL_PARAMETER_NAME;
        }
    }
    public String pageNumberParameterName {
        get {
            return PAGE_NUMBER_PARAMETER_NAME;
        }
    }
      String paramByParamId(String paramId, String defaultValue) {
        if (ApexPages.currentPage().getParameters() == null) {
            return defaultValue;
        } else {
            String value = ApexPages.currentPage().getParameters().get(paramId);
            return (value == null) ? defaultValue : value;
        }
    }
    Integer paramByParamId(String paramId, Integer defaultValue) {
        if (ApexPages.currentPage().getParameters() == null) {
            return defaultValue;
        } else {
            String value = ApexPages.currentPage().getParameters().get(paramId);
            return (value == null) ? defaultValue : Integer.valueOf(value);
        }
    }
    public Integer currentPageNumber {
        get {
            if (currentPageNumber == null) {
                currentPageNumber = paramByParamId(PAGE_NUMBER_PARAMETER_NAME, 1);
            }
            return currentPageNumber;
        }
        set;
    }
    public String currentCategory {
        get {
            if (currentCategory == null) {
                currentCategory = paramByParamId(CATEGORY_PARAMETER_NAME, getRootCategoryName());
            }
            return currentCategory;
        }
        set;
    }
    public String currentCategoryName {
            get {
            if (currentCategory!= null) {
                currentCategoryName = currentCategory.replace('_',' ');
            }
            return currentCategoryName; 
        }
        set;
    }
    public String currentArticleType {
        get {
            if (currentArticleType == null) {
                currentArticleType = paramByParamId(ARTICLE_TYPE_PARAMETER_NAME, '');
            }
            return currentArticleType;
        }
        set;
    }
    public String currentArticleTypeLabel {
        get {
            if (currentArticleTypeLabel == null) {
                currentArticleTypeLabel = paramByParamId(ARTICLE_TYPE_LABEL_PARAMETER_NAME, '');
            }
            return currentArticleTypeLabel;
        }
        set;
    }
    public String currentKeyword {
        get {
            if (currentKeyword == null) {
                currentKeyword = paramByParamId(KEYWORD_PARAMETER_NAME, '');
            }
            return currentKeyword;
         }
        set;
    }
    public String currentKeywordSerach {
        get {
            if (currentKeyword == null || currentKeyword =='') {
                currentKeyword = paramByParamId(KEYWORD_PARAMETER_NAME, '');
                return currentKeyword ;
            }
            return '\"'+currentKeyword+'\"';
           }
        set;
    }
    /*For Site redirection depending upon the brand*/
    public PageReference localeSetting() {
         PageReference myPage = ApexPages.CurrentPage(); 
         String strBrandParam = ApexPages.CurrentPage().getParameters().get('brand');
         String strUrl='';
         /*to add all param*/
        String allParam = ApexPages.currentPage().getUrl() ;
        Integer intFirstIndex = allParam.indexOf('?');
        Integer intLength = allParam.length();
        /**/
        if(allParam!='' && allParam !=null && intFirstIndex > 0 ){
           allParam =allParam.subString(intFirstIndex,intLength);                 
        }
         if(strBrandParam != null && strBrandParam != ''){
            if(strBrandParam == 'RC_UK'){
               strUrl=Site.getCurrentSiteUrl(); 
               if(strUrl!='' && strUrl!=null ){
                 strUrl=strUrl.subString(0,strUrl.lastIndexOf('/'));
                 strUrl=strUrl.subString(0,strUrl.lastIndexOf('/'));
                 strUrl=strUrl+'/rcsupportUK'+allParam;
                 //strUrl=strUrl+'/rcsupportUK';
               }
                PageReference createLeadPage = new PageReference(strUrl);
                createLeadPage.setRedirect(true);
                return createLeadPage;
            }else if(strBrandParam != 'RC_CA'){
                strUrl=Site.getCurrentSiteUrl();
               if(strUrl!='' && strUrl!=null ){
                  strUrl=strUrl.subString(0,strUrl.lastIndexOf('/'));
                  strUrl=strUrl.subString(0,strUrl.lastIndexOf('/'));
                  strUrl=strUrl+'/rcsupportCA'+allParam;
                  //strUrl=strUrl+'/rcsupportCA';  
               }
                PageReference createLeadPage = new PageReference(strUrl);
                createLeadPage.setRedirect(true);
                return createLeadPage;
            }
        } 
      return null;
    }
    public static RCSiteSetup__c siteSetup {
        get {
            if (siteSetup == null) {
                try {
                    String siteName = Site.getName();
                        if (siteName == null || siteName.length()==0) {
                        siteName = 'TestPKBSiteSetup';
                    }
                    siteSetup = [
                       SELECT RCSiteName__c, RootCategoryName__c, CategoryGroupName__c, CacheMaxAge__c,
                       Category1Description__c, Category2Description__c, Category3Description__c,
                       Category4Description__c, Category5Description__c, Category6Description__c,
                       HomeAdText__c, HomeAdTitle__c, Brand_Filter__c
                       FROM RCSiteSetup__c
                       WHERE RCSiteName__c = :siteName ];
                       //WHERE RCSiteName__c = :'rcsupport'];
                 } catch (QueryException  e) {
                    // can't throw an exception here in order to prevent tests from failing before creating an PKB Site Setup
                    siteSetup = new RCSiteSetup__c();
                }
            }
            return siteSetup;
        }
        set;
    }

    public RCSiteSetup__c getSiteSetup() {
        return siteSetup;
    }
    private String[] categoryDescriptions;

    public String[] getCategoryDescriptions() {
        if (categoryDescriptions == null) {
            categoryDescriptions = new String[]{};
            categoryDescriptions.add(siteSetup.category1Description__c == null ? '' : siteSetup.category1Description__c);
            categoryDescriptions.add(siteSetup.category2Description__c == null ? '' : siteSetup.category2Description__c);
            categoryDescriptions.add(siteSetup.category3Description__c == null ? '' : siteSetup.category3Description__c);
            categoryDescriptions.add(siteSetup.category4Description__c == null ? '' : siteSetup.category4Description__c);
            categoryDescriptions.add(siteSetup.category5Description__c == null ? '' : siteSetup.category5Description__c);
            categoryDescriptions.add(siteSetup.category6Description__c == null ? '' : siteSetup.category6Description__c);
        }
        return categoryDescriptions;
    }

    public String getHomeAdTitle() {
        return siteSetup.HomeAdTitle__c == null ? '' : siteSetup.HomeAdTitle__c;
    }

    public String getHomeAdText() {
        return siteSetup.HomeAdText__c == null ? '' : siteSetup.HomeAdText__c;
    }

    public String getRootCategoryName() {
        return siteSetup.RootCategoryName__c == null ? '' : siteSetup.RootCategoryName__c;
    }

    public String getCategoryGroupName() {
        return siteSetup.CategoryGroupName__c == null ? '' : siteSetup.CategoryGroupName__c;
    }
    
    public String getBrandFilter() {
        return siteSetup.Brand_Filter__c == null ? '' : siteSetup.Brand_Filter__c;
    }
     public String getServiceFilter() {
        String strServiceFilter=ApexPages.CurrentPage().getParameters().get('serviceFilter');
       if(strServiceFilter==null){
          // return siteSetup.Brand_Filter__c == null ? '' : siteSetup.Brand_Filter__c;
          //return siteSetup.Brand_Filter__c == null ? '' : 'ALL';
          strServiceFilter = '';
       }else{
          strServiceFilter = 'Service:'+strServiceFilter;       
       }
       return strServiceFilter;
    }
     public String getServiceFilterURL() {
        String strServiceFilter=ApexPages.CurrentPage().getParameters().get('serviceFilter');
       if(strServiceFilter==null){
          // return siteSetup.Brand_Filter__c == null ? '' : siteSetup.Brand_Filter__c;
          //return siteSetup.Brand_Filter__c == null ? '' : 'ALL';
          strServiceFilter = '';
       }else{
          strServiceFilter = strServiceFilter;      
       }
       return strServiceFilter;
    }
    public String getURLCategory() {
        return ApexPages.CurrentPage().getParameters().get('c');
    }
    
    public String getFramedParam() {
        return ApexPages.CurrentPage().getParameters().get('framed');
    }

    public String getCaseURL() {
         String strToken = ApexPages.CurrentPage().getParameters().get('token');
         String caseURL = '';
         String tokenVal = '';
         if(strToken == null || strToken.Trim() == '') {            
            strToken = '';
            String retUrl = ApexPages.CurrentPage().getParameters().get('retURL');
            if(retURL != null) {
                retUrl = Encodingutil.urlDecode(retUrl, 'UTF-8');
                List<String> params = retUrl.split('&');
                for(String param : params) {
                    if(param.startsWith('token')){
                        strToken = param;
                        break;
                    }
                }
            }           
            if(strToken.Trim() != '') {
                strToken = strToken.replace('token=', '');
            }
        }
         if(strToken==''){
            caseURL = 'false';
         } else {
            String tokenUrlDecoded = EncodingUtil.urlDecode(strToken, 'UTF-8');
            tokenUrlDecoded = tokenUrlDecoded.replaceAll(' ', '+');
            Blob tokenDecodedBases64 = Encodingutil.base64Decode(tokenUrlDecoded);          
            Blob cryptoKey = Blob.valueOf('v7Y2g2webAqutAcr4DEC3uTAnaspEgA8');
            Blob initVector = Blob.valueof('da4atrABufastacr');
            // Decrypt the data
            try{
                Blob decryptedData = Crypto.decrypt('AES256', cryptoKey, initVector, tokenDecodedBases64);
                tokenVal = decryptedData.toString();    
                // it is fixed for mul
                String VIEW_ID = '&startURL=%2F500%3Ffcf%3D00B80000007jL32';            
                caseURL = 'https://na6.salesforce.com/secur/login_portal.jsp?orgId=00D80000000aRUX&portalId=06080000000EWip'+VIEW_ID+'&'+tokenVal;
            } catch (Exception ex) {
                tokenVal =  ex.getMessage();
                caseURL = 'false';
            }
         }         
        return caseURL;
    }
     public String getIdeaURL() {
         String strToken = ApexPages.CurrentPage().getParameters().get('token');
         String ideaURL = '';
         String tokenVal = '';
         if(strToken == null || strToken.Trim() == '') {            
            strToken = '';
            String retUrl = ApexPages.CurrentPage().getParameters().get('retURL');
            if(retURL != null) {
                retUrl = Encodingutil.urlDecode(retUrl, 'UTF-8');
                List<String> params = retUrl.split('&');
                for(String param : params) {
                    if(param.startsWith('token')){
                        strToken = param;
                        break;
                    }
                }
            }           
            if(strToken.Trim() != '') {
                strToken = strToken.replace('token=', '');
            }
            
        }
         if(strToken==''){
            ideaURL= 'false';
         } else {
                String strSite=Site.getCurrentSiteUrl()+'?'+getAuthToken(); 
               
             String strToken1='&startURL=apex/RCAnswerAndIdeaPage?siteUrl='+strSite;
            //String strToken1='&startURL=home/home.jsp?siteUrl='+strSite;
        
            String tokenUrlDecoded = EncodingUtil.urlDecode(strToken, 'UTF-8');
            tokenUrlDecoded = tokenUrlDecoded.replaceAll(' ', '+');
            Blob tokenDecodedBases64 = Encodingutil.base64Decode(tokenUrlDecoded);          
            Blob cryptoKey = Blob.valueOf('v7Y2g2webAqutAcr4DEC3uTAnaspEgA8');
            Blob initVector = Blob.valueof('da4atrABufastacr');
            // Decrypt the data
            try{
                 Blob decryptedData = Crypto.decrypt('AES256', cryptoKey, initVector, tokenDecodedBases64);
                tokenVal = decryptedData.toString();             
                 ideaURL= 'https://na6.salesforce.com/secur/login_portal.jsp?orgId=00D80000000aRUX&portalId=06080000000EWip&'+tokenVal+''+strToken1;
                //ideaURL= 'https://tapp0.salesforce.com/secur/login_portal.jsp?orgId=00DT0000000JuDx&portalId=060T00000004fIE&'+tokenVal+''+strToken1;
            } catch (Exception ex) {
                tokenVal =  ex.getMessage();
                ideaURL= 'false';
            }
         }         
        return ideaURL;
    } 
    public String getAuthToken()
    {
        String strToken = ApexPages.CurrentPage().getParameters().get('token');
        if(strToken == null || strToken.Trim() == '') {
            strToken = '';
            String retUrl = ApexPages.CurrentPage().getParameters().get('retURL');
            if(retURL != null) {
                retUrl = Encodingutil.urlDecode(retUrl, 'UTF-8');
                List<String> params = retUrl.split('&');
                for(String param : params) {
                    if(param.startsWith('token')){
                        strToken = param;
                        break;
                    }
                } 
            }           
         } else {         
            strToken = 'token='+ strToken;
         }      
        return strToken;
    } 
    public String getPageId() {
        String strgetpageid = '';
        Boolean isHomePage=false;
        strgetpageid = ApexPages.CurrentPage().getParameters().get('pageid');
        String pagename = ApexPages.currentPage().getUrl();
        if(pagename == '/apex/RCSupportHome2013'){
            strgetpageid = 'home';
            isHomePage=true;
        } 
         if(isHomePage==false && (strgetpageid==null || strgetpageid=='')  ){
            if(ApexPages.CurrentPage().getParameters().get('token')!=null){
              strgetpageid = 'home';
            }else{
               strgetpageid='knowledge';
               }
          }   
        return strgetpageid;
    }
    public Long getCacheMaxAge() {
        return siteSetup.CacheMaxAge__c == null ? 0 : Math.roundToLong(siteSetup.CacheMaxAge__c);
    }

    public String getParentId() {
        return ApexPages.CurrentPage().getParameters().get('parentId');
    }
   
    public String getHomeUrl() {
        return URL_HOME;
    }

    public String getProductUrl() {
        return URL_PRODUCT;
    }

    public String getSearchUrl() {
        return URL_SEARCH;
    }
    public String getSearchPageUrl() {
        /*String strURL_PageSEARCH = URL_PageSEARCH;
        String strserviceFilter=ApexPages.currentPage().getParameters().get('serviceFilter');
        if(strserviceFilter != ''){
            strURL_PageSEARCH =  strURL_PageSEARCH+'&serviceFilter='+ strserviceFilter;         
        }
        //return URL_PageSEARCH;
        */
        return URL_PageSEARCH;
    }
    public String getSupportSearchPageUrl() {
        return PAGE_SUPPORT_SERARCH;
    }
      public String getSearchUrl1() {
        return URL_SEARCH1;
    }
    
    public String getHomePage() {
        return PAGE_HOME;
    }

    public String getProductPage() {
        return PAGE_PRODUCT;
    }

    public String getSearchPage() {
        return PAGE_SEARCH;
    }

    public String getPage(String url) {
        if (url.contains('?')) {
            Integer i = url.indexOf('?');
            url = url.substring(0, i);
        }
        while (url.endsWith('/')) {
            url = url.substring(0, url.length()-1);
        }
        if (url.contains('/')) {
            Integer i = url.lastIndexOf('/');
            url = url.substring(i+1);
        }
        return url;
    }
     public PageReference currentPageReference {
        get {
            if (currentPageReference == null) {
                currentPageReference = ApexPages.currentPage();
            }
            return currentPageReference;
        }
        set;
    }

    public String currentPage {
        get {
                if (currentPage == null) {
                    currentPage = getPage(currentPageReference.getUrl());
                }
                return currentPage;
            }
            set;
    }

    public Boolean isPage(String pageName) {
        return currentPage.toLowerCase() == (pageName.toLowerCase());
    }

    public Boolean getIsHomePage() {
        return isPage(PAGE_HOME);
    }

  public Boolean getIsContactSupportPage() {
        return isPage(PAGE_CONTACT_SUPPORT);
    }
    public Boolean getIsProductPage() {
        return isPage(PAGE_PRODUCT);
    }

    public Boolean getIsSearchPage() {
        return isPage(PAGE_SEARCH);
    }
    public Boolean getIsCustomArticleListPage(){
        return isPage(PAGE_SEARCH_CUSTOM);
    }
    public Boolean getIsExternalPage() {
        return !(getIsHomePage() || getIsProductPage() || getIsSearchPage() || getIsCustomArticleListPage());
        //  return !(getIsHomePage() );
    }


   public PageReference doSearch() {
       /* if (currentKeyword.length()<2) {
            return cleanKeyword();
        }*/
        PageReference pg = new PageReference(getSearchUrl());
        pg.getParameters().put(KEYWORD_PARAMETER_NAME, currentKeyword);
        pg.getParameters().put(CATEGORY_PARAMETER_NAME, currentCategory);
         pg.getParameters().put('action', 'SearchAnswer');
          pg.getParameters().put(PAGE_SORT_BY, strSortOrderDirection);
        if (getIsExternalPage()) {
            pg.setRedirect(true);
        }
           pg.setRedirect(true);
        return pg;
   }
    public PageReference cleanKeyword() {
        PageReference pg = new PageReference(getProductUrl());
        pg.getParameters().put(CATEGORY_PARAMETER_NAME, currentCategory);
        pg.getParameters().put(KEYWORD_PARAMETER_NAME, '');
        currentKeyword = '';
        if (getIsExternalPage()) {
            pg.setRedirect(true);
        }
     
        return pg;
   }

    public Boolean getCanUserSeeKnowledge() {
        //return [select permissionsviewknowledge from profile where id = :UserInfo.getProfileId()].permissionsviewknowledge;
        return true;
    }

 public Boolean getIsContact(){
    String strParam=ApexPages.currentPage().getParameters().get('attContactUs');
     if(strParam == 'contact'){
   return true;
   }
   return false;
 }
   public Boolean getIsAnswerSearch(){ 
   String strParam=ApexPages.currentPage().getParameters().get('action');
     if(strParam !=null && strParam!='' && strParam.contains('?')){
       return true;
     }
     if(strParam == 'SearchAnswer'){
   return true;
   }
   if(ApexPages.currentPage().getParameters().get('retURL')!=null){
     return true;
   }
   return false;
   
   }
   
    public Boolean getIsArticleDetailsPage(){ 
     if(ApexPages.currentPage().getParameters().get('retURL')!=null){
     return true;
   }
   return false;
    }
   
  public String strSearchCategory{get;set;}
 // public String strSortOrderDirection{get;set;}
  public String strSortOrderAscORDec{get;set;}
  
   public String strSortOrderDirection{
      get{
      if(ApexPages.currentPage().getParameters().get('sortBy')==null){
        //return 'mostViewed';
        return 'title';
      }
      return ApexPages.currentPage().getParameters().get('sortBy');
      }
       set;
     }
  
   public PageReference doAdvanceSearch() {
       /* if (currentKeyword.length()<2) {
            return cleanKeyword();
        }*/
        PageReference pg = new PageReference(getSearchUrl());
        pg.getParameters().put(KEYWORD_PARAMETER_NAME, currentKeyword);
        pg.getParameters().put(CATEGORY_PARAMETER_NAME, strSearchCategory);
        pg.getParameters().put('action', 'SearchAnswer');
        if (getIsExternalPage()) {
            pg.setRedirect(true);
        }
         //pg.getParameters().put('test1', strSortOrderDirection);
         //pg.getParameters().put('test2', strSortOrderAscORDec);
           pg.setRedirect(true);
        return pg;
   }
   
  public PageReference emailSend(){
   String page=ApexPages.currentPage().getParameters().get('emailPage');
   String recMail=ApexPages.currentPage().getParameters().get('recMail');
   String senderMail=ApexPages.currentPage().getParameters().get('senderMail');
   String senderName=ApexPages.currentPage().getParameters().get('sendername');
   String strTitle='';
   
  if(page!=null && page!=''){
     page=page.replace('\'','');
  }
  
  if(page!=null){
    strTitle=ApexPages.currentPage().getParameters().get('title');
    if(strTitle!=null){
    strTitle=strTitle.replace('\'','');
    }
   }
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   //String strTo='kanishk.singh@simplion.com';
    String strTo=recMail;
    String strMessageBody= '<div>The following answer has been forwarded to you by '+senderName+
                            ' - <a href=#>'+senderMail+'.</a><br/>'+
                           ' (The sender email address has not been verified.)</div><br/><br/> '+
                           ' <div style=background-color:#e0e0e0;width:100%><B>Summary</B></div><div>'+
                           //' Supported File Attachments for Faxes<br/> '+
                           strTitle+
                           '<br/> <a href='+page+'>You can view this answer here.</a> '+
                           ' </div>';
    
            String[] toAddresses = new String[] {strTo}; 
            mail.setToAddresses(toAddresses);
            //mail.setSenderDisplayName(senderName);
             mail.setSenderDisplayName('');
            mail.setSubject('FWD Answer: '+strTitle);
          //mail.setPlainTextBody('Test mail\n\n'+page+'\n\n'+recMail+'\n'+senderMail+'\n'+senderName);  
            mail.setHtmlBody(strMessageBody); 
            try{            
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }catch(Exception e){}
          return null;
   }

    private class ATTDataTest{ 
    }
    
  /* static testMethod void testRCSupportController2013(){
        try{
        RCSupportController2013 objRCSupportController2013=new RCSupportController2013();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='rcsupport2013';
        upsert objRCSiteName;

        PageReference pageRef = new PageReference('/apex/RCSupportHome2013');
        Test.setCurrentPageReference(pageRef);
       
        objRCSupportController2013.getAuthToken(); 
        objRCSupportController2013.getBrandFilter();
        objRCSupportController2013.getCacheMaxAge();
        objRCSupportController2013.getCanUserSeeKnowledge();
        objRCSupportController2013.getCategoryDescriptions();
        objRCSupportController2013.getCategoryGroupName();
        objRCSupportController2013.getFramedParam();
        objRCSupportController2013.getHomeAdText();
        objRCSupportController2013.getHomeAdTitle();
        objRCSupportController2013.getHomePage();
        objRCSupportController2013.getHomeUrl();
        objRCSupportController2013.getIsAnswerSearch();
        objRCSupportController2013.getIsArticleDetailsPage();
        objRCSupportController2013.getIsContact();
        objRCSupportController2013.getIsContactSupportPage();
        objRCSupportController2013.getIsCustomArticleListPage();
        objRCSupportController2013.getIsExternalPage();
        objRCSupportController2013.getIsHomePage();
        objRCSupportController2013.getIsProductPage();
        objRCSupportController2013.getRootCategoryName();

        objRCSupportController2013.getPage(ApexPages.currentpage().getUrl());
        objRCSupportController2013.getPageId();
        objRCSupportController2013.getParentId();
        objRCSupportController2013.getProductPage();
        objRCSupportController2013.getProductUrl();
        objRCSupportController2013.getRootCategoryName();
        objRCSupportController2013.getSearchPage();
        objRCSupportController2013.getSearchPageUrl();
        objRCSupportController2013.getSearchUrl();
        objRCSupportController2013.getSearchUrl1();
        
        String str2= objRCSupportController2013.currentArticleType;
        str2= objRCSupportController2013.currentArticleTypeLabel;
        str2= objRCSupportController2013.currentCategory;
        str2= objRCSupportController2013.currentCategoryName;
        str2= objRCSupportController2013.currentKeyword;
        str2= objRCSupportController2013.currentPage;
        Integer pageNum= objRCSupportController2013.currentPageNumber;
        PageReference objpage= objRCSupportController2013.currentPageReference;
        objRCSupportController2013.doSearch();
        objRCSupportController2013.doAdvanceSearch();
       
        str2= objRCSupportController2013.categoryParameterName; 
        str2= objRCSupportController2013.keywordParameterName; 
        str2= objRCSupportController2013.articleTypeParameterName; 
        str2= objRCSupportController2013.articleTypeLabelParameterName; 
        str2= objRCSupportController2013.pageNumberParameterName ;
        objRCSupportController2013.getSiteSetup();
        objRCSupportController2013.getServiceFilter();
        objRCSupportController2013.getServiceFilterURL();
        objRCSupportController2013.getSupportSearchPageUrl();
        objRCSupportController2013.getIsSearchPage();
        objRCSupportController2013.cleanKeyword();
        
        ApexPages.currentPage().getParameters().put('emailPage','kanishk.singh@simplion.com');
        String recMail=ApexPages.currentPage().getParameters().put('recMail','kanishk.singh@simplion.com');
        String senderMail=ApexPages.currentPage().getParameters().put('senderMail','kanishk.singh@simplion.com');
        String senderName=ApexPages.currentPage().getParameters().put('sendername','kanishk');
        String strTitle='';
        
        objRCSupportController2013.emailSend();
        objRCSupportController2013.getIdeaURL();
        objRCSupportController2013.getCaseURL();
        ApexPages.CurrentPage().getParameters().put('retUrl','service=1&brand=Ringcentral&token=test');
        ApexPages.CurrentPage().getParameters().put('brand','RC_UK');
        objRCSupportController2013.getIdeaURL();
        objRCSupportController2013.getCaseURL();
        
        ApexPages.CurrentPage().getParameters().put('token','test');
        objRCSupportController2013.getIdeaURL();
        objRCSupportController2013.getCaseURL();
     
        ApexPages.CurrentPage().getParameters().put('token','PFK8fqxUQZ3qw1nIWm0gVoPE1O1xEhiRFh0X3n0PxvEIzdYo+J2ihXuaSvfrFoOGXg5uqTH8KYo/2oohN5A7wQ==');
        objRCSupportController2013.getIdeaURL(); 
        objRCSupportController2013.getCaseURL();
       
        objRCSupportController2013.getIdeaURL(); 
        objRCSupportController2013.updateUserProfile();
        objRCSupportController2013.getCommunityId();

        objRCSupportController2013.localeSetting();
        }catch(Exception e){
        	
        }  
    }*/
}