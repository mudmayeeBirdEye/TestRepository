@isTest
// This class is bound to API version 16.0 by Version Settings
private class employeedetail_Test
{
static testMethod void employeedetail_TestMethod() {
Employee__c emp = new Employee__c();
String empId;
List<Employee__c> peers;
empId = '1230';
String strTestgetEmpID;
String strTestgetEmpName;
String strTestgetTitle;
String strTestgetEmpEmail;
String strTestgetPhoneWork;

String strTestgetPhoneCell;
String strTestgetLocation;
String strTestgetManagerId;
String strTestgetManagerName;
String strTestgetMgrEmail;
String strTestgetDepartment;
String strTestgetDivision;
String strTestgetTeam;
String strTestgetSkills;
Boolean showDirectory;
Boolean authError;



//employeedetails testEmpDet = new employeedetails(new ApexPages.StandardController(emp));
employeedetails testEmpDetDefault = new employeedetails();

//emp = [SELECT id,EmpID__c, First_Name__c, Last_Name__c, Title__c, Email__c, Phone_Work__c, Extension__c, Phone_Cell__c, Location__c, Manager_Employee_Number_Lookup__r.First_Name__c, Manager_Employee_Number_Lookup__r.Last_Name__c, Department__c,Division__c, Skills__c, Team__c,  User__c, ImageID__c, Manager_Employee_Number__c, Manager_Employee_Number_Lookup__r.Email__c , Manager_Employee_Number_Lookup__r.EmpID__c   FROM Employee__c where EmpID__c='1271'];
//peers =  [SELECT EmpID__c, First_Name__c, Last_Name__c FROM Employee__c  where EmpID__c <> '1271' order by First_Name__c asc ] ;

testEmpDetDefault.getImageID();
testEmpDetDefault.getPeers();

strTestgetEmpID = testEmpDetDefault.getEmpID();
strTestgetEmpName= testEmpDetDefault.getEmpName();
strTestgetTitle= testEmpDetDefault.getTitle();
strTestgetEmpEmail= testEmpDetDefault.getEmpEmail();
strTestgetPhoneWork= testEmpDetDefault.getPhoneWork();

strTestgetPhoneCell= testEmpDetDefault.getPhoneCell();
strTestgetLocation = testEmpDetDefault.getLocation();
strTestgetManagerId= testEmpDetDefault.getManagerId();
strTestgetManagerName= testEmpDetDefault.getManagerName();
strTestgetMgrEmail= testEmpDetDefault.getMgrEmail();
strTestgetDepartment= testEmpDetDefault.getDepartment();
strTestgetDivision= testEmpDetDefault.getDivision();
strTestgetTeam= testEmpDetDefault.getTeam();
strTestgetSkills= testEmpDetDefault.getSkills();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '216.156.83.186');
showDirectory = testEmpDetDefault.getShowDirectory();
authError = testEmpDetDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '123.456.68.86');
showDirectory = testEmpDetDefault.getShowDirectory();
authError = testEmpDetDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '66.238.90.13');
showDirectory = testEmpDetDefault.getShowDirectory();
ApexPages.currentPage().getHeaders().put('True-Client-IP', '65.205.207.12');
showDirectory = testEmpDetDefault.getShowDirectory();
ApexPages.currentPage().getHeaders().put('True-Client-IP', '65.113.43.20');
showDirectory = testEmpDetDefault.getShowDirectory();
ApexPages.currentPage().getHeaders().put('True-Client-IP', '67.103.123.4');
showDirectory = testEmpDetDefault.getShowDirectory();
ApexPages.currentPage().getHeaders().put('True-Client-IP', '198.107.149.');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '216.156.83.186');
showDirectory = testEmpDetDefault.getShowDirectory();
authError = testEmpDetDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '123.456.68.86');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '198.107.149.243');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '65.205.207.123');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '66.238.90.13');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '65.113.43.20');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '67.103.123.4');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '198.107.149.');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '119.93.30.');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '202.136.40.');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '212.119.180.46');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '212.119.189.');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '79.142.83.118');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '217.79.3.62');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '193.104.181.');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '195.114.135.');
showDirectory = testEmpDetDefault.getShowDirectory();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '195.138.74.');
showDirectory = testEmpDetDefault.getShowDirectory();

Employee__c newEmp = [SELECT id,Name FROM Employee__c WHERE Name='1049'];
ApexPages.currentPage().getParameters().put('empId','1049');

ApexPages.StandardController sc = new ApexPages.standardController(newEmp);
employeedetails testEmpDetDefault2 = new employeedetails(sc);


}
}