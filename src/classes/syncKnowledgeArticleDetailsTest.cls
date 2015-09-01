/**
 * This class contains unit tests for validating the behavior of Apex class syncKnowledgeArticleDetails.
 * Created By: Simplion Technologies
 */
@isTest(seeAllData = true)
private class syncKnowledgeArticleDetailsTest {
    static testMethod void myUnitTest() {
		try{
			Test.startTest();
			/*RC_Knowledge_Article__ka kaObj = new RC_Knowledge_Article__ka();
			insert kaObj;
			RC_Knowledge_Article__kav rcKnowlgKavObj = new RC_Knowledge_Article__kav();
			rcKnowlgKavObj.Details__c = 'These are hte detais test';
			rcKnowlgKavObj.Key_Words__c = 'phone,office,fax';
			rcKnowlgKavObj.Legacy_Article_ID__c = 'asjw2343';
			rcKnowlgKavObj.Ranking__c = '1';
			rcKnowlgKavObj.Summary = 'test summary';
			rcKnowlgKavObj.Title='123test'+system.now();
			rcKnowlgKavObj.UrlName = 'test-title';
			insert rcKnowlgKavObj;
			System.assertEquals('test-title', rcKnowlgKavObj.UrlName);
			String articleId = string.valueof(rcKnowlgKavObj.KnowledgeArticleId);
			KbManagement.PublishingService.publishArticle(articleId, true);
			System.assertEquals('Online', rcKnowlgKavObj.PublishStatus);
			RC_Article_Rating__c rcArticleObj = new RC_Article_Rating__c();
			rcArticleObj.of_User_Rate_This_Article__c =1;
			rcArticleObj.Article_Id__c = rcKnowlgKavObj.KnowledgeArticleId;
			rcArticleObj.Article_Rating_Count__c =1;
			rcArticleObj.RC_Average_Rating__c =1;
			rcArticleObj.RCArticle_Title__c = 'test title';
			insert rcArticleObj;
			System.assertEquals(rcKnowlgKavObj.KnowledgeArticleId, rcArticleObj.Article_Id__c);
			list<RC_Article_Rating__c> rcArticlelist = new List<RC_Article_Rating__c>();
			rcArticlelist.add(rcArticleObj);*/
			String jobId = System.schedule('syncKnowledgeArticleDetails','0 0 0 3 9 ? 2022',new syncKnowledgeArticleDetails());
			CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
			System.assertEquals(0, ct.TimesTriggered);
			System.assertEquals('2022-09-03 00:00:00',String.valueOf(ct.NextFireTime));
			syncKnowledgeArticleDetails objTest = new syncKnowledgeArticleDetails();
			/*set<string> setuId = new Set<String>();
			setuId.add(rcArticleObj.CreatedById );
			objTest.getUsersName(setuId, rcArticlelist);*/
			Test.stopTest();
		}catch(Exception e){}
	}
}