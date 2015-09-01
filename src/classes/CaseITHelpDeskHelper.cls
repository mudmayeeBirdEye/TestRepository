/*Class for Attaching the contact in cases for RC Internal Account.Used in Trigger CaseBefore*/
	/*If contact is present in RC internal Account than find and attach them and if not present than create according the web information provided in case 
	and than attach in case.*/
	/*Created Date 23 April 2013*/
public class CaseITHelpDeskHelper { 
    public List<Contact> createContactList ;
    Map<String, Contact> emailToContactMap ;
    Map<string,string> MapEmailAndPhone;
    Map<string,string> MapEmailAndName;
    Set<string> setSuppliedEmail;
    public CaseITHelpDeskHelper () {
       	setSuppliedEmail = new Set<string>();
        MapEmailAndName = new Map<string,string>();
        MapEmailAndPhone = new Map<string,string>();
        createContactList = new List<Contact>();
        emailToContactMap = new Map<String, Contact>();
    }
        
    public void checkContact(List<case> caseList, Map<ID,Schema.RecordTypeInfo> CaseMapByName) {
        try {
            for(Case objCase:caseList) {
                System.debug('Trigger In');
                if(CaseMapByName.get(objCase.RecordTypeId ).getName()=='IT Helpdesk') {
                    if(objCase.ContactId == null && !String.isBlank(objCase.SuppliedEmail)) {
                       setSuppliedEmail.add(objCase.SuppliedEmail);
                        /*if(!String.isBlank(objCase.SuppliedName))
                           setSuppliedName.add(objCase.SuppliedName);
                        if(!String.isBlank(objCase.SuppliedPhone))
                           setSuppliedPhone.add(objcase.SuppliedPhone);*/
                       MapemailandName.put(objCase.SuppliedEmail,objCase.SuppliedName);
                       MapEmailAndPhone.put(objCase.SuppliedEmail,objcase.SuppliedPhone);
                       System.debug('SuppliedEmail:'+setSuppliedEmail);
                    }
                }
            }
            Account accObj = [SELECT id,(SELECT Id, Name,Email,AccountId,Account.Name from Contacts 
                                WHERE email IN:setSuppliedEmail ORDER BY LastModifiedDate DESC) Name from Account where Name =:'RC Internal'];
			if(accObj == null)
				return;	                                
            System.debug('***accObj****'+accObj);   
            for(Contact contactObj:accObj.Contacts) {
                emailToContactMap.put(contactObj.Email, contactObj);  
            }
            for(Case caseObj : caseList) {
                String email = caseObj.SuppliedEmail;
                if(CaseMapByName.get(caseObj.RecordTypeId).getName() == 'IT Helpdesk') {
                    if(String.isBlank(email) || caseObj.ContactId != null) {
                         continue; 
                    }
                    if( accObj.contacts != null && accObj.contacts.size()== 0) {
                       Contact contactObj = new Contact();
                       contactObj.AccountId = accObj.id;
                       contactObj.lastName = mapEmailAndName.get(email);
                       contactObj.Phone = mapEmailAndPhone.get(email);
                       contactObj.Email = email;
                       createContactList.add(contactObj);
                       system.debug('****createContactList***********'+createContactList);
                    } else {
                        Contact contactObj = emailToContactMap.get(email);
                        caseObj.ContactId = contactObj.Id;
                    }
                 
                }
			} 
        	try {
	            if(createContactList != null && createContactList.size()>0) {
	                insert createContactList;
	            }
	            emailToContactMap.clear();
	        } catch(Exception e) {}
	        
        	
            for(Contact contactObj : createContactList) {
                emailToContactMap.put(contactObj.Email, contactObj);
            }
       
            for(Case caseObj : caseList) {
            	String email = caseObj.SuppliedEmail;
            	if(CaseMapByName.get(caseObj.RecordTypeId).getName() == 'IT Helpdesk') {
	                if(String.isBlank(email) || caseObj.ContactId != null) {
	                    continue; 
	                }
	                if( emailToContactMap.get(email) != null) {
	                    Contact contactObj = emailToContactMap.get(email);
	                    caseObj.ContactId = contactObj.Id;
	                    System.debug('Case with contact'+caseObj);
	               }
            	}
            }
            
        } catch(Exception e){System.debug('Exception'+e.getMessage());}
    }
    /****************************************************************************************
     * @Description - Method to map Account based on Case.Case_account_number__c field      * 
     * @params List<Case>                                                                   *                                                  
     * @return void                                                                         *
     ***************************************************************************************/ 
    public static void findMissingAccount(List<Case> newCaseIdsList) {
    	Set<String> accountNumberIdSet = new Set<String>();
        List<Account> matchingAccountByAccntNmbrList = new List<Account>();
        Map<String,Account> accountByAccountNumberMap = new Map<String,Account>();
        for(Case newCase : newCaseIdsList){
            if(String.isBlank(newCase.accountId) && newCase.Case_Account_Number__c != '' && newCase.Case_Account_Number__c != NULL ){
                accountNumberIdSet.add(newCase.Case_Account_Number__c);
                // logic to get Account if we have to remove Prefix '1' from case.case_account_number
				String tempString = '';
				if(String.valueOf(newCase.Case_Account_Number__c).startsWith('1')){
					tempString = String.valueOf(newCase.Case_Account_Number__c).substring(1,String.valueOf(newCase.Case_Account_Number__c).length());
					accountNumberIdSet.add(tempString);
	    		}
            }
        }
        matchingAccountByAccntNmbrList = [SELECT Id, RC_Account_Number__c,RecordType.Name 
        											FROM Account 
        											WHERE RC_Account_Number__c 
        											IN : accountNumberIdSet AND RecordType.Name = 'Customer Account' AND RC_Account_Number__c != NULL];
        for(Account acc : matchingAccountByAccntNmbrList){
            accountByAccountNumberMap.put(acc.RC_Account_Number__c,acc);
        }
        for(Case newCase : newCaseIdsList){
            if(String.isBlank(newCase.accountId) && newCase.Case_Account_Number__c != '' && newCase.Case_Account_Number__c != NULL){
                if(accountByAccountNumberMap != NULL && accountByAccountNumberMap.containsKey(newCase.Case_Account_Number__c) ){
                    if(accountByAccountNumberMap.get(newCase.Case_Account_Number__c) != NULL){
                    	newCase.AccountId = accountByAccountNumberMap.get(newCase.Case_Account_Number__c).Id;
                    }
                }else if(accountByAccountNumberMap != NULL && accountByAccountNumberMap.containsKey(String.valueOf(newCase.Case_Account_Number__c).substring(1,String.valueOf(newCase.Case_Account_Number__c).length()))){
                    String tempString = String.valueOf(newCase.Case_Account_Number__c).substring(1,String.valueOf(newCase.Case_Account_Number__c).length());
                    if(accountByAccountNumberMap.get(tempString) != NULL){
                    	newCase.AccountId = accountByAccountNumberMap.get(tempString).Id;
                    }
                }else if((accountByAccountNumberMap != NULL && (!accountByAccountNumberMap.containsKey(newCase.Case_Account_Number__c) || accountByAccountNumberMap.get(newCase.Case_Account_Number__c).Id == NULL)) 
                		|| accountByAccountNumberMap == NULL || accountByAccountNumberMap.keySet().size() == 0 ){
                    newCase.AccountId = (System.Label.Orphan_Container_Account_Id != NULL ? System.Label.Orphan_Container_Account_Id : NULL);
                }
            }
        }
    }
   /* @isTest 
    static void caseAttachContactTestMethod() {   
    	try{
        list<contact> ListContact=new list<contact>();
        Account accountObj = new Account();
        accountObj.Name = 'RC Internal';
        insert accountObj;
        Contact conObjTest = new Contact();
        conObjTest.LastName='Test Name';
        conObjTest.Email='rcindia@simplion.com';
        conObjTest.Phone='1234567890';
        conObjTest.AccountId=accountObj.id;
        ListContact.add(conObjTest);
        Contact conObjTest1=new Contact();
        conObjTest1.LastName='Test Name';
        conObjTest1.Email='Virendra.Singh@simplion.com';
        conObjTest1.Phone='1234567890';
        conObjTest1.AccountId=accountObj.id;
        ListContact.add(conObjTest1);
        insert ListContact;
        
        RecordType rTypeObject = new RecordType();
        rTypeObject = [SELECT  Name,Id, DeveloperName, SobjectType  FROM RecordType where name=:'IT Helpdesk' and SobjectType='case'];
        
        Case caseObjectTest=new Case();
        caseObjectTest.Description = 'myPlainText';
        caseObjectTest.Priority = 'Low';
        caseObjectTest.Origin = 'Email';
        caseObjectTest.Status = 'New';
        caseObjectTest.SuppliedEmail ='rcindia@simplion.com';
        caseObjectTest.SuppliedPhone ='1234567890';
        caseObjectTest.SuppliedName ='Test Name';
        caseObjectTest.Subject = 'Test Subject';
        caseObjectTest.RecordTypeid=rTypeObject.id;
        //insert caseObjectTest;
        /*******************Test Case Record without Supplied Email**************/
       /* Case caseObjectTest1=new Case();
        caseObjectTest1.Description = 'myPlainText';
        caseObjectTest1.Priority = 'Low';
        caseObjectTest1.Origin = 'Email';
        caseObjectTest1.Status = 'New';
        caseObjectTest1.Subject = 'Test Subject';
        caseObjectTest1.RecordTypeid=rTypeObject.id;
       // insert caseObjectTest1;
        List<case>  testCaseList=new  List<case>();
        testCaseList.add(caseObjectTest);
        testCaseList.add(caseObjectTest1);
        insert testCaseList;
        Schema.DescribeSObjectResult testmapresult = Case.SObjectType.getDescribe();
        Map<ID,Schema.RecordTypeInfo> testrtMapByName = testmapresult.getRecordTypeInfosById();
        Test.startTest(); 
        CaseITHelpDeskHelper objCLS_AttachContactToCase=new CaseITHelpDeskHelper ();
        objCLS_AttachContactToCase.checkContact(testCaseList,testrtMapByName);
        Test.stopTest();
    	}catch(Exception e){}
    }*/
    
