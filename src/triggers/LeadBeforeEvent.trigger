trigger LeadBeforeEvent on Lead (before insert, before update) {
/*************************************************
Trigger on Lead object
Before Insert: Evaluate company size.
               Adjust LeadSource as needed.
               Set Primary_Campaign__c field for use in Lead_After.
               Assign lead using Protection Rules or Lead Assignment Rules.
Before Update: Set Downgrade Date.
               Update indexed fields.
               Update owner manager name and email fields.
               Update Last Touched and Responded fields.
               Use mkto2__Lead_Score__c numerical value to set Lead_Score__c alphanumeric value.
/************************************************/
	// Select a.Status__c, a.Name From ActiveOldLeadBefore__c a
	
}