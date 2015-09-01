public class RCSupportPortalSystemStatusController{

	public System_Status__c objStatus;
	public Boolean isPublicDescFound {get;set;}
	public String strClassName {get;set;}
	public string strResolvedDescription; 
	public string strOpenDescription;
	public List<string> resolveDescriptionLst {get;set;}
	public List<string> openDescriptionLst {get;set;}

	public RCSupportPortalSystemStatusController(){
 		 
 		openDescriptionLst = new List<String>();
	 	resolveDescriptionLst = new List<String>();
	   	isPublicDescFound = false;
	   	RCSiteSetup__c  objSite = getSiteDetail();
	   	objStatus = new System_Status__c();
	   	String strRegion = 'US';
	   	strClassName = 'status-bg-right-green';
	    
		if(objSite.Brand_Filter__c!=null){
			if(objSite.Brand_Filter__c.indexOf('US')>0){
				strRegion='US'; 
			} else if(objSite.Brand_Filter__c.indexOf('UK')>0){
				strRegion='UK';
			} else if(objSite.Brand_Filter__c.indexOf('CAN')>0){
				strRegion='CAN';
			}
			strRegion='%'+strRegion+'%';
	      	boolean flag = false;
	     	try {
	     		/* For Resolved Status
				   New Change - 20th November 2014 : No matter the color of the service status button, 
				                                     if there are any Resolved Issues resolved over 6 hours ago, 
				                                     the PFD for those issues should not be displayed on the Service Status bar.
				   Case Number - 03076521
				*/
		 		for(System_Status__c sysObj : [SELECT createdDate,IncidentID__c,Internal_Status__c,Public_Description__c,Region__c,Severity__c,
		                   							  Summary__c,System_Status__c,Name, Incident_Resolved_Date__c 
		                   					   FROM System_Status__c 
		                   					   WHERE Region__c Like : strRegion AND Severity__c != null AND Severity__c != '' AND 
		                   						((Internal_Status__c = 'RESOLVED' AND Incident_Resolved_Date__c > :system.now().addHours(-6)) OR  Internal_Status__c = 'CLOSED') 
		                   						order by  Severity__c desc, Incident_Resolved_Date__c desc NULLS LAST]) {
		        	if(((!String.isBlank(sysObj.Public_Description__c) && !sysObj.Public_Description__c.equalsIgnoreCase('false'))) && !string.isBlank(sysObj.Internal_Status__c)) {
	        			if((sysObj.Internal_Status__c.equalsIgnoreCase('RESOLVED') && sysObj.Incident_Resolved_Date__c > system.now().addHours(-6)) || 
	        			    sysObj.Internal_Status__c.equalsIgnoreCase('CLOSED')) {
	        		   		resolveDescriptionLst.add(String.isBlank(sysObj.Public_Description__c) ? '' : sysObj.Public_Description__c.trim());
	            		}
        			}           							
				} 
				/* For Open Status 
				   New Change - 20th November 2014 : If there are no Current Issues AND no Resolved Issues resolved within the last 6 hours: 
				                                     display the status as Green with proper message.
				                                   : Change the logic of status display as follows
				                                   		•         GREEN Status – when No Issues or Level 0 issues
														•         YELLOW Status – When Level 1 issues
														•         RED Status – When Level 2 + issues
				                                   
				   Case Number - 03076521
				*/
				for(System_Status__c sysObj : [SELECT createdDate,IncidentID__c,Internal_Status__c,Public_Description__c,Region__c,Severity__c,
		                   						      Summary__c,System_Status__c,Name 
		                   					   FROM System_Status__c 
		                   					   WHERE Region__c like : strRegion AND Severity__c != null AND Severity__c != '' AND 
		                   						(Internal_Status__c = 'OPEN' OR (Internal_Status__c = 'RESOLVED' AND Incident_Resolved_Date__c > :system.now().addHours(-6))) 
		                   						order by  Severity__c desc, Incident_Start_Date__c desc NULLS LAST]) {
					if(((!String.isBlank(sysObj.Public_Description__c) && !sysObj.Public_Description__c.equalsIgnoreCase('false'))) && !string.isBlank(sysObj.Internal_Status__c)) {
	        			if(!sysObj.Internal_Status__c.equalsIgnoreCase('RESOLVED')) {
			            	if(flag == false) {
				            	flag = true;
				            	if(sysObj.Severity__c == 'Level-1'){
								    strClassName = 'status-bg-right-orange';
								} else if((sysObj.Severity__c == 'Level-2' || sysObj.Severity__c == 'Level-3' || sysObj.Severity__c == 'Level-4' || sysObj.Severity__c =='Level-5')){
								    strClassName='status-bg-right-red';
								} else {
									strClassName = 'status-bg-right-green';
								}
			            	}
			            	openDescriptionLst.add(String.isBlank(sysObj.Public_Description__c) ? '' : sysObj.Public_Description__c.trim());
			            }
        			}
				}
	           
		        if(resolveDescriptionLst.size() != 0 || openDescriptionLst.size() != 0) {
		        	isPublicDescFound = true;
		        } else {
		        	strClassName = 'status-bg-right-green';
		        }
     		} catch(Exception e) {
	       		//strException =e.getMessage();
	     	}
  		}
	}
	
	/************************************** To GET Site Details ************************************************************************/
   	private RCSiteSetup__c  getSiteDetail(){
   		RCSiteSetup__c siteSetup=null;
    	try {
    		String siteName = Site.getName();
         	if(siteName == null || siteName.length()==0) {
           		siteName = 'rcsupport';
          	}
        	siteSetup = [SELECT RCSiteName__c, RootCategoryName__c, CategoryGroupName__c, CacheMaxAge__c,
                       		Category1Description__c, Category2Description__c, Category3Description__c,
                       		Category4Description__c, Category5Description__c, Category6Description__c,
                       		HomeAdText__c, HomeAdTitle__c, Brand_Filter__c
                       		FROM RCSiteSetup__c
                       		WHERE RCSiteName__c = :siteName];
      	} catch (QueryException  e) {
     		siteSetup = new RCSiteSetup__c();
    	}
  	return siteSetup;
    }
}