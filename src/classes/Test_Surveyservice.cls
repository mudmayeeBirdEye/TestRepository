@isTest
private class Test_Surveyservice {

    static testMethod void TestSurveyservice() {
    	try{
    		Account a = new Account();
			a.Name = 'TestbyJesse';
	        a.RC_User_ID__c = '345';
	        insert a;
	        
	        Contact c = new Contact();
	        c.LastName = 'contactLast';
	        c.AccountId = [SELECT id FROM Account WHERE name=: a.Name].id;
	        c.email='test@rc.com';
	        insert c;
			Survey__c surveyObj = new Survey__c();
			surveyObj.Contact__c = c.Id;
			surveyObj.SurveyType__c = 'Porting';
			insert surveyObj;
	    	
		    ApexPages.currentPage().getParameters().put('id', surveyObj.Id);
		    Surveyservice ss = new Surveyservice();
		    ss.setQ1Value(3);
		    ss.setQ2Value(2);
		    ss.setQ3Value(4);
		    ss.setQ4Value(5);
		    ss.setComments('these are my comments');
		    Boolean a1 = ss.getIsEmpty();
		    Boolean b1 = ss.getIsFilled();
		    List<SelectOption> l1 = ss.getValues();
		    List<SelectOption> l2 = ss.getValues1();
		    ss.getContactName();
		    ss.save();
		    ss.getAnswered();
		    ss.getQ1Value();
		    ss.getQ2Value();
		    ss.getQ3Value();
		    ss.getQ4Value();
		    ss.getSurvey();

    	}catch(exception ex){}
    }
}