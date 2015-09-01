/*
	This is a Helper Class which is used for following purposes :
		CAMPAIGN ASSIGNMENT to LEAD
		Employee Range Validation
		Good and Bad Value Check for Employee Range based on CSV		
*/

public class LeadTriggerHelperExt {
	
	/**************************************************STATIC VARIABLE DECLARATION*********************************************************/
	private static String JOB_FUNCTION = 'Job_Function__c';
	private static String NO_OF_EMPLOYEES = 'numberofemployees__c';
	private static String INDUSTRY = 'Industry';
	private static String PURCHASE_TIMEFRAME = 'Purchase_Timeframe__c';
	/**************************************************************************************************************************************/
	
	/**********************Method to assign campaign on basis of Campaign Name to list of Leads***************************/
    public static void assignCampaignToList(String campName,List<Lead> leadList,Map<String, Campaign> campMap){
        for(List<Campaign> tempCampList : [SELECT Id, type,Lead_Creation_Score__c, Lead_Entry_Source__c, AID__c, PID__c, BMID__c, DNIS__c, Team__c,
        								   NumberOfLeads, Lead_Score__c, Name from Campaign where name = :campName AND IsActive = true limit 1]){
            if(tempCampList!=null && tempCampList.size() > 0){
	            Campaign tempCampObj = tempCampList.get(0);   
	            for(Lead trueWalkOnLead :leadList ){
	                trueWalkOnLead.Primary_Campaign__c = tempCampObj.Id;
	                trueWalkOnLead.Most_Recent_Campaign__c = tempCampObj.Id;
	                campMap.put((String)trueWalkOnLead.Primary_Campaign__c,tempCampObj);
	            }
            }
        }
    }
    /***********************************************************************************************************/
    
    /********************Returns Campaign Map on the basis of Campaign Id Set**************************************/
    public static map<String,Campaign> returnCampaignMap(Set<id> campaignIdSet){
        return new map<String,Campaign>([SELECT Id, type,Lead_Creation_Score__c, Lead_Entry_Source__c, AID__c, PID__c, BMID__c, DNIS__c, Team__c, NumberOfLeads, Lead_Score__c, Name from Campaign where Id in: campaignIdSet]); 
    }
    /*****************************************************************************/
	
