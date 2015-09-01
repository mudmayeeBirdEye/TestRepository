public class AssetController {
   
    private String assetID;
    
    public AssetController(ApexPages.StandardController controller){
   		assetID  = 	controller.getId(); 
    }
    
    public PageReference callDispatcher() {
    	String keyPrefix = '/' + assetID + '/e'; 
	    PageReference assetPage = new PageReference(keyPrefix);
	    assetPage.getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
	    // assetPage.getParameters().put('00NV0000000Vtbx','null');// field id must be change for Production env.
	    //00N80000004j0TM //for Production
	    assetPage.getParameters().put('00N80000004j0TM','null');
        assetPage.getParameters().put('nooverride','1');
        assetPage.setRedirect(true);
        return assetPage;  
    }
  /*
  	Unit Test
  */  
   /* @isTest(SeeAllData=true)
 	static void AssetControllerTest1(){
 		Asset__c asst = new Asset__c();
        asst.Asset_Type__c = 'Hardware';
        asst.Sub_Asset_Type__c = 'Computer';
        asst.Manufacturer__c = 'Other';
        asst.Manufacturer_Other__c ='IBM';
        asst.Model__c ='Other';
        asst.Model_Other__c = 'IBM420';
        asst.Location__c ='Home Office';
        asst.Status__c = 'Deployed';
        insert asst;
       
       
      PageReference pageRef = Page.AssetClientPage;    
      Test.setCurrentPageReference(pageRef);  
      ApexPages.StandardController controller = new  ApexPages.StandardController ( asst );
      ApexPages.currentPage().getParameters().put('retURL', controller.getid());
      AssetController ac = new AssetController(controller);
      ac.callDispatcher();
 	}*/
}