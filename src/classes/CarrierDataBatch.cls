global class CarrierDataBatch implements  Database.Batchable<sObject> { 
	public string strQuery;
	global CarrierDataBatch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(strQuery);
	}
	
	public void runBatchProcessManually() {
		CarrierDataBatch carrierDataObj = new CarrierDataBatch(); 
   		carrierDataObj.strQuery = 'SELECT Carrier_Wireless_Phone_Number__c FROM Carrier_Data__c WHERE Carrier_Wireless_Phone_Number__c != null ' +
   									' and Account__c = null ';		 
        Database.executeBatch(carrierDataObj, 200);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		try {
			List<Carrier_Data__c> carrierDataListToUpd = new List<Carrier_Data__c>();
			Set<String> setPhoneNumber = new Set<String>();
			for(sObject result : scope) {
				Carrier_Data__c carrierDataObj = (Carrier_Data__c)result; 
			    if(carrierDataObj.Carrier_Wireless_Phone_Number__c != null) {
		        	String originalPhoneNumber = carrierDataObj.Carrier_Wireless_Phone_Number__c;
					String formatPhoneWithCode = formatPhoneNumberWithCode(originalPhoneNumber);
 					String formatPhoneWithoutCode = formatPhoneNumberWithoutCode(originalPhoneNumber);
					setPhoneNumber.add(formatPhoneWithCode);
					setPhoneNumber.add(formatPhoneWithoutCode);
		        } 
		    }
		    List<account> accList = [SELECT Id, Name, Account_Mobile_Number__c FROM Account WHERE Account_Mobile_Number__c != NULL AND 
		    							Account_Mobile_Number__c IN :setPhoneNumber ORDER BY lastmodifiedDate];
		    Map<string,Account> mapPhoneNumberTOAccount = new Map<string,Account>();
	  		for(Account accObj : accList) {
	  			String originalPhoneNumber = accObj.Account_Mobile_Number__c;
	  			mapPhoneNumberTOAccount.put(originalPhoneNumber,accObj);
	  		}
	  		for(sObject result : scope) {
	  			Carrier_Data__c carrierDataObj = (Carrier_Data__c)result;
	  			if(carrierDataObj.Carrier_Wireless_Phone_Number__c != null) {
	  				String originalPhoneNumber = carrierDataObj.Carrier_Wireless_Phone_Number__c;
	          		String formatPhoneWithCode = formatPhoneNumberWithCode(originalPhoneNumber);
	 				String formatPhoneWithoutCode = formatPhoneNumberWithoutCode(originalPhoneNumber);
	 				Account accountObj = mapPhoneNumberTOAccount.get(formatPhoneWithCode);
	          		if(accountObj != null) {
	          			carrierDataObj.Account__c = accountObj.Id;
	          			carrierDataListToUpd.add(carrierDataObj);
	          		} else {
	          			accountObj = mapPhoneNumberTOAccount.get(formatPhoneWithoutCode);
	          			if(accountObj != null) {
		          			carrierDataObj.Account__c = accountObj.Id;
		          			carrierDataListToUpd.add(carrierDataObj);
		          		}
	          		}	
	  			} 
	  		}							
		    if(carrierDataListToUpd != null && carrierDataListToUpd.size()>0) {
		 		update carrierDataListToUpd;		
		    }
		} catch(Exception ex) {}
	}
	
	global void finish(Database.BatchableContext info) {
		try {
		    strQuery = null;
		} catch(Exception exp) {
			
		}
	}
	
	private static String formatPhoneNumberWithCode(String originalPhoneNumber) {
		return (originalPhoneNumber.length() == 10 ? '1' + originalPhoneNumber : originalPhoneNumber);
	}
	
	private static String formatPhoneNumberWithoutCode(String originalPhoneNumber) {
		return (originalPhoneNumber.length() == 11 ? originalPhoneNumber.substring(1,originalPhoneNumber.length()) : originalPhoneNumber);
	}
}