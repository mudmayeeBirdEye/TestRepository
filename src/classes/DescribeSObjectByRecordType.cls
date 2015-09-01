/**************************************************************************************************
* Project Name..........: Code for enhancement                                                    *
* File..................: MilestoneUtils.class                                                    *
* Version...............: 1.0                                                                     *
* Created by............: eugenebasianomutya                                                      *
* Created Date..........: 27-02-2015                                                              *
* Last Modified by......: eugenebasianomutya                                                      *
* Last Modified Date....: 27-02-2015                                                              *
* Description...........: A flexible class that describe sObject and stores a map of RecordType   *
*                         Name, and map of RecordTypeId                                           *
*                         [This code is not yet implemented]                                      *         
***************************************************************************************************/

public class DescribeSObjectByRecordType {
	
	public Map<ID,Schema.RecordTypeInfo> rtMapByName;
	public Map<string,Schema.RecordTypeInfo> rtMapById;
	
	public void DescribeSObjectByRecordType(String ObjectName){
		String obj = ObjectName;
	
		Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
		Schema.SObjectType sobjType = gd.get(obj); 
		
		Schema.DescribeSObjectResult result = sobjType.getDescribe(); 
		Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
	    Map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
	    
	}

}