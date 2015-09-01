public class ChatterAccessToken{
   // public static String cookieName = 'chattersession';
   // public static String instanceURL = 'instanceURL';
   // public static String cookieName = 'ACCESS_TOKEN';
   // public static String instanceURL = 'Instance_Variable';
    
    public ChatterAccessToken() {
    	
    }
    
   // public static String getChatterAccessToken(){
   /* if(ApexPages.currentPage().getCookies().get(cookieName)==null){
      return null;
    }
       return(ApexPages.currentPage().getCookies().get(cookieName).getValue());*/
  //  }
   // public static void deleteChatterAccessToken(){
      /*   ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(cookieName,null,null,0,false)});
         ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(instanceURL ,null,null,0,false)});*/
   // }
    // public static String getChatterInstanceURL(){
       /* if(ApexPages.currentPage().getCookies().get(instanceURL )==null){
          return 'https://cs12.salesforce.com';
        }
       return(ApexPages.currentPage().getCookies().get(instanceURL).getValue());*/
   // }
  //  public static void setChatterAccessToken(String accessToken,String instanceURL2 ){
       /* Integer expires = 3600;
        ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(cookieName,accessToken ,null,-1,false)});
        ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(instanceURL ,instanceURL2 ,null,-1,false)});*/
  //  }

  /* @isTest(SeeAllData=true)
   static  void ChatterAccessTokenTest() {
   		ChatterAccessToken chatterObj = new ChatterAccessToken();
      /* Cookie accTokenCookie = new Cookie('ACCESS_TOKEN', 'test', null, -1, false);
       Cookie intVariableCookie = new Cookie('Instance_Variable', 'test' , null, -1, false);
       
       ApexPages.currentPage().setCookies(new Cookie[]{accTokenCookie}); 
       ApexPages.currentPage().setCookies(new Cookie[]{intVariableCookie}); 
      		
      		ChatterAccessToken.getChatterAccessToken();
   			ChatterAccessToken.deleteChatterAccessToken();
   			ChatterAccessToken.getChatterInstanceURL();
   			ChatterAccessToken.setChatterAccessToken(null, null);*/
 //  }
   
  /* @isTest(SeeAllData=true)
   static  void ChatterAccessTokenTest1() {
      	ChatterAccessToken.getChatterInstanceURL();
   		
   }*/

}