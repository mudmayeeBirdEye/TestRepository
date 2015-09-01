/**************************************************************************************************
* Project Name..........: Fake lead Deletion                                                      *
* File..................: FakeScheduledMethod.class                                               *
* Version...............: 1.0 																	  *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 																		  *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 27-02-2014                                                              *
* Description...........: This is schedular class which delete Fake Leads                         *
 **************************************************************************************************/
 
global class FakeScheduledMethod implements Schedulable {
/**************************************************************************************************
* @Description : Start method to execute the query.                                               *
* @Params : SchedulableContext.                                                                   *
* @Return : void                                                                                  *
***************************************************************************************************/
    global void execute(SchedulableContext ctx) { 
    	try{
    		/** GET ALL LEAD, CREATED WITHIN LAST 7 DAYS, TO BE CHECKED IN A LIST **/     
        	List<Lead> leadList = [SELECT Email, Name, CreatedDate, FirstName, LastName, Phone FROM Lead WHERE CreatedDate = LAST_N_DAYS:7]; 
        
       		List<Lead> leadListToDel = new List<Lead>();
       		List<String> lstLeadId = new List<String>();
        
       		/** GETTING ALL RECORD OF CUSTOM SETTING FAKELEAD **/
    		Map<String,FakeLead_1__c> mapFakeLead1Days = FakeLead_1__c.getAll();
    		Map<String,FakeLead_7__c> mapFakeLead7Days = FakeLead_7__c.getAll(); 
         	
         	mapFakeLead1Days = mapFakeLead1Days == null ? new Map<String,FakeLead_1__c>() : mapFakeLead1Days;
         	mapFakeLead7Days = mapFakeLead7Days == null ? new Map<String,FakeLead_7__c>() : mapFakeLead7Days;
         	
         	Map<String,FakeLead_1__c> mapFakeLead1DayIgnoreCase = new Map<String,FakeLead_1__c>();
         	Set<String> fakeLead1DayKey = mapFakeLead1Days.keySet();
         	
         	for(String strKey : fakeLead1DayKey){
         		String mapKey = strKey.toLowerCase();
         		FakeLead_1__c mapValue = mapFakeLead1Days.get(strKey);
         		mapFakeLead1DayIgnoreCase.put(mapKey,mapValue);
         	}
         	
         	Map<String,FakeLead_7__c> mapFakeLead7DayIgnoreCase = new Map<String,FakeLead_7__c>();
         	Set<String> fakeLead7DayKey = mapFakeLead7Days.keySet();
         	
         	for(String strKey : fakeLead7DayKey){
         		String mapKey = strKey.toLowerCase();
         		FakeLead_7__c mapValue = mapFakeLead7Days.get(strKey);
         		mapFakeLead7DayIgnoreCase.put(mapKey,mapValue);
         	}
         	
	        if (leadList != null && leadList.size() > 0){
				for(Lead objLead:leadList){ 
					//system.debug('>>>>>>@12>>>>>'+ objLead.FirstName); 
				    if(objLead.FirstName != null ){
				    	/** CHECKING THE LEADS FIRST NAME IS  SOMETHING OR  RCTU **/
				        if(mapFakeLead1DayIgnoreCase != null && mapFakeLead1DayIgnoreCase.containsKey((objLead.FirstName).toLowerCase())){
				        	FakeLead_1__c objCustomSettingLead = mapFakeLead1DayIgnoreCase.get(objLead.FirstName.toLowerCase());
				        	if(objCustomSettingLead != null){
				        		/**    CHECKING THE FIRST NAME IS SOMETHING AND LAST NAME IS NEW OR RCTU AND LAST NAME IS 2CALLS4ME AND IF IS CREATED ONE DAY BEFORE */
				        		if(objLead.CreatedDate.date().daysBetween(system.today())== 1 &&objLead.FirstName.equalsIgnoreCase(objCustomSettingLead.First_Name__c) 
				        			&& !String.isBlank(objLead.LastName) && objLead.LastName.equalsIgnoreCase(objCustomSettingLead.Last_Name__c) ) {
				        			leadListToDel.add(objLead);
				        			lstLeadId.add(objLead.id);
				        		} 
				        	}
				        }else {
				        	/** CHECKING LEADS FIRST NAME IS RINGCENTRAL AND LAST IS NAME RINGCENTRAL-TEST **/
				        	if(mapFakeLead7DayIgnoreCase != null && mapFakeLead7DayIgnoreCase.containsKey((objLead.FirstName).toLowerCase())){
				        		FakeLead_7__c objCustomSettingLead = mapFakeLead7DayIgnoreCase.get(objLead.FirstName.toLowerCase());
						        if(objCustomSettingLead != null){
							        if(objLead.FirstName.equalsIgnoreCase(objCustomSettingLead.First_Name__c) && !String.isBlank(objLead.LastName) 
							        			&& objLead.LastName.equalsIgnoreCase(objCustomSettingLead.Last_Name__c)) {
							        	leadListToDel.add(objLead);
							        	lstLeadId.add(objLead.id);
							        }
						        }
				        	}
						}  
				    } 
				}
			}
         
       
	       /** Delete all DFRs associated to a Fake Leads **/
	   		List<Demand_Funnel__c> lstDemandFunnelToDelete = new List<Demand_Funnel__c>();
	   		lstDemandFunnelToDelete = [SELECT d.id FROM Demand_Funnel__c d WHERE d.Lead__c IN :lstLeadId];
	   		
	   		if(lstDemandFunnelToDelete != null && lstDemandFunnelToDelete.size() >0){
	   			delete lstDemandFunnelToDelete;
	   		}	        
	        
	        /** DELETING ALL FAKE LEADS **/
	        if(!leadListToDel.isEmpty() && leadListToDel.size()>0){
	            delete leadListToDel;
	   		}
	   		
    	}catch(Exception ex){}
    }   
}