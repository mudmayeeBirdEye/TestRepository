@isTest
// This class is bound to API version 16.0 by Version Settings
private class employeesearchdrill_Test
{
static testMethod void employeesearchdrill_TestMethod() {
Employee__c emp = new Employee__c();

List<Employee__c> listTestemployees;
String strTestgetStrEmpNo;
Integer intTestgetCount;
List<String>  listTestgetDepartment;
List<SelectOption> listTestgetItems;
String[] TestgetCountries;

//String[] testDep = new String[4];
//testDep[0] = 'sales'; 
//testDep[1] = 'IT';





List<String>  listTestgetDivisionValues;
List<SelectOption> listTestgetDivisionItems;
String[] strTestgetDivision;
List<String>  listTestgetTeamValues;
List<SelectOption> listTestgetTeamItems; 
String[] strTestgetTeam; 
List<Employee__c> listTestgetManagerAll;
List<SelectOption> listTestgetManagerItems;
String[] strTestgetManager;
Boolean showDirectory;
Boolean authError;


//employeedetails testEmpDet = new employeedetails(new ApexPages.StandardController(emp));
employeesearchdrill testEmpSearchDefault = new employeesearchdrill();

testEmpSearchDefault.doSearch();


strTestgetStrEmpNo = testEmpSearchDefault.getStrEmpNo();
testEmpSearchDefault.setStrEmpNo('1270');

String[] countriesTemp = new List<String>(); 
countriesTemp.add('sales');
testEmpSearchDefault.setCountries(countriesTemp);
testEmpSearchDefault.doSearch();

listTestemployees = testEmpSearchDefault.getEmployees();

intTestgetCount = testEmpSearchDefault.getIntCount();
listTestgetDepartment = testEmpSearchDefault.getDepartment();
listTestgetItems = testEmpSearchDefault.getItems();
TestgetCountries = testEmpSearchDefault.getCountries();
//setCountries(testDep);
//setCountries(listTestgetCountries);
listTestgetDivisionValues = testEmpSearchDefault.getDivisionValues();
listTestgetDivisionItems = testEmpSearchDefault.getDivisionItems();
strTestgetDivision = testEmpSearchDefault.getDivision();

listTestgetTeamValues = testEmpSearchDefault.getTeamValues();
//listTestgetTeamItems = testEmpSearchDefault.getTeamItems();

strTestgetTeam = testEmpSearchDefault.getTeam();
//listTestgetManagerAll = testEmpSearchDefault.getManagerAll();

//listTestgetManagerItems = testEmpSearchDefault.getManagerItems();
strTestgetManager = testEmpSearchDefault.getManager();


ApexPages.currentPage().getHeaders().put('True-Client-IP', '216.156.83.186');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '123.456.68.86');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '198.107.149.243');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '65.205.207.123');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '66.238.90.13');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '65.113.43.20');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '67.103.123.4');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '198.107.149.');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '119.93.30.');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '202.136.40.');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '212.119.180.46');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '212.119.189.');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '79.142.83.118');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '217.79.3.62');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '193.104.181.');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '195.114.135.');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();

ApexPages.currentPage().getHeaders().put('True-Client-IP', '195.138.74.');
showDirectory = testEmpSearchDefault.getShowDirectory();
authError = testEmpSearchDefault.getAuthorizationError();
}
}