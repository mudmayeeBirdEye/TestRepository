public without sharing class DG_DFR_Class {
	public static boolean firstRun = true;
	public static boolean LeadAfterUpdate_FirstRun = true;
	public static boolean LeadAfterConvert_FirstRun = true;
	public static boolean ContactAfterUpdate_FirstRun = true;    
	
	public static void CreateLeadDFR(List<Lead> lds){
		system.debug('CreateLeadDFR=================');
		
		//Retrive lead recordtype api names from custom settings.  These are the recordtype related to DFR.
		list<String> DFRLeadRType = DG_DFR_Class.getDFRLeadRType();
		
		//Retrieve Lead Sources excluded for DFR creation from custom settings
		Set<String> ExcludedLS = DG_DFR_Class.getExcludedLeadSources();
				
		//Retrieve recordtype id of the corresponding lead record types
		Map<Id,String> mapRTId = new Map<Id,String>();
		for(RecordType r : [Select r.Id, r.DeveloperName From RecordType r where r.SobjectType = 'Lead'
			and r.DeveloperName in :DFRLeadRType]){
			mapRTId.put(r.Id,r.DeveloperName);
		}
		
		//Retrieve custom setting related to mapping lead statuses to funnel stages			
		map<String,String> mapStatusToStage = DG_DFR_Class.getDFRStatusToStage();
		
		map<String,Integer> mapStatusOrder = DG_DFR_Class.getDFRStatusOrder();
		
		list<Lead> listLead = new list<Lead>();
		list<Id> listOwnerId = new list<Id>();
		
		for(Lead ld : lds)
    	{
    		if(mapRTId.containsKey(ld.RecordTypeId) && !ld.Duplicate_Lead__c && !ExcludedLS.contains(ld.LeadSource)){
	    		if(mapStatusToStage.containsKey(ld.Status)){
	    			String vStage = mapStatusToStage.get(ld.Status);
	    			if(mapStatusOrder.containsKey(vStage)){
	    				listLead.add(ld);
	    				listOwnerId.add(ld.OwnerId);
	    			}
	    		}
    		}
    	}
					
		List<Demand_Funnel__c> DFRInsert = new List<Demand_Funnel__c>();
		
		//Build list of DFR to create if status translates to Prospect, MQL or SAL funnel stage.
		if(listLead.size() > 0){
			
			 //( ### SAL Handoff
			//Retrieve Users
			map<Id, User> mapUsers = new map<Id, User>();
			mapUsers.putAll([Select u.Id, u.UserRole.Name, u.Profile.Name, u.Name From User u where u.id in :listOwnerId]);
			//) ### SAL Handoff
			
			//Retrieve Employees
			map<Id, Employee__c> mapEmps = new map<Id, Employee__c>();
			for(Employee__c e :[Select e.User__c, e.Team__c, e.Division__c From Employee__c e where e.User__c in :mapUsers.keySet()]){
				mapEmps.put(e.User__c,e);
			}

	    	for(Lead ld : listLead){
	    		if(mapStatusToStage.containsKey(ld.Status)){
	    			String vStage = mapStatusToStage.get(ld.Status);
	    			if(mapStatusOrder.containsKey(vStage)){
	    				Integer vOrder = mapStatusOrder.get(vStage);
		    			Demand_Funnel__c DFR = new Demand_Funnel__c();
		    			
		    			//Get Owner Info
		    			String vOwnerName;
		    			String vOwnerRole;
		    			String vOwnerProfile;
		    			String vOwnerTeam;
		    			String vOwnerDivision;
		    			
	    				if(mapUsers.containsKey(ld.OwnerId)){
							vOwnerRole = mapUsers.get(ld.OwnerId).Userrole.Name;
							vOwnerProfile = mapUsers.get(ld.OwnerId).Profile.Name;
							vOwnerName = mapUsers.get(ld.OwnerId).Name;
							if(mapEmps.containsKey(ld.OwnerId)){
								vOwnerDivision = mapEmps.get(ld.OwnerId).Division__c;
								vOwnerTeam = mapEmps.get(ld.OwnerId).Team__c;
							}
						}
						DFR.DFR_Funnel_Type__c = 'Acquisition';
		    			//Prospect
		    			if(vOrder >= 1){
		    				DFR.Prospect_DateTime_Entered__c = datetime.Now();
							DFR.Prospect_Lead_Source__c = ld.LeadSource; 
							DFR.Prospect_Campaign__c = ld.Most_Recent_Campaign__c; 
							DFR.Prospect_Demographic_Score__c = ld.Demographic_Score__c;
							DFR.Prospect_Behavior_Score__c = ld.Behavior_Score__c;
							DFR.Prospect_Score__c = ld.mkto2__Lead_Score__c;
							DFR.Prospect_BMID__c = ld.BMID__c;
							DFR.Prospect_PID__c = ld.PID__c;
							DFR.Prospect_AID__c = ld.AID__c;		
							DFR.Prospect_Purchase_Timeframe__c = ld.Time_Frame__c;
							DFR.Prospect_Lead_Score_Category__c = ld.Lead_Score__c;
							//DFR.Prospect_Employee_Size__c = ld.NumberOfEmployees__c;
							DFR.Prospect_Employee_Size__c = ld.Effective_No_of_Employees_Range__c;
							DFR.Prospect_Owner_Role__c = vOwnerRole;
							DFR.Prospect_Owner_Name__c = vOwnerName;
							DFR.Prospect_Owner_Division__c = vOwnerDivision;
							DFR.Prospect_Owner_Team__c = vOwnerTeam;
	
							if(vOrder == 1){
								DFR.Pre_Opportunity_Status__c = 'Prospect';
								DFR.Prospect_Entered_From__c = 'Created';
								DFR.Lead__c = ld.Id;
								DFR.Lead_Name_on_Creation__c = (ld.FirstName != null ? ld.FirstName : '' ) + ' ' + ld.LastName;
								DFR.Lead_Email_on_Creation__c = ld.Email;
								DFRInsert.add(DFR); 
							} else {
								DFR.Prospect_Entered_From__c = 'Backfilled';
								DFR.Prospect_Exited_To__c = 'Backfilled';
								DFR.Prospect_DateTime_Exited__c = datetime.Now();
								DFR.Prospect_Backfilled__c = true;
							}

		    			}
		    			//MQL
		    			if(vOrder >= 2){
							DFR.MQL_DateTime_Entered__c = dateTime.Now();
							DFR.MQL_Lead_Source__c = ld.LeadSource; 
							DFR.MQL_Campaign__c = ld.Most_Recent_Campaign__c;			
							DFR.MQL_Demographic_Score__c = ld.Demographic_Score__c;
							DFR.MQL_Behavior_Score__c = ld.Behavior_Score__c;
							DFR.MQL_Score__c = ld.mkto2__Lead_Score__c;
							DFR.MQL_BMID__c = ld.BMID__c;
							DFR.MQL_PID__c = ld.PID__c;
							DFR.MQL_AID__c = ld.AID__c;			
							DFR.MQL_Purchase_Timeframe__c = ld.Time_Frame__c;
							DFR.MQL_Lead_Score_Category__c = ld.Lead_Score__c;
							//DFR.MQL_Employee_Size__c = ld.NumberOfEmployees__c;
							DFR.MQL_Employee_Size__c = ld.Effective_No_of_Employees_Range__c;	
							DFR.MQL_Owner_Role__c = vOwnerRole;
							DFR.MQL_Owner_Name__c = vOwnerName;
							DFR.MQL_Owner_Division__c = vOwnerDivision;
							DFR.MQL_Owner_Team__c = vOwnerTeam;		
							if(vOrder == 2){
								DFR.Pre_Opportunity_Status__c = 'MQL';
								DFR.MQL_Entered_From__c = 'Created';
								if(vStage == 'Re-New'){
									DFR.MQL_Type__c = 'Re-New';
								}else{
									DFR.MQL_Type__c = 'New';
								}
								DFR.Lead_Name_on_Creation__c = (ld.FirstName != null ? ld.FirstName : '' ) + ' ' + ld.LastName;
								DFR.Lead_Email_on_Creation__c = ld.Email;
								DFR.Lead__c = ld.Id;
								DFRInsert.add(DFR); 
							} else {
								DFR.MQL_Entered_From__c = 'Backfilled';
								DFR.MQL_Exited_To__c = 'Backfilled';
								DFR.MQL_DateTime_Exited__c = datetime.Now();
								DFR.MQL_Backfilled__c = true;
							}

		    			}
		    			//SAL
		    			if(vOrder == 3){
							DFR.SAL_DateTime_Entered__c = datetime.now();
							DFR.SAL_Lead_Source__c = ld.LeadSource; 
							DFR.SAL_Campaign__c = ld.Most_Recent_Campaign__c;
							DFR.SAL_Demographic_Score__c = ld.Demographic_Score__c;
							DFR.SAL_Behavior_Score__c = ld.Behavior_Score__c;
							DFR.SAL_Score__c = ld.mkto2__Lead_Score__c;
							DFR.SAL_BMID__c = ld.BMID__c;
							DFR.SAL_PID__c = ld.PID__c;
							DFR.SAL_AID__c = ld.AID__c;	
							DFR.SAL_Purchase_Timeframe__c = ld.Time_Frame__c;
							DFR.SAL_Lead_Score_Category__c = ld.Lead_Score__c;
							//DFR.SAL_Employee_Size__c = ld.NumberOfEmployees__c;
							DFR.SAL_Employee_Size__c = ld.Effective_No_of_Employees_Range__c;
							DFR.SAL_Owner_Role__c = vOwnerRole;
							DFR.SAL_Owner_Name__c = vOwnerName;
							DFR.SAL_Owner_Division__c = vOwnerDivision;
							DFR.SAL_Owner_Team__c = vOwnerTeam;
							DFR.Pre_Opportunity_Status__c = 'SAL';
							DFR.SAL_Entered_From__c = 'Created';
							DFR.Lead_Name_on_Creation__c = (ld.FirstName != null ? ld.FirstName : '' ) + ' ' + ld.LastName;
							DFR.Lead_Email_on_Creation__c = ld.Email;
							DFR.Lead__c = ld.Id;
							
							//( ### SAL Handoff
							if(vOwnerProfile != null && !vOwnerProfile.contains('SDR')){
							DFR.SAL_Handoff_Date__c = datetime.now();
							DFR.SAL_Handoff_Owner__c = vOwnerName;
							DFR.SAL_Handoff_Owner_Role__c = vOwnerRole;
							}
							//) ### SAL Handoff 
							
							DFRInsert.add(DFR);
		    			}
		    			    			
		    		}
	    		}

	    	}
	    	
		   	//Insert list of DFRs  	
	        if (DFRInsert.size()> 0){
				Database.SaveResult[] srInsert = Database.Insert(DFRInsert, false);	
				
				for (Database.SaveResult sr : srInsert) {
				    if (!sr.isSuccess()) {             
				        for(Database.Error err : sr.getErrors()) {
				            System.debug('DFR Creation Error: ' + err.getMessage());
				        }
				    }
				}
			}
		}
	}
		
	
	public static void DFR_LeadStatusChange(List<Lead> l, List<Lead> oldl){
		system.debug('DFR_LeadStatusChange=================');
		//Retrive lead recordtype api names from custom settings.  These are the recordtype related to DFR.
		list<String> DFRLeadRType = DG_DFR_Class.getDFRLeadRType();
		
		//Retrieve recordtype id of the corresponding lead record types
		Map<Id,String> mapRTId = new Map<Id,String>();
		for(RecordType r : [Select r.Id, r.DeveloperName From RecordType r where r.SobjectType = 'Lead'
			and r.DeveloperName in :DFRLeadRType]){
			mapRTId.put(r.Id,r.DeveloperName);
		}
		
		//Retrieve custom setting related to mapping lead statuses to funnel stages	
		map<String,String> mapStatusToStage = DG_DFR_Class.getDFRStatusToStage();
						
		List<Lead> listLead = new List<Lead>();
		List<Id> listLID = new List<Id>();
		list<Id> listOwnerId = new list<Id>();
		
		//Identify leads that move from one funnel stage to another based on translating their lead status to funnel stage.
		integer i;
        for (i=0; i<l.size(); i++){
        	if(mapRTId.containsKey(l[i].RecordTypeId) && !l[i].Duplicate_Lead__c){
	        	if(l[i].isConverted == false){
		        	if(mapStatusToStage.containsKey(l[i].Status) && mapStatusToStage.containsKey(oldl[i].Status)){
		        		String oldStage = mapStatusToStage.get(oldl[i].Status);
		        		String newStage = mapStatusToStage.get(l[i].Status);
		        		if(oldStage <> newStage){
		        			listLead.add(l[i]);
		        			listLID.add(l[i].id);
		        			listOwnerId.add(l[i].OwnerId);
		        		}
		        	}
	        	}   
        	}     	
        }
        
        if(listLID.size()>0){
	        
	         //( ### SAL Handoff
			//Retrieve Users
			map<Id, User> mapUsers = new map<Id, User>();
			mapUsers.putAll([Select u.Id, u.UserRole.Name, u.Profile.Name, u.Name From User u where u.id in :listOwnerId]);
			//) ### SAL Handoff
			
			//Retrieve Employees
			map<Id, Employee__c> mapEmps = new map<Id, Employee__c>();
			for(Employee__c e :[Select e.User__c, e.Team__c, e.Division__c From Employee__c e where e.User__c in :mapUsers.keySet()]){
				mapEmps.put(e.User__c,e);			
			}
			
			//Retrieve Lead Sources excluded for DFR creation from custom settings
			Set<String> ExcludedLS = DG_DFR_Class.getExcludedLeadSources();	
	        
	        map<String,Integer> mapStatusOrder = DG_DFR_Class.getDFRStatusOrder();
	        
	        //Retrieve DFR related to leads that move stages.        	
			Demand_Funnel__c[] DFRs = [Select d.Lead__c, d.id, d.Pre_Opportunity_Status__c From Demand_Funnel__c d 
			 				where d.Lead__c in :listLID and d.Pre_Opportunity_Close_Reason__c = Null and d.Opportunity__c = Null];
			
			//Mapping between Lead and DFR				
			map<id,Demand_Funnel__c> mapLeadDFR = new map<id,Demand_Funnel__c>();
					
			for(Demand_Funnel__c d: DFRs){
				mapLeadDFR.put(d.Lead__c,d);
			}
			
			//List use for inserting new DFR
			List<Demand_Funnel__c> DFRInsert = new List<Demand_Funnel__c>();
			
			//Mapping use to update existing DFR
			map<id,Demand_Funnel__c> mapDFRUpdate = new map<id,Demand_Funnel__c>();
		
			
			for(Lead ld: listLead){
					
				//Get Owner Info
    			String vOwnerName;
    			String vOwnerRole;
    			String vOwnerProfile;
    			String vOwnerTeam;
    			String vOwnerDivision;
    			
				if(mapUsers.containsKey(ld.OwnerId)){
					vOwnerRole = mapUsers.get(ld.OwnerId).Userrole.Name;
					vOwnerProfile = mapUsers.get(ld.OwnerId).Profile.Name;
					vOwnerName = mapUsers.get(ld.OwnerId).Name;
					if(mapEmps.containsKey(ld.OwnerId)){
						vOwnerDivision = mapEmps.get(ld.OwnerId).Division__c;
						vOwnerTeam = mapEmps.get(ld.OwnerId).Team__c;
					}
				}
				
				if(mapLeadDFR.containsKey(ld.id)){ //Check if lead has an active DFR from the map
					String vStage = mapStatusToStage.get(ld.Status);
					if(mapStatusOrder.containsKey(vStage)){
						Demand_Funnel__c DFR = mapLeadDFR.get(ld.id); //Get related DFR
	    				Integer vOrder = mapStatusOrder.get(vStage);
	    				Integer vOldOrder = mapStatusOrder.get(DFR.Pre_Opportunity_Status__c);						
							
						mapDFRUpdate.put(DFR.id, new Demand_Funnel__c(Id=DFR.id));  //Put related DFR in the map for update
													    			
		    			//MQL
		    			if(vOrder >= 2 && vOldOrder < 2){
		    				mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Entered__c',datetime.now());
							mapDFRUpdate.get(DFR.id).put('MQL_Lead_Source__c',ld.LeadSource);
							mapDFRUpdate.get(DFR.id).put('MQL_Campaign__c',ld.Most_Recent_Campaign__c);
							mapDFRUpdate.get(DFR.id).put('MQL_Demographic_Score__c',ld.Demographic_Score__c);
							mapDFRUpdate.get(DFR.id).put('MQL_Behavior_Score__c',ld.Behavior_Score__c);
							mapDFRUpdate.get(DFR.id).put('MQL_Score__c',ld.mkto2__Lead_Score__c);
							mapDFRUpdate.get(DFR.id).put('MQL_BMID__c',ld.BMID__c);
							mapDFRUpdate.get(DFR.id).put('MQL_PID__c',ld.PID__c);
							mapDFRUpdate.get(DFR.id).put('MQL_AID__c',ld.AID__c);
							mapDFRUpdate.get(DFR.id).put('MQL_Purchase_Timeframe__c',ld.Time_Frame__c);
							mapDFRUpdate.get(DFR.id).put('MQL_Lead_Score_Category__c',ld.Lead_Score__c);
							//mapDFRUpdate.get(DFR.id).put('MQL_Employee_Size__c',ld.NumberOfEmployees__c);
							mapDFRUpdate.get(DFR.id).put('MQL_Employee_Size__c',ld.Effective_No_of_Employees_Range__c);
							mapDFRUpdate.get(DFR.id).put('MQL_Owner_Name__c',vOwnerName);
							mapDFRUpdate.get(DFR.id).put('MQL_Owner_Role__c',vOwnerRole);
							mapDFRUpdate.get(DFR.id).put('MQL_Owner_Team__c',vOwnerTeam);
							mapDFRUpdate.get(DFR.id).put('MQL_Owner_Division__c',vOwnerDivision);
							if(vOrder == 2){
								mapDFRUpdate.get(DFR.id).put('MQL_Entered_From__c','MQL');
								if(vStage == 'Re-New'){
									mapDFRUpdate.get(DFR.id).put('MQL_Type__c','Re-New');
								}else{
									mapDFRUpdate.get(DFR.id).put('MQL_Type__c','New');
								}
			
								if(DFR.Pre_Opportunity_Status__c == 'Prospect'){
									mapDFRUpdate.get(DFR.id).put('Prospect_DateTime_Exited__c',datetime.Now());
									mapDFRUpdate.get(DFR.id).put('Prospect_Exited_To__c','MQL');
									mapDFRUpdate.get(DFR.id).put('MQL_Entered_From__c','Prospect');
			    				}
			    				mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Status__c','MQL');
							} else {
								mapDFRUpdate.get(DFR.id).put('MQL_Entered_From__c','Backfilled');
								mapDFRUpdate.get(DFR.id).put('MQL_Exited_To__c','Backfilled');
								mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Exited__c',datetime.now());
								mapDFRUpdate.get(DFR.id).put('MQL_Backfilled__c',true);
							}		    				
		    			}
		    			//SAL
		    			if(vOrder == 3 && vOldOrder < 3){
		    				mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Entered__c',datetime.now());
							mapDFRUpdate.get(DFR.id).put('SAL_Lead_Source__c',ld.LeadSource);
							mapDFRUpdate.get(DFR.id).put('SAL_Campaign__c',ld.Most_Recent_Campaign__c);
							mapDFRUpdate.get(DFR.id).put('SAL_Demographic_Score__c',ld.Demographic_Score__c);
							mapDFRUpdate.get(DFR.id).put('SAL_Behavior_Score__c',ld.Behavior_Score__c);
							mapDFRUpdate.get(DFR.id).put('SAL_Score__c',ld.mkto2__Lead_Score__c);
							mapDFRUpdate.get(DFR.id).put('SAL_BMID__c',ld.BMID__c);
							mapDFRUpdate.get(DFR.id).put('SAL_PID__c',ld.PID__c);
							mapDFRUpdate.get(DFR.id).put('SAL_AID__c',ld.AID__c);
							mapDFRUpdate.get(DFR.id).put('SAL_Purchase_Timeframe__c',ld.Time_Frame__c);
							mapDFRUpdate.get(DFR.id).put('SAL_Lead_Score_Category__c',ld.Lead_Score__c);
							//mapDFRUpdate.get(DFR.id).put('SAL_Employee_Size__c',ld.NumberOfEmployees__c);
							mapDFRUpdate.get(DFR.id).put('SAL_Employee_Size__c',ld.Effective_No_of_Employees_Range__c);
							mapDFRUpdate.get(DFR.id).put('SAL_Owner_Name__c',vOwnerName);
							mapDFRUpdate.get(DFR.id).put('SAL_Owner_Role__c',vOwnerRole);
							mapDFRUpdate.get(DFR.id).put('SAL_Owner_Team__c',vOwnerTeam);
							mapDFRUpdate.get(DFR.id).put('SAL_Owner_Division__c',vOwnerDivision);
							
							mapDFRUpdate.get(DFR.id).put('SAL_Entered_From__c','SAL');
							//( ### SAL Handoff
							if(vOwnerProfile != null && !vOwnerProfile.contains('SDR')){
							mapDFRUpdate.get(DFR.id).put('SAL_Handoff_Date__c', datetime.now());
							mapDFRUpdate.get(DFR.id).put('SAL_Handoff_Owner__c', vOwnerName);
							mapDFRUpdate.get(DFR.id).put('SAL_Handoff_Owner_Role__c', vOwnerRole);
							}
							//) ### SAL Handoff 
							if(DFR.Pre_Opportunity_Status__c == 'MQL'){
								mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Exited__c',datetime.now());
								mapDFRUpdate.get(DFR.id).put('MQL_Exited_To__c','SAL');
								mapDFRUpdate.get(DFR.id).put('SAL_Entered_From__c','MQL');
		    				}else if(DFR.Pre_Opportunity_Status__c == 'Prospect'){
								mapDFRUpdate.get(DFR.id).put('Prospect_DateTime_Exited__c',datetime.Now());
								mapDFRUpdate.get(DFR.id).put('Prospect_Exited_To__c','SAL');
								mapDFRUpdate.get(DFR.id).put('SAL_Entered_From__c','Prospect');
		    				}	
		    				mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Status__c','SAL');				
		    			}  
		    			//Downgraded
		    			if(vStage == 'Downgraded'){
							
							mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Close_Date__c',date.today());							
							mapDFRUpdate.get(DFR.id).put('EOL_DateTime_Entered__c',datetime.now());
							
							mapDFRUpdate.get(DFR.id).put('EOL_Lead_Source__c',ld.LeadSource);
							mapDFRUpdate.get(DFR.id).put('EOL_Campaign__c',ld.Most_Recent_Campaign__c);
							mapDFRUpdate.get(DFR.id).put('EOL_Demographic_Score__c',ld.Demographic_Score__c);
							mapDFRUpdate.get(DFR.id).put('EOL_Behavior_Score__c',ld.Behavior_Score__c);
							mapDFRUpdate.get(DFR.id).put('EOL_Score__c',ld.mkto2__Lead_Score__c);
							mapDFRUpdate.get(DFR.id).put('EOL_BMID__c',ld.BMID__c);
							mapDFRUpdate.get(DFR.id).put('EOL_PID__c',ld.PID__c);
							mapDFRUpdate.get(DFR.id).put('EOL_AID__c',ld.AID__c);
							mapDFRUpdate.get(DFR.id).put('EOL_Purchase_Timeframe__c',ld.Time_Frame__c);
							mapDFRUpdate.get(DFR.id).put('EOL_Lead_Score_Category__c',ld.Lead_Score__c);
							//mapDFRUpdate.get(DFR.id).put('EOL_Employee_Size__c',ld.NumberOfEmployees__c);
							mapDFRUpdate.get(DFR.id).put('EOL_Employee_Size__c',ld.Effective_No_of_Employees_Range__c);
							mapDFRUpdate.get(DFR.id).put('EOL_Owner_Name__c',vOwnerName);
							mapDFRUpdate.get(DFR.id).put('EOL_Owner_Role__c',vOwnerRole);
							mapDFRUpdate.get(DFR.id).put('EOL_Owner_Team__c',vOwnerTeam);
							mapDFRUpdate.get(DFR.id).put('EOL_Owner_Division__c',vOwnerDivision);
							mapDFRUpdate.get(DFR.id).put('EOL_Downgrade_Reason__c',ld.Downgrade_Reason__c);
                            mapDFRUpdate.get(DFR.id).put('EOL_Sub_Downgrade_Reason__c',ld.Sub_Downgrade_Reason__c);
							
							if(DFR.Pre_Opportunity_Status__c == 'SAL'){
								mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Exited__c',datetime.now());
								mapDFRUpdate.get(DFR.id).put('SAL_Exited_To__c',vStage);
								mapDFRUpdate.get(DFR.id).put('EOL_Entered_From__c','SAL');
							}else if(DFR.Pre_Opportunity_Status__c == 'MQL'){
								mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Exited__c',datetime.now());
								mapDFRUpdate.get(DFR.id).put('MQL_Exited_To__c',vStage);
								mapDFRUpdate.get(DFR.id).put('EOL_Entered_From__c','MQL');
							}else if(DFR.Pre_Opportunity_Status__c == 'Prospect'){
								mapDFRUpdate.get(DFR.id).put('Prospect_DateTime_Exited__c',datetime.Now());
								mapDFRUpdate.get(DFR.id).put('Prospect_Exited_To__c',vStage);
								mapDFRUpdate.get(DFR.id).put('EOL_Entered_From__c','Prospect');
							}	
							
							mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Close_Reason__c',vStage);	
		    			}
					}			  				
				}else{ // Leads that move stages without active DFR
		    		if(mapStatusToStage.containsKey(ld.Status)  && !ExcludedLS.contains(ld.LeadSource)){
		    			String vStage = mapStatusToStage.get(ld.Status);
		    			if(mapStatusOrder.containsKey(vStage)){
		    				Integer vOrder = mapStatusOrder.get(vStage);
			    			Demand_Funnel__c DFR = new Demand_Funnel__c();
			    			DFR.DFR_Funnel_Type__c = 'Acquisition';
			    			//Prospect
			    			if(vOrder >= 1){
			    				DFR.Prospect_DateTime_Entered__c = datetime.Now();
								DFR.Prospect_Lead_Source__c = ld.LeadSource; 
								DFR.Prospect_Campaign__c = ld.Most_Recent_Campaign__c; 
								DFR.Prospect_Demographic_Score__c = ld.Demographic_Score__c;
								DFR.Prospect_Behavior_Score__c = ld.Behavior_Score__c;
								DFR.Prospect_Score__c = ld.mkto2__Lead_Score__c;
								DFR.Prospect_BMID__c = ld.BMID__c;
								DFR.Prospect_PID__c = ld.PID__c;
								DFR.Prospect_AID__c = ld.AID__c;
								DFR.Prospect_Purchase_Timeframe__c = ld.Time_Frame__c;
								DFR.Prospect_Lead_Score_Category__c = ld.Lead_Score__c;
								//DFR.Prospect_Employee_Size__c = ld.NumberOfEmployees__c;
								DFR.Prospect_Employee_Size__c = ld.Effective_No_of_Employees_Range__c;
								DFR.Prospect_Owner_Role__c = vOwnerRole;
								DFR.Prospect_Owner_Name__c = vOwnerName;
								DFR.Prospect_Owner_Division__c = vOwnerDivision;
								DFR.Prospect_Owner_Team__c = vOwnerTeam;
								
								if(vOrder == 1){
									DFR.Pre_Opportunity_Status__c = 'Prospect';
									DFR.Prospect_Entered_From__c = 'Created';
									DFR.Lead_Name_on_Creation__c = (ld.FirstName != null ? ld.FirstName : '' ) + ' ' + ld.LastName;
									DFR.Lead_Email_on_Creation__c = ld.Email;
									DFR.Lead__c = ld.Id;
									DFRInsert.add(DFR); 
								} else {
									DFR.Prospect_Entered_From__c = 'Backfilled';
									DFR.Prospect_Exited_To__c = 'Backfilled';
									DFR.Prospect_DateTime_Exited__c = datetime.Now();
									DFR.Prospect_Backfilled__c = true;
								}
			    			}
			    			//MQL
			    			if(vOrder >= 2){
								DFR.MQL_DateTime_Entered__c = datetime.now();
								DFR.MQL_Lead_Source__c = ld.LeadSource; 
								DFR.MQL_Campaign__c = ld.Most_Recent_Campaign__c;
								DFR.MQL_Demographic_Score__c = ld.Demographic_Score__c;
								DFR.MQL_Behavior_Score__c = ld.Behavior_Score__c;
								DFR.MQL_Score__c = ld.mkto2__Lead_Score__c;
								DFR.MQL_BMID__c = ld.BMID__c;
								DFR.MQL_PID__c = ld.PID__c;
								DFR.MQL_AID__c = ld.AID__c;
								DFR.MQL_Purchase_Timeframe__c = ld.Time_Frame__c;
								DFR.MQL_Lead_Score_Category__c = ld.Lead_Score__c;
								//DFR.MQL_Employee_Size__c = ld.NumberOfEmployees__c;
								DFR.MQL_Employee_Size__c = ld.Effective_No_of_Employees_Range__c;
								DFR.MQL_Owner_Role__c = vOwnerRole;
								DFR.MQL_Owner_Name__c = vOwnerName;
								DFR.MQL_Owner_Division__c = vOwnerDivision;
								DFR.MQL_Owner_Team__c = vOwnerTeam;
								if(vOrder == 2){
									DFR.Pre_Opportunity_Status__c = 'MQL';
									DFR.MQL_Entered_From__c = 'Created';
									if(vStage == 'Re-New'){
										DFR.MQL_Type__c = 'Re-New';
									}else{
										DFR.MQL_Type__c = 'New';
									}
									DFR.Lead_Name_on_Creation__c = (ld.FirstName != null ? ld.FirstName : '' ) + ' ' + ld.LastName;
									DFR.Lead_Email_on_Creation__c = ld.Email;
									DFR.Lead__c = ld.Id;
									DFRInsert.add(DFR); 
								} else {
									DFR.MQL_Entered_From__c = 'Backfilled';
									DFR.MQL_Exited_To__c = 'Backfilled';
									DFR.MQL_DateTime_Exited__c = datetime.Now();
									DFR.MQL_Backfilled__c = true;
								}
			    			}
			    			//SAL
			    			if(vOrder == 3){
								DFR.SAL_DateTime_Entered__c = datetime.now();
								DFR.SAL_Entered_From__c = 'Created';
								DFR.SAL_Lead_Source__c = ld.LeadSource; 
								DFR.SAL_Campaign__c = ld.Most_Recent_Campaign__c;
								DFR.SAL_Demographic_Score__c = ld.Demographic_Score__c;
								DFR.SAL_Behavior_Score__c = ld.Behavior_Score__c;
								DFR.SAL_Score__c = ld.mkto2__Lead_Score__c;
								DFR.SAL_BMID__c = ld.BMID__c;
								DFR.SAL_PID__c = ld.PID__c;
								DFR.SAL_AID__c = ld.AID__c;
								DFR.SAL_Purchase_Timeframe__c = ld.Time_Frame__c;
								DFR.SAL_Lead_Score_Category__c = ld.Lead_Score__c;
								//DFR.SAL_Employee_Size__c = ld.NumberOfEmployees__c;
								DFR.SAL_Employee_Size__c = ld.Effective_No_of_Employees_Range__c;
								DFR.SAL_Owner_Role__c = vOwnerRole;
								DFR.SAL_Owner_Name__c = vOwnerName;
								DFR.SAL_Owner_Division__c = vOwnerDivision;
								DFR.SAL_Owner_Team__c = vOwnerTeam;
								DFR.Pre_Opportunity_Status__c = 'SAL';
								DFR.Lead_Name_on_Creation__c = (ld.FirstName != null ? ld.FirstName : '' ) + ' ' + ld.LastName;
								DFR.Lead_Email_on_Creation__c = ld.Email;
								DFR.Lead__c = ld.Id;
								//( ### SAL Handoff
								if(vOwnerProfile != null && !vOwnerProfile.contains('SDR')){
								DFR.SAL_Handoff_Date__c = datetime.now();
								DFR.SAL_Handoff_Owner__c = vOwnerName;
								DFR.SAL_Handoff_Owner_Role__c = vOwnerRole;
								}
								//) ### SAL Handoff
								DFRInsert.add(DFR);
			    			}	    			
			    		}
		    		}			
				}
		
			}
			
			//Update existing DFR
			if (mapDFRUpdate.size()> 0)
			{ 
				Database.SaveResult[] srUpdate = Database.Update(mapDFRUpdate.values(),false);
				
				for (Database.SaveResult sr : srUpdate) {
				    if (!sr.isSuccess()) {             
				        for(Database.Error err : sr.getErrors()) {
				            System.debug('DFR Update Error: ' + err.getMessage());
				        }
				    }
				}
			}
			
			//Create new DFR
			if (DFRInsert.size()> 0) 
			{
				Database.SaveResult[] srInsert = Database.Insert(DFRInsert, false);	
				
				for (Database.SaveResult sr : srInsert) {
				    if (!sr.isSuccess()) {             
				        for(Database.Error err : sr.getErrors()) {
				            System.debug('DFR Creation Error: ' + err.getMessage());
				        }
				    }
				}
			}
		
        }
	}
	
	public static void DFR_ConvertLead(Lead pLead){
        system.debug('DFR_ConvertLead=================');
        
        String strError = '';
        try{
            strError = StrError + 'Lead Id: ' + pLead.Id + ' \r\n';
            strError = StrError + 'Opportunity Id: ' + pLead.ConvertedOpportunityId + ' \r\n';
            strError = StrError + 'Contact Id: ' + pLead.ConvertedContactId + ' \r\n';
            strError = StrError + 'Account Id: ' + pLead.ConvertedAccountId + ' \r\n';      
            strError = StrError + '2700: Entered DFR_ConvertLead method' + ' \r\n';
        
            //Retrive lead recordtype api names from custom settings.  These are the recordtype related to DFR.
            list<String> DFRLeadRType = DG_DFR_Class.getDFRLeadRType();
            
            map<String,Integer> mapStatusOrder = DG_DFR_Class.getDFRStatusOrder();
            
            //Retrieve recordtype id of the corresponding lead record types
            Map<Id,String> mapRTId = new Map<Id,String>();
            for(RecordType r : [Select r.Id, r.DeveloperName From RecordType r where r.SobjectType = 'Lead'
                and r.DeveloperName in :DFRLeadRType]){
                mapRTId.put(r.Id,r.DeveloperName);
            }
            
            //Retrieve Lead Sources excluded for DFR creation from custom settings
            Set<String> ExcludedLS = DG_DFR_Class.getExcludedLeadSources();
                                                 
            Boolean vCreateDFR = True;
            
            strError = StrError + '2730: Retrived Custom Settings' + ' \r\n';
             
             if(mapRTId.containsKey(pLead.RecordTypeId) && !pLead.Duplicate_Lead__c){
                strError = StrError + '2735: Valid record and not duplicate' + ' \r\n';
                        
                //Retrieve DFRs related to converted lead
                Demand_Funnel__c activeDFR;
                //list<Demand_Funnel__c> listDFR = new list<Demand_Funnel__c>();
                map<id,Demand_Funnel__c> mapDFRUpdate = new map<id,Demand_Funnel__c>();
                
                for(Demand_Funnel__c d : [Select d.Lead__c, d.id, d.Pre_Opportunity_Status__c, d.Pre_Opportunity_Close_Reason__c, d.Opportunity__c, d.contact__c From Demand_Funnel__c d 
                where lead__c = :pLead.Id]){
                    if(d.Pre_Opportunity_Close_Reason__c == Null && d.Opportunity__c == Null && activeDFR == Null){
                        activeDFR = d;
                        strError = StrError + '2740: activeDFR Id: ' + activeDFR.id + ' \r\n';
                    }else{
                        mapDFRUpdate.put(d.id, new Demand_Funnel__c(Id=d.id, Contact__c=pLead.ConvertedContactId));     
                        //listDFR.add(d);
                    }               
                }
                
                strError = StrError + '2750: mapDFRUpdate count: ' + mapDFRUpdate.size() + ' \r\n';
                        
                //Retrieve DFR related to converted lead
                //Demand_Funnel__c[] DFRs = [Select d.Lead__c, d.id, d.Pre_Opportunity_Status__c    From Demand_Funnel__c d 
                //              where lead__c = :pLead.Id and d.Pre_Opportunity_Close_Reason__c = Null and d.Opportunity__c = Null LIMIT 1];
                            
                String vOwnerName;
                String vOwnerRole;
                String vOwnerTeam;
                String vOwnerDivision;
                                
                map<Id, User> mapUsers = new map<Id, User>();
                map<Id, Employee__c> mapEmps = new map<Id, Employee__c>(); 
                
                Opportunity o;
                if (pLead.ConvertedOpportunityId <> null){  
                    try{
                        o = [Select o.id, o.Primary_Opportunity_Contact__c, o.OwnerId, o.DFR_FromLeadConvert__c From Opportunity o
                        Where o.Id = :pLead.ConvertedOpportunityId LIMIT 1];
                        strError = StrError + '2760: Found opportunity' + ' \r\n';
                    } catch(Exception e) {
                        strError = StrError + 'Error-1  Querying Opportunity - '+ e.getMessage() + ' \r\n';
                    } 
                                
                    //Retrieve Users                
                    mapUsers.putAll([Select u.Id, u.UserRole.Name, u.Name From User u where u.id = :o.OwnerId]);
                    
                    //Retrieve Employees                
                    for(Employee__c e :[Select e.User__c, e.Team__c, e.Division__c From Employee__c e where e.User__c in :mapUsers.keySet()]){
                        mapEmps.put(e.User__c,e);
                    }   
                    
                    //Get Owner Info
                    if(mapUsers.containsKey(o.OwnerId)){
                        vOwnerRole = mapUsers.get(o.OwnerId).Userrole.Name;
                        vOwnerName = mapUsers.get(o.OwnerId).Name;
                        if(mapEmps.containsKey(o.OwnerId)){
                            vOwnerDivision = mapEmps.get(o.OwnerId).Division__c;
                            vOwnerTeam = mapEmps.get(o.OwnerId).Team__c;
                        }
                    }
                }
                
                Contact c;
                if (pLead.ConvertedContactId <> null){
                    try{                
                        c = [Select c.id, c.DFR_FromLeadConvert__c, c.DFR_Status__c, c.Contact_Funnel_Type__c
                    		 From Contact c Where c.Id = :pLead.ConvertedContactId LIMIT 1];
                        strError = StrError + '2770: Found contact' + ' \r\n';
                    } catch(Exception e) {
                        strError = StrError + 'Error-2  Querying Contact - '+ e.getMessage() + ' \r\n';
                    }         
                }
                map<Id, OpportunityContactRole> mapOCR = new map<Id, OpportunityContactRole>();
            
            if (pLead.ConvertedContactId <> null && pLead.ConvertedOpportunityId <> null){
                set<Id> setOId = new set<Id>();
                setOId.add(pLead.ConvertedOpportunityId);
                map <String, Id> mapOIDCID = getMapOpportunityContactRole(setOId);
                if(mapOIDCID.containsKey(pLead.ConvertedOpportunityId  + '~' + pLead.ConvertedContactId)){
                    Id OCRId =  mapOIDCID.get(pLead.ConvertedOpportunityId  + '~' + pLead.ConvertedContactId);              
                    mapOCR.put(OCRId, new OpportunityContactRole(Id = OCRId, IsPrimary = True));
                }
                
                if(mapOCR.size() > 0){
                    database.update(mapOCR.values(), false);
                }               
            }
            
            map <String,String> mapContactTypeToFunnelType = getContactTypeToFunnelType();                 
                if(activeDFR<>Null){ //Update existing DFR related to converted lead    
                    strError = StrError + '2780: Active DFR Id' + activeDFR.id + ' \r\n';               
                    
                    Demand_Funnel__c DFR = activeDFR;
                    mapDFRUpdate.put(DFR.id, new Demand_Funnel__c(Id=DFR.id));  
                    
                    if (pLead.ConvertedContactId <> null){
                        mapDFRUpdate.get(DFR.id).put('Contact__c',pLead.ConvertedContactId);    
                        c.DFR_FromLeadConvert__c = True;
                        c.DFR_Status__c = pLead.Status;
                        
                        strError = StrError + '2790: Before Contact Update' + ' \r\n';
                        
                        try {
                            update c;
                            if(String.IsNotBlank(c.Contact_Funnel_Type__c)){
	                            if(mapContactTypeToFunnelType.containsKey(c.Contact_Funnel_Type__c.ToLowerCase())){
	                        		mapDFRUpdate.get(DFR.id).put('DFR_Funnel_Type__c',mapContactTypeToFunnelType.get (c.Contact_Funnel_Type__c.ToLowerCase()));
	 							}
                            }
                        } catch (System.DmlException e) {
                            for (Integer i = 0; i < e.getNumDml(); i++) {
                                strError = StrError + 'Error: ' + e.getDmlMessage(i) + ' \r\n';
                            }
                        }
                                        
                    }
                    if (pLead.ConvertedAccountId <> null){
                        mapDFRUpdate.get(DFR.id).put('Account__c',pLead.ConvertedAccountId);
                    }
                    if (pLead.ConvertedOpportunityId <> null){                  
                        o.DFR_FromLeadConvert__c = True; 
                        o.Primary_Opportunity_Contact__c = pLead.ConvertedContactId;
                        
                        strError = StrError + '2800: Before Opportunity Update' + ' \r\n';
                        
                        try {
                            update o;
                            mapDFRUpdate.get(DFR.id).put('DFR_Primary_Role__c', True);
                        } catch (System.DmlException e) {
                            for (Integer i = 0; i < e.getNumDml(); i++) {
                                strError = StrError + 'Error: ' + e.getDmlMessage(i) + ' \r\n';
                            }
                        }
                        
                        Integer vOldOrder = mapStatusOrder.get(DFR.Pre_Opportunity_Status__c);  
                        
                        //MQL
                        if(vOldOrder < 2){
                            mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Entered__c',datetime.now());
                            mapDFRUpdate.get(DFR.id).put('MQL_Lead_Source__c',pLead.LeadSource);
                            mapDFRUpdate.get(DFR.id).put('MQL_Campaign__c',pLead.Most_Recent_Campaign__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_Demographic_Score__c',pLead.Demographic_Score__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_Behavior_Score__c',pLead.Behavior_Score__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_Score__c',pLead.mkto2__Lead_Score__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_BMID__c',pLead.BMID__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_PID__c',pLead.PID__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_AID__c',pLead.AID__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_Purchase_Timeframe__c',pLead.Time_Frame__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_Lead_Score_Category__c',pLead.Lead_Score__c);
                            //mapDFRUpdate.get(DFR.id).put('MQL_Employee_Size__c',pLead.NumberOfEmployees__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_Employee_Size__c',pLead.Effective_No_of_Employees_Range__c);
                            mapDFRUpdate.get(DFR.id).put('MQL_Owner_Name__c',vOwnerName);
                            mapDFRUpdate.get(DFR.id).put('MQL_Owner_Role__c',vOwnerRole);
                            mapDFRUpdate.get(DFR.id).put('MQL_Owner_Team__c',vOwnerTeam);
                            mapDFRUpdate.get(DFR.id).put('MQL_Owner_Division__c',vOwnerDivision);
                            mapDFRUpdate.get(DFR.id).put('MQL_Entered_From__c','Backfilled');
                            mapDFRUpdate.get(DFR.id).put('MQL_Exited_To__c','Backfilled');
                            mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Exited__c',datetime.now());
                            mapDFRUpdate.get(DFR.id).put('MQL_Backfilled__c',true);                     
                        }
                        //SAL
                        if(vOldOrder < 3){
                            mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Entered__c',datetime.now());
                            mapDFRUpdate.get(DFR.id).put('SAL_Lead_Source__c',pLead.LeadSource);
                            mapDFRUpdate.get(DFR.id).put('SAL_Campaign__c',pLead.Most_Recent_Campaign__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_Demographic_Score__c',pLead.Demographic_Score__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_Behavior_Score__c',pLead.Behavior_Score__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_Score__c',pLead.mkto2__Lead_Score__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_BMID__c',pLead.BMID__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_PID__c',pLead.PID__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_AID__c',pLead.AID__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_Purchase_Timeframe__c',pLead.Time_Frame__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_Lead_Score_Category__c',pLead.Lead_Score__c);
                            //mapDFRUpdate.get(DFR.id).put('SAL_Employee_Size__c',pLead.NumberOfEmployees__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_Employee_Size__c',pLead.Effective_No_of_Employees_Range__c);
                            mapDFRUpdate.get(DFR.id).put('SAL_Owner_Name__c',vOwnerName);
                            mapDFRUpdate.get(DFR.id).put('SAL_Owner_Role__c',vOwnerRole);
                            mapDFRUpdate.get(DFR.id).put('SAL_Owner_Team__c',vOwnerTeam);
                            mapDFRUpdate.get(DFR.id).put('SAL_Owner_Division__c',vOwnerDivision);
                            mapDFRUpdate.get(DFR.id).put('SAL_Entered_From__c','Backfilled');
                            mapDFRUpdate.get(DFR.id).put('SAL_Exited_To__c','Backfilled');
                            mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Exited__c',datetime.now());
                            mapDFRUpdate.get(DFR.id).put('SAL_Backfilled__c',true);             
                        }  
                        
                        mapDFRUpdate.get(DFR.id).put('Opportunity__c',pLead.ConvertedOpportunityId);
                        mapDFRUpdate.get(DFR.id).put('SQL_DateTime_Entered__c',datetime.now());
                        mapDFRUpdate.get(DFR.id).put('SQL_Lead_Source__c',pLead.LeadSource);
                        mapDFRUpdate.get(DFR.id).put('SQL_Campaign__c',pLead.Most_Recent_Campaign__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_Demographic_Score__c',pLead.Demographic_Score__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_Behavior_Score__c',pLead.Behavior_Score__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_Score__c',pLead.mkto2__Lead_Score__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_BMID__c',pLead.BMID__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_PID__c',pLead.PID__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_AID__c',pLead.AID__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_Purchase_Timeframe__c',pLead.Time_Frame__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_Lead_Score_Category__c',pLead.Lead_Score__c);
                        //mapDFRUpdate.get(DFR.id).put('SQL_Employee_Size__c',pLead.NumberOfEmployees__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_Employee_Size__c',pLead.Effective_No_of_Employees_Range__c);
                        mapDFRUpdate.get(DFR.id).put('SQL_Owner_Name__c',vOwnerName);
                        mapDFRUpdate.get(DFR.id).put('SQL_Owner_Role__c',vOwnerRole);
                        mapDFRUpdate.get(DFR.id).put('SQL_Owner_Team__c',vOwnerTeam);
                        mapDFRUpdate.get(DFR.id).put('SQL_Owner_Division__c',vOwnerDivision);
                        mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','SQL');
                        
                        if(DFR.Pre_Opportunity_Status__c == 'SAL'){
                            mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Exited__c',datetime.now());
                            mapDFRUpdate.get(DFR.id).put('SAL_Exited_To__c','SQL');
                            mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','SAL');                  
                        }else if(DFR.Pre_Opportunity_Status__c == 'MQL'){
                            mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Exited__c',datetime.now());
                            mapDFRUpdate.get(DFR.id).put('MQL_Exited_To__c','SQL');
                            mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','MQL');
                        }else if(DFR.Pre_Opportunity_Status__c == 'Prospect'){
                            mapDFRUpdate.get(DFR.id).put('Prospect_DateTime_Exited__c',datetime.Now());
                            mapDFRUpdate.get(DFR.id).put('Prospect_Exited_To__c','SQL');
                            mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','Prospect');
                        }   
                        mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Status__c','SQL');    
                    }
                    
                    //Update DFR
                    /*if (mapDFRUpdate.size()> 0)
                    { 
                        Database.SaveResult[] srUpdate = Database.Update(mapDFRUpdate.values(),false);
                        
                        for (Database.SaveResult sr : srUpdate) {
                            if (!sr.isSuccess()) {             
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('DFR Update Error: ' + err.getMessage());
                                }
                            }
                        }
                    }*/
    
                    vCreateDFR = False; //Set flag to not create DFR
                    strError = StrError + '2810: Completed setting values on existing DFR' + ' \r\n';
                 }
                
                if(vCreateDFR == True  && pLead.ConvertedOpportunityId <> null  && !ExcludedLS.contains(pLead.LeadSource)){ //Create DFR for converted lead
                    strError = StrError + '2820: DFR Creation on lead conversion' + ' \r\n';
                    
                    Demand_Funnel__c DFR = new Demand_Funnel__c();
                    DFR.DFR_Funnel_Type__c = 'Acquisition';
                    
                    if (pLead.ConvertedContactId <> null){
                        DFR.Contact__c = pLead.ConvertedContactId;  
                        c.DFR_FromLeadConvert__c = True;
                        c.DFR_Status__c = pLead.Status;
                        
                        strError = StrError + '2830: Before Contact Update' + ' \r\n';
                        update c; 
                        if(String.IsNotBlank(c.Contact_Funnel_Type__c)){
	                        if(mapContactTypeToFunnelType.containsKey(c.Contact_Funnel_Type__c.ToLowerCase())){
	                        	DFR.DFR_Funnel_Type__c = mapContactTypeToFunnelType.get(c.Contact_Funnel_Type__c.ToLowerCase());
	                    	}      
                        }    
                    }
                    if (pLead.ConvertedAccountId <> null){
                        DFR.Account__c = pLead.ConvertedAccountId;
                    }
                    if (pLead.ConvertedOpportunityId <> null){
                        o.Primary_Opportunity_Contact__c = pLead.ConvertedContactId;
                        o.DFR_FromLeadConvert__c = True; 
                        
                        strError = StrError + '2840: Before Opportunity Update' + ' \r\n';
                        update o;
                        DFR.DFR_Primary_Role__c = True;    
                        
                        //Prospect
                        DFR.Prospect_DateTime_Entered__c = datetime.Now();
                        DFR.Prospect_Lead_Source__c = pLead.LeadSource; 
                        DFR.Prospect_Campaign__c = pLead.Most_Recent_Campaign__c; 
                        DFR.Prospect_Demographic_Score__c = pLead.Demographic_Score__c;
                        DFR.Prospect_Behavior_Score__c = pLead.Behavior_Score__c;
                        DFR.Prospect_Score__c = pLead.mkto2__Lead_Score__c;
                        DFR.Prospect_BMID__c = pLead.BMID__c;
                        DFR.Prospect_PID__c = pLead.PID__c;
                        DFR.Prospect_AID__c = pLead.AID__c;     
                        DFR.Prospect_Purchase_Timeframe__c = pLead.Time_Frame__c;
                        DFR.Prospect_Lead_Score_Category__c = pLead.Lead_Score__c;
                        //DFR.Prospect_Employee_Size__c = pLead.NumberOfEmployees__c;
                        DFR.Prospect_Employee_Size__c = pLead.Effective_No_of_Employees_Range__c;
                        DFR.Prospect_Owner_Role__c = vOwnerRole;
                        DFR.Prospect_Owner_Name__c = vOwnerName;
                        DFR.Prospect_Owner_Division__c = vOwnerDivision;
                        DFR.Prospect_Owner_Team__c = vOwnerTeam;
                        DFR.Prospect_Entered_From__c = 'Backfilled';
                        DFR.Prospect_Exited_To__c = 'Backfilled';
                        DFR.Prospect_DateTime_Exited__c = datetime.Now();
                        DFR.Prospect_Backfilled__c = true;
    
                        //MQL
                        DFR.MQL_DateTime_Entered__c = dateTime.Now();
                        DFR.MQL_Lead_Source__c = pLead.LeadSource; 
                        DFR.MQL_Campaign__c = pLead.Most_Recent_Campaign__c;            
                        DFR.MQL_Demographic_Score__c = pLead.Demographic_Score__c;
                        DFR.MQL_Behavior_Score__c = pLead.Behavior_Score__c;
                        DFR.MQL_Score__c = pLead.mkto2__Lead_Score__c;
                        DFR.MQL_BMID__c = pLead.BMID__c;
                        DFR.MQL_PID__c = pLead.PID__c;
                        DFR.MQL_AID__c = pLead.AID__c;          
                        DFR.MQL_Purchase_Timeframe__c = pLead.Time_Frame__c;
                        DFR.MQL_Lead_Score_Category__c = pLead.Lead_Score__c;
                        //DFR.MQL_Employee_Size__c = pLead.NumberOfEmployees__c;
                        DFR.MQL_Employee_Size__c = pLead.Effective_No_of_Employees_Range__c;  
                        DFR.MQL_Owner_Role__c = vOwnerRole;
                        DFR.MQL_Owner_Name__c = vOwnerName;
                        DFR.MQL_Owner_Division__c = vOwnerDivision;
                        DFR.MQL_Owner_Team__c = vOwnerTeam;     
                        DFR.MQL_Entered_From__c = 'Backfilled';
                        DFR.MQL_Exited_To__c = 'Backfilled';
                        DFR.MQL_DateTime_Exited__c = datetime.Now();
                        DFR.MQL_Backfilled__c = true;
    
                        //SAL
                        DFR.SAL_DateTime_Entered__c = datetime.now();
                        DFR.SAL_Lead_Source__c = pLead.LeadSource; 
                        DFR.SAL_Campaign__c = pLead.Most_Recent_Campaign__c;
                        DFR.SAL_Demographic_Score__c = pLead.Demographic_Score__c;
                        DFR.SAL_Behavior_Score__c = pLead.Behavior_Score__c;
                        DFR.SAL_Score__c = pLead.mkto2__Lead_Score__c;
                        DFR.SAL_BMID__c = pLead.BMID__c;
                        DFR.SAL_PID__c = pLead.PID__c;
                        DFR.SAL_AID__c = pLead.AID__c;  
                        DFR.SAL_Purchase_Timeframe__c = pLead.Time_Frame__c;
                        DFR.SAL_Lead_Score_Category__c = pLead.Lead_Score__c;
                        //DFR.SAL_Employee_Size__c = pLead.NumberOfEmployees__c;
                        DFR.SAL_Employee_Size__c = pLead.Effective_No_of_Employees_Range__c;
                        DFR.SAL_Owner_Role__c = vOwnerRole;
                        DFR.SAL_Owner_Name__c = vOwnerName;
                        DFR.SAL_Owner_Division__c = vOwnerDivision;
                        DFR.SAL_Owner_Team__c = vOwnerTeam; 
                        DFR.SAL_Entered_From__c = 'Backfilled';
                        DFR.SAL_Exited_To__c = 'Backfilled';
                        DFR.SAL_DateTime_Exited__c = datetime.Now();
                        DFR.SAL_Backfilled__c = true;
                        
                        //SQL
                        DFR.Opportunity__c = pLead.ConvertedOpportunityId;
                        DFR.SQL_DateTime_Entered__c = datetime.now();
                        DFR.SQL_Lead_Source__c = pLead.LeadSource;
                        DFR.SQL_Campaign__c = pLead.Most_Recent_Campaign__c;
                        DFR.SQL_Demographic_Score__c = pLead.Demographic_Score__c;
                        DFR.SQL_Behavior_Score__c = pLead.Behavior_Score__c;
                        DFR.SQL_Score__c = pLead.mkto2__Lead_Score__c;
                        DFR.SQL_BMID__c = pLead.BMID__c;
                        DFR.SQL_PID__c = pLead.PID__c;
                        DFR.SQL_AID__c = pLead.AID__c;
                        DFR.SQL_Purchase_Timeframe__c = pLead.Time_Frame__c;
                        DFR.SQL_Lead_Score_Category__c = pLead.Lead_Score__c;
                        //DFR.SQL_Employee_Size__c = pLead.NumberOfEmployees__c;
                        DFR.SQL_Employee_Size__c = pLead.Effective_No_of_Employees_Range__c;
                        DFR.SQL_Owner_Role__c = vOwnerRole;
                        DFR.SQL_Owner_Name__c = vOwnerName;
                        DFR.SQL_Owner_Division__c = vOwnerDivision;
                        DFR.SQL_Owner_Team__c = vOwnerTeam; 
                        DFR.SQL_Entered_From__c = 'Created';
                        
                        DFR.Lead_Name_on_Creation__c = (pLead.FirstName != null ? pLead.FirstName : '' ) + ' ' + pLead.LastName;
                        DFR.Lead_Email_on_Creation__c = pLead.Email;            
                        DFR.Pre_Opportunity_Status__c = 'SQL';  
                    }
                    
                    //Insert new DFR for converted lead 
                    strError = StrError + '2850: DFR creation Attempt' + ' \r\n';       
                    try {
                        insert DFR;
                    } catch (System.DmlException e) {
                        for (Integer i = 0; i < e.getNumDml(); i++) {
                            System.debug('DFR Creation Error: ' + e.getDmlMessage(i)); 
                            strError = StrError + 'Error: ' + e.getDmlMessage(i) + ' \r\n';
                        }
                    }
                    strError = StrError + '2860: Success or failure for DFR creation' + ' \r\n';
                }
                
                //Update DFR
                strError = StrError + '2870: DFR Map Count: ' + mapDFRUpdate.size() + ' \r\n';
                
                if (mapDFRUpdate.size()> 0){
                        
                    /*if(listDFR.size()>0){
                        for(Demand_Funnel__c ld: listDFR){
                            mapDFRUpdate.put(ld.id, new Demand_Funnel__c(Id=ld.id, Contact__c=pLead.ConvertedContactId));   
                        }
                    }*/
                    
                    strError = StrError + '2880: DFR Commit Attemp' + ' \r\n';
        
                    Database.SaveResult[] srUpdate = Database.Update(mapDFRUpdate.values(),false);
                            
                    for (Database.SaveResult sr : srUpdate) {
                        if (!sr.isSuccess()) {             
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('DFR Update Error: ' + err.getMessage());
                                strError = StrError + '2900: ' + err.getMessage() + ' \r\n';
                            }
                        }
                    }
                    
                    strError = StrError + '2900: Successful DFR Commit' + ' \r\n';
                }
             
             }
        }catch(exception e){
            strError = StrError + 'Error: DFR_ConvertLead - '+ e.getMessage() + ' \r\n';
        }
                
        insert new Exception_And_Notification_History__c(
            Exception__c = 'Lead Conversion Exception - DFR_ConvertLead method - '+ System.Now().format(), 
            Exception_Desc__c = strError, Object_Type__c = 'DFR',
            RecordTypeId = '01280000000UF6F');   
    }		
	
	public static void DFR_AddOpportunity(Opportunity o){
        system.debug('DFR_AddOpportunity=================');
        String strError = '';
        
        try{
            strError = StrError + 'Opportunity Id: ' + o.id + ' \r\n';
            strError = StrError + 'Contact Id: ' + o.Primary_Opportunity_Contact__c + ' \r\n';
            strError = StrError + 'Account Id: ' + o.AccountId + ' \r\n';       
            strError = StrError + '2900: Entered DFR_AddOpportunity method' + ' \r\n';
            
            map<String,Integer> mapStatusOrder = DG_DFR_Class.getDFRStatusOrder();
            
            //Retrieve Users
            map<Id, User> mapUsers = new map<Id, User>();
            mapUsers.putAll([Select u.Id, u.UserRole.Name, u.Name From User u where u.id = :o.OwnerId]);
            
            //Retrieve Employees
            map<Id, Employee__c> mapEmps = new map<Id, Employee__c>();
            for(Employee__c e :[Select e.User__c, e.Team__c, e.Division__c From Employee__c e where e.User__c in :mapUsers.keySet()]){
                mapEmps.put(e.User__c,e);
            }
            
            //Retrieve Opportunity Contact Role
	        set<Id> setOId = new set<Id>();	        
	        setOId.add(o.Id);	        
	        set <String> setOIDCID = getOpportunityContactRole(setOId);	 
	        list <OpportunityContactRole > listOCR = new list <OpportunityContactRole >();
            
            //Get Owner Info
            String vOwnerName;
            String vOwnerRole;
            String vOwnerTeam;
            String vOwnerDivision;
            
            if(mapUsers.containsKey(o.OwnerId)){
                vOwnerRole = mapUsers.get(o.OwnerId).Userrole.Name;
                vOwnerName = mapUsers.get(o.OwnerId).Name;
                if(mapEmps.containsKey(o.OwnerId)){
                    vOwnerDivision = mapEmps.get(o.OwnerId).Division__c;
                    vOwnerTeam = mapEmps.get(o.OwnerId).Team__c;
                }
            }   
            
            //Retrieve DFR related to Primary Opportunity Contact
            Demand_Funnel__c[] DFRs = [Select d.id, d.Lead__c , d.Pre_Opportunity_Status__c, d.Contact__c From Demand_Funnel__c d 
                            where Contact__c = :o.Primary_Opportunity_Contact__c and Opportunity__c = Null and d.Pre_Opportunity_Close_Reason__c = Null
                            Order by d.CreatedDate DESC];
            
            //Retrieve Contact information              
            Contact c = [Select c.id, c.mkto2__Lead_Score__c, c.PID__c, c.Most_Recent_Campaign__c, c.FirstName, c.LastName, c.Email,
            				c.LeadSource, c.Demographic_Score__c, c.Behavior_Score__c, c.BMID__c, c.AID__c, c.NumberOfEmployees__c, c.Time_Frame__c,
            				c.Contact_Funnel_Type__c from Contact c where c.id = :o.Primary_Opportunity_Contact__c LIMIT 1];
            
            //Retrive Contact Type/Funnel Type mapping
            map <String,String> mapContactTypeToFunnelType = getContactTypeToFunnelType();
            
            Boolean vCreateDFR = True;
            
            if(DFRs.size() > 0){ //Update existing DFR
                strError = StrError + '2950: Active DFR found for contact' + ' \r\n';
                Demand_Funnel__c DFR = DFRs[0];
                map<id,Demand_Funnel__c> mapDFRUpdate = new map<id,Demand_Funnel__c>();
                mapDFRUpdate.put(DFR.id, new Demand_Funnel__c(Id=DFR.id));  
                
                Integer vOldOrder = mapStatusOrder.get(DFR.Pre_Opportunity_Status__c);  
                        
                //MQL
                if(vOldOrder < 2){
                    mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Entered__c',datetime.now());
                    mapDFRUpdate.get(DFR.id).put('MQL_Lead_Source__c',c.LeadSource);
                    mapDFRUpdate.get(DFR.id).put('MQL_Campaign__c',c.Most_Recent_Campaign__c );
                    mapDFRUpdate.get(DFR.id).put('MQL_Demographic_Score__c',c.Demographic_Score__c);
                    mapDFRUpdate.get(DFR.id).put('MQL_Behavior_Score__c',c.Behavior_Score__c);
                    mapDFRUpdate.get(DFR.id).put('MQL_Score__c',c.mkto2__Lead_Score__c); 
                    mapDFRUpdate.get(DFR.id).put('MQL_BMID__c',c.BMID__c);
                    mapDFRUpdate.get(DFR.id).put('MQL_PID__c',c.PID__c);
                    mapDFRUpdate.get(DFR.id).put('MQL_AID__c',c.AID__c);
                    mapDFRUpdate.get(DFR.id).put('MQL_Employee_Size__c',c.NumberOfEmployees__c);
                    mapDFRUpdate.get(DFR.id).put('MQL_Purchase_Timeframe__c',c.Time_Frame__c);
                    mapDFRUpdate.get(DFR.id).put('MQL_Owner_Name__c',vOwnerName);
                    mapDFRUpdate.get(DFR.id).put('MQL_Owner_Role__c',vOwnerRole);
                    mapDFRUpdate.get(DFR.id).put('MQL_Owner_Team__c',vOwnerTeam);
                    mapDFRUpdate.get(DFR.id).put('MQL_Owner_Division__c',vOwnerDivision);
                    mapDFRUpdate.get(DFR.id).put('MQL_Entered_From__c','Backfilled');
                    mapDFRUpdate.get(DFR.id).put('MQL_Exited_To__c','Backfilled');
                    mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Exited__c',datetime.now());
                    mapDFRUpdate.get(DFR.id).put('MQL_Backfilled__c',true);                     
                }
                //SAL
                if(vOldOrder < 3){
                    mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Entered__c',datetime.now());
                    mapDFRUpdate.get(DFR.id).put('SAL_Lead_Source__c',c.LeadSource);
                    mapDFRUpdate.get(DFR.id).put('SAL_Campaign__c',c.Most_Recent_Campaign__c );
                    mapDFRUpdate.get(DFR.id).put('SAL_Demographic_Score__c',c.Demographic_Score__c);
                    mapDFRUpdate.get(DFR.id).put('SAL_Behavior_Score__c',c.Behavior_Score__c);
                    mapDFRUpdate.get(DFR.id).put('SAL_Score__c',c.mkto2__Lead_Score__c); 
                    mapDFRUpdate.get(DFR.id).put('SAL_BMID__c',c.BMID__c);
                    mapDFRUpdate.get(DFR.id).put('SAL_PID__c',c.PID__c);
                    mapDFRUpdate.get(DFR.id).put('SAL_AID__c',c.AID__c);
                    mapDFRUpdate.get(DFR.id).put('SAL_Employee_Size__c',c.NumberOfEmployees__c);
                    mapDFRUpdate.get(DFR.id).put('SAL_Purchase_Timeframe__c',c.Time_Frame__c);
                    mapDFRUpdate.get(DFR.id).put('SAL_Owner_Name__c',vOwnerName);
                    mapDFRUpdate.get(DFR.id).put('SAL_Owner_Role__c',vOwnerRole);
                    mapDFRUpdate.get(DFR.id).put('SAL_Owner_Team__c',vOwnerTeam);
                    mapDFRUpdate.get(DFR.id).put('SAL_Owner_Division__c',vOwnerDivision);
                    mapDFRUpdate.get(DFR.id).put('SAL_Entered_From__c','Backfilled');
                    mapDFRUpdate.get(DFR.id).put('SAL_Exited_To__c','Backfilled');
                    mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Exited__c',datetime.now());
                    mapDFRUpdate.get(DFR.id).put('SAL_Backfilled__c',true);             
                }  
                
                mapDFRUpdate.get(DFR.id).put('Account__c',o.AccountId);
                mapDFRUpdate.get(DFR.id).put('Opportunity__c',o.Id);                            
                mapDFRUpdate.get(DFR.id).put('SQL_DateTime_Entered__c',datetime.now());
                mapDFRUpdate.get(DFR.id).put('SQL_Lead_Source__c',c.LeadSource);
                mapDFRUpdate.get(DFR.id).put('SQL_Campaign__c',c.Most_Recent_Campaign__c );
                mapDFRUpdate.get(DFR.id).put('SQL_Demographic_Score__c',c.Demographic_Score__c);
                mapDFRUpdate.get(DFR.id).put('SQL_Behavior_Score__c',c.Behavior_Score__c);
                mapDFRUpdate.get(DFR.id).put('SQL_Score__c',c.mkto2__Lead_Score__c); 
                mapDFRUpdate.get(DFR.id).put('SQL_BMID__c',c.BMID__c);
                mapDFRUpdate.get(DFR.id).put('SQL_PID__c',c.PID__c);
                mapDFRUpdate.get(DFR.id).put('SQL_AID__c',c.AID__c);
                mapDFRUpdate.get(DFR.id).put('SQL_Employee_Size__c',c.NumberOfEmployees__c);
                mapDFRUpdate.get(DFR.id).put('SQL_Purchase_Timeframe__c',c.Time_Frame__c);
                mapDFRUpdate.get(DFR.id).put('SQL_Owner_Name__c',vOwnerName);
                mapDFRUpdate.get(DFR.id).put('SQL_Owner_Role__c',vOwnerRole);
                mapDFRUpdate.get(DFR.id).put('SQL_Owner_Team__c',vOwnerTeam);
                mapDFRUpdate.get(DFR.id).put('SQL_Owner_Division__c',vOwnerDivision);
                mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','SQL');
                
                
                //Update DFR Funnel Type
                if(String.IsNotBlank(c.Contact_Funnel_Type__c)){
	                if(mapContactTypeToFunnelType.containsKey(c.Contact_Funnel_Type__c.ToLowerCase())){
	                     mapDFRUpdate.get(DFR.id).put('DFR_Funnel_Type__c',mapContactTypeToFunnelType.get (c.Contact_Funnel_Type__c.ToLowerCase()));
	                }
                }      		
                
                if(DFR.Pre_Opportunity_Status__c == 'SAL'){
                    mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Exited__c',datetime.now());
                    mapDFRUpdate.get(DFR.id).put('SAL_Exited_To__c','SQL');
                    mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','SAL');                  
                }else if(DFR.Pre_Opportunity_Status__c == 'MQL'){
                    mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Exited__c',datetime.now());
                    mapDFRUpdate.get(DFR.id).put('MQL_Exited_To__c','SQL');
                    mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','MQL');
                }else if(DFR.Pre_Opportunity_Status__c == 'Prospect'){
                    mapDFRUpdate.get(DFR.id).put('Prospect_DateTime_Exited__c',datetime.Now());
                    mapDFRUpdate.get(DFR.id).put('Prospect_Exited_To__c','SQL');
                    mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','Prospect');
                }   
                mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Status__c','SQL');    
                
                if(!setOIDCID.contains(o.id + '~' + c.id)){                
                	listOCR.add(new OpportunityContactRole(ContactId = c.id, OpportunityId = o.id));
            	}
                
                if (mapDFRUpdate.size()> 0) //Update DFR map
                { 
                    strError = StrError + '2960: Before update on Active DFR' + ' \r\n';
                    Database.SaveResult[] srUpdate = Database.Update(mapDFRUpdate.values(),false);
                    
                    for (Database.SaveResult sr : srUpdate) {
                        if (!sr.isSuccess()) {             
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('DFR Update Error: ' + err.getMessage());
                            }
                        }
                    }
                    strError = StrError + '2970: After update on Active DFR' + ' \r\n';
                }
                vCreateDFR = False; //Set DFR creation flag to false
             }
            
            if(vCreateDFR == True){ //Create DFR since one doesn't exist
                strError = StrError + '2980: Active DFR not found for Primary Contact' + ' \r\n';
                Demand_Funnel__c DFR = new Demand_Funnel__c();
                                
                DFR.Account__c = o.AccountId;
                DFR.Contact__c = o.Primary_Opportunity_Contact__c;
                DFR.Opportunity__c = o.Id;
                
                //Prospect
                DFR.Prospect_DateTime_Entered__c = datetime.Now();
                DFR.Prospect_Lead_Source__c = c.LeadSource;
                DFR.Prospect_Campaign__c = c.Most_Recent_Campaign__c ;
                DFR.Prospect_Demographic_Score__c = c.Demographic_Score__c;
                DFR.Prospect_Behavior_Score__c = c.Behavior_Score__c;
                DFR.Prospect_Score__c = c.mkto2__Lead_Score__c; 
                DFR.Prospect_BMID__c = c.BMID__c;
                DFR.Prospect_PID__c = c.PID__c;
                DFR.Prospect_AID__c = c.AID__c;
                DFR.Prospect_Employee_Size__c = c.NumberOfEmployees__c;
                DFR.Prospect_Purchase_Timeframe__c = c.Time_Frame__c;
                DFR.Prospect_Owner_Role__c = vOwnerRole;
                DFR.Prospect_Owner_Name__c = vOwnerName;
                DFR.Prospect_Owner_Division__c = vOwnerDivision;
                DFR.Prospect_Owner_Team__c = vOwnerTeam;
                DFR.Prospect_Entered_From__c = 'Backfilled';
                DFR.Prospect_Exited_To__c = 'Backfilled';
                DFR.Prospect_DateTime_Exited__c = datetime.Now();
                DFR.Prospect_Backfilled__c = true;
    
                //MQL
                DFR.MQL_DateTime_Entered__c = dateTime.Now();
                DFR.MQL_Lead_Source__c = c.LeadSource;
                DFR.MQL_Campaign__c = c.Most_Recent_Campaign__c ;
                DFR.MQL_Demographic_Score__c = c.Demographic_Score__c;
                DFR.MQL_Behavior_Score__c = c.Behavior_Score__c;
                DFR.MQL_Score__c = c.mkto2__Lead_Score__c; 
                DFR.MQL_BMID__c = c.BMID__c;
                DFR.MQL_PID__c = c.PID__c;
                DFR.MQL_AID__c = c.AID__c;
                DFR.MQL_Employee_Size__c = c.NumberOfEmployees__c;
                DFR.MQL_Purchase_Timeframe__c = c.Time_Frame__c;    
                DFR.MQL_Owner_Role__c = vOwnerRole;
                DFR.MQL_Owner_Name__c = vOwnerName;
                DFR.MQL_Owner_Division__c = vOwnerDivision;
                DFR.MQL_Owner_Team__c = vOwnerTeam; 
                DFR.MQL_Entered_From__c = 'Backfilled';
                DFR.MQL_Exited_To__c = 'Backfilled';
                DFR.MQL_DateTime_Exited__c = datetime.Now();
                DFR.MQL_Backfilled__c = true;
    
                //SAL
                DFR.SAL_DateTime_Entered__c = datetime.now();
                DFR.SAL_Lead_Source__c = c.LeadSource;
                DFR.SAL_Campaign__c = c.Most_Recent_Campaign__c ;
                DFR.SAL_Demographic_Score__c = c.Demographic_Score__c;
                DFR.SAL_Behavior_Score__c = c.Behavior_Score__c;
                DFR.SAL_Score__c = c.mkto2__Lead_Score__c; 
                DFR.SAL_BMID__c = c.BMID__c;
                DFR.SAL_PID__c = c.PID__c;
                DFR.SAL_AID__c = c.AID__c;
                DFR.SAL_Employee_Size__c = c.NumberOfEmployees__c;
                DFR.SAL_Purchase_Timeframe__c = c.Time_Frame__c;
                DFR.SAL_Owner_Role__c = vOwnerRole;
                DFR.SAL_Owner_Name__c = vOwnerName;
                DFR.SAL_Owner_Division__c = vOwnerDivision;
                DFR.SAL_Owner_Team__c = vOwnerTeam;
                DFR.SAL_Entered_From__c = 'Backfilled';
                DFR.SAL_Exited_To__c = 'Backfilled';
                DFR.SAL_DateTime_Exited__c = datetime.Now();
                DFR.SAL_Backfilled__c = true;   
                
                //SQL
                DFR.SQL_DateTime_Entered__c = datetime.now();
                DFR.SQL_Entered_From__c = 'Created';
                DFR.Account__c = o.AccountId;
                DFR.Opportunity__c = o.Id;                          
                DFR.SQL_Lead_Source__c = c.LeadSource;
                DFR.SQL_Campaign__c = c.Most_Recent_Campaign__c ;
                DFR.SQL_Demographic_Score__c = c.Demographic_Score__c;
                DFR.SQL_Behavior_Score__c = c.Behavior_Score__c;
                DFR.SQL_Score__c = c.mkto2__Lead_Score__c; 
                DFR.SQL_BMID__c = c.BMID__c;
                DFR.SQL_PID__c = c.PID__c;
                DFR.SQL_AID__c = c.AID__c;
                DFR.SQL_Employee_Size__c = c.NumberOfEmployees__c;
                DFR.SQL_Purchase_Timeframe__c = c.Time_Frame__c;
                DFR.SQL_Owner_Role__c = vOwnerRole;
                DFR.SQL_Owner_Name__c = vOwnerName;
                DFR.SQL_Owner_Division__c = vOwnerDivision;
                DFR.SQL_Owner_Team__c = vOwnerTeam;
                
                //Update DFR Funnel Type
                if(String.IsNotBlank(c.Contact_Funnel_Type__c)){
	                if(mapContactTypeToFunnelType.containsKey(c.Contact_Funnel_Type__c.ToLowerCase())){
	                     DFR.DFR_Funnel_Type__c = mapContactTypeToFunnelType.get (c.Contact_Funnel_Type__c.ToLowerCase());
	                }
                }
                
                //Make DFR as primary
                DFR.DFR_Primary_Role__c = True; 
                
                DFR.Contact_Name_on_Creation__c = (c.FirstName != null ? c.FirstName : '' ) + ' ' + c.LastName;
                DFR.Contact_Email_on_Creation__c = c.Email;         
                DFR.Pre_Opportunity_Status__c = 'SQL';  
                if(!setOIDCID.contains(o.id + '~' + c.id)){                
                	listOCR.add(new OpportunityContactRole(ContactId = c.id, OpportunityId = o.id));
                }
                
                strError = StrError + '2990: Before DFR Insert' + ' \r\n';
                try {
                    insert DFR;
                } catch (System.DmlException e) {
                    for (Integer i = 0; i < e.getNumDml(); i++) {
                        System.debug('DFR Creation Error: ' + e.getDmlMessage(i)); 
                        strError = StrError + 'Error: ' + e.getDmlMessage(i) + ' \r\n';
                    }
                }
                strError = StrError + '3000: After DFR Insert' + ' \r\n';
            }
            if(listOCR.size() > 0){
            	database.insert(listOCR, false);
        	}
        
        }catch(exception e){
            strError = StrError + 'Error: DFR_AddOpportunity - '+ e.getMessage() + ' \r\n';
        }
                
        insert new Exception_And_Notification_History__c(
            Exception__c = 'Lead Conversion Exception - DFR_AddOpportunity method - ' + System.Now().format(), 
            Exception_Desc__c = strError, Object_Type__c = 'DFR',
            RecordTypeId = '01280000000UF6F');  
    
    }
	
	public static void DFR_RemoveOpportunity(id pOid, id pCid){
		system.debug('DFR_RemoveOpportunity=================');
		//Retrieve existing DFR
	 	Demand_Funnel__c[] DFRs = [Select d.Lead__c, d.Id, d.Pre_Opportunity_Status__c 	From Demand_Funnel__c d 
	 	where Contact__c = :pCid and Opportunity__c = :pOid];
	 	
	 	if(DFRs.size() > 0){
		 	Demand_Funnel__c DFR = DFRs[0];
		 	
		 	//Add DFR to update in a map
			map<id,Demand_Funnel__c> mapDFRUpdate = new map<id,Demand_Funnel__c>();
			mapDFRUpdate.put(DFR.id, new Demand_Funnel__c(Id=DFR.id)); 	
		 	
		 	mapDFRUpdate.get(DFR.id).put('Opportunity__c',Null);		 			   		
	   		mapDFRUpdate.get(DFR.id).put('SQL_DateTime_Entered__c',Null);
	   		mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c',Null);	
			mapDFRUpdate.get(DFR.id).put('SQL_Lead_Source__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Campaign__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Demographic_Score__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Behavior_Score__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Score__c',Null); 
			mapDFRUpdate.get(DFR.id).put('SQL_BMID__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_PID__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_AID__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Employee_Size__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Purchase_Timeframe__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Lead_Score_Category__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Owner_Name__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Owner_Role__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Owner_Team__c',Null);
			mapDFRUpdate.get(DFR.id).put('SQL_Owner_Division__c',Null);
			mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Status__c','SAL');
			
			//Update existing DFR
 			if (mapDFRUpdate.size()> 0)
			{ 
				Database.SaveResult[] srUpdate = Database.Update(mapDFRUpdate.values(),false);
				
				for (Database.SaveResult sr : srUpdate) {
				    if (!sr.isSuccess()) {             
				        for(Database.Error err : sr.getErrors()) {
				            System.debug('DFR Update Error: ' + err.getMessage());
				        }
				    }
				}
			}
		}
	}
	
	 //( ### SAL Handoff
