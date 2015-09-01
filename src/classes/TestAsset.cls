@isTest
private class TestAsset {

    static testMethod void assetEmployeeUnitTest() {
      	  try {
      	  		Asset__c asst = new Asset__c();
		        asst.Asset_Type__c = 'Hardware';
		        asst.Sub_Asset_Type__c = 'Computer';
		        asst.Manufacturer__c = 'Other';
		        asst.Manufacturer_Other__c = 'IBM';
		        asst.Model__c = 'Other';
		        asst.Model_Other__c = 'IBM420';
		        asst.Location__c = 'Home Office';
		        asst.Status__c = 'Deployed';
		        asst.Purchase_Date__c = System.today() - 15;
		        insert asst;
		        
		        Employee__c empObj = new Employee__c();
		        empObj.First_Name__c = 'TestEMP';
		        empObj.Last_Name__c = 'TestLast';
		        empObj.Email__c = 'test@test.com';
		        empObj.Location__c = 'Denver, US';
		        empObj.Department__c = 'Business Services';
		        empObj.Division__c = 'Coaching';
		        empObj.Team__c = 'Development Bay';
		        empObj.SPID__c = '58';
		        insert  empObj;
		        
		        Employee__c empObj1 = new Employee__c();
		        empObj1.First_Name__c = 'TestEMP1';
		        empObj1.Last_Name__c = 'TestLast1';
		        empObj1.Email__c = 'test1@test.com';
		        empObj1.Location__c = 'Denver, US';
		        empObj1.Department__c = 'Business Services';
		        empObj1.Division__c = 'Coaching';
		        empObj1.Team__c = 'Development Bay';
		        empObj1.SPID__c = '59';
		        insert  empObj1;
		        
		        Test.startTest();
      	  		AddEditEmployeeAssetCtrl assesEmpObj = new AddEditEmployeeAssetCtrl(new ApexPages.StandardController(new EmployeeAssetJunction__c()));
      	  		assesEmpObj.empAssetObj.Employee_Number__c  = empObj.Id;
      	  		assesEmpObj.empAssetObj.Asset__c = asst.Id;
      	  		assesEmpObj.onSave();
      	  		ApexPages.currentPage().getParameters().put('clone', '1');
      	  		assesEmpObj.empAssetObj.Employee_Number__c  = empObj1.Id;
      	  		assesEmpObj.empAssetObj.Asset__c = asst.Id;
      	  		assesEmpObj.onSave();
      	  		assesEmpObj.onCancel();
      	  		assesEmpObj.onSave();
      	  		assesEmpObj.empAssetObj.Asset_Assigned_Date__c = System.today() - 20;
      	  		assesEmpObj.onSave();
      	  		Test.stopTest();
      	  } catch(Exception ex) {
      	  	
      	  }
    }
}