	/***************Method for Campaign distribution in Leads*************************/
	public static Map<String, Campaign> assignCampaigns(List<Lead> leadList) {
		Map<String, Campaign> campaignMap = new Map<String, Campaign>();
		List<CampaignWrapper> camWrapperList = new List<CampaignWrapper>();  
		
		set<id> campaignIdSet = new set<id>(); 
		List<Lead> ListOfleadForSpecificCampn = new List<Lead>();
		List<Campaign> tempCampList = new List<Campaign>();
        List<Lead> inboundCallChatCampList = new List<Lead>(); 
        
        for(Lead leadObj : leadList) {          
            if(String.isBlank(leadObj.Primary_Campaign__c)){
                if(String.isBlank(leadObj.AID__c) && String.isBlank(leadObj.PID__c) && String.isBlank(leadObj.BMID__c) && String.isBlank(leadObj.Five9_DNIS__c) ){
                    if(leadObj.Lead_System_Source__c == 'LivePerson'){
                    	inboundCallChatCampList.add(leadObj);
                    }else{
                    	ListOfleadForSpecificCampn.add(leadObj);
                    }                    
                }else{
                    camWrapperList.add(new CampaignWrapper(leadObj.AID__c, leadObj.BMID__c, leadObj.PID__c, leadObj.Five9_DNIS__c,leadObj.Primary_Campaign__c, (leadObj.RecordTypeId == OpportunityHelper.getOppRecordTypeMap('Partner Leads'))));
                }
            }else{
                campaignIdSet.add(leadObj.Primary_Campaign__c);
                leadObj.Most_Recent_Campaign__c = leadObj.Primary_Campaign__c;
            }           
        }
        
        if(campaignIdSet!=null && campaignIdSet.size() > 0){
            campaignMap = returnCampaignMap(campaignIdSet);
        }
        
        if(ListOfleadForSpecificCampn!=null && ListOfleadForSpecificCampn.size() > 0){
            assignCampaignToList('True Walk-On',ListOfleadForSpecificCampn,campaignMap);
        }  
        
        if(inboundCallChatCampList!=null && inboundCallChatCampList.size() > 0){
            assignCampaignToList('Inbound Call/Chat',inboundCallChatCampList,campaignMap);
        }      
        
        if(camWrapperList!=null && camWrapperList.size() > 0){
        	//New Function "findCampaingsLogic" for Considering DNIS also for Campaign Calculation.
            Map<String, Campaign> criteriaToCamapaignMap = CampaignAssignmentHelper.findCampaingsLogic(camWrapperList);
            ListOfleadForSpecificCampn = new List<Lead>();
            for(Lead leadObj :leadList) {   
            	if(String.isBlank(leadObj.Primary_Campaign__c)){            
	                Campaign campaignObj = CampaignAssignmentHelper.getLeadCampaignLogic(new CampaignWrapper(leadObj.AID__c, leadObj.BMID__c, leadObj.PID__c, leadObj.Five9_DNIS__c,leadObj.Primary_Campaign__c, (leadObj.RecordTypeId == OpportunityHelper.getOppRecordTypeMap('Partner Leads'))), criteriaToCamapaignMap);                
	                if(campaignObj != null) {
	                    leadObj.Primary_Campaign__c = campaignObj.Id;
	                    leadObj.Most_Recent_Campaign__c = campaignObj.Id;
	                    campaignMap.put((String)leadObj.Primary_Campaign__c, campaignObj);
	                }else{
	                    ListOfleadForSpecificCampn.add(leadObj);
	                }
            	}
            }
            if(ListOfleadForSpecificCampn!=null && ListOfleadForSpecificCampn.size() > 0){
                assignCampaignToList('Broken Attribution',ListOfleadForSpecificCampn,campaignMap);
            }
        } 
		return campaignMap;
	}
	/*************************************************************************************************/
	
	/***************************Returns List of Documnemt Based on Document Name*********************/
	public static List<Document> getMyDocument(String docName){
        return [SELECT body, Name, bodyLength, ContentType, Url FROM Document WHERE Name = :docName];
    }
    /***********************************************************************************************/
    
    /************************************************************************************************
    *@Description: Check number of employee Value is Valid Range value or not                       *
    *@Params: Set<String>,Lead                                                                      *
    *@Returns: Boolean                                                                              *    
    *************************************************************************************************/
    private static Boolean isValidValue(Set<String> range, Lead leadObj){ 
        if(range.contains(leadObj.NumberOfEmployees__c)){
            return true;
        }
        return false;
    }
    
