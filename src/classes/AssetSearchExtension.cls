public class AssetSearchExtension {

	public Asset__c objAsset{get;set;}
	public String selectedOperator{get;set;}
	public String strAssetNumber{get;set;}
	public transient  List<Asset__c> lstAsset{get;set;}
	public transient  List<Asset__c> lstAsset1{get;set;}

	public String strEmployeeLastName{get;set;}
	public Boolean isUnAssigned{get;set;} 
	public boolean toEnableNetworkName {get;set;}
	public string allFieldSearchVal {get;set;}
	public List<SelectOption> recordTypeItems {get;set;}


	public AssetSearchExtension(ApexPages.StandardSetController controller) {
		objAsset=new Asset__c ();
		lstAsset=new List<Asset__c>();
		lstAsset1 = new List<Asset__c>();
		selectedOperator='';
		strAssetNumber='';
		strEmployeeLastName='';
		objAsset.Sub_Asset_Type__c='';
		recordTypeItems = new List<SelectOption>();
		try {
			Schema.DescribeSObjectResult resultObj = Asset__c.SObjectType.getDescribe();
			Map<String,Schema.RecordTypeInfo> rtMapByName = resultObj.getRecordTypeInfosByName();
			recordTypeItems.add(new SelectOption('','--None--'));
			selectedValue = ''; 
			for(Schema.RecordTypeInfo rcTypeObj: rtMapByName.values()) {
				if(rcTypeObj.Name != 'Master') {
					recordTypeItems.add(new SelectOption(rcTypeObj.getRecordTypeId(),rcTypeObj.Name)); 
					if(rcTypeObj.isDefaultRecordTypeMapping()) {
						//objAsset.RecordTypeId = rcTypeObj.getRecordTypeId();
					}	
				} 
			}

			if(objAsset.RecordTypeId == rtMapByName.get('Hardware').getRecordTypeId()) {
				toEnableNetworkName = true;
			}	
		} catch(Exception ex) {

		}
	}

	public pageReference searchAsset() {
		try {
			lstAsset1 = new List<Asset__c>();
			system.debug('<-------------------> strEmployeeLastName: '+strEmployeeLastName);
			if(String.isBlank(objAsset.Asset_tag__c)
					&& String.isBlank(objAsset.Location__c)
					&& String.isBlank(objAsset.Department__c)
					&& String.isBlank(strEmployeeLastName)
					&& String.isBlank(objAsset.Sub_Asset_Type__c)
					&& String.isBlank(objAsset.Manufacturer__c)
					&& String.isBlank(objAsset.Model__c)
					&& String.isBlank(objAsset.Serial_Number__c)
					&& String.isBlank(objAsset.Network_Name__c)
					&& String.isBlank(strAssetNumber)
					&& String.isBlank(objAsset.RecordTypeId)
					&& string.isBlank(objAsset.Status__c)
			) { 
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please insert value for search'));	
			} else {//------------->
				System.Debug('>>EEE>>>');
				String strQuery = 'Select id,Name,Location__c,Model__c,Asset_Tag__c, Serial_Number__c,Network_Name__c,Department__c,Status__c,';
				/*	if(strEmployeeLastName!=null && strEmployeeLastName.trim()!='') {
			             strQuery = strQuery+'(SELECT Asset__c,'+
			                               ' Asset_Assigned_Date__c,Department_Contact__c,Employe_Name__c,Employee_Number__c,IT_Team_Member__c,'+
			                               ' Location_Contact__c  FROM Employees__r where (Employee_Number__r.Last_Name__c LIKE \'%'+String.escapeSingleQuotes(strEmployeeLastName.trim())+'\'))';
			     	} else {
			               strQuery = strQuery+'(SELECT Asset__c,'+
			                                 ' Asset_Assigned_Date__c,Department_Contact__c,Employe_Name__c,Employee_Number__c,IT_Team_Member__c,Location_Contact__c '+
			                                 ', Employee_Number__r.Last_Name__c FROM Employees__r)';
			       	}*/
				if(strEmployeeLastName!=null && strEmployeeLastName.trim()!='') {
					strQuery = strQuery+'(SELECT Asset__c,'+
					' Asset_Assigned_Date__c,Department_Contact__c,Employe_Name__c,Employee_Number__c,IT_Team_Member__c,'+
					' Location_Contact__c FROM Employees__r where (Employee_Number__r.Last_Name__c LIKE \'%'+String.escapeSingleQuotes(strEmployeeLastName.trim())+'\'))';
				} else {
					strQuery = strQuery+'(SELECT Asset__c,'+
					' Asset_Assigned_Date__c,Department_Contact__c,Employe_Name__c,Employee_Number__c,IT_Team_Member__c,Location_Contact__c'+
					', Employee_Number__r.Last_Name__c FROM Employees__r)';
				}


				strQuery = strQuery+' from Asset__c where id != null ';

				lstAsset1 = Database.Query(getQueryString(strQuery));

				if(strEmployeeLastName!='' && strEmployeeLastName!=null){
					getDataBasedOnEmployeeLastName(lstAsset1);
				}

				if(lstAsset1.size()==0){
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Result Found.Please change your search criteria'));
					//toShowFilterLink = true;
					//toShowFilterField = true;
					//toshowListPanel = true;
				} else {
					//toShowFilter = true;
					//toShowFilterLink = true;
					//toShowFilterField = true;
				}

			}
		} catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getLineNumber()+e.getMessage()));}
		return null;
	}

	public pageReference globalSearch() {
		try {
			lstAsset = new List<Asset__c>();
			objAsset = new Asset__c ();
			strAssetNumber = '';
			strEmployeeLastName = '';
			isUnAssigned = false;
			String strQuery = 'Select id,Name,Location__c,Model__c,Serial_Number__c,Network_Name__c,Department__c,';
			strQuery = strQuery + '(SELECT Asset__c,'+
			' Asset_Assigned_Date__c,Department_Contact__c,Employe_Name__c,Employee_Number__c,IT_Team_Member__c,Location_Contact__c'+
			', Employee_Number__r.Last_Name__c FROM Employees__r)';
			/*if(allFieldSearchVal != null && allFieldSearchVal .trim()!= '') {
	             strQuery = strQuery+'(SELECT Asset__c,'+
	                               ' Asset_Assigned_Date__c,Department__c,Employe_Name__c,Employee_Number__c,IT_Team_Member__c,'+
	                               ' Location__c FROM Employees__r )';
	     	} else {
	               strQuery = strQuery+'(SELECT Asset__c,'+
	                                 ' Asset_Assigned_Date__c,Department__c,Employe_Name__c,Employee_Number__c,IT_Team_Member__c,Location__c'+
	                                 ', Employee_Number__r.Last_Name__c FROM Employees__r)';
	       	}*/                         
			strQuery = strQuery + ' from Asset__c where id != null ';


			if(allFieldSearchVal != null && allFieldSearchVal != '') {
				strQuery = strQuery + getQueryStringGlobalSearch(allFieldSearchVal);	
			}

			lstAsset = Database.Query(strQuery);

			if(allFieldSearchVal != null && allFieldSearchVal != '') {
				getDataBasedOnEmployeeLastName1(lstAsset);
			}

			if(lstAsset.size() == 0 ) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Result Found.'));
				//toshowListPanel = false;
			} else {
				//toShowFilterField = true;
				//toshowListPanel = true;
			}	
		} catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getLineNumber()+e.getMessage()));}
		return null;
	}

	private string getQueryStringGlobalSearch(string strValue) {
		string strReturn;
		try {
			Map<String, Schema.SObjectField> allAssetFieldMap = Schema.SObjectType.Asset__c.fields.getMap();
			strReturn = ' and (Name LIKE \''+String.escapeSingleQuotes(strValue.trim())+'%\'';
			strReturn = strReturn + ' OR RecordType.Name LIKE \''+String.escapeSingleQuotes(strValue.trim())+'%\'';
			for(Schema.SObjectField sobjFieldObj: allAssetFieldMap.values()) {
				Schema.DescribeFieldResult fieldDesc = sobjFieldObj.getDescribe();
				if(fieldDesc.isCustom() && fieldDesc.isFilterable() && fieldDesc.getName() != 'Asset_Type__c') {
					Schema.SOAPType soapEnumObj = fieldDesc.getSoapType();
					if(String.valueOf(soapEnumObj) == 'DOUBLE' && strValue.isNumeric()) {
						strReturn = strReturn + ' OR ' + fieldDesc.getName() + ' = ' + Integer.valueOf(strValue.trim()) + '';
					} else if(String.valueOf(soapEnumObj) == 'STRING') {
						strReturn = strReturn + ' OR ' + fieldDesc.getName() + ' LIKE \''+ String.escapeSingleQuotes(strValue.trim())+'%\'';
					}
				}
			}
			strReturn = strReturn + ')';
			System.Debug('>>>!strReturn#>>>'+ strReturn);	
		} catch(Exception e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getLineNumber()+e.getMessage()));}
		return strReturn;
	}

	public boolean toShowFilter {get;set;}
	public boolean toShowFilterLink {get;set;}
	public pageReference ClearAsset() {
		objAsset = new Asset__c ();
		lstAsset = new List<Asset__c>();
		//toShowFilter = false;
		//toShowFilterLink = false;
		//toShowFilterField = false;
		allFieldSearchVal = '';
		isUnAssigned = false;
		return null;
	}

	public pageReference ClearAsset1(){
		objAsset = new Asset__c ();
		lstAsset1 = new List<Asset__c>();
		selectedOperator='';
		strAssetNumber='';
		//toShowFilter = false;
		//toShowFilterLink = false;
		//toShowFilterField = false;
		strEmployeeLastName = '';
		isUnAssigned = false;
		return null;
	}

	//public boolean toShowFilterField {get;set;}
	/*public void showFilterField() {
    	if(toShowFilterField == false) {
    		toShowFilterField = true;
    		toShowFilter = true;
    		toshowListPanel = true;
    	} else {
    		toShowFilterField = false;
    		toShowFilter = false;
    		toshowListPanel = false;
    	}
    }*/

	//public boolean toshowListPanel {get;set;}
	public string selectedValue {get;set;}
	public void onOptionChange() {
		try {
			objAsset.Network_Name__c = '';
			//toshowListPanel = true;
			Schema.DescribeSObjectResult resultObj = Asset__c.SObjectType.getDescribe();
			Map<String,Schema.RecordTypeInfo> rtMapByName = resultObj.getRecordTypeInfosByName();
			if(objAsset.RecordTypeId == rtMapByName.get('Hardware').getRecordTypeId()) {
				toEnableNetworkName = true;
			} else {
				toEnableNetworkName = false;
			}
			objAsset.Sub_Asset_Type__c = '';
		} catch(Exception ex) {

		}
	}

	private void getDataBasedOnEmployeeLastName(List<Asset__c> lstAsset2) { 
		lstAsset1 = new List<Asset__c>();
		for(Asset__c  objAsset : lstAsset2) {
			if(objAsset.Employees__r.size()>0 && !isUnAssigned){
				lstAsset1.add(objAsset);
			}
			if(objAsset.Employees__r.size()==0 && isUnAssigned){
				lstAsset1.add(objAsset);
			}
		}
	}

	private void getDataBasedOnEmployeeLastName1(List<Asset__c> lstAsset2) {  
		try {
			lstAsset = new List<Asset__c>();
			List<Asset__c> listTemp = new List<Asset__c>();
			List<Asset__c> listTemp1 = new List<Asset__c>();
			listTemp = lstAsset2;

			String strQuery = 'Select id,Name,Location__c,Model__c,Serial_Number__c,Network_Name__c,Department__c,';
			if(allFieldSearchVal !=null && allFieldSearchVal .trim()!='') {
				strQuery = strQuery+'(SELECT Asset__c,'+
				' Asset_Assigned_Date__c,Department_Contact__c,Employe_Name__c,Employee_Number__c,IT_Team_Member__c,'+
				' Location_Contact__c FROM Employees__r where (Employee_Number__r.Last_Name__c LIKE \'%'+String.escapeSingleQuotes(allFieldSearchVal.trim())+'\'))';

				strQuery = strQuery + ' from Asset__c where id != null ';
				listTemp1 = Database.Query(strQuery);
			} 

			if(listTemp != null && listTemp.size() == 0) {
				for(Asset__c  objAsset : listTemp1) {
					if(objAsset.Employees__r.size() >0){
						lstAsset.add(objAsset);
					}
				}	
			} else {
				Set<Id> leadSetId = new Set<Id>();
				for(Asset__c  objAsset : listTemp) {
					if(!leadSetId.contains(objAsset.Id)) {
						lstAsset.add(objAsset);
						leadSetId.add(objAsset.Id);
					}
				}
				for(Asset__c  objAsset : listTemp1) {
					if(objAsset.Employees__r.size() >0){
						if(!leadSetId.contains(objAsset.Id)) {
							lstAsset.add(objAsset);
							leadSetId.add(objAsset.Id);
						}	
					}
				}
			}	
		} catch (Exception ex) {}
	} 

	private String getQueryString(String strParam) { 
		String strQuery = strParam;
		if(strAssetNumber != null && strAssetNumber.trim() != ''){
			if(selectedOperator=='notequal'){
				strQuery=strQuery+' and Name !=\''+String.escapeSingleQuotes(strAssetNumber.trim())+'\'';
			} else {
				strQuery=strQuery+' and Name =\''+String.escapeSingleQuotes(strAssetNumber.trim())+'\'';
			}
		}
		if(objAsset.Location__c!=null){
			strQuery=strQuery+' and Location__c=\''+String.escapeSingleQuotes(objAsset.Location__c)+'\'';
		}
		if(objAsset.Model__c!=null){
			strQuery=strQuery+' and Model__c=\''+String.escapeSingleQuotes(objAsset.Model__c)+'\'';
		}
		if(objAsset.Serial_Number__c!=null && objAsset.Serial_Number__c.trim()!=''){
			strQuery=strQuery+' and Serial_Number__c Like \'%'+String.escapeSingleQuotes(objAsset.Serial_Number__c.trim())+'%\'';
		}
		if(objAsset.Network_Name__c!=null && objAsset.Network_Name__c.trim()!=''){
			strQuery=strQuery+' and Network_Name__c  Like \'%'+String.escapeSingleQuotes(objAsset.Network_Name__c.trim())+'%\'';
		}
		if(objAsset.Department__c!=null) {
			strQuery=strQuery+' and Department__c=\''+String.escapeSingleQuotes(objAsset.Department__c)+'\'';
		}
		if(objAsset.RecordTypeId != null) {
			strQuery = strQuery+' and RecordTypeId=\''+String.escapeSingleQuotes(objAsset.RecordTypeId)+'\'';
		}
		if(objAsset.Sub_Asset_Type__c!=null){
			strQuery=strQuery+' and Sub_Asset_Type__c=\''+String.escapeSingleQuotes(objAsset.Sub_Asset_Type__c)+'\'';
		}
		if(objAsset.Manufacturer__c!=null){
			strQuery=strQuery+' and Manufacturer__c=\''+String.escapeSingleQuotes(objAsset.Manufacturer__c)+'\'';
		}
		if(objAsset.Status__c!=null){
      		strQuery=strQuery+' and Status__c=\''+String.escapeSingleQuotes(objAsset.Status__c)+'\'';
   		 }
		System.Debug('>>>!@#>>>'+strQuery); 
		return strQuery;
	}



}
/* String strQuery='Select id,Name,Location__c,Model__c,Serial_Number__c,Network_Name__c,Department__c,(SELECT Asset__c,'+
	                         ' Asset_Assigned_Date__c,Department__c,Employe_Name__c,Employee_Number__c,IT_Team_Member__c,Location__c'+
	                         ' FROM Employees__r where id!=null) from Asset__c where id!=null';*/




