public class SitemapController {
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

 // A method to retrieve the most recent 1000 FAQ__kav articles
	public RC_Knowledge_Article__kav[] getFAQList(){  
		List<RC_Knowledge_Article__kav> objList = new List<RC_Knowledge_Article__kav>();
    	try {
	    	Set<String> setArticleId=new Set<String>();
	    	for(RC_Knowledge_Article__DataCategorySelection objCat:[Select r.Parent.ArticleNumber,r.Parent.KnowledgeArticleId, r.ParentId 
	                                   From RC_Knowledge_Article__DataCategorySelection r where r.Parent.PublishStatus='Online']){
	    		setArticleId.add(objCat.ParentId);  
	  		}
			objList = [Select r.UrlName, r.Title,r.KnowledgeArticleId,r.LastPublishedDate From RC_Knowledge_Article__kav r  where PublishStatus='Online'
	                                            AND id IN:setArticleId AND IsVisibleInPkb = true ORDER BY LastPublishedDate DESC LIMIT 1000];
    	} catch(Exception e) {}
		return objList; 
	}
	
/*	static testMethod void testSitemapController() {
		SitemapController sc = new SitemapController();
		sc.siteUrl = 'http://help.ringcentral.com';
		sc.getFAQList();
		String url  = sc.siteUrl;
	}*/
	
}