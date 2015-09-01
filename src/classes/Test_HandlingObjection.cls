@isTest
private class Test_HandlingObjection {

    static testMethod void TestHandlingObjection() {
        try{
    			Handling_Objection__c ObjHanObj = new Handling_Objection__c();
				ApexPages.StandardController controller = new ApexPages.StandardController(ObjHanObj);
				RCHandlingExt objHanExt = new RCHandlingExt(controller);
    	}catch(exception ex){}
    }
}