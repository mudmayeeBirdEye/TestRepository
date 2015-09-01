public with sharing class RNIncidentDetails {
    String strEmail = ApexPages.currentPage().getParameters().get('emailid');
    String strIncidentId= ApexPages.currentPage().getparameters().get('IncidentId');
    public List<List<String>> listOfListOfStrings { get; set; }    
    public List<List<String>> listOfListOfStringstask { get; set; }
    //to dispaly at top as summary
    public List<List<String>> listOfListOfStringsSummary { get; set; }
    public String strSummaryRefNum { get; set; }
    public String strSummarySub { get; set; }
    public String strSummaryStatus { get; set; }
    public String strSummaryAssTo { get; set; }
        
    String strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">IncidentId</pair><pair name="compare_val" type="string">'+strIncidentId+'</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106082</parameter></function></connector>';
    String strDataSummary = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">detailIncidentid</pair><pair name="compare_val" type="string">'+strIncidentId+'</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106081</parameter></function></connector>';    
    String details;
     public RNIncidentDetails()
     {
         HttpRequest req = new HttpRequest();
         req.setEndpoint('http://help.ringcentral.com/cgi-bin/ringcentral.cfg/php/xml_api/parse.php');
         req.setMethod('POST');     
         req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
     
         req.setBody(strData);  
         Http http = new Http();
         HTTPResponse res = http.send(req);
         dom.Document doc = res.getBodyDocument(); 
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
                         
                    }
                }
            }
       
       }
    //for getting Incident Summary
    HttpRequest reqSummary = new HttpRequest();
         reqSummary.setEndpoint('http://help.ringcentral.com/cgi-bin/ringcentral.cfg/php/xml_api/parse.php');
         reqSummary.setMethod('POST');     
         reqSummary.setHeader('Content-Type', 'application/x-www-form-urlencoded');
         reqSummary.setBody(strDataSummary);  
         Http httpSummary = new Http();
         HTTPResponse resSummary = http.send(reqSummary);  
 
         dom.Document docSummary = resSummary.getBodyDocument(); 
         Dom.XMLNode rootAtrSummary= docSummary.getRootElement();
         listOfListOfStringsSummary = new List<List<String>>();
         
         for(Integer iChild=0;iChild<rootAtrSummary.getChildElements().size();iChild++){       
            Dom.XMLNode getchildNodeSummary =rootAtrSummary.getChildElements().get(iChild);
            if(getchildNodeSummary.getName() == 'function'){
                for(Integer iEntity=0;iEntity<getchildNodeSummary.getChildElements().size();iEntity++){
                    Dom.XMLNode getchildNodeEntitySummary = getchildNodeSummary.getChildElements().get(iEntity);
                    if(getchildNodeEntitySummary.getName() == 'row'){                    
                         //get the entity text  
                         List<String> listEntityTextSummary = new List<String>();  
                         for(Integer iEntityText=0;iEntityText<getchildNodeEntitySummary.getChildElements().size();iEntityText++){ 
                            Dom.XMLNode getchildNodeEntityTextSummary = getchildNodeEntitySummary.getChildElements().get(iEntityText);
                            listEntityTextSummary.add(getchildNodeEntityTextSummary.getText());
                         }
                         listOfListOfStringsSummary.add(listEntityTextSummary);
                         
                    }
                }
            }
       }
    
     }
    //------------------   

     public class Row
     {
        public String TID {get; set;} 
        public String name {get; set;}
        public String subject {get; set;}
        public String createDate {get; set;}
        public String createby {get; set;}
     }
 
     public List<Row> getData()
     {   
          List<Row> yourDataAsAListOfRow = new List<Row>(); 
          for(Integer i=0;i<listOfListOfStrings.size();i++)
          {
                Row abc = new Row();
                abc.TID = listOfListOfStrings.get(i).get(6);
                abc.name = listOfListOfStrings.get(i).get(0);
                //
                string strsubject= listOfListOfStrings.get(i).get(4);
                strsubject = strsubject.replaceAll('\n', '<br/>');
                //
                abc.subject = strsubject; 
                abc.createDate = listOfListOfStrings.get(i).get(5);
                abc.createby = listOfListOfStrings.get(i).get(9);
                yourDataAsAListOfRow.add(abc);
         }  
         return yourDataAsAListOfRow;
    }
    
    public class Rowdetails 
     {
        public String refNumber {get; set;}
        public String subject {get; set;}
        public String assignedTo {get; set;}
        public String status {get; set;}
     }
 
     public List<Rowdetails> getDatadetails()
     {
        List<Rowdetails> yourDataAsAListOfRowdetails = new List<Rowdetails>();  
        for(Integer i=0;i<listOfListOfStringsSummary.size();i++)
        {
            Rowdetails mno = new Rowdetails();      
            mno.refNumber = listOfListOfStringsSummary.get(i).get(0);
            mno.subject = listOfListOfStringsSummary.get(i).get(1);
            mno.assignedTo = listOfListOfStringsSummary.get(i).get(2);
            mno.status = listOfListOfStringsSummary.get(i).get(3);
            yourDataAsAListOfRowdetails.add(mno);
            
            strSummaryRefNum = listOfListOfStringsSummary.get(i).get(0);
            strSummarySub = listOfListOfStringsSummary.get(i).get(1);
            strSummaryAssTo  = listOfListOfStringsSummary.get(i).get(2);
            strSummaryStatus  = listOfListOfStringsSummary.get(i).get(3);
            
        }   
        return yourDataAsAListOfRowdetails;
    }
    
 }