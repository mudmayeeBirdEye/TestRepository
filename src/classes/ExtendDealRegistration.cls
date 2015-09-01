public class ExtendDealRegistration{

	  public String strComments{get;set;}
	  VAR_Deal_Registration__c objVARDealRegistration{get;set;}
	  public Boolean isRecordExist{get;set;}
	  public ApexPages.StandardController con{get;set;} 
  
   public ExtendDealRegistration(ApexPages.StandardController controller) {
	      try{
               strComments='';
               con=controller;
               objVARDealRegistration=(VAR_Deal_Registration__c)controller.getRecord();
               objVARDealRegistration=[Select Registration_Status__c,Approval_Date__c,Extension_Status__c,Extension_Approved__c from VAR_Deal_Registration__c where id=:objVARDealRegistration.id];
	        
	            if(objVARDealRegistration.Registration_Status__c=='Approved' && objVARDealRegistration.Approval_Date__c!=null && objVARDealRegistration.Extension_Status__c=='Pending'){
	                        isRecordExist=false;
	                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Since this expiration extension request is already submit for approval, you cannot perform this action any more'));
	               }else if(objVARDealRegistration.Registration_Status__c=='Approved' && objVARDealRegistration.Approval_Date__c!=null && objVARDealRegistration.Extension_Status__c=='Approved' ){
		                    isRecordExist=false;
		                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Since this expiration extension request is already approved, you cannot perform this action any more'));
	                 }else if(objVARDealRegistration.Registration_Status__c!='Approved'){
		                    isRecordExist=false;
		                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Since This deal resistration is not approved, you cannot perform this action any more'));
	                }else if(objVARDealRegistration.Registration_Status__c=='Approved' && objVARDealRegistration.Approval_Date__c!=null && objVARDealRegistration.Extension_Status__c!='Pending'){
	                        isRecordExist=true;
	                }
	          }catch(Exception e){
	              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
	              isRecordExist=false;
	          }
	       }
	  
  public pagereference submitForApproval(){
         
      Savepoint sp=null;
      try{
	         sp = Database.setSavePoint();
	        
	         objVARDealRegistration.Comments__c=strComments;
	         objVARDealRegistration.Extension_Status__c='Pending';
	         update objVARDealRegistration;
	     
	       
	        Approval.ProcessSubmitRequest req1 =new Approval.ProcessSubmitRequest();
	        req1.setComments('Submitting expiration extension request for approval.');
	        req1.setObjectId(objVARDealRegistration.id);
	        
	       Approval.ProcessResult result = Approval.process(req1);
        
        }catch(Exception e){
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
            return null;
         }
     return(con.view());
}
    /*public static testmethod void myUnitTest() {
        
        try{ 
	         Account  objAccount= (Account  )SmartFactory.createSObject('Account', true);
	         objAccount.Partner_id__c='123456Test';
	         upsert objAccount;
	        
	         Contact objContact= (Contact)SmartFactory.createSObject('Contact', true);
	         objContact.AccountId=objAccount.id;
	         upsert objContact;
	         
	          objContact=[Select Account.Partner_id__c from Contact where id=:objContact.id];
	          System.assert(objContact.Account.Partner_id__c=='123456Test');
	          
	          
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
	           ApexPages.StandardController controller=null;
	           ExtendDealRegistration objExtendDealRegistration=null;
	          
	          system.runAs(objUser){
	                 objDeal=new  VAR_Deal_Registration__c();
	                objDeal.Company_Name__c='testSimplion';
	                objDeal.Email_1__c='kanisk@test.com';
	                objDeal.Phone__c = '123456789';
	                objDeal.Number_of_Users__c = 5;
	                insert objDeal;
	             
	              System.assert(UserInfo.getUserId()==objUser.id);
	              System.assert(objDeal.id!=null);
	             
	              workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,
	                                                            p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId 
	                                                            From ProcessInstanceWorkitem p where
	                                                             p.ProcessInstance.TargetObjectId = :objDeal.Id]; 
	              System.assertEquals('Pending', workItemList.get(0).ProcessInstance.Status);                                                  
	               controller=new ApexPages.StandardController(objDeal);
	               objExtendDealRegistration=new ExtendDealRegistration(controller);
	             }
	            
	             Approval.ProcessWorkitemRequest req2 =new Approval.ProcessWorkitemRequest();
	             req2.setComments('Approving request.');
	             req2.setAction('Approve');
	             req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
	             req2.setWorkitemId(workItemList.get(0).id);
	        
	            Approval.ProcessResult result2 =  Approval.process(req2);
	            System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
	            System.assertEquals('Approved', result2.getInstanceStatus(),'Instance Status'+result2.getInstanceStatus());                                                
	                         
	           system.runAs(objUser){ 
	                 controller=new ApexPages.StandardController(objDeal);
	                 objExtendDealRegistration=new ExtendDealRegistration(controller);
	                 objExtendDealRegistration.submitForApproval();
	                 
	                 //catch block code coverage
	                  controller=new ApexPages.StandardController(objDeal);
	                  objExtendDealRegistration=new ExtendDealRegistration(controller);
	                  objExtendDealRegistration.submitForApproval();
	             }
	             workItemList = [Select p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId,
	                                                            p.ProcessInstanceId,p.OriginalActorId,p.Id,p.ActorId 
	                                                            From ProcessInstanceWorkitem p where
	                                                             p.ProcessInstance.TargetObjectId = :objDeal.Id]; 
	            
	            Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();
	            req3.setComments('Approving request.');
	            req3.setAction('Approve');
	            req3.setNextApproverIds(new Id[] {UserInfo.getUserId()});
	            req3.setWorkitemId(workItemList.get(0).id);
	        
	           result2 =  Approval.process(req3);
	    
	           System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
	    
	           System.assertEquals('Approved', result2.getInstanceStatus(),'Instance Status'+result2.getInstanceStatus());
	          
	          system.runAs(objUser){ 
	              controller=new ApexPages.StandardController(objDeal);
	              objExtendDealRegistration=new ExtendDealRegistration(controller);
	             
	             //catch block code coverage
	               VAR_Deal_Registration__c  objDeal2= (VAR_Deal_Registration__c )SmartFactory.createSObject('VAR_Deal_Registration__c',false);
	               controller=new ApexPages.StandardController(objDeal2);
	               objExtendDealRegistration=new ExtendDealRegistration(controller);
	          }
        }catch(Exception e){
        	
        }   
    }*/
}