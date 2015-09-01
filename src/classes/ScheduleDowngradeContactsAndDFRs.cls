global class ScheduleDowngradeContactsAndDFRs Implements Schedulable{
   global void execute(SchedulableContext sc){
    	DowngradeContactsAndDFRs(); 
    }
    
    public void DowngradeContactsAndDFRs(){
    	new DG_DFR_Class().DowngradeContactsAndDFRs();
	}	
}