    /*************************************************************************************************
    *@Description: validating the number of employees is number and if number assign valid range to  *
    			   it.                                                                               *
    *@Params: List<Lead>                                                                             *
    *@Returns: Void                                                                                  *
    *@@Deployed Date:: 6-March-2014                                                                  *                                                                            *
    *@case No: 2399518																				 *
    *@Coded by: India Team                                                                           *
    **************************************************************************************************/
	public static void  validateEmployeeRangeForNumericValues(List<Lead> leadList) {
		Set<String> range = new Set<String>();
		range = getEmployeeRange();
		List<Lead> nextLogicLeads = new List<Lead>();
		Map<Integer, String> mapPossibleValidRange = rangeMapPerStartValue(range);
		List<Integer> lstIntLowerValueOfValidRange = new List<Integer>(mapPossibleValidRange.keySet());
		lstIntLowerValueOfValidRange.sort();
  		try {
			for(Lead leadObj : leadList){
				String upcomingEmployeeValue = leadObj.NumberOfEmployees__c;
				if(!String.isBlank(upcomingEmployeeValue)) {
					if(isNumeric(upcomingEmployeeValue)) {
						Integer intNumberOfEmployeeRangeValue = Integer.valueOf(upcomingEmployeeValue);
						for(Integer intLowerRange : lstIntLowerValueOfValidRange){
							if(intLowerRange <= intNumberOfEmployeeRangeValue){
								leadObj.Employee_Size_History__c = upcomingEmployeeValue;
								leadObj.NumberOfEmployees__c = mapPossibleValidRange.get(intLowerRange);
							} else {	
								break;
							}
						}
					} 
				} 
			}
  		} catch(exception ex) {}
	}
	/**********************************validateEmployeeRangeForNumericValues method end's here********/
	/*************************************************************************************************
    *@Description: Check number of employee lies between valid range or not  if it is numeric value  *
    *@Params: Set<String>                                                                            *
    *@Returns: Map<Integer, String>                                                                  *
    *@@Deployed Date:: 6-March-2014                                                                  *                                                                            *
    *@case No: 2399518                                                                               *
    *@Coded By: India Team                                                                           *
    **************************************************************************************************/
	private static Map<Integer, String> rangeMapPerStartValue(Set<String> range) {
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
	/*********************************** rangeMapPerStartValue ends here********************************/
	
	/****************************************************************************************************
    *@Description: Check number of employee is Number or not                                            *
    *@Params:String                                                                                     *
    *@Returns: Boolean															                        *
    *@Deployed Date: 06-March-14												                        * 
    *@Case No: 2399518 																					*
    *@Coded By: India Team                                                                              *
    *****************************************************************************************************/	
	public static  boolean isNumeric( String numberOfEmployeeRange) {
		return Pattern.matches('^[0-9]{1,10}$', numberOfEmployeeRange);//^[0-9]+(\\.[0-9]+)?$
	}
	/*********************** isNumeric method end's here*************************************************/
	
	/****************************************************************************************************
	 *@Description: getting Standard Value of No. Of Employee Range                                     *
    *@Params: no Parameters                                                                             *
    *@Returns: Set<String>                                                                              *
    *@Deployed Date: 06- March -14												                        *
    *@Case No: 2399518																					*
    *@Coded By: India Team                                                                              *
    *****************************************************************************************************/
	public static Set<String> getEmployeeRange() {
		Set<String> range = new Set<String>();
        range.addAll(LeadTriggerHelper.getPicklistValue());
        return range;
	}
	/*******************getEmployeeRange method Ends here************************************************/
	
	/****************************************************************************************************
    *@Description: Check good value against the bad value                                               *
    *@Params:List<Lead>                                                                                 *
    *@Returns: Void 															                        *
    *****************************************************************************************************/  
     public static void getCheckForBadValue(List<Lead> lstLead){ 
     	try { 
	        List<Lead> filteredLeads = new List<Lead>();    
	        Set<String> range = new Set<String>();
	        range.addAll(LeadTriggerHelper.getPicklistValue());
	        for(Lead leadObj : lstLead){
	            if(!isValidValue(range, leadObj)) {
	                filteredLeads.add(leadObj);
	            }
	        }
	        if(filteredLeads.size() == 0)
	            return;
	        String csvFile;
	        String fileName='No_Employee_Mapping';
	        String[] fileLines = new String[]{}; 
	        Map<String,String> mapToGetGoodValueEmp = new Map<String,String>();  
	        Map<String,String> mapToGetGoodValueInd = new Map<String,String>();  
	        Map<String,String> mapToGetGoodValueJob = new Map<String,String>();  
	        Map<String,String> mapToGetGoodValuePur = new Map<String,String>();  
	        Map<String,Map<String,String>> masterMap = new Map<String,Map<String,String>>();     
	        List<Lead_Field_Map__c> fieldlst = Lead_Field_Map__c.getAll().Values();
	        
	        List<Document> compareDoc=getMyDocument(fileName);
	        if(compareDoc[0].body!=null){ 
	            csvFile= compareDoc[0].body.toString();
	            fileLines=csvFile.split('#EOL#'); 
	            for(String line : fileLines){
	                if(!String.isBlank(line)) {
	                    String[] inputvalues = line.split(',#,');               
	                    if(inputvalues != null && inputvalues.size() == 3){                    	
	                    	If(inputvalues[0].trim().equalsIgnoreCase(NO_OF_EMPLOYEES)){
	                    		mapToGetGoodValueEmp.put(inputvalues[1].trim().tolowercase(),inputvalues[2].trim());                    		
	                    	}
	                    	if(inputvalues[0].trim().equalsIgnoreCase(INDUSTRY)){
	                    		mapToGetGoodValueInd.put(inputvalues[1].trim().tolowercase(),inputvalues[2].trim());                    	
	                    	}
							if(inputvalues[0].trim().equalsIgnoreCase(JOB_FUNCTION)){
	                    		mapToGetGoodValueJob.put(inputvalues[1].trim().tolowercase(),inputvalues[2].trim());                    	
	                    	}
	                    	if(inputvalues[0].trim().equalsIgnoreCase(PURCHASE_TIMEFRAME)){
	                    		mapToGetGoodValuePur.put(inputvalues[1].trim().tolowercase(),inputvalues[2].trim());                    		
	                    	}                       
	                    }
	                }
	            }  
	        }
	        for(Lead_Field_Map__c lfp:fieldlst){       
	        	if(lfp.api_name__c.trim()== NO_OF_EMPLOYEES){
	        		masterMap.put(String.valueOf(lfp.api_name__c).trim().tolowercase(),mapToGetGoodValueEmp);
	        	}
	        	if(lfp.api_name__c.trim()== PURCHASE_TIMEFRAME){
	        		masterMap.put(String.valueOf(lfp.api_name__c).trim().tolowercase(),mapToGetGoodValuePur);
	        	}
	        	if(lfp.api_name__c.trim()== JOB_FUNCTION){
	        		masterMap.put(String.valueOf(lfp.api_name__c).trim().tolowercase(),mapToGetGoodValueJob);
	        	}     
	        	if(lfp.api_name__c.trim()== INDUSTRY){
	        		masterMap.put(String.valueOf(lfp.api_name__c).trim().tolowercase(),mapToGetGoodValueInd);
	        	}      	
	        }
    
	        for(Lead leadObj : filteredLeads){   
	            if(masterMap.containsKey(NO_OF_EMPLOYEES) && !String.isBlank(String.valueof(leadObj.NumberOfEmployees__c)) && mapToGetGoodValueEmp.containsKey(String.valueof(leadObj.NumberOfEmployees__c).tolowercase())){
		                leadObj.Employee_Size_History__c = leadObj.NumberOfEmployees__c;
		                leadObj.NumberOfEmployees__c = masterMap.get(NO_OF_EMPLOYEES).get(leadObj.NumberOfEmployees__c.toLowerCase().trim());
		                //leadObj.NumberOfEmployees__c = mapToGetGoodValue.get(leadObj.NumberOfEmployees__c);
	            }		            
	            if(masterMap.containsKey(INDUSTRY) && !String.isBlank(String.valueof(leadObj.Industry)) && mapToGetGoodValueInd.containsKey(String.valueof(leadObj.Industry).toLowerCase())){
	                leadObj.Industry = masterMap.get(INDUSTRY).get(leadObj.Industry.toLowerCase().trim());                 
	            }
	            if(masterMap.containsKey(JOB_FUNCTION) && !String.isBlank(String.valueof(leadObj.Job_Function__c)) && mapToGetGoodValueJob.containsKey(String.valueof(leadObj.Job_Function__c).toLowerCase())){
	                 leadObj.Job_Function__c = masterMap.get(JOB_FUNCTION).get(leadObj.Job_Function__c.toLowerCase().trim());                 
	            }            
	            if(masterMap.containsKey(PURCHASE_TIMEFRAME) && !String.isBlank(leadObj.Purchase_Timeframe__c) && mapToGetGoodValuePur.containsKey(leadObj.Purchase_Timeframe__c.toLowerCase())){
	                 leadObj.Purchase_Timeframe__c = masterMap.get(PURCHASE_TIMEFRAME).get(leadObj.Purchase_Timeframe__c.toLowerCase().trim());                 
	            }           
	        }
        }catch(exception e){}
    } 
	/*******************************************************************************************************/	
}