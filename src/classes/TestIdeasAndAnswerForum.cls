/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestIdeasAndAnswerForum {

    static testMethod void myUnitTest(){
     IdeaAndAnswerForumController objIdeaAndAnswer=new IdeaAndAnswerForumController();
      objIdeaAndAnswer.getIdeaURL();
       ApexPages.CurrentPage().getParameters().put('retUrl','service=1&brand=Ringcentral&token=test');
       objIdeaAndAnswer.getIdeaURL();
       ApexPages.CurrentPage().getParameters().put('token','test');
       objIdeaAndAnswer.getIdeaURL();
       ApexPages.CurrentPage().getParameters().put('token','PFK8fqxUQZ3qw1nIWm0gVoPE1O1xEhiRFh0X3n0PxvEIzdYo+J2ihXuaSvfrFoOGXg5uqTH8KYo/2oohN5A7wQ==');
       objIdeaAndAnswer.getIdeaURL(); 
       objIdeaAndAnswer.getIdeaURL(); 
    }
    
    static testMethod void myUnitTest1() {
	   	IdeaAndAnswerForumController objHandler = new IdeaAndAnswerForumController();
	   	Profile pp = [Select p.Name, p.Id From Profile p where Name LIKE '%RCSupport%'limit 1];
	   	User objUserGuest= new User(alias = 'ksTest11',
		                                email='kanishk.singhTest11@simplion.com',
		                                emailencodingkey='UTF-8',
		                                lastname='Testing',
		                                languagelocalekey='en_US',
		                                localesidkey='en_US',
		                                profileid = pp.id,
		                                timezonesidkey='America/Los_Angeles',
		                                username='kanishk.singhTest11@simplion.com'
		                                );
		insert objUserGuest;
	   	system.runAs(objUserGuest){
	   	  	 objHandler= new IdeaAndAnswerForumController();
		    objHandler.validateLoginDetail();  
			 objHandler.login();
			 objHandler.PageAuthorization();
			 objHandler.getCommunityId();
	   	}
   	
   	 	Account  objAccount= (Account)SmartFactory.createSObject('Account', true);
   	 	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
   	 	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
	 	upsert objAccount;
	 	TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
	 	TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE = false;
   	
   	   	Contact objContact= (Contact)SmartFactory.createSObject('Contact', true);
	   	objContact.AccountId=objAccount.id;
	   	objContact.Email='kanishkTest12@test.com';
	   	objContact.FirstName='Kanishk';
	   	TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
	   	TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
	   	upsert objContact;
	   	TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
	   	TriggerHandler.BY_PASS_CONTACT_ON_UPDATE = false;
   	
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
	 
	 	objHandler=new IdeaAndAnswerForumController();
	 	objHandler.validateLoginDetail();
	 	objHandler.login();
	 	objHandler.PageAuthorization();
	 	objHandler.getCommunityId();
	 
	  	ApexPages.currentPage().getParameters().put('startURL','/RCSupportPortalHome');
	  	objHandler= new IdeaAndAnswerForumController();
	  	objHandler.getNextPageName();
	 
	   	system.runAs(objUserGuest){
		   	ApexPages.currentPage().getParameters().put('token',strTokenTest);
		    ApexPages.currentPage().getParameters().put('NEXTPAGE',strNextPage);
		    ApexPages.currentPage().getParameters().put('LCtabId','getting_a');
		    
		    objHandler=new IdeaAndAnswerForumController();
		    objHandler.validateLoginDetail();
	   }
  		PageReference objPageRef = new PageReference('http://success.ringcentral.com/knowledge/TOCArticleRendererPkb.apexp?id=kA2V00000008TK9');
	  	objPageRef.setRedirect(true);
	  	objHandler= new IdeaAndAnswerForumController();
	}
}