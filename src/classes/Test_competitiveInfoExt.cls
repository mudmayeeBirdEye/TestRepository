@isTest
private class Test_competitiveInfoExt {

    static testMethod void TestCompetitiveInfoExt() {
        Competitive_Info__c ObjComInfo = new Competitive_Info__c();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(ObjComInfo);
        competitiveInfoExt objComInfoExt = new competitiveInfoExt(controller);
        
       // TestCompetitiveInfoExt objTesComInfExt = new TestCompetitiveInfoExt();
        //objTesComInfExt.
    }
}