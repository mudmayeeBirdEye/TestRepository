public class MarketingCloud {
	//private static String PHP_URL = 'http://sp2.ringcentral.com/TEAMMHC/'; 
	private static String PHP_URL = 'http://sp2.ringcentral.com/TEAMMHCPRO/';
	private static Integer COMPANY_ID = 762; 
	private static String PASSWORD_STR = 'ringcentral';
	// UserWR:[CompanyId=762, CompanyName=testcompanyname, FirstName=testfirst1, Id=92946, IsActive=true, LastName=testlast1, Login=testlogin1, MiddleName=null, Password=null, SecurityLevel=null, Suffix=null, Title=null]
	public MarketingCloud() {}
	private User getUserDetails(Id userId) {
		return [Select Title, Teammhc_User_Pwd__c, Username, Teammhc_User_Id__c, Name, LastName, FirstName,Email, 
						CompanyName FROM User WHERE Id=: userId AND IsActive = true];
	}	 
	
	public PageReference loginToVAarPortal() {
		/*
		if(ApexPages.currentPage().getCookies().get('storefront') != null && ApexPages.currentPage().getCookies().get('storefront').getValue() != null) {
			PageReference pageObj = new PageReference('https://ringcentral.teammhc.net?override=1');
			pageObj.setRedirect(true);
            return pageObj;
        }
		*/
		boolean isNewUser = false;
		User userObj = getUserDetails(UserInfo.getUserId());
		//userObj.Teammhc_User_Id__c = '92946';
		UserWR userWrObjRtn = new UserWR();
		UserWR userWRObjToUpd = new UserWR();
		if(userObj != null) {
			System.Debug(' TEAM MHC ID == '+userObj.Teammhc_User_Id__c);
			if(String.isBlank(userObj.Teammhc_User_Id__c)) {
				System.Debug(' FOUND NO TEAM MHC ID IN USER ');
				HTTPResponse httpResponseObj = callAPIs(PHP_URL
														+'rc_create_user.php?lname='+userObj.LastName
														+'&fname='+userObj.FirstName
														+'&company_Id='+COMPANY_ID
														+'&companyname='+userObj.CompanyName
														+'&mname=&title='+userObj.Title
														+'&login='+userObj.Username
														+'&email='+userObj.Email
														+'&password='+(String.isBlank(userObj.Teammhc_User_Pwd__c) ? 'ringcentral' : userObj.Teammhc_User_Pwd__c)
														+'&suffix='+'&SecurityLevel=99'
														+'&CustomAttributes='
												,null,'GET');
				System.Debug('## RESPONSE - FIRST ## = '+ httpResponseObj);
				if(httpResponseObj == null || httpResponseObj.getStatusCode() == 500) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured. Please contact to your admin.[FIRST TIME USER CREATION]'));
					return null;
				}
				System.Debug('## RESPONSE ON CREATE USER ## = '+ httpResponseObj.getBody());
				try {
					/*** NEED TO CHANGE HERE ***/
					String response = httpResponseObj.getBody();
					String[] listResult = response.split('-@-'); 
					System.Debug('>>22>>'+listResult); 
					userWRObjToUpd = new UserWR();
					userWRObjToUpd.id = listResult[0];
					userWRObjToUpd.CompanyId = listResult[3];
					userObj.Teammhc_User_Id__c = userWRObjToUpd.Id;
					userObj.Teammhc_Company_Id__c = userWRObjToUpd.CompanyId;
					isNewUser = true;
					if(Test.isRunningTest()) {
						//Integer i = 1/0;
					}
				} catch(Exception e) { 
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured. Please contact to your admin.[PARSING FIRST CONDITION USER]'));
					return null;
				}
			} else {
				HttpResponse httpResponseObjLogin = callAPIs(PHP_URL+'get_login_string.php?id='+userObj.Teammhc_User_Id__c+'&company_Id='+COMPANY_ID,null,'GET');
				if(httpResponseObjLogin != null) {
					if(httpResponseObjLogin.getStatusCode() != 500) {
						string result = httpResponseObjLogin.getBody();
	    				System.debug('## SUCCESSFUL LOGIN TO = ' + result);
	    	 			PageReference pgRef = new PageReference('https://'+result.trim());
		     			pgRef.setRedirect(true);
		     			if(isNewUser == true) {
			     			update userObj;
			     		}
		     			return pgRef;
					}
				}
				// userObj.Teammhc_User_Id__c = '100010';
				HTTPResponse httpResponseObj = callAPIs(PHP_URL+'rc_get_user.php?id='+userObj.Teammhc_User_Id__c+'&company_Id='+COMPANY_ID,null,'GET');
				if(httpResponseObj != null) {
					System.Debug('## GET USER DETAILS ## = '+ httpResponseObj.getBody());
					if(httpResponseObj.getStatusCode() == 500) {
						System.Debug('## ERROR ON USER SEARCH ##');
						httpResponseObj = callAPIs(PHP_URL
														+'rc_create_user.php?lname='+userObj.LastName
														+'&fname='+userObj.FirstName
														+'&company_Id='+COMPANY_ID
														+'&companyname='+userObj.CompanyName
														+'&mname=&title='+userObj.Title
														+'&login='+userObj.Username
														+'&email='+userObj.Email
														+'&password='+(String.isBlank(userObj.Teammhc_User_Pwd__c) ? 'ringcentral' : userObj.Teammhc_User_Pwd__c)
														+'&suffix='+'&SecurityLevel=99'
														+'&CustomAttributes='
												,null,'GET');
						System.Debug('## RESPONSE ON CREATE USER ## = '+ httpResponseObj.getBody());
						//userWrObjRtn = XMLParser(httpResponseObj.getBody());
						try {
							//userWrObjRtn = XMLParser(httpResponseObj.getBody());
							//userWRObjToUpd = new UserWR();
							//userWRObjToUpd = XMLParser(httpResponseObj.getBody());
							//userObj.Teammhc_User_Id__c = userWRObjToUpd.Id;
							String response = httpResponseObj.getBody();
							String[] listResult = response.split('-@-'); 
							System.Debug('>>22>>'+listResult); 
							userWRObjToUpd = new UserWR();
							userWRObjToUpd.id = listResult[0];
							userWRObjToUpd.CompanyId = listResult[3];
							userObj.Teammhc_User_Id__c = userWRObjToUpd.Id;
							userObj.Teammhc_Company_Id__c = userWRObjToUpd.CompanyId;
							isNewUser = true;
						} catch(Exception e) { 
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured. Please contact to your admin.[PARSING SECOND CONDITION USER]'));
							return null;
						}
					} else {
						try {
							userWRObjToUpd = new UserWR();
							userWRObjToUpd = XMLParser(httpResponseObj.getBody());
						} catch(Exception e) { 
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured. Please contact to your admin.[PARSING SECOND CONDITION USER PARSING]'));
							return null;
						}
					}
					System.debug('## USER INFORMATION CLS = ' + userWRObjToUpd);
				}
			}
			if(userWRObjToUpd != null && userWRObjToUpd.Id != null) {
	    		HttpResponse httpResponseObjLogin = callAPIs(PHP_URL+'get_login_string.php?id='+userWRObjToUpd.id+'&company_Id='+userWRObjToUpd.CompanyId, null, 'GET');
	    		if(httpResponseObjLogin != null && httpResponseObjLogin.getBody() != null) {
	    			string result = httpResponseObjLogin.getBody();
	    			System.debug('## SUCCESSFUL LOGIN TO = ' + result);
	    	 		PageReference pgRef = new PageReference('https://'+result.trim());
		     		pgRef.setRedirect(true);
		     		if(isNewUser == true) {
		     			update userObj;
		     		}
		     		return pgRef;
	    		} else {
	    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured. Please contact to your admin.[FINAL REDIRECTING FIST ISSUE]'));
					return null;
	    		}
			} else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error occured. Please contact to your admin.[FINAL REDIRECTING ISSUE]'));
				return null;
			}
		}
		return null;
	}
	
	private HTTPResponse callAPIs(String endURL, String body, String action) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
    	req.setEndpoint(endURL);
    	if(body != null) {
    		req.setBody(body);
    	}
    	req.setHeader('Content-type', 'application/xml');
    	req.setHeader('Accept', 'application/xml'); 
        req.setMethod(action);
        HTTPResponse res = new HTTPResponse();
        res = http.send(req);
        Http strRespBody;
        if(res.getStatus() == 'OK') {
        	return res;
        }
        return null;
    }
    
    public UserWR XMLParser(String strXml){
    	UserWR userWRObj = new UserWR();
		System.debug('####Inside XMLParser Method########'+strXml);
		List<String> orgInfo=new List<String>();
		Dom.Document doc = new Dom.Document();
		//system.Debug('>>11>>');
		doc.load(strXml);
		//Retrieve the root element for this document.
		Dom.XMLNode Envelope = doc.getRootElement();
		Dom.XMLNode Body = Envelope.getChildElements()[0];
		string user_createResult = '';
		//system.Debug('>>11>>'+Body);
		Dom.XMLNode getUserresponse = Body.getChildElements()[0];
		Dom.XMLNode getUserObj = getUserresponse.getChildElements()[0];
		for(Dom.XMLNode child : getUserObj.getChildElements()) {
			//system.Debug('>>22>>'+child.getName());
			//system.Debug('>33>>'+child.getText());
			if(child.getName() == 'Id') {
				userWRObj.id = child.getText();
			}
			if(child.getName() == 'LastName') {
				userWRObj.LastName = child.getText();
			}
			if(child.getName() == 'FirstName') {
				userWRObj.FirstName = child.getText();
			}
			if(child.getName() == 'Login') {
				userWRObj.Login = child.getText();
			}
			if(child.getName() == 'CompanyId') {
				userWRObj.CompanyId = child.getText();
			}
			if(child.getName() == 'CompanyName') {
				userWRObj.CompanyName = child.getText();
			}
			if(child.getName() == 'IsActive') {
				userWRObj.IsActive = Boolean.valueof(child.getText());
			}
			//orgInfo.add(child.getText());
		}
		return userWRObj;
	}
 	
   	public class UserWR {
     String Id;
     boolean IsActive;
	 string FirstName;
     string LastName;
     string MiddleName;
     string Title;
     string Login;
     string CompanyId;
     string CompanyName;
     string Suffix;
     string Password;
     string SecurityLevel;       
   }
}


