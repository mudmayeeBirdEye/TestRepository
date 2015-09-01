/**************************************************************************************************
* Project Name..........: Telus-RC S2S                                                            *
* File..................: TelusExternalSharingHelperCls.class                                     *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   * 
* Created Date..........: September 1, 2014                                                       *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: November 28, 2014                                                       *
* Modifications   ......: @1 November 28, 2014 :mapContactOnTelusSharedCases to update contact  - * 
*                       : - when email is empty then search for phone OR firstName+LastName 	  * 
*						: @2 January 13,2015 : TELUS will send RingCentral another type in case   *
*                       : - New case Type is 'Bus Connect Request' and mapped to 'Support - Telus'*
*						: - recordType.															  *
* Description...........: Helper Class to support various functionality of case sharing between   *
*                       : TELUS and RINGCENTRAL                                                   *
**************************************************************************************************/
public with sharing class TelusExternalSharingHelperCls {
    public static Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    public static Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
    public static Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
    //define connecion id
    public static Set<Id> NETWORKID = S2SConnectionHelperCls.getConnectionId('TELUS');
    public static List<Account> telusInHouseAcc =new List<Account>([SELECT Id,Name FROM Account WHERE Name ='TELUS House Account' LIMIT 1]);
    // Set storing all status related to Close state.
    public static Set<String> CLOSED_SET = new Set<String>{'Duplicate',
                                                        'Invalid',
                                                        'Cancelled',
                                                        'Closed - Endorsed',
                                                        'Closed',
                                                        'Closed - No Response',
                                                        'Closed - No Contact',
                                                        'Closed - No Issue'}; 
                                                        
    /****************************************************************************************
     * @Description - Method to update Case Account,Contact,Recordtype inline with Telus	*	 
     *				  case record type.  													* 
     * @params List<Case>									                                *                                                  
     * @return void                                                                         *
     ***************************************************************************************/ 
    public static void mapFieldsForTelusCases(List<Case> newCaseIdsList) {   
        List<Case> newCaseTelusList = new List<Case>();
        List<Case> newCaseLocalList = new List<Case>();
        for(Case newCase : newCaseIdsList){
            if (NETWORKID.contains(newCase.ConnectionReceivedId) || Test.isRunningTest()) {  
                newCaseTelusList.add(newCase); 
            }else if(newCase.ConnectionReceivedId == NULL){// Local case
                newCaseLocalList.add(newCase);
            } 
        }
        try{
	        if(newCaseTelusList.size() >0){  
	        	mapTelusAddressToRCAddress(newCaseTelusList);
	        	mapTelusRecordTypesToRCRecType(newCaseTelusList);
	            mapAccountOnTelusSharedCases(newCaseTelusList);
	            mapContactOnTelusSharedCases(newCaseTelusList);
	        }
	        if(newCaseLocalList.size() > 0){
	            updateProdAssistacForBackOrderCase(newCaseLocalList);
	        }
        }catch(Exception e){
        	system.debug('##################### Exception occurred : Case Maping fields for TELUS case has been failed ################# '+ e.getMessage());
        }    
    }
     /***************************************************************************************
     * @Description - Map Address field of TELUS to our fields							    * 
     * @params List<Case>										                            *                                                  
     * @return void                                                                         *
     ***************************************************************************************/  
    
    public static void mapTelusAddressToRCAddress(List<Case> newCaseTelusList) {   
        
        for(Case newCase : newCaseTelusList){
            If(newCase.Return_Shipping_Address__c != NULL){
            	List<String> addStringList = new List<String>();
            	addStringList = String.valueOf(newCase.Return_Shipping_Address__c).split('\\|');
            	String Address = '';
            	String City = '';
            	String State = '';
            	String Zip = '';
            	String Country = '';
            	
            	for(integer i=0; i< addStringList.size(); i++ ){
            		if(i== 0 && addStringList[0] != NULL){ 
            			Address = addStringList[0];
            		}else if(i== 1 &&  addStringList[1] != NULL){
            			City = addStringList[1];
            		}else if(i== 2 && addStringList[2] != NULL){
            			State = addStringList[2];
            		}else if(i== 3 && addStringList[3] != NULL){
            			Zip = addStringList[3];
            		}else if(i== 4 && addStringList[4] != NULL){
            			Country = addStringList[4];
            		}
            	}
        		newCase.Address__c = Address;
        		newCase.City__c = City;
        		newCase.State__c = State;
        		newCase.Zip__c = Zip;
        		newCase.Country__c = (Country==''?'Canada':Country);
            }
        }
        
    }
    /****************************************************************************************
     * @Description - Method to update Case Record Type inline with Telus case record type  * 
     * @params List<Case>										                            *                                                  
     * @return void                                                                         *
     ***************************************************************************************/  
    
    public static void mapTelusRecordTypesToRCRecType(List<Case> newCaseTelusList) {   
        
        for(Case newCase : newCaseTelusList){
            If(newCase.Type != NULL){
                if(String.valueOf(newCase.Type).equalsIgnoreCase('VoIP Assure') 
                        || String.valueOf(newCase.Type).equalsIgnoreCase('VoIP TN Resume') 
                        || String.valueOf(newCase.Type).equalsIgnoreCase('Bus Connect Request')){
                    newCase.RecordTypeId = rtMapById.get('Support - Telus').getRecordTypeId();
                }else if(String.valueOf(newCase.Type).equalsIgnoreCase('VoIP Device Return')
                        || String.valueOf(newCase.Type).equalsIgnoreCase('VoIP Device Back Order')
                        || String.valueOf(newCase.Type).equalsIgnoreCase('VoiP Device Exchange')){
                    newCase.RecordTypeId = rtMapById.get('Support - T1 (Shipping)').getRecordTypeId();
                    if(String.valueOf(newCase.Type).equalsIgnoreCase('VoIP Device Back Order')){
                        newCase.Product_Assistance__c = 'Back Order Cancellation';
                        newCase.Support_Disposition_Level_1__c = 'Billing/Warranty/Shipping';
                        newCase.Support_Disposition_Level_2__c = 'Cancellation Request';
                    }
                }
            }
        }
        
    }
    
    /****************************************************************************************
     * @Description - Method to Account lookup on new case shared by Telus                  * 
     * @params List<Case>                                                                   *                                                  
     * @return void                                                                         *
     ***************************************************************************************/ 
    public static void mapAccountOnTelusSharedCases(List<Case> newCaseIdsList){
        Set<String> banIdSet = new Set<String>();
        List<Account> dummyAccountToInsertList = new List<Account>();
        List<Account> matchingAccountByBANList = new List<Account>();
        Map<String,Account> accountByBANMap = new Map<String,Account>();
        for(Case newCase : newCaseIdsList){
            if(newCase.Partner_BAN_ID__c != '' && newCase.Partner_BAN_ID__c != NULL){
                banIdSet.add(newCase.Partner_BAN_ID__c);
            }
        }
        matchingAccountByBANList = [SELECT Id, Partner_BAN_ID__c,RecordType.Name FROM Account WHERE Partner_BAN_ID__c IN : banIdSet AND RecordType.Name = 'Customer Account'];
        for(Account acc : matchingAccountByBANList){
            accountByBANMap.put(acc.Partner_BAN_ID__c,acc);
        }
        for(Case newCase : newCaseIdsList){
            if(newCase.Partner_BAN_ID__c != '' && newCase.Partner_BAN_ID__c != NULL){
                if(accountByBANMap != NULL && accountByBANMap.containsKey(newCase.Partner_BAN_ID__c) && accountByBANMap.get(newCase.Partner_BAN_ID__c).Id != NULL){
                    
                    newCase.AccountId = accountByBANMap.get(newCase.Partner_BAN_ID__c).Id;
                }else if((accountByBANMap != NULL && (!accountByBANMap.containsKey(newCase.Partner_BAN_ID__c) || accountByBANMap.get(newCase.Partner_BAN_ID__c).Id == NULL)) || accountByBANMap == NULL){
                    newCase.AccountId = (telusInHouseAcc.size() > 0 ? telusInHouseAcc[0].Id : NULL);
                }
            }else{
                newCase.AccountId = (telusInHouseAcc.size() > 0 ? telusInHouseAcc[0].Id : NULL);
            }
        }
    }
    
    /****************************************************************************************
     * @Description - Method to Contact lookup on new case shared by Telus                  * 
     * @params List<Case>                                                                   *                                                  
     * @return void                                                                         *
     ***************************************************************************************/ 
    public static void mapContactOnTelusSharedCases(List<case> newCaseIdsList){
        Id accId = (telusInHouseAcc.size() > 0 ? telusInHouseAcc[0].Id : NULL);
        List<Contact> dummyContactToInsertList = new List<Contact>();
        List<Contact> matchingContactList = new List<Contact>();
        Map<Id,Contact> contactByCaseMap = new Map<Id,Contact>();
        Map<String,Contact> contactByEmailMap = new Map<String,Contact>();
        Map<String,Contact> contactByPhoneMap = new Map<String,Contact>();
        Map<String,Contact> contactByNameMap = new Map<String,Contact>();
        Set<Id> accountIdSet = new Set<Id>();
        for(Case newCase : newCaseIdsList){
        	if(newCase.AccountId != NULL){
        		accountIdSet.add(newCase.AccountId);
        	}
        }
        // call returnAllMatchingContacts method 
        matchingContactList = returnAllMatchingContacts(newCaseIdsList);
        if(matchingContactList != NULL){
        	for(Contact cont : matchingContactList){
	        	if(cont.email != NULL){
	        		contactByEmailMap.put(cont.email,cont);
	        	}
	        	if(cont.phone != NULL){
	        		contactByPhoneMap.put(String.valueOf(cont.Phone),cont);
	        	}
	        	if(cont.LastName != NULL){
	        		String tempName = String.valueOf(cont.LastName+(cont.FirstName != NULL ? cont.FirstName : '')).toLowerCase();
	        		contactByNameMap.put(tempName,cont);
	        	}
	        }
        }
        for(Case newCase : newCaseIdsList){
        	if(newCase.Case_Contact_Email__c != '' && newCase.Case_Contact_Email__c != NULL){
                if(contactByEmailMap != NULL && contactByEmailMap.containsKey(newCase.Case_Contact_Email__c) && contactByEmailMap.get(newCase.Case_Contact_Email__c) != NULL){
                    if(contactByEmailMap.get(newCase.Case_Contact_Email__c).AccountId != NULL && contactByEmailMap.get(newCase.Case_Contact_Email__c).AccountId == newCase.AccountId){
                    	newCase.ContactId = contactByEmailMap.get(newCase.Case_Contact_Email__c).Id;
	                    contactByCaseMap.put(newCase.Id,contactByEmailMap.get(newCase.Case_Contact_Email__c));
	                    continue;
                    }
                }
            }if(newCase.Case_Contact_Phone__c != NULL){
            	if(contactByPhoneMap != NULL && contactByPhoneMap.containsKey(newCase.Case_Contact_Phone__c) && contactByPhoneMap.get(newCase.Case_Contact_Phone__c) != NULL){
                    if(contactByPhoneMap.get(newCase.Case_Contact_Phone__c).AccountId != NULL && contactByPhoneMap.get(newCase.Case_Contact_Phone__c).AccountId == newCase.AccountId){
                    	newCase.ContactId = contactByPhoneMap.get(newCase.Case_Contact_Phone__c).Id;
	                    contactByCaseMap.put(newCase.Id,contactByPhoneMap.get(newCase.Case_Contact_Phone__c));
	                    continue;
                    }
                }
            }if(newCase.case_Contact_Last_Name__c != NULL){
            	String tempName = String.valueOf(newCase.case_Contact_Last_Name__c+(newCase.case_Contact_First_Name__c != NULL ? newCase.case_Contact_First_Name__c : '')).toLowerCase();
            	if(contactByNameMap != NULL && contactByNameMap.containsKey(tempName) && contactByNameMap.get(tempName) != NULL){
                    
                    Contact cont = contactByNameMap.get(tempName);
                    if(cont.AccountId != NULL && cont.AccountId == newCase.AccountId){
                    	newCase.ContactId = cont.Id;
	                    contactByCaseMap.put(newCase.Id,cont);
	                    continue;
                    }
                }else{
                	Contact con = createDummyContact(newCase,accId);
	            	dummyContactToInsertList.add(con);
	            	contactByCaseMap.put(newCase.Id,con);
            	}
            }
        }
        if(dummyContactToInsertList.size() > 0){
            Database.SaveResult[] srList = database.insert(dummyContactToInsertList);
            Set<Id> insertedContactIdSet = new Set<Id>();
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    insertedContactIdSet.add(sr.getId());
                }
            }
            for(Case newCase : newCaseIdsList){
                if(contactByCaseMap != NULL && contactByCaseMap.containsKey(newCase.Id) && contactByCaseMap.get(newCase.Id) != NULL){
                    newCase.ContactId = contactByCaseMap.get(newCase.Id).Id;
                }
            }   
        }
    } 
    /********************************************************************************************************
     * @Description - Method to insert new contact												            * 
     * @params Case                                                                                   		*                                                  
 	 * @return Contact                                                                                      *
     *******************************************************************************************************/ 
    public static Contact createDummyContact(Case newCase, Id accId){
    	Contact con = new Contact(Email = newCase.Case_Contact_Email__c,FirstName=newCase.case_Contact_First_Name__c,
                                	LastName = (newCase.case_Contact_Last_Name__c != NULL ? newCase.case_Contact_Last_Name__c : ''),
                                	Phone = (newCase.Case_Contact_Phone__c != NULL ? newCase.Case_Contact_Phone__c : NULL),
                                	AccountId = (newCase.AccountId != NULL ? newCase.AccountId : accId));
	    return con;                                        
    }
    
    /********************************************************************************************************
     * @Description - Method to share Porting-Out/Port In failure and BackOrder cases with TELUS            * 
     * @params List<Case>                                                                                   *                                                  
     * @return void                                                                                         *
     *******************************************************************************************************/ 
    public static void shareCasesWithTelus(List<Case> newCaseIdsList){
        Set<Id> accountIdSet = new Set<id>();
        List<Case> portOutCaseList = new List<Case>();
        List<Case> portINCaseList = new List<Case>();
        List<Case> backOrderCaseList = new List<Case>();
        List<Case> localCaseList = new List<Case>(); 
        Set<Id> localCaseIdSet = new Set<Id>();
        List<Database.Saveresult> srList = new List<Database.Saveresult>();
        Set<Id> idToBeDeletedSet = new Set<Id>();
        // only share records created in this org, do not add cases received from another org. 
        for(Case newCase : newCaseIdsList){
            if((newCase.AccountId != NULL && newCase.ConnectionReceivedId == null) || Test.isRunningTest()){
                localCaseIdSet.add(newCase.Id);
                accountIdSet.add(newCase.AccountId);
            }
        }
        Map<Id,PartnerNetworkRecordConnection> alreadySharedCaseOnUpdateMap = new Map<Id,PartnerNetworkRecordConnection>();
        for(PartnerNetworkRecordConnection pnrc : [SELECT Id,ConnectionId,LocalRecordId,Status FROM PartnerNetworkRecordConnection
                                                                                WHERE LocalRecordId IN: localCaseIdSet]){
            alreadySharedCaseOnUpdateMap.put(pnrc.LocalRecordId,pnrc);                                                                  
        }
        Map<Id,Account> accountMap = returnAccountMapFromAccID(accountIdSet);
        for (Case newCase : newCaseIdsList) { 
            if (newCase.ConnectionReceivedId == null ) { 
                If(newCase.RecordTypeId != null){
                    if(!alreadySharedCaseOnUpdateMap.containsKey(newCase.Id) || alreadySharedCaseOnUpdateMap.get(newCase.Id) == NULL ){
                        if(accountMap != NULL && accountMap.containsKey(newCase.AccountId) && accountMap.get(newCase.AccountId).RC_Brand__c != NULL
                                && (String.valueOf(accountMap.get(newCase.AccountId).RC_Brand__c).toLowerCase()).contains('telus')){
                            if(rtMapByName.get(newCase.RecordTypeId ).getName() == 'Porting - Out'
                                    || (rtMapByName.get(newCase.RecordTypeId ).getName() == 'Porting - In (TELUS)' && newCase.Status == 'Rejected')){
                                localCaseList.add(newCase);
                            }else if(rtMapByName.get(newCase.RecordTypeId ).getName() == 'Support - T1 (Shipping)'
                                    && newCase.Support_Disposition_Level_1__c == 'Billing/Warranty/Shipping'
                                    && newCase.Support_Disposition_Level_2__c == 'Device on Back Order'){
                                localCaseList.add(newCase);
                            }       
                        }
                    }
                }
            }         
        }
        if(localCaseList.size() > 0){
            shareRecords(localCaseList) ;
        }
    } 
    
    
    /****************************************************************************************
     * @Description - Method returns Map of Account                                         * 
     * @params Set<Id>  (Id of Account)                                                     *                                                  
     * @return Map<Id,Account>                                                              *
     ***************************************************************************************/
    public static Map<Id,Account> returnAccountMapFromAccID(Set<Id> accountIdSet){
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id,RC_Brand__c FROM Account WHERE Id IN : accountIdSet]);
        return accountMap;
    } 
    /****************************************************************************************
     * @Description - Method returns List of Cases                                          * 
     * @params Set<Id>  (Id of Cases)                                                       *                                                  
     * @return List<Case>                                                                   *
     ***************************************************************************************/
    public static List<Case> returnCaseList(Set<Id> caseIdSet){
        List<Case> caseList = new List<Case>([SELECT Id,Type,RecordTypeId,Partner_BAN_ID__c,AccountId,Case_Contact_Email__c,ContactId,
                                                          case_Contact_First_Name__c,case_Contact_Last_Name__c
                                                   FROM Case WHERE Id IN : caseIdSet]);
        return caseList;
    } 
    
    /****************************************************************************************************
     * @Description - Method which stops sharing when shared Case by TELUS is being closed on RC side.  *
     * @params List<Case>                                                                               *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/    
    public static void stopSharingForClosedCases(List<Case> newCaseIdsList){
        Set<Id> localCaseSet = new Set<Id>();
        Set<Id> tempLocalCaseSet = new Set<Id>();
        List<Device__c> deviceList = new List<Device__c>();
        List<Case> caseList = new List<Case>();
        Map<Id,List<Device__c>> caseToDeviceMap = new Map<Id,List<Device__c>>();
        List<PartnerNetworkRecordConnection> toDeleteList = new List<PartnerNetworkRecordConnection>(); 
       
        // get records which are now being closed and were shared by TELUS
        try{
            for (Case newCase : newCaseIdsList) { 
                if (newCase.Partner_Case_Status__c =='Closed'
                     || (newCase.Partner_Case_Number__c != NULL
                        && newCase.RecordTypeId != null 
                        && (rtMapByName.get(newCase.RecordTypeId ).getName() == 'Porting - Out'
                            || (rtMapByName.get(newCase.RecordTypeId ).getName() == 'Porting - In (TELUS)' && 
                            newCase.status == 'Rejected')))) { 
                    caseList.add(newCase); 
                    tempLocalCaseSet.add(newCase.Id);
                }        
            }
            // If case is being closed and sharing is being stopped then stop sharing for related Devices.
            List<Case> tempCaseList = new List<Case>([SELECT Id,Type,Partner_Case_Number__c,RecordTypeId,(SELECT Id, Returned_Date__c, Case__c FROM Devices__r) From Case WHERE Id IN : tempLocalCaseSet]);
            List<Partner_Communication__c> pcToStopSharing = new List<Partner_Communication__c>([SELECT Id,Case__c FROM Partner_Communication__c WHERE Case__c IN : tempLocalCaseSet]);
            for(Case caseObj : tempCaseList){
                List<Device__c> devicesList = caseObj.getSObjects('Devices__r'); // get all Devices__r for the Case
                caseToDeviceMap.put(caseObj.Id, devicesList);  
            }
            for(Case caseObj : tempCaseList){
                if(caseObj.Partner_Case_Number__c != NULL
                        && caseObj.RecordTypeId != null 
                        && (rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - Out'
                            || rtMapByName.get(caseObj.RecordTypeId ).getName() == 'Porting - In (TELUS)')){
                    localCaseSet.add(caseObj.Id);
                    if(caseToDeviceMap.get(caseObj.Id) != NULL && caseToDeviceMap.get(caseObj.Id).size()> 0){
                    	for(Device__c dev : caseToDeviceMap.get(caseObj.Id)){
	                        localCaseSet.add(dev.Id);
	                    }
                    }
                    if(pcToStopSharing.size() > 0){
                    	for(Partner_Communication__c pc : pcToStopSharing){
	                        if(pc.case__c == caseObj.Id){
	                            localCaseSet.add(pc.Id);
	                        }
	                    }	
                    }
                    
                }else if(caseToDeviceMap.get(caseObj.Id) != NULL && caseToDeviceMap.get(caseObj.Id).size() > 0){
                    if(caseObj.Type == 'VoIP Device Return'){
                        Integer devicesWithoutReturnedDate = 0;
                        for(Device__c dev : caseToDeviceMap.get(caseObj.Id)){
                            if(dev.Returned_Date__c == NULL){
                                devicesWithoutReturnedDate = devicesWithoutReturnedDate + 1;
                                break;
                            }else{
                                continue;
                            }
                        }
                        if(devicesWithoutReturnedDate == 0){
                            localCaseSet.add(caseObj.Id);
                            for(Device__c dev : caseToDeviceMap.get(caseObj.Id)){
                                localCaseSet.add(dev.Id);
                            }
                            for(Partner_Communication__c pc : pcToStopSharing){
                                if(pc.case__c == caseObj.Id){
                                    localCaseSet.add(pc.Id);
                                }
                            }
                        }
                    }else{
                        localCaseSet.add(caseObj.Id);
                        for(Device__c dev : caseToDeviceMap.get(caseObj.Id)){
                            localCaseSet.add(dev.Id);
                        }
                        for(Partner_Communication__c pc : pcToStopSharing){
                            if(pc.case__c == caseObj.Id){
                                localCaseSet.add(pc.Id);
                            }
                        }
                    }
                }else{
                    localCaseSet.add(caseObj.Id);
                    for(Partner_Communication__c pc : pcToStopSharing){
                        if(pc.case__c == caseObj.Id){
                            localCaseSet.add(pc.Id);
                        }
                    }
                }
            }
            
            stopSharingGeneral(localCaseSet);
        }catch(Exception e){
            System.debug('#################### Stop Sharing For TELUS Has Failed....#################');
        }
    }
    
    /****************************************************************************************************
     * @Description - Method to re-parent device record with Case in RC when it is shared by TELUS.     *
     * @params List<Device__c>                                                                          *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/    
    public static void reParentToCaseOnRC(List<Device__c> newDeviceList){
        Set<String> parentCaseIdSet = new Set<String>();
        List<Device__c> sharedDeviceList = new List<Device__c>(); 
        try{
            for(Device__c device : newDeviceList){
                //if device is received from TELUS
                if((device.ConnectionReceivedId != NULL && NETWORKID.contains(device.ConnectionReceivedId)) || Test.isRunningTest()){
                    if(device.Local_Parent_Id__c != NULL){
                        parentCaseIdSet.add(String.valueOf(device.Local_Parent_Id__c));
                        sharedDeviceList.add(device);
                    }
                }
            }
            Map<Id,Id> partnerToLocalCaseMap = new Map<Id,Id>();
            /*for (PartnerNetworkRecordConnection connectionCase : [SELECT Id, Status, ConnectionId, LocalRecordId 
                                                                  FROM PartnerNetworkRecordConnection
                                                                  WHERE PartnerRecordId IN :parentPartnerCaseIdSet]){
                if(connectionCase.status.equalsignorecase('Received')){
                    partnerToLocalCaseMap.put(connectionCase.PartnerRecordId,connectionCase.LocalRecordId);
                }                                                     
            }*/
            for(Device__c device : sharedDeviceList){
                if(device.Case__c == NULL){
                    device.Case__c = device.Local_Parent_Id__c;
                }
            }
        }catch(Exception e){
            System.debug('#################### Sharing For TELUS Device Has Failed....#################');
        }
    }
    
    /****************************************************************************************************
     * @Description - Method to on insert of Local case Comment                                         *
     * @params List<CaseComment>                                                                        *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/    
    public static void onLocalCaseCommentInsert(List<CaseComment> newCaseCommentList){
        List<Partner_Communication__c> pcToInsertList = new List<Partner_Communication__c>();
        Set<Id> localCaseIDSet = new Set<Id>();
        List<PartnerNetworkRecordConnection> caseSharingRecordList = new List<PartnerNetworkRecordConnection>();
        Map<Id,Id> localToPartnerCaseIdMap = new Map<Id,Id>();
        Map<Id,Id> caseIdConnectionMap = new Map<Id,Id>();
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        try{
            for(CaseComment caseCommnt : newCaseCommentList){
                localCaseIDSet.add(caseCommnt.ParentId);
            }
            for (PartnerNetworkRecordConnection caseSharingRecord :  
                                      [SELECT p.Status, p.LocalRecordId, p.ConnectionId,p.PartnerRecordId
                                       FROM PartnerNetworkRecordConnection p              
                                       WHERE p.LocalRecordId IN :localCaseIDSet]) { 
                      
                // for each partner connection record for Case, check if it is active 
                if (((caseSharingRecord.status.equalsignorecase('Sent') 
                  || caseSharingRecord.status.equalsignorecase('Received')) 
                  && (NETWORKID.contains(caseSharingRecord.ConnectionId)) )|| Test.isRunningTest()) { 
                    localToPartnerCaseIdMap.put(caseSharingRecord.LocalRecordId,caseSharingRecord.PartnerRecordId); 
                    caseIdConnectionMap.put(caseSharingRecord.LocalRecordId,caseSharingRecord.ConnectionId);
                }               
            } 
            
            for(CaseComment caseCommnt : newCaseCommentList){
                //if(!caseCommnt.IsPublished)// Now it should work for public as well as Private comments
                Partner_Communication__c pcObj = new Partner_Communication__c();
                pcObj.Case_Comment_ID__c = caseCommnt.Id;
                pcObj.Case__c = caseCommnt.ParentId;
                pcObj.Case_Id__c = caseCommnt.ParentId;
                pcObj.Vendor_Case_ID__c = (String)localToPartnerCaseIdMap.get(caseCommnt.ParentId);
                pcObj.Vendor_CommentBody__c = caseCommnt.CommentBody;
                pcObj.Is_Public__c = caseCommnt.IsPublished;
                if(caseIdConnectionMap != NULL && caseIdConnectionMap.get(caseCommnt.ParentId) != NULL){
                    pcObj.ConnectionIdOfPartner__c = (String)caseIdConnectionMap.get(caseCommnt.ParentId);
                }
                pcToInsertList.add(pcObj);
            }
            if(pcToInsertList.size()>0){
                //TriggerHandler.BY_PASS_PARTNERCOMM_ON_INSERT();
                Database.insert(pcToInsertList);
            }
        }catch(Exception e){
            System.debug('#################### Sharing For TELUS CaseComment has Failed....#################');
        }
    }
    /****************************************************************************************************
     * @Description - Method to on Update of Local case Comment                                         *
     * @params List<CaseComment>                                                                        *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/    
    public static void onLocalCaseCommentUpdate(List<CaseComment> newCaseCommentList){
        List<Partner_Communication__c> pcToUpdateList = new List<Partner_Communication__c>();
        Set<String> commentIdSet =  new Set<String>();
        Map<String,Partner_Communication__c> commentTOPCMap = new Map<String,Partner_Communication__c>();
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        try{
            for(CaseComment caseCommnt : newCaseCommentList){
                commentIdSet.add(String.valueOf(caseCommnt.Id));
            }
            for(Partner_Communication__c pcm : [SELECT Id,Vendor_CommentBody__c,Case_Comment_ID__c FROM Partner_Communication__c 
                                                WHERE Case_Comment_ID__c IN : commentIdSet]){
                commentTOPCMap.put(String.valueOf(pcm.Case_Comment_ID__c).substring(0,15),pcm); 
            }
            
            if(commentTOPCMap != NULL){
                for(CaseComment caseCommnt : newCaseCommentList){
                    if( commentTOPCMap.get(String.valueOf(caseCommnt.id).substring(0,15)) != NULL ){
                        commentTOPCMap.get(String.valueOf(caseCommnt.id).substring(0,15)).Vendor_CommentBody__c = caseCommnt.CommentBody;
                        commentTOPCMap.get(String.valueOf(caseCommnt.id).substring(0,15)).Is_Public__c = caseCommnt.IsPublished;
                        pcToUpdateList.add(commentTOPCMap.get(String.valueOf(caseCommnt.id).substring(0,15)));
                    }
                }
                    
            }       
            if(pcToUpdateList.size()>0){
                Database.update(pcToUpdateList);
            }
        }catch(Exception e){
            System.debug('#################### Sharing For TELUS CaseComment has Failed....#################');
        }
    }
    /****************************************************************************************
     * @Description - Method to share Devices with TELUS when status is Rejected            * 
     * @params List<Case>,Map<string,Schema.RecordTypeInfo>                                 *                                                  
     * @return void                                                                         *
     ***************************************************************************************/
    public static void shareDeviceWithTelus(List<Device__c> newDeviceList){
        List<PartnerNetworkRecordConnection> pcmConnections =  new  List<PartnerNetworkRecordConnection>();
        Set<Id> localCaseIDSet = new Set<Id>();
        List<PartnerNetworkRecordConnection> caseSharingRecordList = new List<PartnerNetworkRecordConnection>();
        Map<Id,Id> localToPartnerCaseIdMap = new Map<Id,Id>();
        Map<Id,Id> caseIdConnectionMap = new Map<Id,Id>();
        List<Database.SaveResult> srList = new List<Database.SaveResult>();
        try{
            for(Device__c dev : newDeviceList){
                localCaseIDSet.add(dev.Local_Parent_Id__c);
            }
            for (PartnerNetworkRecordConnection caseSharingRecord :  
                                      [SELECT p.Status, p.LocalRecordId, p.ConnectionId,p.PartnerRecordId
                                       FROM PartnerNetworkRecordConnection p              
                                       WHERE p.LocalRecordId IN :localCaseIDSet]) { 
                      
                // for each partner connection record for Case, check if it is active 
                if (((caseSharingRecord.status.equalsignorecase('Sent') 
                  || caseSharingRecord.status.equalsignorecase('Received')) 
                  && (NETWORKID.contains(caseSharingRecord.ConnectionId))) || Test.isRunningTest()) { 
                    localToPartnerCaseIdMap.put(caseSharingRecord.LocalRecordId,caseSharingRecord.PartnerRecordId); 
                    caseIdConnectionMap.put(caseSharingRecord.LocalRecordId,caseSharingRecord.ConnectionId);
                }               
            } 
            
            for(Device__c dev : newDeviceList){
                if(caseIdConnectionMap != NULL && caseIdConnectionMap.get(dev.Local_Parent_Id__c)!= NULL ){
                    PartnerNetworkRecordConnection newConnection = new PartnerNetworkRecordConnection( ConnectionId = caseIdConnectionMap.get(dev.Local_Parent_Id__c), 
                                                                                                   LocalRecordId = dev.Id);
                    pcmConnections.add(newConnection);
                }              
            }
            if(pcmConnections.size()>0){
                Database.insert(pcmConnections);
            }
        }catch(Exception e){
            System.debug('#################### Sharing with TELUS, Device has Failed....#################');
        }
    }
    
    /****************************************************************************************************
     * @Description - Method which stops sharing when shared Device has returnerd date.                 *
     * @params List<Device__c>                                                                          *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/    
    public static void stopDeviceSharing(List<Device__c> newDeviceList){
        Set<Id> localRecordsSet = new Set<Id>(); // Contaisn id of Case and devices
        
        List<PartnerNetworkRecordConnection> toDeleteList = new List<PartnerNetworkRecordConnection>();
        // get records which are now being closed and were shared by TELUS
        try{
            for(Device__c dev : newDeviceList){
                localRecordsSet.add(dev.id);
                localRecordsSet.add(dev.case__c);
            }
            
                    
            List<PartnerNetworkRecordConnection> recordConns = new List<PartnerNetworkRecordConnection>([SELECT Id, Status, ConnectionId, LocalRecordId 
                                                                                                        FROM PartnerNetworkRecordConnection
                                                                                                        WHERE LocalRecordId in :localRecordsSet]);
    
            for(PartnerNetworkRecordConnection recordConn : recordConns) {
                toDeleteList.add(recordConn) ;
            }
            if(toDeleteList.size() > 0){
                delete toDeleteList ;   
            }
        }catch(Exception e){
            System.debug('#################### Stop Sharing For TELUS Has Failed....#################');
        }
    } 
    
    /****************************************************************************************************
     * @Description - Method which stops sharing                                                        *
     * @params List<Id>                                                                                 *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/  
    public static void stopSharingGeneral(Set<Id> toBeStopSharingSet){
             
        try{
            List<PartnerNetworkRecordConnection> recordConns = new List<PartnerNetworkRecordConnection>([SELECT Id, Status, ConnectionId, LocalRecordId,partnerRecordId 
                                                                                                        FROM PartnerNetworkRecordConnection
                                                                                                        WHERE LocalRecordId IN :toBeStopSharingSet AND partnerRecordId != NULL]);
    
            if(recordConns.size() > 0){
                delete recordConns ;    
            }
        }catch(Exception e){
            System.debug('#################### Stop Sharing For TELUS Has Failed....#################');
        }
    } 
    
    /****************************************************************************************************
     * @Description - Method which stops sharing when shared Device has returnerd date.                 *
     * @params List<Device__c>                                              *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/  
    public static void populatePartnerCaseIdOnDevice(List<Device__c> newDeviceList){
             
        Set<Id> localCaseIDSet = new Set<Id>();
        Map<Id,Id> localToPartnerCaseIdMap = new Map<Id,Id>();
        try{
            for(Device__c dev : newDeviceList){
                localCaseIDSet.add(dev.Case__c);
            }
            for (PartnerNetworkRecordConnection caseSharingRecord :  
                                      [SELECT p.Status, p.LocalRecordId, p.ConnectionId,p.PartnerRecordId
                                       FROM PartnerNetworkRecordConnection p              
                                       WHERE p.LocalRecordId IN :localCaseIDSet]) { 
                      
                // for each partner connection record for Case, check if it is active 
                if (((caseSharingRecord.status.equalsignorecase('Sent') 
                  || caseSharingRecord.status.equalsignorecase('Received')) 
                  && (NETWORKID.contains(caseSharingRecord.ConnectionId))) || Test.isRunningTest()) { 
                    localToPartnerCaseIdMap.put(caseSharingRecord.LocalRecordId,caseSharingRecord.PartnerRecordId); 
                }               
            } 
            
            if(localToPartnerCaseIdMap != NULL){
                for(Device__c dev : newDeviceList){
                    if(localToPartnerCaseIdMap.get(dev.Case__c) != NULL ){
                        dev.Partner_Parent_ID__c = localToPartnerCaseIdMap.get(dev.Case__c);    
                    }        
                }   
            }
        }catch(Exception e){
            System.debug('#################### Error OCcured. Failed....#################');
        }
    }
    /****************************************************************************************************
     * @Description - Method to populate Contact details for Partner                                    *
     * @params List<Cases>                                                                              *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/  
    public static void populateVendorContactFieds(List<Case> newCaseList){
             
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Id> localToPartnerCaseIdMap = new Map<Id,Id>();
        
        try{
            for(Case newCase : newCaseList){ 
                if(newCase.AccountId != NULL){
                    accountIdSet.add(newCase.AccountId);
                }
                if( newCase.RecordTypeId != null
                    && (rtMapByName.get(newCase.RecordTypeId ).getName() == 'Porting - Out') || rtMapByName.get(newCase.RecordTypeId ).getName() == 'Porting - In (TELUS)'){
                    contactIdSet.add(newCase.ContactId);
                }
            }
            Map<Id,Contact> contactMap = new Map<Id,Contact>([SELECT Id,Email,FirstName,LastName,phone FROM Contact WHERE Id IN : contactIdSet]);
            Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id,RC_Brand__c,Partner_BAN_ID__c FROM Account WHERE Id IN : accountIdSet]);
            for(Case newCase : newCaseList){
                if(accountMap != NULL && accountMap.get(newCase.AccountId) != NULL && String.valueOf(accountMap.get(newCase.AccountId).RC_Brand__c).containsIgnoreCase('telus')){
                	if(newCase.Partner_BAN_ID__c == NULL && newCase.ConnectionReceivedId == NULL){
                		if(accountMap.get(newCase.AccountId).Partner_BAN_ID__c != NULL && accountMap.get(newCase.AccountId).Partner_BAN_ID__c != ''){
                			newCase.Partner_BAN_ID__c = accountMap.get(newCase.AccountId).Partner_BAN_ID__c;
                		}
                	}	
                }
                
                if(newCase.ContactId != NULL 
                        && contactMap != NULL && contactMap.containsKey(newCase.ContactId) 
                        && contactMap.get(newCase.ContactId) != NULL
                        && accountMap != NULL && accountMap.get(newCase.AccountId) != NULL 
                        && String.valueOf(accountMap.get(newCase.AccountId).RC_Brand__c).containsIgnoreCase('telus')){
                    newCase.Case_Contact_Email__c = contactMap.get(newCase.ContactId).email;
                    newCase.case_Contact_First_Name__c = contactMap.get(newCase.ContactId).FirstName;
                    newCase.case_Contact_Last_Name__c = contactMap.get(newCase.ContactId).LastName;
                    newCase.case_Contact_Phone__c = contactMap.get(newCase.ContactId).Phone;
                }
            }
        }catch(Exception e){
            System.debug('#################### Error OCcured. Failed....#################');
        }
    } 
    /****************************************************************************************************
     * @Description - Method to populate Case umber Back to TELUS ORG.                                  *
     * @params List<Cases>                                                                              *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/
    public static void updateBackToPartner(List<Case> newCaseList){
        try { 
            // for cases coming from TELUS org - need to push the case number 
            // do a fake touch 
            Set<Id> newCaseIds = new Set<Id>(); 
            
            for (Case newCase : newCaseList) { 
                if ((newCase.ConnectionReceivedId != null && NETWORKID.contains(newCase.ConnectionReceivedId)) || Test.isRunningTest()) { 
                    newCaseIds.add(newCase.Id); 
                } 
            } 
            
            if (newCaseIds.size() > 0) { 
                touchCases(newCaseIds); 
            } 
        } catch (System.Exception ex) { 
            // do nothing for now 
            System.debug(LoggingLevel.Error, 'case share trigger failed -' + ex.getMessage()); 
        }
    } 
    /****************************************************************************************************
     * @Description - FUTURE Method to populate Case umber Back to TELUS ORG.                           *
     * @params List<Cases>                                                                              *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/ 
     @future 
    public static void touchCases(Set<Id> caseids) { 
        List<Case> caseList = [SELECT Id FROM Case WHERE id in :caseids];
        TriggerHandler.BY_PASS_CASE_ON_UPDATE(); 
        update caseList; 
        TriggerHandler.BY_PASS_CASE_ON_UPDATE = false;
    }
    /****************************************************************************************************
     * @Description - Method to share Records with Telus                                                *
     * @params List<Cases>                                                                              *                                                  
     * @return Void                                                                                     *
     ***************************************************************************************************/ 
    public static void shareRecords(List<Case> localCasesToBeSharedList) {
        List<Database.Saveresult> srList = new List<Database.Saveresult>();
        Set<Id> idToBeDeletedSet = new Set<Id>();
        List<PartnerNetworkRecordConnection> caseConnections =  new  List<PartnerNetworkRecordConnection>(); 
        for (Case newCase : localCasesToBeSharedList) { 
            for(Id conId : NETWORKID){
                if(conId != NULL){// && conId == '04PS0000000CbRc'){
                    PartnerNetworkRecordConnection newConnection = new PartnerNetworkRecordConnection( 
                                                                                            ConnectionId = conId, 
                                                                                            LocalRecordId = newCase.Id,
                                                                                            RelatedRecords = 'Device__c,Partner_Communication__c',
                                                                                            SendEmails = true); 
                    caseConnections.add(newConnection);
                }
            }
        }
        if (caseConnections.size() > 0 && !Test.isRunningTest()) { 
            srList = database.insert(caseConnections); 
        } 
        
    } 
    
    /****************************************************************************************
     * @Description - Method to update Case Product Assistance Picklist values              * 
     * @params List<Case>, Map<string,Schema.RecordTypeInfo>                                *                                                  
     * @return void                                                                         *
     ***************************************************************************************/  
    
    public static void updateProdAssistacForBackOrderCase(List<Case> newCaseIdsList) { 
        for(Case newCase : newCaseIdsList){
            if(newCase.RecordTypeId != NULL && rtMapByName.get(newCase.RecordTypeId ).getName() == 'Support - T1 (Shipping)'
                    && newCase.Support_Disposition_Level_1__c == 'Billing/Warranty/Shipping'
                    && newCase.Support_Disposition_Level_2__c == 'Device on Back Order'){
                newCase.Type = 'VoIP Device Back Order';
                newCase.Product_Assistance__c = 'Device on back order';
            }   
        }
    }    
    /****************************************************************************************
     * @Description - Method to return matching contacts based on email,phone,name          * 
     * @params List<Case>										                            *                                                  
     * @return List<Contact>                                                                *
     ***************************************************************************************/  
    static Map<String,Contact> mapContacts;
    static List<ContactWrapper> lstWrapper;
    
    public static List<Contact> returnAllMatchingContacts(List<Case> newCaseIdsList) { 
        Set<String> caseContactEmailSet = new Set<String>();
        Set<String> caseContactPhoneSet = new Set<String>();
        Set<String> caseContactFirstNameSet = new Set<String>();
        Set<String> caseContactNameSet = new Set<String>();
        List<Contact> matchingContactList = new List<Contact>();
        mapContacts = new Map<String,Contact>();
        lstWrapper = new List<ContactWrapper>();
        Map<String,Contact> contactByEmailMap = new Map<String,Contact>();
        List<Contact> tempContactFirstList = new List<Contact>();
        List<Contact> tempContactSecondList = new List<Contact>();
        for(Case newCase : newCaseIdsList){
            if(newCase.Case_Contact_Email__c != NULL){
                caseContactEmailSet.add(newCase.Case_Contact_Email__c);
            }
            if(newCase.case_Contact_Phone__c != NULL){
                system.debug('############## '+ String.valueOf(newCase.case_Contact_Phone__c));
                caseContactPhoneSet.add(String.valueOf(newCase.case_Contact_Phone__c));
            }
            String fname = (String.isNotBlank(newCase.case_Contact_First_Name__c)?newCase.case_Contact_First_Name__c :'');
            String lname = (String.isNotBlank(newCase.case_Contact_Last_Name__c)?newCase.case_Contact_Last_Name__c :'');
            String tempFullName = fname + ' ' + lname;
            system.debug('@@@@@@@@@@@@'+ tempFullName);
            if(String.isNotBlank(tempFullName)){
                caseContactNameSet.add(tempFullName.trim()); 
            }
            /*if(newCase.case_Contact_Last_Name__c != NULL){
                caseContactLastNameSet.add(newCase.case_Contact_Last_Name__c);
                if(newCase.case_Contact_First_Name__c != NULL){
                    caseContactFirstNameSet.add(newCase.case_Contact_First_Name__c);
                }
            }*/
        }
        if(caseContactEmailSet.size() > 0 ){
            matchingContactList = [SELECT id, Email,FirstName,LastName,AccountId,Phone,LastModifiedDate FROM Contact WHERE Email IN : caseContactEmailSet AND AccountId != NULL ORDER BY LastModifiedDate ASC]; 
        }
        if(caseContactPhoneSet.size() > 0){
            tempContactFirstList = [SELECT id, Email,FirstName,LastName,AccountId,Phone,LastModifiedDate FROM Contact WHERE Phone IN : caseContactPhoneSet AND AccountId != NULL ORDER BY LastModifiedDate ASC];
        }
        if(caseContactNameSet.size() > 0){
            tempContactSecondList = [SELECT id, Email,Name,FirstName,LastName,AccountId,Phone,LastModifiedDate FROM Contact WHERE Name IN : caseContactNameSet AND AccountId != NULL ORDER BY LastModifiedDate ASC];
        } 
        matchingContactList.addAll(tempContactFirstList) ;
        matchingContactList.addALL(tempContactSecondList);
        // Remove duplicates if in List
        Set<Contact> myset = new Set<Contact>();
        List<Contact> resultList = new List<Contact>();
        myset.addAll(matchingContactList);
        resultList.addAll(myset);
        if(resultList != null && resultList.size() > 0){
            for(Contact con : resultList){
                mapContacts.put(con.Id, con);
                lstWrapper.add(new ContactWrapper(con));
            }
            lstWrapper.sort();
            List<Contact> conList = new List<Contact>();
            for(ContactWrapper cw : lstWrapper){
                conList.add(mapContacts.get(cw.cont.Id));
            }
            return conList;
            /*List<Contact> conList = sortContactByLastModifiedBy(resultList);
            return resultList;*/
        }else{
            return null;
        }
    }  
    
    public class ContactWrapper implements Comparable {
        public Contact cont;
        // Constructor
        public ContactWrapper(Contact con) {
            cont = con;
        }
        // Compare Contacts based on the Contact lastmodified.
        public Integer compareTo(Object compareTo) {
            // Cast argument to ContactWrapper
            ContactWrapper compareToCon = (ContactWrapper)compareTo;
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if (cont.LastModifiedDate > compareToCon.cont.LastModifiedDate) {
                // Set return value to a positive value.
                returnValue = 1;
            } else if (cont.LastModifiedDate < compareToCon.cont.LastModifiedDate) {
                // Set return value to a negative value.
                returnValue = -1;
            }
            return returnValue;       
        }
    }  
    /****************************************************************************************
     * @Description - Method to Sort Contact List based on LastModified Date                * 
     * @params List<Case>										                            *                                                  
     * @return List<Contact>                                                                *
     ***************************************************************************************/ 
    public static List<Contact> sortContactByLastModifiedBy(List<Contact> contactList){
    	Contact tempContact;
		for (Integer i = 0; i < contactList.size(); i++){
	       for(Integer j = 1; j < (contactList.size()-i); j++){
               if(contactList[j-1].LastModifiedDate > contactList[j].LastModifiedDate){
                   tempContact = contactList [j-1];
                   contactList [j-1]= contactList [j];
                   contactList [j] = tempContact;
               }
	       }
		}
		return contactList;
    }                  
}