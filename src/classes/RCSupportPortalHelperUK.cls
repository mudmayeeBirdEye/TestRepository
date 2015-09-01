public class RCSupportPortalHelperUK{

public String str{get;set;}
public Boolean isGuestUser{get;set;}
public String strSeesionId{get;set;}
public Boolean isTokenFound{get;set;}
public String strPageUrl{get;set;}
//public  String strPostFix='_rccustomer';
public  String strPostFix='';
public User objUser{get;set;}
public String strLCClassName{get;set;}


public RCSupportPortalHelperUK(){
if(UserInfo.getUserType()=='Guest'){
        isGuestUser=true;
    }else{
        isGuestUser=false;
    }
    
    isTokenFound=isValidTokenFound();

}


public Pagereference validateLoginDetail(){
      try{
       if(isTokenFound==true ){
          /*if(!(getURLProtocol().equalsIgnoreCase('https'))){
              String strUrl=URL.getCurrentRequestUrl().toExternalForm();
              strUrl=strUrl.replaceFirst('http','https');
              strUrl=strUrl+'?'+URL.getCurrentRequestUrl().getQuery();
              Pagereference objPage=new Pagereference(strUrl);
              objPage.setRedirect(true);
              return objPage;
          }*/
        
         String tokenVal=getValidToken();   
          if(tokenVal!=null && tokenVal!=''){
            String loginToken=tokenVal;
            string username;
            string password;
            
            if(loginToken != null) {
                String[] strSplitToken = loginToken.split('&');
                username =  strSplitToken[0].split('=')[1];
                password =  strSplitToken[1].split('=')[1];
                str=username+password;
            }
            String strPage = ApexPages.CurrentPage().getParameters().get('NEXTPAGE');
            System.Debug('>>>111>>>'+strPage);
            if(strPage!=null && strPage!='' && strPage.indexOf(strPostFix)>=0){
                strPage='/'+strPage.removeEndIgnoreCase(strPostFix);
                System.Debug('>>>112>>>'+strPage);
            }else if(ApexPages.CurrentPage().getParameters().get('ARTICLENAME')!=null && ApexPages.CurrentPage().getParameters().get('ARTICLENAME')!=''){
                 strPage='';
                 strPage='/articles/RC_Knowledge_Article/'+ApexPages.CurrentPage().getParameters().get('ARTICLENAME');
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


public Pagereference login(){
    if(isTokenFound==true){
        return validateLoginDetail();
    }else{
            //PageReference objPage=new PageReference('http://sp2.ringcentral.com/login/login.php');
            PageReference objPage=new PageReference('https://service.ringcentral.co.uk/login.asp');
            objPage.getParameters().put('p_next_page',getNextPageName());
            objPage.setRedirect(true);
            return objPage;
     }
    return null;
}
public String getNextPageName(){
       String strPage=null;
      
       if(ApexPages.currentPage().getParameters().get('startURL')!=null && ApexPages.currentPage().getParameters().get('startURL')!=''){
        strPage=ApexPages.currentPage().getParameters().get('startURL');
        if(strPage!=null && strPage!='' && strPage.indexOf('/')>=0){
            strPage=strPage.substringAfterLast('/');
            return strPage+strPostFix;
        }
        
    }
    return 'RCSupportPortalHome'+strPostFix;
}

	public Boolean getUKPortal(){
		if(Site.getName() != null && Site.getName()!='' && (Site.getName()).lastIndexOfIgnoreCase('RCSupportPortalUK')>-1){
			return true;
		}
		return false;
	}



public String strUserType{get;set;}

public Pagereference PageAuthorization(){
    if(UserInfo.getUserType()=='Guest'){
        isGuestUser=true;
    }else{
        isGuestUser=false;
        return null;
    }//strPageUrl=ApexPages.currentPage().getUrl();
    //return null;
    return login();
} 

public Pagereference getPageAuthorization(){
    if(UserInfo.getUserType()=='Guest'){
        isGuestUser=true;
    }else{
        isGuestUser=false;
        return null;
    }//strPageUrl=ApexPages.currentPage().getUrl();
    //return null;
    return login();
}

public Boolean isValidTokenFound(){
     String strToken =getValidToken();
     if(strToken!=null && strToken!=''){
        return true;
     }
    return false;
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


}