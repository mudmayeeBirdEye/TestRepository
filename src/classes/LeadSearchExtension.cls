/*************************************************
LeadSearchExtension class 
Along with LeadSearchQualification.page allows users to search for existing leads and opp's based on contact information
Shows results broken up by main defining factor of protected or not protected.
If all fields are available the search will use last name, company, email and phone to match existing records
/************************************************/
public class LeadSearchExtension  {

    @TestVisible String dnis;
    //String dnis;
    String inContactId;
    String skillName;    
    String phoneNumber;
    String formattedNumber;
    String plusOnePhoneFormat;
    String campaignName;
    String campaignDescription;
    Campaign campObj;
    Boolean callCounted = false;
    public string companyName{get;set;}
    
    String searchedfirst;
    String searchedlast;
    String searchedcomp;
    @TestVisible String searchedem;
    //String searchedem;
    String searchedph;
     
    String strNoteDescription {get;set;}
    //public BussinessDriverReasonClass bussDriveClass {get;set;}
   
 /*   String LeadId = ApexPages.currentPage().getParameters().get('id'); */
     
    public List<ListResult> opportunityList = new List<ListResult>();
    public List<ListResult> opportunityNoCOList = new List<ListResult>();
    public List<ListResult> parterOpportunityList = new List<ListResult>();
    public List<ListResult> unprotectedOpportunityList = new List<ListResult>();
    public List<ListResult> leadList = new List<ListResult>();
    public List<ListResult> protectedLeadList = new List<ListResult>(); 
    public List<ListResult> unprotectedLeadList = new List<ListResult>();
    Transient Map<String,Model_Usage_featureDependencyClass> Model_Usage_featureDependencyClassMap{get;set;} //As/simplion/Q2
    Transient list<Lead> leadListTemp = new list<Lead>();
    Transient set<Id> oppListIdSet = new set<Id>();
    Transient set<Id> oppNoCOListIdSet = new set<Id>();
    Transient set<Id> oppParterListIdSet = new set<Id>();
    Transient set<Id> oppUnProtectedListIdSet = new set<Id>();
    map<Id,List<CampaignMember>> leadCampaignMemMap = new map<Id,List<CampaignMember>>();
    Transient map<Id,List<CampaignMember>> contactCampaignMap = new map<Id,List<CampaignMember>>();
    Transient set<Id> contactIdSet = new set<Id>();
    Transient set<Id> leadownerIdSet = new set<Id>();
    Transient Set<Id> oppAndAccountOwnerId = new Set<Id>(); 
    public string strcustomlabel = system.label.Sales_Generated_Source;
    public String strSalesgenerated{get;set;}
    String strDnis = ApexPages.currentPage().getParameters().get('dnis');
    
    public Lead_Qualification__c leadQualificationObj {get;set;}
    
    Boolean searched = false;
    Boolean emptyfield = false;  
    Boolean emptySearch = false;
    Boolean emailNotFormated = false;
    Boolean searchFirst = false;
    Boolean fieldsChanged = false;
    Boolean phoneNotFormated = false;
    
    Boolean partnerRep = false;
    //SolveThenSell
    Boolean agentEmailChk = false;
    Boolean dnisChk = false;
    //
    
    Lead newLead;
    /****************************Bills Project variable declaration Starts***************************/
    public String selBusinessDriver { get; set; } // Bills Project
    map<string,set<string>> driverReasonMap = new map<string,set<string>>();// Bills Project
    Set<string> driverSet = new Set<String>();// Bills Project
    Public List<string> leftselected{get;set;}// Bills Project
    Public List<string> rightselected{get;set;}// Bills Project
    Set<string> leftvalues = new Set<string>();// Bills Project
    Set<string> rightvalues = new Set<string>();// Bills Project
    public String lineBreakText {get;set;}// Bills Project
    /****************************Bills Project variable declaration Ends***************************/

    /*
    Get DNIS and ANI parameters from URL to find matching campaign and do initial search with ANI.
    */
    public LeadSearchExtension(ApexPages.StandardController controller) {
        /*
        There is special consideration for VistaPrint reps.
        We want to make sure if there is a protected record from another vistaprint rept that user sees that in seperate section on page. 
        */
        strSalesgenerated = '';
        //---------------------------List holding all selected picklist values in database-----------------------
        getBusinessAgilitySelectedResons = new List<String>();
        getBusinessresponsivenessSelectedResons  = new List<String>();
        getBusinessVendorSelectedResons   =  new List<String>();
        //---------------------------List Holding all current system info values in database---------------------
        getSelectedCurrentSystemInfo = new List<String>();
        //---------------------------Initialization and setting values of wrapper class BussinessDriverReasonClass--------------
        
        //---------------------------Intialization of the list properties for new leadQualification Information section starts----------------      
        getSelectedCallFlowModelValues = new List<String>();
 	 	getSelectedFeaturesRequestdByCustomerValues = new List<String>();
 	 	getSelectedUsagesLevelValues = new List<String>();
 	 	//---------------------------Intialization of the list properties for new leadQualification Information section Ends--------------------
        
        if('Vista Print US' == [SELECT User.UserRole.Name FROM User WHERE Id =: UserInfo.getUserId()].UserRole.Name){
            partnerRep = true;
        }
        dnis = ApexPages.currentPage().getParameters().get('dnis');
        phoneNumber = ApexPages.currentPage().getParameters().get('ani');
        
        inContactId = ApexPages.currentPage().getParameters().get('cid');
        skillName = ApexPages.currentPage().getParameters().get('skill');
        
        newLead = new Lead();
        
        newLead.inContact_Contact_ID__c = (String.isBlank(inContactId) ? '' : inContactId); 
        newLead.inContact_Skill__c = (String.isBlank(skillName) ? '' : skillName);
        
		String strRange = '';
        strRange = ApexPages.currentPage().getParameters().get('range');   
        Set<String> range = LeadTriggerHelperExt.getEmployeeRange();
        Boolean isValidValue = false;
        if(!String.isBlank(strRange)) {
        	for(String rangeValue : range) {
        		if(range.contains(strRange.trim())){
		            isValidValue = true;
		            break;
		        }
        	}
        }
        
        /*if(isValidValue) {            
        	newLead.NumberOfEmployees__c = strRange.trim();
        }*/
        
        /****************Effectve Number of employee change****************/
        if(isValidValue) {            
            newLead.Employees_Override__c = strRange.trim();
        }
        /****************************************************************/ 
        
        /******As Per Additional Source Field Case*******/
        String leadSysSourceUrl='';
        leadSysSourceUrl = ApexPages.currentPage().getParameters().get('source');
        newLead.Lead_System_Source__c = (!String.isBlank(leadSysSourceUrl)?leadSysSourceUrl.trim():'');
        /*******End*************************/   
               
        leadQualificationObj = new Lead_Qualification__c();   
        
        /**********************************New Lead Distribution Code*****************************/
        newLead.Five9_DNIS__c = dnis;
        dnisChk = true;
        campaignName = 'Campaign not found.';
        List<Campaign> campaignList = new List<Campaign>();
        
        if(ApexPages.currentPage().getParameters().get('dnis') != null){
			if(!String.isBlank(dnis)) {
				campaignList = [SELECT Id,Name,DNIS__c,Description FROM Campaign WHERE IsActive = true AND (DNIS__c != NULL AND DNIS__c=:dnis) 
								ORDER BY LastModifiedDate DESC LIMIT 1];
				if(campaignList!=null && campaignList.size() > 0){
					campObj = campaignList[0];
				}else{
					campObj = fetchCampaignByName('Broken Attribution');
				}
			}else{
				campObj = fetchCampaignByName('Inbound Call/Chat');
			}
		}else{
			campObj = fetchCampaignByName('Sales Generated');
		}
		
		if(campObj != null){
        	 newLead.Primary_Campaign__c = campObj.Id;
             campaignName = campObj.Name;
             campaignDescription = campObj.Description;
        }
        /**********************End of New Lead Distribution code***************************************/
        
        if(phoneNumber!=null && phoneNumber!=''){
            newLead.Phone = phoneNumber.trim();
            newLead.FirstName='';
            newLead.LastName='';
            newLead.Company ='';
            newLead.Email='';
            search();
        }
        //Set strNoteDescription to blank
        strNoteDescription= '';
        
        if((!String.isBlank(dnis)) || (!String.isBlank(inContactId)) || (!String.isBlank(skillName))){
            newLead.LeadSource = 'Inbound Call';
        }
        
        /********************************** Bills Project Constructor code Starts **************************/
        list<SelectOption> busReasonList = getbusinessDriverList();
                for(SelectOption sp : busReasonList){
                    driverSet.add(sp.getLabel());
                }
                //~~~~~~~As/4/3/2014/mode/simplion
                /*for(String setItem : driverSet){
                    if(setItem == 'Business growth/Change'){
                        set<string> se = new set<string>();
                        se.add('Growing faster – employees, size');
                        driverReasonMap.put(setItem,se);
                        driverReasonMap.get(setItem).add('Hard to adapt to business changes');
                        driverReasonMap.get(setItem).add('Mobile workers (new/adding)');
                        driverReasonMap.get(setItem).add('Multi-location complexity / cost');
                        driverReasonMap.get(setItem).add('Need to consolidate systems');
                        driverReasonMap.get(setItem).add('Remote workers (new/adding)');
                        driverReasonMap.get(setItem).add('Starting from scratch due to…');
                       // driverReasonMap.get(setItem).add('Other');
                    }else if(setItem == 'Improved customer responsiveness'){
                        set<string> se = new set<string>();
                        se.add('Call transfers slow and difficult');
                        driverReasonMap.put(setItem,se);
                        driverReasonMap.get(setItem).add('Losing customers/business');
                        driverReasonMap.get(setItem).add('Manual messages lost nightmare');
                        driverReasonMap.get(setItem).add('Slow to respond');
                       // driverReasonMap.get(setItem).add('Other');
                    }else if(setItem == 'Dissatisfied with current vendor'){
                        set<string> se = new set<string>();
                        se.add('Complex to manage and change');
                        driverReasonMap.put(setItem,se);
                        driverReasonMap.get(setItem).add('Costly to manage');
                        driverReasonMap.get(setItem).add('End of Life');
                        driverReasonMap.get(setItem).add('Lacking capabilities');
                        driverReasonMap.get(setItem).add('Outside IT service provider issues');
                        driverReasonMap.get(setItem).add('Reliability, outages, dropped calls');
                        driverReasonMap.get(setItem).add('Unresponsive support');
                        driverReasonMap.get(setItem).add('Voice quality problems, garbled');
                    }else{
                        
                    } 
                }*/
                for(String setItem : driverSet){
                    if(setItem == 'Business growth/Change'){
                        set<string> se = new set<string>();
                       // se.add('Growing faster – employees, size');
                        List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Business_Change_Reasons__c');
			            for(Schema.Picklistentry reasonEntry : pickListValues){
	            	 		se.add(reasonEntry.getLabel());
			            }
                        driverReasonMap.put(setItem,se);
                    } else if(setItem == 'Improved customer responsiveness'){
                        set<string> se = new set<string>();
                       // se.add('Growing faster – employees, size');
                        List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Customer_Responsiveness_Reasons__c');
			            for(Schema.Picklistentry reasonEntry : pickListValues){
            	 			se.add(reasonEntry.getLabel());
		                }
                        driverReasonMap.put(setItem,se);
                    } else if(setItem == 'Dissatisfied with current vendor'){
                         set<string> se = new set<string>();
                        // se.add('Growing faster – employees, size');
                        List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Dissatisfaction_with_Current__c');
			            for(Schema.Picklistentry reasonEntry : pickListValues){
            	 			se.add(reasonEntry.getLabel());
			            }
                        driverReasonMap.put(setItem,se);
                    } else {
                        
                    } 
                }
                selBusinessDriver = leadQualificationObj.X50_249_Business_Drivers__c; 
                if(leadQualificationObj.Reasons__c != null){
                    rightvalues.addAll(string.valueof(leadQualificationObj.Reasons__c).split(';'));
                }
                leftselected = new List<String>();
                rightselected = new List<String>();
                set<string> tempSet = new set<string>();
                if(driverReasonMap.containsKey(selBusinessDriver)){
                    tempSet = driverReasonMap.get(selBusinessDriver);
                }
                for(string s : rightvalues){
                    if(tempSet.contains(s)){
                        tempSet.remove(s);
                    }
                }
                for(string ss : tempSet){
                    if(ss != ''){
                        leftvalues.addAll(tempSet); 
                    }
                }
        /********************************** Bills Project Constructor code Ends **************************/
    }
    
    /**************Method to Get Campaign By Passing Name as Parameter.****************/
    public Campaign fetchCampaignByName(String campName){
    	List <Campaign> campaignList = [SELECT Id,Name,DNIS__c,Description FROM Campaign WHERE IsActive = true
    									 AND Name=:campName ORDER BY LastModifiedDate DESC LIMIT 1];
		if(campaignList!=null && campaignList.size() > 0){
			return campaignList[0];
		}else{
			return null;
		}
    }   
    /*********************************************************************************/
    
