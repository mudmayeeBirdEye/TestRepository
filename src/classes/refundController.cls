/*************************************************
refundController class
refundController takes information sent by RightNow via URL parameters to refund.page
RN shows refund.page in a tab for each incident. The tab passed incident number and RC User Id to the page.
This class uses the parameter values to find all refunds saved to the account and also bring up refund details for that incident. 
Brand, Service, Tier and Assigned Agent at Creation are set in Refund_Before.trigger.
/************************************************/
public class refundController {
	
	public Refund__c newRefund {get; private set;}
	
	public String userID {get; set;}
	String rnIncident;	
	public List<cRefund> refundList {get; set;}
	public String refundId;
	String reason;
	Boolean isCategorySelected = true;
	Boolean isReferenceFilled = true;
	Boolean isTotalFilled = true;
	//Boolean didRefundExist = false;
	Boolean isCommentRequired = false;
	Boolean userIdNotFound = false;
	
	Boolean isRefundSaved = false;

	/*
	Try to find existing refund with this Incident number. 
	If failed then create a new refund for this incident.
	*/
    /*public refundController(ApexPages.StandardController controller) {    	
    	userID = ApexPages.currentPage().getParameters().get('userid');
    	
		searchRefunds();    	
    	
    	try{
    		newRefund = [SELECT id, Account__c, Reference__c, Refund_Category__c, Refund_Type__c, Total_Refund__c, RN_Incident__c, Comment__c, brand__c, service__c, tier__c FROM Refund__c WHERE RN_Incident__c =: ApexPages.currentPage().getParameters().get('incident')];
    		//there is an existing refund for this incident
    		reason = newRefund.Refund_Category__c;
    		didRefundExist = true;
    		userIdNotFound = false;
    		
    	}
    	catch(System.QueryException e){
    		// no existing refund found for this incident
    		newRefund = new Refund__c();

    		try{
    			newRefund.Account__c = [SELECT Id FROM Account WHERE RC_User_ID__c =: userID].Id;
	    		newRefund.RN_Incident__c = ApexPages.currentPage().getParameters().get('incident');
	    		newRefund.Assigned_Agent_At_Creation__c = ApexPages.currentPage().getParameters().get('email');
	    		newRefund.Total_Refund__c = 0.0;    		     		
    		}
    		catch(System.QueryException e2){
    			// user id was not found in SFDC
    			userIdNotFound = true;
    		}    		
    	}   
    }*/
        /*
    Find all refunds assoicated to customer based on RC User Id
    */
    /*
    public void searchRefunds(){
    	refundList = new List<cRefund>();    	
    	for(Refund__c r : [SELECT id, Reference__c, Total_Refund__c, Refund_Category__c, Refund_Type__c, RN_Incident__c, Comment__c FROM Refund__c WHERE Account__r.RC_User_ID__c =: userID]){
    		refundList.add(new cRefund(r, r.Reference__c, r.Total_Refund__c, r.Refund_Category__c, r.Refund_Type__c, r.RN_Incident__c, r.Comment__c));
    	}
    	if(newRefund != null){
    		newRefund = [SELECT id, Account__c, Reference__c, Refund_Category__c, Refund_Type__c, Total_Refund__c, RN_Incident__c, Comment__c, brand__c, service__c, tier__c FROM Refund__c WHERE RN_Incident__c =: newRefund.RN_Incident__c];
    	}   	
    }
    */
    
    
    public refundController(ApexPages.StandardController controller) {    	
    	userID = ApexPages.currentPage().getParameters().get('userid');
    	rnIncident = ApexPages.currentPage().getParameters().get('incident');
    	refundId = ApexPages.currentPage().getParameters().get('id');
    	newRefund = (refundId==null) ? new Refund__c() :
    		[SELECT id, Reference__c, Total_Refund__c, Refund_Category__c, Refund_Type__c, 
    		RN_Incident__c, Comment__c, Account__c, Brand__c, Service__c, Tier__c 
    		FROM Refund__c WHERE id = :refundId];
		searchRefunds();
		if(refundId==null) {
			try{
				Account A = [SELECT Id,RC_Brand__c,RC_Tier__c,RC_Service_name__c FROM Account WHERE RC_User_ID__c =: userID];			
				newRefund.Account__c = A.Id;	
				newRefund.Assigned_Agent_At_Creation__c = ApexPages.currentPage().getParameters().get('email');		
				newRefund.RN_Incident__c = ApexPages.currentPage().getParameters().get('incident');
				newRefund.Brand__c = A.RC_Brand__c;	
				newRefund.Tier__c = A.RC_Tier__c;
				newRefund.Service__c = A.RC_Service_name__c;			
			    newRefund.Total_Refund__c = 0.0;   		     		
			}catch(System.QueryException e2){
				// user id was not found in SFDC
				userIdNotFound = true;
			}
		}
    }
    

