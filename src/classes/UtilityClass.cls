/**************************************************************************************************
* Project Name..........: Code for enhancement                                                    *
* File..................: UtilityClass.class                                                    *
* Version...............: 1.0                                                                     *
* Created by............: eugenebasianomutya                                                      *
* Created Date..........: 27-02-2015                                                              *
* Last Modified by......: eugenebasianomutya                                                      *
* Last Modified Date....: 27-02-2015                                                              *
* Description...........: List of reusable function												  *
*						  [This code is not yet implemented]                                      *         
***************************************************************************************************/

public with sharing class UtilityClass {

	public Map<ID,Schema.RecordTypeInfo> rtMapByName;
	public Map<string,Schema.RecordTypeInfo> rtMapById;


	/******************************************************************************
    * @Description : Describe sObject and stores a map of RecordType Name,	      *
	*                and map of RecordTypeId                                      *
    * @Params      : String,                                  					  *
    * @Return      : void                                                         * 
    ******************************************************************************/ 
    public void DescribeSObjectByRecordType(String ObjectName){
		String obj = ObjectName;
	
		Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
		Schema.SObjectType sobjType = gd.get(obj); 
		
		Schema.DescribeSObjectResult result = sobjType.getDescribe(); 
		map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
	    map<string,Schema.RecordTypeInfo> rtMapById = result.getRecordTypeInfosByName();
	    
	    system.debug('------------------ RECORD TYPE RESULT -------------------');
	    
	    system.debug('RECORD TYPE NAME: -------------------------------- ');
	    system.debug(rtMapByName);
	   
	    system.debug('RECORD TYPE ID: -------------------------------- ');
	    system.debug(rtMapById);
	    
	    system.debug('------------------ END RESULT ---------------------------');
	    
	}
    
    public Profile GetCurrentUserProfile(){
    	Profile prof = new Profile();
	    if(UserInfo.getProfileId() != NULL){
	    	List<Profile> profList = new List<Profile>([select Name from Profile where Id = :UserInfo.getProfileId() limit 1 ]);
	    	if(profList.size()>0){
	    		prof = profList[0];
	    		return prof;
	    	}
	    }
	     
	    return null;
    }
}