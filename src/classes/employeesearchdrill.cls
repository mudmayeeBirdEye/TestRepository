public class employeesearchdrill { 
    public employeesearchdrill(ApexPages.StandardSetController controller) {
         //controller.setPageSize(10); 
    }

/*

 Employee__c emp = new Employee__c();
 Integer intCount=1;

   String strRowBgColor=''; 
   String strEmpNo;
   public String getStrEmpNo(){
       return strEmpNo;
   }   
   public void setStrEmpNo(String strEmpNo){
       this.strEmpNo=strEmpNo;
   }   
      
      
   List<Employee__c> employees;
   List<String> department; 
   List<String> division; //for division
   List<String> team;
   List<String> manager;
   List<Employee__c> managerAll; 
   
   List<Employee__c> managerALLId;   
   public employeesearchdrill (ApexPages.StandardController controller) {   
   }
   public employeesearchdrill () {   
   }
           
    //Action for Search         
    public PageReference doSearch()
    { 
        getManagerItems();
        String strSelDep = '';
        String[] countriesTemp = getCountries();      
        String[] DivisionTemp = getDivision();   
        String[] teamTemp = getTeam();   
        String[] managerTemp = getManager();  
      String strFname = '' ;
      String strLname = '' ;

                  
        if(countriesTemp != null){
           for(Integer counter=0;counter<countriesTemp.size();counter++)
           {          
                strSelDep += countriesTemp[counter] + ',';    
           } 
           strSelDep = strSelDep+'---';       
       }
       
       String STRTEST = 'SELECT id,EmpID__c, First_Name__c, Last_Name__c, Employee_Nick_Name__c, Email__c, Phone_Cell__c, Phone_Work__c, Location__c,Department__c,Division__c, Extension__c, Skills__c, Team__c, Title__c, User__c,Manager_Employee_Number__c,ImageID__c,Manager_Employee_Number__r.First_Name__c, Manager_Employee_Number__r.Last_Name__c,Manager_Employee_Number__r.EmpID__c   FROM  Employee__c ';
       String strWhere = 'where (Is_Active__c = true) ';
       if(strEmpNo != '' && strEmpNo != null){
            String myString = strEmpNo ;
            Boolean result = myString.contains(' ');

            if (!result){

                strFname = myString ;
                strLname = myString ;
                //System.debug('The name is ' + strFname + ' ' +  strLname);
            }else{
                Integer intSpace = myString.indexOf(' ', 0);
                Integer intLength = myString.length() ;
                strFname = myString.substring(0,intSpace)  ;
                strFname = strFname.trim()  ;
                strLname = myString.substring(intSpace, intLength)  ;
                strLname = strLname.trim()  ;
                //System.debug('The name is ' + strFname + ' ' +  strLname);

            }
        
        
           //strWhere += ' and ( EmpID__c=\''+strEmpNo+'\' or Department__c=\''+strEmpNo+'\' or Team__c=\''+strEmpNo+'\' or Employee_Nick_Name__c=\''+strEmpNo+'\' or Email__c=\''+strEmpNo+'\' or First_Name__c=\''+strFname+'\' or Last_Name__c=\''+strLname+'\' ) ';            
           strWhere += ' and ( EmpID__c=\''+strEmpNo+'\' or Department__c=\''+strEmpNo+'\' or Team__c=\''+strEmpNo+'\' or Employee_Nick_Name__c like \'%'+strEmpNo+'%\' or Email__c=\''+strEmpNo+'\' or First_Name__c=\''+strFname+'\' or Last_Name__c=\''+strLname+'\' ) ';
          
            
            
        }
       String strOr = '';
      if((countriesTemp.size() > 0) ||(DivisionTemp.size() > 0) || (teamTemp.size() > 0)){            
               
        
        if(countriesTemp.size() > 0){
            if(strOr.equals('')){
                strOr += ' and ( Department__c in :countriesTemp ';
            }else{
                strOr += ' or Department__c in :countriesTemp ';
            }

        }
        if(DivisionTemp.size() > 0){
             if(strOr.equals('')){
                strOr += ' and ( Division__c in :DivisionTemp ';
            }else{
                strOr += ' or Division__c in :DivisionTemp ';
            }

            
        }
        if(teamTemp.size() > 0){
            
             if(strOr.equals('')){
                strOr += ' and ( Team__c in :teamTemp ';                 
            }else{
                strOr += ' or Team__c in :teamTemp ';
            }

            
        }
        /*
        if(managerTemp.size() > 0){
                           
            if(strOr.equals('')){                
                strOr += ' and ( Manager_Employee_Number__c in :managerTemp ';
            }else{                  
                strOr += ' or  Manager_Employee_Number__c in :managerTemp';
            }

            
        }
        *
        
        if(!(strOr.equals(''))){
            strOr += ')';
        }
        
        
        STRTEST += strWhere;   
        STRTEST += strOr;  
        STRTEST += ' order by First_Name__c asc';
        System.debug('STRTEST='+STRTEST);
        
        
        try{
            employees = Database.query(STRTEST);
           //System.assert(false, STRTEST );    
        }catch(exception ex){
            //System.assert(false, STRTEST );           
        }           
        //employees= [SELECT id,EmpID__c, First_Name__c, Last_Name__c, Email__c, Phone_Cell__c, Phone_Work__c, Location__c,Department__c,Division__c, Extension__c, Skills__c, Team__c, Title__c, User__c,Manager_Employee_Number__c,ImageID__c  FROM Employee__c where Department__c=:strEmpNo order by First_Name__c asc];        
      }else{
        if(strEmpNo != null && strEmpNo != ''){   
            String myString = strEmpNo ;
            Boolean result = myString.contains(' ');
        

            if (!result){

                strFname = myString ;
                strLname = myString ;
                //System.debug('The name is ' + strFname + ' ' +  strLname);
            }else{
                Integer intSpace = myString.indexOf(' ', 0);
                Integer intLength = myString.length() ;
                strFname = myString.substring(0,intSpace)  ;
                strFname = strFname.trim()  ;
                strLname = myString.substring(intSpace, intLength)  ;
                strLname = strLname.trim()  ;
                //System.debug('The name is ' + strFname + ' ' +  strLname);

            }
        }    
        if(managerTemp.size() > 0){                
                employees= [SELECT id,EmpID__c, First_Name__c, Last_Name__c, Employee_Nick_Name__c, Email__c, Phone_Cell__c, Phone_Work__c, Location__c,Department__c,Division__c, Extension__c, Skills__c, Team__c, Title__c, User__c,Manager_Employee_Number__c,ImageID__c,Manager_Employee_Number__r.First_Name__c, Manager_Employee_Number__r.Last_Name__c,Manager_Employee_Number__r.EmpID__c   FROM Employee__c where  (Is_Active__c = true) and ( Manager_Employee_Number__c in :managerTemp) and ( EmpID__c=:strEmpNo or Department__c=:strEmpNo or Team__c=:strEmpNo or Email__c=:strEmpNo or First_Name__c like :('%' + strFname + '%') or Last_Name__c like :('%' + strLname + '%') or Employee_Nick_Name__c like :('%' + strEmpNo + '%')  )  order by First_Name__c asc];
            }else{                  
                employees= [SELECT id,EmpID__c, First_Name__c, Last_Name__c, Employee_Nick_Name__c, Email__c, Phone_Cell__c, Phone_Work__c, Location__c,Department__c,Division__c, Extension__c, Skills__c, Team__c, Title__c, User__c,Manager_Employee_Number__c,ImageID__c,Manager_Employee_Number__r.First_Name__c, Manager_Employee_Number__r.Last_Name__c,Manager_Employee_Number__r.EmpID__c   FROM Employee__c where  (Is_Active__c = true) and ( EmpID__c=:strEmpNo or Department__c=:strEmpNo or Team__c=:strEmpNo or Email__c=:strEmpNo or First_Name__c like :('%' + strFname + '%') or Last_Name__c like :('%' + strLname + '%')  or Employee_Nick_Name__c like :('%' + strEmpNo + '%') )  order by First_Name__c asc];
            } 
         
      }     
      return null;
    }       
    
    
    public List<Employee__c> getEmployees() 
    {
       if(strEmpNo==null){
          if(employees== null)
          {
             employees= [SELECT id,EmpID__c, First_Name__c, Employee_Nick_Name__c, Last_Name__c, Email__c, Phone_Cell__c, Phone_Work__c, Location__c,Department__c,Division__c, Extension__c, Skills__c, Team__c, Title__c, User__c,Manager_Employee_Number__c,ImageID__c,Manager_Employee_Number__r.EmpID__c, Manager_Employee_Number__r.First_Name__c, Manager_Employee_Number__r.Last_Name__c  FROM Employee__c where  (Is_Active__c = true) order by First_Name__c asc];
          }
       }
       return employees;
    } 
      
    public Integer getIntCount()
    {
         return intCount;
    }
    
    //Get the PickList value for Department
    public List<String>  getDepartment(){
       List<String> options = new List<String>();
       Schema.DescribeFieldResult fieldResult = Employee__c.Department__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
       for( Schema.PicklistEntry f : ple)
       {
       options.add(f.getValue()); 
       }
       department = options;
       return department ;
     }
    
    String[] countries = new List<String>(); 

   public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        department  =  getDepartment();
        if(department != null)
        {
            Integer iCount;
            String strLabel ; 
          for(Integer counter=0;counter<department.size();counter++)
           {

        strLabel = department.get(counter) ;
            iCount = [SELECT count()   FROM Employee__c where (Is_Active__c = true) and Department__c =:strLabel];
            strLabel = strLabel + '  (' + iCount + ')';
       
                options.add(new SelectOption(department.get(counter),strLabel));
        iCount = 0 ;
        strLabel ='';
        
           }        
       }
       return options;
    }    

    
    public String[] getCountries() {
        return countries;
    }
    
    public void setCountries(String[] countries) {
        this.countries = countries;
    }
    
    // code for divison
    public List<String>  getDivisionValues(){
       List<String> options = new List<String>();
       Schema.DescribeFieldResult fieldResult = Employee__c.Division__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
       for( Schema.PicklistEntry f : ple)
       {
        options.add(f.getValue()); 
       }
       division = options;
       return division ;
     }
    
    String[] divisions = new List<String>(); 
    public List<SelectOption> getDivisionItems() {
        List<SelectOption> options = new List<SelectOption>();
        division  =  getDivisionValues();
        if(division != null)
        {
           for(Integer counter=0;counter<division.size();counter++)
           {          
               options.add(new SelectOption(division.get(counter),division.get(counter)));       
           }        
       }
       return options;
    }    
    
    public String[] getDivision() {
        return divisions;
    }
    
    public void setDivision(String[] divisionVal) {
        this.divisions = divisionVal;
    }
    
    
    // code for Team
    public List<String>  getTeamValues(){
       List<String> options = new List<String>();
       Schema.DescribeFieldResult fieldResult = Employee__c.Team__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
       for( Schema.PicklistEntry f : ple)
       {
        options.add(f.getValue()); 
       }
       team = options;
       return team ;
     }
    
    String[] teams = new List<String>(); 

    public List<SelectOption> getTeamItems() {
        List<SelectOption> options = new List<SelectOption>();
        team  =  getTeamValues();
        if(team != null)
        {
        Integer iCount;
            String strLabel ;
           for(Integer counter=0;counter<team.size();counter++)
           { 
        strLabel = team.get(counter) ;
            iCount = [SELECT count()   FROM Employee__c where (Is_Active__c = true) and Team__c = :strLabel];
            strLabel = strLabel + '  (' + iCount + ')' ;                 
               options.add(new SelectOption(team.get(counter),strLabel)); 
        iCount = 0 ;
        strLabel =''; 
         
           }        
       }
       return options;
    }    

    
    public String[] getTeam() {
        return teams;
    }
    
    public void setTeam(String[] teamVal) {
        this.teams = teamVal;
    }
    
    // code for Manager
     /*public List<String>  getManagerValues(){
       List<String> options = new List<String>();
       Schema.DescribeFieldResult fieldResult = Employee__c.Manager_Employee_Number__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
       for( Schema.PicklistEntry f : ple)
       {
        options.add(f.getValue()); 
       }
       manager = options;
       return manager ;
     }*
     
    public List<Employee__c> getManagerAll() 
    {
        String[] countriesTemp = getCountries() ;
        String[] managerALLIdStr = new List<String>();
        if(countriesTemp.size() > 0){               
            managerALLId = [select Manager_Employee_Number__c,Manager_Employee_Number__r.EmpID__c from Employee__c where (Is_Active__c = true) and Manager_Employee_Number__c <> null];                 
            if(managerALLId.size() > 0)
            {
                managerALLIdStr = new String[managerALLId.size()];
               for(Integer counter=0;counter<managerALLId.size();counter++)
               {   
                  managerALLIdStr.add(counter, managerALLId.get(counter).Manager_Employee_Number__r.EmpID__c);
               }                         
           }          
        //managerAll= [SELECT id,EmpID__c, First_Name__c, Last_Name__c  FROM Employee__c where EmpID__c in :managerALLIdStr and Department__c in:countriesTemp order by First_Name__c asc];
        managerAll= [SELECT id,EmpID__c, First_Name__c, Last_Name__c  FROM Employee__c where (Is_Active__c = true) and EmpID__c in :managerALLIdStr and Department__c in:countriesTemp order by First_Name__c asc];
        //System.assert(false,managerALLIdStr);
        
        }else{        
        }
        
       return managerAll;
    }
    
    String[] managers = new List<String>(); 
    public List<SelectOption> getManagerItems() {
       List<SelectOption> options = new List<SelectOption>();    
       managerAll = getManagerAll();       
       if(managerAll != null)
        {
           for(Integer counter=0;counter<managerAll.size();counter++)
           {          
               options.add(new SelectOption(managerAll.get(counter).id,managerAll.get(counter).First_Name__c + ' ' + managerAll.get(counter).Last_Name__c));       
           }        
       }
       return options;
    }    
    
    public String[] getManager() {
        return managers;
    }
    
    public void setManager(String[] managerVal) {
        this.managers = managerVal;
    }
    
    //Check visitors IP against list of acceptable IP's
    public Boolean getShowDirectory(){
        String visitorIP = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        system.debug('Visitor IP is: ' + visitorIP);
         if(visitorIP == '216.156.83.186' || visitorIP == null || visitorIP == '24.6.163.79'){
            return true;
         }
         else if(visitorIP.startsWith('66.238.90.13')){
            // XO IP
            return true;
         }
         else if(visitorIP.startsWith('65.205.207.12')){
            // Verizon IP
            return true;
         }
         else if(visitorIP.startsWith('65.113.43.20')){
            // Qwest IP
            return true;
         }
         else if(visitorIP.startsWith('67.103.123.4')){
            // Covad IP
            return true;
         }
         else if(visitorIP.startsWith('198.107.149.')){
            // Manila IP
            return true;
         }
         else if(visitorIP.startsWith('119.93.30.')){
            // Manila IP
            return true;
         }
         else if(visitorIP.startsWith('202.136.40.')){
            // Manila IP
            return true;
         }
         else if(visitorIP == '212.119.180.46'){
            // SPB IP
            return true;
         }
         else if(visitorIP.startsWith('212.119.189.')){
            // SPB IP
            return true;
         }
         else if(visitorIP == '79.142.83.118'){
            // SPB IP
            return true;
         }
         else if(visitorIP == '217.79.3.62'){
            // SPB IP
            return true;
         }
         else if(visitorIP.startsWith('193.104.181.')){
            // SPB IP
            return true;
         }
         else if(visitorIP.startsWith('195.114.135.')){
            // Odessa IP
            return true;
         }
         else if(visitorIP.startsWith('195.138.74.')){
            // Odessa IP
            return true;
         }
         else if(visitorIP.startsWith('122.160.68.250')){
            // Odessa IP
            return true;
         } 
          //  Done Changes As Wilson Email On 5/25/2011
      
          else if(visitorIP == '69.33.165.144'){
            // Megapath/Covad
            return true;
         } 
          else if(visitorIP == '69.33.165.146'){
            // Megapath/Covad
            return true;
         } 
          else if(visitorIP == '69.33.165.147'){
            // Megapath/Covad
            return true;
         } 
          else if(visitorIP == '69.33.165.148'){
            // Megapath/Covad
            return true;
         } 
          else if(visitorIP == '69.33.165.149'){
            // Megapath/Covad
            return true;
         } 
          else if(visitorIP == '69.33.165.150'){
            // Megapath/Covad
            return true;
         } 
          else if(visitorIP == '24.221.195.249'){
            // Sprint 4G(650-274-2555)
            return true;
         } 
          else if(visitorIP == '24.221.196.119'){
            // Sprint 4G(650-274-1479)
            return true;
         }           
      //  Above Changes As Wilson Email On 5/25/2011
    
      //  For Denver as per Sunil Email On 6/24/2011
          else if(visitorIP == '38.109.202.162'){
            // For Denver
            return true;
         }       
        return false;               
    }
    
    public Boolean getAuthorizationError(){
        if(getShowDirectory() == false){
            return true;
        }
        return false;
    }
    
   /* public String getmyIP(){
        return ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
    }
    *
    public String gettrueIP(){
        return ApexPages.currentPage().getHeaders().get('True-Client-IP');
    }
    
    
    //for Pagination
    
    
   /* public PageReference next() {
       return null;
    }
    public PageReference previous() {
        return null;
    }
    public Boolean hasPrevious {
        get {return employees.getHasPrevious();     }
    }
    */
   
    
    
}