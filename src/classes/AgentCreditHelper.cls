/*
	Use this class for any update on Agent Credit object
	*Running on Trigger Context only
	-:Updating the Agent Credit trigger with Office Location field for monitoring current owner change.
*/
/*
	*isBeforeupdate exceut event on trigger.isUpdate on before
	*isBeforeInsert exceut event on trigger.isinsert on before
	*@param newList list of Agent credit in context of trigger e.g. Trigger.new
	*@param oldList list of Agent credit in context of trigger e.g. Trigger.old
	*@param newMap Map of Agent Credit in context of trigger e.g. Trigger.newMap
	*@param oldMap Map of Agent Credit in context of trigger e.g. Trigger.oldMap
*/
public class AgentCreditHelper {
	
	public static String ccAddresses = 'ccAddresses';
	public static String bccAddresses = 'bccAddresses';
	public static String toAddresses = 'toAddresses';
	public static String CurrentOwnerSalesResellers = 'Current Owner Sales & Resellers';
	public static String SalesResellers = 'RCSF Owner Sales & Resellers';
	public static String CurrentOwnerFranchiseAssoc = 'Current Owner Franchise & Assoc';
	public static String FranchiseAssoc = 'RCSF Owner Franchise & Assoc';
	
			public static void isBeforeInsert(List<Agent_Credit__c> newList){
				updateLocation( newList, null );// passing null here because we not need old map here
			}		
		
			public static void isBeforeUpdate(List<Agent_Credit__c> newList, List<Agent_Credit__c> oldList, Map<id,Agent_Credit__c> newMap, Map<id,Agent_Credit__c> oldMap ){
				updateLocation( newList, oldMap);
			}
		
			 private static void updateLocation(List<Agent_Credit__c> newList, Map<id,Agent_Credit__c> oldMap ) {
				Map< String, String > employeeLocationMap = getEmployeeLocation( newList );
					if( oldMap != null ){
						for(Agent_Credit__c agentCreditObjectNew : newList){
						Agent_Credit__c agentCreditObjectold = oldMap.get( agentCreditObjectNew.id );
					    	if( agentCreditObjectNew.OwnerId != agentCreditObjectold.OwnerId  ) {
								agentCreditObjectNew.Office_Location__c = employeeLocationMap.get( agentCreditObjectNew.OwnerId );
							}
						}	
				 	} else if( oldMap == null ) {
				 		for(Agent_Credit__c agentCreditObjectNew : newList){
				 			agentCreditObjectNew.Office_Location__c = employeeLocationMap.get( agentCreditObjectNew.OwnerId );
				 		}
			 	   }
			}
		/*
			*getEmployeeLocation returns Map<UserID, Location>
			*@param agentList is Agent Credit List
		*/
			private static Map<String,String> getEmployeeLocation(List<Agent_Credit__c> agentList) {
				Map<String , String> employeeLocationMap = new Map<String , String>(); 
				Set<Id> OwnerIDs = new Set<Id>();
				for( Agent_Credit__c agentCredit : agentList ){
					OwnerIDs.add( agentCredit.OwnerId );
				}
				for( Employee__c emp : [SELECT 	
											  User__c , 
											  Location__c, 
											  Email__c 
										FROM 
											  Employee__c 
										WHERE 
											  User__c IN : OwnerIDs 
											AND 
											  Is_Active__c = true ]){
					employeeLocationMap.put( emp.User__c , emp.Location__c );
				}
				return 	employeeLocationMap;
			}
			
