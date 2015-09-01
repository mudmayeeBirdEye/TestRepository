public class ChatterPostUtil{
  
  public ChatterPostUtil() {
  	
  }
  
  //public static String cookieName = 'chattersession';
  
  //public static String getUserFeedItem(){
  
       /* Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getFeedItemsEndPointURL());
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + ChatterAccessToken.getChatterAccessToken());
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        HTTPResponse res = http.send(req);
       // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,res.getBody()));  
        return res.getBody();*/
  
  //}

  //public Static void likePost(String strLikeId){
     
      /*  Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getFeedItemsLikeEndPointURL(strLikeId));
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + ChatterAccessToken.getChatterAccessToken());
         req.setTimeout(60000);
        //req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
   
        HTTPResponse res = http.send(req);
       //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Successfully Post=='+res.getStatusCode())); 
        if(res.getStatusCode() != 200) {
            System.debug('Error POSTing to Graph: '+res);
            System.debug('Request: '+req);
            System.debug('Body: ' + req.getBody());
            throw new ChatterException('ChatterPostUtil received '+res.getStatusCode()+' '+res.getStatus()+'\n'+req.getBody());
        }*/
  
  
  //}
  
  //public Static void UNLikePost(String strLikeId){
     
       /* Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getFeedItemsUnLikeEndPointURL(strLikeId));
        req.setMethod('DELETE');
         req.setTimeout(60000);
        req.setHeader('Authorization', 'OAuth ' + ChatterAccessToken.getChatterAccessToken());
        //req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
   
        HTTPResponse res = http.send(req);
       //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Successfully Post=='+res.getStatusCode())); 
        if(res.getStatusCode() != 200) {
            throw new ChatterException('ChatterPostUtil received '+res.getStatusCode()+' '+res.getStatus()+'\n'+req.getBody());
        }*/
  //}
  
  // public Static void updateStatus(String strContent){
     /*   Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getUpdateStatusPostCommentEndPointURL(strContent));
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + ChatterAccessToken.getChatterAccessToken());
        req.setTimeout(60000);
        req.setHeader('Content-Type::', 'text');
        HTTPResponse res = http.send(req);
       if(res.getStatusCode() != 200) {
            throw new ChatterException('ChatterPostUtil received '+res.getStatusCode()+' '+res.getStatus()+'\n'+req.getBody());
        }*/
   //}
   //public Static void postComment(String strFeedItemId,String strURL,String strContent){
     
     /*   Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getFeedItemsPostCommentEndPointURL(strFeedItemId,strURL,strContent));
        req.setMethod('POST');
        req.setHeader('Authorization', 'OAuth ' + ChatterAccessToken.getChatterAccessToken());
         req.setTimeout(60000);
        //req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type::', 'text');
       // req.setBody('{ "body" : { "messageSegments" : [{ "type": "Text","text" : strContent}]}}');
      // String accountsJSON = JSON.serializePretty(strContent);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'==unLikePost=='+getFeedItemsPostCommentEndPointURL(strFeedItemId,strURL,strContent))); 
       // req.setBody(accountsJSON );
        HTTPResponse res = http.send(req);
       //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Successfully Post=='+res.getStatusCode())); 
        if(res.getStatusCode() != 200) {
            throw new ChatterException('ChatterPostUtil received '+res.getStatusCode()+' '+res.getStatus()+'\n'+req.getBody());
        }*/
  //}
 //  public Static String getCurrentUserDetails(){
       /* Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getCurrentUserDetailsEndPointURL());
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + ChatterAccessToken.getChatterAccessToken());
        req.setTimeout(60000);
        req.setHeader('Accept', 'application/json');
        HTTPResponse res = http.send(req);
       //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Successfully Post=='+res.getStatusCode())); 
        if(res.getStatusCode() != 200) {
            throw new ChatterException('ChatterPostUtil received '+res.getStatusCode()+' '+res.getStatus()+'\n'+req.getBody());
        }
     return res.getBody();*/
  // }
   // public Static String searchFeedItem( String strContent){
     /*   Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getSearchFeedItemEndPointURL(strContent));
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + ChatterAccessToken.getChatterAccessToken());
        req.setTimeout(60000);
       // req.setHeader('Accept', 'application/json');
         req.setHeader('Content-Type', 'application/json');
        HTTPResponse res = http.send(req);
     return res.getBody();*/
  // }
    //public Static String getAllFeedItemComments( String strFeedItemId){
      /*  Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getAllFeedItemCommentsEndPointURL(strFeedItemId));
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + ChatterAccessToken.getChatterAccessToken());
        req.setTimeout(60000);
       // req.setHeader('Accept', 'application/json');
         req.setHeader('Content-Type', 'application/json');
        HTTPResponse res = http.send(req);
     return res.getBody();*/
  // }
   // private Http getHTTPObject(){
      /*  Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(getFeedItemsEndPointURL());
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + ChatterAccessToken.getChatterAccessToken());
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        return http;*/
    //}
   
    /*public String getFeedItemsEndPointURL(){
      return( ChatterAccessToken.getChatterInstanceURL()+'/services/data/v24.0/chatter/feeds/news/me/feed-items?pageSize=100');
   } */
       //public static String getAllFeedItemCommentsEndPointURL(String strFeedItemId){
      //return(ChatterAccessToken.getChatterInstanceURL()+'/services/data/v24.0/chatter/feed-items/'+strFeedItemId+'/comments');
   //}
   //public static String getSearchFeedItemEndPointURL(String strContent){
     /* return(ChatterAccessToken.getChatterInstanceURL()+'/services/data/v24.0/chatter/feed-items?q='+strContent+'*');*/
   //}
   //public static String getCurrentUserDetailsEndPointURL(){
     /* return(ChatterAccessToken.getChatterInstanceURL()+'/services/data/v24.0/chatter/users/me');*/
   //}
  //  public static String getFeedItemsEndPointURL(){
    /*  return( ChatterAccessToken.getChatterInstanceURL()+'/services/data/v24.0/chatter/feeds/news/me/feed-items?pageSize=100');*/
  // }
   //public static String getFeedItemsLikeEndPointURL(String strId){
    /*  return( ChatterAccessToken.getChatterInstanceURL()+'/services/data/v24.0/chatter/feed-items/'+strId+'/likes');*/
  // }
   // public static String getFeedItemsUnLikeEndPointURL(String strId){
     /* return( ChatterAccessToken.getChatterInstanceURL()+'/services/data/v24.0/chatter/likes/'+strId);*/
   //}
   // public static String getFeedItemsPostCommentEndPointURL(String strFeedCommentId,String strURL,String strContent){
    /*  return( ChatterAccessToken.getChatterInstanceURL()+'/services/data/v24.0/chatter/feed-items/'+strFeedCommentId+'/comments?text='+strContent);*/
   //}
    //public static String getUpdateStatusPostCommentEndPointURL(String strContent){
     /* return( ChatterAccessToken.getChatterInstanceURL()+'/services/data/v24.0/chatter/feeds/news/me/feed-items?text='+strContent);*/
   //}
   //public String getUserDetailsEndPointURL(){
    /*  return('https://na14.salesforce.com/services/data/v24.0/chatter/users/me');*/
   //}
   
   //@isTest(SeeAllData=true)
  // static  void ChatterPostUtilTest() {
   		//ChatterPostUtil chObj = new ChatterPostUtil();
   		/*ChatterPostUtil.getUserFeedItem();
   		ChatterPostUtil cpu =  new ChatterPostUtil();
   		cpu.getUserDetailsEndPointURL();
   		cpu.getHTTPObject();
   		cpu.getUserDetailsEndPointURL();*/
   //}
   
   /* @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest0() {
   	ChatterPostUtil.likePost('test');
   	   }
   @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest1() {
      	ChatterPostUtil.UNLikePost('test');
   }
   @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest2() {
      	ChatterPostUtil.getCurrentUserDetails();
   }
   @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest3() {
      	ChatterPostUtil.postComment(null, null, null);
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest4() {
      ChatterPostUtil.updateStatus('test');
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest5() {
      	ChatterPostUtil.searchFeedItem('test');
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest6() {
      	ChatterPostUtil.getAllFeedItemComments('test');
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest7() {
      	 		ChatterPostUtil.getAllFeedItemCommentsEndPointURL('test');
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest8() {
      	ChatterPostUtil.getSearchFeedItemEndPointURL('test');
   }
   
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest9() {
      	ChatterPostUtil.getCurrentUserDetailsEndPointURL();
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest10() {
      ChatterPostUtil.getFeedItemsLikeEndPointURL('test');
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest11() {
      	ChatterPostUtil.getFeedItemsUnLikeEndPointURL('test');
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest12() {
      		ChatterPostUtil.getFeedItemsPostCommentEndPointURL(null, null, null);
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest13() {
      		ChatterPostUtil.getUpdateStatusPostCommentEndPointURL('test');
   		
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest14() {
      		new ChatterPostUtil().getUserDetailsEndPointURL();
   		
   }
    @isTest(SeeAllData=true)
   static  void ChatterPostUtilTest15() {
      		new ChatterPostUtil().getHTTPObject();
   		
   }*/
   
}