public class RCSupportControllerHandler{
public String str{get;set;}
public Boolean isGuestUser{get;set;}
public String strSeesionId{get;set;}
public Boolean isTokenFound{get;set;}
public String strPageUrl{get;set;}
//public  String strPostFix='_rccustomer';
public  String strPostFix='';
public User objUser{get;set;}
public String strLCClassName{get;set;}
public map<String,String> mapArticleUrl{get;set;}
public String siteArticle {get;set;}
public List<String> articleOrderedList {get;set;}
public String CurrentURl{get;set;}
public String defaultName{get;set;}


	public RCSupportControllerHandler(){	
		if(UserInfo.getUserType()=='Guest'){
			isGuestUser=true;
		} else {
			isGuestUser=false;
		}
		// CHANGES STARTS FOR CSV BASED ARTICLE LISTING
	    	mapArticleUrl = new Map<String,String>();
	   		articleOrderedList = new List<String>();
	    // CHANGES ENDS FOR CSV BASED ARTICLE LISTING
		isTokenFound=isValidTokenFound();
		objUser=new User();
		if(isGuestUser!=true){
			objUser=[SELECT AboutMe, IsActive, CommunityNickname, CompanyName, Country, CreatedDate, Department, Division, Email,  Name, IsPortalEnabled, LastLoginDate,
	                UserType, Username,Profile.Name,UserRole.Name,FullPhotoUrl FROM User where id=:UserInfo.getUserId()];
		}   
		CurrentURl = Site.getBaseUrl();
	        system.debug('======================='+CurrentURl);
	    if(CurrentURl.contains('rcsupportCA2012')||CurrentURl.contains('success.ringcentral.ca')){
	    	defaultName ='Canada';
	    } else {
	    	defaultName ='United States';
		}
		if(String.isNotBlank(ApexPages.CurrentPage().getParameters().get('LCtabId'))){
			strLCClassName=ApexPages.CurrentPage().getParameters().get('LCtabId');
		} else {
			strLCClassName='getting_0';
		}
		mapArticleUrl = knowledgeArticleMap('ArticleNaviagationListForUSCAandUK', (getUKPortal() ? 'UK' :'US/CA'));
	}
	/************************ GET DOCUMENT FOR ARTICLE LISTING **********************************/
  	public static List<Document> getMyDocument(String docName){
		return [SELECT body, Name, bodyLength, ContentType, Url FROM Document WHERE Name = :docName];
    }
	/*********************************************************/  
 	public Map<String,String> knowledgeArticleMap(String docName, String brandName){
        String[] fileLines = new String[]{};
        
        List<Document> lstDoc = getMyDocument(docName);
        if(lstDoc != null && lstDoc.size() != 0 && lstDoc[0].body != null) {
            try {
                String csvFile= lstDoc[0].body.toString();
                fileLines = csvFile.split('#EOL#');
                Integer counter = 0;
                for(String line : fileLines){
                    if(!String.isBlank(line)&& line != '' && line != null && ++counter > 1) {
                        String[] inputvalues = line.split(',\\*-\\*,');
                        if(inputvalues != null && inputvalues.size() == 3){
                    		if(brandName.containsIgnoreCase('UK')){
                    			if((inputvalues[0]).containsIgnoreCase('UK')){
                       				mapArticleUrl.put(inputvalues[1].replaceAll('"','').trim(),inputvalues[2].trim());
                       				articleOrderedList.add(inputvalues[1].replaceAll('"','').trim());
                    			}
                    		} else if(brandName.containsIgnoreCase('US')){
                    			if((inputvalues[0]).containsIgnoreCase('US/CA')){
                       				mapArticleUrl.put(inputvalues[1].replaceAll('"','').trim(),inputvalues[2].trim());
                       				articleOrderedList.add(inputvalues[1].replaceAll('"','').trim());
                    			}
                    		}
                        }
                    }
                }
            } catch(exception ex){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
                system.debug(ex.getMessage());
            }
        } else {
        	mapArticleUrl.put('No articles configured.','No articles configured.');
        	articleOrderedList.add('No articles configured.');
        }
        return  mapArticleUrl;
    }
	public PageReference showTabsDetail(){
	 	PageReference objPage=new PageReference('/RCSupportPortalLearningCenter');
	 	objPage.getParameters().put('LCtabId',strLCClassName);
	 	return objPage;
 	} 
  	public PageReference updateUserProfile() {
		try {
            update objUser;
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Profile Successfully updated');
			ApexPages.addMessage(msg);
    	}catch(Exception e ){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
            e.getMessage());
            ApexPages.addMessage(msg);
        }
		return null;
  	}
	public Boolean isValidTokenFound(){
	 	String strToken =getValidToken();
	 	if(strToken!=null && strToken!=''){
	 		return true;
	 	}
		return false;
	}

	public String getURL() {
		return Site.getName();
	}
	
	public Boolean getUKPortal(){
		if(Site.getName()!=null && Site.getName()!='' && (Site.getName()).lastIndexOfIgnoreCase('RCSupportPortalUK')>-1){
		return true;
		}
		return false;
	}


	public String strPageUrl2{get;set;}
	public Pagereference validateLoginDetail(){
	  	try {
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
					username = 	strSplitToken[0].split('=')[1];
					password = 	strSplitToken[1].split('=')[1];
					str=username+password;
				}
				String strPage = ApexPages.CurrentPage().getParameters().get('NEXTPAGE');
				if(strPage!=null && strPage!='' && strPage.indexOf(strPostFix)>=0){
					strPage='/'+strPage.removeEndIgnoreCase(strPostFix);
				}else if(ApexPages.CurrentPage().getParameters().get('ARTICLENAME')!=null && ApexPages.CurrentPage().getParameters().get('ARTICLENAME')!=''){
					 strPage='';
					 strPage='/articles/RC_Knowledge_Article/'+ApexPages.CurrentPage().getParameters().get('ARTICLENAME');
				}
					//Pagereference pageRef= Site.login(username,password, ''+getRetPageName());
					ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'username ='+username+' | pwd='+password);
					ApexPages.addMessage(msg);
					Pagereference pageRef= Site.login(username,password, ''+strPage);
					// Pagereference pageRef= new Pagereference(Site.getCurrentSiteUrl()+'/secur/logout.jsp');
					//Pagereference pageRef= Site.login(username,password, '/RCSupportPortalSearch');
					pageRef.setRedirect(true);
					return pageRef;
	 			}
			}  
	  //} 
	  	} catch(Exception e) {
	  		system.debug('#### EXCEPTION ON THE PAGE = ' + e.getStackTraceString());
	  		ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString());
			ApexPages.addMessage(msg);
	  	} 
		return null;
	}

	/*
	public String getRetPageName(){
		String strPage = ApexPages.CurrentPage().getParameters().get('NEXTPAGE');
		if(strPage!=null && strPage!=''){
			return '/'+strPage;
		}else if(ApexPages.currentPage().getParameters().get('startURL')!=null && ApexPages.currentPage().getParameters().get('startURL')!=''){
			
			strPage=ApexPages.currentPage().getParameters().get('startURL');
			return strPage;
		}
		return '/RCSupportPortalHome';
	}
	*/
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

	/*public Pagereference loginUsingToken(){
		 if(isTokenFound==true){
			return validateLoginDetail();
		}
		return null;
	}*/

	public Pagereference login(){
		if(isTokenFound==true){
			return validateLoginDetail();
		} else {
			PageReference objPage=new PageReference('https://service.ringcentral.com/login.asp');
			objPage.getParameters().put('p_next_page',getNextPageName());
			objPage.setRedirect(true);
			return objPage;
	 	}
		return null;
	}
	public String strUserType{get;set;}
	public Pagereference PageAuthorization(){
		if(UserInfo.getUserType()=='Guest'){
			isGuestUser=true;
		} else {
			isGuestUser=false;
			return null;
		}//strPageUrl=ApexPages.currentPage().getUrl();
		//return null;
		return login();
	} 
	public Pagereference getPageAuthorization(){
		if(UserInfo.getUserType()=='Guest'){
			isGuestUser=true;
			} else {
			isGuestUser=false;
			return null;
		}//strPageUrl=ApexPages.currentPage().getUrl();
		//return null;
		return login();
	} 
	public Pagereference openCase(){
		//return new Pagereference('/RCSupportAdvCaseCreate');
		return new Pagereference('/RCSupportPortalCreateNewCase');
	}
	public Pagereference openMyCase(){
		return new Pagereference('/RCSupportAdvMyCases');
	}

  	public String getPageDetail(){
		return ApexPages.currentPage().getUrl();
  	}
  
	public Boolean getIsArticleDetailsPage(){
  		String pageURL=ApexPages.currentPage().getUrl();
  		if(pageURL!=null && pageURL.indexOf('TOCArticleRendererPkb')>-1){
  			return true;
  		}
  		return false;
   	}
 	public String getURLProtocol(){
 		return URL.getSalesforceBaseUrl().getProtocol();
 	} 
  
	public String getCommunityId(){
   		String strReturnString='false';
   		for(Community objCommunity : [SELECT Id FROM Community WHERE Name = 'RingCentral Customer Community' limit 1 ]){
         	strReturnString=objCommunity.id;
    	}
   		return strReturnString;
   	}
}