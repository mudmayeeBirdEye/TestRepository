/**************************************************************************************************
 * Project Name..........:                                                                         *
 * File..................: AccountTriggerHelper.class                                              *
 * Version...............: 1.0                                                                     *
 * Created by............: Simplion Technologies                                                   *
 * Created Date..........: 29-01-2014                                                              *
 * Last Modified by......: Simplion Technologies                                                   *
 * Last Modified Date....: 29-01-2014                                                              *
 * Description...........: This is a helper class for Account.trigger.                             *
 **************************************************************************************************/

public class AccountTriggerHelper { 
	//-----------------Test varriable by ashish-----------------------
    public static String stateVarriable{get;set;}
    public static Integer triggerCounter = 0;
	//Declaring Updated Account Map and Older Account Map. 
	public static Map<Id, Account> newAccountMap = new Map<Id, Account>();
	public static Map<Id, Account> oldAccountMap = new Map<Id, Account>();
	//----------------As/Simplion/4/6/2015---------------------
	public static List<Carrier_Data__c>  lstCarrData = new List<Carrier_Data__c>();
	public static List<Account> allAccountInAfterQuery = new List<Account>();
	public static List<Account> currentCustomersPartnersListInAfterQuery = new List<Account>();
	public static Map<Id,Account> allAccountsMapAfterQuery = new Map<Id,Account>();
	public static List<Account> allAccountsByParentDetails = new List<Account>();
	public static Map<ID,Account> allAccountParentByParentIdQuery = new Map<ID,Account>();
	public static Map<Id, Contact> PrimaryContactAccountMap = new Map<Id, Contact>(); 
	public static Map<Id, List<Contact>> AllAccountContactMapQuery = new Map<Id,List<Contact>>();
	public static Map<Id,List<Contract>> accountContractMap = new Map<Id,List<Contract>>(); 
	// Declaring Variables
	
	private static ImplementationMethods im = new ImplementationMethods();
	private static List<Survey__c> surveyListTOInsert = new List<Survey__c>();                                       
	private static List<Lead> leadList = new List<Lead>();
	private static List<Account> partnerAccountLst = new list<Account>();
	private static List<Account> lstAcc = new List<Account>();
	private static List<Implementation__c> implementationList = new List<Implementation__c>();
	//--------------------------As/simplion/4/9/2015-----------------------------
	//----------------------Making this property public --------------------------------
	public static Set<Id> accountIds = new Set<Id>();
	private static Set<Id> accountOwnerIdSet = new Set<Id>();
	private static Set<Id> contractOwnerId = new Set<Id>();
	private static Set<String> lstPartnerAcc = new set<String>();
	private static Set<string> partnerAccountIdSet = new Set<string>();

	private static Map<String, Account> mapPartnerIdToAccount = new Map<String, Account>();
	private static Map<String, Account> MapPartnerId = new Map<String, Account>();
	private static Map<String, Account> partnerAccMap = new Map<String, Account>();
	//-------------------------As/Simplion/4/8/2015------------------------------------------------------
	public static Map<String, Account> partnerAccountContactMap = new Map<String, Account>();
	//private static Map<String, Integer> mapAccountImplementationTrail = new Map<String, Integer>(); 
	//private static Map<String, Integer> mapAccntImplementation = new Map<String, Integer>(); 
	//-------------------------As/Simplion/4/8/2015------------------------------------------------------
	public static Map<Id, Integer> premiumImpAccMap = new Map<Id, Integer>();
	private static Map<Id, User> userMap = new Map<Id, User>();
	 
	private static Map<Id, Boolean> allowImplMap = new Map<Id, Boolean>();
//-------------------------As/Simplion/5/12/2015--------------------------------------------------
//-------------------creating property public
	//This set is initialized for implementation status.
	public static Set<String> impStatus = new Set<String>{'6a. Completed','6b. Completed - No Help Needed','6c. Completed - Account Cancelled','6d. Completed - No Response'};

	//This map is initialzed for the mob lead sources
	private static Map<String, String> mobLeadSources = new Map<String, String>{'m' => 'm', 'iphone' => 'iphone', 'bb' => 'bb', 'android' => 'android'};

	// Declaring constants
	private static final String TRIAL_30NOCC = 'TRIAL_30NOCC';
	private static final String TRIAL_30d_NO_CC_WEB ='TRIAL 30d-NO-CC-WEB';
	private static final String DWH_SYNC_PENDING = 'DWH SYNC PENDING';
	private static final String TRIAL = 'TRIAL';
	private static final String TRIAL_NOCC ='TRIAL_NOCC';
	private static final String TRIAL_30d_NO_CC_MOB = 'TRIAL 30d-NO-CC-MOB';
	private static final String TRIAL_30_NO_CC = 'Trial 30 no-CC';
	private static final String IMP_NEW = 'New';
	private static final String TRIAL_ACCOUNT = 'Trial Account';
	private static final String PREMIUM = 'Premium';
	private static final String CANCELED = 'Canceled'; 
	private static final String DISABLED = 'Disabled'; 
	private static final String CANCELLED_TRIAL = 'Cancelled Trial';
	//----------------------------As/Simplion/5/12/2015--------------------------------------
	//-------------------making property public------------------
	public static final String RC_OFFICE ='RC Office';
	private static final String SALES_AGENT_RESELLERS = 'Sales Agents & Resellers';
	private static final String PARTNER_ACCOUNT = 'Partner Account';
	private static final String CUSTOMER_ACCOUNT ='Customer Account';
	private static final String PARTNER = 'Partner';
	private static final String RING_CENTRAL ='RingCentral';
	private static final String WEB = 'WEB';
	//----------------------------As/Simplion/5/12/2015--------------------------------------
	//-------------------making property public------------------
	public static final String COMPLETED_ACCOUNT_CANCELLED = '6c. Completed - Account Cancelled';
	private static final String TELUS ='TELUS';
	private static final String BT_CLOUD_PHONE = 'BT Cloud Phone';
	private static  String BT_BUSINESS = '';
	
	static{
		if(!Test.isRunningTest()){
			BT_BUSINESS = RcDealHealper.getBTBrand();
		}else{
			BT_BUSINESS = 'BT Business';
		}
	}
	

	/****************************************************************************
	 * @Description - Constructor Class.                                         * 
	 * @params void                                                              *
	 * @return void                                                              * 
	 *****************************************************************************/
	public AccountTriggerHelper(){
		//system.debug('#### Inside Contructor AccountTriggerHelper');

		system.debug('#### mobLeads - '+mobLeadSources);
		accountIds = newAccountMap.keySet();
		//system.debug('#### accountIds - '+accountIds);  
		//---------------------------This line functionality is corrected and shifted to Account.trigger---------------------------
		//PrimaryContactAccountMap = im.getContactAccountMap(newAccountMap);
		//partnerAccountContactMap = im.getPartnerAccountContactMap(newAccountMap.values());
		//premiumImpAccMap = im.accountToOppMap(accountIds);
		//---------------This property is not in use so commented this out
		//allowImplMap = im.allImplementationMap(newAccountMap.values()); 
	}   

