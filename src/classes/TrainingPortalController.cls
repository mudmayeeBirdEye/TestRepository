public class TrainingPortalController{

	public User objUser{get;set;}
	public boolean isActivationCodeAvaliable {get;set;} 
   	public TrainingPortalController() {
      	objUser = new User();
      	isActivationCodeAvaliable = false;
     	 objUser = [Select RCPartner_ID__c,email,id,RCSFDCUserName__c, Hughes_UserID__c,SFDC_Activation_Code_Group_Name__c,SFDCUserName__c
               		,FirstName,LastName,Contact.Account.RC_Brand__c, Contact.Account.Activation_Code_Group_Name__c  
               		from User where id=:UserInfo.getUserId()];
      	if(!(string.isBlank(objUser.Contact.Account.Activation_Code_Group_Name__c))
 			/*&& (objUser.Contact.Account.Activation_Code_Group_Name__c == 'UK Resellers'
 					|| objUser.Contact.Account.Activation_Code_Group_Name__c == 'Direct Sales Agents')*/
 					) {
 			isActivationCodeAvaliable = true;
 		}         
   	}
}