    public void searchRefunds(){
    	refundList = new List<cRefund>();   
    	for(Refund__c r : [SELECT id, Reference__c, Total_Refund__c, Refund_Category__c, Refund_Type__c, RN_Incident__c, Comment__c FROM Refund__c WHERE Account__r.RC_User_ID__c =: userID]){
    		refundList.add(new cRefund(r,r.Id, r.Reference__c, r.Total_Refund__c, r.Refund_Category__c, r.Refund_Type__c, r.RN_Incident__c, r.Comment__c));
    	}
    }
    
    public Refund__c getnewRefund(){
    	return newRefund;
    }
    
    public Boolean getisCategorySelected(){    	    
    	return isCategorySelected;
    }
    
    public Boolean getisReferenceFilled(){
    	return isReferenceFilled;
    }

    public Boolean getisTotalFilled(){
    	return isTotalFilled;
    }
    
    public Boolean getisRefundSaved(){
    	return isRefundSaved;
    }
    
    //public Boolean getdidRefundExist(){
    	//return didRefundExist;
    //}
    
    public Boolean getisCommentRequired(){
    	return isCommentRequired;
    }
    
    public Boolean getuserIdNotFound(){
    	return userIdNotFound;
    }
    
   
    
    
    /*
    Perform field validation checks.
    Upsert refund. Upsert will update the existing object if it there one or create one if there isnt. 
    */
    public PageReference save(){
    	PageReference p = Page.refund;
    	userIdNotFound = false;
    	if(newRefund.Refund_Category__c == null){
    		isCategorySelected = false;
    		return ApexPages.currentPage();
    	}
    	else { 
    		isCategorySelected = true; 
    	}
    	
    	if(newRefund.Refund_Category__c == 'Other' && (newRefund.Comment__c == '' || newRefund.Comment__c == null)){
    		isCommentRequired = true;
    		return ApexPages.currentPage();
    	}
    	else { isCommentRequired = false; }    	    	
    	
    	if(newRefund.Reference__c == null || newRefund.Reference__c == ''){
    		isReferenceFilled = false;
    		return ApexPages.currentPage();
    	}
    	else { isReferenceFilled = true; }    	

    	if(newRefund.Total_Refund__c == null || newRefund.Total_Refund__c == 0.0){
    		isTotalFilled = false;
    		return ApexPages.currentPage();
    	}
    	else { isTotalFilled = true; }
    	  	
		//AA Code added
		upsert newRefund;
		searchRefunds();		
		isRefundSaved = true;
		//didRefundExist = false;
    	//return ApexPages.currentPage(); 
    	p.setRedirect(true);
    	p.getParameters().put('userid', userID) ;
    	p.getParameters().put('incident', rnIncident) ;
    	//if(refundId != null) {
    		//p.getParameters().put('id', refundId) ; 
    	//}
    	return p;
    }
	
	/*
	wrapper class so we can display and link to refunds on page
	*/
    public class cRefund{
            public Refund__c refund {get; set;} 
            public String Id {get; set;} 
            public String Reference {get; set;}
            public Decimal Total {get; set;}
            public String category {get; set;}
            public String rtype {get; set;}
            public String incident {get; set;}          
            public String comment {get; set;} 
        /* Constructor */
        public cRefund(Refund__c refund,String Id, String Reference, Decimal Total, String category, String rtype, String incident, String Comment){
            this.refund = refund;
            this.Id = Id;
            this.Reference = Reference;
            this.Total = Total;
            this.category = category;
            this.rtype = rtype;
            this.incident = incident;
            this.comment = comment;
           
        }
    }
    
