public class AddEditEmployeeAssetCtrl {
	public EmployeeAssetJunction__c empAssetObj{get;set;}
	public String strName{get;set;}
	public String sUrlRewrite{get;set;}
	public AddEditEmployeeAssetCtrl(ApexPages.StandardController stdController) {
		this.empAssetObj = (EmployeeAssetJunction__c)stdController.getRecord();
		try {
			//empAssetObj.IT_Team_Member__c = null;
			empAssetObj.OwnerId = UserInfo.getUserId();
		} catch(Exception e) {
		
		}
	}
	
	public PageReference onSave(){
		try {
  			String isClonned = ApexPages.currentPage().getParameters().get('clone');
			if(isClonned != null && isClonned == '1' && empAssetObj != null) {
				EmployeeAssetJunction__c clonnedEAObj = empAssetObj.clone();
				insert clonnedEAObj;
				return new ApexPages.StandardController(clonnedEAObj).view();
			} else if(empAssetObj != null) {
				upsert empAssetObj;
				return new ApexPages.StandardController(empAssetObj).view();
			}
		} catch ( Exception ex ) {
  			if( ex.getMessage().contains('DUPLICATE_VALUE')){
  				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
  									'This asset is already assigned to selected employee. Please select different employee number.'));	
			} else if(ex.getMessage().contains('Asset assignment cannot be less than asset purchase date.')){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Asset assignment cannot be less than asset purchase date.'));
			} else{
  				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() ));
  			}	
		}	
  		return ApexPages.currentPage();	
  	}
	public PageReference onCancel(){
		String recordId = ApexPages.currentPage().getParameters().get('retURL');
		if(recordId == null) {
			recordId = 'home/home.jsp';
		}
		PageReference onCancel = new PageReference(recordId);
  		return onCancel;
  	}
}