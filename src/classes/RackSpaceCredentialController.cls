public class RackSpaceCredentialController{

private static String User_Agent='Rackspace Management Interface';
  
  public Static CredentialModel getRackspaceCredential(){
     String csvbody='';
     CredentialModel objCredentialModel =new CredentialModel();
      try{
          List<Document> d = [Select body, bodyLength, ContentType, Url from Document where Name ='RackSpaceLoginCredential'];
              if(d.size()>0){
                      Blob b = d[0].body;
                      csvbody= b.toString();
                    objCredentialModel =getDetail(csvbody);
              }
        }catch(Exception e){
           objCredentialModel.strMessage=e.getMessage()+'Line Number'+e.getLineNumber();
        }      
      return objCredentialModel; 
   }

 public Static CredentialModel getDetail(String csvbody){
    CredentialModel objCredentialModel =new CredentialModel();
    List<String> lstCsvValue=csvbody.split('EOL');
    Map<String,String> mapKeyVal=new Map<String,String>();
    
     for(String strValue:lstCsvValue){
         if(strValue!=null && strValue!=''){
           List<String> lstCsvValue2=strValue.split(',');
            if(lstCsvValue2.size()>1){
              mapKeyVal.put(lstCsvValue2.get(0).trim(),lstCsvValue2.get(1).trim());   
            }
          }    
     }
   
     objCredentialModel.strAccountNumber=mapKeyVal.get('Account Number');
     objCredentialModel.strDomainName=mapKeyVal.get('Domain Name');
     objCredentialModel.strApiKey=mapKeyVal.get('Rackspace ApiKey');
     objCredentialModel.secretKey=mapKeyVal.get('Rackspace Secret Key');
     objCredentialModel.strSignature=getSignature(objCredentialModel.strApiKey,objCredentialModel.secretKey);
     System.debug(String.valueOf(objCredentialModel+'~~~~~~~~~~~~~~objCredentialModel'));
     return objCredentialModel;
}

public class CredentialModel{
  public String strAccountNumber{get;set;}
  public String strDomainName{get;set;}
  public String strApiKey{get;set;}
  public String secretKey{get;set;}
  public String strSignature{get;set;}
  public String strMessage{get;set;}
}

public static String getTimeStamp(){
       Datetime myDT = Datetime.now();
       String strTimeStamp = myDT.format('yyyy/MM/dd hh:mm:ss'); 
       strTimeStamp =strTimeStamp.replaceAll('/','').replaceAll(' ','').replaceAll(':','');
    return strTimeStamp;
 }

 public Static String getSignature(String strApiKey,String secretKey){
      String strTimeStamp=getTimeStamp();
      String strSHA1Hash=strApiKey+User_Agent+strTimeStamp+secretKey;
      Blob hash =(Crypto.generateDigest('SHA1',Blob.valueOf(strSHA1Hash)));
      strSHA1Hash = EncodingUtil.base64Encode(hash);
 
    return strApiKey+':'+strTimeStamp +':'+strSHA1Hash;
  }


}