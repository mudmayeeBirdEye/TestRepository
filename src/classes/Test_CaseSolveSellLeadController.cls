@isTest
private class Test_CaseSolveSellLeadController  {    
static testMethod void myUnitTest() {
             Lead  r = new Lead();   
           r.FirstName='testabc';
           r.lastName ='testxyz';
           r.Leadsource ='abcd';
           r.Agent_Email_Address__c ='xyz';
           r.Phone='123654789';
           r.Email='Test@Test.com';
           ApexPages.StandardController sc = new ApexPages.standardController(r);
           CaseSolveSellLeadController rc = new CaseSolveSellLeadController(sc);
           rc.saveLead();
           rc.searchLeads();
           rc.testingEdgeData011();
           Lead  ref = rc.getnewlead();
           Boolean b = rc.getisLeadSaved();
           b = rc.getuserIdNotFound();
           b = rc.getisFirstNameFilled();
           b = rc.getisLastNameFilled();       
           b = rc.getisCompanyFilled();
           b= rc.getisEmailFilled();
           b = rc.getisPhoneFilled();
           b= rc.getisAgentMailFilled();
        
        }
     }