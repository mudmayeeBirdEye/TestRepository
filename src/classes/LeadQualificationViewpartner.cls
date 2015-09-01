public with sharing class LeadQualificationViewpartner {
    public List<WrapperLeadQualification> wrLeadQualList {get;set;}
    public Lead_Qualification__c leadQualificationObj {get;set;}
    map<Id,Lead_Qualification__c> mapLeadQual;
    public string selectedLeadQual {get;set;}
    public boolean toShowViewMode {get;set;} 
    public String rcUsers{get;set;}   
    public Lead newLead {get;set;}
    
    public string strEmail {get;set;}
	string strId;
	string rtrl;
    
	public List<SelectOption> getHasPurchasedBefore() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead_Qualification__c.Has_this_Lead_purchased_services_before__c.getDescribe();
        options = processSchemaResult(fieldResult);
        return options; 
	}
    
    public List<SelectOption> getIsUnderContract() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead_Qualification__c.Currently_under_contract__c.getDescribe();
        options = processSchemaResult(fieldResult);
        return options; 
    }
    
    public List<SelectOption> getHavePhoneBill() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead_Qualification__c.Have_copy_of_current_phone_bill__c.getDescribe();
        options = processSchemaResult(fieldResult);
        return options; 
    }
    
    public List<SelectOption> getDecisionMaker() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead_Qualification__c.Decision_Maker_Partner__c.getDescribe();
        options = processSchemaResult(fieldResult);
        return options; 
	}

   	public List<SelectOption> processSchemaResult(Schema.DescribeFieldResult fieldResult){
        List<SelectOption> options = new List<SelectOption>();
        List<Schema.PicklistEntry> listDecisionMaker = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry schemaEntry : listDecisionMaker) {
            options.add(new SelectOption(schemaEntry.getValue(),schemaEntry.getLabel()));
        }       
        return options;
    }
      
    /***************************
     Constructor for Controller 
    ***************************/
    
    public LeadQualificationViewpartner() {
	    Boolean errorFound = false;
	    newLead = new Lead();
	    rcUsers = null;    
        if(!String.isBlank(ApexPages.currentPage().getParameters().get('Id'))) {
            try {
                toShowViewMode = false;
                strId = ApexPages.currentPage().getParameters().get('Id');
                rtrl = Apexpages.currentPage().getParameters().get('retURL'); 
                loadLeadQualBasicDet();
            } catch(Exception ex) {}
        }
    }
    
    public string strLeadQualificationExNeed {get;set;}
    public string strleadQualificationWhtTypOServLedPurcFrmu {get;set;}
    public void loadLeadQualBasicDet() {
        try {
            strLeadQualificationExNeed = '';
            strleadQualificationWhtTypOServLedPurcFrmu = '';
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
                        if(leadQualificationObj.Explain_the_Lead_s_Need__c != null && leadQualificationObj.Explain_the_Lead_s_Need__c != '') {
                            System.debug('>>>>>111>>'+leadQualificationObj.Explain_the_Lead_s_Need__c);
                            List<string> stringLst = leadQualificationObj.Explain_the_Lead_s_Need__c.split(';');
                            for(string str : stringLst) {
                                if(strLeadQualificationExNeed == null || strLeadQualificationExNeed == '') {
                                    strLeadQualificationExNeed = str;
                                } else {
                                    strLeadQualificationExNeed = strLeadQualificationExNeed + '\n' + str;
                                }
                            }
                            System.debug('>>>>>111strLeadQualificationExNeed>>'+ strLeadQualificationExNeed);
                        }
                        
                        if(leadQualificationObj.What_type_of_services_has_Lead_purchased__c != null && 
                        	leadQualificationObj.What_type_of_services_has_Lead_purchased__c != '') {
                            List<string> stringLst1 = leadQualificationObj.What_type_of_services_has_Lead_purchased__c.split(';');
                            for(string str1 : stringLst1) {
                                if(strleadQualificationWhtTypOServLedPurcFrmu == null || strleadQualificationWhtTypOServLedPurcFrmu == '') {
                                    strleadQualificationWhtTypOServLedPurcFrmu = str1;
                                } else {
                                    strleadQualificationWhtTypOServLedPurcFrmu = strleadQualificationWhtTypOServLedPurcFrmu + '\n' + str1;
                                }
                            }
                        }
                        getContactInfo();
                    }
                }
            } else {
                getContactInfo();
            }
            System.Debug('>>>leadQualificationObj>>'+leadQualificationObj);
        } catch(Exception ex) {}
    }    
    
    /* For query the data on the page ************************************/
    public List<Lead_Qualification__c> getLeadQualList() {
        wrLeadQualList = new List<WrapperLeadQualification>();
        leadQualificationObj = new Lead_Qualification__c();
        List<Lead_Qualification__c> leadQualList = new List<Lead_Qualification__c>();
        try {
            if(strId.startsWith('001')) {
                    leadQualList = [Select  Name, Pain__c, Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate, 
                                     InContract__c, Ideal_Solution__c, Id, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
                                     Decision_Maker_First_Name__c,contact__r.firstName,contact__r.Name,
                                     contact__r.lastName,contact__r.phone,contact__r.email,Lead_s_Need_Other__c,Other_purchased_services__c,
                                     What_type_of_services_has_Lead_purchased__c,Has_this_Lead_purchased_services_before__c,
                                     Internet_Download_Speed_in_kBps__c,Internet_Upload_Speed_in_kBps__c,Current_Internet_Provider__c,
                                     When_will_contract_expire__c,How_many_phones_are_needed__c,Timeframe__c,Budget_per_Month__c,
                                     Currently_under_contract__c, Decision_Maker_Last_Name__c, Decision_Maker_Business_Title__c,
                                     Decision_Maker_Email__c,Case__r.Partner_Lead_FirstName__c,Case__r.Partner_Lead_LastName__c,
                                     Case__r.Partner_Lead_Phone__c,Case__r.Partner_Lead_Email__c,Case__r.Partner_Lead_Title__c,
                                     Case__r.Partner_Lead_Phone_Alternate__c,Have_copy_of_current_phone_bill__c,Contact__r.title,Contact__r.Phone_Alternate__c,
                                     Lead__r.Phone_Alternate__c,Decision_Maker_Partner__c,Explain_the_Lead_s_Need__c, Decision_Maker_Phone__c, 
                                     Decision_Maker_Alternate_Phone__c, Account__c,Account__r.Name, Lead__r.FirstName,Lead__r.title,
                                     Lead__r.LastName,Lead__r.Email,Case__r.CaseNumber,Lead__r.Phone,Owner.Name,Lead__r.Name,Opportunity__r.Name 
                                     From Lead_Qualification__c where IsDeleted  = false and Account__c =:strId  
                                     order by lastModifiedDate desc];
            } else if(strId.startsWith('006')) {
                    leadQualList = [Select Name, Pain__c, Pain_Impact__c,When_will_contract_expire__c, Opportunity__c, Next_Steps_questions__c, 
                    				 Lead__c, LastModifiedDate, 
                                     Internet_Upload_Speed_in_kBps__c,Lead_s_Need_Other__c,Other_purchased_services__c,Current_Internet_Provider__c,
                                     Decision_Maker_Partner__c,Budget_per_Month__c,Decision_Maker_Business_Title__c,Decision_Maker_Last_Name__c,
                                     Decision_Maker_Alternate_Phone__c,Decision_Maker_Phone__c,Decision_Maker_First_Name__c,
                                     Internet_Download_Speed_in_kBps__c,What_type_of_services_has_Lead_purchased__c,
                                     Has_this_Lead_purchased_services_before__c, Explain_the_Lead_s_Need__c,Decision_Maker_Email__c, 
                                     Have_copy_of_current_phone_bill__c,Lead__r.Phone_Alternate__c,Contact__r.title,Timeframe__c, 
                                     Currently_under_contract__c, InContract__c, How_many_phones_are_needed__c,Case__r.Partner_Lead_FirstName__c,
                                     Case__r.Partner_Lead_LastName__c,Case__r.Partner_Lead_Phone__c,Case__r.Partner_Lead_Email__c,
                                     Case__r.Partner_Lead_Title__c,Case__r.Partner_Lead_Phone_Alternate__c,Ideal_Solution__c, Id, 
                                     Gain__c,Contact__r.Phone_Alternate__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
                                     Account__c,contact__r.firstName,contact__r.lastName,Lead__r.title,contact__r.Name,contact__r.phone,
                                     contact__r.email,Account__r.Name, Lead__r.FirstName,Lead__r.LastName,Lead__r.Email,Lead__r.Phone,
                                     Owner.Name,Lead__r.Name,Opportunity__r.Name,Case__r.CaseNumber 
                                     From Lead_Qualification__c where IsDeleted  = false and Opportunity__c =:strId  
                                     order by lastModifiedDate desc];
            
            } else if(strId.startsWith('00Q')) {
                    leadQualList = [Select Name, Pain__c, Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate,  
                                     InContract__c,Other_purchased_services__c,Have_copy_of_current_phone_bill__c,
                                     What_type_of_services_has_Lead_purchased__c,Internet_Download_Speed_in_kBps__c,Internet_Upload_Speed_in_kBps__c,
                                     Has_this_Lead_purchased_services_before__c,Current_Internet_Provider__c,
                                     When_will_contract_expire__c,How_many_phones_are_needed__c,Timeframe__c, Ideal_Solution__c, Id,
                                     Lead_s_Need_Other__c,Budget_per_Month__c, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
                                     Account__c, Account__r.Name,contact__r.firstName,contact__r.lastName,Lead__r.Phone_Alternate__c,
                                     Contact__r.Phone_Alternate__c,Contact__r.title,contact__r.phone,contact__r.email, 
                                     Lead__r.FirstName,Lead__r.LastName,Lead__r.Email,Lead__r.Phone,Owner.Name,Lead__r.Name,Opportunity__r.Name,
                                     Decision_Maker_First_Name__c,Case__r.Partner_Lead_FirstName__c,Case__r.Partner_Lead_LastName__c,
                                     Case__r.Partner_Lead_Phone__c,Case__r.Partner_Lead_Email__c,Case__r.Partner_Lead_Title__c,
                                     Case__r.Partner_Lead_Phone_Alternate__c,Currently_under_contract__c,Lead__r.title,contact__r.Name,Decision_Maker_Partner__c,
                                     Explain_the_Lead_s_Need__c, Decision_Maker_Last_Name__c, Decision_Maker_Business_Title__c,
                                     Decision_Maker_Email__c, Decision_Maker_Phone__c, Decision_Maker_Alternate_Phone__c,Case__r.CaseNumber  
                                     From Lead_Qualification__c where IsDeleted  = false and  Lead__c =:strId  
                                     order by lastModifiedDate desc];
            } else if(strId.startsWith('003')) {
					leadQualList = [Select Name, Pain__c, Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate,  
                                     InContract__c,Other_purchased_services__c,Have_copy_of_current_phone_bill__c,
                                     What_type_of_services_has_Lead_purchased__c,Internet_Download_Speed_in_kBps__c,Internet_Upload_Speed_in_kBps__c,
                                     Has_this_Lead_purchased_services_before__c,Current_Internet_Provider__c,
                                     When_will_contract_expire__c,How_many_phones_are_needed__c,Timeframe__c, Ideal_Solution__c, Id,
                                     Lead_s_Need_Other__c,Budget_per_Month__c, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
                                     Account__c, Account__r.Name, contact__r.Name,contact__r.firstName,
                                     contact__r.lastName,Lead__r.Phone_Alternate__c,Contact__r.Phone_Alternate__c,Contact__r.title,
                                     contact__r.phone,contact__r.email, Lead__r.FirstName,Lead__r.LastName,Lead__r.Email,
                                     Lead__r.Phone,Owner.Name,Lead__r.Name,Opportunity__r.Name,
                                     Decision_Maker_First_Name__c,Case__r.Partner_Lead_FirstName__c,Case__r.Partner_Lead_LastName__c,
                                     Case__r.Partner_Lead_Phone__c,Case__r.Partner_Lead_Email__c,Case__r.Partner_Lead_Title__c,
                                     Case__r.Partner_Lead_Phone_Alternate__c,Currently_under_contract__c,Lead__r.title,Decision_Maker_Partner__c,
                                     Explain_the_Lead_s_Need__c, Decision_Maker_Last_Name__c, Decision_Maker_Business_Title__c,
                                     Decision_Maker_Email__c, Decision_Maker_Phone__c, Decision_Maker_Alternate_Phone__c,Case__r.CaseNumber  
                                     From Lead_Qualification__c where IsDeleted  = false and  contact__c = :strId  
									 order by lastModifiedDate desc];
			} else if(strId.startsWith('500')) {
					leadQualList = [Select Name, Pain__c, Pain_Impact__c, Opportunity__c, Next_Steps_questions__c, Lead__c, LastModifiedDate,  
                                     InContract__c,Other_purchased_services__c,Have_copy_of_current_phone_bill__c,
                                     What_type_of_services_has_Lead_purchased__c,Internet_Download_Speed_in_kBps__c,
                                     Internet_Upload_Speed_in_kBps__c,Has_this_Lead_purchased_services_before__c,Current_Internet_Provider__c,
                                     When_will_contract_expire__c,How_many_phones_are_needed__c,Timeframe__c, Ideal_Solution__c, Id,
                                     Lead_s_Need_Other__c,Budget_per_Month__c, Gain__c, Gain_Impact__c, CreatedDate, CompanyInfo__c, Benefits__c, 
                                     Account__c, Account__r.Name,case__r.Id,Case__r.Partner_Lead_FirstName__c,Case__r.Partner_Lead_LastName__c,
                                     Case__r.Partner_Lead_Phone__c,Case__r.Partner_Lead_Email__c,Case__r.Partner_Lead_Title__c,
                                     Case__r.Partner_Lead_Phone_Alternate__c, contact__r.Name,contact__r.firstName,contact__r.lastName,Lead__r.Phone_Alternate__c,
                                     Contact__r.Phone_Alternate__c,Contact__r.title,contact__r.phone,contact__r.email, 
                                     Lead__r.FirstName,Lead__r.LastName,Lead__r.Email,Lead__r.Phone,Owner.Name,Lead__r.Name,Opportunity__r.Name,
                                     Decision_Maker_First_Name__c,Currently_under_contract__c,Lead__r.title,Decision_Maker_Partner__c,
                                     Explain_the_Lead_s_Need__c, Decision_Maker_Last_Name__c, Decision_Maker_Business_Title__c,
                                     Decision_Maker_Email__c, Decision_Maker_Phone__c, Decision_Maker_Alternate_Phone__c,Case__r.CaseNumber  
                                     From Lead_Qualification__c where IsDeleted  = false and  case__c = :strId  
									 order by lastModifiedDate desc];
			}
			
        } catch(Exception ex) {}
        	System.Debug('>>>111>>'+ leadQualList);
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
        }
    }
    
    
 	public WrapperContactInformation wrContactInfoObj {get;set;}
    public void getContactInfo() {
    	wrContactInfoObj = new WrapperContactInformation();
        if(strId.startsWith('00Q')) {
	        List<Lead> leadInfo = [select firstName,lastName,phone,email,Phone_Alternate__c,title from lead where Id = :strId limit 1];
	        if(leadInfo != null && leadInfo.size()>0) {
	             wrContactInfoObj.firstName = leadInfo[0].firstName;
	             wrContactInfoObj.lastName = leadInfo[0].lastName;
	             wrContactInfoObj.phone = leadInfo[0].phone;
	             wrContactInfoObj.email = leadInfo[0].email;       
	             wrContactInfoObj.title= leadInfo[0].title;
	             wrContactInfoObj.phonAlt= leadInfo[0].Phone_Alternate__c;
	      	}
    	}
        else if(strId.startsWith('500')) {
      		List<Case> caseInfo = [select Partner_Lead_FirstName__c,Partner_Lead_LastName__c,Partner_Lead_Phone__c,Partner_Lead_Email__c,
      								Partner_Lead_Title__c,Partner_Lead_Phone_Alternate__c from 
      								Case where Id = :strId limit 1];
       		if(caseInfo != null && caseInfo.size()>0) {
	            wrContactInfoObj.firstName = caseInfo[0].Partner_Lead_FirstName__c;
	            wrContactInfoObj.lastName = caseInfo[0].Partner_Lead_LastName__c;
	            wrContactInfoObj.phone = caseInfo[0].Partner_Lead_Phone__c;
	            wrContactInfoObj.email = caseInfo[0].Partner_Lead_Email__c;        
	            wrContactInfoObj.title= caseInfo[0].Partner_Lead_Title__c;
	            wrContactInfoObj.phonAlt= caseInfo[0].Partner_Lead_Phone_Alternate__c;                         
      		}
        } else if(strId.startsWith('003')) {
      		List<Contact> contactInfo = [select firstName,lastName,phone,email,title,Phone_Alternate__c from Contact where Id = :strId limit 1];
       		if(contactInfo != null && contactInfo.size()>0) {
	            wrContactInfoObj.firstName = contactInfo[0].firstName;
	            wrContactInfoObj.lastName = contactInfo[0].lastName;
	            wrContactInfoObj.phone = contactInfo[0].phone;
	            wrContactInfoObj.email = contactInfo[0].email;        
	            wrContactInfoObj.title= contactInfo[0].title;
	            wrContactInfoObj.phonAlt= contactInfo[0].Phone_Alternate__c;                         
      		}
    	} else if(strId.startsWith('001')) {
      		System.Debug('>leadQualificationObj>'+ leadQualificationObj);
	      	if(leadQualificationObj != null && leadQualificationObj.Contact__c != null) {
		           wrContactInfoObj.firstName = leadQualificationObj.Contact__r.firstName;
		           wrContactInfoObj.lastName = leadQualificationObj.Contact__r.lastName;
		           wrContactInfoObj.phone = leadQualificationObj.Contact__r.phone;
		           wrContactInfoObj.email = leadQualificationObj.Contact__r.email;
		           wrContactInfoObj.phonAlt= leadQualificationObj.Contact__r.Phone_Alternate__c;
	      	} else {
		        List<Contact> contactInfo = [select firstName,lastName,phone,Phone_Alternate__c,email,title from Contact where accountID = :strId 
		                                     order by lastmodifieddate desc limit 1];
		        if(contactInfo != null && contactInfo.size()>0) {
		           wrContactInfoObj.firstName = contactInfo[0].firstName;
		           wrContactInfoObj.lastName = contactInfo[0].lastName;
		           wrContactInfoObj.phone = contactInfo[0].phone;
		           wrContactInfoObj.email = contactInfo[0].email;
		           wrContactInfoObj.title = contactInfo[0].title;
		           wrContactInfoObj.PhonAlt= contactInfo[0].Phone_Alternate__c;
		                      
		        }  
      		} 
		} else if(strId.startsWith('006')) {
		      if(leadQualificationObj != null && leadQualificationObj.Contact__c != null) {
	          	wrContactInfoObj.firstName = leadQualificationObj.Contact__r.firstName;
	          	wrContactInfoObj.lastName = leadQualificationObj.Contact__r.lastName;
	          	wrContactInfoObj.phone = leadQualificationObj.Contact__r.phone;
	          	wrContactInfoObj.email = leadQualificationObj.Contact__r.email;
	          	wrContactInfoObj.title= leadQualificationObj.Contact__r.Title;
	          	wrContactInfoObj.phonAlt= leadQualificationObj.Contact__r.Phone_Alternate__c;         
		      } else {
	        	List<OpportunityContactRole > oppcontactInfo = [select Contact.firstName,Contact.Phone_Alternate__c,
	        														Contact.title,Contact.lastName,Contact.phone,Contact.email 
	                              									from OpportunityContactRole where opportunityId = :strId 
	                              									order by lastmodifieddate desc limit 1];
	         	if(oppcontactInfo != null && oppcontactInfo.size()>0) {
	          		wrContactInfoObj.firstName = oppcontactInfo[0].Contact.firstName;
		           wrContactInfoObj.lastName = oppcontactInfo[0].Contact.lastName;
		           wrContactInfoObj.phone = oppcontactInfo[0].Contact.phone;
		           wrContactInfoObj.email = oppcontactInfo[0].Contact.email;
		           wrContactInfoObj.title= oppcontactInfo[0].Contact.title;   
		           wrContactInfoObj.phonAlt= oppcontactInfo[0].Contact.Phone_Alternate__c;                                       
	        	}  
      		}
    	}
  	}        
	
	public PageReference cancel() {
        try {
            System.Debug('>>>>21>>');
            loadupdatedLeadQual();
        } catch(Exception ex) {
            System.Debug('>>>>24>>'+ex);
        }
        return null; 
    }
    
    public PageReference loadLeadQualDet() {
    	selectedLeadQual =  Apexpages.currentPage().getParameters().get('param1');
        loadupdatedLeadQual();
        if(selectedLeadQual != null && mapLeadQual != null && mapLeadQual.get(selectedLeadQual) != null) {
        	leadQualificationObj = mapLeadQual.get(selectedLeadQual);
        }
        toShowViewMode = true;
        return null;
    }
    
    /* Method for the Edit section */
    public PageReference editLeadQualDet() {
        toShowViewMode = false;
        return null;
    }
    
    /* Method for the update section*********************************************/
    public PageReference updateLeadQual() {  
        try {
            Boolean errorFound = false;
            String errorMessage = 'Please provide the required information.';  
    		if(isEmpty(wrContactInfoObj.Phone)) {
	                errorFound = true;
            } 
          	if(!isEmpty(leadQualificationObj.Decision_Maker_Partner__c) && !'Unknown'.equalsIgnoreCase(leadQualificationObj.Decision_Maker_Partner__c)) {
                if(isEmpty(leadQualificationObj.Decision_Maker_Partner__c)) {
                	errorFound = true;
                }
                if(isEmpty(leadQualificationObj.Decision_Maker_First_Name__c)){
                    errorFound = true;
                }
                if(isEmpty(leadQualificationObj.Decision_Maker_Last_Name__c)){
                    errorFound = true;
                }
                if(isEmpty(leadQualificationObj.Decision_Maker_Email__c)){
                    errorFound = true;
                }
                if(isEmpty(leadQualificationObj.Decision_Maker_Phone__c)){
                    errorFound = true;
                }
            }   
         	if(!isEmpty(leadQualificationObj.Decision_Maker_Partner__c) && 'Details Below'.equalsIgnoreCase(leadQualificationObj.Decision_Maker_Partner__c)) {
                if(!isEmpty(leadQualificationObj.Decision_Maker_Email__c) && !isEmpty(wrContactInfoObj.Email) 
                                                        && (wrContactInfoObj.Email).equalsIgnoreCase(leadQualificationObj.Decision_Maker_Email__c)){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                                'You have indicated that the Decision Maker is different than the Lead contact. The email addresses cannot be the ' + 
                                'same. Please update the email address and submit again.'); 
                    ApexPages.addMessage(myMsg);
                  	return null;
                }
            }
                       
            if(isEmpty(leadQualificationObj.Explain_the_Lead_s_Need__c)){
            	errorFound = true;
            }
                
         	if(!isEmpty(leadQualificationObj.Explain_the_Lead_s_Need__c) && 
            							leadQualificationObj.Explain_the_Lead_s_Need__c.containsIgnoreCase('Other (Please specify)') 
                                        && isEmpty(leadQualificationObj.Lead_s_Need_Other__c)){
           		errorFound = true;
         	}
            if(isEmpty(leadQualificationObj.Budget_per_Month__c)){
                errorFound = true;
            }
            if(isEmpty(leadQualificationObj.Have_copy_of_current_phone_bill__c)){
                errorFound = true;
            }
            if(isEmpty(leadQualificationObj.How_many_phones_are_needed__c)){
                errorFound = true;
            }
            /*if(isEmpty(leadQualificationObj.When_will_contract_expire__c)){
                errorFound = true;
            }*/
            if(!isEmpty(leadQualificationObj.Currently_under_contract__c) && 'yes'.equalsIgnoreCase(leadQualificationObj.Currently_under_contract__c) 
                && isEmpty(leadQualificationObj.When_will_contract_expire__c)){
            	errorFound = true;
            }
         	if(isEmpty(leadQualificationObj.Has_this_Lead_purchased_services_before__c)){
                errorFound = true;
            }
            
            if(!isEmpty(leadQualificationObj.Has_this_Lead_purchased_services_before__c) && 
            				'yes'.equalsIgnoreCase(leadQualificationObj.Has_this_Lead_purchased_services_before__c) 
                            && isEmpty(leadQualificationObj.What_type_of_services_has_Lead_purchased__c)){
            	errorFound = true;
            }
                 
			if(!isEmpty(leadQualificationObj.What_type_of_services_has_Lead_purchased__c) && 
					leadQualificationObj.What_type_of_services_has_Lead_purchased__c.containsIgnoreCase('Other (Please specify)') 
	                && isEmpty(leadQualificationObj.Other_purchased_services__c)){
            	errorFound = true;
    		}
              
            if(isEmpty(leadQualificationObj.Timeframe__c)) {
                system.debug('@@@@@!#$');
                errorFound = true;
            }
               
            if(errorFound) {
                system.debug('@@@@@!#$'+errorMessage);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                    errorMessage);
                ApexPages.addMessage(myMsg);
                //return ApexPages.currentPage();
                return null;
            }
                
            if(!isValidEmail(wrContactInfoObj.Email.trim()) || !isValidEmail(leadQualificationObj.Decision_Maker_Email__c.trim())) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                'The email entered is not in a valid format.'); 
                 ApexPages.addMessage(myMsg );
                 return null;
           	}
            PageReference rtnPgRef;       
            System.Debug('>>>>11>>'+ leadQualificationObj);
            if(strId.startsWith('001')) {
                leadQualificationObj.Account__c = strId;
            } else if(strId.startsWith('006')) {
                leadQualificationObj.Opportunity__c = strId;
            } else if(strId.startsWith('00Q')) {
                leadQualificationObj.Lead__c = strId; 
            } else if(strId.startsWith('003')) {
                leadQualificationObj.Contact__c = strId; 
            }
            else if(strId.startsWith('500')) {
                leadQualificationObj.Case__c = strId; 
            }       
            system.debug('722222227'+ leadQualificationObj);
            upsert leadQualificationObj;  
            system.debug('77777777777777'+ leadQualificationObj);
            toShowViewMode = true;
            //toflag = false;
            loadLeadQualBasicDet();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Lead Qualification saved successfully.'));
            /*String retURL1 = '/apex/LeadQualificationView';
            rtnPgRef = new Pagereference(retURL1);
            rtnPgRef.getParameters().put('retURL',strId);
            rtnPgRef.getParameters().put('Id',strId);
            rtnPgRef.setRedirect(false);
            return rtnPgRef;*/    
       } catch(Exception e) {}     
        return null;
	}
    
    /* Method for the Back Button ***********************/
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
    
    /* wrapper class for the Lead Qualification Information section .******************************/        
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
   	
 	public Boolean isEmpty(String value) {
        return (value == null || value.trim() == '' ? true : false);
    }
    
    public Boolean isEmpty(Date dtvalue) {
        return (dtvalue == null || String.valueof(dtvalue).trim() == '' ? true : false);
    }
    
    public Boolean isFakeEmail(String email) {
        return (!isEmpty(email) && email.trim() ==  'fake@email.com');
    }
    
    public Boolean isValidEmail(String InputString) {
        if(InputString != null && InputString != '') {
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern MyPattern = Pattern.compile(emailRegex);
            Matcher MyMatcher = MyPattern.matcher(InputString);
            if (!MyMatcher.matches()) {
                return false;
            }
        }
        return true;
    }
 	
 	public PageReference clearPickListValue(){
        leadQualificationObj.What_type_of_services_has_Lead_purchased__c = null;
        return null;
    }
  	
  	/*wrapper class for the contact Information section .********************************/    
    public class WrapperContactInformation {
	    public string firstName {get;set;}
	    public string lastName {get;set;}
	    public string phone {get;set;}
	    public string email {get;set;}
	    public string title{get;set;} 
	    public string phonAlt{get;set;}    
	    public WrapperContactInformation() {
	  		firstName = lastName = phone = email = title = phonAlt = '';
		}
  	}
}