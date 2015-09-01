/*************************************************
RCContractDetails class
RCContractDetails along with RCContractDetails.page and RCContractTerms (.cls/.page) help users create send and save customer contracts
Takes contact data of Contact related to the Opportunity it is launched from for the contract.
Takes contact data of current user to use as agent data (email, phone)
Compeltes job when it passes all data to RCContractTerms. 
/************************************************/
public class RCContractDetails {

    Opportunity opportunity;
    Contract contract; 
    Contact contact = new Contact();
    String strEmail;
    String strName;
    String strPrice;
    String strOperatorEmail;
    String strOperatorFax;

    User activeUser;
    
    Boolean fillFieldError;
    Boolean ContactError;
    Boolean NumLinesError;
    Boolean ContactEmailError;
    
    String[] term = new String[]{};
    
    public String[] getTerm(){
    	return term;
    }
    
    public void setTerm(String[] term){
    	this.term = term;
    }
    // term options for contract
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('12','12'));
        options.add(new SelectOption('24','24'));
        options.add(new SelectOption('36','36'));
        return options;
    }
    
    /*
    Find information from Opportunities Contact and SFDC User. 
    If no contact can be found alert user
    */
    public RCContractDetails(ApexPages.StandardController controller) {
    	fillFieldError = false;
    	NumLinesError = false;
    	ContactEmailError = false;
        String userNm = UserInfo.getUserId();
        activeUser = [Select Email, Fax From User where id = :userNm ];
    	strOperatorFax = activeUser.Fax;    
    	strOperatorEmail = activeUser.Email;
    	
        system.debug('THIS IS OPPID: ' + ApexPages.currentPage().getParameters().get('id'));       
        opportunity = [select id,AccountId from Opportunity where id =:ApexPages.currentPage().getParameters().get('id')];
        
        contract = new Contract();      
                
        if(opportunity!=null){
        	try{
				OpportunityContactRole ocr = [SELECT id,ContactId FROM OpportunityContactRole WHERE OpportunityId =: opportunity.Id LIMIT 1];      		
        		contact =[select id,Name,Email from Contact where Id =:ocr.ContactId];
             	strEmail = contact.Email;
             	strName = contact.Name;
             	ContactError = false;
             	if(strEmail == null || strEmail == ''){
             		ContactEmailError = true;
             	}
        	}
        	catch(System.QueryException e){
        		ContactError = true; 
        	}
        }
    }   
    
    public Boolean getContactEmailError(){
    	return ContactEmailError;
    }     
    
    public Boolean getContactError(){
    	return ContactError;
    }
    
    public Boolean getNumLinesError(){
    	return NumLinesError;
    }
    
    public String getStrEmail() {
        return strEmail;
    }
    
    public void setStrEmail(String strEmail) {
        this.strEmail= strEmail;
    }
    
    public String getStrName() {
        return strName;
    }
    
    public void setStrName(String strName) {
        this.strName= strName;
    }
    
    public String getAgentEmail()
    {
    	return strOperatorEmail;
    }
    
    public String getAgentFax()
    {
    	return strOperatorFax;
    }
    
    public void setAgentFax(String fax)
    {
    	strOperatorFax = fax;
    }         
       
    public Opportunity getOpportunity() {
        return opportunity;
    }
	
	public Contract getContract() {
        return contract;
    }      
    
    public User getUser(){
    	return activeUser;
    }
    
    public Boolean getFillError(){
    	return fillFieldError;
    }

	/*
	doSearch checks fields for business compliance and sends information to RCContractTerms via URL parameters
	The number of lines and price of lines is hardcoded because this version of contract was made for only one type of contract.
	*/
    public PageReference doSearch()
    {
    	if(contract.Total_Number_Of_Lines__c < 20.0){
    		NumLinesError=true;
    		return ApexPages.currentPage();
    	}    	
    	if(strOperatorFax == null || strOperatorFax == ''){
    		fillFieldError=true;
    		return ApexPages.currentPage();
    	}    	    	    	    	
    	
        PageReference pdf =  Page.RCContractTerms;
        //pdf.getParameters().put('startDate',contract.StartDate.format());
        pdf.getParameters().put('term',String.valueOf(contract.ContractTerm));
        try{
        	pdf.getParameters().put('years',String.valueOf(contract.ContractTerm / 12));
        }
        catch(System.Exception e){
        	
        } 
        
        pdf.getParameters().put('accountId',Opportunity.AccountId);
        pdf.getParameters().put('name',strName);
        pdf.getParameters().put('email',strEmail);
        pdf.getParameters().put('noOfLines',contract.Total_Number_Of_Lines__c.format());
        Decimal price = 19.99 * contract.Total_Number_Of_Lines__c;
        pdf.getParameters().put('price', String.valueOf(price));        
        pdf.getParameters().put('operatorEmail',strOperatorEmail);
        pdf.getParameters().put('operatorFax',strOperatorFax); 
        pdf.setRedirect(true);

        return pdf;
    }
    
    public void cancel(){
    	
    }
    
