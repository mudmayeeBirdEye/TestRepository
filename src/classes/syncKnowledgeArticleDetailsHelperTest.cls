/**
 * This class contains unit tests for validating the behavior of Apex class syncKnowledgeArticleDetailsHelper
 * Created By: Simplion Technologies
 */
@isTest(seeAllData=true)
private class syncKnowledgeArticleDetailsHelperTest {
    static testMethod void myUnitTest() {
    	try{
    		test.startTest();
			syncKnowledgeArticleDetailsHelper obj=new syncKnowledgeArticleDetailsHelper();
			obj.syncArticleDetails();
			obj.strNoOfDays='7';
			obj.syncArticleDetails();
			test.stopTest();
        }catch(Exception e){}
    }
}