@isTest
private class TestRNIncidentDetails{ 
    public class MockTestHTTPRNIncidentDetails implements HttpCalloutMock {
      public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">emailfilter</pair><pair name="compare_val" type="string">test@test.com</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106079</parameter></function></connector>');
            res.setStatusCode(200);
            res.setStatus('Ok');
            return res;
        }
    }
    
    static testmethod void UnitRNIncidentDetails(){
    	try {
	        ApexPages.currentPage().getParameters().put('emailid', 'test@test.com');
	        //ApexPages.currentPage().getparameters().get('IncidentId','shdsh45545');
	        Account acc = new Account (Name ='test' ,RC_User_ID__c='UID6505392405');
	        insert acc;
	        ApexPages.currentPage().getparameters().put('id',acc.id);
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new MockTestHTTPRNIncidentDetails());
	        //Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(acc); 
	        RNIncidentDetails RNincdata = new RNIncidentDetails();
	        RNIncidentDetails.Row rowObj = new RNIncidentDetails.Row(); 
	        RNIncidentDetails.Rowdetails rowobjdet = new  RNIncidentDetails.Rowdetails();        
	        Test.stopTest(); 
	        List<List<String>> listObj = new List<List<String>>();
	        List<string> listObj1 = new List<string>();
	        List<List<String>> listObj2 = new List<List<String>>();
	        List<string> listObj3 = new List<string>();
	        listObj3.add('test1');
	        listObj1.add('teststring1');
	        listObj1.add('teststring2');
	        listObj1.add('teststring3');
	        listObj1.add('teststring4');
	        listObj1.add('teststring5');
	        listObj1.add('teststring6');
	        listObj1.add('teststring7');
	        listObj1.add('teststring8');
	        listObj1.add('teststring9');
	        listObj1.add('teststring10');
	        listObj1.add('teststring11');
	        listObj1.add('teststring12');
	        listObj1.add('teststring13');
	        listObj1.add('teststring14');        
	        listObj.add(listObj1);
	        listObj2.add(listObj3);
	        RNincdata.listOfListOfStrings =listObj2 ;
	        RNincdata.listOfListOfStrings = listObj;
	        RNincdata.getData();
	        RNincdata.getDatadetails();  
        } catch(Exception e) {}               
   }   
}