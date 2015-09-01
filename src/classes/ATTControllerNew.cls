public  class ATTControllerNew {
//String IEE = Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');// For IE9 

private static final String PAGE_PREFIX = '/apex';

    public static final String PAGE_HOME = 'ATTSupportHome';
    public static final String PAGE_PRODUCT = 'ATTProduct';
    public static final String PAGE_SEARCH1 = 'ATTSupportArtList?action=SearchAnswer';
     public static final String PAGE_Next = 'ATTSupportArtList';
    public static final String PAGE_SEARCH = 'ATTSupportArtList';
    public static final String PAGE_SEARCH_CUSTOM = 'ATTSupportArtListNew';
    
    public static final String PAGE_WHATIS_NEW = 'ATTWhatIsNew';
    public static final String PAGE_INTERNATIONALRATES = 'internationalrates';
    
     public static final String PAGE_SUPPORT_SERARCH='ATTSupportSearch';
    public static final String PAGE_CONTACT_SUPPORT='ATTContactSupport';
    public static final String PAGE_Video_Link_Page='AttVideoLink2';

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

  public pagereference redirectToDetailPage(){
  	
     try{
      if(ApexPages.CurrentPage().getParameters().get('ARTICLEID')!=null && ApexPages.CurrentPage().getParameters().get('ARTICLEID')!=''){
      	String strParam=ApexPages.CurrentPage().getParameters().get('ARTICLEID');
        String strArticleNumber='%'+strParam+'';
         if(strParam.length()<4){
        	 strArticleNumber='%0'+strParam+'';
        }
        String strURLName='Not Found';
       // List<RC_Knowledge_Article__DataCategorySelection> lstDataCategory=new List<RC_Knowledge_Article__DataCategorySelection>();
       	for(RC_Knowledge_Article__DataCategorySelection objData:[Select r.Parent.UrlName,r.DataCategoryName, r.DataCategoryGroupName,r.Parent.ArticleNumber,r.Parent.KnowledgeArticleId, r.ParentId 
		                                                         From RC_Knowledge_Article__DataCategorySelection r where r.Parent.PublishStatus='Online'
		                                                         and ((r.Parent.ArticleNumber Like:strArticleNumber) OR (r.Parent.UrlName=:strParam) OR 
		                                                         (r.Parent.KnowledgeArticleId=:strParam) OR (r.Parent.id=:strParam)) 
		                                                          order by r.Parent.UrlName limit 20]){
		       if(objdata.DataCategoryGroupName=='Brand' && (objdata.DataCategoryName=='ALL' || objdata.DataCategoryName=='ATT_VIIPFR')){
		         	//lstDataCategory.add(objData);
		         	strURLName=objdata.Parent.UrlName;
		       }                                                              	
      	
        }
      	 if(strURLName!='Not Found'){
        	  String strPage='/articles/RC_Knowledge_Article/'+strURLName+'?retUrl=';
	      	  Pagereference pageRef= new Pagereference(strPage);
	      	  pageRef.setRedirect(true);
			  return pageRef;
        }
      }
     }catch(Exception ex){}
  	return null;
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



    public String paramByParamId(String paramId, String defaultValue) {
        if (ApexPages.currentPage().getParameters() == null) {
            return defaultValue;
        } else {
            String value = ApexPages.currentPage().getParameters().get(paramId);
            return (value == null) ? defaultValue : value;
        }
    }

    public Integer paramByParamId(String paramId, Integer defaultValue) {
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
    /*public PageReference localeSetting() {
         PageReference myPage = ApexPages.CurrentPage(); 
         String strBrandParam = ApexPages.CurrentPage().getParameters().get('brand');
         String strUrl='';
       
        String allParam = ApexPages.currentPage().getUrl() ;
    Integer intFirstIndex = allParam.indexOf('?');
    Integer intLength = allParam.length();
    
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
*/

    public static RCSiteSetup__c siteSetup {
        get {
            if (siteSetup == null) {
                try {
                    String siteName = Site.getName();
                        if (siteName == null || siteName.length()==0) {
                        siteName = 'TestPKBSiteSetup';
                    }
                    if(Test.isRunningTest()){
                    	 siteName = 'ATT';
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

   /* public String getCaseURL() {
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
    */
    
    public String getAuthToken()
    {
       /* String strToken = ApexPages.CurrentPage().getParameters().get('token');
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
         } */     
        return '';
    } 
    public String getPageId() {
        String strgetpageid = '';
        Boolean isHomePage=false;
        strgetpageid = ApexPages.CurrentPage().getParameters().get('pageid');
        String pagename = ApexPages.currentPage().getUrl();
        if(pagename == '/apex/ATTSupportHome'){
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
     public Boolean getIsVideoLinkPage(){
        return isPage(PAGE_Video_Link_Page);
    }
    
    public Boolean getWhatIsNewPage() {
        return isPage(PAGE_WHATIS_NEW);
    }
     public Boolean getWhatIsNewPageNew() {
        return isPage('WhatIsNew');
    }
    public Boolean getINTERNATIONALPage() {
        return isPage(PAGE_INTERNATIONALRATES);
    }
    
    public Boolean getIsExternalPage() {
        return !(getIsHomePage() || getIsProductPage() || getIsSearchPage() || getIsCustomArticleListPage() || getIsContactSupportPage()
        	|| getWhatIsNewPage() || getWhatIsNewPageNew() || getINTERNATIONALPage());
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
}