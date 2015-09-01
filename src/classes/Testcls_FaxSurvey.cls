@isTest
private class Testcls_FaxSurvey {

    static testMethod void myUnitTest() {
    	Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.RecordTypeId  = '01280000000UERq';
        insert acctest; 
        
        Contact contObj = new Contact();
	    contObj.AccountId =  acctest.Id;
	    contObj.Email = 'abc1111@test.com';
	    contObj.LastName = 'Test Last1';
	    contObj.FirstName = 'Test First1';
      	insert contObj;
      	
      	cls_FaxSurvey obj = new cls_FaxSurvey();
        obj.recomRCRating = 'test';
        obj.ratingDescription = 'Test';
        obj.addCommentsValue = 'test';
        obj.custSupportValue = '3';
        obj.FeatFunctValue = '3';
        obj.easeImpValue = '3';
        obj.easeUseValue = '3';
        obj.custSupResValue = '3';
        obj.SubmitSurvey();
        
    }
}