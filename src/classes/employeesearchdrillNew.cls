public class employeesearchdrillNew { 
    public employeesearchdrillNew (ApexPages.StandardController controller) {
           /*strTotalEmployee=null;
           division =new  List<String>();
           team=new  List<String>();
           manager=new List<String>();
           seletedTeam='';
           seletedManager='';
           seletedDepartment='';
           liKeySet=new List<String>();
           setMapEmployeeDetailsData();*/
    }


  /*public Map<String,List<Employee__c>> mapEmployeeDetails{get;set;}
  public Map<String,String> mapEmployeeDetails1{get;set;}
  public String strTotalEmployee{get;set;}
  public String strEmployee{get;set;}
  
  public Boolean isListExist{get;set;}
  public List<String> liKeySet{get;set;}
  public List<serchKeyClass> liKeySetClass{get;set;}
 
  
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
  
   public String seletedDepartment{get;set;}
   public String seletedTeam{get;set;}
   public String seletedManager{get;set;}
   
   List<String> department{get;set;}
   List<String> division {get;set;} //for division
   List<String> team{get;set;}
   List<String> manager{get;set;}
   List<Employee__c> managerAll; 
   
   public Map<String,String> mapDepartmentValues{get;set;}
   public Map<String,String> mapTeamValues{get;set;}
      
   List<Employee__c> managerALLId;   
  
  /* public employeesearchdrillNew () {
       strTotalEmployee=null;
       seletedTeam='';
       seletedManager='';
       seletedDepartment='';
       division =new  List<String>();
       team=new  List<String>();
       manager=new  List<String>();
       
       setMapEmployeeDetailsData();
   }*
    public void doSearch1(){
         setMapEmployeeDetailsData();
        
    }
    
    //Action for Search         
   /* public String getSelectedString(List<String> strvalue){
        String departmentString='';
        Integer i=0;
        for(String str:strvalue){
            if(i!=0){
                      departmentString=departmentString+',';
                    }
              departmentString=departmentString+'\''+str+'\'';
              i++;   
            }
            return departmentString;
    }*
    
    public void setMapEmployeeDetailsData() 
    {
     // system.debug('>>>>>>>>>>>>>>>>'+employees);
       String strQuery=' SELECT id,EmpID__c, First_Name__c, Employee_Nick_Name__c, Last_Name__c, Email__c, Phone_Cell__c, Phone_Work__c,'+
                        ' Location__c,Department__c,Division__c, Extension__c, Skills__c, Team__c, '+
                        ' Title__c, User__c,Manager_Employee_Number__c,ImageID__c,Manager_Employee_Number__r.EmpID__c, '+
                        ' Manager_Employee_Number__r.First_Name__c, Manager_Employee_Number__r.Last_Name__c,Manager_Employee_Number__r.Email__c '+
                        ' FROM Employee__c where  (Is_Active__c = true)';
       
       if(seletedDepartment!=null && seletedDepartment!=''){
           //strQuery=strQuery+' and Department__c IN ('+getSelectedString(seletedDepartment)+')';
            strQuery=strQuery+' and Department__c=\''+seletedDepartment+'\'';
       }                  
      if(division.size()>0){
          //strQuery=strQuery+' and Division__c IN ('+division+')';
      }
     if(seletedTeam!=null && seletedTeam!=''){
        //strQuery=strQuery+' and Team__c IN ('+getSelectedString(seletedTeam)+')';
        strQuery=strQuery+' and Team__c =\''+seletedTeam+'\'';
     }     
     if(seletedManager!=null && seletedManager!=''){
        // strQuery=strQuery+' and  Manager_Employee_Number__c IN ('+getSelectedString(seletedManager)+')';
          strQuery=strQuery+' and Manager_Employee_Number__r.EmpID__c=\''+seletedManager+'\'';
     }
     if(strEmployee!='' && strEmployee!=null && strEmployee.length()>1){
         strEmployee=strEmployee.trim();
         List <String> strName=strEmployee.split(' ');
         String strLastname='';
         strEmployee=strName.get(0).trim();
         strQuery=strQuery+' and( First_Name__c Like \'%'+strEmployee+'%\'';
         if(strName.size()>1){
             for(Integer ii=1;ii<=strName.size();ii++){
                    if(strName[ii]!='' && strName[ii]!=null){
                    strLastname=strName[ii].trim();
                    strQuery=strQuery+' or Last_Name__c Like \'%'+strLastname+'%\')';
               break;
               }
               }
         }else{
           strQuery=strQuery+')';
         }
       
     }else if(strEmployee!='' && strEmployee!=null && strEmployee.length()==1){
         strQuery=strQuery+' and First_Name__c Like \''+strEmployee+'%\'';
     }
      strQuery=strQuery+' order by First_Name__c asc';
     system.debug('>>>>>>>>>>>>>>>>>>>'+strQuery);
     
         employees= Database.query(strQuery);
         
         strTotalEmployee=String.valueOf(employees.size());
        isListExist=false;
        if(employees.size()>0){
         isListExist=true;
         }
         // system.debug('>>>>>>>>>>>>>>>>'+employees);
          List<Employee__c> liEmployee=new List<Employee__c>();
          String key='';
          String currentKey='';
          mapEmployeeDetails=new Map<String,List<Employee__c>>();
          liKeySet=new List<String>();
                for(Employee__c objEmployee:employees){
                      key=((objEmployee.First_Name__c.trim()).Substring(0,1));
                     System.debug('>>>>>>>>>>>>>>>>>>+'+objEmployee.First_Name__c+'>>>>>>>>>'+key+'currentKey>>'+currentKey);
                
                     if(currentKey==''){
                        currentKey=key;
                        liEmployee.add(objEmployee);
                      }else  if(key==currentKey){
                             liEmployee.add(objEmployee);
                      }else{
                             mapEmployeeDetails.put(currentKey,liEmployee);
                           
                             currentKey=key;
                             liEmployee=new List<Employee__c>();
                             liEmployee.add(objEmployee);
                       }
                 
                }
                if(mapEmployeeDetails.get(key)==null){
                     mapEmployeeDetails.put(key,liEmployee);
                }
                  liKeySet=new List<String>();
                  for(String strKey:mapEmployeeDetails.keySet()){
                      liKeySet.add(strKey);
                  }
                  if(liKeySet.size()>0){
                    liKeySet.sort();
                  }
                   
       setSearchTextLink();
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
       getTotalDepartmentValues();
       return department ;
     }
    
    String[] countries = new List<String>(); 

  /* public List<SelectOption> getItems() {
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
    }   * 
     public Map<String,String> getTotalDepartmentValues(){
         mapDepartmentValues=new Map<String,String>();
        try{
        if(department != null){
        	Set <String> strLabel=new Set<String>();
            for(String strLabel1:department  ){
                  //Integer iCount = [SELECT count()   FROM Employee__c where (Is_Active__c = true) and Department__c =:strLabel];
                  //mapDepartmentValues.put(strLabel,'('+iCount +')');
                   strLabel.add(strLabel1);
             } 
               List<AggregateResult> lstResult=[SELECT count(id) total,Department__c  FROM Employee__c where (Is_Active__c = true) and Department__c IN:strLabel group by Department__c ];
             Map<String,Integer> mapCount=new map<String ,Integer>();
             for(AggregateResult aResult:lstResult){
                mapCount.put((String)aResult.get('Department__c'),(Integer)aResult.get('total'));
             }
             
             for(String strLabel1:department){
                 Integer count=0;
                 if(mapCount.get(strLabel1)!=null){
                  count=mapCount.get(strLabel1);
                 }
              mapDepartmentValues.put(strLabel1,'('+count+')');
             }
           }
         }catch(Exception e){}     
        mapDepartmentValues=mapDepartmentValues;
       return mapDepartmentValues;
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
           getTotalTeamValues();
           return team ;
     }
     public Map<String,String> getTotalTeamValues(){
        mapTeamValues=new Map<String,String>();
       try{
        if(team != null){
        	  Set <String> strLabel=new Set<String>();
            for(String strLabel1:team ){
                 // Integer iCount = [SELECT count()   FROM Employee__c where (Is_Active__c = true) and Team__c = :strLabel];
                  //mapTeamValues.put(strLabel,'('+iCount +')');
                   strLabel.add(strLabel1);
             }
              List<AggregateResult> lstResult=[SELECT count(id) total,Team__c   FROM Employee__c where (Is_Active__c = true) and Team__c IN:strLabel group by Team__c ];
             Map<String,Integer> mapCount=new map<String ,Integer>();
             for(AggregateResult aResult:lstResult){
                mapCount.put((String)aResult.get('Team__c'),(Integer)aResult.get('total'));
             }
              for(String strLabel1:team ){
                 Integer count=0;
                 if(mapCount.get(strLabel1)!=null){
                  count=mapCount.get(strLabel1);
                 }
              mapTeamValues.put(strLabel1,'('+count+')');
             } 
       }
       
       
       }catch(Exception e){}
       mapTeamValues=mapTeamValues;
       return mapTeamValues;
     }
   
  public List<Employee__c> getManagerAll() 
    {
        //String[] countriesTemp = getCountries() ;
        getDepartment();
        String[] countriesTemp=department ;
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
   /* public List<SelectOption> getDivisionItems() {
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
    *
    public String[] getDivision() {
        return divisions;
    }
    
    public void setDivision(String[] divisionVal) {
        this.divisions = divisionVal;
    }
    
    
  
    
    String[] teams = new List<String>(); 

   /* public List<SelectOption> getTeamItems() {
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
*
    
    public String[] getTeam() {
        return teams;
    }
    
    public void setTeam(String[] teamVal) {
        this.teams = teamVal;
    }
    
    String[] managers = new List<String>(); 
  /*  public List<SelectOption> getManagerItems() {
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
    } *   
    
    public String[] getManager() {
        return managers;
    }
    
    public void setManager(String[] managerVal) {
        this.managers = managerVal;
    }
    public String visitorIPData {get;set;}
    //Check visitors IP against list of acceptable IP's
    public Boolean getShowDirectory(){
         String visitorIP = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        // String visitorIP = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
         visitorIPData =visitorIP;
        system.debug('Visitor IP is: ' + visitorIP);
         if(visitorIP == '216.156.83.186' || visitorIP == null || visitorIP == '24.6.163.79'){
            return true;
         }
         else if(visitorIP.startsWith('66.238.90.13')){
            // XO IP
            return true;
         }else if(visitorIP.startsWith('210.7.71')){
             return true;
         }else if(visitorIP.startsWith('65.205.207.12')){
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
     public void setSearchTextLink(){
        Map<String,Boolean> mapKey=new  Map<String,Boolean>();
        mapKey.put('A',false);
        mapKey.put('B',false);
        mapKey.put('C',false);
        mapKey.put('D',false);
        mapKey.put('E',false);
        mapKey.put('F',false);
        mapKey.put('G',false);
        mapKey.put('H',false);
        mapKey.put('I',false);
        mapKey.put('J',false);
        mapKey.put('K',false);
        mapKey.put('L',false);
        mapKey.put('B',false);
        mapKey.put('M',false);
        mapKey.put('N',false);
        mapKey.put('O',false);
        mapKey.put('P',false);
        mapKey.put('Q',false);
        mapKey.put('R',false);
        mapKey.put('S',false);
        mapKey.put('T',false);
        mapKey.put('U',false);
        mapKey.put('V',false);
        mapKey.put('W',false);
        mapKey.put('X',false);
        mapKey.put('Y',false);
        mapKey.put('Z',false);
      
      List <String> liKeySetText=new List<String>();
      liKeySetClass=new List<serchKeyClass>();
      for(String str:liKeySet){
         if(mapKey.get(str)!=null){
           mapKey.put(str,true);
         }else if(str!=null && str!=''){
            mapKey.put(str,true);
         }
      }
     
       for(String strKey:mapKey.keySet()){
               liKeySetText.add(strKey);
      }
       liKeySetText.sort();
       for(String obj:liKeySetText){
       serchKeyClass objserchKeyClass=new serchKeyClass();
       objserchKeyClass.strKey=obj;
       objserchKeyClass.isExist=mapKey.get(obj);
       liKeySetClass.add(objserchKeyClass);
       }
       
     }
   public PageReference showEmployeeByText(){
       if(liKeySet.size()>0){
         liKeySet=new List<String>();
         liKeySet.add(strEmployee);
      }
   return null;
   }
   private class serchKeyClass{
     public String strKey{get;set;}
     public Boolean isExist{get;set;}
   }

 /* public static testmethod void test() {
         Employee__c objEmp=new Employee__c();
         ApexPages.StandardController controller=new ApexPages.StandardController(objEmp);
         employeesearchdrillNew obj=new employeesearchdrillNew(controller);
         
        // ApexPages.currentPage().getParameters().put('id')
         obj.showEmployeeByText();
         obj.gettrueIP();
         obj.getShowDirectory();
         obj.getTeam();
         String[] str=new List<String>();
         obj.setTeam(str);
         obj.getDivision();
           
            obj.setDivision(str);
            obj.getDivisionValues();
            obj.getCountries();
            obj.getManagerAll();
            obj.getTotalTeamValues();
            obj.getTeamValues();
            obj.getTotalDepartmentValues();
            obj.getDepartment();
            obj.strEmployee='test test';
            obj.strEmployee='test test';
             obj.seletedManager='test test';
             obj.seletedTeam='test test';
             obj.seletedDepartment='test test';
             obj.getStrEmpNo();
             obj.setStrEmpNo('1233');
             obj.getIntCount();
             obj.setCountries(str);
             obj.getManager();
             obj.setManager(str);
             obj.doSearch1();
         
   } */
    
}