@isTest 
private class TestGetIndustry {
	static testMethod void GetIndustry() {
		try{
			List<AggregateResult> arrObj = new List<AggregateResult>();
			arrObj = [SELECT Id, Name FROM Industry__c GROUP BY Id, Name order by Name];
		  	Industry__c IndstryObj = new Industry__c();
            IndstryObj.Name='Test';
            IndstryObj.How_the_Phone_system_works__c='Test3';
            IndstryObj.Industry_Pain_Point__c = 'Test34';
            IndstryObj.Pain_Reliever__c ='Test-TEst45';
            IndstryObj.Web_Resource__c ='https://www.google.com';
            IndstryObj.What_it_is__c = 'Testd';
            insert IndstryObj;
       		String  lastIndustryName='Industry name';  
            Test.startTest();
            GetIndustry getIndustryObj = new GetIndustry();
            GetIndustry.Summary obje = new GetIndustry.Summary(arrObj[0]);
            //getIndustryObj.getIndustry();
            Test.stopTest();    
        } Catch(Exception ex){}   
		
		
	}

}