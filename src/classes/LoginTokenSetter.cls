public with sharing class LoginTokenSetter {
    //public static string accessTokenValue {get;set;}
    //public static string instanceUrl {get;set;}
    
    /*public static final String ACCESS_TOKEN = 'ACCESS_TOKEN';
    public static final String INSTANCE_VARIABLE = 'Instance_Variable';
    public static final String FIRST_NAME = 'FIRST_NAME';
    public static final String LAST_NAME = 'LAST_NAME';
    public static final String PHOTO_URL = 'PHOTO_URL';*/
    
    public LoginTokenSetter() {
       /* try {
            if(ApexPages.currentPage().getCookies().get(ACCESS_TOKEN).getValue() != null 
                && ApexPages.currentPage().getCookies().get(INSTANCE_VARIABLE).getValue() != null) {
                accessTokenValue = ApexPages.currentPage().getCookies().get(ACCESS_TOKEN).getValue();
                instanceUrl = ApexPages.currentPage().getCookies().get(INSTANCE_VARIABLE).getValue();
           
            }
        } catch(Exception e) {}*/
    }
    
  //  public static Boolean getLoggedInStatus() {
    /*    Boolean loginStatus = getIsLoginRequired();
        return (!loginStatus);*/
  //  }
    
   // public static Boolean getIsLoginRequired(){
       /* try {
            /*if(ApexPages.currentPage().getCookies().get('ACCESS_TOKEN').getValue() != null 
                    && ApexPages.currentPage().getCookies().get('Instance_Variable').getValue() != null) {
                accessTokenValue = ApexPages.currentPage().getCookies().get('ACCESS_TOKEN').getValue();
                instanceUrl = ApexPages.currentPage().getCookies().get('Instance_Variable').getValue();
            }
            */
          /*  if(ApexPages.currentPage().getCookies().get(ACCESS_TOKEN).getValue() != null 
                    && ApexPages.currentPage().getCookies().get(INSTANCE_VARIABLE).getValue() != null) {
                accessTokenValue = ApexPages.currentPage().getCookies().get(ACCESS_TOKEN).getValue();
                instanceUrl = ApexPages.currentPage().getCookies().get(INSTANCE_VARIABLE).getValue();
            }
        } catch(Exception e) {}
        if(ApexPages.currentPage().getCookies().get(ACCESS_TOKEN) == null 
            || ApexPages.currentPage().getCookies().get(ACCESS_TOKEN).getValue() == null 
            || ApexPages.currentPage().getCookies().get(ACCESS_TOKEN).getValue() == '') {
            return true;    
        } 
        return false;*/
    //}
    //private static void setUserDetails(String strInsURL,String strUserDetailsURL,String strAccessToken) {
       /* Http http = new Http();
        HttpRequest req = new HttpRequest();
        if(strUserDetailsURL != '' && strUserDetailsURL != null) {
          strUserDetailsURL = strUserDetailsURL.subString(strUserDetailsURL.indexOf('.com')+4);
        
        }
        req.setEndpoint(strInsURL+strUserDetailsURL);
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + strAccessToken);
        req.setHeader('Content-Type', 'application/json');
        HTTPResponse res = http.send(req);
        string jsonUserDetail =  res.getBody();
        if(res.getStatus() == 'Ok' && res.getStatusCode() == 200) {
             UserJsonObject  userJsonResultObj = getUserDetails(jsonUserDetail);
             if(userJsonResultObj != null) {
                ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(FIRST_NAME,userJsonResultObj.first_name,null,-1,false)});
                ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(LAST_NAME,userJsonResultObj.last_name,null,-1,false)});
                ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(PHOTO_URL,userJsonResultObj.photos.picture,null,-1,false)});
                //getUserProfileId(userJsonResultObj.urls.profile,strAccessToken,strInsURL);
                //getUserProfileId(userJsonResultObj.user_id,strAccessToken,strInsURL);
             }  
        }
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO,res.getBody()));  
        //return res.getBody();*/
    // }
     
   // public static void getUserProfileId(string userId,string strAccessToken, string strInsURL)  {
       /* //System.Debug('>>1>>'+profileURL);
        System.Debug('>>2>>'+strAccessToken);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        //string url = strInsURL + '/services/data/v25.0/sobjects/User/' + userId + '/profile'; describe
        string url = strInsURL + '/services/data/v25.0/sobjects/User/' + userId;
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + strAccessToken);
        req.setHeader('Content-Type', 'application/json');
        HTTPResponse res = http.send(req);
        string jsonUserProfileDetail =  res.getBody();
        System.Debug('>>!@#>>>11'+jsonUserProfileDetail); */      
   // }
    
   // public static UserJsonObject getUserDetails(string jsonUserDetail) {
      /*  try {
             System.Debug('>>UserJson'+jsonUserDetail);
             JSONParser parser = System.JSON.createParser(jsonUserDetail);
             UserJsonObject  userJsonResultObj = (UserJsonObject)parser.readValueAs(UserJsonObject.class);
             System.debug('>>UserDetails1'+userJsonResultObj);
             return userJsonResultObj;
        } catch(Exception ex) { }
        return null;*/
   // }
    
   // public static UserDetailWrapper getUserDetailsCookie() {
      /*  UserDetailWrapper userDetailObj = new UserDetailWrapper();  
        if(ApexPages.currentPage().getCookies().get(FIRST_NAME) != null &&
           ApexPages.currentPage().getCookies().get(LAST_NAME) != null &&
           ApexPages.currentPage().getCookies().get(PHOTO_URL) != null &&
           ApexPages.currentPage().getCookies().get(FIRST_NAME).getValue() != null && 
           ApexPages.currentPage().getCookies().get(FIRST_NAME).getValue() != ''
           && ApexPages.currentPage().getCookies().get(LAST_NAME).getValue() != null &&
           ApexPages.currentPage().getCookies().get(LAST_NAME).getValue() != ''
           && ApexPages.currentPage().getCookies().get(PHOTO_URL).getValue() != null && 
           ApexPages.currentPage().getCookies().get(PHOTO_URL).getValue() != '') {
            userDetailObj.firstName = ApexPages.currentPage().getCookies().get(FIRST_NAME).getValue();
            userDetailObj.lastName = ApexPages.currentPage().getCookies().get(LAST_NAME).getValue();
            userDetailObj.photoUrl = ApexPages.currentPage().getCookies().get(PHOTO_URL).getValue();
        }
        return userDetailObj;*/
   // }
    
   // public class UserDetailWrapper {
     /*   public string firstName;
        public string lastName;
        public string photoUrl;*/
    //}
    
   // public static void setLoginCredentials(String accessToken,String instanceURL2,String strUserDetailUrl ) {
      /*  Integer expires = 3600;
        ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(ACCESS_TOKEN,accessToken ,null,-1,false)});
        ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(INSTANCE_VARIABLE ,instanceURL2 ,null,-1,false)});
        setUserDetails(instanceURL2,strUserDetailUrl,accessToken);*/
   // }
    
  // @isTest(SeeAllData=true)
 //  static  void LoginTokenSetterTest() {
   		//	LoginTokenSetter loginObj = new LoginTokenSetter();
          /*  LoginTokenSetter.getUserDetails('{"id":"https://test.salesforce.com/id/00DV00000051cC4MAI/00580000003d9rBAAQ","asserted_user":true,"user_id":"00580000003d9rBAAQ","organization_id":"00DV00000051cC4MAI","username":"rcindia@simplion.com.box3","nick_name":"IndiaTm","display_name":"India Team","email":"virendra.singh@simplion.com","first_name":"India","last_name":"Team","status":{"created_date":null,"body":null},"photos":{"picture":"https://c.cs12.content.force.com/profilephoto/729V00000008QMe/F","thumbnail":"https://c.cs12.content.force.com/profilephoto/729V00000008QMe/T"},"urls":{"enterprise":"https://cs12.salesforce.com/services/Soap/c/{version}/00DV00000051cC4","metadata":"https://cs12.salesforce.com/services/Soap/m/{version}/00DV00000051cC4","partner":"https://cs12.salesforce.com/services/Soap/u/{version}/00DV00000051cC4","rest":"https://cs12.salesforce.com/services/data/v{version}/","sobjects":"https://cs12.salesforce.com/services/data/v{version}/sobjects/","search":"https://cs12.salesforce.com/services/data/v{version}/search/","query":"https://cs12.salesforce.com/services/data/v{version}/query/","recent":"https://cs12.salesforce.com/services/data/v{version}/recent/","profile":"https://cs12.salesforce.com/00580000003d9rBAAQ","feeds":"https://cs12.salesforce.com/services/data/v{version}/chatter/feeds","groups":"https://cs12.salesforce.com/services/data/v{version}/chatter/groups","users":"https://cs12.salesforce.com/services/data/v{version}/chatter/users","feed_items":"https://cs12.salesforce.com/services/data/v{version}/chatter/feed-items","custom_domain":"https://rc--box3.cs12.my.salesforce.com"},"active":true,"user_type":"STANDARD","language":"en_US","locale":"en_US","utcOffset":-28800000,"last_modified_date":"2012-06-12T12:15:35.000+0000"}');
            LoginTokenSetter.getUserDetails('{"id":"https://test.salesforce.com/id/00DV00000051cC4MAI/00580000003d9rBAAQ"} ');
            LoginTokenSetter.setLoginCredentials(null, null, null); 
            LoginTokenSetter.setUserDetails('www.dot.com', 'www.dot.com', null);*/
            
   //}
  
  /* @isTest(SeeAllData=true)
   static  void LoginTokenSetterTest0() {
       Cookie accTokenCookie = new Cookie('ACCESS_TOKEN', 'test', null, -1, false);
       Cookie intVariableCookie = new Cookie('Instance_Variable', 'test' , null, -1, false);
       Cookie fnVariableCookie = new Cookie('FIRST_NAME', 'test' , null, -1, false);
       Cookie lnVariableCookie = new Cookie('LAST_NAME', 'test' , null, -1, false);
       Cookie fuVariableCookie = new Cookie('PHOTO_URL', 'test' , null, -1, false);
       
       ApexPages.currentPage().setCookies(new Cookie[]{accTokenCookie}); 
       ApexPages.currentPage().setCookies(new Cookie[]{intVariableCookie}); 
       ApexPages.currentPage().setCookies(new Cookie[]{fnVariableCookie});
       ApexPages.currentPage().setCookies(new Cookie[]{lnVariableCookie});
       ApexPages.currentPage().setCookies(new Cookie[]{fuVariableCookie});
       
       LoginTokenSetter ls = new LoginTokenSetter();
       LoginTokenSetter.getLoggedInStatus();
       LoginTokenSetter.getUserDetailsCookie();
       LoginTokenSetter.getUserProfileId(null, null, null);
       
   }*/
}