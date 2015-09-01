public with sharing class  GccSmartSearchController {
  //------------------------properties section starts------------------------------------
  public String searchValue{get;set;}
  public String selectedAccount{get;set;}
  public String searchChoice{get;set;}
  public Boolean showDetails{get;set;}
  public Boolean showList{get;set;}
  public Boolean showNoAccount{get;set;}
  public AccountCaseClass detailsClass{get;set;}
  public DataTableClass dataTableClassForAccount{get;set;}
  
  //----------------------transient properties starts------------------------------------------
  transient public URLParamClass paramClass{get;set;}
  transient public Account accountToShow{get;set;}
  transient public List<Account> accountList{get;private set;}
  transient public Integer TotaCount{get;set;}
  transient public String errorMsg{get;set;}
  transient public Integer openCount{get;set;}
  //----------------------transient properties ends  ------------------------------------------
  
  //------------------------properties section ends--------------------------------------
  
  //------------------------Controller starts--------------------------------------------
  public GccSmartSearchController(){
    
    //-----------------Initialize properties starts-------------------- ----------------
      searchChoice = 'accountNumber';
      searchValue = '';  
      selectedAccount = ''; 
      accountList = new List<Account>();
      showDetails =showList = showNoAccount = false;
      paramClass = new URLParamClass();
      detailsClass = new AccountCaseClass();
      dataTableClassForAccount = new DataTableClass();
    //-----------------Initialize properties ends--------------------------------------
    
    //-----------------URL parameter handeling-----------------------------------------
        
        paramClass.dnis = ApexPages.currentPage().getParameters().get('dnis');
        paramClass.dnis = String.isBlank(paramClass.dnis) ?'':paramClass.dnis;
        if(!String.isBlank(paramClass.dnis)){
            List<Campaign> campaignList = new List<Campaign>();
            campaignList = [SELECT Id,Name,DNIS__c,Description FROM Campaign WHERE IsActive = true and (DNIS__c != NULL AND DNIS__c=:paramClass.dnis) ORDER By LastModifiedDate LIMIT 1];
            if(campaignList.size() >0){
                    paramClass.campObj = campaignList.get(0);
                    paramClass.campaignName = campaignList.get(0).name;
            }else if(campaignList.size() == 0){
                paramClass.campaignName = 'Campaign not found.';
            }
        }
        paramClass.inContactId = ApexPages.currentPage().getParameters().get('cid');
        paramClass.inContactId = String.isBlank(paramClass.inContactId) ?'':paramClass.inContactId;
        paramClass.skillName =   ApexPages.currentPage().getParameters().get('skill');
        paramClass.skillName =   String.isBlank(paramClass.skillName)?'':paramClass.skillName;
        paramClass.accno =       ApexPages.currentPage().getParameters().get('acctno');
        if(!String.isBlank(paramClass.accno)){
          searchValue = paramClass.accno;
          searchAccount();
        }else{
          paramClass.accno = '';  
        }
  }
  
  //------------------------Controller ends----------------------------------------------

  
  //-------------------Method starts-----------------------------------------------------
  
  
  //-------------------------------------Method to search accounts for user entered term--------- 
  public void searchAccount(){
    System.debug(searchChoice+'~~~~~~~~~~~~~~~~~~~searchChoice');
    dataTableClassForAccount =  new DataTableClass();
    dataTableClassForAccount.setObjectType('Account');
   // accountList = new List<Account>();
    dataTableClassForAccount.setFieldList(new List<String>{'Name','RC_Account_Status__c','RC_Brand__c','Service_Type__c','RC_Tier__c','Total_DLs__c','Total_Account_DL_s__c','CreatedDate'});
    dataTableClassForAccount.setSizeOptions(new List<String>{'10','20','30','40','50'});
   // String mainQuery ='select Id,Name,RC_Account_Status__c,RC_Brand__c,Service_Type__c,RC_Tier__c,Total_DLs__c,Total_Account_DL_s__c FROM Account';
    String WhereClause = ' ';
    selectedAccount = '';
    searchValue = searchValue.trim();
    searchValue = String.escapeSingleQuotes(searchValue);
    if(!String.isBlank(searchValue)){
      List<Object> paramList  = new List<Object>();
      
      //WhereClause = ' WHERE RC_Account_Number__c'+ ' like \'%' + searchValue + '%\' OR Phone'+ ' like \'%' + searchValue + '%\'';
      if(searchChoice.equals('phone')){
      	paramList.add(new Map<String,Object>{
	        'name' 			=>'Account_Mobile_Number__c',
	        'operator'		=>'=',
	        'seperator'		=>'No',
	        'value'			=>searchValue
	    });
      	
        String formatedSearchValue = formatphonenumber(searchValue);
        if(!searchValue.equals(formatedSearchValue)){
             
            paramList.add(new Map<String,Object>{
		        'name' 			=>'Account_Mobile_Number__c',
		        'operator'		=>'=', 
		        'seperator'		=>'OR',
		        'value'			=>formatedSearchValue
		    });
        }
        
      }else{
        
        paramList.add(new Map<String,Object>{
	        'name' 			=>'RC_Account_Number__c',
	        'operator'		=>'=',
	        'seperator'		=>'No',
	        'value'			=>searchValue
	    });
      }
      System.debug(paramList+'~~~~~~~~~~~~~~~~~~~~paramList');
      dataTableClassForAccount.setParamList(paramList);
      dataTableClassForAccount.setSortByField('CreatedDate');
	    dataTableClassForAccount.setSortDirection('DESC');
	    dataTableClassForAccount.setList_size(10);
	    dataTableClassForAccount.prepareTable();
	   /* String subQuery = ' ORDER BY createdDate DESC LIMIT 5';
	    String Query = mainQuery+WhereClause+subQuery;
	    System.debug(Query+'~~~~~~~~~~~~~~~~~~~Query');
	    accountList = DataBase.query(Query);*/
	    if(dataTableClassForAccount.objectsList != null && dataTableClassForAccount.objectsList.size() == 1){
	        selectedAccount = dataTableClassForAccount.objectsList.get(0).Id;
	        detailsClass.accountToShow = getAccountDetails(selectedAccount);
	        if(detailsClass.accountToShow != null){
	            showDetails = true;
	            showNoAccount = false;
	            showList = false;
	            String accountId = String.valueOf(detailsClass.accountToShow.Id);
	            getCaseSurveyDetails(selectedAccount);
		        if(String.isBlank(detailsClass.accountToShow.Ultimate_Parent_Account_ID__c)){
		        	detailsClass.parentChildValue = 'Parent';
		        }
		        else if(!String.isBlank(detailsClass.accountToShow.Ultimate_Parent_Account_ID__c) && detailsClass.accountToShow.Ultimate_Parent_Account_ID__c.equals(accountId.subString(0,15))){
		            detailsClass.parentChildValue = 'Parent';
		        }else if(!String.isBlank(detailsClass.accountToShow.Ultimate_Parent_Account_ID__c) && !detailsClass.accountToShow.Ultimate_Parent_Account_ID__c.equals(accountId.subString(0,15))){
		            detailsClass.parentChildValue = 'Child';
		        }
	        }
	    }else if(dataTableClassForAccount.objectsList != null && dataTableClassForAccount.objectsList.size() == 0){
	        showDetails = false;
	        showNoAccount = true;
	        errorMsg = 'There are no records of account for your search text!!';
	        showList = false;
	    }else if(dataTableClassForAccount.objectsList != null && dataTableClassForAccount.objectsList.size() >1){
	        showDetails = false;
	        showNoAccount = false;
	        showList = true;
	    }
	    System.debug(dataTableClassForAccount.objectsList);
    }else{
    		showDetails = false;
	        showNoAccount = true;
	        errorMsg = 'Please enter some search text !!';
	        showList = false;
    }
    
    
  }  
  
  //------------------------------------------Method to get survey details --------------------------------
  public void getCaseSurveyDetails( String selectedAcc){
    
            String totalCaseQuery = 'SELECT count() FROM Case where AccountId =:selectedAcc AND CreatedDate >= LAST_N_DAYS:30';
            detailsClass.totalCount = Database.countQuery(totalCaseQuery);
            List<String> closedStatusList = new List<String>{'Closed','Closed - No Response','Cancelled','Duplicate','Invalid'};
            String totalOpenCaseQuery = 'SELECT count() FROM Case where AccountId =:selectedAcc AND status NOT IN:closedStatusList';
            detailsClass.openCount = Database.countQuery(totalOpenCaseQuery);
            String surveyType = 'Support';
            String lastCsatScoreQuery = 'SELECT support_overall_sat_eval__c FROM Survey__c WHERE SurveyType__c =:surveyType AND Account__c =:selectedAcc ORDER BY Response_Date__c DESC LIMIT 1';
            List<Survey__c> surveyList = Database.query(lastCsatScoreQuery);
            detailsClass.lastCsatScore = surveyList.size() > 0?surveyList[0].support_overall_sat_eval__c:0;
            surveyType = 'Relationship';
            String csatScoreQuery = 'SELECT Likely_to_Recommend_Rel__c FROM Survey__c WHERE SurveyType__c =:surveyType AND Account__c =:selectedAcc ORDER BY Response_Date__c DESC LIMIT 1';
            surveyList = Database.query(csatScoreQuery);
            detailsClass.csatScore = surveyList.size() > 0?surveyList[0].Likely_to_Recommend_Rel__c:0;
            detailsClass.lastFiveCaseList = [SELECT ID,CaseNumber,Subject,Status,Support_Disposition_Level_3__c,CreatedDate,RecordTypeId FROM Case Where AccountId =:selectedAcc ORDER BY CreatedDate DESC LIMIT 5 ];
            detailsClass.dataTableClassForOpenCases.setObjectType('Case');
   			detailsClass.dataTableClassForOpenCases.setFieldList(new List<String>{'CaseNumber','Subject','Status','Support_Disposition_Level_3__c','CreatedDate','RecordTypeId'});
		    detailsClass.dataTableClassForOpenCases.setSizeOptions(new List<String>{'10','20','30','40','50'});
		    List<Object> paramList  = new List<Object>();
		   	paramList.add(
			   	new Map<String,Object>{
			        'name' 			=>'AccountId',
			        'operator'		=>'=',
			        'seperator'		=>'No',
			        'value'			=>selectedAcc
			    });
		    paramList.add(new Map<String,Object>{
		        'name' 			=>'status',
		        'operator'		=>'NOT IN',
		        'seperator'		=>'AND',
		        'value'			=>closedStatusList
		    });
		    detailsClass.dataTableClassForOpenCases.setParamList(paramList);
		   	detailsClass.dataTableClassForOpenCases.setSortByField('CreatedDate');
		    detailsClass.dataTableClassForOpenCases.setSortDirection('DESC');
		    detailsClass.dataTableClassForOpenCases.setList_size(10);
		    detailsClass.dataTableClassForOpenCases.prepareTable();
  }
  //--------------------------------------Method to get account details from selected account by user--------------------------------
  public Account getAccountDetails(String accId){
        Account tempAccount = [select Id,name,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,RC_User_ID__c,Partner_ID__c,RC_Brand__c,RC_Tier__c,MRR__c,Ultimate_Parent_Account_ID__c,
                        Red_Account_Status__c,CCExpireDate__c,Total_DLs__c,Total_Account_DL_s__c,Technical_Account_Manager__c,Technical_Account_Manager__r.name, 
                        VIP_Account_Indicator__c,Banner_Alert__c,CurrencyIsoCode,(SELECT ID from cases order by CreatedDate LIMIT 5) FROM ACCOUNT WHERE ID =:accId];
        return tempAccount;                 
  }
  
  //--------------------------------------Methods to convert phone number in formated phone number------------------------------------
  public static String formatphonenumber(String cphone) {
        String fphone = cphone.replaceAll('\\D','');
    	if (fphone.length() == 10) {
            fphone = formatphonenum(fphone);
            return fphone;
        }
        else {
            return cphone;
        }
    } 
    static String formatphonenum (String s) {
        s = '(' + s.substring(0, 3) + ') ' + s.substring(3, 6) + '-' + s.substring(6);
        return s;
    }
  
  //-------------------------------------Method initiate after users account selection if there are more then one account------------
  public void showAccount(){ 
    System.debug('~~~~~~~~~~selectedAccount'+selectedAccount);
    detailsClass.accountToShow = getAccountDetails(selectedAccount);
    if(detailsClass.accountToShow != null){
        showDetails = true;
        showNoAccount = false;
        showList = true;
        String accountId = String.valueOf(detailsClass.accountToShow.Id);        
        getCaseSurveyDetails(selectedAccount);
        if(String.isBlank(detailsClass.accountToShow.Ultimate_Parent_Account_ID__c)){
	    	detailsClass.parentChildValue = 'Parent';
	    }
	    else if(!String.isBlank(detailsClass.accountToShow.Ultimate_Parent_Account_ID__c) && detailsClass.accountToShow.Ultimate_Parent_Account_ID__c.equals(accountId.subString(0,15))){
	        detailsClass.parentChildValue = 'Parent';
	    }else if(!String.isBlank(detailsClass.accountToShow.Ultimate_Parent_Account_ID__c) && !detailsClass.accountToShow.Ultimate_Parent_Account_ID__c.equals(accountId.subString(0,15))){
	        detailsClass.parentChildValue = 'Child';
	    }
       
    }else{
        showDetails = false;
        showNoAccount = false;
        showList = true;
    }
    System.debug(detailsClass.accountToShow+'~~~~~~~~~~~~~~accountToShow');
  }
  //-------------------Method ends-------------------------------------------------------
  
  public class URLParamClass{
    public String dnis{get;set;}
    public String inContactId{get;set;}
    public String skillName{get;set;}
    public String campaignName{get;set;}
    public Campaign campObj{get;set;}
    public String accno{get;set;}
  }
  
  //-----------------------------------------Class containing information of cases for selected account----------
	public class AccountCaseClass{
	    public Account accountToShow{get;set;}
	    transient public String parentChildValue{get;set;}
	    transient public Integer totalCount{get;set;}
	    transient public Integer openCount{get;set;}
	    transient public Decimal lastCsatScore{get;set;}
	    transient public Decimal csatScore{get;set;}
	    public List<Case> lastFiveCaseList{get;set;}
	    public DataTableClass dataTableClassForOpenCases{get;set;}
	    
	    public AccountCaseClass(){
	    	dataTableClassForOpenCases = new DataTableClass();
	    }
	}
 
	  

  

}