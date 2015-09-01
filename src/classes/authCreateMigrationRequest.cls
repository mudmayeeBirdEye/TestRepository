global class authCreateMigrationRequest{


//Define an object in apex that is exposed in apex web service
   global class authUserInputParam{
        /*Input*/
         webservice String In_RCUserID;
        webservice String In_RCPrimaryNumber;
        webservice String In_ContactMail;
        /*output*/
        webservice String OUT_Status;
  }
   
   webservice static authUserInputParam createMigrationRequest(authUserInputParam vauthUserInputParam) {          
        
        /*Logic to get USRID*/
        String strUserId=vauthUserInputParam.In_RCUserID;
       try{
       /*Logic to get Account */
          List<Account> lstAccount=[Select id,Number_of_DL_s__c from Account where RC_User_ID__c=:strUserId limit 1];
        
       /*Logic to get Contact*/   
             List<Contact> liContact= [SELECT Account_Brand__c, Id, Email, Phone FROM Contact  WHERE Account.RC_User_ID__c =:vauthUserInputParam.In_RCUserID
             AND email =:vauthUserInputParam.In_ContactMail limit 1];    
             
           if(lstAccount.size()>0){
               Account objLocalAcoount;
               Contact objLocalContact;
               RecordType objRecordType=[SELECT Name,Id FROM RecordType where Name='Migration Request'];
               if(isAlreadyRequested(lstAccount,liContact,objRecordType.id,vauthUserInputParam)){
                   return vauthUserInputParam;
               }
            
             //String strContactId='';
             for(Account objAccount:lstAccount){
              objLocalAcoount=objAccount;
              
              if(liContact.size()>0){
                 objLocalContact=liContact.get(0);
              }else{
                 objLocalContact=new Contact();
              } 
            
             Map<String,Group> mapGroup=New Map<String,Group>();
             for(Group gp:[Select id,name from group where Type='Queue']){
                  mapGroup.put(gp.Name,gp);
             }
             
             Group objGroup=null;
             if(objLocalAcoount.Number_of_DL_s__c==null){
                  objLocalAcoount.Number_of_DL_s__c=0;
             }
           
         /* for(String str:mapGroup.keySet()){
            system.debug('Queue='+str+'/n');
          }*/
             if(objLocalAcoount.Number_of_DL_s__c>=20){
                 objGroup=mapGroup.get('SE Team');
             }else{
                objGroup=mapGroup.get('US Ops Team Queue');
             }
           
              Case objCase=new Case();
              objCase.RecordTypeId=objRecordType.id;
              if(objGroup!=null){
                 objCase.OwnerId=objGroup.id;
               }
              objCase.AccountId=objLocalAcoount.id;
               // if(objLocalContact!=null){
                  objCase.ContactId=objLocalContact.id;
                //}
              objCase.Subject='Customer with RCUserID:'+strUserId+' has requested to be migrated to Amarosa';
              objCase.Description=strUserId+';'+
                                  'Number of Digitial Lines (from account):'+objLocalAcoount.Number_of_DL_s__c+';'+
                                   'Primary contact phone number:'+(objLocalContact.Phone==null?'Not Found':objLocalContact.Phone)+';'+
                                   'Primary contact email address:'+(objLocalContact.Email==null?'Not Found':objLocalContact.Email);
                                
             insert objCase;
              vauthUserInputParam.OUT_Status='success';
              }
           
           }else{
              vauthUserInputParam.OUT_Status='NotFound';
           }
       }catch(Exception e){
       system.debug('exception==='+e+'Line Number=='+e.getLineNumber());
        vauthUserInputParam.OUT_Status='exception';
        //return vauthUserInputParam;
       }
       return vauthUserInputParam;
   }
   
  private Static Boolean isAlreadyRequested(List<Account> lstAccount,List<Contact> lstContact,String strRecordTypeId,authUserInputParam vauthUserInputParam){
      Boolean isExist=false;
      for(Account objAccount:lstAccount){
          String strContactId=lstContact.size()>0?lstContact.get(0).id:null;
          for(Case objCase:[Select id,Status from Case where AccountId=:objAccount.id and ContactId=:strContactId and RecordTypeId=:strRecordTypeId limit 1]){
            if(objCase.Status !='New'){
               vauthUserInputParam.OUT_Status='closed';
            }else if(objCase.Status =='New'){
               vauthUserInputParam.OUT_Status='new';
            }
            isExist=true;      
       }
    }
    return isExist;
 }
  /*static testMethod void testAuth(){
     try{
             Account  objAccount= (Account  )SmartFactory.createSObject('Account', true);
             objAccount.Partner_id__c='123456Test12345';
             objAccount.RC_User_ID__c='12345';
             upsert objAccount;
            
             Contact objContact= (Contact)SmartFactory.createSObject('Contact', true);
             objContact.AccountId=objAccount.id;
             objContact.email='kanishk.singh@simplion.com';
             upsert objContact;
  
           authUserInputParam vauthUserInputParam=new authUserInputParam ();
           vauthUserInputParam.In_RCUserID=objAccount.RC_User_ID__c;
           vauthUserInputParam.In_RCPrimaryNumber='';
           vauthUserInputParam.In_ContactMail= objContact.email;
           
           authCreateMigrationRequest.createMigrationRequest(vauthUserInputParam);
           authCreateMigrationRequest.createMigrationRequest(vauthUserInputParam);
           
           Case objCase=[Select id,Status from Case where AccountId=:objAccount.id and ContactId=:objContact.id];
           objCase.status='closed';
            update objCase;
            authCreateMigrationRequest.createMigrationRequest(vauthUserInputParam);
           
           vauthUserInputParam.In_RCUserID='test12345';
           vauthUserInputParam.In_RCPrimaryNumber='';
           vauthUserInputParam.In_ContactMail= objContact.email;
           
           authCreateMigrationRequest.createMigrationRequest(vauthUserInputParam);
           
           
           
      }catch(Exception e){}     
  }*/
  
  
  
  
    
}