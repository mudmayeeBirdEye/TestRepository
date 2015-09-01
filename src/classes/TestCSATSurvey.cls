@isTest
private class TestCSATSurvey {

    static testMethod void csatSurveyTest() {
    	Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.RecordTypeId  = '01280000000UERq';
        insert acctest; 
        
        Contact contObj = new Contact();
	    contObj.AccountId =  acctest.Id;
	    contObj.Email = 'test@test.com';
	    contObj.LastName = 'Test Last1';
	    contObj.FirstName = 'Test First1';
      	insert contObj;
	      	
    	Survey__c surveyObj1 = new Survey__c();
    	surveyObj1.SurveyType__c = 'Implementation';
    	surveyObj1.Name = 'Test Impl';
    	surveyObj1.Contact__c = contObj.Id;
    	surveyObj1.Contact_Email__c = 'test@test.com';
    	insert surveyObj1;
    	
    	Survey__c surveyObj2 = new Survey__c();
    	surveyObj2.SurveyType__c = 'Sales';
    	surveyObj2.Name = 'Test Impl';
    	surveyObj2.Contact__c = contObj.Id;
    	surveyObj2.Contact_Email__c = 'test@test.com';
    	insert surveyObj2;
    	
    	Test.startTest();
    	
    	CSATSurvey csatsurvey2 = new CSATSurvey();
	    ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        CSATSurvey csatsurvey1 = new CSATSurvey();
        csatsurvey1.getValues1();
        csatsurvey1.getValues1_Porting();
        csatsurvey1.getValues3_Porting();
        csatsurvey1.getValues2();
        csatsurvey1.getValues3();
        csatsurvey1.getValues4();
        csatsurvey1.save();
        csatsurvey1.answer1 = '1.00';
        csatsurvey1.answer2 = '2.00';
        csatsurvey1.answer31 = '2.00';
        csatsurvey1.answer32 = '2.00';
        csatsurvey1.answer33 = '3.00';
        csatsurvey1.answer34 = '3.00';
        csatsurvey1.answer01 = '8';
        csatsurvey1.answer011 = '8';
        csatsurvey1.answer012 = '8';
        csatsurvey1.answer013 = '8';
        csatsurvey1.answer014 = '8';
        csatsurvey1.surveyObj.X4_Survey__c ='3.00';
        csatsurvey1.answer5 = '3.00';
        csatsurvey1.surveyObj.X6_Survey__c = 'Low';
        csatsurvey1.save();
        csatsurvey1.setResponseValue();
        csatsurvey1.checkSurveyAlreadyFilled();
        new CSATSurvey();
        ApexPages.currentPage().getParameters().put('id', surveyObj2.id);
        CSATSurvey csatsurvey3 = new CSATSurvey();
        
        Test.stopTest();
    }
    static testMethod void attSurveyTest(){
    Account acctest = new Account();
        acctest.Name = 'RCTestAccount';
        acctest.RecordTypeId  = '01280000000UERq';
        acctest.Number_of_DL_s__c = 5;
        acctest.RC_Service_name__c = 'Office12';
        insert acctest; 
        
        Contact contObj = new Contact();
	    contObj.AccountId =  acctest.Id;
	    contObj.Email = 'test@test1.com';
	    contObj.LastName = 'Test Last123';
	    contObj.FirstName = 'Test First145';
      	insert contObj;
	      	
    	Survey__c surveyObj1 = new Survey__c();
    	surveyObj1.SurveyType__c = 'ATT Implementation';
    	surveyObj1.Name = 'Test Imp4l';
    	surveyObj1.Contact__c = contObj.Id;
    	surveyObj1.Contact_Email__c = 'test@test1.com';
    	insert surveyObj1;
    	
    	Test.startTest();
    	
    	CSATSurvey csatsurvey2 = new CSATSurvey();
	    ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        CSATSurvey csatsurvey1 = new CSATSurvey();
        csatsurvey1.getValues1();
        csatsurvey1.getValues1_Porting();
        csatsurvey1.getValues3_Porting();
        csatsurvey1.getValues2();
        csatsurvey1.getValues3();
        csatsurvey1.getValues4();
        csatsurvey1.save();
        csatsurvey1.answer1 = '1.00';
        csatsurvey1.answer2 = '2.00';
        csatsurvey1.answer31 = '2.00';
        csatsurvey1.answer32 = '2.00';
        csatsurvey1.answer33 = '3.00';
        csatsurvey1.answer34 = '3.00';
        csatsurvey1.answer01 = '8';
        csatsurvey1.answer011 = '8';
        csatsurvey1.answer012 = '8';
        csatsurvey1.answer013 = '8';
        csatsurvey1.answer014 = '8';
        csatsurvey1.surveyObj.X4_Survey__c ='3.00';
        csatsurvey1.answer5 = '3.00';
        csatsurvey1.surveyObj.X6_Survey__c = 'Low';
        csatsurvey1.save();
        csatsurvey1.setResponseValue();
        csatsurvey1.checkSurveyAlreadyFilled();
        new CSATSurvey();
        ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        CSATSurvey csatsurvey3 = new CSATSurvey();
        
        Test.stopTest();
    }
    static testMethod void getIsEmpty(){
    	Account acctest = new Account();
        acctest.Name = 'RCTestAccount';
        acctest.RecordTypeId  = '01280000000UERq';
        insert acctest; 
        
        Contact contObj = new Contact();
	    contObj.AccountId =  acctest.Id;
	    contObj.Email = 'test@test1.com';
	    contObj.LastName = 'Test Last123';
	    contObj.FirstName = 'Test First145';
      	insert contObj;
	      	
    	Survey__c surveyObj1 = new Survey__c();
    	surveyObj1.SurveyType__c = 'ATT Implementation';
    	surveyObj1.Name = 'Test Imp4l';
    	surveyObj1.Contact__c = contObj.Id;
    	surveyObj1.Contact_Email__c = 'test@test1.com';
    	insert surveyObj1;
    	
    	Test.startTest();
    	
    	CSATSurvey csatsurvey2 = new CSATSurvey();
	    ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        CSATSurvey csatsurvey1 = new CSATSurvey();
        csatsurvey1.getValues1();
        csatsurvey1.getValues1_Porting();
        csatsurvey1.getValues3_Porting();
        csatsurvey1.getValues2();
        csatsurvey1.getValues3();
        csatsurvey1.getValues4();
        csatsurvey1.save();
        csatsurvey1.answer1 = '1.00';
        csatsurvey1.answer2 = '2.00';
        csatsurvey1.answer31 = '2.00';
        csatsurvey1.answer32 = '2.00';
        csatsurvey1.answer33 = '3.00';
        csatsurvey1.answer34 = '3.00';
        csatsurvey1.answer01 = '8';
        csatsurvey1.answer011 = '8';
        csatsurvey1.answer012 = null;
        csatsurvey1.answer013 = null;
        csatsurvey1.answer014 = '8';
        csatsurvey1.surveyObj.X4_Survey__c ='3.00';
        csatsurvey1.answer5 = '3.00';
        csatsurvey1.surveyObj.X6_Survey__c = 'Low';
        csatsurvey1.save();
        //csatsurvey1.setResponseValue();
        //csatsurvey1.checkSurveyAlreadyFilled();
        csatsurvey1.getIsEmpty();
        new CSATSurvey();
        ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        CSATSurvey csatsurvey3 = new CSATSurvey();
        
        Test.stopTest();
    }
    
