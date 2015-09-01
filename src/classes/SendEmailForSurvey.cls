/*
* For sending Email we are using Custom object ENH
* Where particuler condition fire an email to respective emails
*/

public class SendEmailForSurvey {
	
	/*private static final String leadPrefix = Schema.SObjectType.Lead.getKeyPrefix();
	private static final String contactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
	private static final String userPrefix = Schema.SObjectType.User.getKeyPrefix();*/
	   
	/*
	* @param idSet is ids of object for survey.
	*/
	/*public static void fetchEmailFromIds(Set<ID> userIds, Set<ID> leadIds, Set<ID> contactIds ) {
		System.debug('##UserIds##'+userIds);
		System.debug('##LeadIds##'+leadIds);
		System.debug('##ConatctIds##'+contactIds);
		List<User> userList = new List<User>();
		List<Lead> leadList = new List<Lead>();
		List<Contact> contactList = new List<Contact>();
		
		userList = [Select Email From User Where ID IN: userIds ];	
		leadList = [Select Email From Lead Where ID IN: leadIds ];
		contactList = [Select Email From Contact Where ID IN: contactIds ];
		
		List<String> emails = new List<String>();
		
		Integer counter = 0;
		for ( User userTemp : userList ) {
			emails.add( userTemp.email );
		}
		for ( Lead leadTemp : leadList ) {
			emails.add( leadTemp.email );
		}
		for (Contact contactTemp : contactList ) {
			emails.add( contactTemp.email );
		}
		
		if( emails != null && emails.size() > 0 ){
			sendAnEmail( emails );
		}
		
	}*/
	/*
	* @param emails is List of emails of objects for survey.
	* not sending survey just create the ENH object 
	*/
	public static void sendAnEmail(List<String> emails , String surveyId, string surveyTemplateName) {
		
		Set<String> setOfIds = new Set<String>();
		setOfIds.addAll( emails );
		List<String> tempList = new List<String>();
		tempList.addAll( setOfIds );
		
		List<Exception_And_Notification_History__c> ENHList =  new List<Exception_And_Notification_History__c>();
		
		
		for( String email : tempList ) {
				Exception_And_Notification_History__c ENHobject = new Exception_And_Notification_History__c();
		   		ENHobject.Object_Type__c = 'SurveyDetails';
		   		ENHobject.content_label_01__c = surveyId ;
		   		ENHobject.content_label_02__c = surveyTemplateName;
		   		/*ENHobject.content_label_01__c = salesAgree.Account__r.Name;
		   		ENHobject.content_label_02__c = salesAgree.Name;
		   		ENHobject.content_label_03__c = salesAgree.Id;
		   		ENHobject.content_label_04__c = String.valueOf( selfRenew );*/
		   			   		
		   		ENHobject.To_Address_1__c = email;
		   		/*Assuming the maximum emails addresses should be five*/
		   		/*for(Integer i = 0 ; i < emails.size() ; i++ ){
			   			if( i == 0 ) {
			   				ENHobject.To_Address_1__c = emails[i];
			   			}
			   			else if( i == 1 ) {
			   				ENHobject.To_Address_2__c = emails[i];
			   			}
			   			else if( i == 2 ) {
			   				ENHobject.To_Address_3__c = emails[i];
			   			}
			   			else if( i == 3 ) {
			   				ENHobject.To_Address_4__c = emails[i];
			   			}
			   			else if( i == 4 ) {
			   				ENHobject.To_Address_5__c = emails[i];
			   			}
		   		}*/
		   		ENHList.add( ENHobject );
		   		//return ENHobject;
		}
		
		insert ENHList;
		System.debug('################################################'+ENHList);
	}
		
		
}