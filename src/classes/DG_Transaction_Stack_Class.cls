public without sharing class DG_Transaction_Stack_Class {
	public static boolean TSLeadUpdate_FirstRun = true;
    public static boolean TSContactUpdate_FirstRun = true; 
	
	public static void Log_TS_OnLeadUpdate(List<Lead> tn, List<Lead> to){

        map<String,String> mapLeadField = LeadFieldMapping();
        list<Transaction_Stack__c> listTS = new list<Transaction_Stack__c>();
       	
       	if(mapLeadField.size() > 0){
			for (integer i=0; i< tn.size(); i++){		            	
				for(String f : mapLeadField.keySet()){
					system.debug('### Field: ' + f); 
					try{
						//String newValue = tn[i].get(f).toString();
	                	if(tn[i].get(f) <> to[i].get(f) && String.isNotBlank(String.valueOf(tn[i].get(f)))){
	                		system.debug('### Field: ' + f + ' has changed');
	                		Transaction_Stack__c ts = new Transaction_Stack__c();
							ts.Date_Time__c = datetime.now();
							ts.Lead__c = tn[i].id;
							ts.New_Value__c = String.valueOf(tn[i].get(f));
							ts.Type__c = mapLeadField.get(f);
							
							listTS.add(ts);
	                	}
					}catch(exception e){}
				}
			}
       	}
       	
       	if(listTS.size() > 0){
       		database.insert(listTS, false);
       	}
	}
	
	public static void Log_TS_OnContactUpdate(List<Contact> tn, List<Contact> to){

        system.debug('New Value ==' + tn);
		system.debug('Old Value ==' + to);
        map<String,String> mapContactField = ContactFieldMapping();
        list<Transaction_Stack__c> listTS = new list<Transaction_Stack__c>();
       	
       	if(mapContactField.size() > 0){
			for (integer i=0; i< tn.size(); i++){		            	
				for(String f : mapContactField.keySet()){
					system.debug('### Field: ' + f);
					System.debug('### CONDITIONAL TEXT = tn[i] = ' + tn[i]);
					System.debug('### CONDITIONAL TEXT = tn[i].get(f) = ' + tn[i].get(f)); 
					System.debug('### CONDITIONAL TEXT = to[i].get(f) = ' + to[i].get(f)); 
					System.debug('### CONDITIONAL TEXT = String.valueOf(tn[i].get(f)) = ' + String.isNotBlank(String.valueOf(tn[i].get(f)))); 
					try{
	                	if(tn[i].get(f) <> to[i].get(f) && String.isNotBlank(String.valueOf(tn[i].get(f)))){
	                		system.debug('### Field: ' + f + ' has changed');
	                		Transaction_Stack__c ts = new Transaction_Stack__c();
							ts.Date_Time__c = datetime.now();
							ts.Contact__c = tn[i].id;
							ts.Account__c = tn[i].AccountId;
							ts.New_Value__c = String.valueOf(tn[i].get(f));
							ts.Type__c = mapContactField.get(f);
							
							listTS.add(ts);
	                	}
					}catch(exception ex){
						system.debug('*** Log_TS_OnContactUpdate Exception ***' + ex.getMessage());
					}
				}
			}
       	}
       	
       	if(listTS.size() > 0){
       		database.insert(listTS, false);
       	}
	}
		                				
		                				
    private static map<String,String> LeadFieldMapping(){
        Map<String, Schema.SObjectField> mapLSchema = Schema.SObjectType.Lead.fields.getMap();

        Map<String, String> mapFieldMapping = new Map<String, String>();
        
        map<String,Transaction_Stack_Settings__c> mapTSS = new map<String,Transaction_Stack_Settings__c>();
        
        if(!test.isRunningTest()){          
            mapTSS = Transaction_Stack_Settings__c.getAll();
        }else{
            mapTSS.put('BMID',new Transaction_Stack_Settings__c (name = 'BMID', Lead_Field__c = 'BMID__c', Contact_Field__c = 'BMID__c'));
            mapTSS.put('Campaign',new Transaction_Stack_Settings__c (name = 'Campaign', Lead_Field__c = 'Most_Recent_Campaign__c', Contact_Field__c = 'Most_Recent_Campaign__c'));
            mapTSS.put('Owner',new Transaction_Stack_Settings__c (name = 'Owner', Lead_Field__c = 'OwnerId', Contact_Field__c = 'OwnerId'));
        }

        for(String k:mapTSS.keySet()){  
            String vLead_Field = mapTSS.get(k).Lead_Field__c;
        
            if (vLead_Field <> Null){
                vLead_Field = vLead_Field.trim();
                if(mapLSchema.containsKey(vLead_Field)){
                    Schema.DescribeFieldResult LeadFieldDescribe = mapLSchema.get(vLead_Field).getDescribe();
                    if(LeadFieldDescribe.isUpdateable()){
                        mapFieldMapping.put(vLead_Field,k);
                    }
                }
            }
        }
        return mapFieldMapping;
    }
    
    private static map<String,String> ContactFieldMapping(){
        Map<String, Schema.SObjectField> mapCSchema = Schema.SObjectType.Contact.fields.getMap();

        Map<String, String> mapFieldMapping = new Map<String, String>();
        
        map<String,Transaction_Stack_Settings__c> mapTSS = new map<String,Transaction_Stack_Settings__c>();
        
        if(!test.isRunningTest()){          
            mapTSS = Transaction_Stack_Settings__c.getAll();
        }else{
            mapTSS.put('BMID',new Transaction_Stack_Settings__c (name = 'BMID', Lead_Field__c = 'BMID__c', Contact_Field__c = 'BMID__c'));
            mapTSS.put('Campaign',new Transaction_Stack_Settings__c (name = 'Campaign', Lead_Field__c = 'Most_Recent_Campaign__c', Contact_Field__c = 'Most_Recent_Campaign__c'));
            mapTSS.put('Owner',new Transaction_Stack_Settings__c (name = 'Owner', Lead_Field__c = 'OwnerId', Contact_Field__c = 'OwnerId'));
        }

        for(String k:mapTSS.keySet()){  
            String vContact_Field = mapTSS.get(k).Contact_Field__c;
        
            if (vContact_Field <> Null){
                vContact_Field = vContact_Field.trim();
                if(mapCSchema.containsKey(vContact_Field)){
                    Schema.DescribeFieldResult ContactFieldDescribe = mapCSchema.get(vContact_Field).getDescribe();
                    if(ContactFieldDescribe.isUpdateable()){
                        mapFieldMapping.put(vContact_Field,k);
                    }
                }
            }
        }
        return mapFieldMapping;
    }
    
    public static void Populate_DFR_Data(List<Transaction_Stack__c> tn){
    	list<Id> listLID = new list<Id>();
    	list<Id> listCID = new list<Id>();
    	
    	for (integer i=0; i< tn.size(); i++){
    		if(tn[i].Contact__c <> Null){
    			listCID.add(tn[i].Contact__c);
    		}else if(tn[i].Lead__c <> Null){
    			listLID.add(tn[i].Lead__c);
    		}
    	}
    	
    	map<Id, Demand_Funnel__c> mapIdDFR = new map<Id, Demand_Funnel__c>();
    	
    	for(Demand_Funnel__c d : [Select d.Pre_Opportunity_Status__c, d.Id, d.EOL_Entered_From__c, d.DET_DFR_Created_Date__c,
    								d.DET_Current_Funnel_Status__c, d.DFR_Funnel_Type__c, d.Lead__c, d.Contact__c
    								From Demand_Funnel__c d Where d.Lead__c in :listLID or d.Contact__c in :listCID
    								Order by d.DET_DFR_Created_Date__c]){
    		mapIdDFR.put(d.Lead__c, d);
    		mapIdDFR.put(d.Contact__c, d);    		
    	}
    	
    	for (integer i=0; i< tn.size(); i++){
    		if(tn[i].Contact__c <> Null){
    			if(mapIdDFR.containsKey(tn[i].Contact__c)){
    				tn[i].DFR__c = mapIdDFR.get(tn[i].Contact__c).Id;
    				tn[i].Stage__c = mapIdDFR.get(tn[i].Contact__c).DET_Current_Funnel_Status__c;
    				tn[i].Funnel_Type__c = mapIdDFR.get(tn[i].Contact__c).DFR_Funnel_Type__c;
    			} else {
    				tn[i].Stage__c = 'Pre-Funnel';
    			}
    		}else if(tn[i].Lead__c <> Null){
    			if(mapIdDFR.containsKey(tn[i].Lead__c)){
    				tn[i].DFR__c = mapIdDFR.get(tn[i].Lead__c).Id;
    				tn[i].Stage__c = mapIdDFR.get(tn[i].Lead__c).DET_Current_Funnel_Status__c;
    				tn[i].Funnel_Type__c = mapIdDFR.get(tn[i].Lead__c).DFR_Funnel_Type__c;
    			} else {
    				tn[i].Stage__c = 'Pre-Funnel';
    			}
    		}
    	}
    }
    
    public static void TransactionType_Owner(List<Transaction_Stack__c> tn){
    	list<Id> listUserId = new list<Id>();
    	
    	for (integer i=0; i< tn.size(); i++){
    		if(tn[i].New_Value__c <> Null && 'Owner'.equalsIgnoreCase(tn[i].Type__c)){
				listUserId.add(tn[i].New_Value__c);
    		}
    	}
    	
    	if(listUserId.size() > 0){
    		map<Id, User> mapUser = new map<Id, User>();
    		
    		mapUser.putAll([Select Id, Name from User where Id in :listUserId]);
    		
	    	for (integer i=0; i< tn.size(); i++){
	    		if(tn[i].New_Value__c <> Null && 'Owner'.equalsIgnoreCase(tn[i].Type__c)){
					if(mapUser.containsKey(tn[i].New_Value__c)){
						tn[i].New_Value__c = mapUser.get(tn[i].New_Value__c).Name;
					}
	    		}
	    	}
    		
    	}
    }
        
    public static void TransactionType_Campaign(List<Transaction_Stack__c> tn){
    	list<Id> listCampaignId = new list<Id>();
    	
    	for (integer i=0; i<tn.size(); i++){
    		if(tn[i].New_Value__c <> Null && 'Campaign'.equalsIgnoreCase(tn[i].Type__c)){
				listCampaignId.add(tn[i].New_Value__c);
    		}
    	}
    	
    	if(listCampaignId.size() > 0){
    		map<Id, Campaign> mapCampaign = new map<Id, Campaign>();
    		
    		mapCampaign.putAll([Select Id, Name from Campaign where Id in :listCampaignId]);
    		
	    	for (integer i=0; i<tn.size(); i++){
	    		if(tn[i].New_Value__c <> Null && 'Campaign'.equalsIgnoreCase(tn[i].Type__c)){
					if(mapCampaign.containsKey(tn[i].New_Value__c)){
						tn[i].Campaign__c = mapCampaign.get(tn[i].New_Value__c).Id;
						tn[i].New_Value__c = mapCampaign.get(tn[i].New_Value__c).Name;
					}
	    		}
	    	}
    		
    	}
    }
    
   	public static void Update_TS_OnLeadConvert(List<Lead> tn, List<Lead> to){

		map<Id, Lead> mapLead = new map<Id, Lead>();
       	
		for (integer i=0; i<tn.size(); i++){		            	
			if (to[i].isConverted == false && tn[i].isConverted == true){
				mapLead.put(tn[i].id, tn[i]);
			}
		}
       	
       	if(mapLead.size() > 0){
       		list<Transaction_Stack__c> listTS = new list<Transaction_Stack__c>();
       		
       		for(Transaction_Stack__c t : [Select t.Lead__c, t.Id, t.Contact__c, t.Account__c 
       									  				From Transaction_Stack__c t Where t.Lead__c in :mapLead.keySet()]){ 
       			if(mapLead.containsKey(t.Lead__c)){
       				Lead l = mapLead.get(t.Lead__c);
       				if(l.ConvertedContactId != Null){
       					t.Contact__c = l.ConvertedContactId;
       				}
       				if(l.ConvertedAccountId != Null){
       					t.Account__c = l.ConvertedAccountId;
       				}
       				listTS.add(t); 
       			}
       		}
       		
       		if(listTS.size() > 0){
       			database.update(listTS, false);
       		}       		
       	}
	}
		                				
}