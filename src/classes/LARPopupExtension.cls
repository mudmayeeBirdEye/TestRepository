public class LARPopupExtension {
	Lead_Assignment_Rules__c leadassignmentRuleObj {get;set;}
    public boolean closePan {get;set;}
    public boolean displayPopup {get; set;}
    string rtnUrl;
    string param1;
    string param2;
    string param3;
    string param4;  
    public LARPopupExtension(ApexPages.StandardController controller) {
    	try {
    		closePan = true;
	        rtnUrl = ApexPages.currentPage().getParameters().get('retURL'); 
	        param1  = ApexPages.currentPage().getParameters().get('CF00N80000004kQjV');
	        param2  = ApexPages.currentPage().getParameters().get('CF00N80000004kQjV_lkid');
	        param3  = ApexPages.currentPage().getParameters().get('CF00N80000004kQja');
	        param4  = ApexPages.currentPage().getParameters().get('CF00N80000004kQja_lkid');     
	        leadassignmentRuleObj =(Lead_Assignment_Rules__c) controller.getRecord();  
    	} catch(Exception ex) {}
    }
    
    public void searchAndfind() {       
 	}    
 	
 	/*public PageReference cancel() {
 	return new ApexPages.StandardController(leadassignmentRuleObj).view();}*/
    
	public PageReference redirectTOLARCall() {       
        PageReference leadPage = new PageReference('/a0E/e');
        leadPage.getParameters().put('nooverride','1');
        if(!String.isBlank(param1)) {
            leadPage.getParameters().put('CF00N80000004kQjV',param1);
        }
        if(!String.isBlank(param2)) {
            leadPage.getParameters().put('CF00N80000004kQjV_lkid',param2);
        }
        if(!String.isBlank(param3)) {
            leadPage.getParameters().put('CF00N80000004kQja',param3);
        }
        if(!String.isBlank(param4)) {
            leadPage.getParameters().put('CF00N80000004kQja_lkid',param4);
        }        
     	if(!String.isBlank(rtnUrl)) {
            leadPage.getParameters().put('retURL',rtnUrl);
        }
        leadPage.setRedirect(true);
        return leadPage;
    } 
	
	public PageReference redirectTORTNCall() {
      	try {
      		 PageReference leadPage;
	  	 	 if(!string.isBlank(rtnUrl)) {
	  	 	 	leadPage = new PageReference(rtnUrl);
	  	 	 } else {
	  	 	 	leadPage = new PageReference('/apex/CustomTabs?tabname=name3');
	  	 	 }
	  	 	 leadPage.setRedirect(true);
	      	 return leadPage;
      	} catch(Exception ex) {}
      	 return null;
   } 
   
   /* public void closePopup() {
        displayPopup = false; }*/
        
   public pagereference showPopup() {
        displayPopup = true;      
        return null;
   }
}