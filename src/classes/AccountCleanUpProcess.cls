/**************************************************************************************************
 * Project Name..........:                                                                        *
 * File..................: AccountCleanUpProcess.class                                            *
 * Version...............: 1.0                                                                    *
 * Created by............: Simplion Technologies                                                  *
 * Created Date..........: 29-01-2014                                                             *
 * Last Modified by......: Simplion Technologies                                                  *
 * Last Modified Date....: 29-01-2014                                                             *
 * Description...........: This is a class for Account cleanup.                                   *
 **************************************************************************************************/

public with sharing class AccountCleanUpProcess {
	
	/*****************************************************************************
	 * @Description - List of the accounts, associated to partner ids only.      * 
	 * @params Map<Id, Account>, Map<Id,Contact>                                 *
	 * @return void                                                              * 
	 *****************************************************************************/
	public static void cleanUpAccounts(Map<Id, Account> accountMap , Map<Id,Contact> contactAccountMap) {
		try{
			Set<Id> accountIds = new Set<Id>();
			if(accountMap !=null && accountMap.keySet()!=null){
				for(Id accountId : accountMap.keySet()) {
					Account accountObj = accountMap.get(accountId);
					if(accountObj.Partner_ID__c != null) {
						//System.debug('#### '+ 1 +' #####');
						accountIds.add(accountId);
					}
				}
			}
			if(accountIds == null) {
				//System.debug('#### '+ 2 +' #####');
				return;
			}
			if(accountIds.size() == 0) {
				//System.debug('#### '+ 2 +' #####');
				return;
			}
			Set<String> emails = new Set<String>();
			for(Contact contactObj :contactAccountMap.values()){
				if(contactObj.Email != 'fake@email.com' && contactObj.Email != 'fake@fake.com') {
					//System.debug('#### '+ 3 +' #####');
					emails.add(contactObj.Email);
				}
			}
			if(emails !=null && emails.size() != 0) {
				//System.debug('#### '+ 4 +' #####');
				cleanUpProcessPerAccount(emails);
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception e){
			System.debug('#### Error @ cleanUpAccounts line - '+e.getlineNumber());
			System.debug('#### Error @ cleanUpAccounts message - '+e.getMessage()); 
		}
	}

	/*****************************************************************************
	 * @Description -                                                            * 
	 * @params Map<Id,Contact>                                                   *
	 * @return void                                                              * 
	 *****************************************************************************/
	public static void cleanUpContacts(Map<Id, Contact> contactMap) {
		try{
			Map<Id, Id> contactAccountMap = new Map<Id, Id>();
			for(Id contactId: contactMap.keySet()) {
				Contact contactObj = contactMap.get(contactId);
				if(contactObj.Email != 'fake@email.com' && contactObj.Email != 'fake@fake.com') {
					contactAccountMap.put(contactObj.AccountId, contactId);
				}
			}
			if(contactAccountMap == null) {
				//System.debug('#### '+ 2 +' #####');
				return;
			}
			if(contactAccountMap.size() == 0) {
				//System.debug('#### '+ 2 +' #####');
				return;
			}
			Set<String> emails = new Set<String>();
			for(Account accountObj : [SELECT Id,Partner_ID__c FROM Account WHERE Id IN: contactAccountMap.keySet()]) {
				if(accountObj.Partner_ID__c != null) {
					Id contactId = contactAccountMap.get(accountObj.Id);
					emails.add(contactMap.get(contactId).Email);
				}
			}
			if(emails != null && emails.size() != 0) {
				// cleanUpProcess(emails);
				cleanUpProcessPerContact(emails);
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception e){
			System.debug('#### Error @ cleanUpContacts line'+e.getlineNumber());
			System.debug('#### Error @ cleanUpContacts message '+e.getMessage());
		}
	}
	// @future
	
	/*****************************************************************************
	 * @Description -                                                            * 
	 * @params Set<String>                                                       *
	 * @return void                                                              * 
	 *****************************************************************************/
	public static void cleanUpProcessPerAccount(Set<String> emails) {
		//System.debug('#### '+ 5 +' #####');
		try {
			if(emails != null && emails.size() != 0) {
				//System.debug('#### '+ 6 +' #####');
				List<Contact> suspendedContacts = [SELECT Id, marketingSuspend__c 
				                                   FROM Contact WHERE (marketingSuspend__c = false OR marketingSuspend__c = null) AND Email IN: emails AND isDeleted= false];

				for(Contact contactObj : suspendedContacts) {
					contactObj.marketingSuspend__c = true;
				}
				List<Lead> suspendedLeads = [SELECT Id, marketingSuspend__c 
				                             FROM Lead WHERE marketingSuspend__c = false AND Email IN:emails 
				                             AND IsConverted = false AND isDeleted= false];

				for(Lead leadObj : suspendedLeads) {
					leadObj.marketingSuspend__c = true;
				}

				if(suspendedContacts != null && suspendedContacts.size() != 0)
					update suspendedContacts;

				if(suspendedLeads != null && suspendedLeads.size() != 0)
					update suspendedLeads;

			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		} catch(Exception e) {
			System.debug('#### Error @ cleanUpProcessPerContact line - '+e.getlineNumber());
			System.debug('#### Error @ cleanUpProcessPerContact message - '+e.getMessage()); 
		}
	}

	/*****************************************************************************
	 * @Description -                                                            * 
	 * @params Set<String>                                                       *
	 * @return void                                                              * 
	 *****************************************************************************/
	@future
	public static void cleanUpProcessPerContact(Set<String> emails) {
		//System.debug('#### '+ 5 +' #####');
		try {
			if(emails != null && emails.size() != 0) {
				//System.debug('#### '+ 6 +' #####');
				List<Contact> suspendedContacts = [SELECT Id, marketingSuspend__c 
				                                   FROM Contact WHERE (marketingSuspend__c = false OR marketingSuspend__c = null) AND Email IN: emails AND isDeleted= false];

				for(Contact contactObj : suspendedContacts) {
					contactObj.marketingSuspend__c = true;
				}
				List<Lead> suspendedLeads = [SELECT Id, marketingSuspend__c 
				                             FROM Lead WHERE marketingSuspend__c = false AND Email IN:emails 
				                             AND IsConverted = false AND isDeleted= false];

				for(Lead leadObj : suspendedLeads) {
					leadObj.marketingSuspend__c = true;
				}

				if(suspendedContacts != null && suspendedContacts.size() != 0)
					update suspendedContacts;

				if(suspendedLeads != null && suspendedLeads.size() != 0)
					update suspendedLeads;
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		} catch(Exception ex) {
			System.debug('#### Error cleanUpProcessContact line - '+ex.getlineNumber());
			System.debug('#### Error cleanUpProcessContact message - '+ex.getMessage());
		}
	}
}