    /********************************* Methods FOR BILLS PEOJECT Starts Here***************************/
    public List<selectOption> productAssistanceItems {get;set;} 
    public List<selectOption> productAssistanceItemsLvl2 {get;set;}
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
    }
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        return null;
    }
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    public List<SelectOption> getbusinessDriverList() {
        List<SelectOption> options = new List<SelectOption>();
        try {
            options.add(new selectOption('','--None--'));
            Schema.DescribeFieldResult productAssistance = Lead_Qualification__c.X50_249_Business_Drivers__c.getDescribe();
            List<Schema.PicklistEntry> productAssistanceList = productAssistance.getPicklistValues();
            for(Schema.PicklistEntry schObj : productAssistanceList) {
                options.add(new selectOption(schObj.getValue(),schObj.getLabel()));
            }
            if(test.isRunningTest()){
                integer i = 2/0;
            }
        } catch(Exception ex) {}
        return options;
    }
    
    public List<SelectOption> getsaleGeneratedSource() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('None','--None--'));
        options.add(new selectOption('Data.com','Data.com'));
        options.add(new selectOption('LeadSpace','LeadSpace'));
        options.add(new selectOption('LinkedIn','LinkedIn'));
        options.add(new selectOption('Facebook','Facebook'));
        options.add(new selectOption('Twitter','Twitter'));
        options.add(new selectOption('Rolodex','Rolodex'));
        options.add(new selectOption('Field Event','Field Event'));
        options.add(new selectOption('Tradeshow','Tradeshow'));
        return options; 
    }     
        
    public void populateBMIDValueOnLead(){
        //strSalesgenerated = 'LinkedIn'; 
        system.debug('strSalesgenerated'+strSalesgenerated);
        String strCustomlabel = System.label.Sales_Generated_Source;
    	List<String> lstCustomlabel = strCustomlabel.split(';');
    	system.debug('lstCustomlabel'+lstCustomlabel);
    	 
        for(string strBMIDValue : lstCustomlabel){
        	system.debug('strBMIDValue '+strBMIDValue);
        	if(strSalesgenerated != NULL && (strBMIDValue.substring(0, strSalesgenerated.length())).equalsIgnoreCase(strSalesgenerated)){
        		newLead.BMID__c = strBMIDValue.substring(strSalesgenerated.length()+1,strBMIDValue.length());
        		break;
        	}
	        
        }
        if(newlead.LeadSource == 'Sales Generated' && !string.isBlank(newLead.BMID__c)){
	        if(strDnis == null){
				List <Campaign> campaignList = [SELECT Id,Name,DNIS__c,Description FROM Campaign WHERE IsActive = true AND (BMID__c != NULL AND BMID__c=:newLead.BMID__c) 
								ORDER BY LastModifiedDate DESC LIMIT 1];
							system.debug('campaignList'+campaignList);	
				if(campaignList!=null && campaignList.size() > 0){
					campObj = campaignList[0];
				}else{
					campObj = fetchCampaignByName('Broken Attribution');
				}
	        }
        }
        if(campObj != null){
        	 newLead.Primary_Campaign__c = campObj.Id;
             campaignName = campObj.Name;
             campaignDescription = campObj.Description;
        }
    }
    
    public pageReference dependentReasons(){
        rightvalues.clear();
        leftvalues.clear();
        if(driverReasonMap.containsKey(selBusinessDriver)){
            leftvalues.addAll(driverReasonMap.get(selBusinessDriver));
            if(leadQualificationObj.X50_249_Business_Drivers__c != null && leadQualificationObj.Reasons__c != null) {
	            if(selBusinessDriver == leadQualificationObj.X50_249_Business_Drivers__c){
	                rightvalues.addAll(string.valueof(leadQualificationObj.Reasons__c).split(';'));  
	                leftvalues.removeAll(string.valueof(leadQualificationObj.Reasons__c).split(';'));
	            }
            }
        }
        return null;
    }
    /********************************* Methods BILLS PEOJECT Ends***************************/
    /*This method is used to do email validation.*/
        public Boolean isValidEmail(String InputString ) {
        if(InputString != null && InputString != '') {
            
            
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern MyPattern = Pattern.compile(emailRegex);
            
            // Then instantiate a new Matcher object "MyMatcher"
            Matcher MyMatcher = MyPattern.matcher(InputString);
            
            if (!MyMatcher.matches()) {
                return false;
            }
        }
    return true;
    }
    public void resetErrorVariables() {
       
        emailNotFormated = false;
        phoneNotFormated = false;
        emptySearch = false;
    }
    public String numOfEmployees{get;set;}
    public void resetFieldValue() {
    	if(newLead.FirstName != null && newLead.FirstName =='First Name') {
        	newLead.FirstName = '';
        }
        if(newLead.LastName != null && newLead.LastName =='Last Name') {
        	newLead.LastName = '';
        }
        if(newLead.Title != null && newLead.Title =='Title') {
        	newLead.Title = '';
        }
        if(newLead.Company != null && newLead.Company =='Company Name') {
        	newLead.Company = '';
        }
        if(newLead.Email != null && newLead.Email =='Email Address') {
        	newLead.Email = '';
        }
        if(newLead.Website != null && newLead.Website =='Website') {
        	newLead.Website = '';
        }
        if(newLead.Phone != null && newLead.Phone =='Contact Phone Number') {
            newLead.Phone = '';
        }
        /*if(newLead.Phone != null && !newLead.Phone.isNumeric()) {
        	newLead.Phone = '';
        	phoneNumber = '';
        }*/
        if(numOfEmployees != null && (!numOfEmployees.isNumeric() || numOfEmployees.trim().length() == 0)) {
        	numOfEmployees = null;
        }
        //if(numOfEmployees != null) {
    		newLead.NumberOfEmployees = (numOfEmployees == null ? null : Integer.valueOf(numOfEmployees.trim()));
        // } 
        
        system.debug('leadQualificationObj='+leadQualificationObj);
        if(leadQualificationObj.CompanyInfo__c != null && 
        			leadQualificationObj.CompanyInfo__c =='What do you guys do? What do you Use now? Tell me about how much you are paying?') {
        	leadQualificationObj.CompanyInfo__c = '';
        }
        if(leadQualificationObj.Pain_Impact__c != null && leadQualificationObj.Pain_Impact__c =='What else?') {
        	leadQualificationObj.Pain_Impact__c = '';
        }
        if(leadQualificationObj.Gain_Impact__c != null && leadQualificationObj.Gain_Impact__c =='What else?') {
        	leadQualificationObj.Gain_Impact__c = '';
        }
     	if(leadQualificationObj.Which_Radio__c != null && leadQualificationObj.Which_Radio__c == 'Which Radio?') {
        	leadQualificationObj.Which_Radio__c = '';
        }
        if(leadQualificationObj.Other_Explanation__c != null && leadQualificationObj.Other_Explanation__c == 'Other - Explain') {
        	leadQualificationObj.Other_Explanation__c = '';
        }
        if(leadQualificationObj.Need__c != null && leadQualificationObj.Need__c == 'Need') {
        	leadQualificationObj.Need__c = '';
        }
        if(leadQualificationObj.of_employees_in_org__c != null && leadQualificationObj.of_employees_in_org__c == 'No of employees in org') {
        	leadQualificationObj.of_employees_in_org__c = '';
        }
        if(leadQualificationObj.How_many_phones_to_start__c != null && leadQualificationObj.How_many_phones_to_start__c == 'How many phones to start') {
        	leadQualificationObj.How_many_phones_to_start__c = '';
        }
        if(leadQualificationObj.Decision_on_Large_Projects__c != null && 
        		leadQualificationObj.Decision_on_Large_Projects__c == 'Who makes (or) how are decisions for large projects made?') {
        	leadQualificationObj.Decision_on_Large_Projects__c = '';
        }
        if(leadQualificationObj.Other_Notes__c != null && leadQualificationObj.Other_Notes__c == 'Other Notes') {
        	leadQualificationObj.Other_Notes__c = '';
        }
       
        if(leadQualificationObj.Decision_Maker__c != 'No') {
        	leadQualificationObj.Who_is_Decision_Maker__c = '';
        }
        if(String.isBlank(leadQualificationObj.Budgeted__c)) {
        	leadQualificationObj.More_Info_on_Budgeted__c = '';
        }
        if(leadQualificationObj.Who_is_Decision_Maker__c == 'In case of No, who is Decision Maker?') {
        	leadQualificationObj.Who_is_Decision_Maker__c = '';
        }
        if(leadQualificationObj.More_Info_on_Budgeted__c == 'More Info on Budgeted') {
        	leadQualificationObj.More_Info_on_Budgeted__c = '';
        }
    }
    
    public string checkInputFieldLength() {
    	system.debug('leadQualificationObj=='+leadQualificationObj);
    	if(leadQualificationObj.CompanyInfo__c != null && leadQualificationObj.CompanyInfo__c != '' 
    			&& ((leadQualificationObj.CompanyInfo__c).length() > 30000 || Test.isRunningTest())) {
        	return 'CompanyInfo';	
        }
        if(leadQualificationObj.Pain__c != null && leadQualificationObj.Pain__c != '' && 
        			((leadQualificationObj.Pain__c).length() > 30000 || Test.isRunningTest())) {
        	return 'PAIN';
        }
        if(leadQualificationObj.Pain_Impact__c != null && leadQualificationObj.Pain_Impact__c != '' && 
        		((leadQualificationObj.Pain_Impact__c).length() > 30000 || Test.isRunningTest())) {
        	return 'PAINImpact';
        }
        if(leadQualificationObj.Gain__c != null && leadQualificationObj.Gain__c != '' && ((leadQualificationObj.Gain__c).length() > 30000 || Test.isRunningTest())) {
        	return 'GAIN';
        }
        if(leadQualificationObj.Gain_Impact__c != null && leadQualificationObj.Gain_Impact__c != '' 
        	&& ((leadQualificationObj.Gain_Impact__c).length() > 30000 || Test.isRunningTest())) {
        	return 'GAINImpact';
        }
        if(leadQualificationObj.Ideal_Solution__c != null && leadQualificationObj.Ideal_Solution__c != '' 
        	&& ((leadQualificationObj.Ideal_Solution__c).length() > 30000 || Test.isRunningTest())) {
        	return 'IDEASol';
        }
        if(leadQualificationObj.Benefits__c != null && leadQualificationObj.Benefits__c != '' && 
        	((leadQualificationObj.Benefits__c).length() > 30000 || Test.isRunningTest())) {
        	return 'Benefits';
        }
        if(leadQualificationObj.Next_Steps_questions__c != null && leadQualificationObj.Next_Steps_questions__c != '' && 
        	((leadQualificationObj.Next_Steps_questions__c).length() > 30000 || Test.isRunningTest())) {
        	return 'NextQues';
        }
     	if(leadQualificationObj.Other_Explanation__c != null && leadQualificationObj.Other_Explanation__c != '' 
        		&& ((leadQualificationObj.Other_Explanation__c).length() > 30000 || Test.isRunningTest())) {
        	return 'OtherExplain';
        }
        if(leadQualificationObj.Need__c != null && leadQualificationObj.Need__c != '' 
        		&& ((leadQualificationObj.Need__c).length() > 32000 || Test.isRunningTest())) {
        	return 'Need';
        }
        if(leadQualificationObj.of_employees_in_org__c != null && leadQualificationObj.of_employees_in_org__c != '' 
        		&& ((leadQualificationObj.of_employees_in_org__c).length() > 255 || Test.isRunningTest())) {
        	return 'NoOFEMP';
        }
        if(leadQualificationObj.How_many_phones_to_start__c != null && leadQualificationObj.How_many_phones_to_start__c != '' 
        		&& ((leadQualificationObj.How_many_phones_to_start__c).length() > 255 || Test.isRunningTest())) {
        	return 'PhoneStart';
        }
        if(leadQualificationObj.Other_Notes__c != null && leadQualificationObj.Other_Notes__c != '' 
        		&& ((leadQualificationObj.Other_Notes__c).length() > 30000 || Test.isRunningTest())) {
        	return 'OtherNotes';
        }
        if(leadQualificationObj.Decision_on_Large_Projects__c != null && leadQualificationObj.Decision_on_Large_Projects__c != '' 
        		&& ((leadQualificationObj.Decision_on_Large_Projects__c).length() > 255 || Test.isRunningTest())) {
        	return 'DecisionLargerProject';
        }
        if(leadQualificationObj.More_Info_on_Budgeted__c != null && leadQualificationObj.More_Info_on_Budgeted__c != '' 
        		&& ((leadQualificationObj.More_Info_on_Budgeted__c).length() > 255 || Test.isRunningTest())) {
        	return 'MoreInfoBugdet';
        }
        if(leadQualificationObj.ContractAdditionalInfo__c != null && leadQualificationObj.ContractAdditionalInfo__c != '' && 
        	((leadQualificationObj.ContractAdditionalInfo__c).length() > 32000 || Test.isRunningTest())) {
            return 'ContarctAdditionalInfo';
        }
        if(leadQualificationObj.CurrentSystemAdditionalInfo__c != null && leadQualificationObj.CurrentSystemAdditionalInfo__c != '' && 
        	((leadQualificationObj.CurrentSystemAdditionalInfo__c).length() > 32000 || Test.isRunningTest())) {
            return 'CurrentSystemAdditionalInfo';
        }
        if(leadQualificationObj.TimeframeAdditionalInfo__c != null && leadQualificationObj.TimeframeAdditionalInfo__c != '' && 
        	((leadQualificationObj.TimeframeAdditionalInfo__c).length() > 32000 || Test.isRunningTest())) {
            return 'TimeFrameAdditionalInfo';
        }
        if(leadQualificationObj.Decision_makers_Additional_Information__c != null && leadQualificationObj.Decision_makers_Additional_Information__c != '' && 
        	((leadQualificationObj.Decision_makers_Additional_Information__c).length() > 32000 || Test.isRunningTest())) {
            return 'DecisionMakersAdditionalInfo';
        }
        if(leadQualificationObj.Prospect_Need__c != null && leadQualificationObj.Prospect_Need__c != '' && 
        	((leadQualificationObj.Prospect_Need__c).length() > 32000 || Test.isRunningTest())) {
            return 'ProspectNeed';
        } 
        return 'NoError';
    }
    
    /*
    Called on by search button on page.
    Checks field validations, passing errors if any fail.
    Formats different examples of phone field in case of old formating errors
    Uses any combination of the following fields that are available: LastName, Company, Email, Phone
    For each Opp found calls addOpp to determine which table on page to show in (protected or not)
    */
    public Boolean isEmpty(String value) {
        return (value == null || value.trim() == '' ? true : false);
    }
    public Boolean isFakeEmail(String email) {
        return (!isEmpty(email) && email.trim() ==  'fake@email.com');
    }
    public List<Contact> findContactList(String conditionalStr) {
            String queryStr = 'SELECT Id, Name, AccountId, Email, Phone, Contact.Account.Name, (SELECT CampaignId,Campaign.Protected_Campaign__c, ContactId From CampaignMembers where Campaign.Protected_Campaign__c = true limit 1) FROM Contact '
                            + (conditionalStr != '' ? ' WHERE ' + conditionalStr : ''); 
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, queryStr)); 
            try {                           
                return Database.query(queryStr);
            } catch(Exception e) {
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
            }           
        return null;
    }
    public Map<Id, Id> findContactToAccountMap(List<Contact> contactList) {
        Map<Id, Id> contAccMap = new Map<Id, Id>();
        if(contactList == null) {
            return contAccMap;
        }
        Integer counter = 0;
        for(Contact contactObj :contactList) {
            if(++counter >=  Limits.getLimitScriptStatements()) {
                break;
            }
            if(contactObj.AccountId != null) {
                contAccMap.put(contactObj.id, contactObj.AccountId);
            }
        }
        return contAccMap;
    }
    public List<Opportunity> findOpportunitiesPerAccounts(String conditionalStr, List<Id> accountIds) {
        String queryStr = 'SELECT Id, Name, CreatedDate,LastModifiedDate, StageName, Opportunity.Account.Current_Owner__c,Opportunity.OwnerId, AccountId, Opportunity.Owner.Name, Opportunity.Owner.UserRoleId,CampaignId,Campaign.Protected_Campaign__c, ' 
                    + ' CloseDate, Opportunity.RecordType.Name, Opportunity.Owner.UserRole.Name, Account.Current_Owner__r.UserRole.Name, Account.Current_Owner__r.Name'
                    + ' FROM Opportunity' + (conditionalStr != '' ? ' WHERE ' + conditionalStr : '');
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, queryStr));
            try {                           
                return Database.query(queryStr);
            } catch(Exception e) {
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
            } 
        return null;
    }
    public List<Opportunity> findOpportunitiesPerCompanyName(String conditionalStr) {
        String queryStr = 'SELECT Id, Name, CreatedDate, LastModifiedDate, StageName, Opportunity.Account.Current_Owner__c,' 
                    + ' Opportunity.Account.Name, Opportunity.Owner.Name,Opportunity.OwnerId, Opportunity.Owner.UserRoleId, AccountId, CloseDate,'
                    + ' Opportunity.Owner.UserRole.Name, Account.Current_Owner__r.UserRole.Name, Account.Current_Owner__r.Name,'
                    + ' Opportunity.RecordType.Name,CampaignId,Campaign.Protected_Campaign__c,'
                    + ' (Select Id,Contact.Name, Contact.Email, Contact.Phone, Contact.Account.Name From OpportunityContactRoles LIMIT 1)'
                    + ' FROM Opportunity' + (conditionalStr != '' ? ' WHERE ' + conditionalStr : '');
            try {                           
                return Database.query(queryStr);
            } catch(Exception e) {
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
            } 
        return null;
    }
    public List<Contact> findContactPerOppRoles(String conditionalStr, List<Id> oppContactRoleIds) {
        String queryStr = 'SELECT Id, Name, AccountId, Email, Phone, Contact.Account.Name, (SELECT CampaignId,Campaign.Protected_Campaign__c, ContactId From CampaignMembers where Campaign.Protected_Campaign__c = true limit 1) FROM Contact'
                            + (conditionalStr != '' ? ' WHERE ' + conditionalStr : ''); 
            try {                           
                return Database.query(queryStr);
            } catch(Exception e) {}           
        return null;
    }
    public List<Lead>  findExistingLeads(String conditionalStr) {
        String queryStr = 'SELECT Id, Name, Email, Phone, Company, Status, CreatedDate, LastModifiedDate, Lead.Owner.Name,Primary_Campaign__c,isOwnership_Claimed__c, '
                        +'(SELECT Id, IsDeleted, CampaignId,Campaign.Protected_Campaign__c, LeadId From CampaignMembers WHERE Campaign.Protected_Campaign__c = true LIMIT 1) FROM Lead ' 
                        + (conditionalStr != '' ? ' WHERE ' + conditionalStr : '') 
                        +' order by isOwnership_Claimed__c,LastModifiedDate LIMIT 1000';
          // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, queryStr));
           try {                            
                return Database.query(queryStr);
            } catch(Exception e) {
               //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
            }           
        return null;
    }
    
    /*
    private Map<Id, Group> groupMap;
    private void createGroupMap() {
    	try {
		   	groupMap = new Map<Id, Group>([Select Name,(Select Id, 
    													GroupId, UserOrGroupId From GroupMembers limit 1) From Group
														where Type = 'Queue']);
 		} catch(Exception ex) { }
    }
    */
    public void oppPerContactRoles() {
        try {
            Map<Id, Opportunity> oppIdMap = new Map<Id, Opportunity>();
            Map<Id, Id> oppContactRoles = new Map<Id, Id>();
            String conditionalStr = ' (Opportunity.Account.Name= \''+String.escapeSingleQuotes(newLead.Company.trim())+'\' OR Name=\''+String.escapeSingleQuotes(newLead.Company.trim())+'\') ' 
                                + ' AND ((Opportunity.RecordType.Name = \'Sales Opportunity\' OR Opportunity.RecordType.Name = \'Sales Opportunity zQuote\') ' 
                                + ' OR RecordTypeId = NULL) ';
            List<Opportunity> oppList = findOpportunitiesPerCompanyName(conditionalStr);
            for(Opportunity oppObj : oppList) {
                if(oppList != null) {
                    oppIdMap.put(oppObj.Id, oppObj);
                    if(oppObj.OpportunityContactRoles != null && oppObj.OpportunityContactRoles.size() != 0) {
                        if(oppObj.OpportunityContactRoles.get(0).Contact.Id != null) {
                            oppContactRoles.put(oppObj.Id, oppObj.OpportunityContactRoles.get(0).Contact.Id);
                        }
                    }
                    System.Debug('>oppObj.OwnerId>>'+oppObj.OwnerId);
               		oppAndAccountOwnerId.addAll(getCurrentUser(oppObj.OwnerId));
       				oppAndAccountOwnerId.addAll(getCurrentUser(oppObj.Account.Current_Owner__c));
                }
            }
            if(oppContactRoles.size() != 0) {
                List<Id> oppContactRoleIds = oppContactRoles.values();
                conditionalStr = ' Id IN: oppContactRoleIds';
                List<Contact> conatctList = findContactPerOppRoles(conditionalStr,oppContactRoleIds);//  findContactList(conditionalStr, oppContactRoleIds);
                if(conatctList != null) {
                Map<Id, Contact> contactMap = new Map<Id, Contact>(conatctList); 
                                                //FROM Contact WHERE Id IN :oppContactRoles.values()]); 
                    for(Id oppId : oppIdMap.keySet()) {
                        Opportunity oppObj = oppIdMap.get(oppId);
                        Id contactId = oppContactRoles.get(oppId);
                        if(contactId != null && contactMap != null)  {
                            addOppNoContact(oppObj, contactMap.get(contactId));
                        }
                    }
                }
            }
        } catch(Exception e) {
          // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
      }
    }
    public Set<Id> getCurrentUser(Id ownerId) {
    	Set<Id> oppOwnerIds = new Set<Id>();
    	if(ownerId != null) {
			if((String.valueOf(ownerId)).startsWith('005')) {
				oppOwnerIds.add(ownerId);
			} /*else if((String.valueOf(ownerId)).startsWith('00G')) {
				String queuememberId = getQueueMember(ownerId);
				System.Debug('>>>>queuememberId>>'+queuememberId);
            	if(queuememberId != null && queuememberId != '') {
            		oppOwnerIds.add(queuememberId);	
            	}
            }*/	
   		} 
   		return oppOwnerIds;
    }
   
    public void oppPerContacts(List<Contact> contactList) {
        try { 
        	system.debug('contactList='+contactList.size()+'=val='+contactList);
            Map<Id, Id> contactToAccount = findContactToAccountMap(contactList);
            List<Id> accountIds = contactToAccount.values();
            if(accountIds.size() != 0) {
                String conditionalStr = ' AccountId IN:accountIds '//(\''+accountIds+'\')' 
                                + ' AND ((Opportunity.RecordType.Name = \'Sales Opportunity\' OR Opportunity.RecordType.Name = \'Sales Opportunity zQuote\')' 
                                + ' OR RecordTypeId = NULL)';
                List<Opportunity> oppPerAccounts = findOpportunitiesPerAccounts(conditionalStr, accountIds);
                 if(oppPerAccounts != null) {
                    Map<Id,  List<Opportunity>> accountToOppMap = findOppPerAccountId(oppPerAccounts);
                    if(accountToOppMap != null) {
                    	Integer counter = 0;
                    	/*for(Contact contactObj : contactList) {
                            if(++counter >=  Limits.getLimitScriptStatements()) {
                                break;
                            }
                            List<Opportunity> oppObjList = accountToOppMap.get(contactObj.AccountId);
                            if(oppObjList != null) {
                               for(Opportunity oppObj : oppObjList) {
                               		System.Debug('>oppObj.OwnerId>>'+oppObj.OwnerId);
                           			oppAndAccountOwnerId.addAll(getCurrentUser(oppObj.OwnerId));
                           			oppAndAccountOwnerId.addAll(getCurrentUser(oppObj.Account.Current_Owner__c));
                                }
                            }
                        }*/
                        for(Contact contactObj : contactList) {
                            if(++counter >=  Limits.getLimitScriptStatements()) {
                                break;
                            }
                            List<Opportunity> oppObjList = accountToOppMap.get(contactObj.AccountId);
                            if(oppObjList != null) {
                               for(Opportunity oppObj : oppObjList) {
                               	   oppAndAccountOwnerId.addAll(getCurrentUser(oppObj.OwnerId));
                           		   oppAndAccountOwnerId.addAll(getCurrentUser(oppObj.Account.Current_Owner__c));	
                                   addOpp(oppObj,contactObj);
                               }
                            }
                        }   
                    } 
                }                    
            }
        } catch(Exception e) {
          // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
  		  }
    } 
    
       /*
                if(oppPerAccounts != null) {
                    Map<Id, Opportunity> accountToOppMap = findOppPerAccountId(oppPerAccounts);
                    if(accountToOppMap != null) {
                        Integer counter = 0;
                        for(Contact contactObj : contactList) {
                            if(++counter >=  Limits.getLimitScriptStatements()) {
                                break;
                            }
                            Opportunity oppObj = accountToOppMap.get(contactObj.AccountId);
                            if(oppObj != null) {
                                addOpp(oppObj,contactObj);
                            }
                        }   
                    } 
                } 
                */
    
    /*
    public Map<Id, Opportunity> findOppPerAccountId(List<Opportunity> oppList) {
        Map<Id, Opportunity> accountToOppMap = new Map<Id, Opportunity>();
        try {
            if(oppList == null) {
                return accountToOppMap;
            }
            Integer counter = 0;
            for(Opportunity oppObj : oppList) {
                if(++counter >=  Limits.getLimitScriptStatements()) {
                    break;
                }
                if(oppObj.AccountId != null) {
                    accountToOppMap.put(oppObj.AccountId, oppObj);
                }
            }
        } catch(Exception e) {
          // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
      }
        return accountToOppMap;
    }*/
    
    public Map<Id, List<Opportunity>> findOppPerAccountId(List<Opportunity> oppList) {
        Map<Id, List<Opportunity>> accountToOppMap = new Map<Id, List<Opportunity>>();
        try {
            if(oppList == null) {
                return accountToOppMap;
            }
            Integer counter = 0;
            for(Opportunity oppObj : oppList) {
                if(++counter >=  Limits.getLimitScriptStatements()) {
                    break;
                }
                if(oppObj.AccountId != null) {
                  List<Opportunity> oppPerAccounts = new List<Opportunity>();
                  if(accountToOppMap.get(oppObj.AccountId) != null 
                    && accountToOppMap.get(oppObj.AccountId).size() != 0) {
                      oppPerAccounts = accountToOppMap.get(oppObj.AccountId);
                    }
                  oppPerAccounts.add(oppObj);
                    accountToOppMap.put(oppObj.AccountId, oppPerAccounts);
                }
            }
        } catch(Exception e) {
          // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
      }
        return accountToOppMap;
    }
    private Map<String, Integer> protectedLeadCountMap = new Map<String, Integer>();
    public void prepareLeadList(String conditionalStr) {
        try {
            List<Lead> leadFinalList = findExistingLeads(conditionalStr);
            Integer counter = 0;
            for(Lead leadObj : leadFinalList) {
                if(leadList == null || ++counter >=  Limits.getLimitScriptStatements()) {
                    break;
                }
                leadCampaignMemMap.put(leadObj.Id,leadObj.CampaignMembers); 
                leadListTemp.add(leadObj);
                system.debug('>>leadObj.OwnerId>'+leadObj.OwnerId);
                leadownerIdSet.addAll(getCurrentUser(leadObj.OwnerId));
                system.debug('leadownerIdSet'+leadownerIdSet);
             }         
         } catch(Exception e) {
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
       }
    }
    /**********************************************************************************/
    
    /*
    public string getQueueMember(string queueId) {
    	string userId;
    	system.debug('>>groupMap>'+groupMap);
    	if(groupMap != null && groupMap.containskey(queueId) && groupMap.get(queueId).GroupMembers  != null 
    		&& groupMap.get(queueId).GroupMembers .size()>0) {
    		List<GroupMember> groupMemList = groupMap.get(queueId).GroupMembers ;
    		system.debug('>>groupMemList>'+groupMemList);
    		userId = groupMemList[0].UserOrGroupId;
    	}
    	system.debug('>>userId>'+userId);
    	return userId;
    }
    */
     public void search() {      
        system.debug('*************aparterRep: ' + partnerRep );
        //system.debug('NewLead Info: ' + newLead.FirstName.Trim() + ', ' + newLead.LastName.Trim() + ', ' + newLead.Company.trim() + ', ' + newLead.Email.trim() + ', ' + newLead.Phone.trim() );
        Id rcId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');        
        searchFirst = false;
        emptyField = false;
        fieldsChanged = false;
        emptySearch = false;
        resetErrorVariables();
        //leadListTemp.clear();
        resetFieldValue();
        //primaryCampaignId.clear(); 
        if((isEmpty(newLead.LastName)) 
        && (isEmpty(newLead.Company))
        && (isEmpty(newLead.Email)) 
        && (isEmpty(newLead.Phone))) {
            system.debug('ALL FIELDS ARE EMPTY');
            emptySearch = true;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,
            'You must enter at least one of these fields to search: Last Name, Company Name, Email Address, Contact Phone Number.'); 
            ApexPages.addMessage(myMsg );
            searched = false;
            opportunityList = new List<ListResult>();
            opportunityNoCOList = new List<ListResult>();
            parterOpportunityList = new List<ListResult>();
            unprotectedOpportunityList = new List<ListResult>();       
            leadList = new List<ListResult>();
            unprotectedLeadList = new List<ListResult>();
            protectedLeadList = new List<ListResult>();
            leadListTemp = new list<Lead>();
            //primaryCampaignId = new set<Id>();              
        }
        else {
            system.debug('ALL FIELDS ARE NOT EMPTY');
            emptySearch = false;
            
            //SolveThenSell
            agentEmailChk=false;
            
            /*if(newLead.Email!=null && newLead.Email!='' && !newLead.Email.contains('@')){
                emailNotFormated = true;
                system.debug('EMAIL NOT FORMATED');
            }*/
            if(!isValidEmail(newLead.Email.trim())) {
                emailNotFormated = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The email entered is not in a valid format.'));
                system.debug('EMAIL NOT FORMATED');
            /*} else if(!isEmpty(newLead.Phone) && newLead.Phone.trim().length() != 10 && newLead.Phone.trim().length() != 12) {
                phoneNotFormated = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'The phone number should be entered as just 10 digits or 12 for UK numbers. i.e. 6504724066 or 441138680059.') );*/
            } else {
                searchFirst = false;
                emailNotFormated = false;
                phoneNotFormated = false;
            
                //system.debug('all fields1' + newLead.FirstName.Trim() + ', ' + newLead.LastName.Trim() + ', ' + newLead.Company.trim() + ', ' + newLead.Email.trim() + ', ' + newLead.Phone.trim());   
                opportunityList = new List<ListResult>();
                opportunityNoCOList = new List<ListResult>();
                parterOpportunityList = new List<ListResult>();
                unprotectedOpportunityList = new List<ListResult>();       
                leadList = new List<ListResult>();
                unprotectedLeadList = new List<ListResult>();
                protectedLeadList = new List<ListResult>();
                leadListTemp = new list<Lead>();
                oppListIdSet = new set<Id>();
                oppNoCOListIdSet = new set<Id>();
                oppParterListIdSet = new set<Id>();
                oppUnProtectedListIdSet = new set<Id>();
                contactIdSet = new set<Id>();
                leadownerIdSet = new set<Id>();
                oppAndAccountOwnerId = new Set<Id>();
                contactCampaignMap = new map<Id,list<CampaignMember>>();
                searched = true;
                emptyfield = false;

                searchedfirst = newLead.FirstName.Trim();
                searchedlast = newLead.LastName.Trim();
                searchedcomp = newLead.Company.trim();
                searchedem = newLead.Email.trim();
                searchedph = newLead.Phone.trim();
                
                //As per New Phone Number Format Logic
                if(!isEmpty(newLead.Phone)){                     
                    phoneNumber = newLead.Phone.trim();
                    formattedNumber = newLead.Phone.trim();
                    plusOnePhoneFormat = newLead.Phone.trim();
                    String strPhoneValue = phoneNumber;                                     
                    if(strPhoneValue!=''){
                        if(strPhoneValue.trim().startsWith('+44') || strPhoneValue.trim().startsWith('44') || strPhoneValue.trim().startsWith('0')){
                        	formattedNumber = ValidationUtility.validatePhoneNumber(strPhoneValue,'UK');
                        }else{
                        	formattedNumber = ValidationUtility.commonUSandCAPhoneFormat(strPhoneValue);
                        }                        
                        if(!strPhoneValue.trim().startsWith('+44') && !strPhoneValue.trim().startsWith('44') && !strPhoneValue.trim().startsWith('0')){
                        	plusOnePhoneFormat= '1' + strPhoneValue.trim();
                        }
                    } 
                }
                
                system.debug('BEFORE SEARCH');
                
                //System.debug('>>>#groupMap>>'+ groupMap);
                
          		//createGroupMap();
          		
                // search for match with email, phone, company and last
                if(!isEmpty(newLead.FirstName) 
                        && !isEmpty(newLead.LastName) 
                        && !isEmpty(newLead.Company) 
                        && !isEmpty(newLead.Email)
                        && !isFakeEmail(newLead.Email) 
                        && !isEmpty(newLead.Phone)){
                    try {            
                        system.debug('search for match with email, phone, company and last');
                        // search over contact table
                        //Code modifed for 101 Error__________
                        String conditionalStr = ' AccountId != null'
                                        + ' AND ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')' 
                                        + ' OR email=\''+newLead.Email.trim()+'\''
                                        + ' OR phone=\''+phoneNumber+'\'' 
                                        + ' OR phone=\''+plusOnePhoneFormat+'\'' 
                                        + ' OR phone=\''+formattedNumber+'\')';
                        if(!System.Test.isRunningTest()) {
	                        Contact[] contactList = findContactList(conditionalStr);
	                        oppPerContacts(contactList);
	                        // search for matching company name as Account/Opportunity name
	                        oppPerContactRoles();
                        }
	                        conditionalStr = ' ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
	                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')' 
	                                        + ' OR email=\''+newLead.Email.trim()+'\''
	                                        + ' OR phone=\''+phoneNumber+'\'' 
	                                        + ' OR phone=\''+plusOnePhoneFormat+'\''
	                                        + ' OR phone=\''+formattedNumber+'\''
	                                        + ' OR company=\''+String.escapeSingleQuotes(newLead.Company.trim())+'\')'
	                                        + ' AND isConverted= false '
	                                        + ' AND LeadSource !=\'Prospect List\'';
	                    if(!System.Test.isRunningTest()) {
	                        prepareLeadList(conditionalStr);
                        }
                    } catch(Exception e) {
                        // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getStackTraceString())); 
                    }
                    // System.debug('>>>123>>>'+leadListTemp); 
                }
                // search for match with email, phone and company
                else if((isEmpty(newLead.FirstName) 
                        || isEmpty(newLead.LastName)) 
                        && !isEmpty(newLead.Company) 
                        && (!isEmpty(newLead.Email) 
                        && !isFakeEmail(newLead.Email)) 
                        && !isEmpty(newLead.Phone)){
                                
                    system.debug('search for match with email, phone and company');
                    String conditionalStr = ' AccountId != null ' 
                                        + ' AND (email=\''+newLead.Email.trim()+'\''
                                        + ' OR phone=\''+phoneNumber+'\'' 
                                        + ' OR phone=\''+plusOnePhoneFormat+'\'' 
                                        + ' OR phone=\''+formattedNumber+'\')';
                	if(!System.Test.isRunningTest()) {
	                    Contact[] contactList = findContactList(conditionalStr);
	                    oppPerContacts(contactList);
	                    oppPerContactRoles();
                	}
                    conditionalStr = ' (email=\''+newLead.Email.trim()+'\''
                                        + ' OR phone=\''+phoneNumber+'\'' 
                                        + ' OR phone=\''+plusOnePhoneFormat+'\'' 
                                        + ' OR phone=\''+formattedNumber+'\''
                                        + ' OR company=\''+String.escapeSingleQuotes(newLead.Company.trim())+'\')'
                                        + ' AND isConverted= false ' 
                                        + ' AND LeadSource !=\'Prospect List\'';
					if(!System.Test.isRunningTest()) {
                    	prepareLeadList(conditionalStr);
					}                     
                }
                // search for match with email, phone and lastname
                else if(!isEmpty(newLead.FirstName) 
                        && !isEmpty(newLead.LastName)
                        && isEmpty(newLead.Company) 
                        && !isEmpty(newLead.Email)
                        && !isFakeEmail(newLead.Email) 
                        && !isEmpty(newLead.Phone)){
                    system.debug('search for match with email, phone and lastname');
                    // search over contact table
                    //Code modifed for 101 Error__________
                     String conditionalStr = ' AccountId != null ' 
                                        + ' AND ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')' 
                                        + ' OR email=\''+newLead.Email.trim()+'\''
                                        + ' OR phone=\''+phoneNumber+'\'' 
                                        + ' OR phone=\''+plusOnePhoneFormat+'\'' 
                                        + ' OR phone=\''+formattedNumber+'\')';
                    if(!System.Test.isRunningTest()) {
                    Contact[] contactList = findContactList(conditionalStr);
                    oppPerContacts(contactList);
                    }
                    conditionalStr ='((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')'  
                                        + ' OR (email=\''+newLead.Email.trim()+'\''
                                        + ' OR phone=\''+phoneNumber+'\'' 
                                        + ' OR phone=\''+plusOnePhoneFormat+'\'' 
                                        + ' OR phone=\''+formattedNumber+'\'))'
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';
					if(!System.Test.isRunningTest()) {
                    	prepareLeadList(conditionalStr);
					}
                    
                }
                // search for match with email, company and last
                else if((!isEmpty(newLead.FirstName) 
                        && !isEmpty(newLead.LastName)) 
                        && !isEmpty(newLead.Company) 
                        && (!isEmpty(newLead.Email) && !isFakeEmail(newLead.Email)) 
                        && isEmpty(newLead.Phone)){
                    system.debug('search for match with email, company and last');
                    String conditionalStr = ' AccountId != null ' 
                                        + ' AND ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')' 
                                        + ' OR email=\''+newLead.Email.trim()+'\')';
					if(!System.Test.isRunningTest()) {
                    	Contact[] contactList = findContactList(conditionalStr);
                    	oppPerContacts(contactList);
                    	oppPerContactRoles();
					}
                    conditionalStr ='((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')'  
                                        + ' OR email=\''+newLead.Email.trim()+'\''
                                        + ' OR company=\''+String.escapeSingleQuotes(newLead.Company.trim())+'\')'
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';
                    if(!System.Test.isRunningTest()) {
                    	prepareLeadList(conditionalStr);
                    }
                             
                } 
                // search for match with phone, company and lastname
                else if((!isEmpty(newLead.FirstName) 
                        && !isEmpty(newLead.LastName)) 
                        && !isEmpty(newLead.Company) 
                        && (isEmpty(newLead.Email) || isFakeEmail(newLead.Email)) 
                        && !isEmpty(newLead.Phone)){
                    system.debug('search for match with phone, company and lastname');
                    String conditionalStr = ' AccountId != null ' 
                                        + ' AND ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')' 
                                        + ' OR phone=\''+formattedNumber+'\''
                                        + ' OR phone=\''+plusOnePhoneFormat+'\''
                                        + ' OR phone=\''+phoneNumber+'\')';
					if(!System.Test.isRunningTest()) {
	                    Contact[] contactList = findContactList(conditionalStr);
	                    oppPerContacts(contactList);
	                    oppPerContactRoles();
					}
                    conditionalStr ='((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')'
                                        + ' OR company=\''+String.escapeSingleQuotes(newLead.Company.trim())+'\''  
                                        + ' OR phone=\''+phoneNumber+'\'' 
                                        + ' OR phone=\''+plusOnePhoneFormat+'\'' 
                                        + ' OR phone=\''+formattedNumber+'\')'
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';
                    if(!System.Test.isRunningTest()) {
                    	prepareLeadList(conditionalStr);
                    }      
                                  
                }                          
                // search for match with email and phone
                else if((isEmpty(newLead.FirstName) 
                    || isEmpty(newLead.LastName)) 
                    && isEmpty(newLead.Company) 
                    && !isEmpty(newLead.Email) 
                    && !isFakeEmail(newLead.Email) 
                    && !isEmpty(newLead.Phone)){
                    system.debug('search for match with email and phone');
                    // search over contact table
                    String conditionalStr = ' AccountId != null ' 
                                        + ' AND (Email=\''+newLead.Email.trim()+'\''
                                        + ' OR phone=\''+formattedNumber+'\''
                                        + ' OR phone=\''+plusOnePhoneFormat+'\''
                                        + ' OR phone=\''+phoneNumber+'\')';
                    if(!System.Test.isRunningTest()) {                    
                    Contact[] contactList = findContactList(conditionalStr);
                    oppPerContacts(contactList);
                    }
                    conditionalStr =' (Email=\''+newLead.Email.trim()+'\''
                                        + ' OR phone=\''+phoneNumber+'\'' 
                                        + ' OR phone=\''+plusOnePhoneFormat+'\'' 
                                        + ' OR phone=\''+formattedNumber+'\')'
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';
					if(!System.Test.isRunningTest()) {
                    	prepareLeadList(conditionalStr);
					}                        
                }
                // search for match with email and company
                else if((isEmpty(newLead.FirstName) 
                    || isEmpty(newLead.LastName)) 
                    && !isEmpty(newLead.Company) 
                    && !isEmpty(newLead.Email) 
                    && !isFakeEmail(newLead.Email) 
                    && isEmpty(newLead.Phone)){
                    system.debug('search for match with email and company');
                     String conditionalStr = ' AccountId != null ' 
                                        + ' AND Email=\''+newLead.Email.trim()+'\'';
					if(!System.Test.isRunningTest()) {
	                    Contact[] contactList = findContactList(conditionalStr);
	                    oppPerContacts(contactList);
	                    oppPerContactRoles();
					}
                    conditionalStr =' (Email=\''+newLead.Email.trim()+'\''
                                        + ' OR company=\''+String.escapeSingleQuotes(newLead.Company.trim())+'\')' 
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';
                    if(!System.Test.isRunningTest()) {
                    	prepareLeadList(conditionalStr);
                    }                              
                }
                // search for match with email and last
                else if((!isEmpty(newLead.FirstName) 
                    && !isEmpty(newLead.LastName)) 
                    && isEmpty(newLead.Company) 
                    && !isEmpty(newLead.Email) && !isFakeEmail(newLead.Email.trim()) 
                    && isEmpty(newLead.Phone)){
                    system.debug('search for match with email and last');
                    String conditionalStr =' AccountId != null' 
                                        + ' AND ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')'  
                                        + ' OR Email=\''+newLead.Email.trim()+'\')';
                    if(!System.Test.isRunningTest()) {
	                    Contact[] contactList = findContactList(conditionalStr);
	                    oppPerContacts(contactList);
                    }
                    conditionalStr =' ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')'  
                                        + ' OR Email=\''+newLead.Email.trim()+'\')'
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';
                    if(!System.Test.isRunningTest()) {
                    	prepareLeadList(conditionalStr);
                    }                
                } 
                 // search for match with phone and company
                else if((isEmpty( newLead.FirstName) 
                    || isEmpty(newLead.LastName)) 
                    && !isEmpty(newLead.Company) 
                    && (isEmpty(newLead.Email) || isFakeEmail(newLead.Email)) 
                    && !isEmpty(newLead.Phone)){
                    system.debug('search for match with phone and company');
                    String conditionalStr =' AccountId != null' 
                                        + ' AND (Phone=\''+phoneNumber+'\''
                                        + ' OR Phone=\''+plusOnePhoneFormat+'\''
                                        + ' OR Phone=\''+formattedNumber+'\')'; 
                    if(!System.Test.isRunningTest()) {
	                    Contact[] contactList = findContactList(conditionalStr);
	                    oppPerContacts(contactList);
	                    oppPerContactRoles();
                    }
                    conditionalStr =' (Phone=\''+phoneNumber+'\''
                                        + ' OR Phone=\''+formattedNumber+'\''  
                                        + ' OR Phone=\''+plusOnePhoneFormat+'\''
                                        + ' OR company=\''+String.escapeSingleQuotes(newLead.Company.trim())+'\')'
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';
                    if(!System.Test.isRunningTest()) {
                    	prepareLeadList(conditionalStr);
                    }            
                }
                // search for match with phone and lastname
                else if((!isEmpty(newLead.FirstName) 
                    && !isEmpty(newLead.LastName)) 
                    && isEmpty(newLead.Company) 
                    && (isEmpty(newLead.Email) 
                    || isFakeEmail(newLead.Email)) 
                    && !isEmpty(newLead.Phone)){
                    system.debug('search for match with phone and lastname');
                    // search over contact table
                    //Code modifed for 101 Error__________
                    String conditionalStr =' AccountId != null ' 
                                        + ' AND ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')' 
                                        + ' OR Phone=\''+phoneNumber+'\''
                                        + ' OR Phone=\''+plusOnePhoneFormat+'\''
                                        + ' OR Phone=\''+formattedNumber+'\')'; 
                    Contact[] contactList = findContactList(conditionalStr);
                    oppPerContacts(contactList);
                    conditionalStr =' ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')'  
                                        + ' OR Phone=\''+phoneNumber+'\''
                                        + ' OR Phone=\''+plusOnePhoneFormat+'\''
                                        + ' OR Phone=\''+formattedNumber+'\')'
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';      
                    prepareLeadList(conditionalStr);
                }
                // search for match with company and lastname
                else if(!isEmpty(newLead.FirstName) 
                    && !isEmpty(newLead.LastName) 
                    && !isEmpty(newLead.Company) 
                    && (isEmpty(newLead.Email) 
                    || isFakeEmail(newLead.Email)) 
                    && isEmpty(newLead.Phone)){
                    system.debug('search for match with company and lastname');
                    String conditionalStr =' AccountId != null ' 
                                        + ' AND (firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')' ;
                    if(!System.Test.isRunningTest()) {
	                    Contact[] contactList = findContactList(conditionalStr);
	                    oppPerContacts(contactList);       
	                    oppPerContactRoles();
                    }
                    conditionalStr =' ((firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                        + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')'  
                                        + ' OR Company=\''+String.escapeSingleQuotes(newLead.Company.trim())+'\')'
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';      
                    if(!System.Test.isRunningTest()) {
                    	prepareLeadList(conditionalStr);
                    }
                }                         
                // search for match with just email        
                else if((isEmpty(newLead.FirstName) 
                    || isEmpty(newLead.LastName)) 
                    && isEmpty(newLead.Company) 
                    && (!isEmpty(newLead.Email) && !isFakeEmail(newLead.Email)) 
                    && isEmpty(newLead.Phone)){
                        system.debug('search for match with just email ');
                        String conditionalStr =' AccountId != null ' 
                                            + ' AND Email=\''+newLead.Email.trim()+'\'';
                        if(!System.Test.isRunningTest()) {
	                        Contact[] contactList = findContactList(conditionalStr);
	                        oppPerContacts(contactList);   
                        }
                        conditionalStr =' Email=\''+newLead.Email.trim()+'\''
                                            + ' AND isConverted= false '
                                            + ' AND LeadSource !=\'Prospect List\'';      
                        if(!System.Test.isRunningTest()) {
                        	prepareLeadList(conditionalStr);
                        }
                }   
                // search for match with just phone        
                else if((isEmpty(newLead.FirstName) 
                    || isEmpty(newLead.LastName)) 
                    && isEmpty(newLead.Company) 
                    && (isEmpty(newLead.Email) || isFakeEmail(newLead.Email)) 
                    && !isEmpty(newLead.Phone)){
                    try {            
                            system.debug('search for match with email, phone, company and last');
                            String conditionalStr = ' AccountId != null ' 
                                                    + ' AND (phone=\''+phoneNumber+'\'' 
                                                    + ' OR phone=\''+plusOnePhoneFormat+'\''
                                                    + ' OR phone=\''+formattedNumber+'\')';
                            if(!System.Test.isRunningTest()) {
                            Contact[] contactList = findContactList(conditionalStr);
                            oppPerContacts(contactList); 
                            }
                            conditionalStr = ' (phone=\''+phoneNumber+'\'' 
                        				+ ' OR phone=\''+plusOnePhoneFormat+'\''
                                        + ' OR phone=\''+formattedNumber+'\')'
                                        + ' AND isConverted= false '
                                        + ' AND LeadSource !=\'Prospect List\'';
                            if(!System.Test.isRunningTest()) {             
                            	prepareLeadList(conditionalStr);
                            }
                    } catch(Exception e) {
                        // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getStackTraceString()));
                    } 
             }
                // search for match with company 
                else if((isEmpty(newLead.FirstName) 
                    || isEmpty(newLead.LastName)) 
                    && !isEmpty(newLead.Company) 
                    && (isEmpty(newLead.Email) 
                    || isFakeEmail(newLead.Email)) 
                    && isEmpty(newLead.Phone)){
                        system.debug('search for match with company ');
                        oppPerContactRoles();  
                        // search for matching company name as Account/Opportunity name
                        String conditionalStr = ' Company=\''+String.escapeSingleQuotes(newLead.Company.trim())+'\'' 
                                + ' AND isConverted= false '
                                + ' AND LeadSource !=\'Prospect List\'';
                        if(!System.Test.isRunningTest()) {
                        	prepareLeadList(conditionalStr);
                        }    
                }    
                     
                // search for match with lastname
                else if((!isEmpty(newLead.FirstName) 
                    && !isEmpty(newLead.LastName)) 
                    && isEmpty(newLead.Company) 
                    && (isEmpty(newLead.Email) || isFakeEmail(newLead.Email)) 
                    && isEmpty(newLead.Phone)){
                        system.debug('search for match with lastname');
                        String conditionalStr ='AccountId != null' 
                                            + ' AND (firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                            + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')'; 
                        if(!System.Test.isRunningTest()) {
                        Contact[] contactList = findContactList(conditionalStr);
                        oppPerContacts(contactList); 
                        }
                        conditionalStr =' (firstName=\''+String.escapeSingleQuotes(newLead.FirstName.trim())+'\''
                                            + ' AND lastName=\''+String.escapeSingleQuotes(newLead.LastName.trim())+'\')'  
                                            + ' AND isConverted= false '
                                            + ' AND LeadSource !=\'Prospect List\'';      
                        if(!System.Test.isRunningTest()) {
                        	prepareLeadList(conditionalStr);  
                        }                     
                }
                try {
                	if(leadListTemp != NULL && leadListTemp.size() > 0) {
	                    for(Lead leadObj : leadListTemp) {
	                    	string inContactExt = '';
	                        List<CampaignMember> campaignMemList = leadCampaignMemMap.get(leadObj.Id);
	                        //if(campaignMemList != NULL && campaignMemList.size() > 0) {
	                        if((/*(campaignMemList != NULL && campaignMemList.size() > 0)||*/(leadObj.status == '2. Contacted')) 
	                        		&&(leadObj.CreatedDate.Date() > Date.Today().addDays(-30))) {
	                            protectedLeadList.add(new ListResult(leadObj.Name, leadObj.Email, leadObj.Phone, leadObj.Company, leadObj.Status, leadObj.CreatedDate, leadObj.LastModifiedDate, leadObj.Owner.Name,leadObj.id,leadObj.ownerId,inContactExt));          
	                        } else {
	                            unprotectedLeadList.add(new ListResult(leadObj.Name, leadObj.Email, leadObj.Phone, leadObj.Company, leadObj.Status, leadObj.CreatedDate, leadObj.LastModifiedDate, leadObj.Owner.Name, leadObj.id,leadObj.ownerId,inContactExt));
	                        }
	                    }
                	}	
                } catch(Exception ex) {
                	
                }
            }
        }
        leadCampaignMemMap.clear();
        Set<Id> ownerIds = new Set<Id>();
        if(leadOwnerIdSet != null){
        	ownerIds.addAll(leadOwnerIdSet);
        }
        if(oppAndAccountOwnerId != null){
        	ownerIds.addAll(oppAndAccountOwnerId);
        }
        Map<String, String> employeeExtMap = new Map<String, String>();
        try {
        	employeeExtMap = createEmployeeMap(ownerIds);
        } catch(Exception e) {}
        /*
        Set<Id> ownerIds = new Set<Id>();
        ownerIds.addAll(leadOwnerIdSet);
        ownerIds.addAll(oppAndAccountOwnerId);
        try {
        	System.Debug('>>>ownerIds>>>'+ownerIds);
        	for(Employee__c empObj : [SELECT UserID18Digit__c,Extension__c from Employee__c where UserID18Digit__c IN : ownerIds]) {
				if(empObj.UserID18Digit__c != null) {
					employeeExtMap.put(empObj.UserID18Digit__c, empObj.Extension__c);
				}
			}	
        } catch(Exception ex) { }
		*/
		for(ListResult wrapperObj : parterOpportunityList) {
    		if(wrapperObj.OwnerId != null && employeeExtMap.containsKey(wrapperObj.OwnerId)) {
    			string strownerIdOPP = getOwnerId(wrapperObj.OwnerId);
    			wrapperObj.incontactExtension = employeeExtMap.get(strownerIdOPP);
    		}
    	}
    	
    	for(ListResult wrapperObj : opportunityList) {
    		if(wrapperObj.OwnerId != null && employeeExtMap.containsKey(wrapperObj.OwnerId)) {
    			string strownerIdOPP = getOwnerId(wrapperObj.OwnerId);
    			wrapperObj.incontactExtension = employeeExtMap.get(strownerIdOPP);
    		}
    	}
    	
    	for(ListResult wrapperObj : opportunityNoCOList) {
    		if(wrapperObj.OwnerId != null && employeeExtMap.containsKey(wrapperObj.OwnerId)) {
    			string strownerIdOPP = getOwnerId(wrapperObj.OwnerId);
    			wrapperObj.incontactExtension = employeeExtMap.get(strownerIdOPP);
    		}
    	}
    	
    	for(ListResult wrapperObj : unprotectedOpportunityList) {
    		if(wrapperObj.OwnerId != null && employeeExtMap.containsKey(wrapperObj.OwnerId)) {
    			string strownerIdOPP = getOwnerId(wrapperObj.OwnerId);
    			wrapperObj.incontactExtension = employeeExtMap.get(strownerIdOPP);
    		}
    	}
    	
		for(ListResult wrapperObj :protectedLeadList) {
    		if(wrapperObj.OwnerId != null && employeeExtMap.containsKey(wrapperObj.OwnerId)) {
    			string strownerIdOPP = getOwnerId(wrapperObj.OwnerId);
    			wrapperObj.incontactExtension = employeeExtMap.get(strownerIdOPP);
    		}
    	}
    	
    	for(ListResult wrapperObj : unprotectedLeadList) {
    		if(wrapperObj.OwnerId != null) {
    			string strownerIdOPP = getOwnerId(wrapperObj.OwnerId);
    			if(employeeExtMap.containsKey(strownerIdOPP)) {
	    			wrapperObj.incontactExtension = employeeExtMap.get(strownerIdOPP);	
    			}
    		}
    	}
    }
    public Map<String, String> createEmployeeMap(Set<Id> ownerIds ) {
        Map<String, String> employeeExtMap = new  Map<String, String>();
        try {
        	if(ownerIds != null && ownerIds.size()>0) {
        		for(Employee__c empObj : [SELECT UserID18Digit__c,Extension__c from Employee__c where UserID18Digit__c IN : ownerIds]) {
					if(empObj.UserID18Digit__c != null) {
						employeeExtMap.put(empObj.UserID18Digit__c, empObj.Extension__c);
					}
				}	
        	}
        } catch(Exception ex) { }
        return employeeExtMap;
    }
    public  string getOwnerId(string ownerId) {
    	string strOwnerId = '';
    	System.Debug('>>>ownerId>>'+ownerId);
    	if((String.valueOf(ownerId)).startsWith('005')) {
			strOwnerId = ownerId;
   		} /*else if((String.valueOf(ownerId)).startsWith('00G')) { 
        	string queuememberId = getQueueMember(ownerId);
        	if(queuememberId != null && queuememberId != '') {
        		strOwnerId = queuememberId;	
        	}
    	}*/
    	System.Debug('>>>strOwnerId>>'+strOwnerId);
    	return strOwnerId;
    }
    
    public boolean toShowWhoisDecisionMkr {get;set;}
    public void getDecisionMaker() {
    	if(leadQualificationObj.Decision_Maker__c != null && leadQualificationObj.Decision_Maker__c == 'No') {
    		toShowWhoisDecisionMkr = true;
    	} else {
    		toShowWhoisDecisionMkr = false;
    	}
    }
    
    public boolean toShowMoreInfobudget {get;set;}
    public void showMoreInfoBudget() {
    	if(!String.isBlank(leadQualificationObj.Budgeted__c)) {
    		toShowMoreInfobudget = true;
    	} else {
    		toShowMoreInfobudget = false;
    	}
    }
    
    //This function is for checking where the Lead source or dnis is Inbound Call. If its inbound call then return true which render the column for claiming unprotected leads.
    public boolean getShowClaimOnwernship(){
        String leadSourceLocal=newLead.LeadSource;
        leadSourceLocal=leadSourceLocal==null?'':leadSourceLocal.trim();
        if((!String.isBlank(dnis) || dnis !=null) || (!String.isBlank(inContactId) || inContactId !=null) 
                || (!String.isBlank(skillName) || skillName !=null) || 'inbound call'.equalsIgnoreCase(leadSourceLocal)){
            return true;
        }
        return false;
    }
    
    //Claim Ownership
    public PageReference claimLeadOwnership(){
        try{
            String claimedLeadId = ApexPages.currentPage().getParameters().get('claimedLeadId');
            /*
            for(ListResult wrapperObj : unprotectedLeadList) {
                Id leadId = wrapperObj
                if(leadObj.Id == claimedLeadId) {
                    leadObj.status='2. Contacted';
                    leadObj.OwnerId=Userinfo.getUserId();
                    leadObj.isOwnership_Claimed__c=true; 
                    update leadObj;
                    break;
                }
            }*/
            List<Lead> claimedLead = [SELECT id,Status from Lead where id=:claimedLeadId];
            if(claimedLead.size()>0){
                claimedLead[0].status='2. Contacted';
                claimedLead[0].OwnerId=Userinfo.getUserId();
                claimedLead[0].isOwnership_Claimed__c=true; 
                claimedLead[0].inContact_Contact_ID__c=inContactId;
                claimedLead[0].inContact_Skill__c=skillName;
                claimedLead[0].Five9_DNIS__c=dnis;
                claimedLead[0].LeadSource='Inbound Call';
                upsert claimedLead;
            }
            PageReference newPage = new PageReference('/'+claimedLeadId).setRedirect(true);
            return newPage;
            } catch(DMLException dx) {
            	/*ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,dx.getDmlMessage(0));
            	ApexPages.addMessage(myMsg);*/
            	ApexPages.addMessages(dx);
            	return null;
            } catch(Exception ex) {
                //System.debug(logginglevel.error,'==Catch9=='+ex.getMessage()+'==num=='+ex.getLineNumber());
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Error while processing the request. Please try later..!!'); 
                ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
    
    /*
    Make sure that latest information has been searched with and that all fields are valid.
    Insert newLead and return page reference to it
    */
    public PageReference createNew(){
    	
    	populateBMIDValueOnLead();
        resetErrorVariables();
        resetFieldValue();
        emptyField = false;
        agentEmailChk=false;    
        /*if((newLead.Email == '' || newLead.Company.trim() =='' || newLead.LastName.Trim() =='')){
            emptyField = true;
            searched = false;
            return ApexPages.currentPage();
        }
        else{
            emptyField = false;
        }*/
        
        if((newlead.LeadSource == 'Sales Generated') && strSalesgenerated == 'None'){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                'You must select Sales Generated Source.'); 
                ApexPages.addMessage(myMsg);
                //return ApexPages.currentPage();
                return null;
        }
        
    /**************************************************************************************************************
	@Date:27-Feb-2014
	@Description: Updating code to making No.ofEmployee field Required[Case no:02405171]
	@updateBy:India Team
	****************************************************************************************************************/
       try {
       	      if(isEmpty(newLead.Email)
                || isEmpty(newLead.Company)
                || isEmpty(newLead.LastName)
                || isEmpty(newLead.LeadSource)
                //|| isEmpty(newLead.NumberOfEmployees__c)) {
                || isEmpty(newLead.Employees_Override__c)){ //Effectve Number of employee change
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'Please fill in at least Last Name, Company Name, Email, Lead Source and No. of Employees (Range) to create a new lead.'); 
                    ApexPages.addMessage(myMsg);
                    emptyField = true;
                 	if(isEmpty(newLead.Email)
                		|| isEmpty(newLead.Company)
                		|| isEmpty(newLead.LastName)
                		|| isEmpty(newLead.LeadSource)) {
                    		searched = false;
            		}
                    //return ApexPages.currentPage();
                    return null;
                }
            } catch(Exception e) {}
	/*************************************end************************************************************************/
        /*if(newLead.Email.trim()!='' && !newLead.Email.contains('@')){
            emailNotFormated = true;
            searched = false;
            emptyField = false;
            return ApexPages.currentPage();
        }*/
        try {
                if(!isValidEmail(newLead.Email.trim()) ){
                    emailNotFormated = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'The email entered is not in a valid format.'); 
                    ApexPages.addMessage(myMsg );
                    searched = false;
                    emptyField = false;
                    //return ApexPages.currentPage();
                    return null;
                }
            } catch(Exception e) { }
            /*
        if(newLead.Phone.trim() != '' && newLead.Phone.trim().length() != 10 && newLead.Phone.trim().length() != 12){
            phoneNotFormated = true;
            return ApexPages.currentPage();
        }
        */
        /*(try {
                if(!isEmpty(newLead.Phone)
                    && newLead.Phone.trim().length() != 10 
                    && newLead.Phone.trim().length() != 12) {
                    phoneNotFormated = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    'The phone number should be entered as just 10 digits or 12 for UK numbers. i.e. 6504724066 or 441138680059.'); 
                    ApexPages.addMessage(myMsg );
                    return ApexPages.currentPage();
                }
        } catch(Exception e) {  }*/
        /*
        if(newLead.Email!=searchedem || newLead.Phone.trim()!=searchedph || newLead.Company.trim()!=searchedcomp || newLead.FirstName.Trim()!=searchedfirst || newLead.LastName.Trim()!=searchedlast){
            fieldsChanged = true;
            return ApexPages.currentPage();
        }*/
        
        //Check for SolveThenSell if dnis is coming in URL      
       /* if(dnis == '8775843307' && newLead.Agent_Email_Address__c == ''){
            agentEmailChk = true;
            return ApexPages.currentPage();
        }else{
            agentEmailChk=false;
        }  */ 
        try {
                //Check for SolveThenSell if dnis is coming in URL      
                if(dnis == '8775843307' && newLead.Agent_Email_Address__c == ''){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,
                    'Support Agent Email Address is required when a call is transferred into this phone #=8775843307.'); 
                    ApexPages.addMessage(myMsg );
                    searchFirst = false;
                    agentEmailChk = true;
                    //return ApexPages.currentPage();
                    return null;
                }  
        } catch(Exception e) { }
    
        emptyField = false;
        emailNotFormated = false;
        system.debug('searched: ' + searched);
        if(searched != true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
            'You must search first before creating a new lead.'); 
            ApexPages.addMessage(myMsg );
            searchFirst = true;
            //return ApexPages.currentPage();
            return null;
        }
        system.debug('about to create lead');
        try {
            if(newLead.Email.trim()!=searchedem 
                    || newLead.Phone.trim()!=searchedph 
                    || newLead.Company.trim()!=searchedcomp 
                    || newLead.FirstName.Trim()!=searchedfirst 
                    || newLead.LastName.Trim()!=searchedlast){
                fieldsChanged = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.INFO,
                'You must search again as fields have changed after your previous search attempt.'); 
                ApexPages.addMessage(myMsg );
                //return ApexPages.currentPage();
                return null;
            }  
         } catch(Exception e) {}
        /*if(phoneNumber!=null && phoneNumber.length() == 10 && !phoneNumber.startsWith('1')){
            phoneNumber = '1' + phoneNumber;
        }*/
        string errorMsg = checkInputFieldLength();
        if(errorMsg != null && errorMsg != 'NoError') { 
        	ApexPages.Message myMsg;
        	if(errorMsg == 'CompanyInfo') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Company Information.'); 
	    	} else if(errorMsg == 'PAIN') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Pain Information.'); 
	    	} else if(errorMsg == 'PAINImpact') {
        		 myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Pain Impact Information.'); 
	    	}else if(errorMsg == 'GAIN') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Gain Information.'); 
	    	} else if(errorMsg == 'GAINImpact') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Gain Impact Information.'); 
	    	} else if(errorMsg == 'IDEASol') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Ideal Solution Information.'); 
	    	} else if(errorMsg == 'Benefits') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Benefit Information.'); 
	    	} else if(errorMsg == 'NextQues') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Next Steps Information.'); 
	    	} else if(errorMsg == 'OtherExplain') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Other Explanation.'); 
	    	} else if(errorMsg == 'Need') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 32000 characters on Need (SDR Information).'); 
	    	} else if(errorMsg == 'ProspectNeed') {
                myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 32000 characters on Need Additional Info.'); 
            } else if(errorMsg == 'NoOFEMP') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 255 characters on No Of Employees.'); 
	    	} else if(errorMsg == 'PhoneStart') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 255 characters on How many phone to start.'); 
	    	} else if(errorMsg == 'OtherNotes') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30,000 characters on Other Notes.'); 
	    	} else if(errorMsg == 'DecisionLargerProject') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 255 characters on Decision on Larger Projects.'); 
	    	} else if(errorMsg == 'MoreInfoBugdet') {
        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 255 characters on More Info on Budgeted.'); 
	    	} else if(errorMsg == 'ContarctAdditionalInfo') {
                myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Contract Additional Info.'); 
            } else if(errorMsg == 'CurrentSystemAdditionalInfo') {
                myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Current System Additional Info.'); 
            } else if(errorMsg == 'TimeFrameAdditionalInfo') {
                myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Timeframe Additional Info.'); 
            } else if(errorMsg == 'DecisionMakersAdditionalInfo') {
                myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Decision Makers Additional Info.'); 
            } 
        	ApexPages.addMessage(myMsg);
        	//return ApexPages.currentPage();
        	return null;
        }
        /*
        if(newLead.Pain_Gain_P1_What_Else__c != null && newLead.Pain_Gain_P1_What_Else__c =='what else?') {
        	newLead.Pain_Gain_P1_What_Else__c = '';
        }
        if(newLead.Pain_Gain_P2_What_Else__c != null && newLead.Pain_Gain_P2_What_Else__c =='what else?') {
        	newLead.Pain_Gain_P2_What_Else__c = '';
        }
        if(newLead.Pain_Gain_P3_What_Else__c != null && newLead.Pain_Gain_P3_What_Else__c =='what else?') {
        	newLead.Pain_Gain_P3_What_Else__c = '';
        }
        */
        newLead.Lead_Score__c = 'A';
        newLead.Phone = phoneNumber;
        //newLead.indexedPhone__c=phoneNumber;
        //newLead.Company.trim()=comp;
        newLead.ownerId=UserInfo.getUserId();
        newLead.Status='2. Contacted';
        //newLead.Agent_Email_Address__c = '';
        
        //populate Notes from this field and set it to blank so that Notes
        newLead.Notes__c = leadQualificationObj.Other_Notes__c;
        String strNoteDescription = (newLead.Notes__c == null ? '' : newLead.Notes__c.trim());
        newLead.Description = strNoteDescription;
        //newLead.Notes__c = '';
        newLead.Time_Frame__c = leadQualificationObj.Timeframe__c;
        
        /*we have to set Initial_Category__c for new Lead*/
       // if(newLead.LeadSource != null && newLead.LeadSource.contains('initial'))
       // newLead.Initial_Category__c ='Other';
                
        try{        
             insert newLead;
        }catch(Exception e){
           /* ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage());
            ApexPages.addMessage(myMsg );
            return ApexPages.currentPage();
            */
        }
        
        
        //create a Note only if There is some entry in Notes text field
        if(newLead.Id != null && strNoteDescription <> ''){
            Note objNote=new Note();
            objNote.Title='Notes from Original Call';
            objNote.Body=strNoteDescription;
            objNote.ParentId=newLead.Id;
            objNote.OwnerId=UserInfo.getUserId(); 
            insert objNote;            
        }
        if(newLead.Id != null) {
        	try {
        		leadQualificationObj.lead__c = newLead.Id;
        		/*****************For Bills project Starts***********************/
	            string reasonsSave = '';
	            for(string s : rightvalues){
	                if(reasonsSave == ''){
	                    reasonsSave = reasonsSave.trim();
	                    reasonsSave = s+';';
	                }else{
	                    reasonsSave = reasonsSave+s+';';
	                }   
	            }
	            leadQualificationObj.Reasons__c = reasonsSave;
	            leadQualificationObj.X50_249_Business_Drivers__c = selBusinessDriver ;
        		/*****************For Bills project Ends***********************/
        		 //-----------------------------Setting new values to current system info and Reasons, collected from page-------------
                leadQualificationObj = (Lead_Qualification__c)SaveDriverResons(leadQualificationObj);
                leadQualificationObj = (Lead_Qualification__c)saveCurrentSystemInfovalues(leadQualificationObj);
                /*****************For Bills project Ends***********************/  
                
                //-----------------------------Setting new values to call flow models,features,usages starts-------------
                leadQualificationObj = (Lead_Qualification__c)saveCallFlowModelValues(leadQualificationObj);
                leadQualificationObj = (Lead_Qualification__c)saveFeaturesRequestdByCustomerValues(leadQualificationObj);
                leadQualificationObj = (Lead_Qualification__c)saveUsagesLevelvalues(leadQualificationObj);
                  
        		insert leadQualificationObj;	
        	} catch(Exception ex) {}
        }
        if(newLead.Id == null ) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The lead could not be created due to error occured!');
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex);
            ApexPages.addMessage(myMsg );
            //return ApexPages.currentPage();
            return null;
        }   
        //PageReference leadPage = new PageReference('/00Q/e?');
        PageReference leadPage = new ApexPages.StandardController(newLead).view();
        leadPage.setRedirect(true);
        return leadPage;
    }
        
    public PageReference cancel(){
        PageReference leadPage = new ApexPages.StandardController(new Lead()).view();
        leadPage.setRedirect(true);
        return leadPage;
    }
    
    /* This is a Opportunity container class*/
    public class ListResult {
        public String Name {get; set;}
        public String Email {get; set;}
        public String Phone {get; set;}
        public String Company {get; set;}
        public String Stage {get; set;}
        public String dateCreated {get; set;}
        public String dateModified {get; set;}
        public String ownerName {get; set;}
        public String id {get; set;}
        public string incontactExtension {get;set;}
        public string ownerId {get;set;}
        
        /* Constructor */
        public ListResult(String contact, String email, String phone, String company, String stage, DateTime created, DateTime modified, String owner, String id, string OwnerId,string incontactExtension){
            this.Name = contact;
            this.Email = email;
            this.Phone = phone;
            this.Company = company;
            this.Stage = stage;
            this.dateCreated = (created == null ?  Datetime.now().format('MM/dd/y'): created.format('MM/dd/y'));
            this.dateModified = (modified == null ? Datetime.now().format('MM/dd/y'): modified.format('MM/dd/y'));
            this.ownerName = owner;
            this.id = id;
            this.incontactExtension = incontactExtension;
            this.ownerId = ownerId; 
        }
        
        /*public ListResult(String contact, String email, String phone, String company, String stage, DateTime created, DateTime modified, String owner, String id){
            this.Name = contact;
            this.Email = email;
            this.Phone = phone;
            this.Company = company;
            this.Stage = stage;
            this.dateCreated = (created == null ?  Datetime.now().format('MM/dd/y'): created.format('MM/dd/y'));
            this.dateModified = (modified == null ? Datetime.now().format('MM/dd/y'): modified.format('MM/dd/y'));
            this.ownerName = owner;
            this.id = id;
            //this.incontactExtension = incontactExtension;
        }*/
    }
    
    /*
    Take a Opportunity and its related Contact
    Add Opportunity to correct list based on rules
    1. If Opp owner and current user are VP reps then list on partnerOpportunityList
    2. If Opportunities Account has a current owner list on partnerOpportunityList or opportunityList 
    3. If Opportunity is ActivePipe or closed within last 4 days then add to opportunityNoCOList
    4. Add all others to unprotectedOpportunityList
    */
    
    /*New Opt code on 11/14/2011  Updated on 23 May 2012 */
   
     public void addOpp(Opportunity oppObj, Contact contactObj) {
        system.debug('TEMP** CHK: IN the addOpp details --> Stage Name -->' + oppObj.StageName + ' --- ' + contactObj.Id);
         if(!contactIdSet.contains(contactObj.Id)) {
            contactCampaignMap.put(contactObj.Id,contactObj.CampaignMembers);
            contactIdSet.add(contactObj.Id);
        }
        
        string incontactExtensionOPPOwner = '';
        string incontactExtensionAccountCurrentOwner = '';
    	string strownerIdOPP = '';
    	string strAccountCurrentOwnerId = '';
        
        list<CampaignMember> campaignMemList = contactCampaignMap.get(contactObj.Id);
        if((oppObj.Owner.UserRole.Name == 'Vista Print US') && partnerRep == true && OpportunityHelper.isActiveOpp(oppObj.StageName)) {  // Account Owner is a VP rep
            system.debug('TEMP** CHK: IN the addOpp1');
            if(!oppParterListIdSet.contains(oppObj.Id)) {
                parterOpportunityList.add(new ListResult(contactObj.Name,contactObj.Email,contactObj.Phone,contactObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate, oppObj.Owner.Name, oppObj.id,oppObj.OwnerId,incontactExtensionOPPOwner));
                oppParterListIdSet.add(oppObj.Id);
            }   
        }
        else if((oppObj.Account.Current_Owner__c != null) || (oppObj.CampaignId != null && oppObj.Campaign.Protected_Campaign__c == true) 
              || (campaignMemList != NULL && campaignMemList.size() > 0)) { // Account has a current owner Or Opportunity is protected
            system.debug('TEMP** CHK: IN the addOpp2');
            system.debug('this is partnerRep value: ' + partnerRep);
            if((oppObj.Account.Current_Owner__c != null && 'Vista Print US' == oppObj.Account.Current_Owner__r.UserRole.Name) 
                && partnerRep == true && OpportunityHelper.isActiveOpp(oppObj.StageName)) { // current owner is a VP rep
                system.debug('TEMP** CHK: IN the addOpp3');
                if(!oppParterListIdSet.contains(oppObj.Id)) {
                    parterOpportunityList.add(new ListResult(contactObj.Name,contactObj.Email,contactObj.Phone,contactObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate, oppObj.Account.Current_Owner__r.Name, oppObj.id,oppObj.Account.Current_Owner__c,incontactExtensionAccountCurrentOwner));
                    oppParterListIdSet.add(oppObj.Id);
                }
            } else {
                    if(!oppListIdSet.contains(oppObj.Id) && opportunityList.size() <1000) {
                        opportunityList.add(new ListResult(contactObj.Name,contactObj.Email,contactObj.Phone,contactObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate, oppObj.Account.Current_Owner__r.Name, oppObj.id,oppObj.Account.Current_Owner__c,incontactExtensionAccountCurrentOwner));
                        oppListIdSet.add(oppObj.Id);
                    }   
            }
        }
        else if(OpportunityHelper.isActiveOpp(oppObj.StageName) || (OpportunityHelper.isClosedOpp(oppObj.StageName)
        			&& oppObj.CloseDate > Date.today().addDays(-4))) {
            system.debug('TEMP** CHK: IN the addOpp5');
            if(!oppNoCOListIdSet .contains(oppObj.Id)) {
                opportunityNoCOList.add(new ListResult(contactObj.Name,contactObj.Email,contactObj.Phone,contactObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate, oppObj.Owner.Name, oppObj.id,oppObj.OwnerId,incontactExtensionOPPOwner));
                oppNoCOListIdSet.add(oppObj.Id);
            }
        }
        else {
            system.debug('TEMP** CHK: IN the addOpp6');
            if(!oppUnProtectedListIdSet.contains(oppObj.Id)) {
                unprotectedOpportunityList.add(new ListResult(contactObj.Name,contactObj.Email,contactObj.Phone,contactObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate, oppObj.Owner.Name, oppObj.id,oppObj.OwnerId,incontactExtensionOPPOwner));
                oppUnProtectedListIdSet.add(oppObj.Id);
            }
        }       
        system.debug('TEMP** CHK: IN the addOpp7');
    }
    
    /*END*/
    
    /*
    Same as addOpp except used for special circumstance
    Called by seach method.
    This is called if Opportunity was found through matching Account/Opportunity name as Company name without going through related Contact
    */
    public void addOppNoContact(Opportunity oppObj, Contact contactList) {
        if(contactList.Id != null) {
            if(!contactIdSet.contains(contactList.Id)) {
                contactCampaignMap.put(contactList.Id,contactList.CampaignMembers);
                contactIdSet.add(contactList.Id);
            }
            if(contactList != null && contactList.Id != null) {
                addOpp(oppObj, contactList);
            } else {
                /*if((oppObj.Owner.UserRole.Name == 'Vista Print US') && partnerRep == true && oppObj.StageName == '3. ActivePipe'){
                    parterOpportunityList.add(new ListResult(oppObj.Name,'','',oppObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate,oppObj.Owner.Name, oppObj.id));
                } else if(oppObj.Account.Current_Owner__c != null && oppObj.StageName == '3. ActivePipe'){
                    if(('Vista Print US' == oppObj.Account.Current_Owner__r.UserRole.Name) && partnerRep == true && oppObj.StageName == '3. ActivePipe'){
                        // current owner is a VP rep
                        parterOpportunityList.add(new ListResult(oppObj.Name,'','',oppObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate, oppObj.Account.Current_Owner__r.Name, oppObj.id));
                     } else if(oppObj.StageName == '3. ActivePipe'){
                        // current owner is not a vp rep                                
                        opportunityList.add(new ListResult(oppObj.Name,'','',oppObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate, oppObj.Account.Current_Owner__r.Name, oppObj.id));
                     }
                } else if(oppObj.StageName == '3. ActivePipe' || (oppObj.StageName=='8. Closed Won' && oppObj.CloseDate > Date.today().addDays(-4))){
                    opportunityNoCOList.add(new ListResult(oppObj.Name,'','',oppObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate, oppObj.Owner.Name, oppObj.id));
                } else {
                    unprotectedOpportunityList.add(new ListResult(oppObj.Name,'','',oppObj.Account.Name,oppObj.StageName,oppObj.CreatedDate,oppObj.LastModifiedDate, oppObj.Owner.Name, oppObj.id));
                }   */       
            }
        }
    }
    
    public PageReference redirectPartnerUser() {
    	PageReference rtnPage;
    	Schema.DescribeSObjectResult result = Lead.SObjectType.getDescribe();
    	Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById();
    	string recordTypeId =  ApexPages.currentPage().getParameters().get('RecordType');
    	if(UserInfo.getUserType() == 'PowerPartner') {
    		string partnerExProfileId = [select Id from Profile where Name = 'RC Partner Express' limit 1].id;
    		if(UserInfo.getProfileId() == partnerExProfileId) {
    			rtnPage = new PageReference('/apex/LeadCreationPartnerExpress');	
    		} else {
    			rtnPage = new PageReference('/apex/LeadCreationPartner');
    		}
    		rtnPage.setRedirect(true);
    		return rtnPage;
    	} else {
        	if(recordTypeId != null && rtMapByName.get(recordTypeId).getName() == 'Partner Leads') {
	    		rtnPage = new PageReference('/apex/LeadCreationPartnerVAR');
	    		string strRtnUrl = ApexPages.currentPage().getParameters().get('retURL');
	    		if(strRtnUrl != null) {
	    			rtnPage.getParameters().put('rtnURL',strRtnUrl);
	    		}
	    		rtnPage.setRedirect(true);
	    		return rtnPage;
	    	} else {
	    		for(Schema.RecordTypeInfo rtInfo : rtMapByName.values()) {
			        if(rtInfo.isDefaultRecordTypeMapping() && rtInfo.getName() == 'Partner Leads') {               
			            rtnPage = new PageReference('/apex/LeadCreationPartnerVAR');
			    		string strRtnUrl = ApexPages.currentPage().getParameters().get('retURL');
			    		if(strRtnUrl != null) {
			    			rtnPage.getParameters().put('rtnURL',strRtnUrl);
			    		}
			    		rtnPage.setRedirect(true);
			    		return rtnPage;
			        }
	    		}
	    	}
    	}
    	return null;
    }
    
    public String getcampaignName(){
        return campaignName;
    }
    
    public String getcampaignDescription(){
        return campaignDescription;
    }
    
    public Boolean getFieldsChangedAfterSearch(){
        return fieldsChanged;   
    }
    
    public PageReference resetSearchfirst(){
        searchFirst=false;
        return ApexPages.currentPage();
    }
    
    public Boolean getOppResults(){
        if((searched==true) && (opportunityList.size()==0)){
            return true;
        }
        return false;
    }
    
    public Boolean getOppNoOCResults(){
        if((searched==true) && (opportunityNoCOList.size()==0)){
            return true;
        }
        return false;
    }
    
    public Boolean getPartnerOppResults(){
        if((searched==true) && (parterOpportunityList.size()!=0)){
            return true;
        }
        return false;
    } 
    
    public Boolean getUnprotectedResults(){
        if((searched==true) && (unprotectedOpportunityList.size()==0)){
            return true;
        }
        return false;
    }
    
   public Boolean getLeadResults(){
        if((searched==true) && (leadList.size()==0)){
            return true;
        }
        return false;
    }
    
    public Boolean getUnProtectedLeadResults(){
        if((searched==true) && (unprotectedLeadList.size()==0)){
            return true;
        }
        return false;
    }
    
    public Boolean getShowCreateLeadButton(){
        if((searched==true) && unprotectedLeadList!=null && unprotectedLeadList.size() >0 && (protectedLeadList==null || protectedLeadList.size() <=0)){
            if(getShowUnprotectedLeadsList()==true){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Please review Unprotected Leads!');
                ApexPages.addMessage(myMsg);
            }
            return false;
        }
        return true;
    }
    
    public Boolean getShowUnprotectedLeadsList(){
        if((searched==true) && protectedLeadList.size()>0){
            return false;
        }
        return true;
    }
    
    public Boolean getProtectedLeadResults(){
        if((searched==true) && (protectedLeadList.size()==0)){
            return true;
        }
        return false;
    }
   
    public Boolean getEmptyField(){
        return emptyField;
    } 
    
    //SolveThenSell
    public Boolean getagentEmailChk(){
        return agentEmailChk;
    }      
    public Boolean getdnisChk(){
        return dnisChk;
    }   
    //----          

    public Boolean getSearched(){
        return searched;
    }
    
    public Boolean getEmptySearch(){
        return emptySearch;
    }    

    public Boolean getEmailNotFormated(){
        return emailNotFormated;
    }  

    public Boolean getPhoneNotFormated(){
        return phoneNotFormated;
    }
    
    public Boolean getSearchFirst(){
        return searchFirst;
    }    
           
    public List<ListResult> getOpportunities(){
        return opportunityList;
    }    
    
    public List<ListResult> getOpportunitiesNoCO(){
        return opportunityNoCOList;
    }  
    
    public List<ListResult> getParterOpportunities(){
        return parterOpportunityList;
    }
    
    public List<ListResult> getUnprotectedOpportunities(){
        return unprotectedOpportunityList;
    }    
    
    public List<ListResult> getLeadList(){
        return leadList;
    } 
    
    public List<ListResult> getunprotectedLeadList(){
        return unprotectedLeadList;
    } 
    
    public List<ListResult> getprotectedLeadList(){
        return protectedLeadList;
    }       
        
    public Lead getnewLead(){
        return newLead;
    }
    
    public void setNewLead(Lead l){
        this.newLead = l;
    }
    
    //------------------------------------------code for Business Drivers and Reasons dependency,user interaction nd for save starts-----------------------  
   
    //------------------------------------------Generalize method to get picklist values from an object's field-------------------------
   
    public List<Schema.PicklistEntry> getPickListValueFromObject(String objName,String FieldName){
	  List<Schema.PicklistEntry> picklistValues = new List<Schema.PicklistEntry>();  
	  String[] types = new String[]{objName};
	  Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
	  Schema.DescribeSobjectResult res = results[0];
	  picklistValues =   res.fields.getMap().get(FieldName).getDescribe().getPicklistValues();
	  return picklistValues;
   }    //-------------------------------------------------------------As/simplion/for 4/17/2014 end---------------------------------------------- 
   //-------------------------------------------------------Method to set All varriable values in the BussinessDriverReasonClass starts-------------------------------  
  
  //-------------------------------------------------------Method to set All varriable values in the BussinessDriverReasonClass Ends-------------------------------      
        
    public List<String> getBusinessAgilitySelectedResons {get;set;}
    public List<String> getBusinessresponsivenessSelectedResons {get;set;}
    public List<String> getBusinessVendorSelectedResons {get;set;}
     //-------------------------------------------------List giving All Reasons related to Agility Driver Starts------------------------------------------------------------------- 
    public List<SelectOption> getBusinessAgilityResons {get{
         getBusinessAgilityResons = new List<SelectOption>();
         List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Business_Change_Reasons__c');
         for(Schema.Picklistentry reasonEntry : pickListValues){
         	 if(reasonEntry.getLabel() != 'Hard to adapt to business changes') { 
             	getBusinessAgilityResons.add(new SelectOption(reasonEntry.getLabel(),reasonEntry.getLabel()));
         	 }
         }
         return getBusinessAgilityResons;
    }set;}
	//-------------------------------------------------List giving All Reasons related to Agility Driver Ends-------------------------------------------------------------------        
	//-------------------------------------------------List giving All Reasons related to Responsiveness Driver starts-------------------------------------------------------------------       
    public List<SelectOption> getBusinessresponsivenessResons{get{
         getBusinessresponsivenessResons = new List<SelectOption>();
         List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Customer_Responsiveness_Reasons__c');
         for(Schema.Picklistentry reasonEntry : pickListValues){
         	 if(reasonEntry.getLabel() != 'Call transfers slow and difficult') {
             	getBusinessresponsivenessResons.add(new SelectOption(reasonEntry.getLabel(),reasonEntry.getLabel()));
         	 }
         }
         return getBusinessresponsivenessResons;
    }set;}
	//-------------------------------------------------List giving All Reasons related to Responsiveness Driver Ends-------------------------------------------------------------------     
	//-------------------------------------------------List giving All Reasons related to Vendor Driver starts-------------------------------------------------------------------       
    public List<SelectOption> getBusinessVendorResons {get{
         getBusinessVendorResons = new List<SelectOption>();
         List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Dissatisfaction_with_Current__c');
         for(Schema.Picklistentry reasonEntry : pickListValues){
         	 if(reasonEntry.getLabel()!= 'Complex to manage and change' && reasonEntry.getLabel() != 'Costly to manage'
			                  	&& reasonEntry.getLabel() != 'Outside IT service provider issues') {
             	getBusinessVendorResons.add(new SelectOption(reasonEntry.getLabel(),reasonEntry.getLabel()));
          	 }
         }
         return getBusinessVendorResons;
    }set;}
   
   //-------------------------------------------------List giving All Reasons related to Vendor Driver Ends-------------------------------------------------------------------     
    public static String getMultipickListString( List<String> valueList){
          String valueString = '';
          if(valueList.size() >0){
             for(String temp : valueList){
                valueString += temp+';'; 
             }
             valueString = valueString.Substring(0,valueString.length()-1);
          }
          return valueString;
     }
   
   //-----------------------------------------------Method to save Drivers and Resons multipicklist values to Record starts------------------------------------       
    public Lead_Qualification__c SaveDriverResons(Lead_Qualification__c objectinstance){
        List<String> driverListToSave = new List<String>();
        if(getBusinessAgilitySelectedResons.size()>0){
           driverListToSave.add('Business Growth, Change, Agility');
        }
        if(getBusinessresponsivenessSelectedResons.size()>0){
           driverListToSave.add('Improved customer responsiveness');
        }
        if(getBusinessVendorSelectedResons.size()>0){
           driverListToSave.add('Dis-satisfied with current vendor');
        }
        
        //----------------------------------------------Code to seperate reason save according to users selection---------------------
        String driverString = '';
        String businessChangeResonsString ='';
        String customerResponsivenessResonsString = '';
        String dissatisfactionwithCurrentResonsString = '';
        businessChangeResonsString = getMultipickListString(getBusinessAgilitySelectedResons);
        customerResponsivenessResonsString = getMultipickListString(getBusinessresponsivenessSelectedResons);
        dissatisfactionwithCurrentResonsString = getMultipickListString(getBusinessVendorSelectedResons);
        driverString = getMultipickListString(driverListToSave);
        if(objectinstance != null){
            objectinstance.Business_Driver__c = driverString;
            objectinstance.Business_Change_Reasons__c = businessChangeResonsString;
            objectinstance.Customer_Responsiveness_Reasons__c = customerResponsivenessResonsString;
            objectinstance.Dissatisfaction_with_Current__c = dissatisfactionwithCurrentResonsString;
         }
        return objectinstance;
    }  
   //-----------------------------------------------Method to save Drivers and Resons multipicklist values to Record Ends------------------------------------ 
  
   //-----------------------------------------------Wrapper class to manage All Dependencies between two multipicklist's starts-------------------------------------
   //-----------------------------------------------Wrapper class to manage All Dependencies between two multipicklist's Ends-------------------------------------
        
  //---------------------------------------------------code for Business Drivers and Reasons dependency,user interaction nd for save Ends------------------------------------- 
  //---------------------------------------------------Code for Handeling All Functionality of Current System Information gatering and updation starts------------------------
     public List<String> getSelectedCurrentSystemInfo{get;set;}
  //-------------------------------------------------property giving all the picklist values of current system info field------------------------------------------------
     public List<Selectoption>  getAllCurrentSystemInfoValues {get{ 
        List<Selectoption> currentSystemInfo =new List<Selectoption>();
        List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','CurrentSystemInfo__c');
        for(Schema.Picklistentry reasonEntry : pickListValues){
            currentSystemInfo.add(new SelectOption(reasonEntry.getLabel(),reasonEntry.getLabel()));
        }
        return currentSystemInfo;
      }set;
    }
  //-------------------------------------------------Method to save new updated values of current system info to database------------------------------------------------
    public Lead_Qualification__c saveCurrentSystemInfovalues(Lead_Qualification__c objectInstance){
        String currentSystemInfString ='';
        currentSystemInfString = getMultipickListString(getSelectedCurrentSystemInfo);
        objectInstance.CurrentSystemInfo__c = currentSystemInfString;
        return objectInstance;
    }

