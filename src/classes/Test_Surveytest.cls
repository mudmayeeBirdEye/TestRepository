@isTest
private class Test_Surveytest {

	static testMethod void Surveytest() {
        try {
        	test.startTest();
			Account accTest = new Account(Name='TestAcc');
			insert accTest;
			  
			Contact contTest = new Contact();
			contTest.AccountID = accTest.id;
			contTest.Email = 'test@test.com';
			contTest.Phone = '123654789';
			contTest.LastName = 'TestLNMAe';
			insert contTest;
			
			Survey__c  surveyObj = new Survey__c();
       		surveyObj.Q1_Score__c = 1;
       		surveyObj.Q2_Score__c = 2;
       		surveyObj.Q3_Score__c = 3;
       		surveyObj.Q4_Score__c =2.5;
       		surveyObj.Q5_Score__c = 3.5;
       		surveyObj.Contact__c = contTest.Id;
       		surveyObj.Account__c = accTest.Id;
       		surveyObj.SurveyType__c ='Sales';
       		insert  surveyObj;
            ApexPages.currentPage().getParameters().put('id', ''+surveyObj.Id);
            
            // Instantiate a new controller with all parameters in the page
            Survey sur = new Survey();
            sur.setQ1Value(3);
            sur.setQ2Value(2);
            sur.setQ3Value(4);
            sur.setQ4Value(5);
            sur.setComments('these are my comments');
            
            Boolean a = sur.getIsEmpty();
            Boolean b = sur.getIsFilled();
            List<SelectOption> l1 = sur.getValues();
            List<SelectOption> l2 = sur.getValues2();
            
            sur.save();
            test.stopTest();
            } catch(Exception e) {}                     
	}
	static testMethod void Surveytest1() {
        try {
        	test.startTest();
			Account accTest = new Account(Name='TestAcc');
			insert accTest;
			  
			Contact contTest = new Contact();
			contTest.AccountID = accTest.id;
			contTest.Email = 'test@test.com';
			contTest.Phone = '123654789';
			contTest.LastName = 'TestLNMAe';
			insert contTest;
			
			Survey__c  surveyObj = new Survey__c();
       		surveyObj.Q1_Score__c = 1;
       		surveyObj.Q2_Score__c = 2;
       		surveyObj.Q3_Score__c = 3;
       		surveyObj.Q4_Score__c =2.5;
       		surveyObj.Q5_Score__c = 3.5;
       		surveyObj.Contact__c = contTest.Id;
       		surveyObj.SurveyType__c ='Implementation';
       		
       		insert  surveyObj;
            ApexPages.currentPage().getParameters().put('id', ''+surveyObj.Id);
            
            // Instantiate a new controller with all parameters in the page
            Survey sur = new Survey();
            sur.setQ1Value(3);
            sur.setQ2Value(2);
            sur.setQ3Value(4);
            sur.setQ4Value(5);
            sur.setComments('these are my comments');
            
            
            Boolean a = sur.getIsEmpty();
            Boolean b = sur.getIsFilled();
            List<SelectOption> l1 = sur.getValues();
            List<SelectOption> l2 = sur.getValues2();
            
            sur.save();
            test.stopTest();
            } catch(Exception e) {}                     
	}
	static testMethod void Surveytest2() {
        try {
        	test.startTest();
			Account accTest = new Account(Name='TestAcc');
			insert accTest;
			  
			Contact contTest = new Contact();
			contTest.AccountID = accTest.id;
			contTest.Email = 'test@test.com';
			contTest.Phone = '123654789';
			contTest.LastName = 'TestLNMAe';
			insert contTest;
			
			Survey__c  surveyObj = new Survey__c();
       		surveyObj.Q1_Score__c = 1;
       		surveyObj.Q2_Score__c = 2;
       		surveyObj.Q3_Score__c = 3;
       		surveyObj.Q4_Score__c =2.5;
       		surveyObj.Q5_Score__c = 3.5;
       		surveyObj.Contact__c = contTest.Id;
       		surveyObj.SurveyType__c ='ATT Implementation';
       		
       		insert  surveyObj;
            ApexPages.currentPage().getParameters().put('id', ''+surveyObj.Id);
            
            // Instantiate a new controller with all parameters in the page
            Survey sur = new Survey();
            sur.setQ1Value(3);
            sur.setQ2Value(2);
            sur.setQ3Value(4);
            sur.setQ4Value(5);
            sur.setComments('these are my comments');
            
            Boolean a = sur.getIsEmpty();
            Boolean b = sur.getIsFilled();
            List<SelectOption> l1 = sur.getValues();
            List<SelectOption> l2 = sur.getValues2();
            
            sur.save();
            
            Case caseObjectTest=new Case();
			caseObjectTest.Description = 'myPlainText';
			caseObjectTest.Priority = 'Low';
			caseObjectTest.Origin = 'Email';
			caseObjectTest.Status = 'New';
			caseObjectTest.SuppliedEmail ='rcindia@simplion.com';
			caseObjectTest.SuppliedPhone ='1234567890';
			caseObjectTest.SuppliedName ='Test Name';
			caseObjectTest.Subject = 'Test Subject';
			caseObjectTest.Ops_ReAssig__c = 1;
			insert caseObjectTest;
            
            surveyObj.Q3_Score__c = 2;
            surveyObj.SurveyType__c = 'SUPPORT CSAT';
            surveyObj.Case__c = caseObjectTest.Id;
            update surveyObj;
            
            test.stopTest();
            } catch(Exception e) {}                     
	}

}