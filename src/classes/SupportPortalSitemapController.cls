public class SupportPortalSitemapController {
    // A property to return the proper Sites URL, used to build our full URL later
  public string siteUrl{
    get{
      String surl = site.getcustomwebaddress();
      if (surl != '' && surl != null) {
          return site.getcustomwebaddress();
      } else {
          return site.getcurrentsiteurl();
      }
    }
    set;
  }
  public Boolean getUKPortal(){
  	 if(Site.getName()!=null && Site.getName()!='' && (Site.getName()).lastIndexOfIgnoreCase('RCSupportPortalUK')>-1){ 
  	 	return true;
  	 }
  	return false;
  }
 // A method to retrieve the most recent 1000 FAQ__kav articles
  public RC_Knowledge_Article__kav[] getFAQList(){  
    List<RC_Knowledge_Article__kav> objList = new List<RC_Knowledge_Article__kav>();
      try {
        Set<String> setArticleId=new Set<String>();
        Boolean isUKPortal=getUKPortal();
        
        for(RC_Knowledge_Article__DataCategorySelection objdata:[Select r.Parent.ArticleNumber,r.Parent.KnowledgeArticleId, r.ParentId,
                                   r.DataCategoryGroupName,r.DataCategoryName  From RC_Knowledge_Article__DataCategorySelection r where r.Parent.PublishStatus='Online']){
        
         if(isUKPortal && objdata.DataCategoryGroupName=='RCProductVesion' && (objdata.DataCategoryName=='ALL' || objdata.DataCategoryName=='RCUK2013')){
        	  setArticleId.add(objdata.ParentId);
         }else if(!isUKPortal && objdata.DataCategoryGroupName=='RCProductVesion' && (objdata.DataCategoryName=='ALL' || objdata.DataCategoryName=='RC2013') ){
              setArticleId.add(objdata.ParentId);
          } 
          
          
        }
      objList = [Select r.UrlName, r.Title,r.KnowledgeArticleId,r.LastPublishedDate,Ranking__c From RC_Knowledge_Article__kav r  where PublishStatus='Online'
                                              AND id IN:setArticleId AND IsVisibleInPkb = true ORDER BY Ranking__c,LastPublishedDate DESC];
      } catch(Exception e) {}
    return objList; 
  }
}