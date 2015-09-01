public class ChargebackCSVUpload {
	public transient Blob uploadDocBody {get;set;}
	public string uploadFileName {get;set;}
	public ChargebackCSVUpload() {
		try {
		} catch(Exception ex) {}
	}
	
	map<string,List<List<string>>> mapStringToListString = new map<string,List<List<string>>>();
	public transient List<WRCSVUpload> wrCSVUploadObjList; 
	public map<string,Account> accountMap {get;set;}
	map<Id,string> accountIdTOUserId = new map<Id,string>();
	public Integer caseRecordNumber {get;set;}
	public Integer caseChargeBackRecordNumber {get;set;}
	public Integer fileSize {get;set;}
	public boolean isFileUploaded {get;set;}
	public pageReference uploadChargeBackCSV() {
		try {
			caseRecordNumber = 0;
			caseChargeBackRecordNumber = 0;
			mapStringToListString = new map<string,List<List<string>>>();
			isFileUploaded = false;
			if(uploadDocBody!= null) {
				if(uploadFileName != null && !uploadFileName.endsWith('csv')) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Only CSV file must be uploaded.'));
					return null;
				}
				System.Debug('>>>fileSize>>'+ fileSize);
				System.Debug('>>>uploadFileName>>'+ uploadFileName);
				Decimal fileSizeDB = Decimal.valueof(fileSize)/(1024 * 1024);
				System.Debug('>>>##>>323e>>'+fileSizeDB);
				if(fileSizeDB > 5) {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Uploaded file size must not be greater then 5 MB.'));
					return null;
				}
				wrCSVUploadObjList = new List<WRCSVUpload>();
				accountMap = new map<string,Account>();
				accountIdTOUserId = new map<Id,string>();
				List<List<String>> parsedCSV = new List<List<String>>();
				if(Test.isRunningTest()) {
					parsedCSV =  parseCSV(uploadDocBody.toString(),false);
				} else {
					parsedCSV =  parseCSV(uploadDocBody.toString(),true);
				}
				System.Debug('>>>parsedCSV>>'+ parsedCSV);
            	if(parsedCSV != null) {
	                for(List<String> listObj : parsedCSV) {
	                	if(listObj.size()>1) {
	                    	List<List<string>> listString = new List<List<string>>();
	                        if(mapStringToListString.get(listObj[1]) != null) {
	                        	listString = mapStringToListString.get(listObj[1]);  // Map of UserId to List Info
	                        }
	                        listString.add(listObj);
	                        mapStringToListString.put(listObj[1].trim(),listString);
	                	}
	                }
                
	            	//System.Debug('>>mapStringToListString>'+ mapStringToListString.keySet());
	            	if(mapStringToListString != null && mapStringToListString.size()>0) {
	            		for(Account accObj : [select name, RC_User_ID__c from account where RC_User_ID__c IN :mapStringToListString.keySet()]) {
		            		accountMap.put(accObj.RC_User_ID__c,accObj);
		            		accountIdTOUserId.put(accObj.id,accObj.RC_User_ID__c);
		            	}	
	            	}
		            
		            if(accountMap != null && accountMap.size()>0) {
		            	caseRecordNumber = accountMap.size();
		            }
		            if(mapStringToListString != null && accountMap != null) {
		            	for(string idObj : accountMap.keyset()) {
		            		List<List<string>> listStringList = new List<List<string>>();
		            		listStringList = mapStringToListString.get(idObj);
		            		if(listStringList != null && listStringList.size()>0) {
		            			caseChargeBackRecordNumber = caseChargeBackRecordNumber + listStringList.size();
		            		}
		            	}
		            }
		         
		            System.Debug('>>caseChargeBackRecordNumber>'+ caseChargeBackRecordNumber);
		            
		            /********* For sorting ********************/
		            /* List<Long> setUserId = new List<Long>();
		            for(string strValue : mapStringToListString.keySet()) {
		            	setUserId.add(Long.valueOf(strValue));
		            } 
		            setUserId.sort(); 
		            
		            System.Debug('>>setUserId>'+ setUserId);
		            for(Long longObj : setUserId) {
		            	System.Debug('>>strObj>'+ string.valueOf(longObj));
		            	for(List<string> strObjList : mapStringToListString.get(string.valueOf(longObj))) {
		            		if(strObjList != null && strObjList.size()>=11) {
		            			WRCSVUpload wrcsvUploadObj = new WRCSVUpload();
		                		wrcsvUploadObj.accountName = accountMap.get(string.valueOf(longObj)) != null ? accountMap.get(string.valueOf(longObj)).Name : '';
		                		wrcsvUploadObj.strDateRcvd = strObjList[0];
		                		wrcsvUploadObj.userId = string.valueOf(longObj);
		                		wrcsvUploadObj.signUpDate = strObjList[2];
		                		wrcsvUploadObj.currentStatus = strObjList[3];
		                		wrcsvUploadObj.incomingStatus = strObjList[4];
		                		wrcsvUploadObj.cbId = strObjList[5];
		                		wrcsvUploadObj.tranId = strObjList[6];
		                		wrcsvUploadObj.tranDate = strObjList[7];
		                		wrcsvUploadObj.amount = strObjList[8];
		                		wrcsvUploadObj.cardToken = strObjList[9];
		                		wrcsvUploadObj.cbReason = strObjList[10];
		                		wrcsvUploadObj.comment = strObjList[11];
		                 		wrCSVUploadObjList.add(wrcsvUploadObj);	
		            		}
	                	}
	                }*/
	                
	                isFileUploaded = true;
	            }
			} else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please upload the file.'));
			}	
		} catch(Exception ex) {
			System.Debug('>>>ex>>' + ex.getMessage());
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Some exception occured due to invalid file format.'));
		}
		uploadDocBody = null;
		//return null;
		return Apexpages.currentPage();
	}
	
	public boolean isInsertSuccessfully {get;set;}
	public pageReference creatRecordsByCSV() {
		TriggerHandler.BY_PASS_CASE_ON_UPDATE = true;
		TriggerHandler.BY_PASS_CASE_ON_INSERT = true;
		isFileUploaded = false;
		Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
    	Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
		Savepoint sp = null;
		isInsertSuccessfully = false;
		try {
			sp = Database.setSavepoint();  
			List<Case> caseListToInsert = new List<Case>();
			List<Case> caseListTOUpd = new List<Case>();
			List<Chargeback__c> chargeBackListTOInsert = new List<Chargeback__c>();
			if(accountMap != null && accountMap.size()>0) {
				for(string strUserId : accountMap.keyset()) {
					Case caseObj = new Case();
					caseObj.AccountId = accountMap.get(strUserId).id;
					caseObj.Subject = 'Chargeback';
					caseObj.OwnerId = [select Id from Group where Name = 'Fraud Prevention MNL' limit 1].Id;
					caseObj.RecordTypeId = rtMapById.get('Support - Fraud Investigation').getRecordTypeId();
					caseListToInsert.add(caseObj);
				}
				if(caseListToInsert != null && caseListToInsert.size()>0) {
					insert caseListToInsert;
					System.Debug('>>>caseListToInsert>>>'+caseListToInsert);
					for(Case caseObj : caseListToInsert) {
						if(caseObj.id != null && mapStringToListString != null && accountIdTOUserId != null && caseObj.accountId != null &&
							accountIdTOUserId.get(caseObj.accountId) != null &&  
							mapStringToListString.get(accountIdTOUserId.get(caseObj.accountId)) != null) {
							for(List<string> strObjList : mapStringToListString.get(accountIdTOUserId.get(caseObj.accountId))) {
                    			if(strObjList != null && strObjList.size()>=11) {
	                    			Chargeback__c chargebackObj = new Chargeback__c();
	                    			chargebackObj.Date_Received__c = (strObjList[0] != null && strObjList[0] != '') ? Date.parse(strObjList[0]) : System.today();
	                    	   		chargebackObj.User_ID__c = strObjList[1];
		                    		chargebackObj.Signup_date__c = (strObjList[2] != null && strObjList[2] != '') ? Date.parse(strObjList[2]) : System.today();
		                    		chargebackObj.Current_status__c = strObjList[3];
		                    		chargebackObj.Incoming_status__c = strObjList[4];
		                    		chargebackObj.CB_ID__c = strObjList[5];
		                    		chargebackObj.TransID__c = strObjList[6];
		                    		chargebackObj.Transaction_Date__c = (strObjList[7] != null && strObjList[7] != '') ? Date.parse(strObjList[7]) : System.today();
		                    		chargebackObj.Amount__c = (strObjList[8] != null && strObjList[8] != '') ? Decimal.valueOf(strObjList[8]) : Decimal.valueOf('0');
		                    		chargebackObj.Card_Token__c = strObjList[9];
		                    		chargebackObj.CB_reason__c = strObjList[10];
		                    		chargebackObj.Comment__c = strObjList[11];
		                    		chargebackObj.Case__c = caseObj.id;
		                    		chargebackObj.Name = 'Chargeback - ' + chargebackObj.TransID__c  + (String.valueof(chargebackObj.Amount__c) != '0' ? ' - USD ' + String.valueof(chargebackObj.Amount__c) : '0');
		                     		chargeBackListTOInsert.add(chargebackObj);	
                    			}
                    		}
                    		/*caseObj.Number_of_Chargebacks__c = mapStringToListString.get(accountIdTOUserId.get(caseObj.accountId)).size() != null ?
                    											String.valueof(mapStringToListString.get(accountIdTOUserId.get(caseObj.accountId)).size()) : '0';*/
							caseListTOUpd.add(caseObj);
						}
					}
					if(chargeBackListTOInsert != null && chargeBackListTOInsert.size()>0) {
						insert chargeBackListTOInsert;
					}
					if(caseListTOUpd != null && caseListTOUpd.size()>0) {
						update caseListTOUpd;
						isInsertSuccessfully = true;
					}
				}	
			}
		} catch(Exception ex) {
			Database.rollback(sp);
			isInsertSuccessfully = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
		}
		accountMap = null;
		caseRecordNumber = 0;
		accountIdTOUserId = null;
		return null;
	}
	
	private static List<List<String>> parseCSV(string contents, Boolean skipHeaders) {
		List<List<String>> allFields = new List<List<String>>();
		try {
	        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
	        contents = contents.replaceAll('""','DBLQT');
	        List<String> lines = new List<String>();
            lines = contents.split('\n');
	        Integer num = 0;
	        for(String line : lines) {
	            if (line.replaceAll(',','').trim().length() == 0) break;
	            List<String> fields = line.split(',');  
	            List<String> cleanFields = new List<String>();
	            String compositeField;
	            Boolean makeCompositeField = false;
	            for(String field : fields) {
	                if (field.startsWith('"') && field.endsWith('"')) {
	                    cleanFields.add(field.replaceAll('DBLQT','"').trim());
	                } else if (field.startsWith('"')) {
	                    makeCompositeField = true;
	                    compositeField = field.trim();
	                } else if (field.endsWith('"')) {
	                    compositeField += ',' + field.trim();
	                    cleanFields.add(compositeField.replaceAll('DBLQT','"').trim());
	                    makeCompositeField = false;
	                } else if (makeCompositeField) {
	                    compositeField +=  ',' + field.trim();
	                } else {
	                    cleanFields.add(field.replaceAll('DBLQT','"').trim());
	                }
	            }
	            allFields.add(cleanFields);
	        }	
		} catch(Exception ex) {}
        if (skipHeaders) allFields.remove(0);
        return allFields; 
    }
	
	public class WRCSVUpload {
		public string accountName {get;set;}
		public string userId {get;set;}
		public string signUpDate {get;set;}
		public string incomingStatus {get;set;}
		public string currentStatus {get;set;}
		public string cbId {get;set;}
		public string tranId {get;set;}
		public string tranDate {get;set;}
		public string amount {get;set;}
		public string cardToken {get;set;}
		public string cbReason {get;set;}
		public string comment {get;set;}
		public string strDateRcvd {get;set;}
		public WRCSVUpload() {
			
		}
	} 
}