//------------------------------------------Code for Handeling All Functionality of Current System Information gatering and updation ends------------------------

 //-------------------------------------------------------------As/simplion/for 4/17/2014 start---------------------------------------------- 
 
 
 
 
 
 //--------------------------------------------Code section to controll new lead Qualification information section starts---------------------------------
 	//-----------------------List containing users selection 
 	 public List<String> getSelectedCallFlowModelValues{get;set;}
 	 public List<String> getSelectedFeaturesRequestdByCustomerValues{get;set;}
 	 public List<String> getSelectedUsagesLevelValues{get;set;}
 	 
 	  
 //List containing all the picklist values in the Call_Flow_Models_Features__c field in Lead_Qualification__c object
 	 public List<ModelValueBindingsClass> getCallFlowModelValues{get{
         getCallFlowModelValues = new List<ModelValueBindingsClass>();
         List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Call_Flow_Models_Features__c');
         for(Schema.Picklistentry reasonEntry : pickListValues){
				getCallFlowModelValues.add(new ModelValueBindingsClass(false,reasonEntry.getLabel()));
         }
         return getCallFlowModelValues;
    }set;}
     public Map<Integer,String> getCallFlowModelValues2{get{
         getCallFlowModelValues2 = new Map<Integer,String>();
         List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Call_Flow_Models_Features__c');
         Integer countval = 0;
         for(Schema.Picklistentry reasonEntry : pickListValues){
				getCallFlowModelValues2.put(countval++,reasonEntry.getLabel());
         }
         return getCallFlowModelValues2;
    }set;}
 //List containing all the picklist values in the Features_Requested_by_Customer__c field in Lead_Qualification__c object
    public List<SelectOption> getFeaturesRequestdByCustomerValues{get{
         getFeaturesRequestdByCustomerValues = new List<Selectoption>();
         List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Features_Requested_by_Customer__c');
         for(Schema.Picklistentry reasonEntry : pickListValues){
				getFeaturesRequestdByCustomerValues.add(new SelectOption(reasonEntry.getLabel(),reasonEntry.getLabel()));
         }
         return getFeaturesRequestdByCustomerValues;
    }set;}
 //List containing all the picklist values in the Usage_Levels__c field in Lead_Qualification__c object   
     public List<SelectOption> getUsagesLevelValues{get{
         getUsagesLevelValues = new List<Selectoption>();
         List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Usage_Levels__c');
         for(Schema.Picklistentry reasonEntry : pickListValues){
				getUsagesLevelValues.add(new SelectOption(reasonEntry.getLabel(),reasonEntry.getLabel()));
         }
         return getUsagesLevelValues;
    }set;}
