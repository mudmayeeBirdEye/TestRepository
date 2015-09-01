public class GetIndustry{
	public Summary[] Summaries { get; set; }

    public GetIndustry() {
    	try{
	        String lastIndustry;
	        AggregateResult[] results = [SELECT Id, Name FROM Industry__c GROUP BY Id, Name order by Name];
	        Summaries = new List<Summary>();
	        for (AggregateResult ar : results) {
	            if (lastIndustry!= (String) ar.get('Name')){
	                Summaries.add(new Summary(ar));
	                lastIndustry= (String) ar.get('Name');
	            }
	        }
    	}catch(exception e){
    		System.debug('##GetIndustry##'+ e.getlineNumber());
    		System.debug('**GetIndustry**'+e.getMessage());
    	}
    }
    
    public class Summary {
    	public String Id{ get; private set; }
        public String Name { get; private set; }

        public Summary(AggregateResult ar) {
        	try{
	            Id= (String) ar.get('Id');
	            Name = (String) ar.get('Name');
        	}catch(Exception e){
        		System.debug('##Summary##'+ e.getlineNumber());
        		System.debug('**Summary**'+e.getMessage());
        	 }    
        }
    	
    }
    
   
}