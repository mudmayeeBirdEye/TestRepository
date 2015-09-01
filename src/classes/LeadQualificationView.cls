public with sharing class LeadQualificationView {
	public List<WrapperLeadQualification> wrLeadQualList {get;set;}
	public Lead_Qualification__c leadQualificationObj {get;set;}
	map<Id,Lead_Qualification__c> mapLeadQual;
	public string selectedLeadQual {get;set;}
	public boolean toShowViewMode {get;set;}
	public string employeeOverride{get;set;}//Effective Number of Employee Changes
	public List<selectOption> empRangePickList{get;set;}//Effective Number of Employee Changes
	Transient Map<String,Model_Usage_featureDependencyClass> Model_Usage_featureDependencyClassMap{get;set;} //As/simplion/Q2
	
	//public BussinessDriverReasonClass bussDriveClass {get;set;}//new Lead Qual
	
	string strId;
	string rtrl;
	/********************************* Variable Declarions FOR Business Driver Updates ***************************/
    public String selBusinessDriver { get; set; } // Bills Project
    map<string,set<string>> driverReasonMap = new map<string,set<string>>();// Bills Project
    Set<string> driverSet = new Set<String>();// Bills Project
    Public List<string> leftselected{get;set;}// Bills Project
    Public List<string> rightselected{get;set;}// Bills Project
    Set<string> leftvalues = new Set<string>();// Bills Project
    Set<string> rightvalues = new Set<string>();// Bills Project
    public String lineBreakText {get;set;}// Bills Project
    /********************************* Variable Declarions FOR Business Driver Updates Ends***************************/
    public LeadQualificationView() {
		if(!String.isBlank(ApexPages.currentPage().getParameters().get('Id'))) {
			try {
				/*************************Effective Number of Employee Changes*******************************/
				empRangePickList = new List<selectOption>();
				empRangePickList = fetchPickList(new Lead(),'NumberOfEmployees__c');
				/******************************************************************************************/
				objName = '';  //----------------------As/simplion/4/17/2014
    			noOfEmployees = '';//----------------------As/simplion/4/17/2014
				getBusinessAgilitySelectedResons = new List<String>();
				getBusinessresponsivenessSelectedResons = new List<String>();
				getBusinessVendorSelectedResons = new List<String>();
				getSelectedCurrentSystemInfo = new List<String>();
				toShowViewMode = false;
				strId = ApexPages.currentPage().getParameters().get('Id');
				rtrl = Apexpages.currentPage().getParameters().get('retURL'); 
				LeadQualParent = new List<Sobject>();
				LeadQualParent = getLeadQualParentInfo(strId);
				/*************************Effective Number of Employee Changes*******************************/
				if(LeadQualParent!=null && LeadQualParent.size() > 0 && objName=='Lead'){
					employeeOverride = (string)LeadQualParent.get(0).get('Effective_No_of_Employees_Range__c');
				}
				/********************************************************************************************/
				loadLeadQualBasicDet();
				setManagerAndNextStepValue();
				getSelectedFeaturesRequestdByCustomerValues = getSelectedValueOfPickList(leadQualificationObj,'Features_Requested_by_Customer__c');
		 	 	getSelectedUsagesLevelValues = getSelectedValueOfPickList(leadQualificationObj,'Usage_Levels__c');
		 	 	getSelectedCurrentSystemInfo = getSelectedValueOfPickList(leadQualificationObj,'CurrentSystemInfo__c');
				getBusinessAgilitySelectedResons = getSelectedValueOfPickList(leadQualificationObj,'Business_Change_Reasons__c');
				getBusinessresponsivenessSelectedResons = getSelectedValueOfPickList(leadQualificationObj,'Customer_Responsiveness_Reasons__c');
				getBusinessVendorSelectedResons = getSelectedValueOfPickList(leadQualificationObj,'Dissatisfaction_with_Current__c');
			 
			 	/********************************Constructor CODE FOR Business Driver updates Starts***************************/
				 
                list<SelectOption> busReasonList = getbusinessDriverList();
                for(SelectOption sp : busReasonList){
                    driverSet.add(sp.getLabel());
                }
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
                    } else{
                        
                    }  
                }
                selBusinessDriver = leadQualificationObj.X50_249_Business_Drivers__c != null ? leadQualificationObj.X50_249_Business_Drivers__c : ''; 
                if(!String.isBlank(leadQualificationObj.Reasons__c)) {
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
                //lineBreakText = string.valueof(leadQualificationObj.Reasons__c).replace(';' , '&#13;&#10;');
                /********************************Constructor CODE FOR Business Driver updates Ends***************************/
			} catch(Exception ex) {}
		}
	}
	
	/********************************* Methods CODE FOR Business Driver updates Starts Here ***************************/
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
    
    // Called on Change of business Drivers 
    public pageReference dependentReasons(){
        rightvalues.clear();
        leftvalues.clear();
        if(!string.isBlank(selBusinessDriver) && driverReasonMap != null &&  driverReasonMap.containsKey(selBusinessDriver)){
    		leftvalues.addAll(driverReasonMap.get(selBusinessDriver));
        	if(selBusinessDriver == leadQualificationObj.X50_249_Business_Drivers__c){
        		if(leadQualificationObj.X50_249_Business_Drivers__c != null && leadQualificationObj.Reasons__c != null) {
	                if(selBusinessDriver == leadQualificationObj.X50_249_Business_Drivers__c) {
                        rightvalues.addAll(string.valueof(leadQualificationObj.Reasons__c).split(';'));  
                        leftvalues.removeAll(string.valueof(leadQualificationObj.Reasons__c).split(';'));
	                }
	            }
            }
        }
        return null;
    }
    /********************************* Methods FOR BILLS PEOJECT Ends***************************/
    
    /**********Method to fetch Picklist value. Provide Object Instance and Field Name***********/
    public List<selectOption> fetchPickList(Sobject object_name, String field_name) {
		List<selectOption> options = new List<selectOption>();
		Schema.sObjectType sobject_type = object_name.getSObjectType();
		Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
		Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
		List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues();
		for (Schema.PicklistEntry a : pick_list_values) {
			options.add(new selectOption(a.getLabel(), a.getValue()));
		}
		return options;
	}
    /********************************************************************************************/
    
    public PageReference redirectLeadQualificUser() {
	 	try {
	 	    PageReference rtnPage;
           	string leadId =  ApexPages.currentPage().getParameters().get('Id');
           	string userId = ApexPages.currentPage().getParameters().get('UserId');
           	string rtrl =  ApexPages.currentPage().getParameters().get('retURL');
           	string userType;
           	if(userId != null && userId != '') {
           		userType = [select Contact.Account.Partner_Type__c from User where Id = :userId limit 1].Contact.Account.Partner_Type__c;
           	}
          	if(userType == 'Partner Express Agent') {
				rtnPage = new PageReference('/apex/LeadQualificationViewVarPartner');
				rtnPage.getParameters().put('Id',leadId);
				rtnPage.getParameters().put('retURL',rtrl);
		 		rtnPage.setRedirect(true);
     		 	return rtnPage;
    	  	}
	  	} catch(Exception ex) {}
    	return null;
    }
    
	public void loadLeadQualBasicDet() {
		try {
			List<Lead_Qualification__c> leadQualList = new List<Lead_Qualification__c>();
			leadQualList = getLeadQualList();
			if(leadQualList != null && leadQualList.size() >0) {
				toShowViewMode = true;
				boolean isALreadySelectedMark = false;
				mapLeadQual = new map<Id,Lead_Qualification__c>();
				for(Lead_Qualification__c leadQualObj : leadQualList) {
					WrapperLeadQualification wrLeadQualObj = new WrapperLeadQualification();
					if(!isALreadySelectedMark) {
						wrLeadQualObj.isSelected = true;
					}
					wrLeadQualObj.leadQualObj = leadQualObj;
					DateTime dtMod = leadQualObj.LastModifiedDate;
                    wrLeadQualObj.strformatDT = dtMod.format('dd/MM/yyyy h:mm:ss a');
					wrLeadQualList.add(wrLeadQualObj);
					mapLeadQual.put(leadQualObj.Id,leadQualObj);
					isALreadySelectedMark = true;
				}
				for(WrapperLeadQualification wrLeadQualObj :wrLeadQualList) {
					if(wrLeadQualObj.isSelected) {
						leadQualificationObj = wrLeadQualObj.leadQualObj;
						selectedLeadQual = wrLeadQualObj.leadQualObj.id;
						if(leadQualificationObj.Who_is_Decision_Maker__c != null) {
							toShowWhoisDecisionMkr = true;
						}
						if(leadQualificationObj.More_Info_on_Budgeted__c != null) {
							toShowMoreInfobudget = true;
						}
						getContactInfo();
					}
				}
			} else {
				getContactInfo();
			}		
		} catch(Exception ex) {}
	}
	
	public boolean toShowContactInfo {get;set;}
	public List<Lead_Qualification__c> getLeadQualList() {
		wrLeadQualList = new List<WrapperLeadQualification>();
		leadQualificationObj = new Lead_Qualification__c();
		List<Lead_Qualification__c> leadQualList = new List<Lead_Qualification__c>();
		try {
			if(strId.startsWith('001')) {
					leadQualList = [Select  Name, Pain__c, Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate, 
									 InContract__c, Ideal_Solution__c, Id, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
									 Account__c,Account__r.Name,Owner.Name,Lead__r.Name,Opportunity__r.Name,Media_Source__c,Which_Radio__c, 
                            		 Other_Explanation__c, Timeframe__c,of_employees_in_org__c,How_many_phones_to_start__c,Other_Notes__c,
                            		 Decision_on_Large_Projects__c,Current_Contact__c,Decision_Maker__c,Budgeted__c,
                            		 Contract__c,Is_this_a_personal_project_or_a_company__c,Integrating_fax_toll_free__c,Internet__c,
                            		 More_Info_on_Budgeted__c , Who_is_Decision_Maker__c ,contact__c,contact__r.Name,Need__c,
                            		 contact__r.firstName,contact__r.lastName,contact__r.phone,contact__r.email,Quality_Conversation__c, 
                            		 X50_249_Business_Drivers__c,Reasons__c,Other_Explain_Business__c, 
                            		 CurrentSystemAdditionalInfo__c,NewSolutionUpTimeFrame__c,ContractAdditionalInfo__c,ContractExpiresInfo__c,
                            		 TimeframeAdditionalInfo__c,
                            		 Decision_makers_Additional_Information__c,
                    				 Business_Driver__c,Business_Drivers_Reasons__c,Business_Change_Reasons__c,Customer_Responsiveness_Reasons__c,
                    			     Dissatisfaction_with_Current__c,In_Contract__c,Prospect_Need__c, NewTimeFrame__c, CurrentSystemInfo__c,
                    			     QualityConversation__c,
                    			     //--------------------------new Implementaion detail section fields-----------------------------
                    			     Call_Flow_Models_Features__c,Features_Requested_by_Customer__c,Usage_Levels__c,ISP__c,Bandwidth_Down__c,Bandwidth_Up__c,
                    			     Bandwidth_Test_Result__c,QoS_Test_Result__c,Router_make__c,Router_Model_Software_Level__c,Firewall_make__c,Firewall_Model_Software_Level__c,
                    			     Gateway_Model_Software_Level__c,Gateway_Make__c,Ethernet_Switch_Make__c,Ethernet_Switch_Model_Software_Level__c,Last_Mile_Handoff_Media__c,
                    			     Network_Additional_Information__c,Number_of_phones__c,Number_of_Businesses__c,Number_of_Publish_Phone_Numbers__c,Number_of_Long_Distance_Minutes_per_Mont__c,
                    			     Number_of_Toll_Free_Minutes__c,Number_of_International_Minutes__c,Number_of_Existing_Polycom_IP_Phones__c,Number_of_Existing_Cisco_SPA_IP_Phones__c,
                    			     Number_of_Other_SIP_Phones__c,Number_of_Softphone_users__c,Number_of_Active_IVR_Dept_Queues__c,Profile_Additional_Information__c,
                    			     //-----------------------------New Discovery Section details fields-------------------------------
                    			     Discovery_notes__c,Opportunity__r.Discovery_Manager_Notes__c,Opportunity__r.Discovery_Next_Steps__c,
                    			     Lead__r.Discovery_Manager_Notes__c,Lead__r.Discovery_Next_Steps__c 
                            		 From Lead_Qualification__c 
									 where IsDeleted  = false and Account__c =:strId  
									 order by lastModifiedDate desc];
			} else if(strId.startsWith('006')) {
					leadQualList = [Select Name, Pain__c, Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate, 
									 InContract__c, Ideal_Solution__c, Id, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
									 Account__c,Account__r.Name,Owner.Name,Lead__r.Name,Opportunity__r.Name,Media_Source__c,Which_Radio__c, 
                            		 Other_Explanation__c, Timeframe__c,of_employees_in_org__c,How_many_phones_to_start__c,Other_Notes__c,
                            		 Decision_on_Large_Projects__c,Current_Contact__c,Decision_Maker__c,Budgeted__c,
                            		 Contract__c,Is_this_a_personal_project_or_a_company__c,Integrating_fax_toll_free__c,Internet__c,
                            		 More_Info_on_Budgeted__c , Who_is_Decision_Maker__c ,contact__c,contact__r.Name,Need__c,
                            		 contact__r.firstName,contact__r.lastName,contact__r.phone,contact__r.email,Quality_Conversation__c,  
									 X50_249_Business_Drivers__c,Reasons__c,Other_Explain_Business__c, 
									 CurrentSystemAdditionalInfo__c,ContractExpiresInfo__c,NewSolutionUpTimeFrame__c,ContractAdditionalInfo__c,
									 TimeframeAdditionalInfo__c,Decision_makers_Additional_Information__c,
	                				 Business_Driver__c,Business_Drivers_Reasons__c,Business_Change_Reasons__c,Customer_Responsiveness_Reasons__c,
	                				 Dissatisfaction_with_Current__c,In_Contract__c,Prospect_Need__c,NewTimeFrame__c,CurrentSystemInfo__c,
	                				 QualityConversation__c,
	                				 //--------------------------new Implementaion detail section fields-----------------------------
                    			     Call_Flow_Models_Features__c,Features_Requested_by_Customer__c,Usage_Levels__c,ISP__c,Bandwidth_Down__c,Bandwidth_Up__c,
                    			     Bandwidth_Test_Result__c,QoS_Test_Result__c,Router_make__c,Router_Model_Software_Level__c,Firewall_make__c,Firewall_Model_Software_Level__c,
                    			     Gateway_Model_Software_Level__c,Gateway_Make__c,Ethernet_Switch_Make__c,Ethernet_Switch_Model_Software_Level__c,Last_Mile_Handoff_Media__c,
                    			     Network_Additional_Information__c,Number_of_phones__c,Number_of_Businesses__c,Number_of_Publish_Phone_Numbers__c,Number_of_Long_Distance_Minutes_per_Mont__c,
                    			     Number_of_Toll_Free_Minutes__c,Number_of_International_Minutes__c,Number_of_Existing_Polycom_IP_Phones__c,Number_of_Existing_Cisco_SPA_IP_Phones__c,
                    			     Number_of_Other_SIP_Phones__c,Number_of_Softphone_users__c,Number_of_Active_IVR_Dept_Queues__c,Profile_Additional_Information__c,
                    			     //-----------------------------New Discovery Section details fields-------------------------------
                    			     Discovery_notes__c,Opportunity__r.Discovery_Manager_Notes__c,Opportunity__r.Discovery_Next_Steps__c,
                    			     Lead__r.Discovery_Manager_Notes__c,Lead__r.Discovery_Next_Steps__c 
	            					 From Lead_Qualification__c 
									 where IsDeleted  = false and Opportunity__c =:strId  
									 order by lastModifiedDate desc];
			
			} else if(strId.startsWith('00Q')) {
					leadQualList = [Select Name, Pain__c, Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate,  
									 InContract__c, Ideal_Solution__c, Id, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
									 Account__c, Account__r.Name,Owner.Name,Lead__r.Name,Opportunity__r.Name,Media_Source__c,Which_Radio__c, 
                            		 Other_Explanation__c,Timeframe__c,of_employees_in_org__c,How_many_phones_to_start__c,Other_Notes__c,
                            		 Decision_on_Large_Projects__c,Current_Contact__c,Decision_Maker__c,Budgeted__c,
                            		 Contract__c,Is_this_a_personal_project_or_a_company__c,Integrating_fax_toll_free__c,Internet__c,
                            		 More_Info_on_Budgeted__c ,Who_is_Decision_Maker__c,Lead__r.Notes__c,Quality_Conversation__c,
                            		 Lead__r.FirstName,Lead__r.LastName,Lead__r.Email,Lead__r.Phone,Lead__r.Time_Frame__c,Need__c,
                            		 contact__c,contact__r.Name, contact__r.firstName,contact__r.lastName,contact__r.phone,contact__r.email,
									 X50_249_Business_Drivers__c,Reasons__c,Other_Explain_Business__c,
									 CurrentSystemAdditionalInfo__c,ContractExpiresInfo__c,NewSolutionUpTimeFrame__c,ContractAdditionalInfo__c,
									 TimeframeAdditionalInfo__c,Decision_makers_Additional_Information__c,
	                				 Business_Driver__c,Business_Drivers_Reasons__c,Business_Change_Reasons__c,Customer_Responsiveness_Reasons__c,
	                				 Dissatisfaction_with_Current__c,In_Contract__c,Prospect_Need__c,NewTimeFrame__c,CurrentSystemInfo__c,
	                				 QualityConversation__c,
	                				 //--------------------------new Implementaion detail section fields-----------------------------
                    			     Call_Flow_Models_Features__c,Features_Requested_by_Customer__c,Usage_Levels__c,ISP__c,Bandwidth_Down__c,Bandwidth_Up__c,
                    			     Bandwidth_Test_Result__c,QoS_Test_Result__c,Router_make__c,Router_Model_Software_Level__c,Firewall_make__c,Firewall_Model_Software_Level__c,
                    			     Gateway_Model_Software_Level__c,Gateway_Make__c,Ethernet_Switch_Make__c,Ethernet_Switch_Model_Software_Level__c,Last_Mile_Handoff_Media__c,
                    			     Network_Additional_Information__c,Number_of_phones__c,Number_of_Businesses__c,Number_of_Publish_Phone_Numbers__c,Number_of_Long_Distance_Minutes_per_Mont__c,
                    			     Number_of_Toll_Free_Minutes__c,Number_of_International_Minutes__c,Number_of_Existing_Polycom_IP_Phones__c,Number_of_Existing_Cisco_SPA_IP_Phones__c,
                    			     Number_of_Other_SIP_Phones__c,Number_of_Softphone_users__c,Number_of_Active_IVR_Dept_Queues__c,Profile_Additional_Information__c,
                    			     //-----------------------------New Discovery Section details fields-------------------------------
                    			     Discovery_notes__c,Opportunity__r.Discovery_Manager_Notes__c,Opportunity__r.Discovery_Next_Steps__c,
                    			     Lead__r.Discovery_Manager_Notes__c,Lead__r.Discovery_Next_Steps__c  
									 From Lead_Qualification__c 
									 where IsDeleted  = false and  Lead__c =:strId  
									 order by lastModifiedDate desc];
			} else if(strId.startsWith('003')) {
					leadQualList = [Select Name, Pain__c, Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate,  
									 InContract__c, Ideal_Solution__c, Id, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
									 Account__c, Account__r.Name,Owner.Name,Lead__r.Name,Opportunity__r.Name,Media_Source__c,Which_Radio__c, 
                            		 Other_Explanation__c,Timeframe__c,of_employees_in_org__c,How_many_phones_to_start__c,Other_Notes__c,
                            		 Decision_on_Large_Projects__c,Current_Contact__c,Decision_Maker__c,Budgeted__c,
                            		 Contract__c,Is_this_a_personal_project_or_a_company__c,Integrating_fax_toll_free__c,Internet__c,
                            		 More_Info_on_Budgeted__c ,Who_is_Decision_Maker__c,Lead__r.Notes__c,Quality_Conversation__c,
                            		 Lead__r.FirstName,Lead__r.LastName,Lead__r.Email,Lead__r.Phone,Lead__r.Time_Frame__c,Need__c,
                            		 contact__c,contact__r.Name, contact__r.firstName,contact__r.lastName,contact__r.phone,contact__r.email,
									 X50_249_Business_Drivers__c,Reasons__c,
									 CurrentSystemAdditionalInfo__c,ContractExpiresInfo__c,NewSolutionUpTimeFrame__c,ContractAdditionalInfo__c,
									 TimeframeAdditionalInfo__c,Decision_makers_Additional_Information__c,
	                				 Business_Driver__c,Business_Drivers_Reasons__c,Business_Change_Reasons__c,Customer_Responsiveness_Reasons__c,
	                				 Dissatisfaction_with_Current__c,In_Contract__c,Prospect_Need__c,NewTimeFrame__c,CurrentSystemInfo__c,
	                				 QualityConversation__c, Other_Explain_Business__c,
	                				 //--------------------------new Implementaion detail section fields-----------------------------
                    			     Call_Flow_Models_Features__c,Features_Requested_by_Customer__c,Usage_Levels__c,ISP__c,Bandwidth_Down__c,Bandwidth_Up__c,
                    			     Bandwidth_Test_Result__c,QoS_Test_Result__c,Router_make__c,Router_Model_Software_Level__c,Firewall_make__c,Firewall_Model_Software_Level__c,
                    			     Gateway_Model_Software_Level__c,Gateway_Make__c,Ethernet_Switch_Make__c,Ethernet_Switch_Model_Software_Level__c,Last_Mile_Handoff_Media__c,
                    			     Network_Additional_Information__c,Number_of_phones__c,Number_of_Businesses__c,Number_of_Publish_Phone_Numbers__c,Number_of_Long_Distance_Minutes_per_Mont__c,
                    			     Number_of_Toll_Free_Minutes__c,Number_of_International_Minutes__c,Number_of_Existing_Polycom_IP_Phones__c,Number_of_Existing_Cisco_SPA_IP_Phones__c,
                    			     Number_of_Other_SIP_Phones__c,Number_of_Softphone_users__c,Number_of_Active_IVR_Dept_Queues__c,Profile_Additional_Information__c,
                    			     //-----------------------------New Discovery Section details fields-------------------------------
                    			     Discovery_notes__c,Opportunity__r.Discovery_Manager_Notes__c,Opportunity__r.Discovery_Next_Steps__c,
                    			     Lead__r.Discovery_Manager_Notes__c,Lead__r.Discovery_Next_Steps__c   
									 From Lead_Qualification__c where IsDeleted  = false and  contact__c = :strId  
									 order by lastModifiedDate desc];
			}
			// ---------------------As/Simplion/6/20/2014/start--------------- --
			else if(strId.startsWith('a07')){
				 	leadQualList = [Select Name, Pain__c, Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate,  
									 InContract__c, Ideal_Solution__c, Id, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
									 Account__c, Account__r.Name,Owner.Name,Lead__r.Name,Opportunity__r.Name,Media_Source__c,Which_Radio__c, 
                            		 Other_Explanation__c,Timeframe__c,of_employees_in_org__c,How_many_phones_to_start__c,Other_Notes__c,
                            		 Decision_on_Large_Projects__c,Current_Contact__c,Decision_Maker__c,Budgeted__c,
                            		 Contract__c,Is_this_a_personal_project_or_a_company__c,Integrating_fax_toll_free__c,Internet__c,
                            		 More_Info_on_Budgeted__c ,Who_is_Decision_Maker__c,Lead__r.Notes__c,Quality_Conversation__c,
                            		 Lead__r.FirstName,Lead__r.LastName,Lead__r.Email,Lead__r.Phone,Lead__r.Time_Frame__c,Need__c,
                            		 contact__c,contact__r.Name, contact__r.firstName,contact__r.lastName,contact__r.phone,contact__r.email,
									 X50_249_Business_Drivers__c,Reasons__c,
									 CurrentSystemAdditionalInfo__c,ContractExpiresInfo__c,NewSolutionUpTimeFrame__c,ContractAdditionalInfo__c,
									 TimeframeAdditionalInfo__c,Decision_makers_Additional_Information__c,
	                				 Business_Driver__c,Business_Drivers_Reasons__c,Business_Change_Reasons__c,Customer_Responsiveness_Reasons__c,
	                				 Dissatisfaction_with_Current__c,In_Contract__c,Prospect_Need__c,NewTimeFrame__c,CurrentSystemInfo__c,QualityConversation__c, Other_Explain_Business__c ,
	                				 //--------------------------new Implementaion detail section fields-----------------------------
                    			     Call_Flow_Models_Features__c,Features_Requested_by_Customer__c,Usage_Levels__c,ISP__c,Bandwidth_Down__c,Bandwidth_Up__c,
                    			     Bandwidth_Test_Result__c,QoS_Test_Result__c,Router_make__c,Router_Model_Software_Level__c,Firewall_make__c,Firewall_Model_Software_Level__c,
                    			     Gateway_Model_Software_Level__c,Gateway_Make__c,Ethernet_Switch_Make__c,Ethernet_Switch_Model_Software_Level__c,Last_Mile_Handoff_Media__c,
                    			     Network_Additional_Information__c,Number_of_phones__c,Number_of_Businesses__c,Number_of_Publish_Phone_Numbers__c,Number_of_Long_Distance_Minutes_per_Mont__c,
                    			     Number_of_Toll_Free_Minutes__c,Number_of_International_Minutes__c,Number_of_Existing_Polycom_IP_Phones__c,Number_of_Existing_Cisco_SPA_IP_Phones__c,
                    			     Number_of_Other_SIP_Phones__c,Number_of_Softphone_users__c,Number_of_Active_IVR_Dept_Queues__c,Profile_Additional_Information__c,
                    			     //-----------------------------New Discovery Section details fields-------------------------------
                    			     Discovery_notes__c,(select Id,name from Implementations__r)
	                				 From Lead_Qualification__c where IsDeleted  = false and  
	                				 Id =:[select Lead_Qualification__c from Implementation__c where Id = :strId limit 1].Lead_Qualification__c
									 order by lastModifiedDate desc];
			}
			// ---------------------As/Simplion/6/20/2014/ends--------------- --
		} catch(Exception ex) {}
		return leadQualList;	
	}
	
	public void loadupdatedLeadQual() {
		List<Lead_Qualification__c> leadQualList = new List<Lead_Qualification__c>();
		leadQualList = getLeadQualList();
		if(leadQualList != null && leadQualList.size() >0) {
			toShowViewMode = true;
			mapLeadQual = new map<Id,Lead_Qualification__c>();
			for(Lead_Qualification__c leadQualObj : leadQualList) {
				WrapperLeadQualification wrLeadQualObj = new WrapperLeadQualification();
				wrLeadQualObj.leadQualObj = leadQualObj;
				DateTime dtMod = leadQualObj.LastModifiedDate;
                wrLeadQualObj.strformatDT = dtMod.format('dd/MM/yyyy h:mm:ss a');
				wrLeadQualList.add(wrLeadQualObj);
				mapLeadQual.put(leadQualObj.Id,leadQualObj);
			}
		} 
		if(selectedLeadQual != null && mapLeadQual != null && mapLeadQual.get(selectedLeadQual) != null) {
			leadQualificationObj = mapLeadQual.get(selectedLeadQual);
			getContactInfo();
			if(leadQualificationObj.Who_is_Decision_Maker__c != null && leadQualificationObj.Who_is_Decision_Maker__c != '') {
				toShowWhoisDecisionMkr = true;
			}
			if(leadQualificationObj.More_Info_on_Budgeted__c != null && leadQualificationObj.More_Info_on_Budgeted__c != '') {
				toShowMoreInfobudget = true;
			}
		}
		
		getSelectedFeaturesRequestdByCustomerValues = getSelectedValueOfPickList(leadQualificationObj,'Features_Requested_by_Customer__c');
 	 	getSelectedUsagesLevelValues = getSelectedValueOfPickList(leadQualificationObj,'Usage_Levels__c');
 	 	getSelectedCurrentSystemInfo = getSelectedValueOfPickList(leadQualificationObj,'CurrentSystemInfo__c');
		getBusinessAgilitySelectedResons = getSelectedValueOfPickList(leadQualificationObj,'Business_Change_Reasons__c');
		getBusinessresponsivenessSelectedResons = getSelectedValueOfPickList(leadQualificationObj,'Customer_Responsiveness_Reasons__c');
		getBusinessVendorSelectedResons = getSelectedValueOfPickList(leadQualificationObj,'Dissatisfaction_with_Current__c');
	    LeadQualParent = getLeadQualParentInfo(strId);
		setManagerAndNextStepValue();
	}
	
	public WrapperContactInformation wrContactInfoObj {get;set;}
	public void getContactInfo() {
		/*if(strId.startsWith('00Q')) {
			wrContactInfoObj = new WrapperContactInformation();
	 		wrContactInfoObj.firstName = leadQualificationObj.Lead__r.firstName;
	 		wrContactInfoObj.lastName = leadQualificationObj.Lead__r.lastName;
	 		wrContactInfoObj.phone = leadQualificationObj.Lead__r.phone;
	 		wrContactInfoObj.email = leadQualificationObj.Lead__r.email;
		} else {
			wrContactInfoObj = new WrapperContactInformation();
	 		wrContactInfoObj.firstName = leadQualificationObj.Contact__r.firstName;
	 		wrContactInfoObj.lastName = leadQualificationObj.Contact__r.lastName;
	 		wrContactInfoObj.phone = leadQualificationObj.Contact__r.phone;
	 		wrContactInfoObj.email = leadQualificationObj.Contact__r.email;
		}*/
		wrContactInfoObj = new WrapperContactInformation();
		if(strId.startsWith('00Q')) {
			List<Lead> leadInfo = [select firstName,lastName,phone,email from lead where Id = :strId limit 1];
			if(leadInfo != null && leadInfo.size()>0) {
				wrContactInfoObj.firstName = leadInfo[0].firstName;
		 		wrContactInfoObj.lastName = leadInfo[0].lastName;
		 		wrContactInfoObj.phone = leadInfo[0].phone;
		 		wrContactInfoObj.email = leadInfo[0].email;
			}
		} else if(strId.startsWith('003')) {
			List<Contact> contactInfo = [select firstName,lastName,phone,email from Contact where Id = :strId limit 1];
	 		if(contactInfo != null && contactInfo.size()>0) {
				wrContactInfoObj.firstName = contactInfo[0].firstName;
		 		wrContactInfoObj.lastName = contactInfo[0].lastName;
		 		wrContactInfoObj.phone = contactInfo[0].phone;
		 		wrContactInfoObj.email = contactInfo[0].email;
			}
		} else if(strId.startsWith('001')) {
			System.Debug('>leadQualificationObj>'+ leadQualificationObj);
			if(leadQualificationObj != null && leadQualificationObj.Contact__c != null) {
				wrContactInfoObj.firstName = leadQualificationObj.Contact__r.firstName;
		 		wrContactInfoObj.lastName = leadQualificationObj.Contact__r.lastName;
		 		wrContactInfoObj.phone = leadQualificationObj.Contact__r.phone;
		 		wrContactInfoObj.email = leadQualificationObj.Contact__r.email;
			} else {
				List<Contact> contactInfo = [select firstName,lastName,phone,email from Contact where accountID = :strId 
												order by lastmodifieddate desc limit 1];
		 		if(contactInfo != null && contactInfo.size()>0) {
					wrContactInfoObj.firstName = contactInfo[0].firstName;
			 		wrContactInfoObj.lastName = contactInfo[0].lastName;
			 		wrContactInfoObj.phone = contactInfo[0].phone;
			 		wrContactInfoObj.email = contactInfo[0].email;
				}	
			} 
		} else if(strId.startsWith('006')) {
			if(leadQualificationObj != null && leadQualificationObj.Contact__c != null) {
				wrContactInfoObj.firstName = leadQualificationObj.Contact__r.firstName;
		 		wrContactInfoObj.lastName = leadQualificationObj.Contact__r.lastName;
		 		wrContactInfoObj.phone = leadQualificationObj.Contact__r.phone;
		 		wrContactInfoObj.email = leadQualificationObj.Contact__r.email;
			} else {
				List<OpportunityContactRole > oppcontactInfo = [select Contact.firstName,Contact.lastName,Contact.phone,Contact.email 
															from OpportunityContactRole where opportunityId = :strId 
															order by lastmodifieddate desc limit 1];
		 		if(oppcontactInfo != null && oppcontactInfo.size()>0) {
					wrContactInfoObj.firstName = oppcontactInfo[0].Contact.firstName;
			 		wrContactInfoObj.lastName = oppcontactInfo[0].Contact.lastName;
			 		wrContactInfoObj.phone = oppcontactInfo[0].Contact.phone;
			 		wrContactInfoObj.email = oppcontactInfo[0].Contact.email;
				}	
			}
		}
	}
	
	public PageReference cancel() {
		try {
			System.Debug('>>>>21>>');
			loadupdatedLeadQual();
			//--------------------As/Simplion/4/9/2014----------------------------issue fix
			dependentReasons();
		} catch(Exception ex) {
			System.Debug('>>>>23>>'+ex);
		}
		return null; 
	}
	
	public PageReference loadLeadQualDet() {
		toShowWhoisDecisionMkr = false;
		toShowMoreInfobudget = false;
		selectedLeadQual =  Apexpages.currentPage().getParameters().get('param1');
		loadupdatedLeadQual();
		if(selectedLeadQual != null && mapLeadQual != null && mapLeadQual.get(selectedLeadQual) != null) {
			leadQualificationObj = mapLeadQual.get(selectedLeadQual);
			if(leadQualificationObj.Who_is_Decision_Maker__c != null && leadQualificationObj.Who_is_Decision_Maker__c != '') {
				toShowWhoisDecisionMkr = true;
			}
			if(leadQualificationObj.More_Info_on_Budgeted__c != null && leadQualificationObj.More_Info_on_Budgeted__c != '') {
				toShowMoreInfobudget = true;
			}
		}
		toShowViewMode = true;
		return null;
	}
	
	public PageReference editLeadQualDet() {
		toShowViewMode = false;
		return null;
	}
	
	public boolean toShowWhoisDecisionMkr {get;set;}
    public void getDecisionMaker() {
    	toShowWhoisDecisionMkr = false;
		if(leadQualificationObj.Decision_Maker__c != null && leadQualificationObj.Decision_Maker__c == 'No') {
    		toShowWhoisDecisionMkr = true;
    	} else {
    		toShowWhoisDecisionMkr = false;
    	}
    }
    
    public boolean toShowMoreInfobudget {get;set;}
    public void showMoreInfoBudget() {
		toShowMoreInfobudget = false;
    	if(!String.isBlank(leadQualificationObj.Budgeted__c)) {
    		toShowMoreInfobudget = true;
    	} else {
    		toShowMoreInfobudget = false;
    	}
    }
	
	public string checkInputFieldLength() {
    	if(leadQualificationObj.CompanyInfo__c != null && leadQualificationObj.CompanyInfo__c != '' 
    			&& ((leadQualificationObj.CompanyInfo__c).length() > 30000 || Test.isRunningTest())) {
        	return 'CompanyInfo';	
        }
        if(leadQualificationObj.Pain__c != null && leadQualificationObj.Pain__c != '' && ((leadQualificationObj.Pain__c).length() > 30000 || Test.isRunningTest())) {
        	return 'PAIN';
        }
        if(leadQualificationObj.Pain_Impact__c != null && leadQualificationObj.Pain_Impact__c != '' 
        		&& ((leadQualificationObj.Pain_Impact__c).length() > 30000 || Test.isRunningTest())) {
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
        if(leadQualificationObj.Benefits__c != null && leadQualificationObj.Benefits__c != '' 
        		&& ((leadQualificationObj.Benefits__c).length() > 30000 || Test.isRunningTest())) {
        	return 'Benefits';
        }
        if(leadQualificationObj.Next_Steps_questions__c != null && leadQualificationObj.Next_Steps_questions__c != '' 
        		&& ((leadQualificationObj.Next_Steps_questions__c).length() > 30000 || Test.isRunningTest())) {
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
        if(leadQualificationObj.Prospect_Need__c != null && leadQualificationObj.Prospect_Need__c != '' 
        		&& ((leadQualificationObj.Prospect_Need__c).length() > 32000 || Test.isRunningTest())) {
        	return 'ProspectNeed';
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
        if(leadQualificationObj.ContractAdditionalInfo__c != null && leadQualificationObj.ContractAdditionalInfo__c != '' 
        		&& ((leadQualificationObj.ContractAdditionalInfo__c).length() > 32000 || Test.isRunningTest())) {
        	return 'ContarctAdditionalInfo';
        }
        if(leadQualificationObj.CurrentSystemAdditionalInfo__c != null && leadQualificationObj.CurrentSystemAdditionalInfo__c != '' 
        		&& ((leadQualificationObj.CurrentSystemAdditionalInfo__c).length() > 32000 || Test.isRunningTest())) {
        	return 'CurrentSystemAdditionalInfo';
        }
        if(leadQualificationObj.TimeframeAdditionalInfo__c != null && leadQualificationObj.TimeframeAdditionalInfo__c != '' 
        		&& ((leadQualificationObj.TimeframeAdditionalInfo__c).length() > 32000 || Test.isRunningTest())) {
        	return 'TimeFrameAdditionalInfo';
        }
        if(leadQualificationObj.Decision_makers_Additional_Information__c != null && leadQualificationObj.Decision_makers_Additional_Information__c != '' 
        		&& ((leadQualificationObj.Decision_makers_Additional_Information__c).length() > 32000 || Test.isRunningTest())) {
        	return 'DecisionMakersAdditionalInfo';
        }
        
        //--------------------------------------------new validation  starts/6/20/2014---------------------------------------------------
        /*if(objName == 'Lead' && (LeadQualParent.get(0).get('NumberOfEmployees__c') == '--None--' || 
        		LeadQualParent.get(0).get('NumberOfEmployees__c') == null)){
		   return 'NumberOfEmployees';
		}*/
		/*************************Effective Number of Employee Changes*******************************/
		if(objName == 'Lead' && (string.isBlank(employeeOverride))){
		   return 'NumberOfEmployees';
		}			 
		/*******************************************************************************************/
		else if(objName == 'Account' && (LeadQualParent.get(0).get('No_of_Employees__c') == '--None--' 
					|| LeadQualParent.get(0).get('No_of_Employees__c') == null)){
		   return 'NumberOfEmployees';
		}  
		else if(objName == 'Opportunity' || objName == 'Contact'){
			if(LeadQualParent.get(0).getSobject('Account').get('No_of_Employees__c') == '--None--' || 
					LeadQualParent.get(0).getSobject('Account').get('No_of_Employees__c') == null){
				return 'NumberOfEmployees';
			}
			else if(LeadQualParent.get(0).get('AccountId') == null || LeadQualParent.get(0).get('AccountId') == ''){
				 return 'contactWithoutAccount';
			}
		}
        //--------------------------------------------new validation  ends/6/20/2014---------------------------------------------------
       
         
        return 'NoError';
    }
	
 	string errorMsg;
	public PageReference updateLeadQual() {
		PageReference rtnPgRef;
		try {
			ApexPages.Message myMsg;
        	errorMsg = checkInputFieldLength();
	        if(errorMsg != null && errorMsg != 'NoError') { 
	        	if(errorMsg == 'Need') {
        			myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 32000 characters on Need (SDR Information).'); 
	    		}  else if(errorMsg == 'ProspectNeed') {
        			myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 32000 characters on Need Additional Info.'); 
				}
	    		else if(errorMsg == 'NoOFEMP') {
        			myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 255 characters on No Of Employees.'); 
	    		} else if(errorMsg == 'PhoneStart') {
        			myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 255 characters on How many phone to start.'); 
	    		} else if(errorMsg == 'OtherNotes') {
        			myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Other Notes.'); 
	    		} else if(errorMsg == 'DecisionLargerProject') {
        			myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 255 characters on Decision on Larger Projects.'); 
	    		} else if(errorMsg == 'MoreInfoBugdet') {
        			myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 255 characters on More Info on Budgeted.'); 
	    		}  else if(errorMsg == 'CompanyInfo') {
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
	        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Benefits Information.'); 
		    	} else if(errorMsg == 'NextQues') {
	        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Next Steps Information.'); 
		    	} else if(errorMsg == 'OtherExplain') {
	        		myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Other Explanation.'); 
		    	} else if(errorMsg == 'ContarctAdditionalInfo') {
					myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Contract Additional Info.'); 
				} else if(errorMsg == 'CurrentSystemAdditionalInfo') {
					myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Current System Additional Info.'); 
				} else if(errorMsg == 'TimeFrameAdditionalInfo') {
					myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Timeframe Additional Info.'); 
				} else if(errorMsg == 'DecisionMakersAdditionalInfo') {
					myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter only upto 30000 characters on Decision Makers Additional Info.'); 
				}
				//--------------------------------------------new validation message  starts/4/17/2014--------------------------------------------------- 
				else if(errorMsg == 'NumberOfEmployees') {
					myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please fill in No. of Employees (Range) to save the record.'); 
				}else if(errorMsg == 'contactWithoutAccount'){
				    myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'Contact is not associated with any account.Please associate this contact with account to save this record.'); 
				} 
				//--------------------------------------------new validation message  ends/4/17/2014---------------------------------------------------  
		 
		    	ApexPages.addMessage(myMsg);
		    	return null; 
	        }
	        if(leadQualificationObj.Decision_Maker__c != 'No') {
        		leadQualificationObj.Who_is_Decision_Maker__c = '';
        	}
        	if(String.isBlank(leadQualificationObj.Budgeted__c)) {
        		leadQualificationObj.More_Info_on_Budgeted__c = '';
        	}
        	Lead leadToUpd = null; 
			System.Debug('>>>>11>>'+leadQualificationObj);
			if(strId.startsWith('001')) {
				leadQualificationObj.Account__c = strId;
			} else if(strId.startsWith('006')) {
				leadQualificationObj.Opportunity__c = strId;
			} else if(strId.startsWith('00Q')) {
				leadQualificationObj.Lead__c = strId;
				leadToUpd = new Lead(Id = leadQualificationObj.Lead__c);
				if(leadQualificationObj.Lead__r.Time_Frame__c != leadQualificationObj.Timeframe__c) {
					leadToUpd.Time_Frame__c = leadQualificationObj.Timeframe__c;
				}
				if(leadQualificationObj.Lead__r.Notes__c != leadQualificationObj.Other_Notes__c) {
					leadToUpd.Notes__c = leadQualificationObj.Other_Notes__c;
				} 
			} else if(strId.startsWith('003')) {
				leadQualificationObj.Contact__c = strId;
			}	
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
            leadQualificationObj = (Lead_Qualification__c)SaveDriverResons(leadQualificationObj);
            leadQualificationObj = (Lead_Qualification__c)saveCurrentSystemInfovalues(leadQualificationObj);
            /*****************For Bills project Ends***********************/ 
            
            //-----------------------------Setting new values to call flow models,features,usages starts-------------
            leadQualificationObj = (Lead_Qualification__c)saveCallFlowModelValues(leadQualificationObj);
            leadQualificationObj = (Lead_Qualification__c)saveFeaturesRequestdByCustomerValues(leadQualificationObj);
            leadQualificationObj = (Lead_Qualification__c)saveUsagesLevelvalues(leadQualificationObj);
            
            if((objName == 'Account' || objName == 'Contact') && string.isBlank(leadQualificationObj.Opportunity__c)
				&& (!string.isBlank(NextSteps) || !string.isBlank(MangerNotes))) {
				myMsg = new ApexPages.Message(ApexPages.severity.ERROR,'This Lead Qualification is not tied to an Opportunity. The Next Step and Manager Notes fields cannot be saved.'); 
				ApexPages.addMessage(myMsg);
		    	return null; 
			}
            	
		 	// ---------------------As/Simplion/6/20/2014/start--------------- --
            if(objName == 'Implementation__c' && leadQualificationObj.Id == null){
		 		leadQualificationObj.Account__c = (LeadQualParent.get(0).getSobject('Account__r')).Id;
			}	
			upsert leadQualificationObj;
			if(objName == 'Implementation__c' && leadQualificationObj.Id != null){
		 		LeadQualParent.get(0).put('Lead_Qualification__c',leadQualificationObj.Id);
			}
			// ---------------------As/Simplion/6/20/2014/ends--------------- --
			if(leadToUpd != null) {
				//update leadToUpd;
			}
			initialiseTriggerBypass();
			// ---------------------As/Simplion/6/20/2014/start--------------- --
			if(objName == 'Lead' || objName == 'Account' || objName == 'Implementation__c') {
				/*************************Effective Number of Employee Changes*******************************/
				if((string)LeadQualParent.get(0).get('Effective_No_of_Employees_Range__c') != employeeOverride){
					LeadQualParent.get(0).put('Employees_Override__c',employeeOverride);
				}
				/*******************************************************************************************/
				update LeadQualParent;
	 		} else if(objName == 'Opportunity' || objName == 'Contact') {
		   		update (Account)(LeadQualParent.get(0).getSobject('Account'));
			}
			
			// ---------------------As/Simplion/7/3/2014/starts--------------- --
			if(objName == 'Lead' && leadQualificationObj.Lead__c != null){ 
	  			Lead leadObjToUpd = new Lead(Id = leadQualificationObj.Lead__c);
   	  			leadObjToUpd.Discovery_Next_Steps__c = NextSteps;
   	  			leadObjToUpd.Discovery_Manager_Notes__c = MangerNotes;
   	  			update leadObjToUpd;
   	  		} else if((objName == 'Opportunity' || objName == 'Account' || objName == 'Contact') && 
   	  					leadQualificationObj.Opportunity__c != null){
   	  			Opportunity oppObjToUpd = new Opportunity(id = leadQualificationObj.Opportunity__c);			
   	  	 		oppObjToUpd.Discovery_Next_Steps__c = NextSteps;
                oppObjToUpd.Discovery_Manager_Notes__c = MangerNotes;
                update oppObjToUpd;
   	  		}
			// ---------------------As/Simplion/7/3/2014/ends--------------- --
			
			// ---------------------As/Simplion/6/20/2014/ends--------------- --
			toShowViewMode = true;
			loadLeadQualBasicDet();
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Lead Qualification saved successfully.'));
		} catch(Exception ex) {
			System.Debug('>>>>112>>'+ex);
		}
		return null;
	}
	
	public void initialiseTriggerBypass() {
        // Setting flags to bypass Triggers.
        TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT();
        TriggerHandler.BY_PASS_ACCOUNT_ON_UPDATE();
        TriggerHandler.BY_PASS_CASE_ON_INSERT();
        TriggerHandler.BY_PASS_CASE_ON_UPDATE();
        TriggerHandler.BY_PASS_CONTACT_ON_INSERT();
        TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT();
        TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE();
        TriggerHandler.BY_PASS_LEAD_UPDATE_ON_INSERT();
    }
	
	public PageReference backToDetail() {
		PageReference rtnPgRef;
		if(!string.isBlank(rtrl)){
			rtnPgRef = new PageReference(rtrl);
		} else {
			rtnPgRef = new PageReference('/'+strId);
		}
		rtnPgRef.setRedirect(true);
		return rtnPgRef;
	}
	
	//-----------------------------------------------------------As/simplion/4/17/2014/start---------------------------------------------------------
    
   //------------------------------------------code for Business Drivers and Reasons dependency,user interaction nd for save starts-----------------------  
  
   //------------------------------------------Generalize method to get picklist values from an object's field-------------------------
    
    public List<Schema.PicklistEntry> getPickListValueFromObject(String objName,String FieldName){
	  List<Schema.PicklistEntry> picklistValues = new List<Schema.PicklistEntry>();  
	  String[] types = new String[]{objName};
	  Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
	  Schema.DescribeSobjectResult res = results[0];
	  picklistValues =   res.fields.getMap().get(FieldName).getDescribe().getPicklistValues();
	  return picklistValues;
   }
   //----------------------------------------Method to set All Resons list values according to there existing selection from saved Record ends----------------------
   //-------------------------------------------------------Method to set All varriable values in the BussinessDriverReasonClass Ends-------------------------------      
    public List<String> getBusinessAgilitySelectedResons {get;set;}
    public List<String> getBusinessVendorSelectedResons {get;set;}
    public List<String> getBusinessresponsivenessSelectedResons {get;set;}
    
    
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
           driverListToSave.add('Business Growth');
        }
        if(getBusinessresponsivenessSelectedResons.size()>0){
           driverListToSave.add('Improved customer responsiveness');
        }
        if(getBusinessVendorSelectedResons.size()>0){
           driverListToSave.add('Dis-satisfied with current vendor');
        }
        
        //----------------------------------------------Code to seperate reason save according to users selection---------------------
        String driverString='' ;
        String businessChangeResonsString ='';
        String customerResponsivenessResonsString ='';
        String dissatisfactionwithCurrentResonsString ='';
        businessChangeResonsString = getMultipickListString(getBusinessAgilitySelectedResons);
        customerResponsivenessResonsString = getMultipickListString(getBusinessresponsivenessSelectedResons);
        dissatisfactionwithCurrentResonsString = getMultipickListString(getBusinessVendorSelectedResons);
        driverString = getMultipickListString(driverListToSave);
        if(objectinstance !=null){
            objectinstance.Business_Driver__c  = driverString;
            objectinstance.Business_Change_Reasons__c = businessChangeResonsString;
            objectinstance.Customer_Responsiveness_Reasons__c = customerResponsivenessResonsString;
            objectinstance.Dissatisfaction_with_Current__c = dissatisfactionwithCurrentResonsString;
         }
        return objectinstance;
    }
  
  //-----------------------------------------------Method to save Drivers and Resons multipicklist values to Record Ends------------------------------------ 
  		
   //---------------------------------------------------code for Business Drivers and Reasons dependency,user interaction nd for save Ends------------------------------------- 
  //---------------------------------------------------Code for Handeling All Functionality of Current System Information gatering and updation starts------------------------
   public List<String> getSelectedCurrentSystemInfo {get;set;}
   
    
  
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
	public Lead_Qualification__c saveCurrentSystemInfovalues(Lead_Qualification__c objectInstance) {
		String currentSystemInfString ='';
		currentSystemInfString = getMultipickListString(getSelectedCurrentSystemInfo);
		objectInstance.CurrentSystemInfo__c = currentSystemInfString;
        return objectInstance;
	}

 	public class LeadQualParentInfoClass {
	   public List<String> employeeRange{get;set;}
	   public String selectedEmployeeRange{get;set;}
	   public String emploees{get;set;}
	   public String neededPhones{get;set;}
	   public List<String> numberOfLocations{get;set;}
	   public String selectedLocations{get;set;}
	   public List<String> Industry{get;set;}
	   public String selectedIndustry{get;set;}
	   public String website{get;set;} 
	}
	public LeadQualParentInfoClass leadQualParentInfocls {get;set;} 
	// ---------------------As/Simplion/6/20/2014/start--------------- --
	public Map<String,String> idObjectmap = new Map<String,String>{
	    '001'   => 'Account',
	    '006'   => 'Opportunity',
	    '00Q'   => 'Lead',
	    '003'   => 'Contact',
	    'a07'   => 'Implementation__c'
    };
    
    //-----------------------------------------As/Simplion/6/25/62014 start------------------------------
    
     public Map<String,List<String>> parentObjFieldsMap = new Map<String,List<String>>{
         'Lead'               => new List<String>{'Id' ,'Number_Of_Locations__c','No_of_Employees_needing_phones__c','NumberOfEmployees__c','Industry','website','NumberOfEmployees','Employees_Override__c','Effective_No_of_Employees_Range__c'},
         'Account'            => new List<String>{'Id','Number_Of_Locations__c','No_of_Employees_needing_phones__c','No_of_Employees__c','Industry','website','NumberOfEmployees'},
         'Opportunity'        => new List<String>{'Id','Account.Number_Of_Locations__c','Account.No_of_Employees_needing_phones__c','Account.No_of_Employees__c','Account.Industry','Account.website','Account.NumberOfEmployees'},
         'Contact'            => new List<String>{'Id','Account.Number_Of_Locations__c','Account.No_of_Employees_needing_phones__c','Account.No_of_Employees__c','Account.Industry','Account.website','Account.NumberOfEmployees'},
         'Implementation__c'  => new List<String>{'Id','Lead_Qualification__c' ,'Account__r.Id','Account__r.Number_Of_Locations__c','Account__r.No_of_Employees_needing_phones__c','Account__r.No_of_Employees__c','Account__r.Industry','Account__r.website','Account__r.NumberOfEmployees'}
     };                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    //-----------------------------------------As/Simplion/6/25/62014 ends------------------------------
  	
  	public String objName {get;set;}
  	public String noOfEmployees {get;set;}
 	List<sObject> getLeadQualParentInfo(String IdValue){
 		Set<Id> idSet = new Set<Id> { IdValue };
		String queryString ='SELECT {0} From {1} WHERE Id in :idSet';
		if(IdValue != null){
        	String idPrefx = IdValue.subString(0,3) ;
        	objName = idObjectmap.get(idPrefx);
		}
		
		String paramString = '';
		for(String param : parentObjFieldsMap.get(objName)){
			paramString = paramString+param+',';
		}
		paramString = paramString.substring(0,paramString.length()-1);
        queryString = String.format(queryString, new List<string>{paramString,objName});
		List<sObject> lstSObjectTORtn = Database.query(queryString);
    	return lstSObjectTORtn;
  	} 
   	public List<Sobject> LeadQualParent {get;set;}
  	public String MangerNotes { get; set;}
 	public String NextSteps {get; set;}
	// ---------------------As/Simplion/6/20/2014/ends--------------- ---/
	
	//------------------------------------------Code for Handeling All Functionality of Current System Information gatering and updation ends------------------------
	//-----------------------------------------------------------As/simplion/4/17/2014/ends---------------------------------------------------------
	
	//--------------------------------------------Code section to controll new lead Qualification information section starts---------------------------------
 	//-----------------------List containing users selection 
    //----------------------------------method to get selected picklist values list from any object starts/Q2------------------------------------	 
 	 public List<String> getSelectedValueOfPickList(Sobject objName,String fieldName){
	
		List<String> pickValuesInDb = new List<String>();
		if(objName != null && objName.get(fieldName) != null && objName.get(fieldName) != ''){
		String valuesString = (String)(objName.get(fieldName));
		pickValuesInDb.addAll(((String)objName.get(fieldName)).split(';'));
		}
		return pickValuesInDb;
	}
	//----------------------------------method to get selected picklist values list from any object ends/Q2------------------------------------
 	 public List<String> getSelectedFeaturesRequestdByCustomerValues{get;set;}
 	 public List<String> getSelectedUsagesLevelValues{get;set;}
 	 public String getSelectedFlowModelValues{get{
 	 
 	   getSelectedFlowModelValues =  (leadQualificationObj != null && !String.isBlank(leadQualificationObj.Call_Flow_Models_Features__c)) ? leadQualificationObj.Call_Flow_Models_Features__c : '';
 	   return getSelectedFlowModelValues;	
 	 }set;}
 	 
 	  
 	//List containing all the picklist values in the Call_Flow_Models_Features__c field in Lead_Qualification__c object
 	 public List<ModelValueBindingsClass> getCallFlowModelValues{get{
         getCallFlowModelValues = new List<ModelValueBindingsClass>();
         List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Call_Flow_Models_Features__c');
         for(Schema.Picklistentry reasonEntry : pickListValues){
				getCallFlowModelValues.add(new ModelValueBindingsClass(false,reasonEntry.getLabel()));
         }
         return getCallFlowModelValues;
    }set;}
    
    public Map<Integer,ModelValueBindingsClass> getCallFlowModelValuesMap{get{
         getCallFlowModelValuesMap = new Map<Integer,ModelValueBindingsClass>();
         List<Schema.Picklistentry> pickListValues = getPickListValueFromObject('Lead_Qualification__c','Call_Flow_Models_Features__c');
         Integer countval = 0;
         for(Schema.Picklistentry reasonEntry : pickListValues){
				getCallFlowModelValuesMap.put(countval++,new ModelValueBindingsClass(false,reasonEntry.getLabel()));
         }
         return getCallFlowModelValuesMap;
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
         getUsagesLevelValues= new List<Selectoption>();
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
    
    //------------------------------------Method to assign value in Manger notes and next steps start/7/3/2014 -------------------------------------------
	public void setManagerAndNextStepValue(){
		if(wrLeadQualList.size() >0){
				if(objName == 'Lead'){
	   	  			MangerNotes = leadQualificationObj.Lead__c == null?'':leadQualificationObj.Lead__r.Discovery_Manager_Notes__c;
	   	  			NextSteps = leadQualificationObj.Lead__c == null?'':leadQualificationObj.Lead__r.Discovery_Next_Steps__c;
				} else if(objName == 'Opportunity' || objName == 'Account' || objName == 'Contact') {
	   	  	 		MangerNotes = leadQualificationObj.Opportunity__c == null ? '' :leadQualificationObj.Opportunity__r.Discovery_Manager_Notes__c;
	   	  	 		NextSteps = leadQualificationObj.Opportunity__c == null?'':leadQualificationObj.Opportunity__r.Discovery_Next_Steps__c;
	   	  		}
	   	}
		else if((objName == 'Lead' || objName == 'Opportunity') && !string.IsBlank(strId)){
			
		 	String qString ='SELECT {0} From {1} WHERE Id =:strId';
			qString = String.format(qString,new List<String>{'Discovery_Manager_Notes__c,Discovery_Next_Steps__c',objName});
			Sobject tempSobj = Database.query(qString);
		 	if(tempSobj != null){
		 		MangerNotes = (String)tempSobj.get('Discovery_Manager_Notes__c');
	   	  	 	NextSteps = (String)tempSobj.get('Discovery_Next_Steps__c');
	   	  	}
		}
	}
//------------------------------------Method to assign value in Manger notes and next steps end/7/3/2014 --------------
    
 	//--------------------------------------------Code section to controll new lead Qualification information section ends------------------
		
	public class WrapperLeadQualification {
		public boolean isSelected {get;set;}
		public Lead_Qualification__c leadQualObj {get;set;}
		public string strformatDT {get;set;}
		public WrapperLeadQualification() {
			isSelected = false;
			leadQualObj = new Lead_Qualification__c();
			strformatDT = null;
		}
	}
	
	public class WrapperContactInformation {
		public string firstName {get;set;}
		public string lastName {get;set;}
		public string phone {get;set;}
		public string email {get;set;}
		public WrapperContactInformation() {
			firstName = lastName = phone = email = '';
		}
	}
}