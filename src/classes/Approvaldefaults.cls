public with sharing class  Approvaldefaults{
    public Approvaldefaults(ApexPages.StandardController controller) {
           actapprovalObject();
    } 
     public  PageReference actapprovalObject() {
         
        // User u = [SELECT ManagerId from User WHERE id=:UserInfo.getUserId() ]; 
        // User mu = [SELECT Name, id from User WHERE id=:u.ManagerId];
        List<User> userlist = [SELECT ManagerId,Manager.Name from User WHERE id=:UserInfo.getUserId()];
        
        // ID qid = [Select id from group where Type=:'Queue' and Name=:'Bid Desk'].id ; 
                        
        //  PageReference approvalPage = new PageReference('/a0k/e');
        PageReference approvalPage = new PageReference('/a0e/e');
        //puting default value of manager
        /* approvalPage.getParameters().put('CF00NQ0000000qeYI',mu.name);
          approvalPage.getParameters().put('CF00NQ0000000qeYI_lkid',mu.id);*/
          
          if(userlist != null && userlist.size()>0) {
      		approvalPage.getParameters().put('CF00N80000004iCn4',userlist[0].Manager.Name);
          	approvalPage.getParameters().put('CF00N80000004iCn4_lkid',userlist[0].ManagerId);		
          }
          
         // approvalPage.getParameters().put('CF00N80000004iCn4',mu.name);
         // approvalPage.getParameters().put('CF00N80000004iCn4_lkid',mu.id);
		  //00N80000004iCmz     
         approvalPage.getParameters().put('CF00N80000004iCmz',ApexPages.currentPage().getParameters().get('CF00N80000004iCmz'));
         approvalPage.getParameters().put('CF00N80000004iCmz_lkid',ApexPages.currentPage().getParameters().get('CF00N80000004iCmz_lkid'));	
          
          // using this method to retrive return url :ApexPages.currentPage().getParameters().get('retURL');
          //save_new_url RecordType
          approvalPage.getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
         // approvalPage.getParameters().put('save_new_url',ApexPages.currentPage().getParameters().get('save_new_url'));
          approvalPage.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType'));
          
         approvalPage.getParameters().put('CF00N80000004iTTJ',ApexPages.currentPage().getParameters().get('CF00N80000004iTTJ'));
         approvalPage.getParameters().put('CF00N80000004iTTJ_lkid',ApexPages.currentPage().getParameters().get('CF00N80000004iTTJ_lkid'));	
         
         approvalPage.getParameters().put('CF00N80000004ieSF',UserInfo.getName());
         approvalPage.getParameters().put('CF00N80000004ieSF_lkid',UserInfo.getUserId()); 
         
         approvalPage.getParameters().put('CF00N80000004ieQs',ApexPages.currentPage().getParameters().get('CF00N80000004ieQs'));
         approvalPage.getParameters().put('CF00N80000004ieQs_lkid',ApexPages.currentPage().getParameters().get('CF00N80000004ieQs_lkid'));
         
         // Opportunity // Invoice
         
         if(!string.Isblank(ApexPages.currentPage().getParameters().get('RecordType'))) {
         	string recordtypeId = ApexPages.currentPage().getParameters().get('RecordType');
         	Schema.DescribeSObjectResult result = Approval__c.SObjectType.getDescribe();
		 	Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById(); 
         	if(rtMapByName.get(recordtypeId).getName() == 'Invoicing Request') {  //recordtypeId == '012V00000004Rkt'
                 try {
                     approvalPage.getParameters().put('CF00N80000004j6pF',ApexPages.currentPage().getParameters().get('CF00N80000004j6pF'));
                     approvalPage.getParameters().put('CF00N80000004j6pF_lkid',ApexPages.currentPage().getParameters().get('CF00N80000004j6pF_lkid'));  
                     List<Opportunity> oppList = [select AccountId,Account.Name from Opportunity 
                     								where Id = :ApexPages.currentPage().getParameters().get('CF00N80000004j6pF_lkid') limit 1];
                     if(oppList != null && oppList.size()>0) {
                     	approvalPage.getParameters().put('CF00N80000004iCmz',oppList[0].Account.Name);
                     	approvalPage.getParameters().put('CF00N80000004iCmz_lkid',oppList[0].AccountId);
                     }								
                 } catch(Exception ex) {}
         	}
         	if(rtMapByName.get(recordtypeId).getName() == 'Refund Approval') {
         		approvalPage.getParameters().put('CF00N80000005Hece',UserInfo.getName());
         		approvalPage.getParameters().put('CF00N80000005Hece_lkid',UserInfo.getUserId());
 			}
 			if(rtMapByName.get(recordtypeId).getName() == 'Farming Claim Owner') {
         		approvalPage.getParameters().put('CF00N80000005HUXw',UserInfo.getName());
         		approvalPage.getParameters().put('CF00N80000005HUXw_lkid',UserInfo.getUserId());
         	}
         }	
          
          
      	 approvalPage.getParameters().put('nooverride','1');
         approvalPage.setRedirect(true);
          
        return approvalPage;
    }
    
   /* static testMethod void isTest(){
        Approvaldefaults app = new Approvaldefaults(null);
        //app.actapprovalObject();
   } */
   
 }