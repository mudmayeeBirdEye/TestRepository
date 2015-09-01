global class ChatterLoginController{
  /* public static String cookieName = 'chattersession';
   public String strToken{get;set;}
   public String strInstanceURL{get;set;}
   public Boolean isTokenExist{get;set;}
   public String error{get;set;}
   public String strSearchFeed{get;set;}
   public Boolean isAjax{get;set;}
   public String CurrentUserDetails{get;set;}*/
   
   public ChatterLoginController(){
   /*  try{
      if(ChatterAccessToken.getChatterAccessToken()==null){
        isTokenExist=false;
      }else{
        isTokenExist=true;
        CurrentUserDetails=ChatterPostUtil.getCurrentUserDetails(); 
      }
      
     }catch(Exception e){
        isTokenExist=false;
        ChatterAccessToken.deleteChatterAccessToken();
     } 
      isAjax=false;*/
   }
   
	/*public pageReference login(){
    try{
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,''+ApexPages.currentPage().getHeaders().get('access_token')));   
        //return null;
     if(ApexPages.currentPage().getparameters().get('access_token')!=null && ApexPages.currentPage().getparameters().get('access_token')!=''){
             String strAccessToken=ApexPages.currentPage().getparameters().get('access_token');
             String strInstanceURL=ApexPages.currentPage().getparameters().get('instance_url');
             String userDetailsUrl=ApexPages.currentPage().getparameters().get('id');
              LoginTokenSetter.setLoginCredentials(strAccessToken,strInstanceURL,userDetailsUrl);
            //PageReference objPage=new PageReference('/chatterdetails'); 
            PageReference objPage=new PageReference('/intranetChatterHomePage');       
            objPage.setRedirect(true);
          return objPage;
       }else if(ChatterAccessToken.getChatterAccessToken()==null) {
   			try {
	    	IntranetPortal__c intPortalCS = IntranetPortal__c.getValues('portalsite');
	    	if(intPortalCS != null && intPortalCS.token__c != null && intPortalCS.orgURL__c != null && intPortalCS.SiteURL__c != null) {
	    		String token = intPortalCS.token__c;
	    		string orgURL = intPortalCS.orgURL__c;
	    		string returnURL = 	intPortalCS.SiteURL__c;
	    		PageReference objPage=new PageReference(orgURL+token+returnURL);
	        	objPage.setRedirect(true);
	        	return objPage;
	    	}
    	} catch(Exception ex) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Set/Check your Intranet Portal Site Custom Settings'));
    	}
       }
       else{
            PageReference objPage=new PageReference('/chatterHomePage');    
            objPage.setRedirect(true);
           return objPage;
       }
      }catch(Exception e){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,e.getMessage()+'=='+e.getLineNumber()));      
      } 
     return null;  
}
 public pageReference likePost(){
  String strPostId='';
   try{
       strPostId=ApexPages.currentPage().getparameters().get('strPostId');
       ChatterPostUtil.likePost(strPostId);
        
    }catch(Exception e){ error = e.getMessage();}
    ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'===='+strPostId)); 
    return null;
  }
 public pageReference unLikePost(){
    String strPostId='';
   try{
       strPostId=ApexPages.currentPage().getparameters().get('strPostId2');
       ChatterPostUtil.UNLikePost(strPostId);
      }catch(Exception e){ 
         error = e.getMessage();
      }
       ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'==unLikePost=='+strPostId)); 
    return null;
  }
   
    /*public String getUserFeedComment(){
       return ChatterPostUtil.getUserFeedItem();
  }*/
 /* public String getUserFeedComment(){
    //return 'test';
    try{
        return ChatterPostUtil.getUserFeedItem();
      }catch(Exception e){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,e.getMessage())); 
       return(e.getMessage());
      }
      return null;  
  }
  public pageReference updateStatus(){
     String strPostId='';
      try{
          String strContent=ApexPages.currentPage().getparameters().get('strPostContent');
          ChatterPostUtil.updateStatus(strContent);
      }catch(Exception e){ 
         error = e.getMessage();
      }
  
  return null;
  }
 public pageReference postComments(){
    String strPostId='';
   try{
       strPostId=ApexPages.currentPage().getparameters().get('strFeedItemId');
       String strPostURL=ApexPages.currentPage().getparameters().get('strPostURL');
       String strContent=ApexPages.currentPage().getparameters().get('strPostContent');
       ChatterPostUtil.postComment(strPostId,strPostURL,strContent);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'==unLikePost=='+strContent)); 
      }catch(Exception e){ 
         error = e.getMessage();
      }
      
    return null;
  }
    public pageReference searchFeedItem(){
     String strPostId='';
     strSearchFeed='';
     try{
           String strContent=ApexPages.currentPage().getparameters().get('strSearchContent');
           strSearchFeed=ChatterPostUtil.searchFeedItem(strContent);
           ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'==unLikePost=='+strContent)); 
      }catch(Exception e){ 
         error = e.getMessage();
      }
      
    return null;
   }
   
   public String strAllComment{get;set;}
     public String strfeedItemId{get;set;}
    public pageReference showAllComments(){
      try{
         strfeedItemId=ApexPages.currentPage().getparameters().get('feedItemId');
         strAllComment=ChatterPostUtil.getAllFeedItemComments(strfeedItemId);
          ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'==strfeedItemId=='+strfeedItemId));
      }catch(Exception e){}
     
     return null;
    }
   
  /*public String getCurrentUserDetails(){
     try{
         return ChatterPostUtil.getCurrentUserDetails();
      }catch(Exception e){
         return e.getMessage();
      }
      return '';
  }*/
  /* public pageReference login3(){
       PageReference objPage=new PageReference('/chatterLoginPage');  
        objPage.setRedirect(true);
        return objPage; 
  }
   public pageReference login2(){
 
  PageReference objPage=new PageReference('https://login.salesforce.com/services/oauth2/authorize');        
          objPage.getParameters().put('response_type','token');
          objPage.getParameters().put('client_id','3MVG9rFJvQRVOvk5B0GwG9V14d..I4.4HH9Ox9ienLsgLImXKOKFSN4pipivK5LP1VoR1ngF_OoOgoXTTtmvI');
          objPage.getParameters().put('redirect_uri','https://kanishkassignment-developer-edition.na14.force.com/chatter');
          objPage.getParameters().put('display','popup');
          //objPage.getParameters().put('scope','chatter_api');
          objPage.setRedirect(true);
         // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'=='+objPage));    
          // return null; 
          return objPage; 
 
 }  
   public String getToken(){
   try{
      return ChatterAccessToken.getChatterAccessToken();
      }catch(Exception e){
       
      }
     return '';
  }  */
   /*Test Method*/ 
   /*@isTest(SeeAllData=true)
   static  void ChatterLoginControllerTest() {
   		ChatterLoginController clc = new ChatterLoginController(); 
         //PageReference pageRef = Page.intranetChatterHomePage;
       /*  Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getparameters().put('access_token','test');
            ApexPages.currentPage().getparameters().put('instance_url','test');
            ApexPages.currentPage().getparameters().put('id','test');
        
        ChatterLoginController clc = new ChatterLoginController();  
        clc.login();
        clc.likePost();
        clc.login2();
        clc.login3();
        clc.unLikePost();
        clc.updateStatus();
        clc.getUserFeedComment();
        clc.postComments();
        clc.showAllComments();
        clc.searchFeedItem();
        clc.showAllComments();
        clc.getToken(); */
         
   //}
            
}