public class CaseHighlighter {
	public Boolean bRedAccount {get;set;}
	public String strRedAccountId{get;set;}
	public String highlighterMsg {get;set;}
	private static final String BT_BUSINESS;
	
	static{
		if(!Test.isRunningTest()){
			BT_BUSINESS = RcDealHealper.getBTBrand();
		}else{
			BT_BUSINESS = 'BT Business';
		} 
	} 
	public CaseHighlighter(ApexPages.StandardController controller) {
		Case objCase= (Case)controller.getRecord();
		Case objCaseDetail=[SELECT id,AccountId,Account.RC_Brand__c FROM Case WHERE id=:objCase.id];
		String brand = objCaseDetail.Account.RC_Brand__c;
		/*
		if(!String.isBlank(brand)) {
			if(brand.containsIgnoreCase('TELUS')) {
				highlighterMsg = 'TELUS';
			} else if(brand.containsIgnoreCase('BT')) {
				highlighterMsg = 'BT';
			} else if(brand.containsIgnoreCase('AT&T')) {
				highlighterMsg = 'AT&T';
			} 
		}
		*/
		highlighterMsg = (!String.isBlank(brand) ? (brand.containsIgnoreCase('TELUS') ? 'TELUS' : (brand.containsIgnoreCase('BT') ? BT_BUSINESS : (brand.containsIgnoreCase('AT&T') ? 'AT&T' : null)) ) : null );
		for(Account acc: [SELECT (SELECT id,Status__c FROM Escalations__r WHERE Status__c!='Resolved' and Status__c !='Yellow' ORDER BY 
	                         LastModifiedDate DESC LIMIT 1) FROM Account WHERE Id =:objCaseDetail.AccountId LIMIT 1] ){   
			try {
				if(acc.Escalations__r.size()>0){
					bRedAccount=true;
					strRedAccountId=acc.Escalations__r.get(0).id;
				}
			} catch(Exception e){}
		}
	}
}