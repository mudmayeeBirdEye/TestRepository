/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_Employee {

	static testMethod void Test_employeedetails2012new() {
	     Employee__c objEmp=new Employee__c();   
         employeedetails2012new  obj2=new employeedetails2012new ();
         ApexPages.StandardController controller=new ApexPages.StandardController(objEmp);
         employeedetails2012new obj=new employeedetails2012new (controller);
         System.currentPagereference().getParameters().put('id','123345');
         Test.startTest();
         obj.getEmpDetails();
         obj.getPeers();
         obj.getMgdTeams();
         Test.stopTest();
    }
 	
 	static testMethod void Test_employeedetailsnew() {
        ApexPages.currentPage().getHeaders().put('True-Client-IP','38.109.202.162');
		Employee__c objEmp=new Employee__c();
		employeedetailsnew  obj2=new employeedetailsnew ();
		ApexPages.StandardController controller=new ApexPages.StandardController(objEmp);
        employeedetailsnew obj=new employeedetailsnew (controller);
        System.currentPagereference().getParameters().put('empId','123345');
        Test.startTest();
        obj.getEmpDetails();
        obj.getPeers();
        obj.getMgdTeams();
        obj.getShowDirectory();
        obj.showEmployeeDetails();
        obj.getImageID();
        obj.getEmpID();
        obj.getEmpName();
        obj.getEmpNickName();
        obj.getTitle();
        obj.getTitle();
        obj.getEmpEmail();
        obj.getPhoneWork();
        obj.getExtension();
        obj.getPhoneCell();
        obj.getLocation();
        obj.getImId();
        obj.getHireDate();
        obj.IsManager();
        obj.getManagerId();
        obj.getManagerName();
        obj.getMgrEmail();
        obj.getDepartment();
        obj.getDivision();
        obj.getTeam();
        obj.getSkills();
        obj.getempDet();
        obj.getAuthorizationError();
        
		ApexPages.currentPage().getHeaders().put('True-Client-IP','24.221.196.119');
		Employee__c objEmp3=new Employee__c();
		//employeedetailsnew  obj2=new employeedetailsnew ();
		ApexPages.StandardController controller3=new ApexPages.StandardController(objEmp3);
        employeedetailsnew obj3=new employeedetailsnew (controller3);
    	obj3.getShowDirectory();
    	
    	ApexPages.currentPage().getHeaders().put('True-Client-IP','202.136.40.120');
		Employee__c objEmp4=new Employee__c();
		ApexPages.StandardController controller4=new ApexPages.StandardController(objEmp4);
        employeedetailsnew obj4=new employeedetailsnew (controller4);
    	obj4.getShowDirectory();
    	
    	ApexPages.currentPage().getHeaders().put('True-Client-IP','216.156.83.186');
		Employee__c objEmp5=new Employee__c();
		ApexPages.StandardController controller5=new ApexPages.StandardController(objEmp5);
        employeedetailsnew obj5=new employeedetailsnew (controller5);
    	obj5.getShowDirectory();
    	
    	ApexPages.currentPage().getHeaders().put('True-Client-IP','212.119.180.46');
		Employee__c objEmp6=new Employee__c();
		ApexPages.StandardController controller6=new ApexPages.StandardController(objEmp6);
        employeedetailsnew obj6=new employeedetailsnew (controller6);
    	obj5.getShowDirectory();
    	Test.stopTest();
    }
    static testMethod void Test_employeesearchdrill2012New() {
         ApexPages.currentPage().getHeaders().put('True-Client-IP','119.93.30.162');
         Employee__c objEmp=new Employee__c();
         ApexPages.StandardController controller=new ApexPages.StandardController(objEmp);
         employeesearchdrill2012New obj=new employeesearchdrill2012New ();
         Test.startTest();
         obj.showEmployeeByText();
         obj.gettrueIP();
         obj.getShowDirectory();
         obj.isIPExist('107.0.179.57');
         obj.getTeam();
         String[] str=new List<String>();
         obj.setTeam(str);
         obj.setDivision(str);
         obj.getDivisionValues();
        obj.getCountries();
        obj.getManagerAll1();
        obj.getTotalTeamValues();
        obj.getTeamValues1();
        obj.getTotalDepartmentValues();
        obj.getDepartment1();
        obj.strEmployee='test test';
        obj.strEmployee='test test';
        obj.seletedManager='test test';
        obj.seletedTeam='test test';
        obj.seletedDepartment='test test';
        obj.getIntCount();
        obj.setCountries(str);
        obj.getManager();
        obj.setManager(str);
        obj.doSearch1();
        
        ApexPages.currentPage().getHeaders().put('True-Client-IP','119.93.302.163');
		Employee__c objEmp1=new Employee__c();
		ApexPages.StandardController controller1=new ApexPages.StandardController(objEmp1);
		employeesearchdrill2012New obj1=new employeesearchdrill2012New ();
		obj1.getShowDirectory();
		Test.stopTest();
    }
     static testMethod void Test_employeesearchdrillNew() {
     	
        ApexPages.currentPage().getHeaders().put('True-Client-IP','38.111.202.162');
		Employee__c objEmp=new Employee__c();
		ApexPages.StandardController controller=new ApexPages.StandardController(objEmp);
		employeesearchdrillNew obj=new employeesearchdrillNew(controller);
         
        // ApexPages.currentPage().getParameters().put('id')
        Test.startTest();
		obj.showEmployeeByText();
		obj.gettrueIP();
		obj.getShowDirectory();
		obj.getTeam();
		String[] str=new List<String>();
		obj.setTeam(str);
		obj.getDivision();
		           
		obj.setDivision(str);
		obj.getDivisionValues();
		obj.getCountries();
		obj.getManagerAll();
		obj.getTotalTeamValues();
		obj.getTeamValues();
		obj.getTotalDepartmentValues();
		obj.getDepartment();
		obj.strEmployee='test test';
		obj.strEmployee='test test';
		obj.seletedManager='test test';
		obj.seletedTeam='test test';
		obj.seletedDepartment='test test';
		obj.getStrEmpNo();
		obj.setStrEmpNo('1233');
		obj.getIntCount();
		obj.setCountries(str);
		obj.getManager();
		obj.setManager(str);
		obj.doSearch1();
        Test.stopTest();
   }
}