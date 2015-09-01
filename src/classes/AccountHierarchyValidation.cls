public with sharing class AccountHierarchyValidation {



	public static void validateAccountHierarchy(List < Account > lstAccount) {

		Set < ID > customerParent = new Set < ID > ();
		Map < Id, List < Integer >> mapDepth = new Map < Id, List < Integer >> ();
		Map < Id, Account > mapParentAccount = new Map < Id, Account > ();

		//Create Query String
		String strQueryCondition = '';
		for (Account objAccount: lstAccount) {
			if (objAccount.ParentId != null) {
				customerParent.add(objAccount.ParentId);
			}
			String strId = objAccount.id;
			if (strId.length() > 15) {
				strQueryCondition = strQueryCondition + ' OR Parent_Detail__c like \'%' + strId.subString(0, 15) + '%\'';
			} else {
				strQueryCondition = strQueryCondition + ' OR Parent_Detail__c like \'%' + strId + '%\'';
			}

		}
		// String strQuery='Select id,Parent_Detail__c,Account_Depth__c from Account where (Parent_Detail__c!=null AND ParentId!=NULL) AND (id IN ('+callSetIterator(customerParent)+')';
		String strQuery = 'Select id,Parent_Detail__c,Account_Depth__c from Account where (Parent_Detail__c!=null AND ParentId!=NULL) AND (id!=null ';
		strQuery = strQuery + strQueryCondition + ')';
		//----------------------As/Simplion/5/1/2015----------------------------------------------------------------
		//--------------------- We have removed below query as we can prepare this data from already done query in Account.trigger
		if (customerParent.size() > 0) {
			for(Id parentAccId : customerParent){
				if(AccountTriggerHelper.accountMapForOfficeTrail.containsKey(parentAccId)){
					mapParentAccount.put(parentAccId,AccountTriggerHelper.accountMapForOfficeTrail.get(parentAccId));
				}
				
			}
		//	mapParentAccount = new Map < ID, Account > ([Select id, Parent_Detail__c, Account_Depth__c from Account where ID IN: customerParent]);
		}
		//lstAccount.get(0).addError(strQuery); 
		//return;
		///--------------------As/Simplion/5/1/2015-------------------------------------------
		//--------------------Syntex modification for optimization---------------------------------
		for (Account objAccount: Database.query(strQuery)) {
			// mapParentAccount.put(objAccount.id,objAccount);
			if (!String.isBlank(objAccount.Parent_Detail__c)) {
				String strParentDetail = objAccount.Parent_Detail__c;
				List < String > commaSeperatedList = strParentDetail.split(',');
				for (String objString: commaSeperatedList) {
					if (!String.isBlank(objString)) {
						List < String > hyphenSeperatedList = objString.split('-');
						if (hyphenSeperatedList.size() == 2) {
							if (mapDepth.get(hyphenSeperatedList.get(1)) != null) {
								mapDepth.get(hyphenSeperatedList.get(1)).add(Integer.valueOf(hyphenSeperatedList.get(0)));
							} else {
								mapDepth.put(hyphenSeperatedList.get(1), new List < Integer > {
								Integer.valueOf(hyphenSeperatedList.get(0))
							});
							}
						}
					}
				}
			}
		}

		for (Account objAccount: lstAccount) {
			if (objAccount.ParentId != null) {
				Account objParentAccount = mapParentAccount.get(objAccount.ParentId);
				//lstAccount.get(0).addError(''+objAccount.ParentId); 
				if (objParentAccount != null && ((objParentAccount.Account_Depth__c + 1) > 4)) {
					objAccount.addError('This account cannot be added to hierarchy(' + (objParentAccount.Account_Depth__c + 1) + '), as it exceeds to hierarchy limit(4).'); // cant create parent
				} else if (objParentAccount != null) {

					if (mapDepth.get(objAccount.id) != null) {
						List < Integer > lstDepth = mapDepth.get(objAccount.id);
						lstDepth.sort();
						Integer maxChild = lstDepth.size() > 0 ? lstDepth.get(lstDepth.size() - 1) : 0;

						if ((maxChild + objParentAccount.Account_Depth__c + 1) > 4) {
							objAccount.addError('This account cannot be added to hierarchy(' + (maxChild + objParentAccount.Account_Depth__c + 1) + '), as it exceeds to hierarchy limit(4)'); // cant create child
						}
					}
				}
			}
		}

	}
	/*
public Static String callSetIterator(Set<Id> idSet) { 
    String strReturn = null;
     for(Id idObj : idSet) {
        if(strReturn == null) {
           strReturn = '' + '\''+ '' + idObj + '' +'\'';
         } else {
            strReturn = strReturn + ',' + '' + '\''+ '' + idObj+ '' +'\'';
          }
       }
    return strReturn;
}
*/

	/*static testMethod void myUnitTest() {
    try {
          Account objAccount1= (Account)SmartFactory.createSObject('Account', true);
                     objAccount1.RC_User_ID__c='RC'+Math.random();
                     upsert objAccount1;
            Account objAccount2= (Account)SmartFactory.createSObject('Account', true);
                    objAccount2.ParentId=objAccount1.id;
                    objAccount2.RC_User_ID__c='RC'+Math.random();
                    upsert objAccount2;
            Account objAccount3= (Account)SmartFactory.createSObject('Account', true);
                    objAccount3.ParentId=objAccount2.id;
                    objAccount3.RC_User_ID__c='RC'+Math.random();
                    upsert objAccount3;
            Account objAccount4= (Account)SmartFactory.createSObject('Account', true);
                    objAccount4.ParentId=objAccount3.id;
                    objAccount4.RC_User_ID__c='RC'+Math.random();
                    upsert objAccount4;
            Test.startTest();        
            Account objAccount5= (Account)SmartFactory.createSObject('Account', true);
                     objAccount5.ParentId=objAccount4.id;
                     objAccount5.RC_User_ID__c='RC'+Math.random();
                    try{
                         upsert objAccount5;
                       } catch(Exception e){}
           
             Account objAccount9= (Account)SmartFactory.createSObject('Account', true);
                     objAccount9.RC_User_ID__c='RC'+Math.random();
                     upsert objAccount9;                          
                    
                      Account objAccount10= (Account)SmartFactory.createSObject('Account', true);
                     objAccount10.RC_User_ID__c='RC'+Math.random();
                     upsert objAccount10;   
                          
                  try{
                    objAccount1.parentId=objAccount9.id;
                    upsert objAccount1;
                  }catch(Exception e){
                      
                  }
          
          List<Account> lst = new List<Account>();
          objAccount1.parentId=null;
          lst.add(objAccount1);
          objAccount2.parentId=null;
          lst.add(objAccount2);
          objAccount3.parentId=null;
          lst.add(objAccount3);
          objAccount4.parentId=null;
          lst.add(objAccount4);
    
          upsert lst;
          
          lst=new List<Account>();
          objAccount1.parentId=objAccount2.id;
          lst.add(objAccount1);
          objAccount2.parentId=objAccount3.id;
          lst.add(objAccount2);
          objAccount3.parentId=objAccount4.id;
          lst.add(objAccount3);
          objAccount4.parentId=objAccount10.id;
          lst.add(objAccount4);
          try{
            upsert lst;
          }catch(Exception e){}
             validateAccountHierarchy(lst);
          Test.stopTest();   
        } catch(Exception e){}      
   }*/
}