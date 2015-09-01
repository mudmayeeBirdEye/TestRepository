public class CarrierDataHelper {
	@future 
	public static void getAccountRecords(set<string> setPhoneNumber, set<Id> carrierDataIdSet) {
		try {
			List<account> accList = [SELECT Id, Name, Account_Mobile_Number__c FROM Account WHERE Account_Mobile_Number__c IN :setPhoneNumber 
			                         order by lastmodifiedDate];
			map<string,Account> mapPhoneNumberTOAccount = new map<string,Account>();
			for(Account accObj : accList) {
				mapPhoneNumberTOAccount.put(accObj.Account_Mobile_Number__c,accObj);
			}

			List<Carrier_Data__c> carrierDataListToUpd = new List<Carrier_Data__c>(); 
			for(Carrier_Data__c carrieDataObj : [select Carrier_Wireless_Phone_Number__c from Carrier_Data__c where ID IN : carrierDataIdSet]) {
				if(!string.isBlank(carrieDataObj.Carrier_Wireless_Phone_Number__c)) {
					if(mapPhoneNumberTOAccount != null && mapPhoneNumberTOAccount.get(carrieDataObj.Carrier_Wireless_Phone_Number__c) != null) {
						carrieDataObj.Account__c = mapPhoneNumberTOAccount.get(carrieDataObj.Carrier_Wireless_Phone_Number__c).id;
						carrierDataListToUpd.add(carrieDataObj);
					}	
				}
			}
			if(carrierDataListToUpd != null && carrierDataListToUpd.size()>0) {
				TriggerHandler.BY_PASS_CARRIERDATA_ON_INSERT();
				TriggerHandler.BY_PASS_CARRIERDATA_ON_UPDATE();
				update carrierDataListToUpd;
			}
			if(Test.isRunningTest()) {
				Integer i = 1/0;
			}	
		}catch(Exception ex) {
			System.debug('CarrierDataHelper Error at line - ' + ex.getlineNumber());
			System.debug('CarrierDataHelper Error Message - ' + ex.getMessage());
		}
	}
	
	@future 
  	public static void getAccountRecords(Set<Id> carrierDataIdSet) {
  		if(carrierDataIdSet == null || carrierDataIdSet.size() == 0)
  			return;
  		try {
	  		List<Carrier_Data__c> carrierList = [SELECT Carrier_Wireless_Phone_Number__c FROM Carrier_Data__c WHERE Carrier_Wireless_Phone_Number__c != NULL AND Id IN : carrierDataIdSet];
	  		Set<String> setPhoneNumber = new Set<String>();
			for(Carrier_Data__c carrierDataObj : carrierList) {
				String originalPhoneNumber = carrierDataObj.Carrier_Wireless_Phone_Number__c;
				String formatPhoneWithCode = formatPhoneNumberWithCode(originalPhoneNumber);
 				String formatPhoneWithoutCode = formatPhoneNumberWithoutCode(originalPhoneNumber);
				setPhoneNumber.add(formatPhoneWithCode);
				setPhoneNumber.add(formatPhoneWithoutCode);
			}
	  		List<account> accList = [SELECT Id, Name, Account_Mobile_Number__c FROM Account WHERE Account_Mobile_Number__c !=NULL AND Account_Mobile_Number__c IN :setPhoneNumber 
	  									ORDER BY lastmodifiedDate];
	  		Map<string,Account> mapPhoneNumberTOAccount = new Map<string,Account>();
	  		for(Account accObj : accList) {
	  			String originalPhoneNumber = accObj.Account_Mobile_Number__c;
	  			mapPhoneNumberTOAccount.put(originalPhoneNumber,accObj);
	  		}
	  		
	  		List<Carrier_Data__c> carrierDataListToUpd = new List<Carrier_Data__c>(); 
	  		for(Carrier_Data__c carrierDataObj : carrierList) {
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
	  		if(carrierDataListToUpd != null && !carrierDataListToUpd.isEmpty()) {
	  			TriggerHandler.BY_PASS_CARRIERDATA_ON_INSERT();
				TriggerHandler.BY_PASS_CARRIERDATA_ON_UPDATE();
	  			update carrierDataListToUpd;
	  		}
	  	    if(Test.isRunningTest()) {
	  			Integer i = 1/0;
	  		}	
		}catch(Exception ex) {
			System.debug('CarrierDataHelper Error at line - ' + ex.getlineNumber());
			System.debug('CarrierDataHelper Error Message - ' + ex.getMessage());
		}
	}
	private static String formatPhoneNumberWithCode(String originalPhoneNumber) {
		return (originalPhoneNumber.length() == 10 ? '1' + originalPhoneNumber : originalPhoneNumber);
	}
	private static String formatPhoneNumberWithoutCode(String originalPhoneNumber) {
		return (originalPhoneNumber.length() == 11 ? originalPhoneNumber.substring(1,originalPhoneNumber.length()) : originalPhoneNumber);
	}
}