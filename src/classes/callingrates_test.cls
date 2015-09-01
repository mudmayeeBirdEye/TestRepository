@isTest
private class callingrates_test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Folder fd = [SELECT Id FROM Folder WHERE Name='VIIFPRInternationalCallingRates'];
        Blob blbObj = Blob.valueOf('93,Afghanistan,1223,Afghanistan - Mobile,Mobile,1.14');
        Document doc = new Document(Name='BT_Calling_Rates', Body = blbObj ,folderId = fd.Id,isPublic=true,type='csv' );
        insert doc;
        
        callingrates ctrlObj = new callingrates();
        ctrlObj.strSelectedCountry = 'afghanistan';
        ctrlObj.getCountryDetailBasedCountry();
        ctrlObj.strSelectedCountry = 'a_';
        ctrlObj.getCountryWiseDetail();
        ctrlObj.strDomesticCode = '1223';
        ctrlObj.getDomesticRates();
        ctrlObj.strDomesticCode = 'a_';
        ctrlObj.getAllDomesticRates();
        ctrlObj.getShowDomesticResultPanel();
        ctrlObj.getShowInternationalResultPanel();
    }
}