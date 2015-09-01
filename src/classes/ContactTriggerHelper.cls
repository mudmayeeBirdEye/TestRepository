public class ContactTriggerHelper {
	
	//Variable Declaration
    private static String NO_OF_EMPLOYEES = 'numberofemployees__c';
    
    /****************************************************************************************************
	 *@Description: getting Standard Value of No. Of Employee Range                                     *
    *@Params: no Parameters                                                                             *
    *@Returns: Set<String>																			*
    *@Coded By: India Team                                                                              *
    *****************************************************************************************************/
    
    public static Set<String> getEmployeeRange() {
        Set<String> range = new Set<String>(); 
        range.addAll(getPicklistValue());
        return range;
    }
    
    /****************************************************************************************************
	 *@Description: get picklist values of a field.                                    *
    *@Params: no Parameters                                                                             *
    *@Returns: Set<String>																			*
    *@Coded By: India Team                                                                              *
    *****************************************************************************************************/
    public static Set<string> getPicklistValue(){       
        Set<String> ranges = new Set<String>();
        Schema.DescribeFieldResult numberOfEmployees = Contact.NumberOfEmployees__c.getDescribe();
        List<Schema.PicklistEntry> numberOfEmployeesRange = numberOfEmployees.getPicklistValues();
        for(Schema.PicklistEntry schObj : numberOfEmployeesRange){
            ranges.add(schObj.getValue());
        }     
        return ranges;         
    }
    
    public static Map<Integer, String> rangeMapPerStartValue(Set<String> range) {
        Map<Integer, String> mapPossibleValidRange = new Map<Integer, String>();
        try {
            if(range.size() > 0){
                for(String strRangeValue : range){
                    if(strRangeValue.indexOf('-') > -1) {
                        try {mapPossibleValidRange.put(Integer.valueOf(strRangeValue.split('-')[0].trim()), strRangeValue);} catch(Exception x) {}
                    } else if(strRangeValue.indexOf('+') > -1) {
                        try {mapPossibleValidRange.put(Integer.valueOf(strRangeValue.substring(0,strRangeValue.indexOf('+'))), strRangeValue); } catch(Exception y) {}
                    } else if(!isNumeric(strRangeValue)) {
                        mapPossibleValidRange.put(1, strRangeValue);
                    } 
                }
            }
        } catch(Exception e) {}
        return mapPossibleValidRange;
    }
    /*****************************************************************************
     * @Description - method to update contact records on insertion/updation of account record      * 
     * @return Map<Id,List<Contract>                                                                * 
     *****************************************************************************/
         
       public static void updateContactOnAccount(list<Contact> lstContact){   
          try{
			   List<Account> accList = new List<Account>();
			   //Set of Account Ids that we will iterate through
			   Set<id> Ids = new Set<id>();
			   for (Contact con : lstContact){
			     if(con.accountid != null){
			       Ids.add(con.AccountId);
			     }
			   }
			   // Get the Account id and Event_Account_Status__c for each account
			    String recordTypeName = 'Customer Account'; // <-- Change this to your record type name
 				Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
  				Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
 				id recordTypeId = rtInfo.getRecordTypeId();
			    Map<id, Account> accountMap = new Map<id, Account>([Select id, RC_Account_Status__c from Account Where Id in :Ids ]);  
			    for(Contact con : lstContact){
			     if(con.AccountId != null){  	
				     Account acc = accountMap.get(con.AccountId);
				     if(acc.RC_Account_Status__c != null && 'Paid'.equalsIgnoreCase(acc.RC_Account_Status__c.trim())){
						    con.isCustomer__c=True;
							con.Contact_Status__c='Closed Won';
							con.Contact_Funnel_Type__c='Customer';
							con.People_Segment__c='Customer';
					 }  else if(acc.RC_Account_Status__c != null && 'Canceled'.equalsIgnoreCase(acc.RC_Account_Status__c.trim())) {
								con.isCustomer__c=False;
							    con.Contact_Status__c='Winback';
								con.Contact_Funnel_Type__c=' Former Customer';
								con.People_Segment__c='Canceled';
						}
				     }
			   }    
			 }  catch(Exception e){
			   System.debug('ERROR: '+ e);
			
			 }         
         }   	     
     
         
    public static void  validateEmployeeRangeForNumericValues(List<Contact> contactList) {
        Set<String> range = new Set<String>();
        range = getEmployeeRange();
        List<Contact> nextLogicContacts = new List<Contact>();
        Map<Integer, String> mapPossibleValidRange = rangeMapPerStartValue(range);
        List<Integer> lstIntLowerValueOfValidRange = new List<Integer>(mapPossibleValidRange.keySet());
        lstIntLowerValueOfValidRange.sort();
        try {
            for(Contact contactObj : contactList){
                String upcomingEmployeeValue = contactObj.NumberOfEmployees__c;
                if(!String.isBlank(upcomingEmployeeValue)) {
                    if(isNumeric(upcomingEmployeeValue)) {
                        Integer intNumberOfEmployeeRangeValue = Integer.valueOf(upcomingEmployeeValue);
                        for(Integer intLowerRange : lstIntLowerValueOfValidRange){
                            if(intLowerRange <= intNumberOfEmployeeRangeValue){
                                contactObj.Employee_Size_History__c = upcomingEmployeeValue;
                                contactObj.NumberOfEmployees__c = mapPossibleValidRange.get(intLowerRange);
                            } else {    
                                break;
                            }
                        }
                    } 
                } 
            }
        } catch(exception ex) {}
    }
    
    public static void getCheckForBadValue(List<Contact> lstContact){ 
        try { 
            List<Contact> filteredContacts = new List<Contact>();    
            Set<String> range = new Set<String>();
            range.addAll(getPicklistValue());
            for(Contact contactObj : lstContact){
                if(!isValidValue(range, contactObj)) {
                    filteredContacts.add(contactObj);
                }
            }
            if(filteredContacts.size() == 0)
                return;
            String csvFile;
            String fileName='No_Employee_Mapping';
            String[] fileLines = new String[]{}; 
            Map<String,String> mapToGetGoodValueEmp = new Map<String,String>();  
            Map<String,String> mapToGetGoodValueInd = new Map<String,String>();  
            Map<String,String> mapToGetGoodValueJob = new Map<String,String>();  
            Map<String,String> mapToGetGoodValuePur = new Map<String,String>();  
            Map<String,Map<String,String>> masterMap = new Map<String,Map<String,String>>();     
            List<Contact_Field_Map__c> fieldlst = Contact_Field_Map__c.getAll().Values();
            
            List<Document> compareDoc=getMyDocument(fileName);
            if(compareDoc[0].body!=null){    
                system.debug('@@@MyName***'+compareDoc[0].body); 
                csvFile= compareDoc[0].body.toString();
                fileLines=csvFile.split('#EOL#'); 
                for(String line : fileLines){
                    if(!String.isBlank(line)) {
                        String[] inputvalues = line.split(',#,');                    
                        if(inputvalues != null && inputvalues.size() == 3){                     
                            If(inputvalues[0].trim().equalsIgnoreCase(NO_OF_EMPLOYEES)){                            
                                mapToGetGoodValueEmp.put(inputvalues[1].trim().tolowercase(),inputvalues[2].trim());                            
                            }                    
                        }
                    }
                }  
            }    
            system.debug('@@@@@@@@@@@@@Contact_Field_Map__c*********** '+fieldlst);    
            for(Contact_Field_Map__c lfp:fieldlst){       
                if(lfp.api_name__c.trim()== NO_OF_EMPLOYEES){
                    masterMap.put(String.valueOf(lfp.api_name__c).trim().tolowercase(),mapToGetGoodValueEmp);
                }    
            }
            system.debug('@@@@@@@@@@@@@Master MAP*********** '+masterMap);    
    
            for(Contact contactObj : filteredContacts){   
                if(masterMap.containsKey(NO_OF_EMPLOYEES) && !String.isBlank(String.valueof(contactObj.NumberOfEmployees__c)) && mapToGetGoodValueEmp.containsKey(String.valueof(contactObj.NumberOfEmployees__c).tolowercase())){
                        contactObj.Employee_Size_History__c = contactObj.NumberOfEmployees__c;
                        contactObj.NumberOfEmployees__c = masterMap.get(NO_OF_EMPLOYEES).get(contactObj.NumberOfEmployees__c.toLowerCase().trim());
                        //contactObj.NumberOfEmployees__c = mapToGetGoodValue.get(contactObj.NumberOfEmployees__c);
                }           
            }
        }catch(exception e){}
    }
    
    public static  boolean isNumeric( String numberOfEmployeeRange) {
        return Pattern.matches('^[0-9]{1,10}$', numberOfEmployeeRange);//^[0-9]+(\\.[0-9]+)?$
    }
    
    private static Boolean isValidValue(Set<String> range, Contact contactObj){ 
        if(range.contains(contactObj.NumberOfEmployees__c)){
            return true;
        }
        return false;
    }
    
    public static List<Document> getMyDocument(String docName){
        return [SELECT body, Name, bodyLength, ContentType, Url FROM Document WHERE Name = :docName];
    }
}