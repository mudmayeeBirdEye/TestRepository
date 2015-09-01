public class AccountMetricExtensionPDF {
    public Account accObj {get;set;}
    public Account_Metric__c accountMetricObj {get;set;}
    Integer perGroupNumber;
    public List<Peer_Group__c> peerGroupPerAccountMetricList {get;set;}
    public map<Integer,Peer_Group__c> peergroupMap {get;set;}
    public Quote quoteObj{get;set;}
    AccountScoreCardHelper accountScoreCardHelperObj = new  AccountScoreCardHelper();
    public AccountMetricExtensionPDF(ApexPages.StandardController controller) {
        String accountId = ApexPages.currentPage().getParameters().get('accid'); 	//controller.getId();
        accountMetricObj = new Account_Metric__c();
        if(accountId != null) {
	        try {
        	 	accObj = accountScoreCardHelperObj.getAccountValues(accountId);
        	 	quoteObj = accountScoreCardHelperObj.getSalesAgreement(accObj);
        		accountMetricObj = accountScoreCardHelperObj.getAccountMetricValues(accountId);
        		if(accountMetricObj != null) {
        			perGroupNumber = Integer.valueOf(accountMetricObj.Peer_Group_ID__c);
        		}
        		set<Integer> metricintSet = new set<Integer>();
        		metricintSet = getMetricSet();
        		if(perGroupNumber != null && metricintSet != null && metricintSet.size()>0) {
        			peerGroupPerAccountMetricList = getPeerGroupPerAccountMetric(perGroupNumber,metricintSet);	
        			List<Peer_Group__c> lstPeerGrpPerAccountMetric = getPeerGroupPerAccountMetric(perGroupNumber,metricintSet);
    			 	peergroupMap = new map<Integer,Peer_Group__c>();
    			 	peergroupMap = accountScoreCardHelperObj.getPeerGroupMapValues(metricintSet,lstPeerGrpPerAccountMetric);
        		}
           } catch(Exception ex) {} 	
        }
    }
    
    public List<Peer_Group__c> getPeerGroupPerAccountMetric(Integer peerGroupNumber, set<Integer> metricNumberSet) {
    	List<Peer_Group__c> rtnListPeerGroup = accountScoreCardHelperObj.getPeerGroupPerAccountMetric(peerGroupNumber, metricNumberSet);
        return rtnListPeerGroup;
    }
    
    public Set<Integer> getMetricSet() {
    	Set<Integer> rtnSetMetricId = accountScoreCardHelperObj.getMetricSet();
        return rtnSetMetricId;
    }
}