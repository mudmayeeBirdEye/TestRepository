public class IdeaAndAnswerForumController{
public  String strPostFix='_IDEAANDANSWERFORUM';
public  String strPreFix='_IDEAANDANSWERFORUM';
//public  String strPostFix='';
public String str{get;set;}
public Boolean isGuestUser{get;set;}
public String strSeesionId{get;set;}
public Boolean isTokenFound{get;set;}
public String strPageUrl{get;set;}

public IdeaAndAnswerForumController(){
	 isTokenFound=isValidTokenFound();
} 
  public PageReference getIdeaURL() {
        PageReference objPageRef=null;
       
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
             //objPageRef=new PageReference('https://service.ringcentral.com/login.asp?p_next_page=IDEAANDANSWERFORUM');
             objPageRef=new PageReference('https://service.ringcentral.com/login.asp?p_next_page=IDEAANDANSWERFORUM');
            
            objPageRef.setRedirect(true);
            return objPageRef;
         } else {
              String strSite=Site.getCurrentSiteUrl()+'?'+getAuthToken(); 
           
             String strToken1='&startURL=/apex/IdeaAndAnswerForumRedirectPage?siteUrl='+strSite;
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
                 ideaURL= 'https://cs12.salesforce.com/secur/login_portal.jsp?orgId=00DV00000051pTK&portalId=06080000000EWip&'+tokenVal+''+strToken1;
               } catch (Exception ex) {
                tokenVal =  ex.getMessage();
                ideaURL= 'false';
               // objPageRef=new PageReference('https://service.ringcentral.com/login.asp?p_next_page=IDEAANDANSWERFORUM');
                objPageRef=new PageReference('https://service.ringcentral.com/login.asp');
                objPageRef.setRedirect(true);
                return objPageRef;
            }
         } 
            objPageRef=new PageReference(ideaURL);
            objPageRef.setRedirect(true);
            return objPageRef;        
       
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

  	
    
public Pagereference login(){
	if(isTokenFound==true){
		return validateLoginDetail();
	}else{
			PageReference objPage=new PageReference('https://service.ringcentral.com/login.asp');
			objPage.getParameters().put('p_next_page',getNextPageName());
			objPage.setRedirect(true);
			return objPage;
	 }
	return null;
}
public Pagereference PageAuthorization(){
	if(UserInfo.getUserType()=='Guest'){
		isGuestUser=true;
	}else{
		isGuestUser=false;
		return null;
	}//strPageUrl=ApexPages.currentPage().getUrl();
	//return null;
	if(isTokenFound!=true){
	 return login();
	} 
return null;	
}  
 public Pagereference validateLoginDetail(){
	  try{
	   if(isTokenFound==true ){
	   	 ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'call');
            ApexPages.addMessage(msg);
         String tokenVal=getValidToken();   
          if(tokenVal!=null && tokenVal!=''){
          	String loginToken=tokenVal;
		    string username;
			string password;
			
			if(loginToken != null) {
				String[] strSplitToken = loginToken.split('&');
				username = 	strSplitToken[0].split('=')[1];
				password = 	strSplitToken[1].split('=')[1];
				str=username+password;
			}
			String strPage = ApexPages.CurrentPage().getParameters().get('NEXTPAGE');
			if(strPage!=null && strPage!='' && strPage.indexOf(strPreFix)>=0){
				strPage='/'+strPage.removeStartIgnoreCase(strPreFix);
				System.Debug('>>>112>>>'+strPage);
			}
			System.Debug('>>>113>>>'+strPage);
			//Pagereference pageRef= Site.login(username,password, ''+getRetPageName());
			Pagereference pageRef= Site.login(username,password, ''+strPage);
			//Pagereference pageRef= Site.login(username,password, '/RCSupportPortalSearch');
			pageRef.setRedirect(true);
			return pageRef;
	 }
	   } 
	  //} 
	  }catch(Exception e){} 
	return null;
}
  public String getNextPageName(){
       String strPage=null;
      
       if(ApexPages.currentPage().getParameters().get('startURL')!=null && ApexPages.currentPage().getParameters().get('startURL')!=''){
		strPage=ApexPages.currentPage().getParameters().get('startURL');
		if(strPage!=null && strPage!='' && strPage.indexOf('/')>=0){
			strPage=strPage.substringAfterLast('/');
			if(strPage.indexOfIgnoreCase('Question')>-1){
				strPage='answers/'+strPage;
			}else if(strPage.indexOfIgnoreCase('idea')>-1){
				strPage='ideas/'+strPage;
			}
			return strPreFix+strPage;
		}
		
	}
	return strPreFix+'RCAnswerAndIdeaForumPage';
}  
  public String getValidToken(){
	  //try{
	  String strToken = ApexPages.CurrentPage().getParameters().get('token');
	   if(strToken!=null && strToken!=''){
	 	    String tokenUrlDecoded = EncodingUtil.urlDecode(strToken, 'UTF-8');
            tokenUrlDecoded = tokenUrlDecoded.replaceAll(' ', '+');
            Blob tokenDecodedBases64 = Encodingutil.base64Decode(tokenUrlDecoded);          
            Blob cryptoKey = Blob.valueOf('v7Y2g2webAqutAcr4DEC3uTAnaspEgA8');
            Blob initVector = Blob.valueof('da4atrABufastacr');
            // Decrypt the data
            Blob decryptedData = Crypto.decrypt('AES256', cryptoKey, initVector, tokenDecodedBases64);
            String tokenVal = decryptedData.toString();    
                // it is fixed for mul
           return tokenVal;
	   }
	  //}catch(Exception e){}
	   return null;  
	
}  

public Boolean isValidTokenFound(){
	 String strToken =getValidToken();
	 if(strToken!=null && strToken!=''){
	 	return true;
	 }
	return false;
}

public String getCommunityId(){
   
   String strReturnString='false';
   for(Community objCommunity : [SELECT Id FROM Community WHERE Name = 'RingCentral Customer Community' limit 1 ]){
         strReturnString=objCommunity.id;
    }
   return strReturnString;
   }    
    
    


}