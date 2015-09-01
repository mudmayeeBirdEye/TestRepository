trigger TotalContactsOnAccount on Contact (before delete, before insert, before update) {
    
    if(Trigger.isInsert) {
        Map<Id, Integer> con_count_mp = new Map<Id, Integer>();
        for(Contact c : Trigger.new) {
            if (c.AccountId != null) {
                if (con_count_mp.containsKey(c.AccountId)) {
                    con_count_mp.put(c.AccountId, con_count_mp.get(c.AccountId) + 1);
                } else {
                    con_count_mp.put(c.AccountId, 1);
                }   
            }
        } 
        
        Map<Id, Account> accounts = new Map<Id, Account>();
        try {
            accounts = new Map<Id, Account>([Select Id,Total_Contacts__c from Account where id IN : con_count_mp.keySet()]);
        } catch(QueryException qe) {}
        
        for(Account acc : accounts.values()) {
            if (acc != null) {
                acc.Total_Contacts__c += con_count_mp.get(acc.id);
            }
        }
        
        update accounts.values();   
    }
    
    if(Trigger.isUpdate) {
        Integer i = 0;
        Map<Id, Integer> con_count_mp = new Map<Id, Integer>();
        for(Contact c : Trigger.new) {
            if (c.AccountId != Trigger.old[i].AccountId) {
                // New
                if (c.AccountId != null && con_count_mp.containsKey(c.AccountId)) {
                    con_count_mp.put(c.AccountId, con_count_mp.get(c.AccountId) + 1);
                } else if (c.AccountId != null) {
                    con_count_mp.put(c.AccountId, 1);
                }   
                // Old
                if (Trigger.old[i].AccountId != null && con_count_mp.containsKey(Trigger.old[i].AccountId)) {
                    con_count_mp.put(Trigger.old[i].AccountId, con_count_mp.get(Trigger.old[i].AccountId) - 1);
                } else if (Trigger.old[i].AccountId != null) {
                    con_count_mp.put(Trigger.old[i].AccountId, -1);
                }
            }
        } 
        
        Map<Id, Account> accounts = new Map<Id, Account>();
        try {
            accounts = new Map<Id, Account>([Select Id,Total_Contacts__c from Account where id IN : con_count_mp.keySet()]);
        } catch(QueryException qe) {}
        
        for(Account acc : accounts.values()) {
            if (acc != null) {
                acc.Total_Contacts__c += con_count_mp.get(acc.id);
            }
        }
        
        update accounts.values();       
    
    }
    
    if(Trigger.isDelete) {
        Map<Id, Integer> con_count_mp = new Map<Id, Integer>();
        for(Contact c : Trigger.old) {
            if (c.AccountId != null) {
                if (con_count_mp.containsKey(c.AccountId)) {
                    con_count_mp.put(c.AccountId, con_count_mp.get(c.AccountId) - 1);
                } else {
                    con_count_mp.put(c.AccountId, -1);
                }   
            }
        } 
        
        Map<Id, Account> accounts = new Map<Id, Account>();
        try {
            accounts = new Map<Id, Account>([Select Id,Total_Contacts__c from Account where id IN : con_count_mp.keySet()]);
        } catch(QueryException qe) {}
        
        for(Account acc : accounts.values()) {
            if (acc != null) {
                acc.Total_Contacts__c += con_count_mp.get(acc.id);
            }
        }
        
        update accounts.values();
        
    }
}