   /* @isTest 
    public static void caseAttachContactTestMethod1() {
        try {
            Account accountObj = new Account(); 
            accountObj.Name = 'RC Internal';
            insert accountObj;
            
            RecordType rTypeObject = new RecordType();
            rTypeObject = [SELECT  Name,Id, DeveloperName, SobjectType  FROM RecordType where name=:'IT Helpdesk' and SobjectType='case'];
            
            Case caseObjectTest=new Case();
            caseObjectTest.Description = 'myPlainText';
            caseObjectTest.Priority = 'Low';
            caseObjectTest.Origin = 'Email';
            caseObjectTest.Status = 'New';
            caseObjectTest.SuppliedEmail ='rcindia@simplion.com';
            caseObjectTest.SuppliedPhone ='1234567890';
            caseObjectTest.SuppliedName ='Test Name';
            caseObjectTest.Subject = 'Test Subject';
            caseObjectTest.RecordTypeid=rTypeObject.id;
            insert caseObjectTest;
            
            List<case>  testCaseList=new  List<case>();
            testCaseList.add(caseObjectTest);
            Schema.DescribeSObjectResult testmapresult = Case.SObjectType.getDescribe();
            Map<ID,Schema.RecordTypeInfo> testrtMapByName = testmapresult.getRecordTypeInfosById();
            Test.startTest(); 
            CaseITHelpDeskHelper objCLS_AttachContactToCase=new CaseITHelpDeskHelper ();
            objCLS_AttachContactToCase.checkContact(testCaseList,testrtMapByName);
            Test.stopTest();
        } catch(Exception ex) {}
    } */
}