    static testMethod void surveyTestPorting() {
    	Account acctest = new Account();
        acctest.Name = 'TestAccount11';
        acctest.RecordTypeId  = '01280000000UERq';
        insert acctest; 
        
        Contact contObj = new Contact();
	    contObj.AccountId =  acctest.Id;
	    contObj.Email = 'test@test11.com';
	    contObj.LastName = 'Test Last1121';
	    contObj.FirstName = 'Test First1';
      	insert contObj;
	      	
    	Survey__c surveyObj1 = new Survey__c();
    	surveyObj1.SurveyType__c = 'Porting Phone Support';
    	surveyObj1.Name = 'Test Impl';
    	surveyObj1.Contact__c = contObj.Id;
    	surveyObj1.Contact_Email__c = 'test@test.com';
    	insert surveyObj1;
    	
    	Survey__c surveyObj2 = new Survey__c();
    	surveyObj2.SurveyType__c = 'Porting Phone Support1';
    	surveyObj2.Name = 'Test Impl';
    	surveyObj2.Contact__c = contObj.Id;
    	surveyObj2.Contact_Email__c = 'test@test.com';
    	insert surveyObj2;
    	
    	Test.startTest();
    	
    	PortingPhoneSupportCSATSurvey csatsurvey2 = new PortingPhoneSupportCSATSurvey();
	    ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        PortingPhoneSupportCSATSurvey csatsurvey1 = new PortingPhoneSupportCSATSurvey();
        csatsurvey1.getValues1();
        csatsurvey1.getValues2();
        csatsurvey1.getValues3();
        csatsurvey1.getValues4();
        csatsurvey1.save();
        csatsurvey1.answer1 = '1.00';
        csatsurvey1.answer2 = '2.00';
        csatsurvey1.answer31 = '2.00';
        csatsurvey1.answer32 = '2.00';
        csatsurvey1.answer33 = '3.00';
        csatsurvey1.answer34 = '3.00';
      	csatsurvey1.surveyObj.X4_Survey__c = 'Yes';
        csatsurvey1.answer5 = '3.00';
        csatsurvey1.surveyObj.X6_Survey__c = 'Low';
        csatsurvey1.save();
        csatsurvey1.setResponseValue();
        csatsurvey1.checkSurveyAlreadyFilled();
        new PortingPhoneSupportCSATSurvey();
        ApexPages.currentPage().getParameters().put('id', surveyObj2.id);
        PortingPhoneSupportCSATSurvey csatsurvey3 = new PortingPhoneSupportCSATSurvey();
        
        Test.stopTest();
    }
    
