/*************************************************
ConvertLead class   
This Class is used by convertLeadVFPage.page which over-rides Convert button for Lead object in SFDC.
Using details of lead this class searches for possible contact matches based on phone and email.
Then it looks at the Accounts associated to those contacts to see if there are any ActivePipe Opportunities.
The page shows agent that there already exists an Account which has the same contact information and if it is protected at all.
Agent can choose to select the matching Account, search for an account they know matchs or create a brand new account.
If merging only a new Opportunity is made which is tied to the existing Account and Contact.
/************************************************/

public class ConvertLead { 
  	public ConvertLead() {
       
    }
    
   /* static testMethod void unitTestMethod() {
    	ConvertLead convertObj = new ConvertLead();
    }*/
}