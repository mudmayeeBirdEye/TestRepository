/*************************************************
Trigger on Implementation object
After Delete: Prevents non-admin user from deleting Implementations.
/************************************************/

trigger ImplementationSaver on Implementation__c (after delete) {
	// Get the current user's profile name
	Profile prof = [select Name from Profile where Id = :UserInfo.getProfileId() ];
	  
	// If current user is not a System Administrator, do not allow Attachments to be deleted
	if (!'System Administrator'.equalsIgnoreCase(prof.Name)) {
		for (Implementation__c i : Trigger.old) {
			i.addError('Unable to delete Implementations.');
		}  
	}
	
	/**
	 *	Strat of Completion Rate Calculation After deletion of Implementation records.
	 */
	 	GraduationScoreCardHelper.updateAccountOnImplementationDeletion(Trigger.old);
		
	 /**
	 *	End of Completion Rate Calculation After deletion of Implementation records.
	 */
}