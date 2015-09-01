public with sharing class EmployeeCustomLookupCtrl {
  
  public Employee__c emp {get;set;} // new Employee to create
  public List<Employee__c> results{get;set;} // search results
  public String searchString{get;set;} // search keyword
 
  public EmployeeCustomLookupCtrl() {
    emp  = new Employee__c();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }
 
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
 
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 
 
  // run the search and return the records found. 
  private List<Employee__c> performSearch(String searchString) {
 
    searchString =  String.escapeSingleQuotes( searchString ).trim();
   
    String soql = 'SELECT id, Name, Last_Name__c,First_Name__c,Manager_Name__c , Location__c, Email__c,Department__c FROM Employee__c';
    if(searchString != '' && searchString != null)
    soql = soql +  ' WHERE Name LIKE \'%' + searchString +'%\' OR First_Name__c LIKE \'%' + searchString +'%\' OR Last_Name__c LIKE \'%' + searchString +'%\' OR Email__c LIKE \'%' + searchString +'%\' ';
    soql = soql + ' ORDER BY First_Name__c LIMIT 25';
    
    System.debug(soql);
    
    return database.query(soql); 
 
  }
 
  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
  
  /*
  * Unit Test
  */
  //	@isTest(SeeAllData=true)
 	/*public static testMethod void  EmployeeCustomLookupCtrl(){
 		
 		Employee__c emp = new Employee__c();
        emp.First_Name__c = 'tuser';
        emp.Last_Name__c = 'lname';
        emp.Email__c ='clc@clc.com';
        emp.Location__c = 'Noida, India';
        emp.Department__c = 'IT';
        emp.Team__c = 'SE';
        emp.SPID__c = '12454';
        insert emp;
        
        PageReference pageRef = Page.CustomEmployeeLookup;   
 		Test.setCurrentPageReference(pageRef);
    	Apexpages.currentPage().getParameters().put('lksrch', 'tuser');
    	
    	EmployeeCustomLookupCtrl eclc = new EmployeeCustomLookupCtrl();
    	eclc.search();
    	eclc.getFormTag();
    	eclc.getTextBox(); 
        
 	}*/
}