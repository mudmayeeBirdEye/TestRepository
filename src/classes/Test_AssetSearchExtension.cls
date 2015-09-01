/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_AssetSearchExtension {

    static testMethod void TestAssetSearchExtension() {
       
	 	try {
	 		  Asset__c objAsset= new Asset__c();//(Asset__c)SmartFactory.createSObject('Asset__c', true);
		      objAsset.Location__c = 'Odessa';
		      objAsset.Asset_Tag__c ='Test';
		      objAsset.Asset_Type__c = 'asset';
		      objAsset.Sub_Asset_Type__c = 'other';
		      objAsset.Manufacturer__c= 'other';
		      objAsset.Manufacturer_Other__c ='test';
		      objAsset.Model__c = 'Other';
		      objAsset.Model_Other__c = 'test1';
		      objAsset.Department__c = 'Information Technology';  
		      //objAsset.Porting_Phone_to_be_Ported__c = 1234;
		      insert objAsset;
		      system.debug('====================='+objAsset.id);
		         
		      EmployeeAssetJunction__c objEmployeeAssetJunction = new EmployeeAssetJunction__c();//(EmployeeAssetJunction__c)SmartFactory.createSObject('EmployeeAssetJunction__c', true);
		      objEmployeeAssetJunction.Asset__c = objAsset.id;
		       
		      insert objEmployeeAssetJunction;
		     
		      List<Asset__c> lst=new  List<Asset__c>();
		      lst.add(objAsset);
		      ApexPages.StandardSetController controller=new ApexPages.StandardSetController(lst);
		     
		      AssetSearchExtension obj=new AssetSearchExtension(controller);
		      obj.searchAsset();
		      obj.ClearAsset();
		      obj.globalSearch();
		      obj.ClearAsset1();
		     
		      obj.allFieldSearchVal = 'Information';
		      obj.globalSearch();
		     
		      obj.onOptionChange();
		     
		      obj.objAsset=new Asset__c();
		      obj.strAssetNumber=''+objAsset.Name;
		      obj.strEmployeeLastName='testEmp';
		      obj.objAsset.Location__c=objAsset.Location__c;
		      obj.objAsset.Model__c=objAsset.Model__c;
		      obj.objAsset.Serial_Number__c=objAsset.Serial_Number__c;
		      obj.objAsset.Network_Name__c=objAsset.Network_Name__c;
		      obj.objAsset.Department__c=objAsset.Department__c;
		      obj.objAsset.Asset_Type__c=objAsset.Asset_Type__c;
		      obj.objAsset.Sub_Asset_Type__c=objAsset.Sub_Asset_Type__c;
		      obj.objAsset.Manufacturer__c=objAsset.Manufacturer__c;
		     
		      obj.searchAsset();
		    
		      obj.isUnAssigned=true;
		      obj.selectedOperator='notequal';
		      obj.searchAsset();
		     
		      Employee__c objEmployees= (Employee__c )SmartFactory.createSObject('Employee__c', true);
		      objEmployees.Last_Name__c ='testEmp';
		      objEmployees.SPID__c='test';
		      objEmployees.EmpID__c='emp10';
		      objEmployees.Email__c='kanishk.singh@simplion.comemp';
		      upsert objEmployees;
		      System.assert(objEmployees.id!=null);
		    
		      objEmployeeAssetJunction.Employee_Number__c=objEmployees.id;
		      upsert objEmployeeAssetJunction;
		      
		      obj.objAsset=new Asset__c();
		      obj.isUnAssigned=false;
		      obj.strEmployeeLastName=objEmployees.Last_Name__c;
		      obj.searchAsset();
		        
		      obj.strEmployeeLastName='\'123\'';
		      obj.searchAsset();	
	 	} catch(exception ex) {}
	 
    }
}