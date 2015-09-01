@isTest
private class TestMarketingCloud {
	
	public class MockTestHTTPMarketingPortal1 implements HttpCalloutMock {
      public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/xml');
	        res.setBody('99369-@-PartnerUser-@-GArima-@-762-@--@-null-@-gari12_812@yahoomail.com-@-1-@-1');
	        res.setStatusCode(200);
	        res.setStatus('Ok');
	        return res;
	    }
	}
	
	public class MockTestHTTPMarketingPortal2 implements HttpCalloutMock {
      public HTTPResponse respond(HTTPRequest req) {
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'application/xml');
	        res.setBody('Test');
	        res.setStatusCode(200);
	        //res.setStatus('Internal Error');
	        return res;
	    }
	}

    static testMethod void marketingCloudTest() {
    	Profile p = [select id from profile where name = 'System Administrator'];
 		User testUser = new User(alias = 'testP8', email='testP8@testorg.com',
		    emailencodingkey='UTF-8', lastname='testP8', languagelocalekey='en_US',
		    localesidkey='en_US', profileid = p.Id, country='United States',
		    timezonesidkey='America/Los_Angeles', username='testP8@testorg.com',Teammhc_User_Id__c = '21213');
		    insert testUser;
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockTestHTTPMarketingPortal1());
        System.runAs(testUser) {
	        MarketingCloud marketingCloudObj = new MarketingCloud();
	        PageReference pgRefRtn = marketingCloudObj.loginToVAarPortal();
	        marketingCloudObj.XMLParser('<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:RSIDataTypes"><SOAP-ENV:Body><SOAP-ENV:getUserResponse><user><ns1:Id>99370</ns1:Id><ns1:LastName>PartnerUser</ns1:LastName><ns1:FirstName>GArima</ns1:FirstName><ns1:MiddleName></ns1:MiddleName><ns1:Title>null</ns1:Title><ns1:Login>gari12_812@yahoomail.com</ns1:Login><ns1:CompanyId>762</ns1:CompanyId><ns1:CompanyName>TestCompanyRC</ns1:CompanyName><ns1:Suffix></ns1:Suffix><ns1:Password/><ns1:IsActive>true</ns1:IsActive><ns1:SecurityLevel>1</ns1:SecurityLevel><ns1:CustomAttributes><ns1:item><ns1:Name>qr_bizcard</ns1:Name><ns1:DataFormat>AlphaNumeric</ns1:DataFormat><ns1:DataType>Text</ns1:DataType><ns1:Description>qr_bizcard</ns1:Description><ns1:DisplayName>qr_bizcard</ns1:DisplayName><ns1:Id>2583</ns1:Id><ns1:IsRequired>true</ns1:IsRequired><ns1:Value id="ref1"/><ns1:DefaultValues id="ref2"/></ns1:item><ns1:item><ns1:Name>qr_email</ns1:Name><ns1:DataFormat>AlphaNumeric</ns1:DataFormat><ns1:DataType>Text</ns1:DataType><ns1:Description>qr_email</ns1:Description><ns1:DisplayName>qr_email</ns1:DisplayName><ns1:Id>2584</ns1:Id><ns1:IsRequired>true</ns1:IsRequired><ns1:Value href="#ref1"/><ns1:DefaultValues href="#ref2"/></ns1:item><ns1:item><ns1:Name>qr_sms</ns1:Name><ns1:DataFormat>AlphaNumeric</ns1:DataFormat><ns1:DataType>Text</ns1:DataType><ns1:Description>qr_sms</ns1:Description><ns1:DisplayName>qr_sms</ns1:DisplayName><ns1:Id>2585</ns1:Id><ns1:IsRequired>true</ns1:IsRequired><ns1:Value href="#ref1"/><ns1:DefaultValues href="#ref2"/></ns1:item><ns1:item><ns1:Name>qr_url</ns1:Name><ns1:DataFormat>AlphaNumeric</ns1:DataFormat><ns1:DataType>Text</ns1:DataType><ns1:Description>qr_url</ns1:Description><ns1:DisplayName>qr_url</ns1:DisplayName><ns1:Id>2586</ns1:Id><ns1:IsRequired>true</ns1:IsRequired><ns1:Value href="#ref1"/><ns1:DefaultValues href="#ref2"/></ns1:item><ns1:item><ns1:Name>qr_vcard</ns1:Name><ns1:DataFormat>AlphaNumeric</ns1:DataFormat><ns1:DataType>Text</ns1:DataType><ns1:Description>qr_vcard</ns1:Description><ns1:DisplayName>qr_vcard</ns1:DisplayName><ns1:Id>2587</ns1:Id><ns1:IsRequired>true</ns1:IsRequired><ns1:Value href="#ref1"/><ns1:DefaultValues href="#ref2"/></ns1:item></ns1:CustomAttributes></user></SOAP-ENV:getUserResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>');
	    }
        Test.stopTest();
    }
    
    static testMethod void marketingCloudTest1() {
    	/*User userObj = [Select Title, Teammhc_User_Pwd__c, Username, Teammhc_User_Id__c, Name, LastName, FirstName,Email, 
						CompanyName FROM User WHERE IsActive = true and Teammhc_User_Id__c = null limit 1];*/
	    Profile p = [select id from profile where name = 'System Administrator'];
 		User testUser = new User(alias = 'testP10', email='testP10@testorg.com',
		    emailencodingkey='UTF-8', lastname='testP10', languagelocalekey='en_US',
		    localesidkey='en_US', profileid = p.Id, country='United States',
		    timezonesidkey='America/Los_Angeles', username='testP10@testorg.com');
		    insert testUser;					
		Test.startTest();				
		Test.setMock(HttpCalloutMock.class, new MockTestHTTPMarketingPortal1());				
		System.runAs(testUser) {
	    	MarketingCloud marketingCloudObj = new MarketingCloud();
        	PageReference pgRefRtn = marketingCloudObj.loginToVAarPortal();
		}
		Test.stopTest();				
    }
    
    static testMethod void marketingCloudTest2() {
    	Profile p = [select id from profile where name = 'System Administrator'];
 		User testUser = new User(alias = 'testP9', email='testP9@testorg.com',
		    emailencodingkey='UTF-8', lastname='testP9', languagelocalekey='en_US',
		    localesidkey='en_US', profileid = p.Id, country='United States',
		    timezonesidkey='America/Los_Angeles', username='testP9@testorg.com',Teammhc_User_Id__c = '21213');
		    insert testUser;
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockTestHTTPMarketingPortal2());
        System.runAs(testUser) {
        	MarketingCloud marketingCloudObj = new MarketingCloud();
        	PageReference pgRefRtn = marketingCloudObj.loginToVAarPortal();
        }
     	Test.stopTest();			
    }
}