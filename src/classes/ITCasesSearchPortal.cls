public class ITCasesSearchPortal {
    public String Case_num{get;set;}
    public String CaseNumber{get;set;}
    String searchText;
    List<Case> results;
    public List<Case> cookieBasedCases {get;set;}
    public boolean toShowMailPanel {get;set;}
    public ITCasesSearchPortal(ApexPages.StandardController controller) {
    	try {
    		toShowMailPanel = false;
    		results = new List<Case>(); 
	        cookieBasedCases = new List<Case>();
	        toShowCaseDetail = false;
	        getCaseNumber();
	    	String caseNumber = '';
	    	if(ApexPages.currentPage().getParameters().get('source') != null && ApexPages.currentPage().getParameters().get('source') != '') {
	    		if(ApexPages.currentPage().getParameters().get('source') == 'wiki' || 
	    			ApexPages.currentPage().getParameters().get('source') == 'email') {
	    			toShowMailPanel = true;
	    		}
	    	}
	  		if(ApexPages.currentPage().getParameters().get('case_num') != null && ApexPages.currentPage().getParameters().get('case_num') != '' &&
	  			ApexPages.currentPage().getParameters().get('source') == 'email') {
	    			caseNumber = ApexPages.currentPage().getParameters().get('case_num');
	    			searchText = caseNumber;
	    			setSearchText(searchText);
	    			caseIdDetail = [select Id from Case where CaseNumber =:caseNumber limit 1].id;
	    			System.debug('>>11>' + caseIdDetail);
	    			showCaseDetail();
	  		}	
    	} catch(Exception ex) {
    		System.debug('>>ex>' + ex.getMessage());
    	}
        
   	}
    public static final String cookieName = 'casenumber';
   
    public String getSearchText() {
         return searchText;
    }
    public void setSearchText(String s) {
        searchText = s;
    }
    
    public List<WrCaseDetail> listWrCaseByText {get;set;}
    public boolean toShowErrorMsg {get;set;}
    public string errorMsg {get;set;}
    public PageReference Search() {
            try {
     		errorMsg = '';
        	toShowErrorMsg = false;
            listWrCaseByText = new List<WrCaseDetail>();
            if(ApexPages.currentPage().getParameters().get('case_num') != null && ApexPages.currentPage().getParameters().get('case_num') != '') {
	        	setCaseNumber(ApexPages.currentPage().getParameters().get('case_num'));
	     	}
            if(!String.isBlank(searchText)) {
                string strQuery;
                string strQuerys;
                strQuerys = searchText.trim();
                strQuerys = strQuerys.replaceAll('(\\c+)', ' ');
                strQuery = 'select Id,CaseNumber,Status,CreatedDate,ClosedDate,Time_Since_Case_Opened__c, Account.Name,Case_Severity__c,Product_Assistance__c,Priority,Subject,Contact.Name,Case.Owner.Name from Case '+
                               'where (RecordType.Name =' + '\'IT Helpdesk\' OR RecordType.Name =' + '\'IT New Hire Request\' )' +' and  CaseNumber = ' + '\''+''+strQuerys+''+'\' order by createddate desc' ; 
                system.debug('######strQuery#######'+ strQuery);                
                results = Database.Query(strQuery);
                for(Case caseObj : results) {
                    WrCaseDetail searchCase = new WrCaseDetail();
                    searchCase.id = caseObj.id;
                    searchCase.CaseNumber = caseObj.CaseNumber;
                    searchCase.ClosedDate = caseObj.ClosedDate != null ? caseObj.ClosedDate.format() : '';
                    searchCase.CreatedDate = caseObj.CreatedDate.format();
                    searchCase.Priority = caseObj.Priority;
                   	searchCase.Subject= caseObj.Subject;
                    searchCase.Status = caseObj.Status;
                    searchCase.contactname = caseObj.Contact.Name;
                    searchCase.caseownernmame = caseObj.Owner.Name;
                    searchCase.accountname = caseObj.Account.Name;
                    searchCase.ProductAssistance = caseObj.Product_Assistance__c;
                    if(caseObj.Time_Since_Case_Opened__c != null) {
	                	Integer noOfDays = Integer.valueOf((caseObj.Time_Since_Case_Opened__c));
		                if(noOfDays >= 0 && noOfDays < 7) {
		                	searchCase.TimeSinceCaseOpened = 'Green';
		                } else if(noOfDays >= 7 && noOfDays <= 9) {
		                	searchCase.TimeSinceCaseOpened = 'Yellow';
		                } else if(noOfDays >9) {
		                	searchCase.TimeSinceCaseOpened = 'Red';
		                }
                	}
                    listWrCaseByText.add(searchCase);
                }   
                getCaseNumber();
                setCaseNumber(searchText);
                system.debug('#############'+results);
                toShowCaseDetail = false;   
            } else {
                ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, 'Blank search will not work. Please search by Case Number.'));
            	toShowErrorMsg = true;
            	errorMsg = 'Blank search will not work. Please search by Case Number.';
            }
        } catch(Exception ex) {
        	 System.debug('>>ex>' + ex.getMessage());
             ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, 'No Result Found.'));
             toShowErrorMsg = true;
        	 errorMsg = 'No Result Found.';
        }
        return null;
    }
    
    public String callSetIterator(Set<string> strSet) {  //'069U00000001MLTIA2','069U00000001NfSIAU' 068U00000001XmEIAU   +'\''+ '' + idSet + '' +'\'
       System.Debug('>>9>>'+strSet);
       String strReturn = null;
       for(string strObj : strSet) {
           if(strReturn == null) {
               strReturn = '' + '\''+ '' + strObj.trim() + '' +'\'';
           } else {
               strReturn = strReturn + ',' + '' + '\''+ '' + strObj.trim()+ '' +'\'';
           }                    
       }
       System.Debug('>>10>>'+strReturn);
       return strReturn;
    }
    
    public List<WrCaseDetail> listWrCaseFromCookie {get;set;}
    public void getCaseNumber(){
    	toShowCaseDetail = false;
    	errorMsg = '';
        toShowErrorMsg = false;
        listWrCaseFromCookie = new List<WrCaseDetail>();
        try {
        	if(ApexPages.currentPage().getCookies().get(cookieName)== null){
            	return;
        	}
        } catch(Exception e) {return;}
        String cookieCaseNumber = (ApexPages.currentPage().getCookies().get(cookieName).getValue());
        if(!String.isBlank(cookieCaseNumber)) {
            try{
	            system.debug('######cookieCaseNumber#######'+ cookieCaseNumber);
	            string[] caseNumberList = cookieCaseNumber.split(';');
	            string strQuery;
	            set<string> setCaseNumber = new set<string>();
	            for(string caseNumberObj : caseNumberList) {
	                setCaseNumber.add(caseNumberObj);    
	            }
	            string caseNumberTOSrch = callSetIterator(setCaseNumber);
	            system.debug('######caseNumberTOSrch#######'+ caseNumberTOSrch); 
	            strQuery = 'select Id,CaseNumber,Status,CreatedDate,ClosedDate,Time_Since_Case_Opened__c,Priority,Account.Name,Case_Severity__c,Subject,Product_Assistance__c,Contact.Name,Case.Owner.name from Case '+
	                           'where (RecordType.Name =' + '\'IT Helpdesk\' OR RecordType.Name =' + '\'IT New Hire Request\' )' + '  and CaseNumber IN (' + caseNumberTOSrch + ' ) order by createddate desc limit 9999' ;
	            system.debug('######strQuery#######'+ strQuery);                
	            cookieBasedCases = Database.Query(strQuery);
	            for(Case caseObj : cookieBasedCases) {
	                WrCaseDetail cookieCase = new WrCaseDetail();
	                cookieCase.id = caseObj.id;
	                cookieCase.CaseNumber = caseObj.CaseNumber;
	                cookieCase.ClosedDate = caseObj.ClosedDate != null ? caseObj.ClosedDate.format() : '';
	                cookieCase.CreatedDate = caseObj.CreatedDate.format();
	                cookieCase.Priority = caseObj.Priority;
	                cookiecase.Subject = caseObj.Subject;
	                cookieCase.Status = caseObj.Status;
	                cookieCase.contactname = caseObj.Contact.Name;
	                cookieCase.caseownernmame = caseObj.Owner.Name;
	                cookieCase.accountname = caseObj.Account.Name;
	                cookieCase.ProductAssistance = caseObj.Product_Assistance__c;
	                if(caseObj.Time_Since_Case_Opened__c != null) {
	                	Integer noOfDays = Integer.valueOf((caseObj.Time_Since_Case_Opened__c));
	                	System.Debug('>noOfDays>>'+ noOfDays);
	                	System.Debug('>caseObj.Time_Since_Case_Opened__c>>'+ caseObj.Time_Since_Case_Opened__c);
		                /*if(noOfDays >= 0 && noOfDays < 3) {
		                	cookieCase.TimeSinceCaseOpened = 'Green';
		                } else if(noOfDays >= 3 && noOfDays < 7) {
		                	cookieCase.TimeSinceCaseOpened = 'Yellow';
		                } else if(noOfDays >=7) {
		                	cookieCase.TimeSinceCaseOpened = 'Red';
		                }*/
		                if(noOfDays >= 0 && noOfDays < 7) {
		                	cookieCase.TimeSinceCaseOpened = 'Green';
		                } else if(noOfDays >= 7 && noOfDays <= 9) {
		                	cookieCase.TimeSinceCaseOpened = 'Yellow';
		                } else if(noOfDays >9) {
		                	cookieCase.TimeSinceCaseOpened = 'Red';
		                }
	                }
	                listWrCaseFromCookie.add(cookieCase);
	                
	            }               
	            //cookieBasedCases = (List<Case>)[FIND :cookieCaseNumber RETURNING Case(Id,CaseNumber,Status,CreatedDate,ClosedDate,Priority)][0];
	            system.debug('#############'+cookieBasedCases);
	        } catch(Exception ex) {
             	ApexPages.addMessage (new ApexPages.Message (ApexPages.Severity.ERROR, 'No Result Found'));
        	}
        }
    }
    
    public static void setCaseNumber(String CaseNumber){
        string previousCaseNumbers = '';
        if(ApexPages.currentPage().getCookies().get(cookieName) != null){
            previousCaseNumbers = ApexPages.currentPage().getCookies().get(cookieName).getValue();
        }
        string newcaseNumbers = CaseNumber + ';' + previousCaseNumbers;
        ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(cookieName,newcaseNumbers,null,-1,false)});
    }
    
    public PageReference backToSearch1() {
        if(ApexPages.currentPage().getParameters().get('case_num') != null && ApexPages.currentPage().getParameters().get('case_num') != '') {
        	setCaseNumber(ApexPages.currentPage().getParameters().get('case_num'));
        	System.Debug('>>listWrCaseFromCookie>>'+listWrCaseFromCookie);
        	//getCaseNumber();
        	PageReference pfRef = new PageReference('/ITHelpDesk?source=email');
        	//pfRef.getParameters().put('source','email');
        	pfRef.setRedirect(true);
        	return pfRef; 
        } else {
        	getCaseNumber();
        }
        return null;
    }
    
    public boolean toShowCaseDetail {get;set;}
    public string caseIdDetail {get;set;}
    public Case caseDetailObj {get;set;}
    public string strFormatDate {get;set;}
    public WrCaseDetail wrCaseDetailObj {get;set;}
    public List<CommentWrapper> commentWrapperList {get;set;}
    public List<historyWrapper> historyWrapperList {get;set;}
    public List<colorWrapper> colorWrapperList {get;set;}
    public string strClosedDate {get;set;}
    public string emailBody {get;set;}
    public List<string> strDateSet {get;set;}
    public set<string> strDateSet1 {get;set;}
    public map<string,List<HistoryWrapper>> mapHistoryInfo {get;set;}
    public map<string,string> mapDateConversion {get;set;}
    public void showCaseDetail() {
        try {
        	errorMsg = '';
        	toShowErrorMsg = false;
            commentWrapperList = new List<CommentWrapper>();
            historyWrapperList = new List<historyWrapper>();
            colorWrapperList = new List<colorWrapper>();
            mapDateConversion = new  map<string,string>();
            strDateSet = new List<string>();
            strDateSet1 = new set<string>();
            mapHistoryInfo = new map<string,List<HistoryWrapper>>();
            caseDetailObj = new Case();
            wrCaseDetailObj = new WrCaseDetail();
            toShowCaseDetail = true;
            if(caseIdDetail != null) {
                     try {
                         caseDetailObj = [SELECT Subject,Priority,Contact.Name,Owner.Name,CaseNumber,Description,createdDate,status,Account.Name,
                                            Contact.Email,Owner.Email,Location__c,closeddate,Ops_Time_Left__c,Time_Since_Case_Opened__c,
                                            Case_Severity__c,Product_Assistance__c,Product_Assistance_Lvl2__c ,Product_Assistance_Lvl3__c, 
                                            (SELECT IsPublished, CommentBody, CreatedById, CreatedDate, LastModifiedDate, LastModifiedById,CreatedBy.Name 
                                            FROM CaseComments where IsPublished = true and IsDeleted = false order by createddate desc),
                                            (SELECT Id, IsDeleted, CaseId, CreatedById, CreatedBy.Name,CreatedDate, Field, OldValue, NewValue 
                                                        From Histories where IsDeleted = false order by createddate desc)
                                            FROM Case where Id =:caseIdDetail and (RecordType.Name = 'IT Helpdesk' OR  RecordType.Name = 'IT New Hire Request')];
                        if(caseDetailObj != null) {
                            strFormatDate = caseDetailObj.CreatedDate.format('h:mm a z, MM/dd/yyyy','America/Los_Angeles');
                            if(caseDetailObj.ClosedDate != null) {
                             	strClosedDate = caseDetailObj.ClosedDate.format('h:mm a z, MM/dd/yyyy','America/Los_Angeles');
                            }
                            wrCaseDetailObj.id = caseDetailObj.id;
                            wrCaseDetailObj.CaseNumber = caseDetailObj.CaseNumber;
                            wrCaseDetailObj.caseownernmame = caseDetailObj.Owner.Name;
                            wrCaseDetailObj.contactname = caseDetailObj.Contact.Name;
                            wrCaseDetailObj.accountname = caseDetailObj.Account.Name;
                          	wrCaseDetailObj.ProductAssistance = caseDetailObj.Product_Assistance__c;
                            wrCaseDetailObj.Priority = caseDetailObj.Priority;
                            wrCaseDetailObj.Status = caseDetailObj.Status;
                            wrCaseDetailObj.Subject = caseDetailObj.Subject;
                            wrCaseDetailObj.description = caseDetailObj.Description;
                            wrCaseDetailObj.caseowneremail = caseDetailObj.Owner.Email;
                            wrCaseDetailObj.contactemail = caseDetailObj.Contact.Email;
                            wrCaseDetailObj.location = caseDetailObj.Location__c;
                            if(caseDetailObj.Time_Since_Case_Opened__c != null) {
			                	Integer noOfDays = Integer.valueOf((caseDetailObj.Time_Since_Case_Opened__c));
				                if(noOfDays >= 0 && noOfDays < 7) {
				                	wrCaseDetailObj.TimeSinceCaseOpened = 'Green';
				                } else if(noOfDays >= 7 && noOfDays <= 9) {
				                	wrCaseDetailObj.TimeSinceCaseOpened = 'Yellow';
				                } else if(noOfDays > 9) {
				                	wrCaseDetailObj.TimeSinceCaseOpened = 'Red';
				                }
			                }
                            for(CaseComment caseCommentObj : caseDetailObj.CaseComments) {
                                System.Debug('>>5>>'+caseCommentObj.IsPublished);
                                CommentWrapper commentWRObj = new CommentWrapper();
                                commentWRObj.commentBody = caseCommentObj.CommentBody;
                                commentWRObj.openedBy = caseCommentObj.CreatedBy.Name;
                                commentWRObj.openeddateformat = caseCommentObj.CreatedDate.format('h:mm a z, MM/dd/yyyy','America/Los_Angeles');
                                commentWrapperList.add(commentWRObj);       
                            } 
                           
                            for(CaseHistory caseHistoryObj : caseDetailObj.Histories) {
                            	if(caseHistoryObj.NewValue == null || (caseHistoryObj.NewValue != null && !string.valueOf(caseHistoryObj.NewValue).startswith('001') 
                            		&&!string.valueOf(caseHistoryObj.NewValue).startswith('003') 
                                	&&!string.valueOf(caseHistoryObj.NewValue).startswith('005'))) {
                                	List<HistoryWrapper> historyWRList = new List<HistoryWrapper>();
                                    HistoryWrapper HistoryWRObj = new HistoryWrapper();
                                    HistoryWRObj.changedDate = caseHistoryObj.CreatedDate.format('h:mm a z, MM/dd/yyyy');
                                    HistoryWRObj.changedByName = caseHistoryObj.CreatedBy.Name;
                               		if(caseHistoryObj.Field.EqualsIgnoreCase('Created')) {
                                		HistoryWRObj.action = '<b>Created</b>';
                                	} else  {
                               			if(caseHistoryObj.OldValue != null) {
                        					HistoryWRObj.action = 'Changed ' + '<b>'+ caseHistoryObj.Field +'</b>' + (caseHistoryObj.OldValue != null ? (' Name from '+ '<b>'+caseHistoryObj.OldValue+'</b>') : '') + (caseHistoryObj.NewValue != null ? (' to '+ '<b>'+caseHistoryObj.NewValue +'</b>' +'.') : '');
                        					//HistoryWRObj.action = 'Changed ' + '<b>'+caseHistoryObj.Field+'</b>' +' Name from '+ '<b>'+caseHistoryObj.OldValue+'</b>' + ' to '+ '<b>'+caseHistoryObj.NewValue+'</b>'+'.';	
                                    	} else {
                                     		HistoryWRObj.action = 'Changed ' + '<b>'+ caseHistoryObj.Field +'</b>' + (caseHistoryObj.NewValue != null ? (' Name to '+ '<b>'+caseHistoryObj.NewValue+'</b>' +'.') : '');
                                     		//HistoryWRObj.action = 'Changed ' + '<b>'+caseHistoryObj.Field;//+'</b>' +' Name to '+ '<b>'+caseHistoryObj.NewValue+'</b>' +'.';   
                                        }
                                		
                                        if(caseHistoryObj.OldValue == null) {
                                        	HistoryWRObj.action = 'Changed ' + '<b>'+ caseHistoryObj.Field +'</b>' + (caseHistoryObj.NewValue != null ? (' Name to '+ '<b>'+caseHistoryObj.NewValue+'</b>' +'.') : '');
                                        } else {
                                    		HistoryWRObj.action = 'Changed ' + '<b>'+ caseHistoryObj.Field +'</b>' + (caseHistoryObj.OldValue != null ? (' Name from '+ '<b>'+caseHistoryObj.OldValue+'</b>') : '') + (caseHistoryObj.NewValue != null ? (' to '+ '<b>'+caseHistoryObj.NewValue +'</b>' +'.') : '');
                                        }
                                    }
                                    
                                    mapDateConversion.put(HistoryWRObj.changedDate,caseHistoryObj.CreatedDate.format('h:mm a z, MM/dd/yyyy','America/Los_Angeles'));
                                    if(mapHistoryInfo != null && mapHistoryInfo.containsKey(HistoryWRObj.changedDate)) {
                                            historyWRList = mapHistoryInfo.get(HistoryWRObj.changedDate);
                                    }
                                    historyWRList.add(HistoryWRObj);   
                                    mapHistoryInfo.put(HistoryWRObj.changedDate,historyWRList);
                                    if(!strDateSet1.contains(HistoryWRObj.changedDate)) {
                                            strDateSet.add(HistoryWRObj.changedDate);
                                    }
                                    strDateSet1.add(HistoryWRObj.changedDate);
                                }
                            }
                            emailBody = 'Case Number: '+wrCaseDetailObj.CaseNumber;                   
                        } 
                    } catch (Exception ex) {
                        System.Debug('>>44...'+ex.getMessage());
                    }
                } else {
                        System.debug('##### CASE ID NOT FOUND #####');
                        ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, '##### CASE ID NOT FOUND #####'));
                }
        } catch(Exception ex) {
                ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.ERROR, '##### ' + ex.getMessage() + ' #####'));
        }
    }
     
    public void backToSearch() {
        toShowCaseDetail = false;
        caseIdDetail = '';
    }
    
    public class CommentWrapper {
        public string commentBody {get;set;}
        public string openedBy {get;set;}
        public string openeddateformat {get;set;}
        public CommentWrapper() {
            commentBody = null;
            openedBy = null;
            openeddateformat = null;    
        }
    }
    
    public class colorWrapper {
        public string red {get;set;}
        public string green{get;set;}
        public string yellow{get;set;}
        public colorWrapper() {
        
        }
    }
    
    public class HistoryWrapper {
	    public string changedByName {get;set;}
	    public string changedDate {get;set;}
	    public string action {get;set;}
	    public HistoryWrapper() {
	    	changedByName = null;
             changedDate = null;
             action = null;
    	}
    }
    
    public class WrCaseDetail {
        public string id {get;set;}
        public string CaseNumber {get;set;}
        public string Status {get;set;}
        public string CreatedDate {get;set;}
        public string ClosedDate {get;set;}
        public string ProductAssistance {get;set;}
        public string Priority {get;set;}
        public string Subject {get;set;}
        public string TimeSinceCaseOpened {get;set;}
        public string caseownernmame {get;set;}
        public string caseowneremail {get;set;}
        public string contactname {get;set;}
        public string accountname {get;set;}
        public string contactemail {get;set;}
        public string Severity {get;set;}
        public string description {get;set;}
        public string location {get;set;}
        public List<CommentWrapper> wrCommentList{get;set;}
        public List<historyWrapper> wrHistoryList{get;set;}
        public List<colorWrapper> wrcolorList {get;set;}
        public WrCaseDetail() {
        wrCommentList = new List<CommentWrapper>();
                wrHistoryList = new List<historyWrapper>();
                wrcolorList= new list<colorWrapper>();
        }
    }
}