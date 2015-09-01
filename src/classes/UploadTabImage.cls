public class UploadTabImage{

  public Intranet_Main_Tab__c mainTabObj{get;set;}
  private ApexPages.StandardController controller {get; set;}
  public String imageName{get;set;}
  public Document objThumbanailDocument {get;set;}
  public String strFilenameExtension {get;set;} 
  public String strFilename {get;set;}  
  Boolean isDefault{get;set;}
  public Boolean isUpload{get;set;} 
  public Boolean isValidUser {get;set;}
  
  public UploadTabImage(ApexPages.StandardController controllerSdtr) {
        isUpload = true;  
        isDefault = false;
        this.controller=controllerSdtr;
        mainTabObj = (Intranet_Main_Tab__c)controllerSdtr.getRecord();
        for(Intranet_Main_Tab__c obj:[Select Id, Tab_Image_Id__c, Name FROM Intranet_Main_Tab__c where id=:mainTabObj.id]){
           mainTabObj= obj;
        }
        imageName = mainTabObj.Name;
        setThumbnailImageDocumentDetails();
   }

 

    public void setThumbnailImageDocumentDetails() {
        if (objThumbanailDocument == null)
            objThumbanailDocument =new Document();
        if(mainTabObj.Tab_Image_Id__c !=null && mainTabObj.Tab_Image_Id__c !=''){
            try{
                objThumbanailDocument=[Select Id, name,body from document where id=:mainTabObj.Tab_Image_Id__c];
                if(objThumbanailDocument.Name.trim() == 'Default') {
                    isDefault = true;
                    objThumbanailDocument = new Document();
                } else {
                    objThumbanailDocument.body=null;
                     strFilename =  objThumbanailDocument.Name;
                }
            }catch(Exception e){
                isDefault = true;
            }
        } 
    }
 
    public PageReference uploadImage() {
        userValidate();
        if(isValidUser) {
          try{
            if(strFilename == null || strFilename == '') {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File Name is Required.'));
                return null;  
            }
            if(objThumbanailDocument.body == null) {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File not exists.'));
                return null;  
            }
            
              objThumbanailDocument.AuthorId = UserInfo.getUserId();
              Folder objDocument=[Select id from Folder where name='Intranet Tab Images'];
              if(objThumbanailDocument.body!=null) {
                  objThumbanailDocument.FolderId=objDocument.id;
              }
          } catch(Exception e) {
              if(objThumbanailDocument.body != null){
                  objThumbanailDocument.FolderId= UserInfo.getUserId();
              }
          }
          try {
              objThumbanailDocument.ContentType='image';
              objThumbanailDocument.IsPublic=true;
              
              //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,objThumbanailDocument.name));
              //return null;
              
              boolean isImageFile = false;
              
              isImageFile = getFileExtension(objThumbanailDocument.Name);
              
              //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,String.valueOf(isImageFile)));
              //return null;
              
              if(isImageFile) {
                if(objThumbanailDocument.body != null && strFilename != null){
                  objThumbanailDocument.name = strFilename;
                    upsert objThumbanailDocument;
                    isUpload = false;
                }
                if(isDefault == true  && objThumbanailDocument.body!=null) {
                    mainTabObj.Tab_Image_Id__c =objThumbanailDocument.id;
                } else if( (mainTabObj.Tab_Image_Id__c ==null || mainTabObj.Tab_Image_Id__c =='') && objThumbanailDocument.body!=null){
                    mainTabObj.Tab_Image_Id__c =objThumbanailDocument.id;
                }  
               update mainTabObj;
               isUpload = false;
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
              } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unsupported image type cannot be uploaded.'));
              return null;
              }
          } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'+ e.getMessage()));
              return null;
          } finally {
              objThumbanailDocument.body=null;
          }
          //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
          // Apexpages.currentPage().setRedirect(true);
        }
        return Apexpages.currentPage();
    }
    //private Map<String, String> 
    private boolean getFileExtension(String strFileName) {
      boolean isImagefile = false;
      if(strFileName.endsWith('jpg') 
        || strFileName.endsWith('png') 
        || strFileName.endsWith('gif') 
        || strFileName.endsWith('tiff') 
        || strFileName.endsWith('jpeg')) {
        isImagefile = true;
      }
        return isImagefile;
    }
     public PageReference onEdit() {
         isUpload = true;
         return Apexpages.currentPage();
     }
     
     public PageReference userValidate(){
      isValidUser = true;
      String SYSADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
      //UserInfo.getUserId();
      String Owner_id = [Select Owner.ID From Intranet_Main_Tab__c Where id =: ApexPages.currentPage().getParameters().get('id')].Owner.ID;
      
      if(!(Owner_id == UserInfo.getUserId() || SYSADMIN_PROFILE_ID == UserInfo.getProfileId()) ) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You Can not Update This Record Because You Are Not An Admin or Owner Of This Record.'));
        isValidUser = false;
        // return null; 
        //return ApexPages.CurrentPage(); 
      }
      return null; 
      //return isValidUser;    
    } 
    
  /*  @isTest(SeeAllData=true)
   static  void UploadTabImageTest() {
       Intranet_Main_Tab__c temp = new Intranet_Main_Tab__c();
    temp.IsDisabled__c = false;
    temp.Name ='Home';
    temp.IsPublic__c = true;
    temp.Position_Type__c ='Top';
    temp.Content__c = '';
    insert temp;
      ApexPages.currentPage().getParameters().put('id', temp.id);
      
      ApexPages.StandardController sc = new ApexPages.StandardController(temp);  
       
      UploadTabImage uploadImageTest = new UploadTabImage(sc);
      uploadImageTest.uploadImage();  
      
      uploadImageTest.strFilename = 'test'; 
      uploadImageTest.uploadImage();  
      
      uploadImageTest.getFileExtension('a.jpg');
      uploadImageTest.onEdit(); 
      
      uploadImageTest.objThumbanailDocument.body = Blob.valueOf('test');
      uploadImageTest.objThumbanailDocument.Name ='a.jpg';
      uploadImageTest.uploadImage();              
   }*/
}