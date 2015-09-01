public class RackspaceDistributionModel{

public String offset{get;set;}
public String size{get;set;}
public String total{get;set;}
public Boolean isHidden{get;set;}
public String displayName{get;set;}
public String name{get;set;}
public List<String> memberList{get;set;}
public List<distributionlists> distributionlists{get;set;}
public List<emailAddressList> emailAddressList{get;set;}
public List<contacts> contacts{get;set;}

public class distributionlists{
  public String displayName{get;set;}
  public String CommonName {get;set;}
  
  public distributionlists( String displayName,String CommonName){
   this.displayName=displayName;
   this.CommonName=CommonName;
  }
}
public class emailAddressList{
public String address{get;set;}
public Boolean replyTo{get;set;}

}
public class contacts{
public String displayName{get;set;}
public String externalEmail{get;set;}
public String name{get;set;}

}



public Static RackspaceDistributionModel getDistributionListObject(String objJson){
  RackspaceDistributionModel obj = (RackspaceDistributionModel)JSON.deserialize(objJson,RackspaceDistributionModel.class);
  system.debug('#### RackspaceDistributionModel' + obj);
return obj;
}

/* public static testmethod void MyUnitTest() {
    RackspaceDistributionModel obj=new RackspaceDistributionModel();
    RackspaceDistributionModel.distributionlists obj2=new RackspaceDistributionModel.distributionlists('test','test');
    RackspaceDistributionModel.emailAddressList obj3=new RackspaceDistributionModel.emailAddressList();
    RackspaceDistributionModel.contacts obj4=new RackspaceDistributionModel.contacts();
 
   String strResponse='{"distributionlists":[{"displayName":"TestUnmanagedDL","name":"testunmanageddl"},{"displayName":"UnmanagedDL","name":"unmanageddl"}],"offset":0,"size":250,"total":2}';
   RackspaceDistributionModel.getDistributionListObject(strResponse);
 }*/

}