/*String searchquery = 'FIND\'"' + String.escapeSingleQuotes(allFieldSearchVal.trim())  + '*"\'IN ALL FIELDS RETURNING Asset__c'; 

		System.Debug('>>>!searchquery#>>>'+ searchquery);	

		List<List<SObject>> searchList = search.query(searchquery);

		System.Debug('>>>!@searchList#>>>'+ searchList);*/	


/*if(String.valueOf(soapEnumObj) == 'BOOLEAN' || String.valueOf(soapEnumObj) == 'DATE') { 
    		 		//strQuery = strQuery + ' OR ' + fieldDesc.getName() + ' = ' + String.escapeSingleQuotes(allFieldSearchVal.trim()) + '';	
    		 	} else {
    		 		strQuery = strQuery + ' OR ' + fieldDesc.getName() + ' = \''+ String.escapeSingleQuotes(allFieldSearchVal.trim())+'\'';
    		 	}*/ 

//List<Schema.RecordTypeInfo> recordTypeList = resultObj.getRecordTypeInfos();
/*for(Schema.RecordTypeInfo rcTypeObj: recordTypeList) {
				if(rcTypeObj.isDefaultRecordTypeMapping()) {
					objAsset.RecordTypeId = rcTypeObj.getRecordTypeId();
				}
			}*/