     static testMethod void surveyTestrogers() {
    	Account acctest = new Account();
        acctest.Name = 'TestAccount11';
        acctest.RecordTypeId  = '01280000000UERq';
        insert acctest; 
        
        Contact contObj = new Contact();
	    contObj.AccountId =  acctest.Id;
	    contObj.Email = 'test@test11.com';
	    contObj.LastName = 'Test Last1121';
	    contObj.FirstName = 'Test First1';
      	insert contObj;
	      	
    	Survey__c surveyObj1 = new Survey__c();
    	surveyObj1.SurveyType__c = 'Support Rogers';
    	surveyObj1.Name = 'Test Impl';
    	surveyObj1.Contact__c = contObj.Id;
    	surveyObj1.Contact_Email__c = 'test@test.com';
    	insert surveyObj1;
    	
    	Survey__c surveyObj2 = new Survey__c();
    	surveyObj2.SurveyType__c = 'Support Rogers1';
    	surveyObj2.Name = 'Test Impl';
    	surveyObj2.Contact__c = contObj.Id;
    	surveyObj2.Contact_Email__c = 'test@test.com';
    	insert surveyObj2;
    	
    	CSATSupportRogers csatsurvey2 = new CSATSupportRogers();
	    ApexPages.currentPage().getParameters().put('id', surveyObj1.id);
        CSATSupportRogers csatsurvey1 = new CSATSupportRogers();
        csatsurvey1.getValues1();
        csatsurvey1.getValues2();
        csatsurvey1.getValues3();
        csatsurvey1.getValues4();
        csatsurvey1.save();
        csatsurvey1.answer1 = '1.00';
        csatsurvey1.answer2 = '2.00';
        csatsurvey1.answer31 = '2.00';
        csatsurvey1.answer32 = '2.00';
        csatsurvey1.answer33 = '3.00';
        csatsurvey1.answer34 = '3.00';
        csatsurvey1.surveyObj.X4_Survey__c = 'Yes';
        csatsurvey1.answer5 = '3.00';
        csatsurvey1.surveyObj.X6_Survey__c = 'Low';
        csatsurvey1.save();
        csatsurvey1.setResponseValue();
        csatsurvey1.checkSurveyAlreadyFilled();
        new CSATSupportRogers();
        ApexPages.currentPage().getParameters().put('id', surveyObj2.id);
        CSATSupportRogers csatsurvey3 = new CSATSupportRogers();
    }
    
