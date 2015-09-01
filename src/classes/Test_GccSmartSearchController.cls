@isTest
public class Test_GccSmartSearchController {
	static void createCampaignData(){
		Campaign campObj1 = new Campaign(Name='TestCampaign',DNIS__c='123456',Description ='This is test campaign' ,IsActive=true);
		insert campObj1;
	}
 static void createSobjectData(Map<String,Object> paramMap){
	List<Sobject> sobjList = new List<Sobject>();
    System.debug(paramMap);
    Integer count = (Integer)paramMap.get('sobjCount');
    String SobjectName = (String)paramMap.get('ObjectName');
    Map<String,Object> valueMap = (Map<String,Object>)paramMap.get('valueMap');
    Map<String,Schema.SObjectType> sobjectMap = Schema.getGlobalDescribe();
		if(count != null && count > 0){
			for(Integer i =0 ;i<count;i++){
                String finalName = '';
                if(valueMap.containsKey('Name')){
                	finalName = String.format((String)valueMap.get('Name'),new LIST<String> {SobjectName,String.valueof(i)});    
                }
                Sobject tempSobject =  sobjectMap.get(SobjectName).newSObject();
                
                for(String key : valueMap.keyset()){
                    if(key.equals('Name')){
                        tempSobject.put(key,finalName);
                    }else{
                        tempSobject.put(key,valueMap.get(key));
                    }
                }
                sobjList.add(tempSobject);
			}
            insert sobjList;
		}
		
	}
    static testMethod void testGccSmartSearchController() {
        PageReference pageRef = Page.GccSmartSearch;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('dnis', '123456');
        ApexPages.currentPage().getParameters().put('cid', '12345678');
        ApexPages.currentPage().getParameters().put('skill', 'testSkill');
        GccSmartSearchController controller = new GccSmartSearchController();
        System.assertEquals('accountNumber', controller.searchChoice); 
        System.assertEquals('123456', controller.paramClass.dnis);
        System.assertEquals('12345678', controller.paramClass.inContactId);
        System.assertEquals('testSkill', controller.paramClass.skillName);
        System.assertEquals('Campaign not found.',controller.paramClass.campaignName);
        //creating campaign to test capmpaign query and result itteration
        createCampaignData();
        controller = new GccSmartSearchController();
        System.assertNotEquals('Campaign not found.',controller.paramClass.campaignName);
        
    }
    
    static testMethod void testMethod_searchAccount(){
    	PageReference pageRef = Page.GccSmartSearch;
        Test.setCurrentPage(pageRef);
        GccSmartSearchController controller = new GccSmartSearchController();
        //-------searchValue is blank----------------------------------------
        controller.searchValue = '';
        controller.searchAccount();
        System.assertEquals('Please enter some search text !!', controller.errorMsg);
        //-------without accounts records------------------------------------
        controller.searchValue = '1234567';
        controller.searchAccount();
        System.assertEquals('There are no records of account for your search text!!', controller.errorMsg);
        //-------When there is only one account------------------------------
        Map<String,Object> paramMapToPass = new Map<String,Object> {
  		'ObjectName' => 'Account',
    	'sobjCount'  => 1,
        'valueMap'	 => new Map<String,Object>{
            'Name' => 'Test{1}FromTestClass{2}',
            'RC_Account_Status__c' => 'Paid',
            'RC_Brand__c' => 'RingCentral',
            'Service_Type__c' => 'RC Office',
            'RC_Tier__c' => 'testTier',
            'Total_DLs__c' => 10,
            'Account_Mobile_Number__c' => '1234567890',
            'RC_Account_Number__c'	=> '123456789'
        	}
		};
		createSobjectData(paramMapToPass);
		//----------------Check for phone search------------------------------
        controller.searchValue = '1234567890';
        controller.searchChoice = 'phone';
        controller.searchAccount();
        System.assertEquals('Parent', controller.detailsClass.parentChildValue);
        System.assert(true, controller.showDetails);
        System.assert(controller.showNoAccount==false);
        System.assert(controller.showList==false);
       
        //----------------Check for account number search------------------------------
        controller.searchValue = '123456789';
        controller.searchChoice = 'accountNumber';
        controller.searchAccount();
        System.assertEquals('Parent', controller.detailsClass.parentChildValue);
        System.assert(true, controller.showDetails);
        System.assert(controller.showNoAccount==false);
        System.assert(controller.showList==false);
        
        //---------------Test For multiple search accounts-----------------------------
        paramMapToPass.put('sobjCount',5);
        createSobjectData(paramMapToPass);
        controller.searchValue = '1234567890';
        controller.searchChoice = 'phone';
        controller.searchAccount();
        System.assert(true, controller.showList);
        System.assert(controller.showDetails==false);
        System.assert(controller.showNoAccount==false);
        //-------------Test for user selected account detail show-----------------------
        List<Account> accList = [SELECT Id,Name from Account LIMIT 10];
        controller.selectedAccount = accList.get(0).Id;
        controller.showAccount();
        System.assert(true, controller.showDetails);
        System.assert(controller.showNoAccount==false);
        System.assert(true, controller.showList);
        
    }
}