/*if(objAsset.Asset_Type__c == 'Hardware') {
    			objAsset.RecordTypeId = '012V00000004QDn';
    		} else if(objAsset.Asset_Type__c == 'Software') {
    			objAsset.RecordTypeId = '012V00000004QDx';
    		} else if(objAsset.Asset_Type__c == 'Mobile') {
    			objAsset.RecordTypeId = '012V00000004QE2';
    		} else if(objAsset.Asset_Type__c == 'Infrastructure') {
    			objAsset.RecordTypeId = '012V00000004QE7';
    		}
    		objAsset.Sub_Asset_Type__c = '';
    		objAsset.Manufacturer__c = '';
    		objAsset.Model__c = '';*/


/*strQuery = strQuery + ' and (Name LIKE \''+String.escapeSingleQuotes(allFieldSearchVal.trim())+'%\'' +
    							'OR Location__c LIKE \''+String.escapeSingleQuotes(allFieldSearchVal.trim())+'%\'' +
    							'OR Serial_Number__c LIKE \''+String.escapeSingleQuotes(allFieldSearchVal.trim())+'%\'' +
    							'OR Network_Name__c LIKE \''+String.escapeSingleQuotes(allFieldSearchVal.trim())+'%\'' +
    							'OR Department__c LIKE \''+String.escapeSingleQuotes(allFieldSearchVal.trim())+'%\'' +
    							'OR RecordType.Name LIKE \''+String.escapeSingleQuotes(allFieldSearchVal.trim())+'%\'' +
    							'OR Sub_Asset_Type__c LIKE \''+String.escapeSingleQuotes(allFieldSearchVal.trim())+'%\'' +
    							'OR Manufacturer__c LIKE \''+String.escapeSingleQuotes(allFieldSearchVal.trim())+'%\'' +
    							'OR Model__c LIKE \''+String.escapeSingleQuotes(allFieldSearchVal.trim())+'%\')';*/