@isTest
private class TestChargebackCSVUpload {

    static testMethod void chargeBackTest() {
        try {
        	Account accObj = new Account();
        	accObj.RC_User_ID__c = '242323';
        	accObj.Name = 'Test acc';
        	insert accObj;
        	ChargebackCSVUpload chargeBKCSVObj = new ChargebackCSVUpload();
        	ChargebackCSVUpload.WRCSVUpload wrObj = new ChargebackCSVUpload.WRCSVUpload();
        	chargeBKCSVObj.fileSize = 2;
        	chargeBKCSVObj.uploadFileName = 'TestCSv.csv'; 
        	chargeBKCSVObj.uploadDocBody = Blob.valueOf('9/11/2013,242323,5/15/2007,Active,Active,8251002,180202009,8/10/2013,72.37,558158...7998,37 - Fraud Transaction: No Cardholder Authorization,11,*EOL*');
        	chargeBKCSVObj.uploadChargeBackCSV();
        	chargeBKCSVObj.creatRecordsByCSV();
        } catch(Exception ex) {}
    }
}