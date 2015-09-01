/********************************************************************************************************
* Project Name..........:                                                                               *
* File..................: AccountScoreCardHelper.class                                                  *
* Version...............: 1.0                                                                           *
* Created by............:                                                                               *
* Created Date..........:                                                                               *
* Last Modified by......: Simplion Technologies                                                         *
* Last Modified Date....: 24-06-2014                                                                    *
* Description...........:                                                                               *
********************************************************************************************************/
public with sharing class AccountScoreCardHelper {
   // public Schema.DescribeSObjectResult descResult = Schema.SObjectType.Case; 
    //public Map<String,Schema.RecordTypeInfo> rtMapByName = descResult.getRecordTypeInfosByName();
    
    // Constants 
    public static final Set<String> ICACCREVIEWSET = new Set<String>{'Overview','Messages','Activity Log','Contacts','Billing','Webinars','Support Portal','Survey'};
    public static final Set<String> ICACCREVIEWSET_TELUS = new Set<String>{'Overview','Messages','Activity Log','Contacts','Billing','Webinars','Support Portal','Survey','Int\'l Calling & Fraud Prevention'};
    public static final Set<String> ICCOMPANYINFOSET = new Set<String>{'Company Caller ID','Company Address','Add Number','User My Existing Number (Porting)'};
    public static final Set<String> ICUSERSSET = new Set<String>{'Unassigned Ext','Add Users','Permissions','User Info','Phones & Numbers','Screening, Greeting, & Hold Music',
                                                            'Call Handling and Forwarding','Messages & Notifications','Outbound Caller ID','Outbound Fax Settings'};
    public static final Set<String> ICPHONESSET = new Set<String>{'Phone Serial Number','Phone Nickname','E911'};
    public static final Set<String> ICGROUPSSET = new Set<String>{'Add Group','Call Queues','Paging','Shared Lines'};  
    public static final Set<String> ICTOOLSSET = new Set<String>{'Mobile App','Softphone','RC Meetings'};
    
    public static final String SURVEY_SUPPORT = 'Support';
    public static final String SURVEY_NEWCUSTOMER = 'New Customer (after 90 days)';
    public static final String SURVEY_IMPLEMENTATION = 'Implementation';
    public static final String SURVEY_ATTIMPLEMENTATION = 'ATT Implementation';
    public static final String SURVEY_RELATIONSHIP = 'Relationship';
     
      
    // Constructor
    public AccountScoreCardHelper() {}
    
    public Account getAccountValues(string accountId) {
        return [SELECT Id, Name, AccountNumber, Implementation_Phase_Completion_Rate__c, Adoption_Phase_Completion_Rate__c, Graduation_Phase_Completion_Rate__c, RC_Brand__c, RC_User_ID__c, Contact_Email__c, RC_Service_name__c, Number_of_DL_s__c, Sales_Agreement_Start_Date__c, Sales_Agreement_End_Date__c, RC_Signup_Date__c,RC_Activation_Date__c, 
                            Next_Renewal_Date__c, No_of_Employees__c, Account_Age__c, MRR__c, CCExpireDate__c, Account_Graduation_Date_61_90__c, (SELECT Email,Name FROM Contacts order by LastModifiedDate DESC) FROM Account WHERE Id = :accountId];     
    }
     
     
     /*
      * This is for fetching Account with its child(Implementation) 
      * @param accountIds is set of Accounts Ids.  
      */
    public static Map<Id, Account> getAccountsValues(set<string> accountIds) {
       // return [SELECT Id, Name, AccountNumber, RC_Brand__c, RC_User_ID__c, Contact_Email__c, RC_Service_name__c, Number_of_DL_s__c, Sales_Agreement_Start_Date__c, Sales_Agreement_End_Date__c, RC_Signup_Date__c,RC_Activation_Date__c, 
          //                  Next_Renewal_Date__c, (SELECT Email,Name FROM Contacts order by LastModifiedDate DESC) FROM Account WHERE Id IN :accountIds];
       Map<Id, Account> objMap = new Map<Id, Account>();
        objMap = new Map<Id, Account>([Select a.Implementation_Phase_Completion_Rate__c, a.Account_Graduation_Date_0_30__c, Adoption_Phase_Completion_Rate__c, Graduation_Phase_Completion_Rate__c,
                    (Select Id, Account__c, Account_Review__c, Company_Numbers_and_Info__c, Users__c, Phones_Devices__c, Groups__c, Tools__c 
                    From Implementations__r order by LastModifiedDate DESC) 
            From Account a WHERE Id IN :accountIds]);
         return objMap;                      
    }
       
     /*
      * This is for getting Account with its children(Case And Account Metric) 
      * @param accountIds is set of Accounts Ids.
      */
     public static Map<Id, Account> getAccountsWithAccountMetric(set<string> accountIds) {
       Map<Id, Account> objMap = new Map<Id, Account>();
       String recTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Support - T3').RecordTypeId ;
       
        objMap = new Map<Id, Account>([Select Id, Account_Graduation_Date_0_30__c, Graduation_Kit__c, Current_Owner_Email__c, Number_of_DL_s__c,Account_Graduation_Date_61_90__c, Account_Graduation_Date_31_60__c, Implementation_Phase_Completion_Rate__c, Adoption_Phase_Completion_Rate__c, Graduation_Phase_Completion_Rate__c,
                                        (Select Account_ID__c, Metric_3_value__c, Metric_11_value__c, Metric_18_value__c,Adoption_Phase_Completion_Rate__c, Account_Graduation_Date_31_60__c, Account_Graduation_Date_61_90__c, 
                						 Graduation_Phase_Completion_Rate__c, Account_Graduation_Status__c,
                                         Metric_23_value__c, Metric_27_value__c, Metric_28_value__c From Account_Metrics__r order by LastModifiedDate DESC limit 1 ),
                                         (Select Id, Account_Graduation_Status__c, Account__c from Implementations__r),
                                         (Select Id,Status,RecordTypeId from Cases where RecordTypeId =: recTypeId AND (Status != 'Closed' AND Status != 'Closed - No Response' AND Status != 'Duplicate' AND Status != 'Cancelled') ORDER BY CreatedDate DESC LIMIT 1)
                                    From Account a WHERE Id IN :accountIds]);
         return objMap;                      
    }
   /* 
    public static Map<Id, Account> getAccountsWithImplemenataionAndAccountMetric(set<string> accountIds) {
       Map<Id, Account> objMap = new Map<Id, Account>();
       objMap = new Map<Id, Account>([Select Id, Graduation_Kit__c, Current_Owner_Email__c, Number_of_DL_s__c, Account_Graduation_Date_31_60__c, Adoption_Phase_Completion_Rate__c, Graduation_Phase_Completion_Rate__c,
                                        (Select Account_ID__c, Metric_3_value__c, Metric_11_value__c, Metric_18_value__c,
                                         Metric_23_value__c, Metric_27_value__c, Metric_28_value__c From Account_Metrics__r order by LastModifiedDate DESC limit 1 ),
                                        (Select Id, Account__c, Account_Review__c, Company_Numbers_and_Info__c, Users__c, Phones_Devices__c, Groups__c, Tools__c 
                                            From Implementations__r order by LastModifiedDate DESC limit 1) 
                                    From Account a WHERE Id IN :accountIds]);
         return objMap;                      
    }
     */  
    public Account getRCInternalAccountInfo() {
        return [SELECT Id,Name,(SELECT Name,email FROM Contacts ORDER BY Name ASC LIMIT 1000) FROM Account WHERE Name = 'RC Internal' LIMIT 1];
    }
    
    /*public Account_Metric__c getAccountMetricValues(string accountId) {
        return [SELECT Peer_Group_ID__c, Metric_1_value__c, 
                    Metric_1_bucket__c, Metric_1000_value__c, Metric_1000_bucket__c,Metric_101_value__c,Metric_101_bucket__c,Id,
                    Metric_102_value__c,Metric_102_bucket__c,Metric_103_value__c,Metric_103_bucket__c, 
                    Metric_2_value__c, Metric_2_bucket__c,Metric_3_value__c, Metric_3_bucket__c,
                    Metric_4_value__c, Metric_4_bucket__c,Metric_5_value__c, Metric_5_bucket__c,
                    Metric_6_value__c, Metric_6_bucket__c,Metric_7_value__c, Metric_7_bucket__c,
                    Metric_1_Position__c,Metric_2_Position__c,Metric_3_Position__c,Metric_4_Position__c,
                    Metric_5_Position__c,Metric_6_Position__c,Metric_7_Position__c,Metric_1000_Position__c,
                    Metric_101_Position__c,Metric_102_Position__c,Metric_103_Position__c,                    
                    Account_ID__c FROM Account_Metric__c WHERE Account_ID__c = :accountId];     
    }*/
    
    //Account Object - OJ
    public Account getAccountInfoValues(string accountId)
    {
        return [SELECT 
        Webinar_Resource_Center__c, //Text
        Webinar_Name__c, //Text
        Webinar_Date__c, //Date
        //Handoff_to_Farming_Agent__c, //Picklist
        Implementation_Phase_Completion_Rate__c, 
        Adoption_Phase_Completion_Rate__c, 
        Graduation_Phase_Completion_Rate__c,
        Current_Owner_Email__c, //Text
        Account_Graduation_Status__c, //Picklist
        Graduation_Kit__c, //Checkbox
        Account_Graduation_Date_0_30__c,
        Account_Graduation_Date_31_60__c,
        Account_Graduation_Date_61_90__c,
        SDR_Agent__c,
        Premium_Support_Agent__c,
        Current_Owner__c
        

        FROM Account WHERE Id = :accountId];     
    }
    
        
    //Implementation Object - OJ - Implementation Completed
    public Implementation__c getImplementationValues(string accountId)
    {
        /*Changes:  1> CreatedDate to ModifiedDate 2> added Status!='Closed' in soql query
                    AND (Implementation_Status__c = '6a. Completed' OR Implementation_Status_2__c = 'Completed') 
        */  
        return [SELECT Implementation_Status__c, Brand__c, Implementation_Status_2__c, Name, Account__c, CreatedDate, Account_Build_out_completed__c, End_User_Training__c, Account_Review__c, 
        				Company_Numbers_and_Info__c, Users__c, Phones_Devices__c, Groups__c, Tools__c, Account_Graduation_Date_0_30__c, Implementation_Phase_Completion_Rate__c,
        				Account_Graduation_Status__c
        FROM Implementation__c WHERE Account__c = :accountId ORDER BY LastModifiedDate DESC LIMIT 1];     
    }
    //Network Info Object - OJ
    public Network_Information__c getNetworkValues(string accountId)
    {
        return [SELECT Name FROM Network_Information__c WHERE Account__c = :accountId ORDER BY CreatedDate DESC LIMIT 1];     
    } 
    //Case Object - OJ - Open Tier 3 Cases / Pending PKIs
    public Case getCaseValues(string accountId)
    {
        //String recTypeId = rtMapByName.get('Support - T3').getRecordTypeId();
        String recTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Support - T3').RecordTypeId ;
        system.debug('@@@@@@@@ 111'+recTypeId );
        return [SELECT RecordTypeId, Status, AccountId      
        //FROM Case WHERE AccountId = :accountId AND RecordTypeId =: recTypeId AND Status != 'Closed' ORDER BY CreatedDate DESC LIMIT 1];  
        FROM Case WHERE AccountId = :accountId AND RecordTypeId =: recTypeId AND (Status != 'Closed' AND Status != 'Closed - No Response' AND Status != 'Duplicate' AND Status != 'Cancelled') ORDER BY CreatedDate DESC LIMIT 1];     
    } 
    
    //Case Object - OJ - Web Portal Adoption
    public Case getCase2Values(string accountId)
    {
        //String recTypeId = rtMapByName.get('Support-Case').getRecordTypeId();
        String recTypeId = Schema.SObjectType.Case.RecordTypeInfosByName.get('Support-Case').RecordTypeId;
        system.debug('@@@@@@@@'+recTypeId );
        return [SELECT RecordTypeId, Status, AccountId, Origin     
        FROM Case WHERE AccountId = :accountId AND Origin = 'Web' AND RecordTypeId =: recTypeId ORDER BY CreatedDate DESC LIMIT 1];     
    } 
    
        public Account_Metric__c getAccountMetricValues(string accountId) {
        return [SELECT Peer_Group_ID__c, Id, Account_ID__c, Metric_1000_bucket__c, Metric_1000_Position__c, Metric_1000_value__c,
                Metric_101_bucket__c, Metric_101_Position__c, Metric_101_value__c, Metric_102_bucket__c, Metric_102_Position__c, 
                Metric_102_value__c, Metric_103_bucket__c, Metric_103_Position__c, Metric_103_value__c, Metric_1_bucket__c, 
                Metric_1_Position__c, Metric_1_value__c, Metric_2_bucket__c, Metric_2_Position__c, Metric_2_value__c, Metric_3_bucket__c, 
                Metric_3_Position__c, Metric_3_value__c, Metric_4_bucket__c, Metric_4_Position__c, Metric_4_value__c, Metric_5_bucket__c, 
                Metric_5_Position__c, Metric_5_value__c, Metric_6_bucket__c, Metric_6_Position__c, Metric_6_value__c, Metric_7_bucket__c, 
                Metric_7_Position__c, Metric_7_value__c, Metric_8_bucket__c, Metric_8_Position__c, Metric_8_value__c, Metric_9_bucket__c, 
                Metric_9_Position__c, Metric_9_value__c, Metric_10_bucket__c, Metric_10_Position__c, Metric_10_value__c, Metric_11_bucket__c, 
                Metric_11_Position__c, Metric_11_value__c, Metric_12_bucket__c, Metric_12_Position__c, Metric_12_value__c, Metric_13_bucket__c, 
                Metric_13_Position__c, Metric_13_value__c, Metric_14_bucket__c, Metric_14_Position__c, Metric_14_value__c, Metric_15_bucket__c, 
                Metric_15_Position__c, Metric_15_value__c, Metric_16_bucket__c, Metric_16_Position__c, Metric_16_value__c, Metric_17_bucket__c, 
                Metric_17_Position__c, Metric_17_value__c, Metric_18_bucket__c, Metric_18_Position__c, Metric_18_value__c, Metric_19_bucket__c, 
                Metric_19_Position__c, Metric_19_value__c, Metric_20_bucket__c, Metric_20_Position__c, Metric_20_value__c, Metric_21_bucket__c, 
                Metric_21_Position__c, Metric_21_value__c, Metric_22_bucket__c, Metric_22_Position__c, Metric_22_value__c, Metric_23_bucket__c, 
                Metric_23_Position__c, Metric_23_value__c, Metric_24_bucket__c, Metric_24_Position__c, Metric_24_value__c, Metric_25_bucket__c, 
                Metric_25_Position__c, Metric_25_value__c, Metric_26_bucket__c, Metric_26_Position__c, Metric_26_value__c, Metric_27_bucket__c, 
                Metric_27_Position__c, Metric_27_value__c, Metric_28_bucket__c, Metric_28_Position__c, Metric_28_value__c, Metric_29_bucket__c, 
                Metric_29_Position__c, Metric_29_value__c, Metric_30_bucket__c, Metric_30_Position__c, Metric_30_value__c,
                Adoption_Phase_Completion_Rate__c, Account_Graduation_Date_31_60__c, Account_Graduation_Date_61_90__c, 
                Graduation_Phase_Completion_Rate__c, Account_Graduation_Status__c	
                FROM Account_Metric__c 
                WHERE Account_ID__c=:accountId];     
    }
    
    public map<Integer,Peer_Group__c> getPeerGroupMapValues(set<Integer> metricintSet, List<Peer_Group__c> lstPeerGrpPerAccountMetric) {
        map<Integer,Peer_Group__c> rtnPeerGroupMap = new map<Integer,Peer_Group__c>();
        for(Peer_Group__c peerGrpObj : lstPeerGrpPerAccountMetric) {
            rtnPeerGroupMap.put(Integer.valueOf(peerGrpObj.Metric_ID__c),peerGrpObj);
        }
        for(Integer metricNum : metricintSet) {
            if(!rtnPeerGroupMap.containskey(metricNum)) {
                Peer_Group__c peerGropTmObj = new Peer_Group__c();
                rtnPeerGroupMap.put(metricNum,peerGropTmObj);
            }
        }
        return rtnPeerGroupMap;
    } 
    
    public List<Peer_Group__c> getPeerGroupPerAccountMetric(Integer peerGroupNumber, set<Integer> metricNumberSet) {
        return [SELECT Yellow_Bucket_Percentage__c, Yellow_Bucket_Label__c, Red_Bucket_Percentage__c, 
                Red_Bucket_Label__c, Peer_Group_ID__c, Name, Metric_ID__c, Median_Value__c, Id, AccountLookup__c,
                Green_Bucket_Label__c, Green_Bucket_Percentage__c, Number_of_Accounts__c
                FROM Peer_Group__c WHERE Metric_ID__c IN : metricNumberSet AND Peer_Group_ID__c = :peerGroupNumber
                ORDER BY createdDate DESC]; // order by Metric_ID__c asc
    }
    
    public Set<Integer> getMetricSet() {
        set<Integer> setToRtn = new set<Integer>();
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('Account_Metric__c').getDescribe().fields.getMap();
        for(String strfieldName : objectFields.keySet()) {
            if(strfieldName.containsIgnoreCase('metric')) {
                List<string> splitStr = strfieldName.split('_');
                if(splitStr != null && splitStr.size()>1) {
                    setToRtn.add(Integer.valueOf(splitStr[1]));
                }
            }         
        }
        return setToRtn;
    }
    public Quote getSalesAgreement(Account accountObj) {
        Quote quoteObj = new Quote();
        try {
            if(accountObj.RC_User_ID__c != null) {
                quoteObj = [SELECT Start_Date__c, End_Date__c, Initial_Term_months__c, Term_months__c, Initial_Term__c, Auto_Renewal__c FROM Quote WHERE 
                             Account_RC_USERID__c = :accountObj.RC_User_ID__c AND Status = 'Active' 
                             ORDER BY LastModifiedById DESC LIMIT 1];
            }
        } catch(Exception e) {}
        return quoteObj;
    }
    
    public static List<Survey__c> getAccountSurvey(String accountId, set<string> setSurveyTypes){
        return [Select SurveyType__c, CSAT_Score__c, support_overall_sat_eval__c, Likely_to_Recommend_Rel__c, Implementation_Advisor_Satisfaction__c, sales_overall_sat_eval__c 
                from Survey__c where Account__c =: accountId and SurveyType__c IN: setSurveyTypes and Response_Date__c = LAST_N_DAYS:60 order by support_overall_sat_eval__c asc];
    }
}