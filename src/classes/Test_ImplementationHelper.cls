/**************************************************************************************************
* Project Name..........: RingCentral - Self Serve Scheduling                                     *
* File..................: Test_ImplementationHelper.class                                         *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 18 September 2014                                                       *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....:                                                                         * 
* Description...........: Test class for ImplementationHelper.                                    *
**************************************************************************************************/
@isTest
private class Test_ImplementationHelper {
	
	public static List<Account> accountList = new List<Account>();
	public static List<Implementation__c> implementationList = new List<Implementation__c>(); 
	public static List<schedulerConfiguration__c> brandList = new List<schedulerConfiguration__c>(); 
	public static List<Contact> contactList = new List<Contact>();
	public static List<User> userList = new List<User>();
	
	/**********************************************************************************************
    * @Description : Method to setup test records.                                                *
    * @Params      : void                                                                         *
    * @Return      : void                                                                         *
    **********************************************************************************************/
	private static void setupRecords(){
		Test_Utils testUtilsObject = new Test_Utils();
    	
    	// Creating test user. 
		userList = testUtilsObject.createUserRecord(new List<User>{new User()});
		system.debug('#### User List - '+userList);
		// Creating RCSF_Sync__c custom setting records.   
		RCSF_Sync__c rcsfsyncObject = new RCSF_Sync__c(); 
		rcsfsyncObject.Name = 'RCSF Sync';
		rcsfsyncObject.Active__c = true;
		rcsfsyncObject.Email__c = 'rcsfsync@ringcentral.com';
		rcsfsyncObject.Id__c = userList[0].Id;
		rcsfsyncObject.Is_Primary__c = true;
		rcsfsyncObject.Last_Name__c = 'Sync';
		insert rcsfsyncObject;
    	// Creating Account Records.
		accountList = testUtilsObject.createAccountRecord(new List<Account>{new Account()});
		if(accountList != null && accountList.size() > 0){
	   		accountList[0].OID__c = 'OID1';
	   		update accountList[0];
		}	
		// Creating Contact Records.
		contactList = testUtilsObject.createContactRecord(new List<Contact>{new Contact(AccountId = accountList[0].Id)});
		// Creating Implementation Records.
		implementationList = testUtilsObject.createImplementationRecords(new List<Implementation__c>
		                     {new Implementation__c(Implementation_Status_2__c = 'Needed', Account__c = accountList[0].Id, Contact__c = contactList[0].Id)});
		
		// Creating Brand Records.
		brandList = testUtilsObject.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{new schedulerConfiguration__c()});
	}
	
	/**********************************************************************************************
    * @Description : Test method for MarkAsPremiumSupportOIDs method.                             *
    * @Params      : void                                                                         *
    * @Return      : void                                                                         *
    **********************************************************************************************/
    static testMethod void TestMarkAsPremiumSupportOIDs() {
   		
   		setupRecords();	
   		Offer_ID__c offData = new Offer_ID__c();
   		offData.OID__c = 'OID1';
   		offData.isPremiumSupport__c = true;
   		insert offData;
   		
   		ImplementationHelper.markAsPremiumSupportOIDs(implementationList);//
    }

	/**********************************************************************************************
    * @Description : Test method for AssignSalesAgent method.                                     *
    * @Params      : void                                                                         *
    * @Return      : void                                                                         *
    **********************************************************************************************/    
    static testMethod void TestAssignSalesAgent() {
    	setupRecords();
    	ImplementationHelper.assignSalesAgent(implementationList);	
    }
    
	/**********************************************************************************************
    * @Description : Test method for CreateDummyEvent method.                                     *
    * @Params      : void                                                                         *
    * @Return      : void                                                                         *
    **********************************************************************************************/
    static testMethod void TestCreateDummyEvent(){
    	setupRecords();
    	ImplementationHelper.createDummyEvent(implementationList);	
    }
}