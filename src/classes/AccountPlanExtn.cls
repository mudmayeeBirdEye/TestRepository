public with sharing class AccountPlanExtn {
      
    public Account_Plan__c objAccountPlan {get; set;}
    public Boolean bEnableSaveButton {get; set;}    
    public Account_Plan__c objAccountReadOnlyPlan {get; set;}
    public Account objAccountObject {get; set;}
    
    String strAccountId = ApexPages.currentPage().getParameters().get('id');
    public Boolean bAccountPlanExist {get; set; }
    public Boolean bAccountPlanShowFromAccount {get; set; }
    public Boolean bAccountPlanShowFromPlan {get; set; }
    public Integer intDummyVal{get; set; }
    
    public Boolean bShowSaveMessage {get; set; }
     
    public AccountPlanExtn (ApexPages.StandardController controller) { 
        
        bAccountPlanExist = false;
        System.debug('In Constructor');
        intDummyVal = 0;       
        checkEnableSaveButton ();
        
        objAccountPlan = new Account_Plan__c();
        
        List<Account_Plan__c> liAccountPlan = [select Number_of_Employees__c, Number_of_Offices__c, 
                                                Digital_Line_Difference__c, Industry_from_Rep__c, 
                                                Industry__c, Website__c, Customer_Type__c, Primary_Contact__c, 
                                                Phone_System_Details__c,  Key_Features_Used_Why_RC_for_this_User__c, 
                                                Account_Plan_value__c, Asked_for_Referrals__c, 
                                                Offered_line_for_Fax_Machine__c, Presented_Additional_Numbers_to_be_Local__c, 
                                                Presented_Addl_No_to_track_Marketing__c, Using_Desktop_Phones__c, 
                                                Offered_Line_for_Conferencing_Phone__c, International_Usage__c, 
                                                Other_Upsell_Opportunities__c, Conference_Calling_Provider_Cost__c, 
                                                CRM_Provider__c, Type_of_ISP_Cost__c, Primary_Mobile_Phone_Device__c, 
                                                Account_Status__c, Brand__c, Service_Name__c, Tier__c, MRR__c, aMRR__c, 
                                                Number_of_DL_s__c, Number_of_Extensions__c, Number_of_IP_Devices__c 
                                                from Account_Plan__c where Account_ID__c=:strAccountId limit 1];
        if(null != liAccountPlan) {
            for( Account_Plan__c actPlan: liAccountPlan ){
                bAccountPlanExist = true;                
                
                //fetch account plan details into objAccountPlan 
                objAccountPlan.Account_Plan_Value__c = actPlan.Account_Plan_Value__c;
                objAccountPlan.Number_of_Employees__c = actPlan.Number_of_Employees__c;
                objAccountPlan.Number_of_Offices__c = actPlan.Number_of_Offices__c;
                objAccountPlan.Industry_from_Rep__c = actPlan.Industry_from_Rep__c;
                objAccountPlan.Website__c = actPlan.Website__c;
                objAccountPlan.Customer_Type__c = actPlan.Customer_Type__c;
                objAccountPlan.Primary_Contact__c = actPlan.Primary_Contact__c;
                objAccountPlan.Phone_System_Details__c = actPlan.Phone_System_Details__c;
                objAccountPlan.Key_Features_Used_Why_RC_for_this_User__c = actPlan.Key_Features_Used_Why_RC_for_this_User__c;
                objAccountPlan.Account_Plan_value__c = actPlan.Account_Plan_value__c;
                objAccountPlan.Asked_for_Referrals__c = actPlan.Asked_for_Referrals__c;
                objAccountPlan.Offered_line_for_Fax_Machine__c = actPlan.Offered_line_for_Fax_Machine__c;
                objAccountPlan.Presented_Additional_Numbers_to_be_Local__c = actPlan.Presented_Additional_Numbers_to_be_Local__c;
                objAccountPlan.Presented_Addl_No_to_track_Marketing__c = actPlan.Presented_Addl_No_to_track_Marketing__c;
                objAccountPlan.Using_Desktop_Phones__c = actPlan.Using_Desktop_Phones__c;
                objAccountPlan.Offered_Line_for_Conferencing_Phone__c = actPlan.Offered_Line_for_Conferencing_Phone__c;
                objAccountPlan.International_Usage__c = actPlan.International_Usage__c;
                objAccountPlan.Other_Upsell_Opportunities__c = actPlan.Other_Upsell_Opportunities__c;
                objAccountPlan.Conference_Calling_Provider_Cost__c = actPlan.Conference_Calling_Provider_Cost__c;
                objAccountPlan.CRM_Provider__c = actPlan.CRM_Provider__c;
                objAccountPlan.Type_of_ISP_Cost__c = actPlan.Type_of_ISP_Cost__c;
                objAccountPlan.Primary_Mobile_Phone_Device__c = actPlan.Primary_Mobile_Phone_Device__c;
                                                   
            }            
        }  else {
                bAccountPlanExist = false; 
                
                //objAccountPlan.Account_ID__c = strAccountID ;
                //objAccountPlan.Account__c = strAccountID ;
        }    
        
        //if bAccountPlanExist is true, AccountPlan has been created for this account and
        //Account lookup fields must have been set set, and it will be fetched to objAccountPlan
        //If objAccountPlan is false, Account Plan object has not been created yet, and these values 
        //should be taken from Account object directly
        if(bAccountPlanExist){
            System.debug ('Account plan exists');
            bAccountPlanShowFromAccount = false;
            bAccountPlanShowFromPlan = true;    
                
            //get its readonly object Digital_Line_Difference__c 
            try{
            objAccountReadOnlyPlan = [select Account_Status__c,Brand__c, name,  Service_Name__c,Tier__c, MRR__c, 
                                    aMRR__c, Digital_Line_Difference__c, Number_of_DL_s__c, Number_of_Extensions__c , 
                                    Number_of_IP_Devices__c  from Account_Plan__c 
                                    where Account__r.id=:strAccountId limit 1];    
            }catch(Exception ex){}             
        } else {
            System.debug ('Account plan does not exist');
            bAccountPlanShowFromAccount = true;
            bAccountPlanShowFromPlan = false;   
            
            //get its readonly object
            objAccountObject = [select Account.RC_Account_Status__c, Account.RC_Brand__c   , Account.RC_Service_name__c  ,
                                Account.RC_Tier__c  ,Account.MRR__c  ,Account.aMRR__c      ,
                                Account.Number_of_DL_s__c,Account.Number_of_Extensions__c   ,
                                Account.Number_of_IP_Devices__c,Account.Payment_Plan__c ,RC_Digital_Line_Difference__c     
                                from Account where id=:strAccountId limit 1];                                  
        }
           
        
    }
    
    
     public PageReference save() {         
          System.debug('In save');
                    
          if(bAccountPlanExist ) {    //if it exists, issue an update 
              //objAccountPlan.Account_Plan_Value__c = strAccountPlan;
                List<Account_Plan__c> liAccountPlan = [select Number_of_Employees__c, Number_of_Offices__c, 
                                                Digital_Line_Difference__c, Industry_from_Rep__c, 
                                                Industry__c, Website__c, Customer_Type__c, Primary_Contact__c, 
                                                Phone_System_Details__c,  Key_Features_Used_Why_RC_for_this_User__c, 
                                                Account_Plan_value__c, Asked_for_Referrals__c, 
                                                Offered_line_for_Fax_Machine__c, Presented_Additional_Numbers_to_be_Local__c, 
                                                Presented_Addl_No_to_track_Marketing__c, Using_Desktop_Phones__c, 
                                                Offered_Line_for_Conferencing_Phone__c, International_Usage__c, 
                                                Other_Upsell_Opportunities__c, Conference_Calling_Provider_Cost__c, 
                                                CRM_Provider__c, Type_of_ISP_Cost__c, Primary_Mobile_Phone_Device__c, 
                                                Account_Status__c, Brand__c, Service_Name__c, Tier__c, MRR__c, aMRR__c, 
                                                Number_of_DL_s__c, Number_of_Extensions__c, Number_of_IP_Devices__c 
                                                from Account_Plan__c where Account_ID__c=:strAccountId limit 1];
                                                
                if(null != liAccountPlan) {
                    for( Account_Plan__c actPlan: liAccountPlan ){
                        
                        //repopulate account plan details into list AccountPlan 
                        actPlan.Account_Plan_Value__c = objAccountPlan.Account_Plan_Value__c;
                        actPlan.Number_of_Employees__c = objAccountPlan.Number_of_Employees__c;
                        actPlan.Number_of_Offices__c = objAccountPlan.Number_of_Offices__c;
                        actPlan.Industry_from_Rep__c = objAccountPlan.Industry_from_Rep__c;
                        actPlan.Website__c = objAccountPlan.Website__c;
                        actPlan.Customer_Type__c = objAccountPlan.Customer_Type__c;
                        actPlan.Primary_Contact__c = objAccountPlan.Primary_Contact__c;
                        actPlan.Phone_System_Details__c = objAccountPlan.Phone_System_Details__c;
                        actPlan.Key_Features_Used_Why_RC_for_this_User__c = objAccountPlan.Key_Features_Used_Why_RC_for_this_User__c;
                        actPlan.Account_Plan_value__c = objAccountPlan.Account_Plan_value__c;
                        actPlan.Asked_for_Referrals__c = objAccountPlan.Asked_for_Referrals__c;
                        actPlan.Offered_line_for_Fax_Machine__c = objAccountPlan.Offered_line_for_Fax_Machine__c;
                        actPlan.Presented_Additional_Numbers_to_be_Local__c = objAccountPlan.Presented_Additional_Numbers_to_be_Local__c;
                        actPlan.Presented_Addl_No_to_track_Marketing__c = objAccountPlan.Presented_Addl_No_to_track_Marketing__c;
                        actPlan.Using_Desktop_Phones__c = objAccountPlan.Using_Desktop_Phones__c;
                        actPlan.Offered_Line_for_Conferencing_Phone__c = objAccountPlan.Offered_Line_for_Conferencing_Phone__c;
                        actPlan.International_Usage__c = objAccountPlan.International_Usage__c;
                        actPlan.Other_Upsell_Opportunities__c = objAccountPlan.Other_Upsell_Opportunities__c;
                        actPlan.Conference_Calling_Provider_Cost__c = objAccountPlan.Conference_Calling_Provider_Cost__c;
                        actPlan.CRM_Provider__c = objAccountPlan.CRM_Provider__c;
                        actPlan.Type_of_ISP_Cost__c = objAccountPlan.Type_of_ISP_Cost__c;
                        actPlan.Primary_Mobile_Phone_Device__c = objAccountPlan.Primary_Mobile_Phone_Device__c;
                                                
                    }    
                    update liAccountPlan ; 
                    bAccountPlanExist = true;         
                }
                 
             } else { //insert Account Plan
                //Account_Plan__c objAccountPlan = new Account_Plan__c();
                System.debug('entered Description= ' + objAccountPlan.Account_Plan_Value__c);
                System.debug('entered primary Contact= ' + objAccountPlan.Primary_Contact__c);
                objAccountPlan.Account_ID__c = strAccountID ;
                objAccountPlan.Account__c = strAccountID ;
                insert objAccountPlan; 
             List<Account_Plan__c> listAP = [Select  Id From Account_Plan__c  where Account_ID__c =: strAccountId limit 1];
            String strAccount_Plan_Id=null;
             if(null != listAP ) {
            for( Account_Plan__c  objAccountPlanc  : listAP ){
               strAccount_Plan_Id=objAccountPlanc.Id;
              }
             } 
             List<Account> listACc = [Select  Id,Account__c From Account where id=: strAccountId limit 1];
             if(null != listACc ) {
            for( Account objAcc  : listACc ){
               objAcc.Account__c=strAccount_Plan_Id; 
               update objAcc  ;
              }
             } 
             
               
                bAccountPlanExist = true;  
         }
          
          bShowSaveMessage = true;
                                       
          //PageReference createAccountPage = new PageReference('/apex/AccountPlanPage?id='+strAccountID);
          //createAccountPage.setRedirect(true);
          //return createAccountPage ;
          return null;
     }    
       
     //function to set bEnableSaveButton 
     //if current logged in user is owner of account, then only save button will be enabled   
     private void checkEnableSaveButton (){
        bEnableSaveButton = true;
        //Get current owner of account by Owner (or Current_Owner__c)
        List<Account> liAccount = [select name, OwnerId /*Current_Owner__c*/ from Account where id=:strAccountId limit 1];
        
        if(null != liAccount ) {
            for( Account objAccount: liAccount ){
                if(objAccount.OwnerId == UserInfo.getUserId()) {
                   bEnableSaveButton = true; 
                }
            }            
        }     
     
     }  
  
   /* static testMethod void testAccountPlanExtn() {
    	Account accObj = new Account();
  	    accObj.Name = 'TestAccount';
      	accObj.RC_Attribution_Channel__c = 'Sales Agents & Resellers';
      	accObj.Partner_ID__c = '123';
       	accObj.RecordTypeId  = '01280000000UERq';
       	accObj.OwnerId = UserInfo.getUserId();
      	insert accObj;
      	
      	ApexPages.currentPage().getParameters().put('Id',accObj.Id);
      	
      	AccountPlanExtn accountPlanExtnObj = new AccountPlanExtn(new ApexPages.StandardController(new Account()));
  		accountPlanExtnObj.save();
      	
      	Account_Plan__c accountPlanObj = new Account_Plan__c();
      	accountPlanObj.Account__c = accObj.Id;
      	accountPlanObj.Account_ID__c = accObj.Id;
      	insert accountPlanObj;
     	
     	AccountPlanExtn accountPlanExtnObj1 = new AccountPlanExtn(new ApexPages.StandardController(new Account())); 
  		accountPlanExtnObj1.save();
  	 }*/
}