    static testMethod void surveyhtmlPreviewTest() {
    	Account acctest = new Account();
        acctest.Name = 'TestAccount';
        acctest.RecordTypeId  = '01280000000UERq';
        insert acctest; 
        
        Contact contObj = new Contact();
	    contObj.AccountId =  acctest.Id;
	    contObj.Email = 'test@test.com';
	    contObj.LastName = 'Test Last1';
	    contObj.FirstName = 'Test First1';
      	insert contObj;
	      	
    	Survey__c surveyObj1 = new Survey__c();
    	surveyObj1.SurveyType__c = 'Implementation';
    	surveyObj1.Name = 'Test Impl';
    	surveyObj1.Contact__c = contObj.Id;
    	surveyObj1.Contact_Email__c = 'test@test.com';
    	insert surveyObj1;
    	
    	Survey__c surveyObj2 = new Survey__c();
    	surveyObj2.SurveyType__c = 'Sales';
    	surveyObj2.Name = 'Test Impl';
    	surveyObj2.Contact__c = contObj.Id;
    	surveyObj2.Contact_Email__c = 'test@test.com';
    	insert surveyObj2;
    	
    	Survey__c surveyObj3 = new Survey__c();
    	surveyObj3.SurveyType__c = 'Support CSAT';
    	surveyObj3.Name = 'Test Impl';
    	surveyObj3.Contact__c = contObj.Id;
    	surveyObj3.Contact_Email__c = 'test@test.com';
    	insert surveyObj3;
    	
    	Survey__c surveyObj4 = new Survey__c();
    	surveyObj4.SurveyType__c = 'Porting Phone Support';
    	surveyObj4.Name = 'Test Impl';
    	surveyObj4.Contact__c = contObj.Id;
    	surveyObj4.Contact_Email__c = 'test@test.com';
    	insert surveyObj4;
    	
    	
    	Survey__c surveyObj5 = new Survey__c();
    	surveyObj5.SurveyType__c = 'RC - IT Internal Survey';
    	surveyObj5.Name = 'Test Impl';
    	surveyObj5.Contact__c = contObj.Id;
    	surveyObj5.Contact_Email__c = 'test@test.com';
    	insert surveyObj5;
    	
    	Survey__c surveyObj6 = new Survey__c();
    	surveyObj6.SurveyType__c = 'Porting';
    	surveyObj6.Name = 'Test Impl';
    	surveyObj6.Contact__c = contObj.Id;
    	surveyObj6.Contact_Email__c = 'test@test.com';
    	insert surveyObj6;
    	
    	Survey__c surveyObj7 = new Survey__c();
    	surveyObj7.SurveyType__c = 'Support Rogers';
    	surveyObj7.Name = 'Test Impl';
    	surveyObj7.Contact__c = contObj.Id;
    	surveyObj7.Contact_Email__c = 'test@test.com';
    	insert surveyObj7;
    	
    	Survey__c surveyObj8 = new Survey__c();
    	surveyObj8.SurveyType__c = 'Saves CSAT';
    	surveyObj8.Name = 'Test Impl';
    	surveyObj8.Contact__c = contObj.Id;
    	surveyObj8.Contact_Email__c = 'test@test.com';
    	insert surveyObj8;
    	
    	Test.startTest();
    	
    	ApexPages.currentPage().getParameters().put('SurveyId', surveyObj1.id);
    	SurveyHtmlPreviewController surveyPrvObj = new SurveyHtmlPreviewController();
    	
    	ApexPages.currentPage().getParameters().put('SurveyId', surveyObj2.id);
    	SurveyHtmlPreviewController surveyPrvObj1 = new SurveyHtmlPreviewController();
    	
    	
    	ApexPages.currentPage().getParameters().put('SurveyId', surveyObj3.id);
    	SurveyHtmlPreviewController surveyPrvObj2 = new SurveyHtmlPreviewController();
    	
    	
    	
    	ApexPages.currentPage().getParameters().put('SurveyId', surveyObj4.id);
    	SurveyHtmlPreviewController surveyPrvObj3 = new SurveyHtmlPreviewController();
    	
    	
    	
    	ApexPages.currentPage().getParameters().put('SurveyId', surveyObj5.id);
    	SurveyHtmlPreviewController surveyPrvObj4 = new SurveyHtmlPreviewController();  
    	
    	
    	ApexPages.currentPage().getParameters().put('SurveyId', surveyObj6.id);
    	SurveyHtmlPreviewController surveyPrvObj5 = new SurveyHtmlPreviewController();
    	
    	
    	ApexPages.currentPage().getParameters().put('SurveyId', surveyObj7.id);
    	SurveyHtmlPreviewController surveyPrvObj6 = new SurveyHtmlPreviewController();
    	
    	
    	
    	ApexPages.currentPage().getParameters().put('SurveyId', surveyObj8.id);
    	SurveyHtmlPreviewController surveyPrvObj7 = new SurveyHtmlPreviewController();
    	
    	SurveyHtmlPreviewController.QuestionOptionWrapper quesWrObj = new SurveyHtmlPreviewController.QuestionOptionWrapper(surveyObj8);
    	quesWrObj.questionType = 'Knowledge';
    	quesWrObj.getValues();
    	quesWrObj.questionType = 'Satisfaction Level';
    	quesWrObj.getValues();
    	quesWrObj.questionType = 'Recommendation';   
    	quesWrObj.getValues();
    	quesWrObj.questionType = 'Satisfaction';
    	quesWrObj.getValues();
    	quesWrObj.questionType = 'ITValue1';
    	quesWrObj.getValues();
    	quesWrObj.questionType = 'ITValue2';
    	quesWrObj.getValues();
    	quesWrObj.questionType = 'ITValue3';
    	quesWrObj.getValues();
    	
    	Test.stopTest();
    }
}