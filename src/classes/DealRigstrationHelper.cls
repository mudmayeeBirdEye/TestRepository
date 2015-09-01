public with sharing class DealRigstrationHelper {
	
	public static boolean IsChanged(VAR_Deal_Registration__c newDealobj, VAR_Deal_Registration__c oldDealobj){
		if( newDealobj.Approval_Date__c != oldDealobj.Approval_Date__c
			|| newDealobj.Comments__c != oldDealobj.Comments__c
			|| newDealobj.Company_Name__c != oldDealobj.Company_Name__c
			|| newDealobj.Company_Website__c != oldDealobj.Company_Website__c
			|| newDealobj.Contact_1_First_Name__c != oldDealobj.Contact_1_First_Name__c
			|| newDealobj.Contact_1_Last_Name__c != oldDealobj.Contact_1_Last_Name__c
			|| newDealobj.Contact_1_Phone__c != oldDealobj.Contact_1_Phone__c
			|| newDealobj.Contact_1_Title__c != oldDealobj.Contact_1_Title__c
			|| newDealobj.Contact_2_First_Name__c != oldDealobj.Contact_2_First_Name__c
			|| newDealobj.Contact_2_Last_Name__c != oldDealobj.Contact_2_Last_Name__c
			|| newDealobj.Contact_2_Phone__c != oldDealobj.Contact_2_Phone__c
			|| newDealobj.Contact_2_Title__c != oldDealobj.Contact_2_Title__c
			|| newDealobj.Contact_3_First_Name__c != oldDealobj.Contact_3_First_Name__c
			|| newDealobj.Contact_3_Last_Name__c != oldDealobj.Contact_3_Last_Name__c
			|| newDealobj.Contact_3_Phone__c != oldDealobj.Contact_3_Phone__c
			|| newDealobj.Contact_3_Title__c != oldDealobj.Contact_3_Title__c
			|| newDealobj.Contact_4First_Name__c != oldDealobj.Contact_4First_Name__c
			|| newDealobj.Contact_4_Last_Name__c != oldDealobj.Contact_4_Last_Name__c
			|| newDealobj.Contact_4_Phone__c != oldDealobj.Contact_4_Phone__c
			|| newDealobj.Contact_4_Title__c != oldDealobj.Contact_4_Title__c
			|| newDealobj.Contact_5_First_Name__c != oldDealobj.Contact_5_First_Name__c
			|| newDealobj.Contact_5_Last_Name__c != oldDealobj.Contact_5_Last_Name__c
			|| newDealobj.Contact_5_Phone__c != oldDealobj.Contact_5_Phone__c
			|| newDealobj.Contact_5_Title__c != oldDealobj.Contact_5_Title__c
			|| newDealobj.Description__c != oldDealobj.Description__c
			|| newDealobj.Email_1__c != oldDealobj.Email_1__c
			|| newDealobj.Email_2__c != oldDealobj.Email_2__c
			|| newDealobj.Email_3__c != oldDealobj.Email_3__c
			|| newDealobj.Email_4__c != oldDealobj.Email_4__c
			|| newDealobj.Email_5__c != oldDealobj.Email_5__c
			|| newDealobj.Expiration_Date__c != oldDealobj.Expiration_Date__c
			|| newDealobj.Extension_Approved__c != oldDealobj.Extension_Approved__c
			|| newDealobj.Expiration_Date__c != oldDealobj.Expiration_Date__c
			|| newDealobj.Industry__c != oldDealobj.Industry__c
			|| newDealobj.Is_Expired__c != oldDealobj.Is_Expired__c
			|| newDealobj.Number_of_Employees__c != oldDealobj.Number_of_Employees__c
			|| newDealobj.Number_of_Locations__c != oldDealobj.Number_of_Locations__c
			|| newDealobj.Number_of_Users__c != oldDealobj.Number_of_Users__c 
			|| newDealobj.Partner_Account_Id__c != oldDealobj.Partner_Account_Id__c
			|| newDealobj.Partner_Id__c != oldDealobj.Partner_Id__c
			|| newDealobj.Phone__c != oldDealobj.Phone__c
			|| newDealobj.Registration_Status__c != oldDealobj.Registration_Status__c
			) {
				return true;
			}
		return false;
	} 
	
	/*Test Methods*/
 /*  @isTest( SeeAllData = true )
   static  void DealRigstrationHelperTest() {
		  VAR_Deal_Registration__c newDealobj = new VAR_Deal_Registration__c();
		  VAR_Deal_Registration__c oldDealobj = new VAR_Deal_Registration__c();
		  DealRigstrationHelper.IsChanged( newDealobj , oldDealobj );
		  
		  VAR_Deal_Registration__c newDealobj0 = new VAR_Deal_Registration__c();
		  newDealobj0.Description__c ='test';
		  VAR_Deal_Registration__c oldDealobj0 = new VAR_Deal_Registration__c();
		  DealRigstrationHelper.IsChanged( newDealobj0 , oldDealobj0 );
		  
   }*/
}