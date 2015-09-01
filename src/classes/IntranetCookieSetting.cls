public with sharing class IntranetCookieSetting {
     //public String instanceUrl { get; set;}
     //public String a_token { get; set;}
     
    public IntranetCookieSetting() {
    	
    } 
     
    /* public String json { get; set; }
     public String token { get; set; }
        
    
    
    public PageReference tokenSetting() {
        redirectLibSearch();
        String strContentPageName='/';
        Pagereference objPage=new Pagereference (strContentPageName); 
        // objPage.getParameters().put('nooverride','0');
        objPage.setRedirect(true);
        return objPage;
    }
    
    
    public static String accessTokenValue {get;set;}
    public static String instanceUrl {get;set;}
    
    public void setCookieAOuthCode() {
       Cookie accTokenCookie = new Cookie('ACCESS_TOKEN', accessTokenValue, null, -1, false);
       Cookie intVariableCookie = new Cookie('Instance_Variable', instanceUrl , null, -1, false);
       ApexPages.currentPage().setCookies(new Cookie[]{accTokenCookie}); 
       ApexPages.currentPage().setCookies(new Cookie[]{intVariableCookie}); 
   }
   
   public void redirectLibSearch() {
        String strToken = token;
        if(strToken != null && strToken != '') {
                innerParamObj = (InnerParameters)System.JSON.deserialize(strToken, InnerParameters.class);
                accessTokenValue = innerParamObj.access_token;
                instanceUrl = innerParamObj.instance_url;
                setCookieAOuthCode();
        }
   }
   
    
   public static InnerParameters innerParamObj {get;set;}
  
   public class InnerParameters {
       public string access_token  {get;set;}
       public string instance_url  {get;set;}
       public string issued_at  {get;set;}
       public string signature  {get;set;}
       public string scope  {get;set;}
       public string id {get;set;}
   } 
   
  /*Test Methods*/
 // static testMethod void IntranetCookieSettingTest() {
  //  IntranetCookieSetting intratest = new IntranetCookieSetting();
   /* intratest.tokenSetting();
    String temp0  = IntranetCookieSetting.accessTokenValue;
    String temp1  = IntranetCookieSetting.instanceUrl;
    intratest.setCookieAOuthCode();
    intratest.token = '{ "id":"005x00000012Q9P","issued_at":"1278448384422","instance_url":"abc","signature":"SSSbLO",  "access_token":"00Dx0000000BV7z","scope":"full"}';              
    intratest.redirectLibSearch();
    IntranetCookieSetting.innerParamObj  = new IntranetCookieSetting.InnerParameters();*/
  //} 
   
}