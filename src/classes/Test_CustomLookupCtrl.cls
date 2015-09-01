/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_CustomLookupCtrl {

    public static testMethod void  CustomLookupCtrlTest2(){
 		
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
        
        PageReference pageRef = Page.CustomLookup;   
 		Test.setCurrentPageReference(pageRef);
 		 Apexpages.currentPage().getParameters().put('CF00N80000004j051_lkid',asst.id); // for production
    	//Apexpages.currentPage().getParameters().put('CF00NV0000000VnGy_lkid', asst.id);//for sb5
    	CustomLookupCtrl clc = new CustomLookupCtrl( null);
    	clc.onCancel();
       clc.onSave(); 
 	}	
 	
 	/*On in the case of Duplicate Exception*/
 	//@isTest(SeeAllData=true)
 	public static testMethod void  CustomLookupCtrlTest3(){
 		
 		Employee__c emp = new Employee__c();
        emp.First_Name__c = 'tuser';
        emp.Last_Name__c = 'lname';
        emp.Email__c ='clc@clc.com';
        emp.Location__c = 'Noida, India';
        emp.Department__c = 'IT';
        emp.Team__c = 'SE';
        emp.SPID__c = '12454';
        insert emp;
       
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
        
        EmployeeAssetJunction__c eaj = new  EmployeeAssetJunction__c();
        eaj.Asset__c = asst.id;
        eaj.IT_Team_Member__c = 'Prince F';
        eaj.Employee_Number__c = emp.id;
        insert eaj;
        
        EmployeeAssetJunction__c eaj1 = new  EmployeeAssetJunction__c();
        eaj1.Asset__c = asst.id;
        eaj1.IT_Team_Member__c = 'Prince F';
        eaj1.Employee_Number__c = emp.id;
       // insert eaj;
       
        
        PageReference pageRef = Page.CustomLookup;   
 		Test.setCurrentPageReference(pageRef);
       Apexpages.currentPage().getParameters().put('CF00N80000004j051_lkid',asst.id); // for production
    	//Apexpages.currentPage().getParameters().put('CF00NV0000000VnGy_lkid', asst.id);
    	CustomLookupCtrl clc = new CustomLookupCtrl( null);
    	clc.empAssetJunctionObj = eaj1;
    	clc.onSave();
        
 	}
 	/*On in the case of Date Exception*/
 	//@isTest(SeeAllData=true)
 	public static testMethod void  CustomLookupCtrlTest4(){
 		Employee__c emp = new Employee__c();
        emp.First_Name__c = 'tuser';
        emp.Last_Name__c = 'lname';
        emp.Email__c ='clc@clc.com';
        emp.Location__c = 'Noida, India';
        emp.Department__c = 'IT';
        emp.Team__c = 'SE';
        emp.SPID__c = '12454';
        insert emp;
       
        Asset__c asst = new Asset__c();
        asst.Asset_Type__c = 'Hardware';
        asst.Sub_Asset_Type__c = 'Computer';
        asst.Manufacturer__c = 'Other';
        asst.Manufacturer_Other__c ='IBM';
        asst.Model__c ='Other';
        asst.Purchase_Date__c = system.today();
        asst.Model_Other__c = 'IBM420';
        asst.Location__c ='Home Office';
        asst.Status__c = 'Deployed';
        insert asst;
        
        EmployeeAssetJunction__c eaj = new  EmployeeAssetJunction__c();
        eaj.Asset__c = asst.id;
        eaj.IT_Team_Member__c = 'Prince F';
        eaj.Employee_Number__c = emp.id;
        eaj.Asset_Assigned_Date__c = system.today() - 1;
                
        
        PageReference pageRef = Page.CustomLookup;   
 		Test.setCurrentPageReference(pageRef);
 		 Apexpages.currentPage().getParameters().put('CF00N80000004j051_lkid',asst.id); // for production
    	//Apexpages.currentPage().getParameters().put('CF00NV0000000VnGy_lkid', asst.id);
    	CustomLookupCtrl clc = new CustomLookupCtrl( null);
    	clc.empAssetJunctionObj = eaj;
    	clc.onSave();
 	}
 	
 	/*On in the case of other Exception*/
 	//@isTest(SeeAllData=true)
    public static testMethod void  CustomLookupCtrlTest5(){
 		Asset__c asst = new Asset__c();
        asst.Asset_Type__c = 'Hardware';
        asst.Sub_Asset_Type__c = 'Computer';
        asst.Manufacturer__c = 'Other';
        asst.Manufacturer_Other__c ='IBM';
        asst.Model__c ='Other';
        asst.Purchase_Date__c = system.today();
        asst.Model_Other__c = 'IBM420';
        asst.Location__c ='Home Office';
        asst.Status__c = 'Deployed';
        insert asst;
 		
 		PageReference pageRef = Page.CustomLookup;   
 		Test.setCurrentPageReference(pageRef);
 		 Apexpages.currentPage().getParameters().put('CF00N80000004j051_lkid',asst.id); // for production
 		//Apexpages.currentPage().getParameters().put('CF00NV0000000VnGy_lkid', asst.id);
    	CustomLookupCtrl clc = new CustomLookupCtrl( null);
    	clc.empAssetJunctionObj = null;
    	clc.onSave();
 	
 	}	
 		
}