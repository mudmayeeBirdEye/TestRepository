/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and Created on 10th feb 2014.
 */
@isTest  
public class TestPop{
     static testMethod void myUnitPopUp() {
        try {
        	Lead_Assignment_Rules__c leadAssRul = new Lead_Assignment_Rules__c();
        	leadAssRul.Name ='testLead';
        	leadAssRul.Folder__c ='A';      	
            Insert leadAssRul;
            
            ApexPages.currentPage().getParameters().put('retURL','retURL');
            ApexPages.currentPage().getParameters().put('CF00N80000004kQjV','param1');
            ApexPages.currentPage().getParameters().put('CF00N80000004kQjV_lkid','param2'); 
            ApexPages.currentPage().getParameters().put('CF00N80000004kQja','param3');
            ApexPages.currentPage().getParameters().put('CF00N80000004kQja_lkid','param4'); 
            
            Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(leadAssRul);   
            LARPopupExtension popUpObj = new LARPopupExtension(controller);
            Test.startTest();
            popUpObj.redirectTOLARCall();
            popUpObj.redirectTORTNCall();
            popUpObj.showPopup();
            popUpObj.searchAndfind();
            Test.stopTest();
       } catch(Exception e){}
   }
}