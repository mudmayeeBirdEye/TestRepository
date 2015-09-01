/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 */
@isTest
private class TestRCSupportPortalHelperUK {

	public static testmethod void myUnitTest(){
    	RCSupportPortalHelperUK objHelperUK=new RCSupportPortalHelperUK();
      	Profile pp = [Select p.Name, p.Id From Profile p where Name LIKE '%RCSupport%'limit 1];
       	User objUserGuest= new User(alias = 'ksTest',
                                    email='kanishk.singhTest@simplion.com',
                                    emailencodingkey='UTF-8',
                                    lastname='Testing',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    profileid = pp.id,
                                    timezonesidkey='America/Los_Angeles',
                                    username='kanishk.singhTest@simplion.com'
                                    );
        insert objUserGuest;
    
      	system.runAs(objUserGuest){
        	objHelperUK=new RCSupportPortalHelperUK();
			objHelperUK.validateLoginDetail();
			objHelperUK.login();
			objHelperUK.PageAuthorization();
			objHelperUK.getNextPageName();
      	}
    
     	Account  objAccount= (Account  )SmartFactory.createSObject('Account', true);
     	upsert objAccount;
    
       	Contact objContact= (Contact)SmartFactory.createSObject('Contact', true);
		objContact.AccountId=objAccount.id;
		objContact.Email='kanishkTest@test.com';
		objContact.FirstName='Kanishk';
		upsert objContact;
    
        User objUser = new User(alias = objContact.FirstName, 
	        email=objContact.Email,  
	        emailencodingkey='UTF-8', 
	        lastname=objContact.LastName, 
	        languagelocalekey='en_US', 
	        localesidkey='en_US', 
	        profileid= '00e80000001OK6k', //On production 'Sandbox 5:00e80000001OK6k',Production:00e80000001OK6k 
	        contactId=objContact.id,
	        timezonesidkey='America/Los_Angeles', 
	        username= objContact.Email+system.Now().getTime(),
	        CommunityNickname='User Community Nick name'+system.Now().getTime()
        ); 
                                                
        insert objUser;
        
		String strRandomPassword ='RC'+String.valueOf(Math.random());//'verity11'; //'RC'+String.valueOf(Math.random());
     	system.setPassword(objUser.Id, strRandomPassword);
     	String strToken = 'un=' + objUser.username + '&pw=' +  strRandomPassword;
     	Blob cryptoKey = Blob.valueOf('v7Y2g2webAqutAcr4DEC3uTAnaspEgA8');
    	Blob initVector = Blob.valueof('da4atrABufastacr');
   	 	Blob data = Blob.valueOf(strToken);
     	Blob encryptedData = Crypto.encrypt('AES256', cryptoKey, initVector, data);
    	String strBase64Encoded =  EncodingUtil.base64Encode(encryptedData);
    	//vauthUserInputParam.Out_Token = EncodingUtil.urlEncode(strBase64Encoded, 'UTF-8') + '#' + strBase64Encoded;
     
     	String strTokenTest= strBase64Encoded; 
     	String strNextPage='RCSupportPortalHomePage';
     	ApexPages.currentPage().getParameters().put('token',strTokenTest);
     	ApexPages.currentPage().getParameters().put('NEXTPAGE',strNextPage);
     
     	objHelperUK=new RCSupportPortalHelperUK();
     	objHelperUK.validateLoginDetail();
     	objHelperUK.login();
     	objHelperUK.PageAuthorization();
    
      	ApexPages.currentPage().getParameters().put('startURL','/RCSupportPortalHome');
      	objHelperUK=new RCSupportPortalHelperUK();
      	objHelperUK.getNextPageName();
     
       	system.runAs(objUserGuest){
	        ApexPages.currentPage().getParameters().put('token',strTokenTest);
	        ApexPages.currentPage().getParameters().put('NEXTPAGE',strNextPage);
	        ApexPages.currentPage().getParameters().put('LCtabId','getting_a');
	        
	        objHelperUK=new RCSupportPortalHelperUK();
	        objHelperUK.validateLoginDetail();
        }
	    PageReference objPageRef=new PageReference('http://success.ringcentral.com/knowledge/TOCArticleRendererPkb.apexp?id=kA2V00000008TK9');
		objPageRef.setRedirect(true);
		objHelperUK=new RCSupportPortalHelperUK();
    }
}