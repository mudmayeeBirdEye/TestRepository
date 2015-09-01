public with sharing class RNIncidentData {
   
    String strEmail = ApexPages.currentPage().getParameters().get('emailid');
    String strconid= ApexPages.currentPage().getparameters().get('id');    
    String strRCID {get;set;}
    public List<List<String>> listOfListOfStrings { get; set; }
    public boolean isTestMode {get;set;}    
    public Account acct {get; set;}
    
    public RNIncidentData(ApexPages.StandardController controller){
    String strData = '';
    
    if(strEmail != null){
         strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">emailfilter</pair><pair name="compare_val" type="string">'+strEmail+'</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106079</parameter></function></connector>';
    }
    
    
     if(strconid != null){      
       try{
            acct = [SELECT id,RC_User_ID__c FROM Account WHERE id=:ApexPages.currentPage().getParameters().get('id')];
            strRCID = acct.RC_User_ID__c;
            if(strRCID != null){
                strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">'+strRCID+'</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106080</parameter></function></connector>';
            }
        }catch (System.QueryException e){           
        }
     }
      
         HttpRequest req = new HttpRequest();
         req.setEndpoint('http://help.ringcentral.com/cgi-bin/ringcentral.cfg/php/xml_api/parse.php');
         req.setMethod('POST');     
         req.setHeader('Content-Type', 'application/x-www-form-urlencoded');     
         req.setBody(strData);         
         req.setTimeout(120000);  
         Http http = new Http();
         HTTPResponse res = http.send(req);
         dom.Document doc = res.getBodyDocument(); 
         /*if(Test.isRunningTest()) {
         	doc = res.getBodyDocument(); 
         	//doc = new Document('sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">emailfilter</pair><pair name="compare_val" type="string">test@test.com</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106079</parameter></function></connector>');
         } else {       
         	doc = res.getBodyDocument(); 
         }*/
         Dom.XMLNode rootAtr= doc.getRootElement();
         listOfListOfStrings = new List<List<String>>();
         
         for(Integer iChild=0;iChild<rootAtr.getChildElements().size();iChild++){       
            Dom.XMLNode getchildNode =rootAtr.getChildElements().get(iChild);
            if(getchildNode.getName() == 'function'){
                for(Integer iEntity=0;iEntity<getchildNode.getChildElements().size();iEntity++){
                    Dom.XMLNode getchildNodeEntity = getchildNode.getChildElements().get(iEntity);
                    if(getchildNodeEntity.getName() == 'row'){                    
                         //get the entity text  
                         List<String> listEntityText = new List<String>();  
                         for(Integer iEntityText=0;iEntityText<getchildNodeEntity.getChildElements().size();iEntityText++){ 
                            Dom.XMLNode getchildNodeEntityText = getchildNodeEntity.getChildElements().get(iEntityText);
                            listEntityText.add(getchildNodeEntityText.getText());
                         }
                         listOfListOfStrings.add(listEntityText);
                         //
                    }
                }
            }
        }       
    }
    
     public class Row {
            public String id{get; set;}
            public String ticket {get; set;}
            public String subject{get; set;}
            public String status{get; set;}
            public String assignedto {get; set;}
            public String createddate {get; set;}
            public String DateLastUpdated {get; set;}
        } 
        public List<Row> getData(){ 
            List<Row> yourDataAsAListOfRow = new List<Row>();  
          
            for(Integer i=0;i<listOfListOfStrings.size();i++) {
                Row abc = new Row();
                abc.id = listOfListOfStrings.get(i).get(1);
                abc.ticket = listOfListOfStrings.get(i).get(9);
                abc.subject= listOfListOfStrings.get(i).get(2);
                abc.status= listOfListOfStrings.get(i).get(7);
                abc.assignedto = listOfListOfStrings.get(i).get(3);
                abc.createddate = listOfListOfStrings.get(i).get(11);
                abc.DateLastUpdated = listOfListOfStrings.get(i).get(12);
                yourDataAsAListOfRow.add(abc);
            
            }
            return yourDataAsAListOfRow;
        }
}