public class MarketoLeadRecord {
 public String strId {get;set;}
 public String strSfdcId{get;set;}
 public String strEmailId {get;set;}
 public String  Unsubscribed {get;set;}
 public String  FirstName {get;set;}
 public String Company {get;set;}
 public String  Referralc {get;set;}
 public String LastName {get;set;}
 public String ActivityID{get;set;}
 
  public String LeadScorec {get;set;}
  public String LeadStatus {get;set;}
  public String OwnerManagerEmailc {get;set;}
  public String LeadSource {get;set;}
 public Boolean checked { get; set; }


  public String Activity {get;set;}
  
  public String WSDLTimestamp {get;set;}
    public String LOCALTimestamp {get;set;}
   public String Source {get;set;}
   public String NewValue {get;set;}
  public String LeadID {get;set;}
  public String AttributeName {get;set;}
  public String OldValue {get;set;}
  public String Reason {get;set;}
  public String activityDateTime{get;set;}

public String campaign{get;set;}




static public Map<String, String> getLeadAttributeMap(Mktows.ArrayOfAttribute aoAttrs) {
        
        Map<String, String> mapData = new Map<String, String>();
        if (aoAttrs != null) {
            List<Mktows.Attribute> tempAttrList = aoAttrs.attribute;
            if (tempAttrList != null) {
                String name = null;
                String value = null;
//              String type = null;
//              JAXBElement<String> elem = null;
                for (Mktows.Attribute attr : tempAttrList) {
                    name = attr.attrName;
                    value = attr.attrValue;
//                  type = attr.getAttrType();
                    mapData.put(name, value);
                }
            }
        }
        return mapData ;
    }
/* static testMethod void testSurveyController() {
    
    MarketoLeadRecord obj=new MarketoLeadRecord ();
    Mktows.ArrayOfAttribute obj2=new Mktows.ArrayOfAttribute();
     try{
        MarketoLeadRecord.getLeadAttributeMap(obj2);
      }catch(Exception e){}
    
      
      
 }*/


}