/*private UserWR parseUser(XmlStreamReader reader) {
     	UserWR userObj = new UserWR();
     	while(reader.hasNext()) {
	        if (reader.getEventType() == XmlTag.END_ELEMENT) {
	           break;
	        } else if (reader.getEventType() == XmlTag.CHARACTERS) {
	           userObj.Id = reader.getText();
	        }
	        System.Debug('>>>55>>');
	        reader.next();
	     }
	     return userObj;
   }*/


/*string userId = '92946';
	public PageReference getUserInfo() {
		HttpRequest requestObj = new HttpRequest();
		List<UserWR> userlist= new List<UserWR>(); 
		requestObj.setEndpoint('http://sp2.ringcentral.com/TEAMMHC/rc_get_user.php'); 	
		requestObj.setMethod('GET');
		requestObj.setTimeout(20000);
		//requestObj.setHeader('Content-Type', 'json');
		//requestObj.setHeader('Host :', 'http://sp2.ringcentral.com/TEAMMHC/get_login_string.php');
		Http httpObj = new Http();
     	HTTPResponse resObj = httpObj.send(requestObj);
     	System.Debug('############ => '+ resObj.getBody());
     	
     	XmlStreamReader reader = resObj.getXmlStreamReader();
    	while(reader.hasNext()) {
	      System.debug('Event Type:' + reader.getEventType());
	      if (reader.getEventType() == XmlTag.START_ELEMENT) {
	        System.debug('>>11>>'+ reader.getLocalName());
	        if(reader.getLocalName() == 'user') {
	        	System.debug('>>22>>');
	        	UserWR userObj = parseUser(reader);
	        	userlist.add(userObj);
	        }
	      }
	      reader.next();
    	}
    	System.Debug('>>33>>'+userlist);
    	if(userId == userlist[0].Id) {
    		
    		String result = callAPIs('http://sp2.ringcentral.com/TEAMMHC/get_login_string.php', null, 'GET');
    		result = result.replaceAll('&#124;', '|'); 
    		System.Debug('===== > '+result);
     		PageReference pgRef = new PageReference('https://'+result);
     		pgRef.setRedirect(true);
     		return pgRef;
    	}
     	
     	/*PageReference pgRef = new PageReference('http://sp2.ringcentral.com/TEAMMHC/rc_login.php');
     	pgRef.setRedirect(true);
     	return pgRef;*/
     	//return null;
	//}*/
	
	//string result1 = result.replaceAll('&#124;','\\|');
	    			//string result1 = result.unescapeHtml4(); 
	    			//String encoded = EncodingUtil.urlEncode(result, 'UTF-8');
	    			//String decoded = EncodingUtil.urlDecode(result, 'UTF-8');
	    			//result = EncodingUtil.urlEncode(result, 'UTF-8');
	    			//System.Debug('=====11 > '+ result1);
		    		//System.Debug('===== 22> '+ encoded);
		    		//System.Debug('===== 33> '+ decoded);
		    		
		    			// UserWR:[CompanyId=762, CompanyName=testcompanyname, FirstName=testfirst1, Id=92946, IsActive=true, LastName=testlast1, Login=testlogin1, MiddleName=null, Password=null, SecurityLevel=null, Suffix=null, Title=null]
					/*XmlStreamReader reader = httpResponseObj.getXmlStreamReader();
					
			    	while(reader.hasNext()) {
				      System.debug('Event Type:' + reader.getEventType());
				      if (reader.getEventType() == XmlTag.START_ELEMENT) {
				        System.debug('>>11>>'+ reader.getLocalName());
				        if(reader.getLocalName() == 'user') {
				        	System.debug('>>22>>');
				        	userWrObjRtn = parseUser(reader);
				        }
				      }
				      reader.next();
			    	}*/
			    	/*
			    	System.Debug('>>userWrObjRtn>>'+userWrObjRtn);
			    	System.debug('>>111212>>'+ userWrObjRtn.Id == userObj.Teammhc_User_Pwd__c);
			    	System.debug('>>111ewe212>>'+ userWrObjRtn.Id);
			    	User userObj1 = getUserDetails(UserInfo.getUserId());
					userObj1.Teammhc_User_Id__c = '92946';
			    	System.debug('>>1112wed12>>'+ userObj1.Teammhc_User_Pwd__c);*/