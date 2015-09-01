public with sharing class AccountTriggerStaticProperties {
	public static boolean BY_PASS_ACCOUNT_BEFORE = false;
    public static boolean BY_PASS_ACCOUNT_AFTER = false;
    public static Set < Id > userIds = new set<Id>();
    public static set<String> AllRecordsPartnerId = new set<String>();
    public  static final String CUSTOMER_ACCOUNT = 'Customer Account';
    public static final String PARTNER_ACCOUNT = 'Partner Account'; 
    public static Map<String,Account> partnerAndCustomerMap = new Map<String,Account>();
    public static Map<String,Account> partnerAccountMap = new Map<String,Account>();
    public static List<Account>  currentCustomersPartnersListQuery = new List<Account>();
    public static List<Account> accountsListForUpdateForCreditCounter = new List<Account>();
    public static set<String> ultimateParentIdSet = new set<String>();
    
    public static Map<Id,Account>  allUpdatedAccountMapQuery = new Map<Id,Account>();
    public static List<Account>  currentPartnersCustomerListQuery = new List<Account>();
    public static List<Account> currentCustomersPartnersListInAfterQuery = new List<Account>();
    //-------------------------As/Simplion/4/8/2015------------------------------------------------------
	public static Map<String, Account> partnerAccountContactMap = new Map<String, Account>();
	public static List<Account> allAccountInAfterQuery = new List<Account>();
	public static final String SALES_OPPORTUNITY = 'Sales Opportunity';
	public static List<Entitlement> EntitlementsList = new List<Entitlement>();
	public static Map<Id,List<Contract>> accountContractMap = new Map<Id,List<Contract>>(); 
	public static Map<Id,Account> allAccountsMapAfterQuery = new Map<Id,Account>();
	public static Map<Id, Integer> premiumImpAccMap = new Map<Id, Integer>();
	public static Map<Id, List<Contact>> AllAccountContactMapQuery = new Map<Id,List<Contact>>();
	public static List<Account> allAccountsByParentDetails = new List<Account>();
	public static Map<ID,Account> allAccountParentByParentIdQuery = new Map<ID,Account>();
	public static Map<Id, Contact> PrimaryContactAccountMap = new Map<Id, Contact>(); 
	public static List<Carrier_Data__c>  lstCarrData = new List<Carrier_Data__c>();
    public static List<Account> allAccountParentAfterQuery = new List<Account>();
    public static Decimal ACCOUNT_METRIC_ADOPTION = 25;
	public static Decimal ACCOUNT_METRIC_12DOT50 = 12.50;
	public static String RING_CENTRAL ='RingCentral';		
	public static String IMP_NEW = 'New';
	public static String TRIAL = 'TRIAL';	
	public static String TRIAL_ACCOUNT = 'Trial Account';	
	public static String PREMIUM = 'Premium';	
	public static String TELUS ='TELUS';
	public static String CANCELED = 'Canceled'; 
	//This set is initialized for implementation status.
	public static Set<String> implementationStatusSetOnAccount = new Set<String>{'6a. Completed','6b. Completed - No Help Needed','6c. Completed - Account Cancelled','6d. Completed - No Response'};
	public static String COMPLETED_ACCOUNT_CANCELLED = '6c. Completed - Account Cancelled';
	public static String RC_OFFICE ='RC Office';	
	public static String WEB = 'WEB';
	public static String TRIAL_30NOCC = 'TRIAL_30NOCC';
	public static String TRIAL_30d_NO_CC_WEB ='TRIAL 30d-NO-CC-WEB';
	public static String DWH_SYNC_PENDING = 'DWH SYNC PENDING';	
	public static String TRIAL_NOCC ='TRIAL_NOCC';
	public static String TRIAL_30d_NO_CC_MOB = 'TRIAL 30d-NO-CC-MOB';		
	public static String TRIAL_30_NO_CC = 'Trial 30 no-CC';
	public static String CANCELLED_TRIAL = 'Cancelled Trial';
	public static String BT_CLOUD_PHONE = 'BT Cloud Phone';
	public static String DISABLED = 'Disabled'; 
	public static Map<String, String> mobLeadSources = new Map<String, String>{'m' => 'm', 'iphone' => 'iphone', 'bb' => 'bb', 'android' => 'android'};
	public static String PARTNER = 'Partner';
	public static String EXECUTIVE = 'Executive'; 
	
	
	
    public static Map < Id, Schema.RecordTypeInfo > accountRecordTypeMapById{
    	get{
    		if(accountRecordTypeMapById != null){
    			return accountRecordTypeMapById;
    		}else{
    			Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    			accountRecordTypeMapById = result.getRecordTypeInfosById();
    			return accountRecordTypeMapById;
    		}
    	}set;
    }
    
    public static Map < String, Schema.RecordTypeInfo > accountRecordTypeMapByName{
    	get{
    		if(accountRecordTypeMapByName != null){
    			return accountRecordTypeMapByName;
    		}else{
    			Schema.DescribeSObjectResult result = Account.SObjectType.getDescribe();
    			accountRecordTypeMapByName = result.getRecordTypeInfosByName();
    			return accountRecordTypeMapByName;
    		}
    	}set;
    }
    
    public static Profile currentLoggedInProfile{get{
        if(currentLoggedInProfile != null){
            return currentLoggedInProfile;
        }else{
            currentLoggedInProfile = [SELECT Id,Name,(SELECT Id,Name,username,FirstName,LastName,Email,Phone FROM Users where Id= : Userinfo.getUserId() Limit 1) FROM Profile Where Id = : Userinfo.getProfileId() LIMIT 1];
            return currentLoggedInProfile;
        }
    }set;}
    
    public static Map<Id,User> allUserMap{get{
        if(allUserMap != null){
            return allUserMap;
        }
        else{
            allUserMap = new Map<Id,User>([SELECT Id,username, Phone, Email,FirstName, LastName, Name FROM User WHERE Id IN :AccountTriggerStaticProperties.userIds]);
            return allUserMap;
        }
    }set;}
}