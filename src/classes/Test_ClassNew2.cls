@isTest
private class Test_ClassNew2 {

        static testMethod void Test_FakeScheduledMethod() {
        Lead leadObj = new Lead();
        leadObj.FirstName = 'FName';
        leadObj.Email= 'abc@test.com';
        leadObj.LastName = 'LastName'; 
        leadObj.Company  ='TestCompany';
        leadObj.phone = '12222223321';
        leadObj.Downgrade_Reason__c  = 'Not Enough Info';
        leadObj.User_ID__c ='12345';
        leadObj.Website = 'test.com';
        leadObj.NumberOfEmployees = 5;
        leadObj.Industry = 'Consulting: IT';
        leadObj.NumberOfEmployees__c='2-19';
        leadObj.Number_of_Locations__c ='2-4'; 
        //leadObj.Account__c
		insert leadObj;
		
		//FakeScheduledMethod objFSM = new FakeScheduledMethod();
		
		Test.startTest();
		FakeScheduledMethod job = new FakeScheduledMethod();
		 String jobId = System.schedule('job',
                                      '0 0 0 3 9 ? 2022',job);
		//job.execute(ctx)
		Test.stopTest();
    }
     static testMethod void Test_MailHelper() {
        
        new MailHelper().createMail(null, 'This is test email. Please ignore', '00580000003SZmNAAW',''
        , false, 'Test Email','Test Email');
    }
    
    /*public static TestMethod void test1() {
        new MailHelper().sendMail('virendra.singh@simplion.com','Test Mail','Test Mail');
    }*/
    
    public static TestMethod void Test_MailHelper2() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', null,''
        , false, 'Test Email','Test Email','virendra.singh@simplion.com');
    }
    public static TestMethod void Test_MailHelper3() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', null,''
        , false, 'Test Email','Test Email',new String[]{'virendra.singh@simplion.com'}, new String[]{'virendra.singh@simplion.com'}, new String[]{'virendra.singh@simplion.com'});
    }
    public static TestMethod void Test_MailHelper4() {
        new MailHelper().createMail(null, 'This is test email. Please ignore', null,''
        , false, 'Test Email','Test Email',null, null, null);
    }
}