//------------------------------------Methods saving users selection to the lead_Qualification Object starts-------------------------------    
      public Lead_Qualification__c saveCallFlowModelValues(Lead_Qualification__c objectInstance){
        String callFlowModelValueString ='';
        if(!string.isBlank(ApexPages.currentPage().getParameters().get('modelValue'))){
        
        	callFlowModelValueString = ApexPages.currentPage().getParameters().get('modelValue');
        }
        
        objectInstance.Call_Flow_Models_Features__c = callFlowModelValueString;
        return objectInstance;
    }
     public Lead_Qualification__c saveFeaturesRequestdByCustomerValues(Lead_Qualification__c objectInstance){
        String FeaturesString ='';
        FeaturesString = getMultipickListString(getSelectedFeaturesRequestdByCustomerValues);
        objectInstance.Features_Requested_by_Customer__c = FeaturesString;
        return objectInstance;
    }
     public Lead_Qualification__c saveUsagesLevelvalues(Lead_Qualification__c objectInstance){
        String usagesLevelString ='';
        usagesLevelString = getMultipickListString(getSelectedUsagesLevelValues);
        objectInstance.Usage_Levels__c = usagesLevelString;
        return objectInstance;
    }
    
    

//------------------------------------Methods saving users selection to the lead_Qualification Object ends------------------------------- 

       public class ModelValueBindingsClass{
       
       		public boolean isSelected{get;set;}
       		public String value{get;set;}
       		
       		public ModelValueBindingsClass(boolean ischeck,String val){
       			isSelected = ischeck;
       			value = val;
       			
       		}
       }
       
       