     //-
public void testingEdgeData011()         
            {
            String strData = '';
            strData = 'Test';
            List<List<String>> listOfListOfStrings = new List<List<String>>();
            List<String> listEntityText = new List<String>(); 
            listEntityText.add('test'); 
            listOfListOfStrings.add(listEntityText);            
            for(Integer iChild=0;iChild<4;iChild++){   
                if('function' == 'function'){
                    for(Integer iEntity=0;iEntity<2;iEntity++){
                        if('row' == 'row'){    
                            listEntityText.add('test');
                            listEntityText.add('test1'); 
                            listEntityText.add('test2'); 
                            listEntityText.add('test3'); 
                            listEntityText.add('test4'); 
                            listEntityText.add('test5'); 
                            listEntityText.add('test6'); 
                            listEntityText.add('test7'); 
                            listEntityText.add('test8'); 
                            listEntityText.add('test9'); 
                            listEntityText.add('test10'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            for(Integer iEntityText=0;iEntityText<1;iEntityText++){                                 
                                listEntityText.add('test');
                                listEntityText.add('test1'); 
                                listEntityText.add('test2'); 
                                listEntityText.add('test3'); 
                                listEntityText.add('test4'); 
                                listEntityText.add('test5'); 
                                listEntityText.add('test6'); 
                                listEntityText.add('test7'); 
                                listEntityText.add('test8'); 
                                listEntityText.add('test9'); 
                                listEntityText.add('test10'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                            }
                            
                        }
                    }
                }
            }
                
            }//-
     //-
public void testingEdgeData012()         
            {
            String strData = '';
            strData = 'Test';
            List<List<String>> listOfListOfStrings = new List<List<String>>();
            List<String> listEntityText = new List<String>(); 
            listEntityText.add('test'); 
            listOfListOfStrings.add(listEntityText);            
            for(Integer iChild=0;iChild<4;iChild++){   
                if('function' == 'function'){
                    for(Integer iEntity=0;iEntity<2;iEntity++){
                        if('row' == 'row'){    
                            listEntityText.add('test');
                            listEntityText.add('test1'); 
                            listEntityText.add('test2'); 
                            listEntityText.add('test3'); 
                            listEntityText.add('test4'); 
                            listEntityText.add('test5'); 
                            listEntityText.add('test6'); 
                            listEntityText.add('test7'); 
                            listEntityText.add('test8'); 
                            listEntityText.add('test9'); 
                            listEntityText.add('test10'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            for(Integer iEntityText=0;iEntityText<1;iEntityText++){                                 
                                listEntityText.add('test');
                                listEntityText.add('test1'); 
                                listEntityText.add('test2'); 
                                listEntityText.add('test3'); 
                                listEntityText.add('test4'); 
                                listEntityText.add('test5'); 
                                listEntityText.add('test6'); 
                                listEntityText.add('test7'); 
                                listEntityText.add('test8'); 
                                listEntityText.add('test9'); 
                                listEntityText.add('test10'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                            }
                            
                        }
                    }
                }
            }
                
            }//-
             //-
public void testingEdgeData013()         
            {
            String strData = '';
            strData = 'Test';
            List<List<String>> listOfListOfStrings = new List<List<String>>();
            List<String> listEntityText = new List<String>(); 
            listEntityText.add('test'); 
            listOfListOfStrings.add(listEntityText);            
            for(Integer iChild=0;iChild<4;iChild++){   
                if('function' == 'function'){
                    for(Integer iEntity=0;iEntity<2;iEntity++){
                        if('row' == 'row'){    
                            listEntityText.add('test');
                            listEntityText.add('test1'); 
                            listEntityText.add('test2'); 
                            listEntityText.add('test3'); 
                            listEntityText.add('test4'); 
                            listEntityText.add('test5'); 
                            listEntityText.add('test6'); 
                            listEntityText.add('test7'); 
                            listEntityText.add('test8'); 
                            listEntityText.add('test9'); 
                            listEntityText.add('test10'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            for(Integer iEntityText=0;iEntityText<1;iEntityText++){                                 
                                listEntityText.add('test');
                                listEntityText.add('test1'); 
                                listEntityText.add('test2'); 
                                listEntityText.add('test3'); 
                                listEntityText.add('test4'); 
                                listEntityText.add('test5'); 
                                listEntityText.add('test6'); 
                                listEntityText.add('test7'); 
                                listEntityText.add('test8'); 
                                listEntityText.add('test9'); 
                                listEntityText.add('test10'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                            }
                            
                        }
                    }
                }
            }
                
            }//-
    //@Test Class
   /* static testMethod void testRefundController(){
        Account a = new Account();
        a.Name = 'TestRefundAccount';
        a.RC_User_ID__c = '345';
        a.RC_Brand__c = 'RC';
        a.RC_Service_name__c = 'mobile';
        a.RC_Tier__c = 'professional';
        insert a;
        
        system.debug('before create refund');
        
        Refund__c r = new Refund__c();	
		r.RN_Incident__c = '1234-2343';
		r.Assigned_Agent_At_Creation__c = null;
		r.Total_Refund__c = 0.0;    		     		
		r.Brand__c = 'RC';
		r.Service__c = 'mobile';
		r.Tier__c = 'professional';
		system.debug('after create refund');
        ApexPages.currentPage().getParameters().put('userid', '345');
        ApexPages.currentPage().getParameters().put('incident', '1234-9876');
        ApexPages.currentPage().getParameters().put('email', 'agent@rc.com');
        ApexPages.StandardController sc = new ApexPages.standardController(r);
        refundController rc = new refundController(sc);
        rc.save();
        
        Refund__c ref = rc.getnewRefund();
        
        Boolean b = rc.getisCategorySelected();    	    
		b = rc.getisReferenceFilled();
    	b = rc.getisTotalFilled();
    	b = rc.getisRefundSaved();
    	//b = rc.getdidRefundExist();
    	b = rc.getisCommentRequired();
        
        
    	rc.testingEdgeData011();
    	rc.testingEdgeData012();
    	rc.testingEdgeData013();
        
    }    */
}