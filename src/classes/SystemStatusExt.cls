/**************************************************************************************************
* Project Name..........: RingCentral -                                                           *
* File..................: SystemStatusExt                                                         *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........:4 September 2013                                                         *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....:                                                                         *
* Description...........: This is class for the Partner Portal                                    *
**************************************************************************************************/

public without sharing class SystemStatusExt {  
    public String severity_class {get; set;}
    Map<String,String> classMap;    
    public String us_class {get;set;}
    public String uk_class {get;set;}
    public String can_class {get;set;}
    public List<System_Status__c> usList_open {get;set;}
    public List<System_Status__c> usList_resolved {get;set;}
    public List<System_Status__c> ukList_open {get;set;}
    public List<System_Status__c> ukList_resolved {get;set;}
    public List<System_Status__c> canList_open {get;set;}
    public List<System_Status__c> canList_resolved {get;set;}
    public Boolean hasUSOpenRecords {get;set;}
    public Boolean hasUKOpenRecords {get;set;}
    public Boolean hasCANOpenRecords {get;set;}
    public Boolean hasUSResolvedRecords {get;set;} 
    public Boolean hasUKResolvedRecords {get;set;}
    public Boolean hasCANResolvedRecords {get;set;}
    List<System_Status__c> systemRecords;
    
    public SystemStatusExt(){
        classMap = new Map<String,String>();
        classMap.put('green','status-bg-right-green');
        classMap.put('yellow','status-bg-right-orange');
        classMap.put('red','status-bg-right-red');
        getAllSystemRecords();
        getLastSystemStatus(); 
        getListOfSystemStatus();
    }
    
    public void getAllSystemRecords(){
        systemRecords = [SELECT Name, Public_Description__c, Internal_Status__c, Severity__c, Region__c, System_Status__c 
                                                                    FROM System_Status__c order by Severity__c desc, lastModifiedDate desc];
    }
    public void getLastSystemStatus(){
        try{
            if(systemRecords != null && systemRecords.size() > 0){
                for(System_Status__c obj : systemRecords){
                    if(!String.isBlank(obj.Public_Description__c) && !'false'.equalsIgnoreCase(obj.Public_Description__c) 
                    																	&& !''.equalsIgnoreCase(obj.Internal_Status__c)){
                        String systemStatus = obj.System_Status__c;
                        if(systemStatus.containsIgnoreCase('Green')){
                            severity_class = classMap.get('green');
                        }else if(systemStatus.containsIgnoreCase('Yellow')){
                            severity_class = classMap.get('yellow');
                        }else if(systemStatus.containsIgnoreCase('Red')){
                            severity_class = classMap.get('red');
                        }else{
                            severity_class = 'status-bg-right-green';
                        }
                        break;
                    }
                }               
            } 
        }catch(Exception ex){
            system.debug('getLastSystemStatus Method Exception===='+ex.getMessage() + '\n' + ex.getStackTraceString());
        }
    }
    
    public void getListOfSystemStatus(){
        try{
            String defaulClass = 'status-bg-right-green';
            Map<String,String> mapRegoin_Level = new Map<String,String>();
            Map<String,List<System_Status__c>> mapOpenRecords = new Map<String,List<System_Status__c>>();
            Map<String,List<System_Status__c>> mapResolovedRecords = new Map<String,List<System_Status__c>>();
            if(systemRecords != null && systemRecords.size() >0 ){
                for(System_Status__c obj : systemRecords){
                    if(!String.isBlank(obj.Public_Description__c) && !'false'.equalsIgnoreCase(obj.Public_Description__c) 
                    																	&& !''.equalsIgnoreCase(obj.Internal_Status__c)){
                    	String strRegion = '';
                    	if('US'.equalsIgnoreCase(obj.Region__c) || 'USA'.equalsIgnoreCase(obj.Region__c)){
                    		strRegion = 'usa';
                    	}
                    	if('CAN'.equalsIgnoreCase(obj.Region__c) || 'Canada'.equalsIgnoreCase(obj.Region__c)){
                    		strRegion = 'canada';
                    	}
                    	if('UK'.equalsIgnoreCase(obj.Region__c)){
                    		strRegion = 'uk';
                    	}
                        if(!mapRegoin_Level.containsKey(strRegion)){
                            mapRegoin_Level.put(strRegion, obj.System_Status__c);
                        }
                        if('Open'.equalsIgnoreCase(obj.Internal_Status__c)){
                            if(mapOpenRecords.containsKey(obj.Region__c.trim().toLowerCase())){
                                List<System_Status__c> lstRecords = mapOpenRecords.get(strRegion);
                                lstRecords.add(obj);
                                mapOpenRecords.put(strRegion,lstRecords);
                            }else{
                                List<System_Status__c> lstRecords = new List<System_Status__c>();
                                lstRecords.add(obj);
                                mapOpenRecords.put(strRegion,lstRecords);
                            }
                        }
                        if('Resolved'.equalsIgnoreCase(obj.Internal_Status__c)){
                            if(mapResolovedRecords.containsKey(obj.Region__c.trim().toLowerCase())){
                                List<System_Status__c> lstRecords = mapResolovedRecords.get(strRegion);
                                lstRecords.add(obj);
                                mapResolovedRecords.put(strRegion,lstRecords);
                            }else{
                                List<System_Status__c> lstRecords = new List<System_Status__c>();
                                lstRecords.add(obj);
                                mapResolovedRecords.put(strRegion,lstRecords);
                            }
                        }
                    }
                }
            }
            
            if(mapRegoin_Level.containsKey('usa')){
                String systemStatus = mapRegoin_Level.get('usa');
                if(systemStatus.containsIgnoreCase('Green')){
                    us_class = classMap.get('green');
                }else if(systemStatus.containsIgnoreCase('Yellow')){
                    us_class = classMap.get('yellow');
                }else if(systemStatus.containsIgnoreCase('Red')){
                    us_class = classMap.get('red');
                }else{
                    us_class = 'status-bg-right-green';
                }               
            }else{
                us_class = defaulClass;
            }
            
            if(mapRegoin_Level.containsKey('canada')){
                String systemStatus = mapRegoin_Level.get('canada');
                if(systemStatus.containsIgnoreCase('Green')){
                    can_class = classMap.get('green');
                }else if(systemStatus.containsIgnoreCase('Yellow')){
                    can_class = classMap.get('yellow');
                }else if(systemStatus.containsIgnoreCase('Red')){
                    can_class = classMap.get('red');
                }else{
                    can_class = 'status-bg-right-green';
                }               
            }else{
                can_class = defaulClass;
            }
            
            if(mapRegoin_Level.containsKey('uk')){
                String systemStatus = mapRegoin_Level.get('uk');
                if(systemStatus.containsIgnoreCase('Green')){
                    uk_class = classMap.get('green');
                }else if(systemStatus.containsIgnoreCase('Yellow')){
                    uk_class = classMap.get('yellow');
                }else if(systemStatus.containsIgnoreCase('Red')){
                    uk_class = classMap.get('red');
                }else{
                    uk_class = 'status-bg-right-green';
                }               
            }else{
                uk_class = defaulClass;
            }
            
            if(mapOpenRecords.containsKey('usa')){
                usList_open =  mapOpenRecords.get('usa');
            }
            if(mapOpenRecords.containsKey('uk')){
                ukList_open =  mapOpenRecords.get('uk');
            }
            if(mapOpenRecords.containsKey('canada')){
                canList_open =  mapOpenRecords.get('canada');
            }
            if(mapResolovedRecords.containsKey('usa')){
                usList_resolved =  mapResolovedRecords.get('usa');
            }
            if(mapResolovedRecords.containsKey('uk')){ 
                ukList_resolved =  mapResolovedRecords.get('uk');
            }
            if(mapResolovedRecords.containsKey('canada')){ 
                canList_resolved =  mapResolovedRecords.get('canada');
            }
            if(usList_open != null && usList_open.size() > 0){
                hasUSOpenRecords = true;
            }else{
                hasUSOpenRecords = false;
            } 
            if(usList_resolved != null && usList_resolved.size() > 0){
                hasUSResolvedRecords = true;
            }else{
                hasUSResolvedRecords = false;
            }
            if(ukList_open != null && ukList_open.size() > 0){
                hasUKOpenRecords = true;
            }else{
                hasUKOpenRecords = false;
            }
            if(ukList_resolved != null && ukList_resolved.size() > 0){
                hasUKResolvedRecords = true;
            }else{
                hasUKResolvedRecords = false;
            } 
            if(canList_open != null && canList_open.size() > 0){
                hasCANOpenRecords = true;
            }else{
                hasCANOpenRecords = false;
            }
            if(canList_resolved != null && canList_resolved.size() > 0){
                hasCANResolvedRecords = true;
            }else{
                hasCANResolvedRecords = false;
            }   
        }catch(Exception ex){
            system.debug('getListOfSystemStatus Method Exception===='+ex.getMessage() + '\n' + ex.getStackTraceString());
        }
    }
}