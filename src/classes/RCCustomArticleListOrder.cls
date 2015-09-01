public class RCCustomArticleListOrder{
  
	public ApexPages.StandardSetController con {get; set;}
	public List<RCNEW_Knowledge_Article__c> searchResults{get;set;}
	public Integer iRecordSize{get;set;} 
	public Integer iPageNo{get;set;} 
	public static final String CATEGORY_PARAMETER_NAME = 'c';
	public RCCustomArticleListOrder(){
		getArticleList();
	}
   
   	public String currentURL{
		get {
			return ApexPages.currentPage().getUrl();
		}
		set;
	}
	public String paramByParamId(String paramId, String defaultValue) {
		if (ApexPages.currentPage().getParameters() == null) {
			return defaultValue;
        } else {
            String value = ApexPages.currentPage().getParameters().get(paramId);
            return (value == null) ? defaultValue : value;
        }
    }

    public static RCSiteSetup__c siteSetup {
        get {
            if (siteSetup == null) {
                try {
                    String siteName=null;
                    if(!Test.isRunningTest()){
                       siteName = Site.getName();
                    }else{
                         siteName='rcsupport1';
                    } 
                    if (siteName == null || siteName.length()==0) {
                        siteName = 'rcsupport';
                    }
                    siteSetup = [SELECT RCSiteName__c, RootCategoryName__c, CategoryGroupName__c, CacheMaxAge__c,
                                   Category1Description__c, Category2Description__c, Category3Description__c,
                                   Category4Description__c, Category5Description__c, Category6Description__c,
                                   HomeAdText__c, HomeAdTitle__c, Brand_Filter__c  FROM RCSiteSetup__c
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

   /* public Integer paramByParamId(String paramId, Integer defaultValue) {
        if (ApexPages.currentPage().getParameters() == null) {
            return defaultValue;
        } else {

            String value = ApexPages.currentPage().getParameters().get(paramId);
            return (value == null) ? defaultValue : Integer.valueOf(value);
        }
    }*/
    
    public String getURLCategory() {
        return ApexPages.CurrentPage().getParameters().get('c');
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
    public String getRootCategoryName() {
        return siteSetup.RootCategoryName__c == null ? '' : siteSetup.RootCategoryName__c;
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
      public Long getCacheMaxAge() {
        return siteSetup.CacheMaxAge__c == null ? 0 : Math.roundToLong(siteSetup.CacheMaxAge__c);
    }
     public String getBrandFilter() {
         String brandName=siteSetup.Brand_Filter__c == null ? '' : siteSetup.Brand_Filter__c;
        try{
	         if(brandName!='' && brandName!=null && !brandName.contains('RCProductVesion')){
	                brandName=brandName.split(':').get(1);
	         }
	         if(brandName!='' && brandName!=null && brandName.contains('RCProductVesion')){
	              brandName=brandName.split(',').get(0).split(':').get(1);
	         }
        }catch(Exception e){
        	
        }  
        return brandName;
    }
     public String getRCVersionFilter() {
         String strRCVersion=siteSetup.Brand_Filter__c == null ? '' : siteSetup.Brand_Filter__c;
       try{
         if(strRCVersion!='' && strRCVersion!=null && strRCVersion.contains('RCProductVesion')){
              strRCVersion=strRCVersion.split(',').get(1).split(':').get(1);
         }else{
             strRCVersion='';
         }
       }catch(Exception e){
        	
        }  
        return strRCVersion;
    }
    public String categoryParameterName {
        get {
            return CATEGORY_PARAMETER_NAME;
        }
    }
   public List<RCNEW_Knowledge_Article__c> getArticleList(){
     
     // String strBrand = '%' + getBrandFilter() + '%';
      String strQuery='';
      strQuery=' Select DataCategoryName__c,DataCategoryGroupName__c,r.of_User_Rate_This_Article__c, r.UrlName__c, r.Title__c, '+
               ' r.Summary__c,r.RC_Average_Rating__c, r.PublishStatus__c, r.OwnerId,r.Legacy_Article_ID__c,'+
               ' r.LastPublishedDate__c, r.LastModifiedDate__c, r.LastModifiedDate, r.LastModifiedById,' +
               ' r.KnowledgeArticleId__c, r.Key_Words_c__c, r.IsVisibleInPrm__c,'+ 
               ' r.IsVisibleInPkb__c, r.IsVisibleInCsp__c, r.IsVisibleInApp__c, r.IsDeleted__c, '+
               ' r.Id, r.FirstPublishedDate__c, r.CreatedDate__c, r.CreatedDate, r.CreatedById__c,'+
               ' r.CreatedById, r.Article_Rating_Count__c,DatacategorySelectionParentId__c, '+
               ' Brand__c,Article_List_Order__c From RCNEW_Knowledge_Article__c r where PublishStatus__c=\'Online\' '+
               ' and IsVisibleInPkb__c=true ';
      
      if(getBrandFilter()!=''){
          strQuery=strQuery+' and Brand__c=\''+getBrandFilter()+'\'';
      }
      if(getRCVersionFilter()!=''){
         strQuery=strQuery+' and RCVersion__c=\''+getRCVersionFilter()+'\'';
      }else{
           strQuery=strQuery+' and RCVersion__c=\'RC_Legacy\'';
      }
     if(currentCategory!=null && currentCategory!=''){
            strQuery=strQuery+' and Section__c=\''+currentCategory+'\'';
        }
      strQuery=strQuery+' order by Article_List_Order__c ASC';
      system.debug('>>>>>>>>>>>>>>>>>>>'+strQuery);
        
        List<RCNEW_Knowledge_Article__c> lis= new  List<RCNEW_Knowledge_Article__c>();                                    
        searchResults=new  List<RCNEW_Knowledge_Article__c>();
       //searchResults.clear();
       try{
            lis= DataBase.query(strQuery);   
         }catch(Exception e){
       	
         }
        iRecordSize=lis.size();
        con = new ApexPages.StandardSetController(lis);
           
        con.setPageSize(5);
    
    
     for(RCNEW_Knowledge_Article__c obj2:(List<RCNEW_Knowledge_Article__c>)con.getRecords()){
                 searchResults.add(obj2);
              }


return searchResults;
}

 // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            if(con!=null){
                return con.getHasNext();
            }
            else return false;
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            if(con!=null)
                return con.getHasPrevious(); 
            else return false;
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
    public void first() {
        con.first();
        searchResults.clear();
        for(RCNEW_Knowledge_Article__c obj2:(List<RCNEW_Knowledge_Article__c>)con.getRecords()){
          
             searchResults.add(obj2);
           
          }
    }

    // returns the last page of records
    public void last() {
        con.last();
        searchResults.clear();
        for(RCNEW_Knowledge_Article__c obj2:(List<RCNEW_Knowledge_Article__c>)con.getRecords()){
              searchResults.add(obj2);
           }
           
    }

    // returns the previous page of records
    public PageReference  previous() {
    	 Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');// For IE9 
        con.previous();
        searchResults.clear();
         for(RCNEW_Knowledge_Article__c obj2:(List<RCNEW_Knowledge_Article__c>)con.getRecords()){
              searchResults.add(obj2);
           
          }
         return null;
    }

    // returns the next page of records
    public PageReference  Next() {
    	 Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');// For IE9 
        con.next();
        searchResults.clear();
       for(RCNEW_Knowledge_Article__c obj2:(List<RCNEW_Knowledge_Article__c>)con.getRecords()){
             searchResults.add(obj2);
         }
        //ApexPages.currentPage().setRedirect(true);
        //return(ApexPages.currentPage());
       return null;
    }

 /*public static testmethod void myUnitTest() {
     try{
         RCSiteSetup__c siteSetup1 = new RCSiteSetup__c(RCSiteName__c='rcsupport1',Brand_Filter__c='Brand:RC_US');
         insert siteSetup1;
         
         RCNEW_Knowledge_Article__c objKnowledge=new RCNEW_Knowledge_Article__c(Article_List_Order__c=1);
         objKnowledge.Section__c='Getting_Started';
         objKnowledge.PublishStatus__c='Online';
         objKnowledge.IsVisibleInPkb__c=true;
         objKnowledge.Brand__c='RC_US';
         objKnowledge.RCVersion__c='RC_Legacy';
         insert objKnowledge;
          
         ApexPages.currentPage().getParameters().put('c','Getting_Started');
         ApexPages.currentPage().getParameters().put('retURL','token=12345');
         
        RCCustomArticleListOrder obj=new RCCustomArticleListOrder();
        String strCurrentCategory=obj.currentCategory;
        obj.getAuthToken();
        obj.getCacheMaxAge();
        Boolean value=obj.hasNext;
        value=obj.hasPrevious;
        obj.first();
        obj.last();
        obj.previous();
        obj.Next();
        obj.getURLCategory();
        Integer icount=obj.pageNumber;
        String strValue=obj.categoryParameterName;
        strValue=obj.currentCategoryName;
        obj.con=null;
        value=obj.hasNext;
        value=obj.hasPrevious;
        obj.first();
        obj.last();
        obj.previous();
        obj.Next();
       
         siteSetup1.RCSiteName__c='rcsupport1';
         siteSetup1.Brand_Filter__c='Brand:RC_US,RCProductVesion:RC2012';
        try{
           update siteSetup1;
        }catch(Exception e){
            
        }
         RCCustomArticleListOrder obj2=new RCCustomArticleListOrder();
         obj2.getArticleList();
        
     }catch(Exception e){
        
     }  
  }*/

}