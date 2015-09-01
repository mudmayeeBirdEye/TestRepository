public class contactHighlighter {
	public Boolean isBTApproved {get;set;}
	public Contact objContact {get;set;}
	static final String strBTBrand = 'BT';
	
	public contactHighlighter(ApexPages.StandardController controller){
		isBTApproved = false;
		List<Contact> lstContact= [SELECT Id, Account.RC_Brand__c FROM Contact WHERE id= :ApexPages.currentPage().getParameters().get('id')];
		if(lstContact != null && lstContact.size() > 0){
			objContact = lstContact.get(0);
		}
		if(objContact != null){
			String rcBrand = objContact.Account.RC_Brand__c;
	        if(String.isNotBlank(rcBrand) && rcBrand.trim().containsIgnoreCase(strBTBrand)){
	   			isBTApproved = true;
	   		}
		}
	}
}