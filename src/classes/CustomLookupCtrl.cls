public with sharing class CustomLookupCtrl {
	
	public EmployeeAssetJunction__c empAssetJunctionObj {get;set;}
	private Asset__c asset {get;set;}
	private ApexPages.StandardController sc {get;set;}
	private String recordId {get;set;}

/*
* Constructor
*  IT_Team_Member__c : For edit record, wipe the field automatically. So user has to pick again before saving the change. 
*/
  	public CustomLookupCtrl(ApexPages.StandardController stdController) {
	    
	     if(ApexPages.currentPage().getParameters().get('id') != null) {
	     	recordId = ApexPages.currentPage().getParameters().get('retURL');
	     	empAssetJunctionObj = [SELECT 
	     								Id, 
	     								Name, 
	     								Employee_Number__c,	
	     								Asset__c, 
	     								Asset_Assigned_Date__c,
	     								IT_Team_Member__c,
	     								Jira__c
	     						   FROM 
	     						   		EmployeeAssetJunction__c 
	     					       WHERE
	     					       		id =: ApexPages.currentPage().getParameters().get('id')];
	     	empAssetJunctionObj.IT_Team_Member__c = null;
	     	sc = new ApexPages.StandardController( empAssetJunctionObj );
	       } else {
	       	 asset = new Asset__c();
		     empAssetJunctionObj = new EmployeeAssetJunction__c();
		    //CF00N80000004j051_lkid  for production
		 	 recordId = ApexPages.currentPage().getParameters().get('CF00N80000004j051_lkid');
			//recordId = ApexPages.currentPage().getParameters().get('CF00NV0000000VnGy_lkid');//for Sandbox5
		   	try { asset = [Select Id From Asset__c Where ID =: recordId]; 
		     empAssetJunctionObj.Asset__c =  asset.id;
		     sc = new ApexPages.StandardController( asset );
		    } catch (Exception e) {}
	     }
  	}
/*
 * On save action
 * Usert DML is use for both edit and create action
*/
  	public PageReference onSave(){
  		if (  empAssetJunctionObj != null ) {
  			try {
  				upsert empAssetJunctionObj;
  				return sc.view();
  			  } catch ( Exception ex ) {
  				if( ex.getMessage().contains('DUPLICATE_VALUE')){
  					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate Employee Number' ));	
  				} else if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
  			 		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Asset assignment cannot be less than asset purchase date.'  ));
  				} else{
  					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage() ));
  				}	
  			 	return null;
  			}	
  		} 
  	return null;	
  	}
/*
* on cancel action
* redirct to parent object (view) e.g. asset
*/
  	public PageReference onCancel(){
  		PageReference onCancel = new PageReference('/'+recordId);
  		return onCancel;
  	}

/*
* Unit Test Methods
*/

 /*on edit operation*/
//  @isTest(SeeAllData=true)
/* public static testMethod void  CustomLookupCtrlTest1(){
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
       
    PageReference pageRef = Page.CustomLookup;    
    Test.setCurrentPageReference(pageRef);
    Apexpages.currentPage().getParameters().put('id',eaj.id);
    
    CustomLookupCtrl clc = new CustomLookupCtrl( null);
      clc.onCancel();
      clc.onSave();  
	}*/
	
	/*On new create operation*/
	//@isTest(SeeAllData=true)
 	/*public static testMethod void  CustomLookupCtrlTest2(){
 		
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
 	}*/	
 	
 	/*On in the case of Duplicate Exception*/
 	//@isTest(SeeAllData=true)
 	/*public static testMethod void  CustomLookupCtrlTest3(){
 		
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
        
 	}*/
 	/*On in the case of Date Exception*/
 	//@isTest(SeeAllData=true)
 	/*public static testMethod void  CustomLookupCtrlTest4(){
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
 	}*/
 	
 	/*On in the case of other Exception*/
 	//@isTest(SeeAllData=true)
   /* public static testMethod void  CustomLookupCtrlTest5(){
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
 	
 	}*/	
 		
 	
}