			public static Map<String, List<String>> getCcBccEmailAddresses(String AgentCredit){
				
				Map<String, List<String>> toCcAndBccAddresses = new Map<String, List<String>>();
				Agent_Credit_Notification_Email_Address__c agentCreditEmails = Agent_Credit_Notification_Email_Address__c.getValues(AgentCredit);
				if(agentCreditEmails != null){
						if(String.isNotBlank(agentCreditEmails.bccAddresses__c)){
								toCcAndBccAddresses.put(bccAddresses, agentCreditEmails.bccAddresses__c.split(';'));
							}
						if(String.isNotBlank(agentCreditEmails.ccAddresses__c)){
								toCcAndBccAddresses.put(ccAddresses, agentCreditEmails.ccAddresses__c.split(';'));
							}
						if(String.isNotBlank(agentCreditEmails.toAddresses__c)){
								toCcAndBccAddresses.put(toAddresses, agentCreditEmails.toAddresses__c.split(';'));
							}
					}
					system.debug('-->'+toCcAndBccAddresses);
				return toCcAndBccAddresses;
			}
/*
	UNIT TEST
*/
		/*IF Context from Trigger ON before Insertion*/
		/*@isTest(SeeAllData=true)
 		static void AgentCreditHelperTest1(){
    		Profile p = [select id from profile where name='System Administrator'];
 		
 		    User testUser = new User(alias = 'u111', email='u111@testorg.com',
		    emailencodingkey='UTF-8', lastname='Testing11', languagelocalekey='en_US',
		    localesidkey='en_US', profileid = p.Id, country='United States',
		    timezonesidkey='America/Los_Angeles', username='u111@testorg.com');
		    insert testUser;
 			
 			
 			Employee__c emp = new Employee__c();
 			emp.User__c = testUser.id;
	        emp.First_Name__c = 'tuser';
	        emp.Last_Name__c = 'lname';
	        emp.Email__c ='clc@clc.com';
	        emp.Location__c = 'Noida, India';
	        emp.Department__c = 'IT';
	        emp.Team__c = 'SE';
	        emp.SPID__c = '12454';
	        insert emp;	
	        
	        System.runAs(testUser) {
	        	Agent_Credit__c asst = new Agent_Credit__c();
	        	asst.Name = 'testAgent';
	        	insert asst;
	        }	
 		}*/
 		/*IF Context from Trigger ON before Updation*/
		/* @isTest(SeeAllData=true)
 		static void AgentCreditHelperTest2(){
 			Profile p = [select id from profile where name='System Administrator'];
 		
 		    User testUser2 = new User(alias = 'u2Agent', email='u2Agent@testorg.com',
		    emailencodingkey='UTF-8', lastname='TestingAgent', languagelocalekey='en_US',
		    localesidkey='en_US', profileid = p.Id, country='United States',
		    timezonesidkey='America/Los_Angeles', username='u2Agent@testorg.com');
		    insert testUser2;
		    
		    Employee__c emp = new Employee__c();
 			emp.User__c = testUser2.id;
	        emp.First_Name__c = 'tuser2';
	        emp.Last_Name__c = 'lname2';
	        emp.Email__c ='2clc@clc.com';
	        emp.Location__c = 'Denver, US';
	        emp.Department__c = 'IT2';
	        emp.Team__c = 'SE';
	        emp.SPID__c = '12455';
	        insert emp;	
	        
	        Agent_Credit__c asst = new Agent_Credit__c();
	        asst.Name = 'testAgent';
	        insert asst;
	        
	         System.runAs(testUser2){
	        	asst.ownerid = testUser2.id;
	        	update asst;
	        }	
 		}*/
 		/*only for code coverage if without trigger context*/
		/*@isTest(SeeAllData=true)
 		static void AgentCreditHelperTest3(){
 			
 			AgentCreditHelper ach = new AgentCreditHelper();
 			
 			Agent_Credit__c agc = new Agent_Credit__c();
	        agc.Name = 'testAgent';
	        insert agc;
	        
	        List<Agent_Credit__c> newlist = new List<Agent_Credit__c>();
	        newlist.add( agc );
	        
	        List<Agent_Credit__c> oldlist = new List<Agent_Credit__c>();
	        newlist.add( agc );
	        
	        Map<id,Agent_Credit__c> newMap = new Map<id,Agent_Credit__c>();
	        newMap.put(agc.id , agc);
	        
	        Map<id,Agent_Credit__c> oldMap = new Map<id,Agent_Credit__c>();
	        oldMap.put(agc.id , agc);
	        
	        AgentCreditHelper.isBeforeInsert(newlist);
	        AgentCreditHelper.isBeforeUpdate( newList, oldList, newMap, oldMap);
 		}*/
}