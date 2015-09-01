public class ApprovalHelper {
    @future
    public static void claimOwnership(Set<Id> apprvIdSet){
        Set<String> setAcc = new Set<String>();
        Map<id,Account> AccountMap;
        List<Account> AccToUpdate = new List<Account>();
        Map<Id,Approval__c> AccountToApprovalMap = new Map<Id,Approval__c>();
        Map<Id,List<Account>> mpAcc = new Map<Id,List<Account>>();
        List<Account> lstAcc1;
        List<Account> lstAcc2;
        Map<id, RecordType> recordTypeMap = new Map<id, RecordType>([SELECT  Name, IsActive, Id FROM RecordType 
        															 WHERE SobjectType ='Approval__c' AND isActive = true]);
        List<Approval__c> approvalList = new List<Approval__c>();
        approvalList = [SELECT Id, Claiming_Requestor__c, Status__c, Account__r.id,Account__c, Account__r.Ultimate_Parent_Account_ID__c,Transfer_Type__c, 
        					   RecordTypeId 
        				FROM Approval__c WHERE Id IN:apprvIdSet];
        //system.debug('-- approvalList --'+ approvalList);
       
        for(Approval__c appr : approvalList){
            if( appr.Status__c =='Approved' &&
            recordTypeMap.get(appr.RecordTypeId).Name =='Farming Claim Owner' &&
            appr.Account__c != null){
            	AccountToApprovalMap.put(appr.Account__c,appr);
            	//system.debug('AccountToApprovalMap ='+AccountToApprovalMap+'==='+appr.Account__c);
                setAcc.add(appr.Account__r.Ultimate_Parent_Account_ID__c);
            }
        }
        //system.debug('@@@----setAcc @@@ '+setAcc);
        Set<String> setAccountId = new Set<String>();
       /* for(Account objAcc:[SELECT Current_Owner__c,Ultimate_Parent_Account_ID__c,MRR_Transfer_Effective_date__c 
                                                FROM   Account
        									    WHERE Id IN:setAcc AND RecordTypeId =: '01280000000UERq'  ]){
     			setAccountId.add(objAcc.Ultimate_Parent_Account_ID__c);
        	  	
        }
        									    
        system.debug('@@@----setAccountId @@@ '+setAccountId);	*/ 								    
        									    
        Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
		Map<String,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosByName();
		Schema.RecordTypeInfo rtByName =  rtMapByName.get('Customer Account');
        
        List<Account> lstOfHierarchyAccounts = [SELECT Current_Owner__c,Ultimate_Parent_Account_ID__c,MRR_Transfer_Effective_date__c 
                                                FROM Account
        									    WHERE Ultimate_Parent_Account_ID__c IN:setAcc AND RecordTypeId =: rtByName.getRecordTypeId() ];
       //system.debug('@@@ ---- lstOfHierarchyAccounts --- @@@ '+lstOfHierarchyAccounts);
       
       List<Account> lstOfHierarchyAccounts1 = lstOfHierarchyAccounts;
        
        /*for(List<Account> lstOfHierarchyAccounts1 : [SELECT Current_Owner__c,Ultimate_Parent_Account_ID__c,MRR_Transfer_Effective_date__c 
                                                       FROM Account
        											   WHERE Ultimate_Parent_Account_ID__c IN:setAcc AND RecordTypeId =: '01280000000UERq' limit 5000 ]){
            for(Account a : lstOfHierarchyAccounts1){
                lstOfHierarchyAccounts.add(a);
            }
        }*/
        
        if(AccountToApprovalMap.keyset().size() > 0)
        AccountMap = new Map<id,Account>([SELECT id,MRR_Transfer_Effective_date__c,Current_Owner__c,Ultimate_Parent_Account_ID__c
        								  FROM Account
    									  WHERE Id IN: AccountToApprovalMap.keyset()]);
        
        //system.debug('lstOfHierarchyAccounts  '+lstOfHierarchyAccounts);
        
        for(String strId :setAcc){
            lstAcc1 = new List<Account>();
            lstAcc2 = new List<Account>();
            for(Account obj:lstOfHierarchyAccounts1){
            	//system.debug('strId='+strId+' strId='+obj.Ultimate_Parent_Account_ID__c);
                if(strId == obj.Ultimate_Parent_Account_ID__c )
                lstAcc1.add(obj);
                else
                    lstAcc2.add(obj);
            }
            mpAcc.put(strId,lstAcc1);
            //system.debug('mpAcc --'+mpAcc.size());
            //system.debug('mpAcc --'+mpAcc);
            //system.debug('size --'+lstAcc2.size());
            //system.debug('size --'+lstAcc1.size());
            lstOfHierarchyAccounts1 = lstAcc2;
        }
        
        for(ID accID:AccountToApprovalMap.keyset()) {
            Approval__c appr = new Approval__c();
            appr = AccountToApprovalMap.get(accID);
            Account acc = new Account();
            acc = AccountMap.get(accID);
            List<Account> lstAccount = mpAcc.get(acc.Ultimate_Parent_Account_ID__c);
            //system.debug('lstAccount size'+lstAccount.size());
            if(appr.Status__c=='Approved') {
                //   Set the MRR Transfer Effective Date to the date based on
                //   If Referral OR Existing Customer, then = Current Date
                //   If Internal Transfer, then = First day of the next month
                //   List<Account> hierarchyAccounts = new List<Account>();
                //   hierarchyAccounts = MapOfHierarchyAccount.get(accID);
                //system.debug('IN---appr.Status__c== Approved');
                //system.debug('IN---lstAccount '+lstAccount);
                for(Account objAcc:lstAccount){
                    //system.debug('IN---Account objAcc:lstAccount'+appr.Status__c); 
                    if(appr.Transfer_Type__c =='Referral'||appr.Transfer_Type__c =='Existing Customer')
                    	objAcc.MRR_Transfer_Effective_date__c = Date.today();
                    //system.debug('IN---Account objAcc:lstAccount');
                    if(appr.Transfer_Type__c =='Internal Transfer')
                    	objAcc.MRR_Transfer_Effective_date__c = Date.today().toStartOfMonth().addMonths(1);
                    
                    // Update the account's new Current Owner and audit the previous current owner. 
                    //acc.Current_Owner_Previous__c = appr.Current_Owner__c;
                    objAcc.Current_Owner__c = appr.Claiming_Requestor__c;
                    AccToUpdate.add(objAcc);
                    
                }
            }
            
        }
        //system.debug('IN--- '+AccToUpdate);
        if(AccToUpdate.size()>0) 
        	Update AccToUpdate;
        
        
    }
    
}