public static void SALHandOff_OnUpdate(List<Lead> tn, List<Lead> to){
	list<Id> listOwnerId = new list<Id>();
	for (integer i=0; i<tn.size(); i++){
		if(to[i].OwnerId <> tn[i].OwnerId){
			listOwnerId.add(to[i].OwnerId);
			listOwnerId.add(tn[i].OwnerId);
		}
	}
	if(listOwnerId.size() > 0){
		map<Id, User> mapUser = new map<Id, User>();
		mapUser.putAll([Select u.id, u.name, u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId
		From User u where u.id in :listOwnerId]);
		map<Id, Lead> mapLead = new map<Id, Lead>();
		for (integer i=0; i<tn.size(); i++){
			String OldOwnerProfile = mapUser.get(to[i].OwnerId) != null ? mapUser.get(to[i].OwnerId).Profile.Name : '';
			String NewOwnerProfile = mapUser.get(tn[i].OwnerId) != null ? mapUser.get(tn[i].OwnerId).Profile.Name : '';
			system.debug('### Profiles: ' + OldOwnerProfile + ' ' + NewOwnerProfile);
			if(OldOwnerProfile.contains('SDR') && !NewOwnerProfile.contains('SDR')){
				mapLead.put(tn[i].Id, tn[i]);
			}
		}
		if(mapLead.size() > 0){
			map<Id, Demand_Funnel__c> mapDFR = new map<Id, Demand_Funnel__c>();
			mapDFR.putAll([Select d.Id, d.SAL_Handoff_Owner__c, d.SAL_Handoff_Owner_Role__c, d.SAL_Handoff_Date__c,
			d.SAL_DateTime_Exited__c, d.SAL_DateTime_Entered__c, d.Lead__c
			From Demand_Funnel__c d where d.SAL_DateTime_Entered__c <> Null and d.SAL_DateTime_Exited__c = Null
			and d.Lead__c in :mapLead.keySet()]);
			if(mapDFR.size() > 0){
				for(Id k : mapDFR.keySet()){
					Demand_Funnel__c d = mapDFR.get(k);
					d.SAL_Handoff_Date__c = datetime.now();
					Id vOwnerId = mapLead.get(d.Lead__c).OwnerId;
					d.SAL_Handoff_Owner__c = mapUser.get(vOwnerId).Name;
					d.SAL_Handoff_Owner_Role__c = mapUser.get(vOwnerId).UserRole.Name;
					mapDFR.put(k, d);
				}
				database.update(mapDFR.values(), false);
			}
		}
	}
}
//) ### SAL Handoff
	/*
	public static void DFR_OpportunityClosed(List<Opportunity> o, List<Opportunity> oldo){
		list<String> DFROppRType = DG_DFR_Class.getDFROppRType(); 
		
		Map<Id,String> mapRTId = new Map<Id,String>();
		for(RecordType r : [Select r.Id, r.DeveloperName From RecordType r where r.SobjectType = 'Opportunity'
			and r.DeveloperName in :DFROppRType]){
			mapRTId.put(r.Id,r.DeveloperName);
		}		
		
		list<Id> listConId = new list<Id>();
		list<Id> listOppId = new list<Id>();
		list<Id> listOwnerId = new list<Id>();
		set<Id> setLostOppId = new set<Id>();
        map<Id, Opportunity> mapOpp = new map<Id, Opportunity>();
		
		integer i;
        for (i=0; i<o.size(); i++){
        	if(o[i].IsClosed <> oldo[i].IsClosed && o[i].IsClosed == true && mapRTId.containsKey(o[i].RecordTypeId) && o[i].Primary_Opportunity_Contact__c <> Null){
				listConId.add(o[i].Primary_Opportunity_Contact__c);
				listOppId.add(o[i].Id);
				listOwnerId.add(o[i].OwnerId);
				mapOpp.put(o[i].id, o[i]);
                if(!o[i].IsWon){
                    setLostOppId.add(o[i].Id);
                }
        	}     	
        }
        
        if(listOppId.size() > 0){
			Map<Id, Contact> mapDowngradeCon = new Map<Id, Contact>();
            
            for(OpportunityContactRole ocr : [Select o.OpportunityId, o.ContactId From OpportunityContactRole o
            where o.OpportunityId in :listOppId]){
                listConId.add(ocr.ContactId);
                if(setLostOppId.contains(ocr.OpportunityId)){ 
                    mapDowngradeCon.put(ocr.ContactId, new Contact(Id = ocr.ContactId, Contact_Status__c = 'Downgraded'));
                }
            }
				
			//Retrieve Users
			map<Id, User> mapUsers = new map<Id, User>();
			mapUsers.putAll([Select u.Id, u.UserRole.Name, u.Name From User u where u.id in :listOwnerId]);
			
			//Retrieve Employees
			map<Id, Employee__c> mapEmps = new map<Id, Employee__c>();
			for(Employee__c e :[Select e.User__c, e.Team__c, e.Division__c From Employee__c e where e.User__c in :mapUsers.keySet()]){
				mapEmps.put(e.User__c,e);
			}	
	        
	        Map<Id, Contact> mapCon = new Map<Id, Contact>();
	        
	        mapCon.putAll([Select c.id, c.mkto2__Lead_Score__c, c.PID__c, c.Most_Recent_Campaign__c, c.LeadSource, 
				c.Demographic_Score__c, c.Behavior_Score__c, c.BMID__c, c.AID__c, c.NumberOfEmployees__c, c.Time_Frame__c 
				from Contact c where c.id in :listConId]);
				
	   		Demand_Funnel__c[] listDFR = [Select d.Contact__c, d.id, d.Pre_Opportunity_Status__c, d.Opportunity__r.OwnerId From Demand_Funnel__c d 
	 				where d.Opportunity__c in :listOppId];
	 		
	 		//Mapping use to update existing DFR
			map<id,Demand_Funnel__c> mapDFRUpdate = new map<id,Demand_Funnel__c>();
					
	 		for(Demand_Funnel__c DFR : listDFR){
	 			
	 			if(mapCon.containsKey(DFR.Contact__c)){
		 			Contact c = mapCon.get(DFR.Contact__c); 
					//Get Owner Info
					String vOwnerName;
					String vOwnerRole;
					String vOwnerTeam;
					String vOwnerDivision;
					
					if(mapUsers.containsKey(DFR.Opportunity__r.OwnerId)){
						vOwnerRole = mapUsers.get(DFR.Opportunity__r.OwnerId).Userrole.Name;
						vOwnerName = mapUsers.get(DFR.Opportunity__r.OwnerId).Name;
						if(mapEmps.containsKey(DFR.Opportunity__r.OwnerId)){
							vOwnerDivision = mapEmps.get(DFR.Opportunity__r.OwnerId).Division__c;
							vOwnerTeam = mapEmps.get(DFR.Opportunity__r.OwnerId).Team__c;
						}
					} 			
		 			
		 			mapDFRUpdate.put(DFR.id, new Demand_Funnel__c(Id=DFR.id)); 
		 			
		 			mapDFRUpdate.get(DFR.id).put('EOL_DateTime_Entered__c',datetime.now());
					mapDFRUpdate.get(DFR.id).put('EOL_Lead_Source__c',c.LeadSource);
					mapDFRUpdate.get(DFR.id).put('EOL_Campaign__c',c.Most_Recent_Campaign__c );
					mapDFRUpdate.get(DFR.id).put('EOL_Demographic_Score__c',c.Demographic_Score__c);
					mapDFRUpdate.get(DFR.id).put('EOL_Behavior_Score__c',c.Behavior_Score__c);
					mapDFRUpdate.get(DFR.id).put('EOL_Score__c',c.mkto2__Lead_Score__c); 
					mapDFRUpdate.get(DFR.id).put('EOL_BMID__c',c.BMID__c);
					mapDFRUpdate.get(DFR.id).put('EOL_PID__c',c.PID__c);
					mapDFRUpdate.get(DFR.id).put('EOL_AID__c',c.AID__c);
					mapDFRUpdate.get(DFR.id).put('EOL_Employee_Size__c',c.NumberOfEmployees__c);
					mapDFRUpdate.get(DFR.id).put('EOL_Purchase_Timeframe__c',c.Time_Frame__c);
					mapDFRUpdate.get(DFR.id).put('EOL_Owner_Name__c',vOwnerName);
					mapDFRUpdate.get(DFR.id).put('EOL_Owner_Role__c',vOwnerRole);
					mapDFRUpdate.get(DFR.id).put('EOL_Owner_Team__c',vOwnerTeam);
					mapDFRUpdate.get(DFR.id).put('EOL_Owner_Division__c',vOwnerDivision);
					mapDFRUpdate.get(DFR.id).put('EOL_Entered_From__c','SQL');
					if(setLostOppId.contains(DFR.Opportunity__c)){
                        if(mapOpp.containsKey(DFR.Opportunity__c)){                     
                            mapDFRUpdate.get(DFR.id).put('EOL_Downgrade_Reason__c',mapOpp.get(DFR.Opportunity__c).Downgrade_Reason_Opp__c);
                            mapDFRUpdate.get(DFR.id).put('EOL_Sub_Downgrade_Reason__c',mapOpp.get(DFR.Opportunity__c).Sub_Downgrade_Reason__c);
                        }
                    }
		 		}
	 		}
	 		
	 		//Update existing DFR
			if (mapDFRUpdate.size()> 0)
			{ 
				Database.SaveResult[] srUpdate = Database.Update(mapDFRUpdate.values(),false);
				
				for (Database.SaveResult sr : srUpdate) {
				    if (!sr.isSuccess()) {             
				        for(Database.Error err : sr.getErrors()) {
				            System.debug('DFR Update Error: ' + err.getMessage());
				        }
				    }
				}
				if(mapDowngradeCon.size() > 0){
                    database.update(mapDowngradeCon.values(), false);
                }
			}
        }
	}*/
	
	public static list<String> getDFRLeadRType(){
		 
		list<String> listDFRRType = new list<String>();
		
		if(!test.isRunningTest()){	
			/* Replaced to use the getAll() method to retrieve custom settings.		
			for(DFR_Lead_Record_Types__c d : [Select name from DFR_Lead_Record_Types__c]){
				listDFRRType.add(d.name);
			}
			*/
			map<String, DFR_Lead_Record_Types__c> mapDFRRType = DFR_Lead_Record_Types__c.getAll();
            for(String k: mapDFRRType.keySet()){
            	listDFRRType.add(k);
        	}
		}else{
			listDFRRType =  new list<String>{'Sales_Leads','Partner_Leads'};
		}
		
		system.debug(listDFRRType);							 
		return listDFRRType;
	}
	
	public static list<String> getDFROppRType(){
		 
		list<String> listDFRRType = new list<String>();
		
		if(!test.isRunningTest()){			
			/* Replaced to use the getAll() method to retrieve custom settings.
			for(DFR_Opportunity_Record_Type__c d : [Select name from DFR_Opportunity_Record_Type__c]){
				listDFRRType.add(d.name);
			}
			*/
			map<String, DFR_Opportunity_Record_Type__c> mapDFRRType = DFR_Opportunity_Record_Type__c.getAll();
            for(String k: mapDFRRType.keySet()){
            	listDFRRType.add(k);
        	}
		}else{
			listDFRRType =  new list<String>{'Sales_Opportunity','VAR_Opportunity'};
		}
		
		system.debug(listDFRRType);							 
		return listDFRRType;
	}
	
	public static map<String,String> getDFRStatusToStage(){
		Map<String, String> mapStatusToStage = new Map<String, String>();	

		if(!test.isRunningTest()){
			/* Replaced to use the getAll() method to retrieve custom settings.
			for(Status_To_Stage__c d : [Select name, Stage__c from Status_To_Stage__c]){
				mapStatusToStage.put(d.name,d.Stage__c);
			}
			*/
			
			map<String, Status_To_Stage__c> mapDFRStatusToStage = Status_To_Stage__c.getAll();
            for(String k: mapDFRStatusToStage.keySet()){
            	mapStatusToStage.put(k,mapDFRStatusToStage.get(k).Stage__c);
        	}
		}else{
			mapStatusToStage =  new Map<String,String>{
			'.5 Re-New'=>'Re-New',
			'2. Contacted'=>'SAL',
			'X. Suspect'=>'Suspect',
			'1.5 Call Out'=>'SAL',
			'0. Downgraded'=>'Downgraded',
			'1. New C'=>'MQL',
			'1. New A'=>'MQL',
			'X. Open'=>'Prospect',
			'1. New'=>'MQL',
			'1. New D'=>'MQL',
			'1. New B'=>'MQL'};
		}
		
		system.debug(mapStatusToStage);	
		return mapStatusToStage;
	}
	
	public static map<String,Integer> getDFRStatusOrder(){
		Map<String,Integer> mapStatusOrder = new Map<String,Integer>{'Downgraded' => 0, 'Prospect' => 1,'MQL' => 2, 'Re-New' => 2, 'SAL' => 3, 'SQL' => 4};
		return mapStatusOrder;
	}
	  public static void DFR_ChangeLeadOwner(List<Lead> l, List<Lead> oldl){
                
        //Retrieve custom setting related to defined System Users
        map<String,String> mapDFRSystemUsers = DG_DFR_Class.getDFRSystemUsers();
                        
        list<Id> listOwnerId = new list<Id>();
        map<Id,Id> mapLID_OID = new map<Id,Id>();
        
        //Identify leads that change from defined System Users to non-System Users.
        integer i;
        for (i=0; i<l.size(); i++){
            //system.debug('###' + oldl[i].OwnerId);
            if(mapDFRSystemUsers.containsKey(oldl[i].OwnerId) && !mapDFRSystemUsers.containsKey(l[i].OwnerId)){
                if(l[i].isConverted == false){
                    listOwnerId.add(l[i].OwnerId);
                    mapLID_OID.put(l[i].id, l[i].OwnerId);
                }   
            }       
        }
        
        //system.debug('###' + mapLID_OID.size());
        if(mapLID_OID.size()>0){
            
            list<Demand_Funnel__c> listDFR = new list<Demand_Funnel__c>();
            
            //Retrieve active DFRs related to the leads meeting the criteria
            try{
                listDFR = [Select d.id, d.Lead__c,
                d.SQL_Owner_Team__c, d.SQL_Owner_Role__c, d.SQL_Owner_Name__c, d.SQL_Owner_Division__c, d.SQL_DateTime_Entered__c, 
                d.SAL_Owner_Team__c, d.SAL_Owner_Role__c, d.SAL_Owner_Name__c, d.SAL_Owner_Division__c, d.SAL_DateTime_Entered__c, 
                d.Prospect_Owner_Team__c, d.Prospect_Owner_Role__c, d.Prospect_Owner_Name__c, d.Prospect_Owner_Division__c, d.Prospect_DateTime_Entered__c, 
                d.MQL_Owner_Team__c, d.MQL_Owner_Role__c, d.MQL_Owner_Name__c, d.MQL_Owner_Division__c, d.MQL_DateTime_Entered__c, 
                d.EOL_Owner_Team__c, d.EOL_Owner_Role__c, d.EOL_Owner_Name__c, d.EOL_Owner_Division__c, d.EOL_DateTime_Entered__c 
                From Demand_Funnel__c d where d.Lead__c in :mapLID_OID.keySet() and DET_DFR_Status__c = 'Active'];
            }catch(exception e){}
            
            if(listDFR.size() > 0){
                map<String, String> mapSysFullName = new map<String, String>();
                
                for(String o : mapDFRSystemUsers.keySet()){
                    String vSysOwner = mapDFRSystemUsers.get(o);
                    mapSysFullName.put(vSysOwner, vSysOwner);
                }
                
                //Retrieve Users
                map<Id, User> mapUsers = new map<Id, User>();
                mapUsers.putAll([Select u.Id, u.UserRole.Name, u.Name From User u where u.id in :listOwnerId]);
            
                //Retrieve Employees
                map<Id, Employee__c> mapEmps = new map<Id, Employee__c>();
                for(Employee__c e :[Select e.User__c, e.Team__c, e.Division__c From Employee__c e where e.User__c in :mapUsers.keySet()]){
                    mapEmps.put(e.User__c,e);
                }
                
                for(Demand_Funnel__c dfr : listDFR){
                    //Get Owner Info
                    String vOwnerName;
                    String vOwnerRole;
                    String vOwnerTeam;
                    String vOwnerDivision;
                    
                    if(mapLID_OID.containsKey(dfr.Lead__c)){
                        Id vLeadOwnerId = mapLID_OID.get(dfr.Lead__c);
                        if(mapUsers.containsKey(vLeadOwnerId)){
                            vOwnerRole = mapUsers.get(vLeadOwnerId).Userrole.Name;
                            vOwnerName = mapUsers.get(vLeadOwnerId).Name;
                            if(mapEmps.containsKey(vLeadOwnerId)){
                                vOwnerDivision = mapEmps.get(vLeadOwnerId).Division__c;
                                vOwnerTeam = mapEmps.get(vLeadOwnerId).Team__c;
                            }
                        }
                    }
                    
                    //Update owner info on affected stages of the DFR
                    if(dfr.SAL_DateTime_Entered__c!=null && mapSysFullName.containsKey(dfr.SAL_Owner_Name__c)){
                        dfr.SAL_Owner_Team__c = vOwnerTeam;
                        dfr.SAL_Owner_Role__c = vOwnerRole;
                        dfr.SAL_Owner_Name__c = vOwnerName; 
                        dfr.SAL_Owner_Division__c = vOwnerDivision;                     
                    }
                    if(dfr.MQL_DateTime_Entered__c!=null && mapSysFullName.containsKey(dfr.MQL_Owner_Name__c)){
                        dfr.MQL_Owner_Team__c = vOwnerTeam;
                        dfr.MQL_Owner_Role__c = vOwnerRole;
                        dfr.MQL_Owner_Name__c = vOwnerName; 
                        dfr.MQL_Owner_Division__c = vOwnerDivision;                     
                    }
                    if(dfr.Prospect_DateTime_Entered__c!=null && mapSysFullName.containsKey(dfr.Prospect_Owner_Name__c)){
                        dfr.Prospect_Owner_Team__c = vOwnerTeam;
                        dfr.Prospect_Owner_Role__c = vOwnerRole;
                        dfr.Prospect_Owner_Name__c = vOwnerName; 
                        dfr.Prospect_Owner_Division__c = vOwnerDivision;                        
                    }                                       
                }
            }
            try{
                //Commit DFR update
                database.update(listDFR,false);
            }catch(exception e){}
        }
    }
            
            
    public static map<String,String> getDFRSystemUsers(){
        Map<String, String> mapDFRSystemUsers = new Map<String, String>();  

        if(!test.isRunningTest()){
        	/* Replaced to use the getAll() method to retrieve custom settings.
            for(DFR_System_Users__c d : [Select d.Name, d.Description__c From DFR_System_Users__c d]){
                mapDFRSystemUsers.put(d.name,d.Description__c);
            }
            */
            map<String, DFR_System_Users__c> mapSysUsers = DFR_System_Users__c.getAll();
            for(String k: mapSysUsers.keySet()){
            	mapDFRSystemUsers.put(k,mapSysUsers.get(k).Description__c);
        	}
        }else{
            mapDFRSystemUsers =  new Map<String,String>{
            '00580000005USPTAA4'=>'LAR System User',
            '005n0000000DhCCAA0'=>'LAR System User'};
        }
        
        system.debug(mapDFRSystemUsers);	
        return mapDFRSystemUsers;
    }
    
    public static Set<String> getExcludedLeadSources(){
        Set<String> setLS = new Set<String>();  

        if(!test.isRunningTest()){
        	map<String, DFRExcludedLeadSource__c> mapExcludedLS = DFRExcludedLeadSource__c.getAll();
        	for(String k: mapExcludedLS.keySet()){
        		setLS.add(mapExcludedLS.get(k).Lead_Source__c);
        	}
        }else{
           setLS.add('Test LS Test');
        }
         
        system.debug(setLS);
        return setLS;
    }
    
    private static map<String,CohortFieldMapping__c> getCohortCS(){
		 
		map<String,CohortFieldMapping__c> mapCohortCS = new map<String,CohortFieldMapping__c>();
		
		if(!test.isRunningTest()){			
			mapCohortCS = CohortFieldMapping__c.getAll();
		}else{
			mapCohortCS.put('1',new CohortFieldMapping__c (name = '1', Source_Field__c = 'LeadSource', Target_Field__c = 'Description'));
		}
										 
		return mapCohortCS;
	}
    
    
   	private static map<String,String> CohortFieldMapping(){
    	Map<String, Schema.SObjectField> mapLSchema = Schema.SObjectType.Lead.fields.getMap();
    	Map<String, CohortFieldMapping__c> mapCohortFieldMapping = getCohortCS();
    	Map<String, String> mapFieldMapping = new Map<String, String>();
    	

    	for(String k:mapCohortFieldMapping.keySet()){  
    		String vSource_Field = mapCohortFieldMapping.get(k).Source_Field__c;
    		String vTarget_Field = mapCohortFieldMapping.get(k).Target_Field__c;
		
    		if (vSource_Field <> Null && vSource_Field <> Null){
    			vSource_Field = vSource_Field.trim();
    			vTarget_Field = vTarget_Field.trim();
	    		if(mapLSchema.containsKey(vSource_Field) && mapLSchema.containsKey(vTarget_Field)){
	    			Schema.DescribeFieldResult TargetDescribe = mapLSchema.get(vTarget_Field).getDescribe();
	    			if(TargetDescribe.isUpdateable()){
		    			mapFieldMapping.put(vSource_Field,vTarget_Field);
	    			}
	    		}
    		}
    	}
    	return mapFieldMapping;
    }
    
    private static void populateCohortData(List<Lead> lds){

		Map<String, String> mapCohortFieldMapping = CohortFieldMapping();
		
		for(Lead l : lds) {
			l.First_Hand_Raise_Date__c = datetime.now();	    
			for(String k:mapCohortFieldMapping.keySet()){ 
				l.put(mapCohortFieldMapping.get(k), l.get(k));
			}
		} 
    }
    
    public static void FirstHandRaise_OnUpdate(List<Lead> tn, List<Lead> to){
    	list<Lead> listLead = new list<Lead>();
        for (integer i=0; i<tn.size(); i++){
        	if(to[i].First_Hand_Raise_Date__c == Null && to[i].Status == 'X. Suspect' && tn[i].Status <> 'X. Suspect' 
        	&& tn[i].Status <> Null && tn[i].Status <> '0. Downgraded'){
        		listLead.add(tn[i]);
        	}
        }
        
        if(listLead.size() > 0){
        	populateCohortData(listLead);
        }
    }
    
    public static void FirstHandRaise_OnInsert(List<Lead> tn){
    	list<Lead> listLead = new list<Lead>();
        for (integer i=0; i<tn.size(); i++){
        	if(tn[i].Status <> 'X. Suspect' && tn[i].Status <> Null && tn[i].Status <> '0. Downgraded'){
        		listLead.add(tn[i]);
        	}
        }
        
        if(listLead.size() > 0){
        	populateCohortData(listLead);
        }
    }
    
    public static map<String,String> getDFRContactStatusToStage(){
		Map<String, String> mapStatusToStage = new Map<String, String>();	

		if(!test.isRunningTest()){ 

			map<String, DFR_Contact_Status_To_Stage__c> mapDFRStatusToStage = DFR_Contact_Status_To_Stage__c.getAll();
            for(String k: mapDFRStatusToStage.keySet()){
            	mapStatusToStage.put(k,mapDFRStatusToStage.get(k).Stage__c);
        	}
		}else{
			mapStatusToStage =  new Map<String,String>{
			'New'=>'SAL',
			'Renew'=>'SAL'};
		}
		
		system.debug(mapStatusToStage);	
		return mapStatusToStage;
	}
        
    public static void DFR_ContactStatusChange(List<Contact> l, List<Contact> oldl){
				
		set<String> setExcludedUsers = getExcludedUsers();
		
		if(!setExcludedUsers.contains(UserInfo.getUserId())){
			//Retrieve custom setting related to mapping Contact statuses to funnel stages	
			map<String,String> mapStatusToStage = DG_DFR_Class.getDFRContactStatusToStage();
							
			list<Contact> listContact = new List<Contact>();
			list<Id> listLID = new List<Id>();
			list<Id> listOwnerId = new list<Id>();
			list<Id> listAId = new list<Id>();
			
			//Identify Contacts that move from one funnel stage to another based on translating their Contact status to funnel stage.
	        for (integer i=0; i<l.size(); i++){
	        	if(mapStatusToStage.containsKey(l[i].Contact_Status__c) && l[i].Contact_Status__c <> Oldl[i].Contact_Status__c){
	    			listContact.add(l[i]);
	    			listLID.add(l[i].id);
	    			listAId.add(l[i].AccountId);
	    			listOwnerId.add(l[i].OwnerId);
	        	}    	
	        }
	        
	        if(listLID.size()>0){
	        	//Retrieve custom setting related to mapping Contact Type to Funnel Type	
				map<String,String> mapContactTypeToFunnelType = getContactTypeToFunnelType();
				
				//Retrieve related accounts' open opportunity
				map<Id, Id> mapAIdOId = getAIdOId(listAId); 
		        
		        //Retrieve if open opportunities are already linked to existing DFR
		        set<Id> setOId = new set<Id>();
		        
		        for(Id k: mapAIdOId.keySet()){
		        	setOId.add(mapAIdOId.get(k));
		        }
		        
		        set<Id> setPriOId = getOppPrimaryStatus(setOId);
		        set<String> setOIDCID = getOpportunityContactRole(setOId);
		        
		        //Retrieve Users
				map<Id, User> mapUsers = new map<Id, User>();
				mapUsers.putAll([Select u.Id, u.UserRole.Name, u.Name From User u where u.id in :listOwnerId]);
				
				//Retrieve Employees
				map<Id, Employee__c> mapEmps = new map<Id, Employee__c>();
				for(Employee__c e :[Select e.User__c, e.Team__c, e.Division__c From Employee__c e where e.User__c in :mapUsers.keySet()]){
					mapEmps.put(e.User__c,e);			
				}
		        
		        map<String,Integer> mapStatusOrder = DG_DFR_Class.getDFRStatusOrder();
		        
		        //Retrieve DFR related to Contacts that move stages.        	
				Demand_Funnel__c[] DFRs = [Select d.Contact__c, d.id, d.Pre_Opportunity_Status__c, d.Opportunity__c From Demand_Funnel__c d 
				 				where d.Contact__c in :listLID and d.Pre_Opportunity_Close_Reason__c = Null];
				
				//Mapping between Contact and DFR				
				map<id,Demand_Funnel__c> mapContactDFR = new map<id,Demand_Funnel__c>();
						
				for(Demand_Funnel__c d: DFRs){
					mapContactDFR.put(d.Contact__c,d);
				}
				
				//List use for inserting new DFR
				List<Demand_Funnel__c> DFRInsert = new List<Demand_Funnel__c>();
				
				//Mapping use to update existing DFR
				map<id,Demand_Funnel__c> mapDFRUpdate = new map<id,Demand_Funnel__c>();
				
				list<OpportunityContactRole> listOCR = new list<OpportunityContactRole>();
				
				for(Contact ld: listContact){					
					//Get Owner Info
	    			String vOwnerName;
	    			String vOwnerRole;
	    			String vOwnerTeam;
	    			String vOwnerDivision;
	    			
					if(mapUsers.containsKey(ld.OwnerId)){
						vOwnerRole = mapUsers.get(ld.OwnerId).Userrole.Name;
						vOwnerName = mapUsers.get(ld.OwnerId).Name;
						if(mapEmps.containsKey(ld.OwnerId)){
							vOwnerDivision = mapEmps.get(ld.OwnerId).Division__c;
							vOwnerTeam = mapEmps.get(ld.OwnerId).Team__c;
						}
					}
					
					if(mapContactDFR.containsKey(ld.id)){ //Check if contact has an active DFR from the map
						String vStage = mapStatusToStage.get(ld.Contact_Status__c);
						if(mapStatusOrder.containsKey(vStage)){
							Demand_Funnel__c DFR = mapContactDFR.get(ld.id); //Get related DFR
		    				Integer vOrder = mapStatusOrder.get(vStage);
		    				Integer vOldOrder = mapStatusOrder.get(DFR.Pre_Opportunity_Status__c);						
								
							mapDFRUpdate.put(DFR.id, new Demand_Funnel__c(Id=DFR.id));  //Put related DFR in the map for update
														    			 
			    			//Downgraded
			    			if(vStage == 'Downgraded'){
								
								mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Close_Date__c',date.today());							
								mapDFRUpdate.get(DFR.id).put('EOL_DateTime_Entered__c',datetime.now());
								
								mapDFRUpdate.get(DFR.id).put('EOL_Lead_Source__c',ld.LeadSource);
								mapDFRUpdate.get(DFR.id).put('EOL_Campaign__c',ld.Most_Recent_Campaign__c);
								mapDFRUpdate.get(DFR.id).put('EOL_Demographic_Score__c',ld.Demographic_Score__c);
								mapDFRUpdate.get(DFR.id).put('EOL_Behavior_Score__c',ld.Behavior_Score__c);
								mapDFRUpdate.get(DFR.id).put('EOL_Score__c',ld.mkto2__Lead_Score__c);
								mapDFRUpdate.get(DFR.id).put('EOL_BMID__c',ld.BMID__c);
								mapDFRUpdate.get(DFR.id).put('EOL_PID__c',ld.PID__c);
								mapDFRUpdate.get(DFR.id).put('EOL_AID__c',ld.AID__c);
								mapDFRUpdate.get(DFR.id).put('EOL_Purchase_Timeframe__c',ld.Time_Frame__c);
								//mapDFRUpdate.get(DFR.id).put('EOL_Lead_Score_Category__c',ld.Lead_Score__c);
								mapDFRUpdate.get(DFR.id).put('EOL_Employee_Size__c',ld.NumberOfEmployees__c);
								mapDFRUpdate.get(DFR.id).put('EOL_Owner_Name__c',vOwnerName);
								mapDFRUpdate.get(DFR.id).put('EOL_Owner_Role__c',vOwnerRole);
								mapDFRUpdate.get(DFR.id).put('EOL_Owner_Team__c',vOwnerTeam);
								mapDFRUpdate.get(DFR.id).put('EOL_Owner_Division__c',vOwnerDivision);
								
								if(DFR.Opportunity__c <> Null){
									//mapDFRUpdate.get(DFR.id).put('SQL_DateTime_Exited__c',datetime.now());
									//mapDFRUpdate.get(DFR.id).put('SQL_Exited_To__c',vStage);
									mapDFRUpdate.get(DFR.id).put('EOL_Entered_From__c','SQL');
								}else if(DFR.Pre_Opportunity_Status__c == 'SAL'){
									mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Exited__c',datetime.now());
									mapDFRUpdate.get(DFR.id).put('SAL_Exited_To__c',vStage);
									mapDFRUpdate.get(DFR.id).put('EOL_Entered_From__c','SAL');
								}else if(DFR.Pre_Opportunity_Status__c == 'MQL'){
									mapDFRUpdate.get(DFR.id).put('MQL_DateTime_Exited__c',datetime.now());
									mapDFRUpdate.get(DFR.id).put('MQL_Exited_To__c',vStage);
									mapDFRUpdate.get(DFR.id).put('EOL_Entered_From__c','MQL');
								}else if(DFR.Pre_Opportunity_Status__c == 'Prospect'){
									mapDFRUpdate.get(DFR.id).put('Prospect_DateTime_Exited__c',datetime.Now());
									mapDFRUpdate.get(DFR.id).put('Prospect_Exited_To__c',vStage);
									mapDFRUpdate.get(DFR.id).put('EOL_Entered_From__c','Prospect');
								}	
								
								if(DFR.Opportunity__c == Null){
									mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Close_Reason__c',vStage);	
								}else{
									mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Close_Reason__c','Opp Downgraded');	
								}
			    			}
						}			  				
					}else{ // Leads that move stages without active DFR
			    			String vStage = mapStatusToStage.get(ld.Contact_Status__c);
			    			if(mapStatusOrder.containsKey(vStage)){
			    				Integer vOrder = mapStatusOrder.get(vStage);
				    			Demand_Funnel__c DFR = new Demand_Funnel__c();
				    			DFR.DFR_Funnel_Type__c = 'Acquisition';
				    			if(String.IsNotBlank(ld.Contact_Funnel_Type__c)){
					    			if(mapContactTypeToFunnelType.containsKey(ld.Contact_Funnel_Type__c.ToLowerCase())){
					    				DFR.DFR_Funnel_Type__c = mapContactTypeToFunnelType.get(ld.Contact_Funnel_Type__c.ToLowerCase());
					    			}
				    			}

				    			//Prospect
				    			if(vOrder >= 1){
				    				DFR.Prospect_DateTime_Entered__c = datetime.Now();
									DFR.Prospect_Lead_Source__c = ld.LeadSource; 
									DFR.Prospect_Campaign__c = ld.Most_Recent_Campaign__c; 
									DFR.Prospect_Demographic_Score__c = ld.Demographic_Score__c;
									DFR.Prospect_Behavior_Score__c = ld.Behavior_Score__c;
									DFR.Prospect_Score__c = ld.mkto2__Lead_Score__c;
									DFR.Prospect_BMID__c = ld.BMID__c;
									DFR.Prospect_PID__c = ld.PID__c;
									DFR.Prospect_AID__c = ld.AID__c;
									DFR.Prospect_Purchase_Timeframe__c = ld.Time_Frame__c;
									//DFR.Prospect_Lead_Score_Category__c = ld.Lead_Score__c;
									DFR.Prospect_Employee_Size__c = ld.NumberOfEmployees__c;
									DFR.Prospect_Owner_Role__c = vOwnerRole;
									DFR.Prospect_Owner_Name__c = vOwnerName;
									DFR.Prospect_Owner_Division__c = vOwnerDivision;
									DFR.Prospect_Owner_Team__c = vOwnerTeam;
									DFR.Prospect_Entered_From__c = 'Backfilled';
									DFR.Prospect_Exited_To__c = 'Backfilled';
									DFR.Prospect_DateTime_Exited__c = datetime.Now();
									DFR.Prospect_Backfilled__c = true;
				    			}
				    			//MQL
				    			if(vOrder >= 2){
									DFR.MQL_DateTime_Entered__c = datetime.now();
									DFR.MQL_Lead_Source__c = ld.LeadSource; 
									DFR.MQL_Campaign__c = ld.Most_Recent_Campaign__c;
									DFR.MQL_Demographic_Score__c = ld.Demographic_Score__c;
									DFR.MQL_Behavior_Score__c = ld.Behavior_Score__c;
									DFR.MQL_Score__c = ld.mkto2__Lead_Score__c;
									DFR.MQL_BMID__c = ld.BMID__c;
									DFR.MQL_PID__c = ld.PID__c;
									DFR.MQL_AID__c = ld.AID__c;
									DFR.MQL_Purchase_Timeframe__c = ld.Time_Frame__c;
									//DFR.MQL_Lead_Score_Category__c = ld.Lead_Score__c;
									DFR.MQL_Employee_Size__c = ld.NumberOfEmployees__c;
									DFR.MQL_Owner_Role__c = vOwnerRole;
									DFR.MQL_Owner_Name__c = vOwnerName;
									DFR.MQL_Owner_Division__c = vOwnerDivision;
									DFR.MQL_Owner_Team__c = vOwnerTeam;
									DFR.MQL_Entered_From__c = 'Backfilled';
									DFR.MQL_Exited_To__c = 'Backfilled';
									DFR.MQL_DateTime_Exited__c = datetime.Now();
									DFR.MQL_Backfilled__c = true;
				    			}
				    			//SAL
				    			if(vOrder == 3){
									DFR.SAL_DateTime_Entered__c = datetime.now();
									DFR.SAL_Entered_From__c = 'Created';
									DFR.SAL_Lead_Source__c = ld.LeadSource; 
									DFR.SAL_Campaign__c = ld.Most_Recent_Campaign__c;
									DFR.SAL_Demographic_Score__c = ld.Demographic_Score__c;
									DFR.SAL_Behavior_Score__c = ld.Behavior_Score__c;
									DFR.SAL_Score__c = ld.mkto2__Lead_Score__c;
									DFR.SAL_BMID__c = ld.BMID__c;
									DFR.SAL_PID__c = ld.PID__c;
									DFR.SAL_AID__c = ld.AID__c;
									DFR.SAL_Purchase_Timeframe__c = ld.Time_Frame__c;
									//DFR.SAL_Lead_Score_Category__c = ld.Lead_Score__c;
									DFR.SAL_Employee_Size__c = ld.NumberOfEmployees__c;
									DFR.SAL_Owner_Role__c = vOwnerRole;
									DFR.SAL_Owner_Name__c = vOwnerName;
									DFR.SAL_Owner_Division__c = vOwnerDivision;
									DFR.SAL_Owner_Team__c = vOwnerTeam;
									DFR.Pre_Opportunity_Status__c = 'SAL';
									DFR.Lead_Name_on_Creation__c = (ld.FirstName != null ? ld.FirstName : '' ) + ' ' + ld.LastName;
									DFR.Lead_Email_on_Creation__c = ld.Email;
									DFR.Contact__c = ld.Id;								
									if(ld.Contact_Status__c == 'Re-New'){
										DFR.SAL_Type__c = 'Re-New';
									}else{
										DFR.SAL_Type__c = 'New';
									} 
									
									DFR.Account__c = ld.AccountId;
									if(mapAIdOId.containsKey(ld.AccountId)){
										DFR.Opportunity__c = mapAIdOId.get(ld.AccountId);
										DFR.Pre_Opportunity_Status__c = 'SQL';
										DFR.SQL_DateTime_Entered__c = datetime.now();
										DFR.SQL_Lead_Source__c = ld.LeadSource;
										DFR.SQL_Campaign__c = ld.Most_Recent_Campaign__c ;
										DFR.SQL_Demographic_Score__c = ld.Demographic_Score__c;
										DFR.SQL_Behavior_Score__c = ld.Behavior_Score__c;
										DFR.SQL_Score__c = ld.mkto2__Lead_Score__c; 
										DFR.SQL_BMID__c = ld.BMID__c;
										DFR.SQL_PID__c = ld.PID__c;
										DFR.SQL_AID__c = ld.AID__c;
										DFR.SQL_Employee_Size__c = ld.NumberOfEmployees__c;
										DFR.SQL_Purchase_Timeframe__c = ld.Time_Frame__c;
										DFR.SQL_Owner_Name__c = vOwnerName;
										DFR.SQL_Owner_Role__c = vOwnerRole;
										DFR.SQL_Owner_Team__c = vOwnerTeam;
										DFR.SQL_Owner_Division__c = vOwnerDivision;
										DFR.SQL_Entered_From__c = 'Created';
										DFR.SAL_DateTime_Exited__c = datetime.now();
										DFR.SAL_Entered_From__c = 'Backfilled';
										DFR.SAL_Exited_To__c = 'Backfilled';
										DFR.SAL_Backfilled__c = true;										
										
										if(!setOIDCID.contains(DFR.Opportunity__c + '~' + ld.id)){			
											listOCR.add(new OpportunityContactRole(ContactId = ld.id, OpportunityId = DFR.Opportunity__c));
										}
											
										if(!setPriOId.contains(DFR.Opportunity__c)){
											DFR.DFR_Primary_Role__c = True;
										}
									}								
									
									DFRInsert.add(DFR);
				    			}	    			
				    		}
			    		//}			
					}
			
				}
				
				//Update existing DFR
				if (mapDFRUpdate.size()> 0){ 
					Database.SaveResult[] srUpdate = Database.Update(mapDFRUpdate.values(),false);
					
					for (Database.SaveResult sr : srUpdate) {
					    if (!sr.isSuccess()) {             
					        for(Database.Error err : sr.getErrors()) {
					            System.debug('DFR Update Error: ' + err.getMessage());
					        }
					    }
					}
				}
				
				//Create new DFR
				if (DFRInsert.size()> 0){
					Database.SaveResult[] srInsert = Database.Insert(DFRInsert, false);	
					
					for (Database.SaveResult sr : srInsert) {
					    if (!sr.isSuccess()) {             
					        for(Database.Error err : sr.getErrors()) {
					            System.debug('DFR Creation Error: ' + err.getMessage());
					        }
					    }
					}
					
					if(listOCR.size() > 0){
						database.insert(listOCR, false);
					}
				}		
	        }
		}
	}
	
	public static map<Id, Id> getAIdOId(list<Id> listAId){
        //This method returns the mapping of Account Id and most recent open Opportunity Id
        map<Id, Id> mapAIdOId = new map<Id, Id>();
        for(Opportunity o:[Select Id, AccountId from Opportunity 
        where AccountId in :listAId and IsClosed = FALSE Order By CreatedDate ]){
            mapAIdOId.put(o.AccountId, o.Id);
        }
        return mapAIdOId;
    }
    
    public static set<Id> getOppPrimaryStatus(set<Id> setOId){
        //This method check the opportunities already associated to a DFR record.
        set<Id> setPriOId = new set<Id>();
        
        for(Demand_Funnel__c d : [Select Opportunity__c from Demand_Funnel__c 
        where Opportunity__c in :setOId]){
            setPriOId.add(d.Opportunity__c);
        }
        
        return setPriOId;
    }
    
    public static set<String> getOpportunityContactRole(set<Id> setOId){
        //This method retrieve Contacts associated with Opportunities
        set<String> setOIDCID = new set<String>();
        
        for(OpportunityContactRole o : [Select o.OpportunityId, o.ContactId From OpportunityContactRole o
        where o.OpportunityId in :setOId]){
            setOIDCID.add(o.OpportunityId + '~' + o.ContactId);
        }
        
        return setOIDCID;
    }
    
    public static map<String, Id> getMapOpportunityContactRole(set<Id> setOId){
        //This method retrieve Contacts associated with Opportunities
        map<String, Id> mapOIDCID = new map<String, Id>();
        
        for(OpportunityContactRole o : [Select o.Id, o.OpportunityId, o.ContactId From OpportunityContactRole o
        where o.OpportunityId in :setOId]){
            mapOIDCID.put(o.OpportunityId + '~' + o.ContactId, o.Id);
        }
        
        return mapOIDCID;
    }
    
    public static void DFR_OpportunityClosed(List<Opportunity> o, List<Opportunity> oldo){
        list<String> DFROppRType = DG_DFR_Class.getDFROppRType(); 
        
        Map<Id,String> mapRTId = new Map<Id,String>();
        for(RecordType r : [Select r.Id, r.DeveloperName From RecordType r where r.SobjectType = 'Opportunity'
            and r.DeveloperName in :DFROppRType]){
            mapRTId.put(r.Id,r.DeveloperName);
        }       
        
        list<Id> listConId = new list<Id>();
        list<Id> listOppId = new list<Id>();
        list<Id> listOwnerId = new list<Id>();
        set<Id> setLostOppId = new set<Id>();
        map<Id, Opportunity> mapOpp = new map<Id, Opportunity>();
        
        integer i;
        for (i=0; i<o.size(); i++){
            if(o[i].IsClosed <> oldo[i].IsClosed && o[i].IsClosed == true && mapRTId.containsKey(o[i].RecordTypeId)){
                //listConId.add(o[i].Primary_Opportunity_Contact__c);
                listOppId.add(o[i].Id);
                listOwnerId.add(o[i].OwnerId);
                mapOpp.put(o[i].id, o[i]);
                if(!o[i].IsWon){
                    setLostOppId.add(o[i].Id);
                }
            }       
        }
        
        if(listOppId.size() > 0){
            Map<Id, Contact> mapDowngradeCon = new Map<Id, Contact>();
            
            for(OpportunityContactRole ocr : [Select o.OpportunityId, o.ContactId From OpportunityContactRole o
            where o.OpportunityId in :listOppId]){
                listConId.add(ocr.ContactId);
                if(setLostOppId.contains(ocr.OpportunityId)){ 
                    mapDowngradeCon.put(ocr.ContactId, new Contact(Id = ocr.ContactId, Contact_Status__c = 'Downgraded'));
                }
            }
                
            //Retrieve Users
            map<Id, User> mapUsers = new map<Id, User>();
            mapUsers.putAll([Select u.Id, u.UserRole.Name, u.Name From User u where u.id in :listOwnerId]);
            
            //Retrieve Employees
            map<Id, Employee__c> mapEmps = new map<Id, Employee__c>();
            for(Employee__c e :[Select e.User__c, e.Team__c, e.Division__c From Employee__c e where e.User__c in :mapUsers.keySet()]){
                mapEmps.put(e.User__c,e);
            }   
            
            Map<Id, Contact> mapCon = new Map<Id, Contact>();
            
            mapCon.putAll([Select c.id, c.mkto2__Lead_Score__c, c.PID__c, c.Most_Recent_Campaign__c, c.LeadSource, 
                c.Demographic_Score__c, c.Behavior_Score__c, c.BMID__c, c.AID__c, c.NumberOfEmployees__c, c.Time_Frame__c 
                from Contact c where c.id in :listConId]);
                
            Demand_Funnel__c[] listDFR = [Select d.Contact__c, d.id, d.Opportunity__c, d.Pre_Opportunity_Status__c, d.Opportunity__r.OwnerId From Demand_Funnel__c d 
                    where d.Opportunity__c in :listOppId];
            
            //Mapping use to update existing DFR
            map<id,Demand_Funnel__c> mapDFRUpdate = new map<id,Demand_Funnel__c>();
                    
            for(Demand_Funnel__c DFR : listDFR){
                
                if(mapCon.containsKey(DFR.Contact__c)){
                    Contact c = mapCon.get(DFR.Contact__c); 
                    //Get Owner Info
                    String vOwnerName;
                    String vOwnerRole;
                    String vOwnerTeam;
                    String vOwnerDivision;
                    
                    if(mapUsers.containsKey(DFR.Opportunity__r.OwnerId)){
                        vOwnerRole = mapUsers.get(DFR.Opportunity__r.OwnerId).Userrole.Name;
                        vOwnerName = mapUsers.get(DFR.Opportunity__r.OwnerId).Name;
                        if(mapEmps.containsKey(DFR.Opportunity__r.OwnerId)){
                            vOwnerDivision = mapEmps.get(DFR.Opportunity__r.OwnerId).Division__c;
                            vOwnerTeam = mapEmps.get(DFR.Opportunity__r.OwnerId).Team__c;
                        }
                    }           
                    
                    mapDFRUpdate.put(DFR.id, new Demand_Funnel__c(Id=DFR.id)); 
                    
                    mapDFRUpdate.get(DFR.id).put('EOL_DateTime_Entered__c',datetime.now());
                    mapDFRUpdate.get(DFR.id).put('EOL_Lead_Source__c',c.LeadSource);
                    mapDFRUpdate.get(DFR.id).put('EOL_Campaign__c',c.Most_Recent_Campaign__c );
                    mapDFRUpdate.get(DFR.id).put('EOL_Demographic_Score__c',c.Demographic_Score__c);
                    mapDFRUpdate.get(DFR.id).put('EOL_Behavior_Score__c',c.Behavior_Score__c);
                    mapDFRUpdate.get(DFR.id).put('EOL_Score__c',c.mkto2__Lead_Score__c); 
                    mapDFRUpdate.get(DFR.id).put('EOL_BMID__c',c.BMID__c);
                    mapDFRUpdate.get(DFR.id).put('EOL_PID__c',c.PID__c);
                    mapDFRUpdate.get(DFR.id).put('EOL_AID__c',c.AID__c);
                    mapDFRUpdate.get(DFR.id).put('EOL_Employee_Size__c',c.NumberOfEmployees__c);
                    mapDFRUpdate.get(DFR.id).put('EOL_Purchase_Timeframe__c',c.Time_Frame__c);
                    mapDFRUpdate.get(DFR.id).put('EOL_Owner_Name__c',vOwnerName);
                    mapDFRUpdate.get(DFR.id).put('EOL_Owner_Role__c',vOwnerRole);
                    mapDFRUpdate.get(DFR.id).put('EOL_Owner_Team__c',vOwnerTeam);
                    mapDFRUpdate.get(DFR.id).put('EOL_Owner_Division__c',vOwnerDivision);
                    mapDFRUpdate.get(DFR.id).put('EOL_Entered_From__c','SQL');
                    if(setLostOppId.contains(DFR.Opportunity__c)){
                        if(mapOpp.containsKey(DFR.Opportunity__c)){                     
                            mapDFRUpdate.get(DFR.id).put('EOL_Downgrade_Reason__c',mapOpp.get(DFR.Opportunity__c).Downgrade_Reason_Opp__c);
                            mapDFRUpdate.get(DFR.id).put('EOL_Sub_Downgrade_Reason__c',mapOpp.get(DFR.Opportunity__c).Sub_Downgrade_Reason__c);
                        }
                    }       
                }
            }
            
            //Update existing DFR
            if (mapDFRUpdate.size()> 0)
            { 
                Database.SaveResult[] srUpdate = Database.Update(mapDFRUpdate.values(),false);
                
                for (Database.SaveResult sr : srUpdate) {
                    if (!sr.isSuccess()) {             
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('DFR Update Error: ' + err.getMessage());
                        }
                    }
                }
                
                if(mapDowngradeCon.size() > 0){
                    database.update(mapDowngradeCon.values(), false);
                }
            }
        }
    }
	
	public static void DFR_AddOpportunityToExistingDFR(list<Opportunity> tn){
		set<Id> setOwnerId = new set<Id>();
		map<Id, Opportunity> mapAIdOpp = new map<Id, Opportunity>();
		
        for (integer i=0; i < tn.size(); i++){
        	mapAidOpp.put(tn[i].AccountId, tn[i]);
        	setOwnerId.add(tn[i].OwnerId);
        }
        
        //Retrieve active DFR related to Accounts
        list<Demand_Funnel__c> listDFR = new list<Demand_Funnel__c>();
        set<Id> setCId = new set<Id>();
        map<Id, Id> mapAcctOldestDFR = new map<Id, Id>();
        
 		for(Demand_Funnel__c d : [Select d.id, d.Contact__c, Account__c, d.Pre_Opportunity_Status__c From Demand_Funnel__c d 
		where Account__c in :mapAidOpp.keySet() and Opportunity__c = Null and d.Pre_Opportunity_Close_Reason__c = Null and Contact__c <> Null
		Order By d.Account__c, d.CreatedDate DESC]){
			listDFR.add(d);
			setCId.add(d.Contact__c);
			mapAcctOldestDFR.put(d.Account__c, d.Contact__c);
		}
		 	
		if(listDFR.size() > 0){		
			
			//Retrieve Users
			map<Id, User> mapUsers = new map<Id, User>();
			mapUsers.putAll([Select u.Id, u.UserRole.Name, u.Name From User u where u.id in :setOwnerId]);
			
			//Retrieve Employees
			map<Id, Employee__c> mapEmps = new map<Id, Employee__c>();
			for(Employee__c e :[Select e.User__c, e.Team__c, e.Division__c From Employee__c e where e.User__c in :mapUsers.keySet()]){
				mapEmps.put(e.User__c,e);
			}
			
			//Retrieve Contact information 	
			map<Id, Contact> mapContact = new map<Id, Contact>();
			
			for(Contact c : [Select c.Id, c.mkto2__Lead_Score__c, c.PID__c, c.Most_Recent_Campaign__c, c.FirstName, c.LastName, c.Email,
			c.LeadSource, c.Demographic_Score__c, c.Behavior_Score__c, c.BMID__c, c.AID__c, c.NumberOfEmployees__c, c.Time_Frame__c 
			from Contact c where c.id in :setCId]){
				mapContact.put(c.Id, c);
			}
						
			map<id,Demand_Funnel__c> mapDFRUpdate = new map<id,Demand_Funnel__c>();
			list<OpportunityContactRole> listOCR = new list<OpportunityContactRole>();
			
			for(Demand_Funnel__c DFR : listDFR){
				
				mapDFRUpdate.put(DFR.id, new Demand_Funnel__c(Id=DFR.id)); 	
								
				Contact c = mapContact.get(DFR.Contact__c);
				Opportunity o = mapAidOpp.get(DFR.Account__c);
				
				if(mapAcctOldestDFR.containsKey(DFR.Account__c)){
					If(mapAcctOldestDFR.get(DFR.Account__c) == c.Id){
						mapDFRUpdate.get(DFR.id).put('DFR_Primary_Role__c', TRUE);
					}
				}
				
				//Get Owner Info
				String vOwnerName;
				String vOwnerRole;
				String vOwnerTeam;
				String vOwnerDivision;
				
				if(mapUsers.containsKey(o.OwnerId)){
					vOwnerRole = mapUsers.get(o.OwnerId).Userrole.Name;
					vOwnerName = mapUsers.get(o.OwnerId).Name;
					if(mapEmps.containsKey(o.OwnerId)){
						vOwnerDivision = mapEmps.get(o.OwnerId).Division__c;
						vOwnerTeam = mapEmps.get(o.OwnerId).Team__c;
					}
				}		
				
			 	mapDFRUpdate.get(DFR.id).put('Opportunity__c', o.Id);		 			   		
		   		mapDFRUpdate.get(DFR.id).put('SQL_DateTime_Entered__c',datetime.now());
				mapDFRUpdate.get(DFR.id).put('SQL_Lead_Source__c',c.LeadSource);
				mapDFRUpdate.get(DFR.id).put('SQL_Campaign__c',c.Most_Recent_Campaign__c );
				mapDFRUpdate.get(DFR.id).put('SQL_Demographic_Score__c',c.Demographic_Score__c);
				mapDFRUpdate.get(DFR.id).put('SQL_Behavior_Score__c',c.Behavior_Score__c);
				mapDFRUpdate.get(DFR.id).put('SQL_Score__c',c.mkto2__Lead_Score__c); 
				mapDFRUpdate.get(DFR.id).put('SQL_BMID__c',c.BMID__c);
				mapDFRUpdate.get(DFR.id).put('SQL_PID__c',c.PID__c);
				mapDFRUpdate.get(DFR.id).put('SQL_AID__c',c.AID__c);
				mapDFRUpdate.get(DFR.id).put('SQL_Employee_Size__c',c.NumberOfEmployees__c);
				mapDFRUpdate.get(DFR.id).put('SQL_Purchase_Timeframe__c',c.Time_Frame__c);
				mapDFRUpdate.get(DFR.id).put('SQL_Owner_Name__c',vOwnerName);
				mapDFRUpdate.get(DFR.id).put('SQL_Owner_Role__c',vOwnerRole);
				mapDFRUpdate.get(DFR.id).put('SQL_Owner_Team__c',vOwnerTeam);
				mapDFRUpdate.get(DFR.id).put('SQL_Owner_Division__c',vOwnerDivision);
				mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','SQL');
				mapDFRUpdate.get(DFR.id).put('SAL_DateTime_Exited__c',datetime.now());
				mapDFRUpdate.get(DFR.id).put('SAL_Exited_To__c','SQL');
				mapDFRUpdate.get(DFR.id).put('SQL_Entered_From__c','SAL');					
				mapDFRUpdate.get(DFR.id).put('Pre_Opportunity_Status__c','SQL');
				
				//Add Opportunity Contact Role	
				listOCR.add(new OpportunityContactRole(ContactId = DFR.Contact__c, OpportunityId = o.Id));

			 }	
			 
			 //Update DFR map
			 if (mapDFRUpdate.size()> 0){ 
				Database.SaveResult[] srUpdate = Database.Update(mapDFRUpdate.values(),false);
				
				for (Database.SaveResult sr : srUpdate) {
				    if (!sr.isSuccess()) {             
				        for(Database.Error err : sr.getErrors()) {
				            System.debug('DFR Update Error: ' + err.getMessage());
				        }
				    }
				}
				
				
				if(listOCR.size() > 0){
					insert listOCR;
					//database.insert(listOCR, false);
				}
			}	
		}
	}
	
	public void DowngradeContactsAndDFRs() { 
		
		Datetime dateFilter = datetime.now() - getDFRAutoDeactivationDays();	
		
		Set<Id> setConId = new Set<Id>();
		map<Id, Demand_Funnel__c> mapDFR = new map<Id, Demand_Funnel__c>();
		
		for(Demand_Funnel__c d : [Select d.Opportunity__c, d.Lead__c, d.DET_DFR_Status__c, d.CreatedDate, d.Contact__c 
		From Demand_Funnel__c d
		where d.CreatedDate <= :dateFilter and d.Lead__c = Null and d.Opportunity__c = Null 
		and d.Contact__c <> Null and d.DET_DFR_Status__c = 'Active']){
			setConId.add(d.Contact__c);
			mapDFR.put(d.id, new Demand_Funnel__c(Id = d.Id, EOL_Downgrade_Reason__c = 'No Sales Response'));
		}
		
	    if(setConId.size() > 0) {   
	    	map<Id, Contact> mapCon = new map<Id, Contact>();
	    	 	
			for(Id CId : setConId){
				mapCon.put(CId, new Contact(Id = CId, Contact_Status__c = 'Downgraded'));
			}			

			if(mapCon.size() > 0){
				database.update(mapCon.values(), false);
			}
			
			if(mapDFR.size() > 0){
				database.update(mapDFR.values(), false);
			}			
		}
	}
	
	public static integer getDFRAutoDeactivationDays(){
		integer Days;
 
		if(!test.isRunningTest()){
			try{
				Days = Integer.valueOf(System.Label.DFR_Auto_Deactivation_Days);		
			}catch(exception e){Days = 21;}	
		}else{
			Days = 0;
		}

		return Days;
	}
	
	public static map<String,String> getContactTypeToFunnelType(){
		Map<String, String> mapContactTypeToFunnelType = new Map<String, String>();	

		if(!test.isRunningTest()){

			map<String, DFR_Contact_Type_to_Funnel_Type__c> mapDFRContactTypeToFunnelType = DFR_Contact_Type_to_Funnel_Type__c.getAll();
            for(String k: mapDFRContactTypeToFunnelType.keySet()){ 
            	mapContactTypeToFunnelType.put(k.ToLowerCase(),mapDFRContactTypeToFunnelType.get(k).Funnel_Type__c);
        	}
		}else{
			mapContactTypeToFunnelType =  new Map<String,String>{
			'prospect'=>'Acquisition',
			'customer'=>'Upsell',
			'winback'=>'Winback'};
		}
		
		system.debug(mapContactTypeToFunnelType);	
		return mapContactTypeToFunnelType;
	}
	
	public static Set<String> getExcludedUsers(){
        Set<String> setExcludedUsers = new Set<String>();  

        if(!test.isRunningTest()){
            map<String, DFR_Excluded_Users__c > mapExclUsers = DFR_Excluded_Users__c.getAll();
            for(String k: mapExclUsers.keySet()){
            	setExcludedUsers.add(k);
        	}
        }else{
            setExcludedUsers.add('00580000005TdpaAAC');
        }
        return setExcludedUsers;
    }
}