/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_AccountCleanUpProcess {

    static testMethod void myUnitTest() {
       /* Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id,Partner_ID__c FROM Account WHERE Id = '0018000000sGJmF' ]);
        cleanUpAccounts(accountMap); // 
        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id,AccountId,Email,marketingSuspend__c  FROM Contact WHERE Id = '0038000001Az7C9' ]);
        cleanUpContacts(contactMap);
        */
        Account accObj = new Account(Name='Simplion', Partner_ID__c='Test12322');
        insert accObj;
        Account accObj1 = new Account(Name='Simplion12', Partner_ID__c='Test12323');
        insert accObj1;
        Contact contactObj = new Contact(firstName='Virendra', lastname='Singh', marketingSuspend__c=false, accountid=accObj.id, email='virendra.singh@simplion.com', phone='9910106804');
        insert contactObj;
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id,Partner_ID__c FROM Account]);
         Contact contactObj1 = new Contact(firstName='Virendra11', lastname='Singh11', marketingSuspend__c=false, accountid=accObj1.id, email='virendra11.singh@simplion.com', phone='9910106804');
        insert contactObj1;
        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id,AccountId,Email,marketingSuspend__c  FROM Contact]);
        
        AccountCleanUpProcess.cleanUpAccounts(accountMap,contactMap); // 
        
        system.debug('----------------------contactMap'+contactMap);
        AccountCleanUpProcess.cleanUpContacts(contactMap);
        Set<String> emails = new Set<String>();
        emails.add('virendra.singh@simplion.com');
        emails.add('virendra11.singh@simplion.com');
        AccountCleanUpProcess.cleanUpProcessPerAccount(emails);
        AccountCleanUpProcess.cleanUpProcessPerContact(emails); 
    }
}