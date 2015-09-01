/*-----------------------------------------------------------------------------
* Project Name..........: Replace New Oppty Campaign Selection with Contact Selection          *
* File..................: OpportunityContactRole Class                                         *
* Version...............: 1.0                                                                 *
* Created by............: Simplion Technologies                                               *
* Created Date..........: 07-17-2014                                                          *
* Last Modified by......: Simplion Technologies                                               *
* Description...........: This page is used for selection of contact for opportunity          *
------------------------------------------------------------------------------>*/

public with sharing class OpportunityContactRoleExtension { 
    
     public string accObj {get;set;}
    List<contact> selectcon;
    public Account objacc{get;set;}
    public Boolean isRenderedContactList{get;set;}
    public String ContactRole { get; set; }
    public String strSelectedContactId { get; set; }
    public boolean render {get;set;}      
    
    public transient List<Contact> lstContact{get;set;}
    public Opportunity oppObj {get;set;}
    public List<ContactWrapper> listContactWrapper{get;set;}
    public string primaryContactId {get;set;}
    public string contactIdTemp {get;set;}
	public Boolean isForCancel {get;set;}
        
     public OpportunityContactRoleExtension(ApexPages.StandardController controller) {
       try {
         objacc = new Account();
         oppObj = new Opportunity();    
          lstContact = new List<contact>();           
          listContactWrapper = new List<ContactWrapper>();
		  String recordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
            if(String.isNotBlank(recordTypeId) && recordTypeId.equalsIgnoreCase('01280000000UIxr')){
                isForCancel = true;
            }
          if(ApexPages.currentPage().getParameters().get('accid') != null && ApexPages.currentPage().getParameters().get('accid') != ''){
          oppObj.AccountId = ApexPages.currentPage().getParameters().get('accid');
          if(ApexPages.currentPage().getParameters().get('conid') != null && ApexPages.currentPage().getParameters().get('conid') != '') {
            contactIdTemp = ApexPages.currentPage().getParameters().get('conid');
          }
              getContactList(ApexPages.currentPage().getParameters().get('accid'));
          } else if(ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid') != null && 
              ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid') != '') {
            Order__c orderObj = [select Account__c,Account__r.Name from Order__c where 
                        Id = :ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid') limit 1];    
            oppObj.AccountId = orderObj.Account__c;
            if(oppObj.AccountId != null) {
              getContactList(oppObj.AccountId);
            }
          }
       } catch(Exception ex) {}
    }
    
    public PageReference callDispatcher() {
      string accId;
       string keyPrefix = '/' + Schema.getGlobalDescribe().get('Opportunity').getDescribe().getKeyPrefix() + '/e'; 
      if(UserInfo.getUserType().containsIgnoreCase('Partner')) {
        PageReference objPage2=new PageReference(keyPrefix);
        if(ApexPages.currentPage().getParameters().get('accid') != null && ApexPages.currentPage().getParameters().get('accid') != '') {
                accId = ApexPages.currentPage().getParameters().get('accid');
              List<Account> accObj = [select name from account where Id = :accId limit 1];
              if(accObj != Null && accObj.size() >0 && accObj[0].Name != null) {
                string accountName = accobj[0].Name;
                objPage2.getParameters().put('opp4',accountName);
                objPage2.getParameters().put('opp4_lkid',AccId);
              }
        }
        objPage2.getParameters().put('nooverride','1');
          objPage2.setRedirect(true);
          return objPage2;
      }
      return null;
    }
          
    public void getContactLstOnAccountSelection() {
      try {
        selectedContact = '';
        system.debug('-------'+ oppObj.AccountId);
         lstContact = new List<contact>();           
        listContactWrapper = new List<ContactWrapper>();
           if(oppObj.AccountId != null) {
          getContactList(oppObj.AccountId);
           } 
      } catch(Exception ex) {
        system.debug('-------'+ ex.getMessage());
      }          
   }
     
     public void getContactList(String strAccountId){
       try {
         primaryContactId = null;
         set<Id> contactIdSet = new set<Id>();
         set<Id> contactIdSetAlreadyAdded = new set<Id>();
         map<Id,Contact> mapContactIdToContact = new map<Id,Contact>();
         if(ApexPages.currentPage().getParameters().get('accid') != null && ApexPages.currentPage().getParameters().get('accid') != '') {
           if(ApexPages.currentPage().getParameters().get('accid') != (string.valueOf(strAccountId).length()>15?string.valueOf(strAccountId).substring(0,15):strAccountId)) {
             contactIdTemp = ''; // To check opportunity is creating through contact
           } 
         }
        Account objAccount = [select id,name,RC_Account_Status__c from account where Id = :strAccountId limit 1];
        lstContact = [select id,FirstName,Lastname,Phone,mkto2__Lead_Score__c,CreatedDate,LastModifiedDate,email,Name from contact
                   WHERE AccountId =:strAccountId ORDER BY LastModifiedDate desc limit 1000];
           for(Contact contObj : lstContact) {
             mapContactIdToContact.put(string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id,contObj);
             contactIdSet.add((string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id));
           }        
        if(objAccount != null && objAccount.RC_Account_Status__c == 'Paid') {
          List<AccountContactRole> listAccountContactRole = [select isPrimary,id, ContactId, AccountId  from AccountContactRole 
                                     where AccountId =:strAccountId and isPrimary = true 
                                       order by LastModifiedDate desc limit 1];
             if(listAccountContactRole != null && listAccountContactRole.size()>0) {
               primaryContactId = (string.valueOf(listAccountContactRole[0].ContactId).length()>15?string.valueOf(listAccountContactRole[0].ContactId).substring(0,15):listAccountContactRole[0].ContactId);
             }
             
             // To check opportunity is creating through contact
             if(mapContactIdToContact != null && contactIdTemp != null && mapContactIdToContact.get(contactIdTemp) != null) { 
               Contact contObj = mapContactIdToContact.get(contactIdTemp);
               ContactWrapper objContactWrapper = new ContactWrapper();
             objContactWrapper.setAsPrimary = true;
             primaryContactId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
               objContactWrapper.strId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
                  objContactWrapper.strFName = contObj.FirstName;
                  objContactWrapper.strFLame = contObj.LastName;
                  objContactWrapper.strEmail = contObj.Email;
                   objContactWrapper.strPhoneNumber= contObj.Phone;
                  objContactWrapper.strCreatedDate = contObj.CreatedDate.format();
                  objContactWrapper.strLastMidifiedDate = contObj.LastModifiedDate.format();
                  listContactWrapper.add(objContactWrapper); 
                  contactIdSetAlreadyAdded.add((string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id));
             } else if(mapContactIdToContact != null && primaryContactId != null && mapContactIdToContact.get(primaryContactId) != null) {
               // To check opportunity is not creating through contact
               Contact contObj = mapContactIdToContact.get(primaryContactId);
               ContactWrapper objContactWrapper = new ContactWrapper();
             objContactWrapper.setAsPrimary = true;
             primaryContactId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
               objContactWrapper.strId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
                  objContactWrapper.strFName = contObj.FirstName;
                  objContactWrapper.strFLame = contObj.LastName;
                  objContactWrapper.strEmail = contObj.Email;
                   objContactWrapper.strPhoneNumber= contObj.Phone;
                  objContactWrapper.strCreatedDate = contObj.CreatedDate.format();
                  objContactWrapper.strLastMidifiedDate = contObj.LastModifiedDate.format();
                  listContactWrapper.add(objContactWrapper);
                  contactIdSetAlreadyAdded.add((string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id));
             } 
             for(Contact contObj : lstContact) {
               if(contactIdSetAlreadyAdded != null && !contactIdSetAlreadyAdded.contains((string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id))) {
                 ContactWrapper objContactWrapper = new ContactWrapper();
                 if(primaryContactId == null || (!contactIdSet.contains(primaryContactId))) {
                   objContactWrapper.setAsPrimary = true;
                   primaryContactId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
                 } 
                 objContactWrapper.strId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
                    objContactWrapper.strFName = contObj.FirstName;
                    objContactWrapper.strFLame = contObj.LastName;
                    objContactWrapper.strEmail = contObj.Email;
                     objContactWrapper.strPhoneNumber= contObj.Phone;
                    objContactWrapper.strCreatedDate = contObj.CreatedDate.format();
                    objContactWrapper.strLastMidifiedDate = contObj.LastModifiedDate.format();
                    listContactWrapper.add(objContactWrapper);
               }
             }                          
        } else {
          boolean isPrimaryCheckSet = false;
          // To check opportunity is not creating through contact
          if(mapContactIdToContact != null && String.isNotBlank(contactIdTemp) && mapContactIdToContact.get(contactIdTemp) != null) {
               Contact contObj = mapContactIdToContact.get(contactIdTemp);
               ContactWrapper objContactWrapper = new ContactWrapper();
             objContactWrapper.setAsPrimary = true;
             primaryContactId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
               objContactWrapper.strId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
                  objContactWrapper.strFName = contObj.FirstName;
                  objContactWrapper.strFLame = contObj.LastName;
                  objContactWrapper.strEmail = contObj.Email;
                   objContactWrapper.strPhoneNumber= contObj.Phone;
                  objContactWrapper.strCreatedDate = contObj.CreatedDate.format();
                  objContactWrapper.strLastMidifiedDate = contObj.LastModifiedDate.format();
                  listContactWrapper.add(objContactWrapper); 
                  contactIdSetAlreadyAdded.add((string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id));
             } 
          for(Contact contObj : lstContact) {
            if(contactIdSetAlreadyAdded != null && !contactIdSetAlreadyAdded.contains((string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id))) {
                 ContactWrapper objContactWrapper = new ContactWrapper();
                 System.debug('>>>>>12344>>>' + contObj.Name);
                 System.debug('>>>>>12345>>>' + isPrimaryCheckSet);
                 if(isPrimaryCheckSet == false) {
                   objContactWrapper.setAsPrimary = true;
                   primaryContactId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
                   isPrimaryCheckSet = true;
                   System.debug('>>>>>12346>>>' + isPrimaryCheckSet);
                 }
                 objContactWrapper.strId = (string.valueOf(contObj.Id).length()>15?string.valueOf(contObj.Id).substring(0,15):contObj.Id);
                    objContactWrapper.strFName = contObj.FirstName;
                    objContactWrapper.strFLame = contObj.LastName;
                    objContactWrapper.strEmail = contObj.Email;
                    objContactWrapper.strPhoneNumber= contObj.Phone;
                    objContactWrapper.strCreatedDate = contObj.CreatedDate.format();
                    objContactWrapper.strLastMidifiedDate = contObj.LastModifiedDate.format();
                    listContactWrapper.add(objContactWrapper);
            }
             }
        }
        if(!string.isBlank(contactIdTemp)) {
          primaryContactId = contactIdTemp;
        }            
       } catch(Exception ex) {}
     }  
	 
	 public PageReference cancelOppty() {
    	if(String.isBlank(oppObj.AccountId)) {
                system.Debug('>>>!234>>>' + oppObj.AccountId);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an account.');
                ApexPages.addMessage(myMsg); 
                return null;
        }
    	String retURL = ApexPages.currentPage().getParameters().get('retURL');
    	String pageUrl = '/apex/OpportunityCancellation?RecordType=01280000000UIxr&retURL='+retURL;
    	if(String.isNotBlank(oppObj.AccountId)){
    		pageUrl = pageUrl + '&opp4_lkid='+oppObj.AccountId;
    	}
    	PageReference detailPage = new PageReference(pageUrl);
        detailPage.setRedirect(true);
        return detailPage;
    }
       
     public PageReference cancel() {
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        if(String.isNotBlank(retURL)) {
            string returnString = ApexPages.currentPage().getParameters().get('retURL');
            return new PageReference(returnString); 
        } else {
            return new PageReference('/006/o'); 
        }
    }
    
    public string selectedContact {get;set;}  
	
     public PageReference createOpportunity() {
       try {
         system.Debug('>>>!233>>>' + oppObj.AccountId);
         if(oppObj.AccountId == null) {
           system.Debug('>>>!234>>>' + oppObj.AccountId);
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an account.');
              ApexPages.addMessage(myMsg); 
              return null;
         }
         if(string.isBlank(selectedContact)) {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select primary contact.');
              ApexPages.addMessage(myMsg); 
              return null;
         }
         string keyPrefix = '/' + Schema.getGlobalDescribe().get('Opportunity').getDescribe().getKeyPrefix() + '/e'; 
          PageReference rtrnOppPage = new PageReference(keyPrefix);
          rtrnOppPage.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType'));
          rtrnOppPage.getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
          rtrnOppPage.getParameters().put('nooverride','1');
          Contact selectedContactObj = [select Name,Id,AccountId,Account.Name from Contact where Id =:selectedContact limit 1];
          if(selectedContactObj != null) {
            rtrnOppPage.getParameters().put('opp4',selectedContactObj.Account.Name);
            rtrnOppPage.getParameters().put('opp4_lkid',selectedContactObj.AccountId);
            rtrnOppPage.getParameters().put('CF00N80000005Hviw',selectedContactObj.Name);
            rtrnOppPage.getParameters().put('CF00N80000005Hviw_lkid',selectedContactObj.Id);
          }
          /*if(ApexPages.currentPage().getParameters().get('campid') != null && ApexPages.currentPage().getParameters().get('campid') != '') {
            rtrnOppPage.getParameters().put('campid',ApexPages.currentPage().getParameters().get('campid'));
          }*/
          if(ApexPages.currentPage().getParameters().get('campid') != null && ApexPages.currentPage().getParameters().get('campid') != '') {
            string campId = ApexPages.currentPage().getParameters().get('campid');
            List<Campaign> campObj = [select name from Campaign where Id = :campId Limit 1];
            if(campObj != null && campObj.size()>0 && campObj[0].Name != null) {
              rtrnOppPage.getParameters().put('opp17',campObj[0].Name);
                 rtrnOppPage.getParameters().put('opp17_lkid',campId);
            }
        }
        if(ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid') != null && 
              ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid') != '') {
                string orderId = ApexPages.currentPage().getParameters().get('CF00N80000004jUBx_lkid');
              List<Order__c> orderObj = [select name from order__c where Id = :orderId limit 1];
              if(orderObj != null && orderObj.size()>0 && orderObj[0].Name != null) {
                string orderName = orderObj[0].Name;
                rtrnOppPage.getParameters().put('CF00N80000004jUBx',orderName);
                rtrnOppPage.getParameters().put('CF00N80000004jUBx_lkid',orderId);
              }
        }
          return rtrnOppPage;
       } catch(Exception ex) {}
       return null;
     }
       
     /*public PageReference redirectTOOppCall() {
       if(ContactRole == '' || ContactRole == null){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select account');
            ApexPages.addMessage(myMsg); 
            return null;
         }
            //url.getSalesforceBaseUrl()
         //return new PageReference(''+url.getSalesforceBaseUrl());//+'/006/e');
         // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error Message.');
          //ApexPages.addMessage(myMsg); 
                            
            string keyPrefix = '/' + Schema.getGlobalDescribe().get('Opportunity').getDescribe().getKeyPrefix() + '/e'; 
            PageReference rtrnOppPage = new PageReference(keyPrefix);
            rtrnOppPage.getParameters().put('RecordType',ApexPages.currentPage().getParameters().get('RecordType'));
            rtrnOppPage.getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
            rtrnOppPage.getParameters().put('nooverride','1');
          system.debug('ContactRole--------->'+ContactRole);
             If(ContactRole!=null){
            List<Contact> lstCont1 = [select Name, id,FirstName,Lastname,Phone,mkto2__Lead_Score__c,CreatedDate,LastModifiedDate,email from contact
                                           WHERE Id =:ContactRole];
              rtrnOppPage.getParameters().put('CF00N80000005Hviw',lstCont1[0].Name);
             
             // if(objacc.Accountopp__c == '' || objacc.Accountopp__c == null)
          //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter Account name'));      //  system.debug('ContactRole--------->'+ContactRole);                               
         }else{
            
         /* List<Contact> lstCont = [select Name, id,FirstName,Lastname,Phone,mkto2__Lead_Score__c,CreatedDate,LastModifiedDate,email from contact
                                           WHERE Id =:ApexPages.currentPage().getParameters().get('value')];
              rtrnOppPage.getParameters().put('CF00N80000005Hviw',lstCont[0].Name);
              */
               /*system.debug('ApexPages.currentPage().getParameters().get()--------->'+ApexPages.currentPage().getParameters().get('value'));
         }
            rtrnOppPage.getParameters().put('CF00N80000005Hviw_lkid',ContactRole);
            rtrnOppPage.getParameters().put('accid',ApexPages.currentPage().getParameters().get('accid'));
            
            return rtrnOppPage;      
       } 
        
     public void selectcon() {
    String selcontactid = System.currentPagereference().getParameters().get('conid');
        Contact con = [Select Id,FirstName,LastName,Email,Phone from Contact where Id=:selcontactid];
        selectcon =  new List<contact>();
        selectcon.add(con);
     } */     
  
  public class ContactWrapper {    
      public SelectOption option {get;set;}
        public Boolean setAsPrimary {get;set;}
        public String strId {get;set;}
        public String strFName {get;set;}
        public String strFLame {get;set;}
        public String strEmail {get;set;}
        public String strPhoneNumber {get;set;}
        public String strCreatedDate {get;set;}
        public String strLastMidifiedDate {get;set;}
        public String strLeadScore {get;set;}
        public ContactWrapper() {
          setAsPrimary = false;
        }    
    }
    
    /*Map<id,List<contact>> maplstcont=new Map<id,List<contact>>();
    public List<SelectOption>  getValues(){
            options.add(new selectOption('--None--','--None--'));
            for(Account acc:[select id,name,(select id,Lastname,email from contacts)from account]){
                options.add(new selectOption(acc.id,acc.name));
                maplstcont.put(acc.id,acc.contacts);               
            }
            return options;
    }*/ 
}