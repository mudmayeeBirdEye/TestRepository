public class leadInsert {
	public leadInsert(){}
/*public void insertList(list<Lead> l) {
	Map<String, Lead> leadMap = new Map<String, Lead>();
	Lead dumpLead;
	
	System.debug('this is the leadmap in the very begining ' + leadMap);
	for (Lead lead : l) {
		// Make sure another new lead isn't also a duplicate
		if (!leadMap.containsKey(lead.Email)) {
			leadMap.put(lead.Email, lead);
		}	
	}
	System.debug('this is the leadmap without duplicates ' + leadMap);
	// Using a single database query, find all the leads in
	// the database that have the same email address as any
	// of the leads being inserted or updated.
	for (Lead lead : [SELECT id,Email FROM Lead WHERE Email IN :leadMap.KeySet()]) {	
		dumpLead = leadMap.remove(lead.email);
		//delete lead;
		//lead.Description = lead.Description + '*Following information copied from newer merged lead* ' + 
	}
	
	System.debug('this is the leadmap after checking with SF' + leadMap);


	List<Lead> leads = new List<Lead>();
	leads = leadMap.values();
		
	System.debug('this is the lead list before insert' + leads);
	
	insert leads;

}

public void insertLead(Lead l){
	Lead db = [SELECT Email FROM Lead WHERE Email = :l.Email];
	if (db == null){
		insert l;
	}
	
}
*/


/*	public boolean insertLead(Lead l){
		if (l.Email != null ) {
			// Query for all leads that have the same email and zip code as the new lead
		    Integer dupCount = [select count() from Lead WHERE email = :l.Email ];
		    if ( dupCount > 0 ) {
		    	// Lead exists, so don't insert
		    	return false;
		    	//future possibilites include field information comparison 
		        
		    }
	    	// No dup is found, so let the processing continue
	    	insert l;
	    	return true;
		}
		
		return false;

		
	}
*/
}