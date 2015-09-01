public with sharing class CustomTabsController {
	public String selectedTabName{get;set;} 
	
	public CustomTabsController() {
		selectedTabName = ApexPages.currentPage().getParameters().get('tabname');
		if(selectedTabName == null) {
			selectedTabName = 'name2';
		}
	}
	/*static testMethod void testCustomTabsController() {
		CustomTabsController obj = new CustomTabsController();
	}*/
}