/*	static testMethod void testRCContract() {
		try{	
    	Account a = new Account(name='opportunity');
    	insert a;
    	Opportunity o = new Opportunity(name='opportunity',account=a,type='New Business',sales_model__c='Direct',CloseDate=Date.Today(), StageName=OpportunityHelper.defaultOpportunityStage);
    	insert o;
    	Contact c = new Contact(lastname='last2', account=a, email='email@rc.com', phone='7654568787');
    	insert c;
    	OpportunityContactRole ocr = new OpportunityContactRole(ContactId=c.Id, OpportunityId=o.Id);
    	insert ocr;
    	PageReference pr = new PageReference('/' + o.Id);
    	system.debug('THIS IS PR: ' + pr);
    	Test.setCurrentPage(pr);
    	ApexPages.currentPage().getParameters().put('id',o.Id);
    	ApexPages.StandardController sc = new ApexPages.standardController(o);
    	
    	RCContractDetails ui = new RCContractDetails(sc);
    	ui.getTerm();
    	String [] term = new String[]{'24'};
    	ui.setTerm(term);
    	List<SelectOption> options = ui.getItems();
    	
    	Boolean cError = ui.getContactError();
		Boolean nError = ui.getNumLinesError();
		ui.setStrEmail('jesse1@ringcentral.com');
		String sEmail = ui.getStrEmail();
    	ui.setStrName('string name');
        String sName = ui.getStrName();
	    String aEmail = ui.getAgentEmail();
	    String aFax = ui.getAgentFax();
	    ui.contract.Total_Number_Of_Lines__c = 19;
	    Opportunity gOpp = ui.getOpportunity();
	    Contract gCon = ui.getContract();
	    User gU = ui.getUser();
	    Boolean fError = ui.getFillError();
	    PageReference pf = ui.doSearch();
	    
	    ui.contract.Total_Number_Of_Lines__c = 25;
	    pf = ui.doSearch();
	    
        Test.setCurrentPage(pf);
        RCContractTerms ct = new RCContractTerms(sc);
        
        ApexPages.currentPage().getParameters().put('name','jesse test');
        ApexPages.currentPage().getParameters().put('email','jesse2@ringcentral.com');
        ApexPages.currentPage().getParameters().put('noOfLines','35');
        ApexPages.currentPage().getParameters().put('price','499.99');
        ApexPages.currentPage().getParameters().put('operatorEmail','jesse1@ringcentral.com'); 
        ApexPages.currentPage().getParameters().put('operatorFax','6549873214');
        ApexPages.currentPage().getParameters().put('accountId',a.Id);
        ApexPages.currentPage().getParameters().put('term','36');
        ApexPages.currentPage().getParameters().put('years','3');
        
        PageReference pf2 = ct.deliverAsPDF();
        
	    String sName2 = ct.getStrName();
	    String sEmail2 = ct.getStrEmail();
	    String sLines = ct.getStrNoLines();
	    String sPrince = ct.getStrPrice();
	    String sOpEmail = ct.getStrOperatorEmail();
	    String sOpFax = ct.getStrOperatorFax();
	    String sAccId = ct.getStrAccountId();
	    String sTerm = ct.getStrTerm();
	    String sYears = ct.getStrYears();
	    String cRender = ct.getChooserender();
        Boolean rButton = ct.getRenderButton();
        
        ApexPages.currentPage().getParameters().put('p','p');
        cRender = ct.getChooserender();
   	}catch(Exception e){} 
	}*/
}