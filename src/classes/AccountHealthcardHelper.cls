public class AccountHealthcardHelper {
    public List<Account_Metric__c> accountMetrics{get;set;}
    public map<Integer,Peer_Group__c> peergroupMap {get;set;}
    public Account_Metric__c accMetricObj {get;set;}
    public AccountHealthcardHelper(ApexPages.StandardController controller) {
        accountMetrics = new List<Account_Metric__c>();
        try {
            String accountId = controller.getId();
            accountMetrics = getAccountMetricPerAccount(accountId);
            Integer perGroupNumber;
            if(accountMetrics != null && accountMetrics.size()>0) {
                accMetricObj = new Account_Metric__c();
                accMetricObj = accountMetrics[0];
                perGroupNumber = Integer.valueOf(accountMetrics[0].Peer_Group_ID__c);
            }
            set<Integer> metricintSet = new set<Integer>();
            metricintSet = getMetricSet();
            if(perGroupNumber != null && metricintSet != null && metricintSet.size()>0) {
                 List<Peer_Group__c> lstPeerGrpPerAccountMetric = getPeerGroupPerAccountMetric(perGroupNumber,metricintSet);
                 peergroupMap = new map<Integer,Peer_Group__c>();
                 for(Peer_Group__c peerGrpObj : lstPeerGrpPerAccountMetric) {
                    peergroupMap.put(Integer.valueOf(peerGrpObj.Metric_ID__c),peerGrpObj);
                 }
                 for(Integer metricNum : metricintSet) {
                    if(!peergroupMap.containskey(metricNum)) {
                        Peer_Group__c peerGropTmObj = new Peer_Group__c();
                        peergroupMap.put(metricNum,peerGropTmObj);
                    }
                }   
            }
        } catch(Exception ex) {}
    }

    /*public List<Account_Metric__c> getAccountMetricPerAccount(String accountId) {
        return [SELECT Peer_Group_ID__c, Metric_1_value__c, 
                    Metric_1_bucket__c, Metric_1000_value__c, Metric_1000_bucket__c,Metric_101_value__c,Metric_101_bucket__c,Id,
                    Metric_102_value__c,Metric_102_bucket__c,Metric_103_value__c,Metric_103_bucket__c, 
                    Account_ID__c,Metric_1_Position__c,Metric_2_Position__c,Metric_3_Position__c,Metric_4_Position__c,
                    Metric_5_Position__c,Metric_6_Position__c,Metric_7_Position__c,Metric_1000_Position__c,
                    Metric_101_Position__c,Metric_102_Position__c,Metric_103_Position__c FROM Account_Metric__c 
                    WHERE Account_ID__c=:accountId];
    }*/
    
    public List<Account_Metric__c> getAccountMetricPerAccount(String accountId) {
        return [SELECT Peer_Group_ID__c, Id, Account_ID__c,
                    Metric_1000_bucket__c, Metric_1000_Position__c, Metric_1000_value__c,
                    Metric_101_bucket__c, Metric_101_Position__c, Metric_101_value__c,
                    Metric_102_bucket__c, Metric_102_Position__c, Metric_102_value__c,
                    Metric_103_bucket__c, Metric_103_Position__c, Metric_103_value__c,
                    Metric_1_bucket__c, Metric_1_Position__c, Metric_1_value__c, 
                    Metric_2_bucket__c, Metric_2_Position__c, Metric_2_value__c, 
                    Metric_3_bucket__c, Metric_3_Position__c, Metric_3_value__c, 
                    Metric_4_bucket__c, Metric_4_Position__c, Metric_4_value__c, 
                    Metric_5_bucket__c, Metric_5_Position__c, Metric_5_value__c, 
                    Metric_6_bucket__c, Metric_6_Position__c, Metric_6_value__c, 
                    Metric_7_bucket__c, Metric_7_Position__c, Metric_7_value__c, 
                    Metric_8_bucket__c, Metric_8_Position__c, Metric_8_value__c, 
                    Metric_9_bucket__c, Metric_9_Position__c, Metric_9_value__c, 
                    Metric_10_bucket__c, Metric_10_Position__c, Metric_10_value__c, 
                    Metric_11_bucket__c, Metric_11_Position__c, Metric_11_value__c, 
                    Metric_12_bucket__c, Metric_12_Position__c, Metric_12_value__c, 
                    Metric_13_bucket__c, Metric_13_Position__c, Metric_13_value__c, 
                    Metric_14_bucket__c, Metric_14_Position__c, Metric_14_value__c, 
                    Metric_15_bucket__c, Metric_15_Position__c, Metric_15_value__c, 
                    Metric_16_bucket__c, Metric_16_Position__c, Metric_16_value__c, 
                    Metric_17_bucket__c, Metric_17_Position__c, Metric_17_value__c, 
                    Metric_18_bucket__c, Metric_18_Position__c, Metric_18_value__c, 
                    Metric_19_bucket__c, Metric_19_Position__c, Metric_19_value__c, 
                    Metric_20_bucket__c, Metric_20_Position__c, Metric_20_value__c, 
                    Metric_21_bucket__c, Metric_21_Position__c, Metric_21_value__c, 
                    Metric_22_bucket__c, Metric_22_Position__c, Metric_22_value__c, 
                    Metric_23_bucket__c, Metric_23_Position__c, Metric_23_value__c, 
                    Metric_24_bucket__c, Metric_24_Position__c, Metric_24_value__c, 
                    Metric_25_bucket__c, Metric_25_Position__c, Metric_25_value__c, 
                    Metric_26_bucket__c, Metric_26_Position__c, Metric_26_value__c, 
                    Metric_27_bucket__c, Metric_27_Position__c, Metric_27_value__c, 
                    Metric_28_bucket__c, Metric_28_Position__c, Metric_28_value__c, 
                    Metric_29_bucket__c, Metric_29_Position__c, Metric_29_value__c, 
                    Metric_30_bucket__c, Metric_30_Position__c, Metric_30_value__c
                    FROM Account_Metric__c 
                    WHERE Account_ID__c=:accountId];
    } 
     
    
    public List<Peer_Group__c> getPeerGroupPerAccountMetric(Integer peerGroupNumber, set<Integer> metricNumberSet) {
        return [SELECT Yellow_Bucket_Percentage__c, Yellow_Bucket_Label__c, Red_Bucket_Percentage__c, 
                Red_Bucket_Label__c, Peer_Group_ID__c, Name, Metric_ID__c, Median_Value__c, Id, AccountLookup__c,
                Green_Bucket_Label__c, Green_Bucket_Percentage__c, Number_of_Accounts__c
                FROM Peer_Group__c WHERE Metric_ID__c IN : metricNumberSet AND Peer_Group_ID__c = :peerGroupNumber
                order by createdDate desc]; // order by createddate
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
}   // 1 Account = {n Account Metric} => {n Peer Group}