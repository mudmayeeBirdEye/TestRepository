/*-----------------------------------------------------------------------------
* Case Name.............: Sales Battle Cards                    
* Case Number...........: 02577716                                            *
* File..................: TestSalesBattleCards                                *
* Created by............: Simplion Technologies                               *
* Created Date..........: 27-06-2014                                          *
* Last Modified by......: Simplion Technologies                               *
------------------------------------------------------------------------------>*/
@isTest()
private class TestSalesBattleCards{
    static testMethod void unitTestSalesBattleCards() {
        try{  
            Industry__c Indst = new Industry__c();
            Indst.Name='Test';
            Indst.How_the_Phone_system_works__c='Test3';
            Indst.Industry_Pain_Point__c = 'Test34';
            Indst.Pain_Reliever__c ='Test-TEst45';
            Indst.Web_Resource__c ='https://www.google.com';
            Indst.What_it_is__c = 'Testd';
            insert Indst;
            
            /* Extension class of Industry    */
            IndustryListViewControlr IndstLstvwCont = new IndustryListViewControlr(new ApexPages.StandardController(Indst));
            String  myIndustryName='Kailasha';  
            Test.startTest();
            IndstLstvwCont.getIndustry(myIndustryName);
            Test.stopTest();    
        } Catch(Exception ex){}         
     }
}