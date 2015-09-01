public abstract class ATTController {
   private static final String PAGE_PREFIX = '/apex';

    public static final String PAGE_HOME = 'ATTHome';
    public static final String PAGE_PRODUCT = 'ATTProduct';
    public static final String PAGE_SEARCH1 = 'ATTAnswer?action=SearchAnswer';
     public static final String PAGE_Next = 'ATTAnswer';
    public static final String PAGE_SEARCH = 'ATTAnswer';
    public static final String PAGE_VIDEO_LINK='AttVideoLink';
    
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



    protected String paramByParamId(String paramId, String defaultValue) {
        if (ApexPages.currentPage().getParameters() == null) {
            return defaultValue;
        } else {
            String value = ApexPages.currentPage().getParameters().get(paramId);
            return (value == null) ? defaultValue : value;
        }
    }

    protected Integer paramByParamId(String paramId, Integer defaultValue) {
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

    public static RCSiteSetup__c siteSetup {
        get {
            if (siteSetup == null) {
                try {
                    String siteName = Site.getName();
                    System.debug('siteName ======================'+siteName );
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
                        //WHERE RCSiteName__c = :'ATT'];
        
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

    public Long getCacheMaxAge() {
        return siteSetup.CacheMaxAge__c == null ? 0 : Math.roundToLong(siteSetup.CacheMaxAge__c);
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

    public Boolean getIsProductPage() {
        return isPage(PAGE_PRODUCT);
    }

    public Boolean getIsSearchPage() {
        return isPage(PAGE_SEARCH);
    }
    public Boolean getIsVideoLinkPage() {
        return isPage(PAGE_VIDEO_LINK);
    }
    public Boolean getIsExternalPage() {
        return !(getIsHomePage() || getIsProductPage() || getIsSearchPage() || getIsVideoLinkPage());
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
  public String strSearchCategory{get;set;}
 // public String strSortOrderDirection{get;set;}
  public String strSortOrderAscORDec{get;set;}
  
   public String strSortOrderDirection{
         get{
           if(ApexPages.currentPage().getParameters().get('sortBy')==null){
                  return 'mostViewed';
            }
       return ApexPages.currentPage().getParameters().get('sortBy');
       }
       set;
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