/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestUpdateCsv {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Lead leadObj = new Lead();
       	leadObj.LeadSource = 'About To be Cancelled'; 
        leadObj.ATBC_Stage__c = 'WIP';
        leadObj.IsConverted = false;
        leadObj.User_ID__c = UserInfo.getUserId();
        leadObj.FirstName='Virendra';
        leadObj.LastName='Singh';
        leadObj.Company='Simplion';
        leadObj.Email='vps@sss.ss221.com';
        leadObj.Phone='9910106804';
        insert leadObj;
        Folder fd = [SELECT Id FROM Folder WHERE Name='LeadSourceMap' LIMIT 1];
        String blbObj='Field Name,#,Bad Values,Good Values,#,#EOL#\r\n'+'NumberOfEmployees__c,#,15-39,#,20-49,#,#EOL#\r\n'+'Job_Function__c,#,CEOO,#,Owner/President/CEO,#,#EOL#\r\n'+'Purchase_Timeframe__c,#,In One Day,#,Less than 1 month,#,#EOL#\r\n'+'Industry,#,IT,#,Consulting: IT,#,#EOL#\r\n';
        Document doc= new Document(Name='No_Employee_Mapping', Body=blob.valueOf(blbObj),folderId=fd.Id,isPublic=true,type='csv' ); 
          insert doc;
        Lead_Field_Correct_Value__c correctsetting = new Lead_Field_Correct_Value__c();
        correctsetting.Name='Job Function';
        correctsetting.Field_Value__c='Owner/President/CEO;IT Director/VP; IT Staff/Manager;IT Consultant;CIO/CTO;Admin/Office/Facilities Manager;Other Management/VP/CxO;Other';
        insert correctsetting;
        list<Lead_Field_Map__c> lstsetting = new list<Lead_Field_Map__c>();
        Lead_Field_Map__c setting = new Lead_Field_Map__c();
		setting.Name = '1';
		setting.Api_Name__c = 'Industry';
		lstsetting.add(setting);
		Lead_Field_Map__c setting1 = new Lead_Field_Map__c();
		setting1.Name = '2';
		setting1.Api_Name__c = 'NumberOfEmployees__c';
		lstsetting.add(setting1);
		Lead_Field_Map__c setting2 = new Lead_Field_Map__c();
		setting2.Name = '3';
		setting2.Api_Name__c = 'Job_Function__c';
		lstsetting.add(setting2);
		Lead_Field_Map__c setting3 = new Lead_Field_Map__c();
		setting3.Name = '5';
		setting3.Api_Name__c = 'Purchase_Timeframe__c';
		lstsetting.add(setting3);
		insert lstsetting;
        ApexPages.StandardController sc = new ApexPages.StandardController(leadObj);
        UpdateCsv testUpdCsv = new UpdateCsv(sc);
        testUpdCsv.getNewGoodValue();
        testUpdCsv.reset();
        testUpdCsv.fieldSearch='NumberOfEmployees__c';
        testUpdCsv.badValSearch='';
        testUpdCsv.csvSearch();
        testUpdCsv.badValSearch='CEOO';
        testUpdCsv.csvSearch();
        testUpdCsv.goodValSearch='20-49';
        testUpdCsv.csvSearch();
        testUpdCsv.delId=1;
        testUpdCsv.deleteRow();
        testUpdCsv.updateDocCsv();
        testUpdCsv.addColumn();
        
    }
}