global class syncPartnerAccountUpdateSharingRuleSch implements Schedulable {
	global void execute(SchedulableContext ctx) {
   		//  syncAccountUpdateSharingRule.massUpdateSharingRule();
    	syncPartnerAccountUpdateSharingRule obj=new syncPartnerAccountUpdateSharingRule();
    	Database.executeBatch(obj,1);  
  	}
}