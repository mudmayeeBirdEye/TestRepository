public class PurchaseOrderExt {
	private IT_Purchase_Order__c purchaseOrderObj;
	public	PurchaseOrderExt(ApexPages.StandardController stdController) {
        this.purchaseOrderObj = (IT_Purchase_Order__c)stdController.getRecord();
	}
	public PageReference saveOrder() {
		String isClonned = ApexPages.currentPage().getParameters().get('clone');
		if(isClonned != null && isClonned == '1') {
			IT_Purchase_Order__c clonnedOrderObj = purchaseOrderObj.clone();
			clonnedOrderObj.OwnerId = UserInfo.getUserId();
			insert clonnedOrderObj;
			return new ApexPages.StandardController(clonnedOrderObj).view();
		} else if(purchaseOrderObj != null) {
			upsert purchaseOrderObj;
			return new ApexPages.StandardController(purchaseOrderObj).view();
		}
		return ApexPages.currentPage();
	}
	
}