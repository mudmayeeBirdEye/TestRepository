trigger TotalCasesOnAccount on Case (before delete, before insert, before update) {
    /*
    if(Trigger.isInsert) {
        Map<Id, Integer> acct_count_mp = new Map<Id, Integer>();
        for(Case cs : Trigger.new) {
            if (cs.AccountId != null) {
                if (acct_count_mp.containsKey(cs.AccountId)) {
                    acct_count_mp.put(cs.AccountId, acct_count_mp.get(cs.AccountId) + 1);
                } else {
                    acct_count_mp.put(cs.AccountId, 1);
                }   
            }
        }       
        
        Map<Id, Account> accounts = new Map<Id, Account>();
        try { 
            accounts = new Map<Id, Account>([Select Id,Total_Cases__c from Account where id IN : acct_count_mp.keySet()]);
        } catch(QueryException qe) {}
        
        for(Account acc : accounts.values()) {
            if (acc != null) {
                acc.Total_Cases__c += acct_count_mp.get(acc.id);
            }
        }
        System.debug('+++++++++++++++++ ' + accounts);
        update accounts.values();
        
    }
    
    if(Trigger.isUpdate) {
        Integer i = 0;
        Map<Id, Integer> acct_count_mp = new Map<Id, Integer>();
        for(Case cs : Trigger.new) {
            if (cs.AccountId != Trigger.old[i].AccountId) {
                // For new
                if (cs.AccountId != null && acct_count_mp.containsKey(cs.AccountId)) {
                    acct_count_mp.put(cs.AccountId, acct_count_mp.get(cs.AccountId) + 1);
                } else if (cs.AccountId != null){
                    acct_count_mp.put(cs.AccountId, 1);
                }   
                // Old new
                if (Trigger.old[i].AccountId != null && acct_count_mp.containsKey(Trigger.old[i].AccountId)) {
                    acct_count_mp.put(Trigger.old[i].AccountId, acct_count_mp.get(Trigger.old[i].AccountId) - 1);
                } else if (Trigger.old[i].AccountId != null){
                    acct_count_mp.put(Trigger.old[i].AccountId, -1);
                }               
            }
            i++;
        }       
        
        Map<Id, Account> accounts = new Map<Id, Account>();
        try {
            accounts = new Map<Id, Account>([Select Id,Total_Cases__c from Account where id IN : acct_count_mp.keySet()]);
        } catch(QueryException qe) {}
        
        for(Account acc : accounts.values()) {
            if (acc != null) {
                acc.Total_Cases__c += acct_count_mp.get(acc.id);
            }
        }
        
        update accounts.values();       
        
        
        
        
        
        
        /*Integer i = 0;
        Set<Id> newAccountIds = new Set<Id>();
        Set<Id> oldAccountIds = new Set<Id>();
        for(Case cs : Trigger.new) {
            if(cs.AccountId != Trigger.old[i].AccountId) {
                newAccountIds.add(cs.AccountId);
                oldAccountIds.add(Trigger.old[i].AccountId);
            }
            i++;
        }
        Map<Id, Account> newAccounts = null;
        Map<Id, Account> oldAccounts = null;
        try {
            newAccounts = new Map<Id, Account>([Select Id,Total_Cases__c from Account where id IN : newAccountIds]);
            oldAccounts = new Map<Id, Account>([Select Id,Total_Cases__c from Account where id IN : oldAccountIds]);
        } catch(QueryException qe) {}
        
        
        i = 0;
        for(Case cs : Trigger.new) {
            Account newAcc = newAccounts.get(cs.AccountId);
            Account oldAcc = oldAccounts.get(Trigger.old[i].AccountId);
            if(oldAcc != null) {
                oldAcc.Total_Cases__c -= 1;
            }
            
            if(newAcc != null) {
                newAcc.Total_Cases__c += 1;
            }
            
            i++;
        }
        
        update newAccounts.values();
        update oldAccounts.values();*/
        
  //  }
   /* 
    if(Trigger.isDelete) {

        Map<Id, Integer> acct_count_mp = new Map<Id, Integer>();
        for(Case cs : Trigger.old) {
            if (cs.AccountId != null) {
                if (acct_count_mp.containsKey(cs.AccountId)) {
                    acct_count_mp.put(cs.AccountId, acct_count_mp.get(cs.AccountId) - 1);
                } else {
                    acct_count_mp.put(cs.AccountId, -1);
                }               
            }
        }       
        
        Map<Id, Account> accounts = new Map<Id, Account>();
        try {
            accounts = new Map<Id, Account>([Select Id,Total_Cases__c from Account where id IN : acct_count_mp.keySet()]);
        } catch(QueryException qe) {}
        
        for(Account acc : accounts.values()) {
            if (acc != null) {
                acc.Total_Cases__c += acct_count_mp.get(acc.id);
            }
        }
        
        update accounts.values(); 
        
        /*
        Set<Id> accountIds = new Set<Id>();
        for(Case cs : Trigger.old) {
            if(cs.AccountId != null) {
                accountIds.add(cs.AccountId);
            }
        }
        Map<Id, Account> accounts = null;
        try {
            accounts = new Map<Id, Account>([Select Id,Total_Cases__c from Account where id IN : accountIds]);
        } catch(QueryException qe) {}

        for(Case cs : Trigger.old) {
            Account acc = accounts.get(cs.AccountId);
            if(acc != null) {
                acc.Total_Cases__c -= 1;
            }
        }
        
        update accounts.values();*/
        
  //  }

}