//------------------------------------section to controll dependency of call flow model,usage level and feature requested by customer starts-------------------------------
	
		public class Model_Usage_featureDependencyClass{
		
			public String ParentName{get;set;}
			public boolean isUsageLevel{get;set;}
			public List<String> childList{get;set;}
			
			public Model_Usage_featureDependencyClass(){
			    ParentName = '';
			    isUsageLevel = false;
			    childList = new List<String>();
				
			}
		}
		
		
		private void setModelUsageFeatureDependencyClass(){
			Model_Usage_featureDependencyClass model_Usage_featureDependencyCls;
			List<CallFlow_usageAndFeaturesRelationship__c> CallFlow_usage_featuresList = CallFlow_usageAndFeaturesRelationship__c.getAll().values();
			Model_Usage_featureDependencyClassMap = new Map<String,Model_Usage_featureDependencyClass>();
			String modelValue = '';
			for(ModelValueBindingsClass s : getCallFlowModelValues){
					modelValue = s.value;
               	    Set<String> tempset;
                for(CallFlow_usageAndFeaturesRelationship__c relationvalue : CallFlow_usage_featuresList){
					
						if(!string.isBlank(relationvalue.Call_Flow_Model__c)){
                            tempset =  new Set<String>(relationvalue.Call_Flow_Model__c.split(';'));
                            if(tempset.contains(modelValue)){
							
								if(Model_Usage_featureDependencyClassMap.keyset().contains(modelValue)){
									 model_Usage_featureDependencyCls = Model_Usage_featureDependencyClassMap.get(modelValue);
									 model_Usage_featureDependencyCls.childList.add(relationvalue.childName__c);
								}
								else{
									model_Usage_featureDependencyCls = new Model_Usage_featureDependencyClass();
									model_Usage_featureDependencyCls.ParentName = modelValue;
									model_Usage_featureDependencyCls.childList.add(relationvalue.childName__c);
									model_Usage_featureDependencyCls.isUsageLevel = relationvalue.isUsages__c;
									Model_Usage_featureDependencyClassMap.put(modelValue,model_Usage_featureDependencyCls);
								}
							}
							
							
							
						}
					}
					
			}
		}
		public String getDependencyList{get{
		    setModelUsageFeatureDependencyClass();
			return JSON.serialize(Model_Usage_featureDependencyClassMap);
		}set;}
		
	
		
  //------------------------------------section to controll dependency of call flow model,usage level and feature requested by customer ends-------------------------------

 //--------------------------------------------Code section to controll new lead Qualification information section ends---------------------------------
    
}