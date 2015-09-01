@isTest
private class TestRackspaceController{
    
     public class MockTestHTTPRNIncidentData implements HttpCalloutMock {
      public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            res.setBody('<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">emailfilter</pair><pair name="compare_val" type="string">test@test.com</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106079</parameter></function></connector>');
            res.setStatusCode(200);
            res.setStatus('Ok');
            return res;
        }
    }
    
    @isTest
    static void UnitRackspaceController(){  
      try{ 
        String strDLName= 'test';
        String  strEmail='test@gmail.com';
        String strAction='';  
        string strMemberName='';
        string  objDLMember  ='';       
           RackspaceController objRackspace=new RackspaceController();    
           objRackspace.strDistributionListName='testunmanageddlUN';
           objRackspace.showDLDetail();     
           objRackspace.addMemberToDL();
           objRackspace.strNewMemberName='kanishk';
           objRackspace.addMemberToDL();    
           objRackspace.strNewMemberName='kanishk@gmail.com';
           objRackspace.addMemberToDL();     
           objRackspace.strNewMemberName='kanishk@ringcentral.com';
           objRackspace.addMemberToDL();               
           objRackspace.strNewMemberName='anuj';         
           objRackspace.removeFromDLEmailAddressList();
           objRackspace.strSelectedMember='kanishk';      
           objRackspace.removeFromDLEmailAddressList();   
           objRackspace.getAllDistributionList();               
           objRackspace.showPreviousPage();
           objRackspace.getIsSiteUser();               
           objRackspace.removeFromDLEmailAddressList();
           objRackspace.saveDistributionChangeLog(strDLName,strEmail,strAction);
           objRackspace.getAvailableMember(); 
           objRackspace.getDistributionListDetail();                  
        }
        
        catch(Exception e){}   
     }
}