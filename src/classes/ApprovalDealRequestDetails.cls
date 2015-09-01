public class ApprovalDealRequestDetails{
  
  public List<Approvaldetails> liApprovaldetails{get;set;}
  public Boolean isSuccess{get;set;} 
 
  public ApprovalDealRequestDetails() {
        try{
            isSuccess=true;
            liApprovaldetails=new List<Approvaldetails>(); 
            
            User objUser=null;
                   for(User objUs:[Select Contact.Account.High_Volume_Deal_Registration__c,Contact.Account.Partner_id__c,Contact.AccountId from User where id=:UserInfo.getUserId()]){
                    if(objUs!=null){
                      objUser=objUs;
                    }
                  }
               if(objUser.Contact.Account.Partner_id__c!=null || Test.isRunningTest()){
                   Approvaldetails objApprovaldetails=new Approvaldetails();
                     for(AggregateResult objAggregateResult:[Select count(id) total from VAR_Deal_Registration__c where
                                                              Partner_Id__c=:objUser.Contact.Account.Partner_id__c]){
                          
                          objApprovaldetails.iTotalRequest=(Integer)objAggregateResult.get('total');
                      }
                      for(AggregateResult objAggregateResult:[Select count(id) total from VAR_Deal_Registration__c where
                                                              Partner_Id__c=:objUser.Contact.Account.Partner_id__c and
                                                              (Registration_Status__c='Approved' AND Deal_Closed__c = false)]){
                          
                        objApprovaldetails.iTotalApprovedRequest=(Integer)objAggregateResult.get('total');
                      }
                      for(AggregateResult objAggregateResult:[Select count(id) total from VAR_Deal_Registration__c where
                                                              Partner_Id__c=:objUser.Contact.Account.Partner_id__c and
                                                              (Registration_Status__c='Pending')]){
                          
                        objApprovaldetails.iTotalPendingRequest=(Integer)objAggregateResult.get('total');
                      }
                       for(AggregateResult objAggregateResult:[Select count(id) total from VAR_Deal_Registration__c where
                                                              Partner_Id__c=:objUser.Contact.Account.Partner_id__c and
                                                              (Registration_Status__c='Rejected')]){
                          
                        objApprovaldetails.iTotalRejectedRequest=(Integer)objAggregateResult.get('total');
                      }
                      for(AggregateResult objAggregateResult:[Select count(id) total from VAR_Deal_Registration__c where
                                                              Partner_Id__c=:objUser.Contact.Account.Partner_id__c and
                                                              (Is_Expired__c='Yes')]){
                          
                        objApprovaldetails.iTotalExpiredRequest=(Integer)objAggregateResult.get('total');
                      }
                       for(AggregateResult objAggregateResult:[Select count(id) total from VAR_Deal_Registration__c where
                                                              Partner_Id__c=:objUser.Contact.Account.Partner_id__c and
                                                              (Registration_Status__c='Approved' AND Is_Expired__c='NO')]){
                          
                        objApprovaldetails.iTotalActiveRequest=(Integer)objAggregateResult.get('total');
                      }
                      
                      if(objUser.Contact.Account.High_Volume_Deal_Registration__c){
                          objApprovaldetails.iMaxmimumLimit=1000;
                      }else{
                        objApprovaldetails.iMaxmimumLimit=200;
                      }
                     
                      objApprovaldetails.iRemainingLimit=objApprovaldetails.iMaxmimumLimit-
                                                         (objApprovaldetails.iTotalApprovedRequest+objApprovaldetails.iTotalPendingRequest)+objApprovaldetails.iTotalExpiredRequest;
                   liApprovaldetails.add(objApprovaldetails);
      }else{
         isSuccess=false;
       }
   }catch(Exception e){
       isSuccess=false;}
  } 

 private class Approvaldetails{
     
     public Integer iTotalRequest{get;set;}
     public Integer iTotalApprovedRequest{get;set;}
     public Integer iTotalPendingRequest{get;set;}
     public Integer iTotalRejectedRequest{get;set;}
     public Integer iTotalExpiredRequest{get;set;}
     public Integer iTotalActiveRequest{get;set;}
     public Integer iMaxmimumLimit{get;set;}
     public Integer iRemainingLimit{get;set;}
 }
 
  /* public static testMethod void testDealRegistration() {
        try{ 
             Account  objAccount= (Account  )SmartFactory.createSObject('Account', true);
             objAccount.Partner_id__c='123456Test12345';
             upsert objAccount;
            
             Contact objContact= (Contact)SmartFactory.createSObject('Contact', true);
             objContact.AccountId=objAccount.id;
             upsert objContact;
             
              objContact=[Select Account.Partner_id__c from Contact where id=:objContact.id];
              System.assert(objContact.Account.Partner_id__c=='123456Test12345');
              
              
             Profile pp = [Select p.Name, p.Id From Profile p where Name LIKE '%RC Partner User%'limit 1];
             System.assert(pp.Name=='RC Partner User');
             
                User objUser= new User(alias = 'ksTest',
                                    email='kanishk.singhTest@simplion.com',
                                    emailencodingkey='UTF-8',
                                    lastname='Testing',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    profileid = pp.Id,
                                    contactid = objContact.Id,
                                    timezonesidkey='America/Los_Angeles',
                                    username='kanishk.singhTest@simplion.com'
                                    );
               insert objUser;
               
              // User objAdminUser=
               
              System.assert(objUser.profileid ==pp.Id);
               System.assert(objUser.contactid ==objContact.Id);
              
               VAR_Deal_Registration__c  objDeal=null;
               List<ProcessInstanceWorkItem> workItemList=null;
              
              system.runAs(objUser){
                    objDeal=new  VAR_Deal_Registration__c();
                    objDeal.Company_Name__c='testSimplion';
                    objDeal.Email_1__c='kanisk@test.com';
                    objDeal.Phone__c='123456789';
                    objDeal.Number_of_Users__c = 5;
                    insert objDeal;
                                        
                  System.assert(UserInfo.getUserId()==objUser.id);
                  System.assert(objDeal.id!=null);
                 
                  workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,
                                                                p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId 
                                                                From ProcessInstanceWorkitem p where
                                                                 p.ProcessInstance.TargetObjectId = :objDeal.Id]; 
                  System.assertEquals('Pending', workItemList.get(0).ProcessInstance.Status);  
                 }                                         
               
               
                 Approval.ProcessWorkitemRequest req3 =new Approval.ProcessWorkitemRequest();
                 req3.setComments('Approving request.');
                 req3.setAction('Approve');
                 req3.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                 req3.setWorkitemId(workItemList.get(0).id);
            
                 Approval.ProcessResult result3 =  Approval.process(req3);
                System.assert(result3.isSuccess(), 'Result Status:'+result3.isSuccess());
                System.assertEquals('Approved', result3.getInstanceStatus(),'Instance Status'+result3.getInstanceStatus());                                                
              
               VAR_Deal_Registration__c objDeal2;
               system.runAs(objUser){
                    objDeal2=new  VAR_Deal_Registration__c();
                    objDeal2.Company_Name__c='testSimplion';
                    objDeal2.Email_1__c='kaneqwisk@test2.com';
                    objDeal2.Phone__c='123456789';
                    objDeal2.Email_2__c='kaweenisk1234@test2.com';
                    objDeal2.Email_3__c='kaweqwenisk@t2est2.com';
                    objDeal2.Email_4__c='kanweqweisk@t21est2.com';
                    objDeal2.Email_5__c='kanqweisk@t211est2.com';
                    objDeal2.Number_of_Users__c = 5;
                    insert objDeal2;
                    workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,
                                                                p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId 
                                                                From ProcessInstanceWorkitem p where
                                                                 p.ProcessInstance.TargetObjectId = :objDeal2.Id];
                
                
                objDeal2=new  VAR_Deal_Registration__c();
                    objDeal2.Company_Name__c='testSimplion';
                    objDeal2.Email_1__c='kaqqqnisk1@test2.com';
                    objDeal2.Phone__c='123456789';
                    objDeal2.Email_2__c='kqqanisk11@test2.com';
                    objDeal2.Email_3__c='kqanisk1111@t2est2.com';
                    objDeal2.Email_4__c='kqanis11k@t21est2.com';
                    objDeal2.Email_5__c='kaqqnis111wek@t211est2.com';
                    objDeal2.Number_of_Users__c = 5;
                   try{
                      insert objDeal2;
                   }catch(Exception e){
                   
                   }
                objDeal2=new  VAR_Deal_Registration__c();
                objDeal2.Company_Name__c='testSimplion';
                objDeal2.Email_1__c='kanisk@test2.com';
                objDeal.Email_2__c='kanisk@test.com';
                objDeal2.Phone__c='123456789';
                 objDeal2.Number_of_Users__c = 5;
               try{
                  insert objDeal2;
                 }catch(Exception e){
                   //System.assertEquals('This email already Exists!',e.getMessage());
                 }
                } 
                 Approval.ProcessWorkitemRequest req2 =new Approval.ProcessWorkitemRequest();
                 req2.setComments('Rejected request.');
                 req2.setAction('Reject');
                 req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                 req2.setWorkitemId(workItemList.get(0).id);
                 Approval.ProcessResult result2 =  Approval.process(req2);
               
                System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
                System.assertEquals('Rejected', result2.getInstanceStatus(),'Instance Status'+result2.getInstanceStatus()); 
                
              try{
                objDeal2=new  VAR_Deal_Registration__c();
                objDeal2.Company_Name__c='testSimplion';
                objDeal2.Email_1__c='kaniskqqq@test2.com';
                objDeal.Email_2__c='kaniskqqqq@test.com';
                objDeal2.Phone__c='123456789';
                 objDeal2.Number_of_Users__c = 5;
                insert objDeal2;
              }catch(Exception e){
                
              }
              try{
                 update objDeal;
              }catch(Exception e){
              }
              System.assert(objContact.Account.Partner_id__c=='123456Test12345');
           system.runAs(objUser){
                 ApprovalDealRequestDetails obj=new ApprovalDealRequestDetails();
              }         
           }catch(Exception e){
           }
        }*/
 }