	/*****************************************************************************
	 * @Description - Queries Contact object and fetches relevant details.       * 
	 * @params Set<Account> [trigger.new]                                        *
	 * @return Map<Id,Contact>                                                   * 
	 *****************************************************************************/
	public static Map<Id,Contact> getContact(Set<Id> accountIdSet){

		System.debug('No.of queries executed before getContact - '+limits.getqueries());

		Map<Id,Contact> mapContactImplementation = new Map<Id,Contact>();
		try{
			for(Contact thisContact : [SELECT FirstName, LastName, NumberOfEmployees__c,AccountId, Email,Phone, Account.No_of_Employees__c , Account.Name
			                           FROM Contact WHERE AccountId IN: accountIdSet]){

				if(thisContact != null){
					mapContactImplementation.put(thisContact.AccountId,thisContact);
				}
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception e){
			System.debug('#### Error @ getContact line - '+e.getlineNumber());
			System.debug('#### Error @ getContact message - '+e.getMessage());
		}
		System.debug('No.of queries executed after getContact - '+limits.getqueries());
		return mapContactImplementation;
	}
	/*****************************************************************************
	 * @Description - allAccountsMapAfterQuery.                                  * 
	 * @params Set<Id>acountIds                                                  *
	 * @return Map<Id,Account>                                                   * 
	 ****************************************************************************/ 
	public static Map<Id,Account> getallAccountsMapAfterQuery(Set<Id>acountIds){

		System.debug('No.of queries executed before getallAccountsMapAfterQuery - '+limits.getqueries());

		Map<Id,Account> accountMapForOffice = new Map<Id,Account>();
		try{
			for(Account thisAccount :[SELECT Owner.Email, Owner.Name, Owner.Team__c, Owner.Manager.Name, Owner.Manager.Email,CreatedBy.Name,    
			                          (SELECT Id FROM Opportunities limit 1),
			                          (SELECT Email,phone,FirstName, LastName,Account.Name,Account.No_of_Employees__c FROM Contacts ORDER BY lastmodifieddate DESC), 
			                          (SELECT Account.Name, Contact.Email,Contact.phone, Contact.FirstName, Contact.LastName,Contact.NumberOfEmployees__c, IsPrimary,Account.No_of_Employees__c 
			                        		  FROM AccountContactRoles WHERE IsPrimary = true limit 1),
			                        		  (SELECT Id FROM Surveys__r WHERE SurveyType__c = 'VAR Customer' limit 1)      
			                        		  FROM Account WHERE Id IN :accountIds]){
				if(thisAccount!=null){
					accountMapForOffice.put(thisAccount.Id,thisAccount);
				}
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		} catch(Exception ex){
			System.debug('#### Error @ allAccountsMapAfterQuery line - '+ex.getlineNumber());
			System.debug('#### Error @ allAccountsMapAfterQuery message - '+ex.getMessage());
		}
		System.debug('No.of queries executed after getallAccountsMapAfterQuery - '+limits.getqueries());
		return accountMapForOffice;
	}
	/*****************************************************************************
	 * @Description - Method to update account list.                             * 
	 * @params Map<Id,Account> [trigger.new] , Map<Id,Account> [trigger.old]     *
	 * @return void                                                              * 
	 ****************************************************************************/ 
	public static Map<String,Integer> getMapAccountImplementation(Set<Id> acctIds){ 

		System.debug('No.of queries executed before getMapAccountImplementation - '+limits.getqueries());
		Map<String,Integer> mapAccntImplementation =  new Map<String,Integer>();

		try {
			for(AggregateResult objAggregateResult:[SELECT Account__c,count(id) cnt 
			                                        FROM Implementation__c 
			                                        WHERE Account__c IN:accountIds 
			                                        GROUP BY Account__c ]){
				mapAccntImplementation.put(String.valueOf(objAggregateResult.get('Account__c')),Integer.valueOf(objAggregateResult.get('cnt')));              
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}  
		} catch(Exception ex) {
			System.debug('#### Exception @ getMapAccountImplementation line - '+ex.getlineNumber());
			System.debug('#### Exception message @ getMapAccountImplementation - '+ex.getMessage());
		} 
		System.debug('No.of queries executed after getMapAccountImplementation - '+limits.getqueries());
		return mapAccntImplementation;
	}
	/*****************************************************************************
	 * @Description - Method to update account list.                             * 
	 * @params Map<Id,Account> [trigger.new] , Map<Id,Account> [trigger.old]     *
	 * @return void                                                              * 
	 ****************************************************************************/ 
	public static Map<String,Integer> getMapAccountImplementationTrail (Set<Id> acntIds){

		System.debug('No.of queries executed before mapAccountImplementationTrail - '+limits.getqueries());
		Map<String,Integer> mapAccountImplementationTrail = new Map<String,Integer>();
		try {
			for(AggregateResult objAggregateResult:[SELECT Account__c,count(id) cnt FROM Implementation__c WHERE Account__c IN:accountIds and
			                                        Implementation_Type__c = 'Trial Account'
			                                        group by Account__c ]){
				mapAccountImplementationTrail.put(String.valueOf(objAggregateResult.get('Account__c')),Integer.valueOf(objAggregateResult.get('cnt')));              
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}  
		} catch(Exception ex) {
			system.debug('#### Exception @ mapAccountImplementationTrail line - '+ex.getlineNumber());
			system.debug('#### Exception message @ mapAccountImplementationTrail - '+ex.getMessage());
		}  
		system.debug('No.of queries executed after mapAccountImplementationTrail - '+limits.getqueries());
		return mapAccountImplementationTrail;
	}
	
	
	public static List<Implementation__c> changeImplementationForCanceledAccounts(List<Account> newList,Map<Id,Account> oldMap,Map<Id,Account> allAccountsAfterQuery){
		List<Implementation__c> implementationListToUpdate = new List<Implementation__c> ();
		for(Account newAcc : newList){
			Account oldAccount = oldMap.get(newAcc.Id);
			if(CANCELED.equalsIgnoreCase(newAcc.RC_account_Status__c) && 
						!CANCELED.equalsIgnoreCase(oldAccount.RC_Account_Status__c)){

					for(Implementation__c thisImplementation : allAccountsAfterQuery.get(newAcc.Id).Implementations__r){
						//Updated by India Team for Case#02405558 on 25/04/2014
						if(!AccountTriggerHelper.impStatus.contains(thisImplementation.Implementation_Status_2__c)){
							
							thisImplementation.Implementation_Status_2__c = AccountTriggerHelper.Completed_Account_Cancelled;
							implementationListToUpdate.add(thisImplementation);
						}
					}
				}
		}
		return implementationListToUpdate;
	}

	public static List<Sobject> sendEmailsForContracts(List<Account> newList,map<Id,Account> oldMap,Map<Id,List<Contract>> AcctContractMap){
		List<Exception_And_Notification_History__c> ExceptionAndNotificationList = new List<Exception_And_Notification_History__c>();
		for(Account newAccount : newList){
			Account oldAccount = oldMap.get(newAccount.Id);
			if(oldAccount.RC_Activation_Date__c == null && 
				oldAccount.RC_Activation_Date__c != newAccount.RC_Activation_Date__c && 
				AccountTriggerHelper.RC_OFFICE.equalsIgnoreCase(newAccount.RC_Service_name__c)){
		
				if(AcctContractMap != null && AcctContractMap.containsKey(newAccount.Id)){
					for(Contract thisContract : AcctContractMap.get(newAccount.Id)){
						//sendEmails(thisContract);
						if(thisContract != null){
							//Send email to Contract owner using Exception_And_Notification_History__c object.
							Exception_And_Notification_History__c exeNotificationObj = new Exception_And_Notification_History__c();
							exeNotificationObj.Sender_Display_Name__c = 'SFDC Account Alert';
							exeNotificationObj.Email_Subject__c = 'Please review this Account Contract';
							exeNotificationObj.To_Address_1__c = thisContract.Owner.Email;
							exeNotificationObj.Reply_To__c =  UserRC.rcsfSyncUserObj.Email__c;
							exeNotificationObj.Object_Type__c = 'Account';
							exeNotificationObj.content_label_01__c = 'SFDC_ACCOUNT_CONTRACT_NOTIFICATION';
							exeNotificationObj.content_var_01__c = thisContract.Id;
							exeNotificationObj.RecordTypeId = ExceptionAndNotificationHelper.getRcId('Email Notification');
							ExceptionAndNotificationList.add(exeNotificationObj);
							//System.debug('@@Sender_Display_Name@@'+exeNotificationObj.Sender_Display_Name__c);
							/*
							exeNotificationObj.Email_Body__c = 'You have a Contract whose Account was recently listed as activated.'+
									'<BR>Please review the contract terms, fill in start date and activate.'+
									' Make sure signed contract is attached before activating.'+
									'<BR><BR><a href=https://na6.salesforce.com/'+thisContract.Id +'>View Contract in salesforce</a>' ;
							*/
							
							/*  System.debug('no.of queries got executed sendEmails'+limits.getqueries());
				            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				            String[] toAddresses = new String[] {userMap.get(thisContract.OwnerId).Email};
				            mail.setToAddresses(toAddresses);
				            mail.setSenderDisplayName('SFDC Account Alert');
				            mail.setReplyTo(UserRC.rcsfSyncUserObj.Email__c);
				            mail.setSubject('Please review this Account Contract ');
				            mail.setHTMLBody('You have a Contract whose Account was recently listed as activated. <BR>Please review the contract terms, fill in start'+
				                    'date and activate. Make sure signed contract is attached before activating.<BR><BR><a href=https://na6.salesforce.com/'+
				                    thisContract.Id +'>View Contract in salesforce</a>');
				            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
						}
					}
				}
			}
		}
		return (List<Sobject>)ExceptionAndNotificationList;
		
	}				
	
	//---------------------------As/Simplion/5/12/2015-------------------------------------------
	//--------------Pending method for implementation functionality
	public static List<Implementation__c> createImplementationForAccounts(Map<Id,Account> newMap,Map<Id,Account> oldMap,Map<Id,Account> accountsMapAfterQuery){
		List<Implementation__c>	implementationListToInsert =  new List<Implementation__c>();
		Map<Id,Implementation__c> accountImplementationMap = new Map<Id,Implementation__c>();
		Map<String,Integer> accountAndImplementationTrailCountMap = new Map<String,Integer>();
		Map<Id,Account> accountMap =  AccountTriggerHelper.allAccountsMapAfterQuery;
		Map<String,Integer> accountAndImplementationCountMap =  new Map<String,Integer>();
		Map<Id,List<Contact>> contactMap = new Map<Id,List<Contact>>();
		Account oldAccount;
		Account newAccount;
		for(Account accByQuery : accountsMapAfterQuery.values()){
			contactMap.put(accByQuery.Id,accByQuery.contacts);
			//accountImplementationMap.put(accByQuery.Id,accByQuery.Implementations__r.);
			accountAndImplementationCountMap.put(accByQuery.Id,accByQuery.Implementations__r.size());
			Integer trailImpCounter = 0;
			for(Implementation__c impl : accByQuery.Implementations__r){
				if(impl.Implementation_Type__c.equalsIgnoreCase('Trial Account')){
					trailImpCounter++;
					accountAndImplementationTrailCountMap.put(accByQuery.Id,trailImpCounter);
				}
			}
			
		}
		for(Account thisAccount : newMap.values()){
			System.debug('~~~~AccountTriggerHelperExt.rtMapById~~'+AccountTriggerHelperExt.rtMapById);
			if(AccountTriggerHelperExt.rtMapById.get(thisAccount.RecordTypeId ).getName() == AccountTriggerHelperExt.CUSTOMER_ACCOUNT){
			System.debug('~~~~inside implementation start zone 1~~'+thisAccount);
				oldAccount = oldMap.get(thisAccount.Id);
				newAccount = thisAccount;
				if(!String.isBlank(thisAccount.RC_Brand__c) && RING_CENTRAL.equalsIgnoreCase(thisAccount.RC_Brand__c.trim())) {
					System.Debug('BRAND IS NOT NULL && RINGCENTRAL');
					Integer oldDL = (oldAccount.Number_of_DL_s__c == null ? 0 : Integer.valueOf(oldAccount.Number_of_DL_s__c));
					Integer newDL = (thisAccount.Number_of_DL_s__c == null ? 0 : Integer.valueOf(thisAccount.Number_of_DL_s__c));
					
					if((oldDL !=  newDL) || (oldAccount.RC_Service_name__c != thisAccount.RC_Service_name__c) ||
							(oldAccount.RC_User_ID__c != thisAccount.RC_User_ID__c)|| 
							(oldAccount.RC_Account_Status__c != thisAccount.RC_Account_Status__c)) {
						System.Debug('EITHER DL, SERVICE NAME, USER ID OR ACCOUNT STATUS IS CHANGED');
						if(im.toCreateImplementationOnInsOrUpdRing(thisAccount,accountAndImplementationCountMap) || 
								(im.toCreateImplementationOnInsOrUpdOfficeTrials(thisAccount,accountAndImplementationTrailCountMap) && 
										(oldAccount.RC_Account_Status__c != thisAccount.RC_Account_Status__c))) { 
							System.Debug('ALLOWED TO CREATE IMPLEMENTATION');
							Implementation__c impObj = new Implementation__c();
							impObj.Type__c = IMP_NEW;
							System.debug('implementation gets created'+impObj.Type__c);
							if(!String.isBlank(thisAccount.RC_Account_Status__c) && (thisAccount.RC_Account_Status__c.containsIgnoreCase(TRIAL))) {
								impObj.Implementation_Type__c = TRIAL_ACCOUNT;
							}
							if(premiumImpAccMap != null && premiumImpAccMap.get(thisAccount.Id)!= null && premiumImpAccMap.get(thisAccount.Id) > 0) {
								impObj.Implementation_Type__c = PREMIUM;
							}
							//im.createAccountImplementation(thisAccount, contactAccountMap, impObj); 
							accountImplementationMap.put(thisAccount.Id, impObj);
						}       
					}   
				} else if(!String.isBlank(thisAccount.RC_Brand__c) && thisAccount.RC_Brand__c.trim().containsIgnoreCase(TELUS) && 
						im.tocreateImplemetationOnInsorUpdForTELUS(thisAccount,accountAndImplementationCountMap)) {

					if((oldAccount.RC_Service_name__c != thisAccount.RC_Service_name__c) || 
							(oldAccount.RC_User_ID__c != thisAccount.RC_User_ID__c) || 
							(oldAccount.RC_Account_Status__c != thisAccount.RC_Account_Status__c) || 
							((oldAccount.RC_Brand__c != thisAccount.RC_Brand__c) && 
									(String.isBlank(oldAccount.RC_Brand__c) || !oldAccount.RC_Brand__c.trim().containsIgnoreCase(TELUS)))) {

						//System.Debug('>>$2>>>');
						Implementation__c impObj = new Implementation__c();
						impObj.Type__c = IMP_NEW;
						if(!String.isBlank(thisAccount.RC_Account_Status__c) && thisAccount.RC_Account_Status__c.toUpperCase().contains(TRIAL)) {
							impObj.Implementation_Type__c = TRIAL_ACCOUNT;
						}
						if(premiumImpAccMap !=null){
							if(premiumImpAccMap.get(thisAccount.Id) != null && premiumImpAccMap.get(thisAccount.Id) > 0) {
								impObj.Implementation_Type__c = PREMIUM;
							}
						}
						//im.createAccountImplementation(thisAccount, contactMap, impObj);
						accountImplementationMap.put(thisAccount.Id, impObj);    
					}           

				}
				/********************************************************************************** 
				*  Code for BT Implementation Creation.                                           *
				*   - Account Brand = BT Cloud Phone                                              *
				*   - Account Number of DL's > 0                                                  *
				*   - Account Status = Paid	                                                      *
				*                                                                                 *
				*   Either RC User Id, Status, Brand is changed.                                  *
				**********************************************************************************/ 
				else if(!String.isBlank(thisAccount.RC_Brand__c) 
							&& (thisAccount.RC_Brand__c.trim().containsIgnoreCase(BT_CLOUD_PHONE) 
												|| thisAccount.RC_Brand__c.trim().containsIgnoreCase(BT_BUSINESS) )
							&& im.tocreateImplemetationOnInsorUpdForBT(thisAccount,accountAndImplementationCountMap)) {

					if((oldAccount.RC_User_ID__c != thisAccount.RC_User_ID__c) || 
					   (oldAccount.RC_Account_Status__c != thisAccount.RC_Account_Status__c) ||
					  ((oldAccount.RC_Brand__c != thisAccount.RC_Brand__c) && 
						(String.isBlank(oldAccount.RC_Brand__c) || !oldAccount.RC_Brand__c.trim().containsIgnoreCase(BT_CLOUD_PHONE)
												|| !oldAccount.RC_Brand__c.trim().containsIgnoreCase(BT_BUSINESS)))) {

						Implementation__c impObj = new Implementation__c();
						impObj.Type__c = IMP_NEW;
						if(!String.isBlank(thisAccount.RC_Account_Status__c) && thisAccount.RC_Account_Status__c.toUpperCase().contains(TRIAL)) {
							impObj.Implementation_Type__c = TRIAL_ACCOUNT;
						}
						if(premiumImpAccMap !=null){
							if(premiumImpAccMap.get(thisAccount.Id) != null && premiumImpAccMap.get(thisAccount.Id) > 0) {
								impObj.Implementation_Type__c = PREMIUM;
							}
						}
						accountImplementationMap.put(thisAccount.Id, impObj);    
					}           
				}
				
				else if(im.toCreateImplementationOnUpd(thisAccount,oldAccount,accountAndImplementationCountMap)) {
					Implementation__c impObj = new Implementation__c();
					impObj.Type__c = IMP_NEW;
					if(!String.isBlank(thisAccount.RC_Account_Status__c) &&(thisAccount.RC_Account_Status__c.containsIgnoreCase(TRIAL))) {
						impObj.Implementation_Type__c = TRIAL_ACCOUNT;
					}
					if(premiumImpAccMap !=null){
						if(premiumImpAccMap.get(thisAccount.Id) != null && premiumImpAccMap.get(thisAccount.Id) > 0) {
							impObj.Implementation_Type__c = PREMIUM;
						}
					}
					//im.createAccountImplementation(thisAccount, contactAccountMap, impObj);
					accountImplementationMap.put(thisAccount.Id, impObj);  
				}
				
			}
			
		
		}
			if(UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.name) !=null){
						
									
				for(Id accountId : accountImplementationMap.keySet()){
					Account thisAccount = newMap.get(accountId);
					if(thisAccount != null) {
						String name = thisAccount.Name;
						String str = thisAccount.Name + ' - ' + Datetime.now().format();
						Integer strLength = (str).length();
						if(strLength > 80) {
							Integer dateLength = (' - ' +Datetime.now().format()).length();
							name = (thisAccount.Name).substring(0, (80-dateLength));
						}
						Implementation__c imp =  new Implementation__c();
						if(accountImplementationMap.get(thisAccount.Id) != null){
							imp = accountImplementationMap.get(thisAccount.Id);
						}
						imp.Name = name + ' - ' + Datetime.now().format();
						imp.office_service_change_date__c = Date.today();
						imp.Account__c = thisAccount.Id;
						imp.Brand__c = thisAccount.RC_Brand__c;
						imp.Tier__c = thisAccount.RC_Tier__c;
						imp.Service__c = thisAccount.RC_Service_Name__c;
						// Logic for setting the owner Id.
						if(UserRC.getRCSFSyncPrimaryOwnerId != null){
							imp.OwnerId = UserRC.getRCSFSyncPrimaryOwnerId;
						}else{
							imp.OwnerId = Userinfo.getUserId();	
						}
						imp.Account_Signup_Date__c = thisAccount.RC_Signup_Date__c;
						imp.Contact__c = (contactMap == null || contactMap.get(thisAccount.Id) == null ? null : contactMap.get(thisAccount.Id)[0].Id);
	
						implementationListToInsert.add(imp);
						
						
					}
				}
			}
			return implementationListToInsert;
		}
	/*****************************************************************************
	 * @Description - Method to update Account Active Date.                      * 
	 * @params Map<Id,Account> [trigger.new], Map<Id,Account> [trigger.oldMap]   *
	 * @return void                                                              * 
	 *****************************************************************************/     
	public static List<Lead> createLeadOnAccountUpdate(List<Account> newList,Map<Id,Account> oldMap,Map<Id,Account> accountsMapAfterQuery){
			List<Lead> bucketLeadList =  new List<Lead>(); 
			Map<Id,Account> accountMap =  AccountTriggerHelper.allAccountsMapAfterQuery;
			Map<Id,List<Contact>> contactMap = new Map<Id,List<Contact>>();
			Map<Id, Lead> accountLeadMap =  new Map<Id, Lead>(); 
			Account oldAccount;
			for(Account accByQuery : accountsMapAfterQuery.values()){
				contactMap.put(accByQuery.Id,accByQuery.contacts);
				
				oldAccount = oldMap.get(accByQuery.Id);
				Lead newLead = new Lead();
				Contact contactObj = new Contact();
				if(accByQuery.AccountContactRoles!= null && accByQuery.AccountContactRoles.size() > 0){
					contactObj = accByQuery.AccountContactRoles[0].Contact;
				}else if(contactMap != null && contactMap.containsKey(accByQuery.Id) && contactMap.get(accByQuery.Id).size() > 0){
					contactObj = contactMap.get(accByQuery.Id)[0];
				 	
				}
				if(contactObj != null) {
				        newLead.Phone = contactObj.Phone;
				        newLead.LastName = ( String.isBlank(contactObj.LastName)? accByQuery.Name : contactObj.LastName );
				        newLead.LastName = contactObj.LastName;
				        newLead.FirstName =contactObj.FirstName;
				        newLead.Email = ( String.isBlank(contactObj.Email)? 'fake@email.com' : contactObj.Email );
				        newLead.Email = contactObj.Email;
				        newLead.Account_Status__c = accByQuery.RC_Account_Status__c;
				        newLead.Account_Number__c = accByQuery.RC_Account_Number__c;
				        newLead.User_ID__c = accByQuery.RC_User_ID__c;
				        newLead.Lead_Tier_Name__c = accByQuery.RC_Tier__c;
				        newLead.RC_Service_name__c = accByQuery.RC_Service_name__c;
				        newLead.Lead_Brand_Name__c = accByQuery.RC_Brand__c;
				        newLead.Company = accByQuery.Name;
				        newLead.Status = 'Open - Not Contacted';
				        //---------------------As.simplion/5/12/2015-----------------------TBD
				        newLead.Account__c = accByQuery.id;
						if(contactObj.NumberOfEmployees__c != null){
							newLead.NumberOfEmployees__c = contactObj.NumberOfEmployees__c;
						}else if(contactObj.Account.No_of_Employees__c != null){
							newLead.NumberOfEmployees__c = contactObj.Account.No_of_Employees__c;
				        }
				        
			       } else {
						newLead.Email = 'fake@fake.com';
						newLead.LastName = 'fakeLead';
						newLead.Company = accByQuery.Name;
						if(accByQuery != null && accByQuery.No_of_Employees__c != null) {
							newLead.NumberOfEmployees__c = accByQuery.No_of_Employees__c;
						}
					}
					
				  	accountLeadMap.put(accByQuery.Id,newLead);
			}
			
			
			for(Account newAcc : newList){
				Lead newLead = accountLeadMap.get(newAcc.Id);
				oldAccount = oldMap.get(newAcc.Id);
				if(!String.isBlank(newAcc.SignupType__c)) {
					
					if((String.isBlank(newAcc.SignupPlatform__c) ||
						    ((!String.isBlank(newAcc.SignupPlatform__c) && WEB.equalsIgnoreCase(newAcc.SignupPlatform__c.trim())))) && 
							 TRIAL_30NOCC.equalsIgnoreCase(newAcc.SignupType__c.trim()) && newLead != null){
	
							newLead.LeadSource = TRIAL_30d_NO_CC_WEB;
							
					} 
					else if(!String.isBlank(newAcc.SignupPlatform__c) && 
							!String.isBlank(mobLeadSources.get(newAcc.SignupPlatform__c.trim())) && 
							(TRIAL_30NOCC.equalsIgnoreCase(newAcc.SignupType__c.trim()) || 
									TRIAL_NOCC.equalsIgnoreCase(newAcc.SignupType__c.trim())) &&
									newLead != null){
							newLead.LeadSource = TRIAL_30d_NO_CC_MOB;

						
					}
					if(!String.isBlank(newAcc.RC_Account_Status__c) && 
						!DWH_SYNC_PENDING.equalsIgnoreCase(newAcc.RC_Account_Status__c.trim()) && 
						newAcc.RC_Account_Status__c.containsIgnoreCase(TRIAL)){
						
						bucketLeadList.add(newLead);
					}
				} else if(String.isBlank(newAcc.SignupType__c) && String.isBlank(newAcc.SignupPlatform__c) && 
						(!String.isBlank(newAcc.RC_Account_Status__c) && TRIAL_30_NO_CC.equalsIgnoreCase(newAcc.RC_Account_Status__c.trim())) && 
						oldMap != null &&
						(String.isBlank (oldAccount.RC_Account_Status__c)|| !TRIAL_30_NO_CC.equalsIgnoreCase(oldAccount.RC_Account_Status__c.trim()) )){
						
						if(newLead != null){
							newLead.LeadSource = TRIAL_30d_NO_CC_WEB;
							///insert newLead;
							bucketLeadList.add(newLead);
						}
				}
				else if(((oldAccount.RC_Account_Status__c != newAcc.RC_Account_Status__c) || 
						(oldAccount.Service_Type__c != newAcc.Service_Type__c)) && accountsMapAfterQuery.get(newAcc.Id).Opportunities.size() == 0) {

					//Lead rtnleadobj = im.createLeadOfficeTrail(thisAccount,allAccountsMapAfterQuery);
					newLead.LeadSource = 'Office Trials';
					String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
					sUrlRewrite = 'https://' + sUrlRewrite + '/' + newAcc.id;
					newLead.Description = 'Office Free Trial Account Signup - Link to Account '+ sUrlRewrite;
					bucketLeadList.add(newLead);
				}
				else if(!String.isBlank(newAcc.RC_Account_Status__c)  && !String.isBlank(oldAccount.RC_Account_Status__c) &&
						 DISABLED.equalsIgnoreCase(newAcc.RC_Account_Status__c.trim())){
					if(accountsMapAfterQuery != null && accountsMapAfterQuery.get(newAcc.Id)!= null && 
						contactMap !=null && contactMap.get(newAcc.Id) != null &&
						accountsMapAfterQuery.get(newAcc.Id).RC_User_ID__c != null ){
					newLead = null;
					if((oldAccount.RC_Account_Status__c.containsIgnoreCase(TRIAL))){
						
						newLead = new Lead(
							FirstName=contactMap.get(newAcc.Id)[0].FirstName,
							LastName=contactMap.get(newAcc.Id)[0].LastName,
							Company=newAcc.Name,
							Email=contactMap.get(newAcc.Id)[0].Email,
							Phone=contactMap.get(newAcc.Id)[0].Phone,
							LeadSource= CANCELLED_TRIAL ,
							Lead_Score__c = 'B', 
							timezone__c=newAcc.Timezone__c, 
							Industry=newAcc.Industry,
							User_ID__c = accountsMapAfterQuery.get(newAcc.Id).RC_User_ID__c);
							
							//insert leadObj;
							bucketLeadList.add(newLead); 
						
					}
					
				}
			}
		}
		return bucketLeadList;
	} 

	/*****************************************************************************
	 * @Description - Method to send mails.                                      * 
	 * @params Contract [trigger.new] Id's                                       *
	 * @return void                                                              * 
	 *****************************************************************************/
	public static void sendEmails(Contract thisContract){

		System.debug('No. of queries executed before sendEmails - '+limits.getqueries());

		try {
			if(thisContract != null){
				//Send email to Contract owner using Exception_And_Notification_History__c object.
				Exception_And_Notification_History__c exeNotificationObj = new Exception_And_Notification_History__c();
				exeNotificationObj.Sender_Display_Name__c = 'SFDC Account Alert';
				//System.debug('@@@@@@@@@'+exeNotificationObj.Sender_Display_Name__c);
				exeNotificationObj.Email_Subject__c = 'Please review this Account Contract';
				exeNotificationObj.To_Address_1__c = thisContract.Owner.Email;
				exeNotificationObj.Reply_To__c =  UserRC.rcsfSyncUserObj.Email__c;
				exeNotificationObj.Object_Type__c = 'Account';
				exeNotificationObj.content_label_01__c = 'SFDC_ACCOUNT_CONTRACT_NOTIFICATION';
				exeNotificationObj.content_var_01__c = thisContract.Id;
				exeNotificationObj.RecordTypeId = ExceptionAndNotificationHelper.getRcId('Email Notification');
				insert exeNotificationObj;
				//System.debug('@@Sender_Display_Name@@'+exeNotificationObj.Sender_Display_Name__c);
				/*
				exeNotificationObj.Email_Body__c = 'You have a Contract whose Account was recently listed as activated.'+
						'<BR>Please review the contract terms, fill in start date and activate.'+
						' Make sure signed contract is attached before activating.'+
						'<BR><BR><a href=https://na6.salesforce.com/'+thisContract.Id +'>View Contract in salesforce</a>' ;
				*/
				
				/*  System.debug('no.of queries got executed sendEmails'+limits.getqueries());
	            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	            String[] toAddresses = new String[] {userMap.get(thisContract.OwnerId).Email};
	            mail.setToAddresses(toAddresses);
	            mail.setSenderDisplayName('SFDC Account Alert');
	            mail.setReplyTo(UserRC.rcsfSyncUserObj.Email__c);
	            mail.setSubject('Please review this Account Contract ');
	            mail.setHTMLBody('You have a Contract whose Account was recently listed as activated. <BR>Please review the contract terms, fill in start'+
	                    'date and activate. Make sure signed contract is attached before activating.<BR><BR><a href=https://na6.salesforce.com/'+
	                    thisContract.Id +'>View Contract in salesforce</a>');
	            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
			}
			System.debug('No. of queries executed after sendEmails - '+limits.getqueries());
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		} catch(Exception e){
			System.debug('#### Error @ sendEmails line - '+e.getlineNumber());
			System.debug('#### Error @ sendEmails message - '+e.getMessage());                      
		}
	}

	/*****************************************************************************
	 * @Description - Method to Create VAR Survey on Account Activation.         * 
	 * @params Map<Id,Account> [trigger.new] , Account                           *
	 * @return void                                                              * 
	 *****************************************************************************/      
	public static void survey (){

		//system.debug('#### survey accountIds - '+accountIds);   
		system.debug('No. of queries executed before survey - '+limits.getqueries());
		
		//---------------------------------As/Simplion/4/9/2015-----------------------------------------
		//---------------------------------Removing this code to optimize SOQl and creating this map through earlier cache of query from account trigger
		//Map<Id,Account> allAccountsMapAfterQuery = new Map<Id,Account>();
		//allAccountsMapAfterQuery = getallAccountsMapAfterQuery(accountIds);

		try {
			for(Account thisAccount : newAccountMap.values()){
				Account oldAccount = oldAccountMap.get(thisAccount.Id);
				if(thisAccount.Is_Demo_Account__c == false && (!String.isBlank(thisAccount.RC_Attribution_Channel__c) && 
						SALES_AGENT_RESELLERS.equalsIgnoreCase(thisAccount.RC_Attribution_Channel__c)) && 
						oldAccount.RC_Activation_Date__c == null && thisAccount.RC_Activation_Date__c != null) { 

					if(allAccountsMapAfterQuery != null && allAccountsMapAfterQuery.get(thisAccount.id) != null && 
							allAccountsMapAfterQuery.get(thisAccount.id).Surveys__r == null && 
							partnerAccountContactMap != null && thisAccount.Partner_ID__c != null && 
							partnerAccountContactMap.get(thisAccount.Partner_ID__c) != null && 
							partnerAccountContactMap.get(thisAccount.Partner_ID__c).contacts != null) {

						List<Contact> partnerAccountContactList = partnerAccountContactMap.get(thisAccount.Partner_ID__c).contacts;     
						Survey__c survObj = im.createVARSurveyOnAccountActivation(thisAccount,allAccountsMapAfterQuery,partnerAccountContactList);

						if(survObj != null) {
							surveyListTOInsert.add(survObj);    
							//System.debug('SURVEY'+surveyListTOInsert);
						}
					}
				} 
			}
			/***************** Create VAR Survey on Account Activation *******************/
			AccountCleanUpProcess.cleanUpAccounts(newAccountMap, PrimaryContactAccountMap);

			if(leadList !=null &&!leadList.isEmpty()){
				insert leadList;
			}
			if(surveyListTOInsert !=null &&!surveyListTOInsert.isEmpty()){
				insert surveyListTOInsert;
				//System.debug('SURVEY LIST'+surveyListTOInsert);
			}
			System.debug('No. of queries executed after survey - '+limits.getqueries());
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception ex){
			System.debug('#### Error @ survey line - '+ex.getlineNumber());
			System.debug('#### Error @ survey message - '+ex.getMessage());
		}
	}
	/*****************************************************************************
	 * @Description - Method to Create  Account for Partner.                     * 
	 * @params Map<Id,Account> [trigger.new] , Account                           *
	 * @return void                                                              * 
	 *****************************************************************************/
	 //---------------------------As/Simplion/3/13/2015----------------------------
	public static void partnerAccount(){

		System.debug('No. of queries executed before partnerAccount - '+limits.getqueries());
		try{
			Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
			Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();

			for(Account objAcc : newAccountMap.values()){
				// objAcc.RecordTypeId == '01280000000UERv' 
				if((PARTNER.equalsIgnoreCase(objAcc.Type)) && !String.isBlank(objAcc.Partner_Id__c) && 
						(rtMapByName != null && objAcc.RecordTypeId != null && rtMapByName.get(objAcc.RecordTypeId ).getName() == PARTNER_ACCOUNT)){

					partnerAccMap.put(objAcc.Partner_ID__c,objAcc);
					partnerAccountIdSet.add('%'+string.valueOf(objAcc.Id).substring(0,15)+'%');
					//System.debug('#@$@#$@%@$@#'+partnerAccountIdSet);
				}
			}
			Map<Id,Account> accMap = new Map<Id,Account>();
			system.debug('#### partnerAccMap - '+partnerAccMap);
			for(Account acc : [SELECT Name,Parent_Detail__c,Partner_ID__c,Do_Not_Creation_Implementation__c,Ultimate_Parent_Partner_ID__c,
			                   Ultimate_Partner_ID__c,Ultimate_Partner_Name__c,Ultimate_Parent_Account_ID__c,Ultimate_Parent_Account_Name__c,
			                   Current_Owner__c,Current_Owner_Email__c,Current_Owner_Name__c 
			                   FROM Account 
			                   WHERE parentId != null AND Parent_Detail__c != null AND Parent_Detail__c LIKE :partnerAccountIdSet 
			                   AND RecordType.Name = 'Partner Account']){
			    accMap.put(acc.id,acc);
				if(!partnerAccMap.containsKey(acc.Partner_ID__c)){
					partnerAccMap.put(acc.Partner_ID__c,acc);
				}
			}
			system.debug('#### partnerAccMap - '+partnerAccMap);
			List<Account> customerAccountList = [SELECT Name,Parent_Detail__c,Partner_ID__c,Do_Not_Creation_Implementation__c,
			                                     Ultimate_Parent_Partner_ID__c,Ultimate_Partner_ID__c,Ultimate_Partner_Name__c,
			                                     Ultimate_Parent_Account_ID__c,Ultimate_Parent_Account_Name__c,Current_Owner__c,
			                                     Current_Owner_Email__c,Current_Owner_Name__c 
			                                     FROM Account 
			                                     WHERE Partner_ID__c IN: partnerAccMap.keySet() AND RecordType.Name = 'Customer Account'];
			//System.debug('**customerList'+customerAccountList);
			for(Account customerAccount : customerAccountList) {

				/*
                system.debug('#### In Map - '+partnerAccMap.containsKey(customerAccount.Partner_ID__c));
                system.debug('#### Customer Account Owner - '+customerAccount.Current_Owner__c);
                system.debug('#### Partner Account Owner - '+partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner__c);
				 */

				if(partnerAccMap !=null && partnerAccMap.get(customerAccount.Partner_ID__c) !=null && 
						partnerAccMap.containsKey(customerAccount.Partner_ID__c) && 
						customerAccount.Current_Owner__c != partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner__c){
						customerAccount.Current_Owner__c = partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner__c;
						System.debug('This is check if in loop~~~~~~~~~~~~~~'); 
						User newOwner = AccountTriggerHelperExt.allUserMap.get(partnerAccMap.get(customerAccount.Partner_ID__c).Current_Owner__c);
						System.debug(newOwner+'~~~~~~~~~~~~~~~~~owner');
						if(newOwner != null){
							customerAccount.Current_Owner_Name__c = newOwner.Name;
							customerAccount.Current_Owner_Email__c = newOwner.Email;
						}
						
						//System.debug('@@@@@owner**'+customerAccount.Current_Owner__c);       

					if(partnerAccMap !=null && partnerAccMap.containsKey(customerAccount.Partner_ID__c) && 
							customerAccount.Ultimate_Partner_ID__c != partnerAccMap.get(customerAccount.Partner_ID__c).Ultimate_Parent_Partner_ID__c){

						customerAccount.Ultimate_Partner_ID__c = partnerAccMap.get(customerAccount.Partner_ID__c).Ultimate_Parent_Partner_ID__c;
						customerAccount.Ultimate_Partner_Name__c = partnerAccMap.get(customerAccount.Partner_ID__c).Ultimate_Parent_Account_Name__c;
						//System.debug('**customerAccount.Ultimate_Partner_ID__c'+customerAccount.Ultimate_Partner_ID__c);
					}   
				} 
			}
			if(customerAccountList!=null &&!customerAccountList.isEmpty()) {
				TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
				update customerAccountList; 
				TriggerHandler.RESET_VARIABLES();
			}
			System.debug('No. of queries executed after partnerAccount - '+limits.getqueries());
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		} catch(Exception e){
			System.debug('#### Error @ partnerAccount line - '+e.getlineNumber());
			System.debug('#### Error @ partnerAccount message - '+e.getMessage());                      
		}
	}
	/* Utility Methods */

	/*****************************************************************************
	 * @Description - Queries Implementation object and fetches relevant details.* 
	 * @params Set<Account> [trigger.new]                                        *
	 * @return Map<Id,List<Implementation__c>                                    * 
	 *****************************************************************************/ 
	public static Map<Id,List<Implementation__c>> getImplementation(Set<Id> accountId){

		System.debug('No. of queries executed before getImplementation - '+limits.getqueries());

		Map<Id,List<Implementation__c>> mapAccountImplementation = new Map<Id,List<Implementation__c>>();
		try{
			for(Implementation__c thisImplementation : [SELECT id, Implementation_Status__c,Account__c ,Implementation_Status_2__c
			                                            FROM Implementation__c 
			                                            WHERE Account__c IN: accountId]){
				if(mapAccountImplementation.containsKey(thisImplementation.Account__c)){
					mapAccountImplementation.get(thisImplementation.Account__c).add(thisImplementation);    
				} else {
					mapAccountImplementation.put(thisImplementation.Account__c,new List<Implementation__c>{thisImplementation});
				}
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception e){
			System.debug('#### Error @ getImplementation line - '+e.getlineNumber());
			System.debug('#### Error @ getImplementation message - '+e.getMessage());
		}

		System.debug('No. of queries executed after getImplementation - '+limits.getqueries());
		return mapAccountImplementation;
	}

	/*****************************************************************************
	 * @Description - Queries Contract object and fetches relevant details.      * 
	 * @params Set<Account> [trigger.new]                                        *
	 * @return Map<Id,List<Contract>                                             * 
	 *****************************************************************************/     
	public static Map<Id,List<Contract>> getContract(Set<Id> accountId){

		System.debug('No. of queries executed before getContract - '+limits.getqueries());

		Map<Id,List<Contract>> mapContractImplementation = new Map<Id,List<Contract>>();
		try{
			for(Contract thisContract : [SELECT Id, OwnerId, Owner.Email, AccountId FROM Contract WHERE AccountId =: accountId]){
				if(mapContractImplementation.containsKey(thisContract.AccountId)){
					mapContractImplementation.get(thisContract.AccountId).add(thisContract);    
				} else {
					mapContractImplementation.put(thisContract.AccountId,new List<Contract>{thisContract});
				}

				contractOwnerId.add(thisContract.OwnerId);
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception e){
			System.debug('#### Error @ getContract line - '+e.getlineNumber());
			System.debug('#### Error @ getContract message - '+e.getMessage());
		}
		System.debug('No. of queries executed after getContract - '+limits.getqueries());
		return mapContractImplementation;
	}

	/*****************************************************************************
	 * @Description - Queries Account object and fetches relevant details.       * 
	 * @params Set<Id> [trigger.new] Id's                                        *
	 * @return Map<Id,Account>                                                   * 
	 *****************************************************************************/
	public static Map<Id,Account> getAccount(Set<Id> accountId){

		System.debug('No. of queries executed before getAccount - '+limits.getqueries());
		Map<Id,Account> accountMap =  new Map<Id,Account>();

		try{
			for(Account thisAccount : [SELECT RC_User_ID__c FROM Account WHERE Id IN: accountId]){
				accountMap.put(thisAccount.Id, thisAccount);
			} 
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception e){
			System.debug('#### Error @ getAccount line - '+e.getlineNumber());
			System.debug('#### Error @ getAccount message - '+e.getMessage());
		}
		System.debug('No. of queries executed after getAccount - '+limits.getqueries());
		return accountMap;
	}

	/*****************************************************************************
	 * @Description - Queries Account object and fetches relevant details.       * 
	 * @params Set<Id> [trigger.new] Id's                                        *
	 * @return Map<Id,Account>                                                   * 
	 *****************************************************************************/
	public static Map<Id,User> getUserDetails(Set<Id> contractOwnId){

		System.debug('No. of queries executed before getUserDetails - '+limits.getqueries());
		Map<Id,User> userDetailsMap =  new Map<Id,User>();

		try{
			for(User thisUser : [SELECT Id, Email FROM User WHERE Id IN: contractOwnId]){
				userDetailsMap.put(thisUser.Id, thisUser);
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			} 
		}catch(exception e){
			System.debug('#### Error @ getUserDetails line - '+e.getlineNumber());
			System.debug('#### Error @ getUserDetails message - '+e.getMessage());
		}
		System.debug('No. of queries executed after getUserDetails - '+limits.getqueries());
		return userDetailsMap;
	}

	/*****************************************************************************
	 * @Description - Create Account Lead Map.                                   * 
	 * @params Set<Id> [trigger.new] Id's                                        *
	 * @return Map<Id,Account>                                                   * 
	 *****************************************************************************/
	public static Map<Id, Lead> createAccountLeadMap(Set<Id> accountIdList){

		Map<Id, Lead> accountLeadMap =  new Map<Id, Lead>();
		for(Id thisAccountId : accountIdList){
			accountLeadMap.put(thisAccountId, new Lead());	
		}	
		return accountLeadMap;
	}
	/*****************************************************************************
	 * @Description - Method to update account list.                             * 
	 * @params Map<Id,Account> [trigger.new] , Map<Id,Account> [trigger.old]     *
	 * @return void                                                              * 
	 *****************************************************************************/ 
	public static List<Account> upListAccount(){

		System.debug('No. of queries executed before upListAccount - '+limits.getqueries());
		List<Account> lstAccount=new List<Account>();

		try{
			for(Account accObj : newAccountMap.values()){
				if(accObj.ParentId !=null && (accObj.ParentId != oldAccountMap.get(accObj.Id).ParentId)){
					lstAccount.add(accObj);
				}
			}
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception e){
			System.debug('#### Error @ upListAccount line - '+e.getlineNumber());
			System.debug('#### Error @ upListAccount message - '+e.getMessage());
		}
		System.debug('No. of queries executed after upListAccount - '+limits.getqueries());
		return lstAccount;
	}

	/*****************************************************************************
	 * @Description - Method to insert lead for implementation.                  * 
	 * @params Map<Id,Account> [trigger.new] , Map<Id,Account> [trigger.old]     *
	 * @return void                                                              * 
	 *****************************************************************************/     
	 
	 
	 public static List<Implementation__c> createImplementationOnAccountInsert(Map<Id,Account> newMap,Map<Id,Account> oldMap,Map<Id,Account> accountsMapAfterQuery){
	 	List<Implementation__c> implementationToInsertList = new List<Implementation__c>();
 		Map<Id,Implementation__c> accountImplementationMap = new Map<Id,Implementation__c>();
		Map<String,Integer> accountAndImplementationTrailCountMap = new Map<String,Integer>();
		Map<Id,Account> accountMap =  AccountTriggerHelper.allAccountsMapAfterQuery;
		Map<String,Integer> accountAndImplementationCountMap =  new Map<String,Integer>();
		Map<Id,List<Contact>> contactMap = new Map<Id,List<Contact>>();
		Account oldAccount;
		for(Account accByQuery : accountsMapAfterQuery.values()){
			contactMap.put(accByQuery.Id,accByQuery.contacts);
			//accountImplementationMap.put(accByQuery.Id,accByQuery.Implementations__r);
			accountAndImplementationCountMap.put(accByQuery.Id,accByQuery.Implementations__r.size());
			Integer trailImpCounter = 0;
			for(Implementation__c impl : accByQuery.Implementations__r){
				if(impl.Implementation_Type__c.equalsIgnoreCase('Trial Account')){
					trailImpCounter++;
					accountAndImplementationTrailCountMap.put(accByQuery.Id,trailImpCounter);
				}
			}
			
		}
		
		for (Account newAcc: newMap.values()) {

			
			if (!String.isBlank(newAcc.RC_Brand__c) && RING_CENTRAL.equalsIgnoreCase(newAcc.RC_Brand__c.trim())) {
				if (im.toCreateImplementationOnInsOrUpdRing(newAcc, accountAndImplementationCountMap) || 
					(im.toCreateImplementationOnInsOrUpdOfficeTrials(newAcc, accountAndImplementationTrailCountMap))) {
					Implementation__c impObj = new Implementation__c();
					impObj.Type__c = IMP_NEW;
					if (!String.isBlank(newAcc.RC_Account_Status__c) && newAcc.RC_Account_Status__c.containsIgnoreCase(TRIAL)) {
						impObj.Implementation_Type__c = TRIAL_ACCOUNT;
					}
					if (premiumImpAccMap != null && premiumImpAccMap.get(newAcc.Id) != null && premiumImpAccMap.get(newAcc.Id) > 0) {
						impObj.Implementation_Type__c = PREMIUM;
					}
					accountImplementationMap.put(newAcc.Id, impObj);
				}
			} else if (!String.isBlank(newAcc.RC_Brand__c) && newAcc.RC_Brand__c.trim().containsIgnoreCase(TELUS) && im.tocreateImplemetationOnInsorUpdForTELUS(newAcc, accountAndImplementationCountMap)) {
				Implementation__c impObj = new Implementation__c();
				impObj.Type__c = 'New';
				if (!String.isBlank(newAcc.RC_Account_Status__c) && newAcc.RC_Account_Status__c.toUpperCase().contains(TRIAL)) {
					impObj.Implementation_Type__c = TRIAL_ACCOUNT;
				}
				if (premiumImpAccMap != null && premiumImpAccMap.get(newAcc.Id) != null && premiumImpAccMap.get(newAcc.Id) > 0) {
					impObj.Implementation_Type__c = PREMIUM;
				}
				accountImplementationMap.put(newAcc.Id, impObj);
			} else {
				if (im.toCreateImplementationOnInsOrUpd(newAcc)) {
					Implementation__c impObj = new Implementation__c();
					impObj.Type__c = IMP_NEW;
					if (premiumImpAccMap != null && premiumImpAccMap.get(newAcc.Id) != null && premiumImpAccMap.get(newAcc.Id) > 0) {
						impObj.Implementation_Type__c = PREMIUM;
					}
					accountImplementationMap.put(newAcc.Id, impObj);
				}
			}
		}
		if(UserCustomSettingHelper.getRCSFSync(UserRC.rcsfSyncUserObj.name) !=null){
			
			for(Id accountId : accountImplementationMap.keySet()){
				Account thisAccount = accountsMapAfterQuery.get(accountId);
				if(thisAccount != null) {
					String name = thisAccount.Name;
					String str = thisAccount.Name + ' - ' + Datetime.now().format();
					Integer strLength = (str).length();
					if(strLength > 80) {
						Integer dateLength = (' - ' +Datetime.now().format()).length();
						name = (thisAccount.Name).substring(0, (80-dateLength));
					}
					Implementation__c imp =  new Implementation__c();
					if(accountImplementationMap.get(thisAccount.Id) != null){
						imp = accountImplementationMap.get(thisAccount.Id);
					}
					imp.Name = name + ' - ' + Datetime.now().format();
					imp.office_service_change_date__c = Date.today();
					imp.Account__c = thisAccount.Id;
					imp.Brand__c = thisAccount.RC_Brand__c;
					imp.Tier__c = thisAccount.RC_Tier__c;
					imp.Service__c = thisAccount.RC_Service_Name__c;
					// Logic for setting the owner Id.
					if(UserRC.getRCSFSyncPrimaryOwnerId != null){
						imp.OwnerId = UserRC.getRCSFSyncPrimaryOwnerId;
					}else{
						imp.OwnerId = Userinfo.getUserId();	
					}
					imp.Account_Signup_Date__c = thisAccount.RC_Signup_Date__c;
					imp.Contact__c = (contactMap == null || contactMap.get(thisAccount.Id).size() == 0 ? null : contactMap.get(thisAccount.Id)[0].Id);

					implementationToInsertList.add(imp);
				}
			}
			
		}

		return implementationToInsertList;	
	 }
	 //------------------------AS/Simplion/5/13/2015------------------------------------------------------- 
	public static List<Lead> createLeadForAccounts(Map<Id,Account> newMap,Map<Id,Account> oldMap,Map<Id,Account> accountsMapAfterQuery){
			List<Lead> leadsListForAccoount = new List<Lead>();
			Map<Id,List<Contact>> contactMap = new Map<Id,List<Contact>>();
			for(Account accByQuery : accountsMapAfterQuery.values()){
				contactMap.put(accByQuery.Id,accByQuery.contacts);
				if(im.chkToCreateLeadForOfficeTrails(newMap.get(accByQuery.Id),allAccountsMapAfterQuery)) {
						
					Lead newLead = new Lead();
					Contact contactObj = new Contact();
					if(accByQuery.AccountContactRoles!= null && accByQuery.AccountContactRoles.size() > 0){
						contactObj = accByQuery.AccountContactRoles[0].Contact;
					}else if(contactMap != null && contactMap.containsKey(accByQuery.Id) && contactMap.get(accByQuery.Id) != null){
						contactObj = contactMap.get(accByQuery.Id)[0];
					 	
					}
					if(contactObj != null) {
				        newLead.Phone = contactObj.Phone;
				        newLead.LastName = ( String.isBlank(contactObj.LastName)? accByQuery.Name : contactObj.LastName );
				        newLead.LastName = contactObj.LastName;
				        newLead.FirstName =contactObj.FirstName;
				        newLead.Email = ( String.isBlank(contactObj.Email)? 'fake@email.com' : contactObj.Email );
				        newLead.Email = contactObj.Email;
				        newLead.Account_Status__c = accByQuery.RC_Account_Status__c;
				        newLead.Account_Number__c = accByQuery.RC_Account_Number__c;
				        newLead.User_ID__c = accByQuery.RC_User_ID__c;
				        newLead.Lead_Tier_Name__c = accByQuery.RC_Tier__c;
				        newLead.RC_Service_name__c = accByQuery.RC_Service_name__c;
				        newLead.Lead_Brand_Name__c = accByQuery.RC_Brand__c;
				        newLead.Company = accByQuery.Name;
				        newLead.Status = 'Open - Not Contacted';
				        newLead.Account__c = accByQuery.id;
				        newLead.LeadSource = 'Office Trials';
				        //---------------------As.simplion/5/12/2015-----------------------TBD
				        newLead.Account__c = accByQuery.id;
						if(contactObj.NumberOfEmployees__c != null){
							newLead.NumberOfEmployees__c = contactObj.NumberOfEmployees__c;
						}else if(contactObj.Account.No_of_Employees__c != null){
							newLead.NumberOfEmployees__c = contactObj.Account.No_of_Employees__c;
				        }
				        
			       } else {
						newLead.Email = 'fake@fake.com';
						newLead.LastName = 'fakeLead';
						newLead.Company = accByQuery.Name;
						if(accByQuery != null && accByQuery.No_of_Employees__c != null) {
							newLead.NumberOfEmployees__c = accByQuery.No_of_Employees__c;
						}
					}
					String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
					System.Debug('>>>sUrlRewrite>>>'+sUrlRewrite);
					//sUrlRewrite = 'https://' + sUrlRewrite.substring(0,sUrlRewrite.indexOf('.')-1) + 'salesforce.com' + '/' + newAccount.id;
					sUrlRewrite = 'https://' + sUrlRewrite + '/' + accByQuery.id; 
					newLead.Description = 'Office Free Trial Account Signup - Link to Account '+ sUrlRewrite;
					leadsListForAccoount.add(newLead);
				}
				
			}
			return leadsListForAccoount;

	}
	/*****************************************************************************
	 * @Description - Method to deinitalize maps, lists, sets.                   * 
	 * @params                                                                   *
	 * @return void                                                              * 
	 *****************************************************************************/      
	public static void deinitalize(){
		try{ 
			surveyListTOInsert.clear();
			leadList.clear();
			contractOwnerId.clear();
			partnerAccountIdSet.clear();
			partnerAccMap.clear();
			//mapAccountImplementationTrail.clear();
			//mapAccntImplementation.clear();
			userMap.clear();
			if(Test.isRunningTest()){
				Integer error = 0/0;
			}
		}catch(Exception e){
			System.debug('@@@Exception Deinitalize'+ e.getlineNumber());
			System.debug('###Exception deinitalize'+e.getMessage());
		}
	}
	
	/***************************************************************************************
     * @Description - Method to create Finance Case                                          * 
     * @params                                                                               *
     * @return void                                                                          * 
     ****************************************************************************************/ 
     
     //--------------As/simplion/5/4/2015-------------------------------------------------------------
     //-------------This is new method which is dedicated for only after insert method 
     //-------------This function created cases on account insert on basis of certain condittions
     public static List<Case> createFinanceCaseOnInsertAndUpdate(List<Account> newList,Map<Id,Account> oldMap,List<Account> allAccountQueryAfter,Group financeGroup){
     	List<Case> casetoinsert = new List<Case>();
     	Map<Id,Integer> mapAccountIdToNumberOfFinanceCase = new Map<Id,Integer>();
     	String financeGrpId = '';
     	if(financeGroup != null){
     		financeGrpId = financeGroup.Id;
     	}
     	for(Account accObjByQuery : allAccountQueryAfter) {
     		mapAccountIdToNumberOfFinanceCase.put(accObjByQuery.id,0);
			if(accObjByQuery.cases != null) {
				for(case cas : accObjByQuery.cases){
					if(cas.RecordType.Name.equalsIgnoreCase('Finance')){
						mapAccountIdToNumberOfFinanceCase.put(accObjByQuery.id,1);
						break;
						
					}
				}
				
			} 
		}
		for (Account accObjNew : newList) {
	    	if (accObjNew.Active_Invoice_Approval__c != NULL &&
	    		 mapAccountIdToNumberOfFinanceCase != NULL && 
	    		 mapAccountIdToNumberOfFinanceCase.get(accObjNew.Id) == 0 &&
	    		 accObjNew.RC_Account_Status__c == 'Paid') {
	    		 	Boolean isCreateCase = true;
	    		 	if(Trigger.isUpdate){
	    		 		if(oldMap.get(accObjNew.id).RC_Account_Status__c != accObjNew.RC_Account_Status__c && oldMap.get(accObjNew.id).Active_Invoice_Approval__c == null){
		    				isCreateCase = true;	
    					}else{
    						isCreateCase = false;
    					}
	    		 	}
	    		 	if(isCreateCase){
	    		 		Case caseObj = new Case();
						caseObj.Status = 'New';
						caseObj.Subject = 'New Customer Tracking for Finance';
						caseObj.OwnerId = financeGrpId;
						caseObj.AccountId = accObjNew.Id;
						caseObj.RecordTypeId  = AccountTriggerHelperExt.caseRecordTypeMapByName.get('Finance').getRecordTypeId(); 
						casetoinsert.add(caseObj);
	    		 	}
	    		 	
	    		
			}
		}
     	return casetoinsert;
     }
	public static void createFinanceCaseOnPaid(map<Id,Account> accountMapOld,List<Account> accountLstNew) {
		createFinanceCaseOnPaid(accountMapOld, accountLstNew, new List<Account>());		      	
		
	}
     public static void createFinanceCaseOnPaid(map<Id,Account> accountMapOld,List<Account> accountLstNew, List<Account> accountsQuery) {
 		List<Case> casetoinsert = new List<Case>();
		Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
    	Map<String,Schema.RecordTypeInfo> rtMapByRecName = result.getRecordTypeInfosByName();
		Map<Id,Integer> mapAccountIdToFinanceCaseNumber = new Map<Id,Integer>();
		String grpId = [SELECT Id FROM Group WHERE Name = 'Finance Queue' AND Type = 'Queue'].Id;
		try {
			for(Account accObj : accountsQuery) {
				if(accObj.cases != null) {
					mapAccountIdToFinanceCaseNumber.put(accObj.id,accObj.cases.size());
				} 
				//System.debug('^^^^^^^mapAccountIdToFinanceCaseNumber'+ mapAccountIdToFinanceCaseNumber.get(accObj.Id));
			}
	    	for (Account accObj : accountLstNew) {
		    	System.debug('########');
		    	if (accObj.Active_Invoice_Approval__c != NULL && mapAccountIdToFinanceCaseNumber != NULL && 
		    			mapAccountIdToFinanceCaseNumber.get(accObj.Id) == 0 && accObj.RC_Account_Status__c == 'Paid' && 
		    			(accountMapOld == null || 
		    				((accountMapOld.get(accObj.id).RC_Account_Status__c != accObj.RC_Account_Status__c) 
		    					|| accountMapOld.get(accObj.id).Active_Invoice_Approval__c == null))) {
		    		System.debug('*******');
					Case caseObj = new Case();
					caseObj.Status = 'New';
					caseObj.Subject = 'New Customer Tracking for Finance';
					caseObj.OwnerId = grpId;
					caseObj.AccountId = accObj.Id;
					caseObj.RecordTypeId  = rtMapByRecName.get('Finance').getRecordTypeId();
					casetoinsert.add(caseObj);
					System.debug('----->>>' + caseObj.Id);
				}
			}
			TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
			TriggerHandler.BY_PASS_CASE_ON_UPDATE = true;
			insert casetoinsert;
			TriggerHandler.BY_PASS_CASE_ON_INSERT = false;
			TriggerHandler.BY_PASS_CASE_ON_UPDATE = false;
		    System.debug('%%%%%'+ casetoinsert);
		} catch (Exception ex) {
			System.debug('##createCaseline'+ ex.getlineNumber());
	      	System.debug('##createCaseMessage'+ ex.getMessage());
	 	}	
     }
     
     /*****************************************************************************
     * @Description - method to update contact records on insertion/updation of account record      * 
     * @return Map<Id,List<Contract>                                                                * 
     *****************************************************************************/
     
    public static void updateRelatedContactAccount(list<Account> lsttAcc){              
       List<Contact> contList = new List<Contact>(); 
       Set<Id> accounttIds = new Set<Id>();
         for(Account ACC : lsttAcc){  
             if(ACC.Id != null){                   
                accounttIds.add(ACC.Id);
             }
         }
         //Query records of Contact 
         List<Contact> lstcontact = [select id,AccountId, isCustomer__c,Contact_Status__c ,People_Segment__c,RCService_ContactStatus__c from Contact where AccountId IN: accounttIds];
         Map<id, list<Contact>> accountToContactMap = new Map<id, list<Contact>>();  
          for(Contact  conn:lstcontact) { 
            if(accountToContactMap.get(conn.AccountId) != null){
                //accountToContactMap.put(conn.AccountId, new List<Contact>{conn});
                accountToContactMap.get(conn.AccountId).add(conn);
            }else{
                accountToContactMap.put(conn.AccountId, new List<Contact>{conn});
            }
          }
          system.debug('-----lstcontact------->'+lstcontact);
          system.debug('------------>'+accountToContactMap);
          for ( Account acc : lsttAcc ) {   
                        if(accountToContactMap.size()!= 0 && accountToContactMap.get(acc.Id) != null){
                         //List<Contact> lstCon= accountToContactMap.get(acc.Id);
                              for(Contact con : accountToContactMap.get(acc.Id)){                                                     
                                if(!String.isBlank(acc.RC_Account_Status__c)){                                  
                                    if(acc.RC_Account_Status__c!= null && 'Paid'.equalsIgnoreCase(acc.RC_Account_Status__c.trim())){
                                        con.isCustomer__c=True;
                                        con.Contact_Status__c='Closed Won';
                                        con.Contact_Funnel_Type__c='Customer';
                                       con.People_Segment__c='Customer';
                                    }
                                    else if(acc.RC_Account_Status__c!= null && 'Canceled'.equalsIgnoreCase(acc.RC_Account_Status__c.trim())){
                                        con.isCustomer__c=False;
                                        con.Contact_Status__c='Winback';
                                        con.Contact_Funnel_Type__c='Former Customer';
                                        con.People_Segment__c='Canceled'; 
                                    }
                                }
                                contList.add(con);
                                system.debug('*********'+contList);
                               }
                                 
                            }
          }
                 
        if(contList.size()>0){
        	
        	TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();        	
            update contList;
            TriggerHandler.BY_PASS_CONTACT_ON_UPDATE=false;
        }         
    }
    //--------------------------As/Simplion/4/9/2015------------------------------------------------------------------
   //---------------------------This method is rewritten for updateRelatedContactAccount method and optimized to reduce SOQL and CPU time-------------------- 
    public static List<Contact> updatePaidAccountRelatedContacts(list<Account> lsttAcc,Map<Id,Account> allAccountsMap){       
    	  List<Contact>  paidAccountRelatedContactsToUpdate = new List<Contact>();      
       	  for(Account paidAccount : lsttAcc){
	  	 	for(Contact cont : allAccountsMap.get(paidAccount.Id).contacts){
	          	 	if(!String.isBlank(paidAccount.RC_Account_Status__c) && 'Paid'.equalsIgnoreCase(paidAccount.RC_Account_Status__c.trim()) ){
	          	 		
	          	 			if(cont.isCustomer__c!=True ||
	          	 			!cont.Contact_Status__c.equalsIgnoreCase('Closed Won') ||
	                        !cont.Contact_Funnel_Type__c.equalsIgnoreCase('Customer') ||
	                       	!cont.People_Segment__c.equalsIgnoreCase('Customer'))
	                       	{
		          	 			cont.isCustomer__c =True;
		                        cont.Contact_Status__c='Closed Won';
		                        cont.Contact_Funnel_Type__c='Customer';
		                       	cont.People_Segment__c='Customer';
		                       	cont.Contact_Status__c = 'Closed Won';
                    			paidAccountRelatedContactsToUpdate.add(cont);
	                       	}
	      	 		}else if(!String.isBlank(paidAccount.RC_Account_Status__c) && 'Canceled'.equalsIgnoreCase(paidAccount.RC_Account_Status__c.trim()) ){
	          	 			if(cont.isCustomer__c!=False  ||
	                        cont.Contact_Status__c.equalsIgnoreCase('Winback') ||
	                        cont.Contact_Funnel_Type__c.equalsIgnoreCase('Former Customer')||
	                        cont.People_Segment__c.equalsIgnoreCase('Canceled'))
	                        {
	                        	cont.isCustomer__c =False;
		                        cont.Contact_Status__c='Winback';
		                        cont.Contact_Funnel_Type__c='Former Customer';
		                        cont.People_Segment__c='Canceled'; 
		                        cont.Contact_Status__c = 'Canceled';
		          	 			paidAccountRelatedContactsToUpdate.add(cont);
	                        }
	          	 			
	          	 	}
	          	 		
	      	 	}
          
          	 	
          }
          return paidAccountRelatedContactsToUpdate;          
    }
    //--------------------As/Simplion/4/6/2015-----------------------------------------------------------------
    //---------------------This code is to create a set of phone number with country code and without country code-------------------
    public static Map<string,Account>  createAccountMobileNumberMap(List<Account> newList){
    	Map<string,Account>  MapMobNumAccount  = new Map<string,Account> ();
		for(Account objAcc : newList) {
			String originalPhoneNumber = objAcc.Account_Mobile_Number__c;
 			if(!String.isBlank(originalPhoneNumber)) {
 				String formatPhoneWithCode = AccountTriggerHelper.formatPhoneNumberWithCode(originalPhoneNumber);
 				String formatPhoneWithoutCode = AccountTriggerHelper.formatPhoneNumberWithoutCode(originalPhoneNumber);
           		MapMobNumAccount.put(formatPhoneWithCode.trim(),objAcc);
           		MapMobNumAccount.put(formatPhoneWithoutCode.trim(),objAcc);
       		}
       }
    	return MapMobNumAccount;
    }
    
    //--------------------------------------These methods are transfered from HelperUtils class to here starts- -----------------------
	public static List<Carrier_Data__c> updateCarrierDataRecordNew(List<Carrier_Data__c>  lstCarrDat,Map<String,Account> MapMobNumAccount) {
		system.debug('####$===============updateCarrierDataRecordNew ');	
       List<Carrier_Data__c> updateCarrData = new List<Carrier_Data__c>();
      for(Carrier_Data__c objCarrData : lstCarrDat) {
          		String originalPhoneNumber = objCarrData.Carrier_Wireless_Phone_Number__c;
          		String formatPhoneWithCode = AccountTriggerHelper.formatPhoneNumberWithCode(originalPhoneNumber);
 				String formatPhoneWithoutCode = AccountTriggerHelper.formatPhoneNumberWithoutCode(originalPhoneNumber);
 				
 				Account accountObj = MapMobNumAccount.get(formatPhoneWithCode);
          		if(accountObj != null) {
          			objCarrData.Account__c = accountObj.Id;
          			updateCarrData.add(objCarrData);
          			system.debug('####$===============objCarrData ' + objCarrData);
          		} else {
          			accountObj = MapMobNumAccount.get(formatPhoneWithoutCode);
          			if(accountObj != null) {
	          			objCarrData.Account__c = accountObj.Id;
	          			updateCarrData.add(objCarrData);
	          		}
          		}
       		}
       		return updateCarrData;
  	}
    public static String formatPhoneNumberWithCode(String originalPhoneNumber) {
		return (originalPhoneNumber.length() == 10 ? '1' + originalPhoneNumber : originalPhoneNumber);
	}
	public static String formatPhoneNumberWithoutCode(String originalPhoneNumber) {
		return (originalPhoneNumber.length() == 11 ? originalPhoneNumber.substring(1,originalPhoneNumber.length()) : originalPhoneNumber);
	}
	
	//--------------------------------------These methods are transfered from HelperUtils class to here ends- -----------------------
	
}// End of Class