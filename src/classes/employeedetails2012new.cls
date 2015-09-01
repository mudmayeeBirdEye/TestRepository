public with sharing class employeedetails2012new {
/*	
public Boolean isRecordExist{get;set;}
public Boolean isPeersExist{get;set;}
public Boolean isMgrTeamsExist{get;set;}

public String empId1{get;set;}
String empId;
 public Employee__c emp {get;set;}
List<Employee__c> curEmp = new List<Employee__c>() ;
 List<Employee__c> peers = new List<Employee__c>() ;
 List<Employee__c> mgrTeams = new List<Employee__c>() ;

 //Employee__c manager = new Employee__c();*/

public employeedetails2012new () {
  //empId1=null;
}

    public employeedetails2012new (ApexPages.StandardController controller) {
      //getEmpDetails();
    }
 /* public void getEmpDetails(){
     String empId=null;
    emp = new Employee__c();
          //system.debug('OPERATING AS CONTROLLER');
           if(empId1!=null){
                empId=empId1;
           } else{   
              empId=System.currentPagereference().getParameters().get('id');
           }
         isRecordExist=false;
        if(empId!=null){  
       for(Employee__c objEmp:[SELECT id,EmpID__c, First_Name__c, Last_Name__c, Title__c, Email__c, Phone_Work__c, Extension__c, Phone_Cell__c, Location__c, Manager_Employee_Number__r.First_Name__c, Manager_Employee_Number__r.Last_Name__c, Department__c,Division__c, Skills__c, Team__c,  User__c, ImageID__c, Manager_Employee_Number__c, Manager_Employee_Number__r.Email__c , Manager_Employee_Number__r.EmpID__c, Manager_Employee_Number__r.Is_Active__c, IM__c, Hire_Date__c, Employee_Nick_Name__c   FROM Employee__c where id=:empId and Is_Active__c = true]){
             emp =objEmp;
             isRecordExist=true;
       }
        //emp = [SELECT id,EmpID__c, First_Name__c, Last_Name__c, Title__c, Email__c, Phone_Work__c, Extension__c, Phone_Cell__c, Location__c, Manager_Employee_Number__r.First_Name__c, Manager_Employee_Number__r.Last_Name__c, Department__c,Division__c, Skills__c, Team__c,  User__c, ImageID__c, Manager_Employee_Number__c, Manager_Employee_Number__r.Email__c , Manager_Employee_Number__r.EmpID__c, Manager_Employee_Number__r.Is_Active__c, IM__c, Hire_Date__c, Employee_Nick_Name__c   FROM Employee__c where EmpID__c=:empId and Is_Active__c = true];
        isPeersExist=false;
        peers =  [SELECT id, EmpID__c, First_Name__c, Last_Name__c,Team__c FROM Employee__c  where Manager_Employee_Number__c  = :emp.Manager_Employee_Number__c and  Manager_Employee_Number__c <> null  and  EmpID__c <> :emp.EmpID__c  and Is_Active__c = true order by First_Name__c asc ] ;
         if(peers.size()>0){
           isPeersExist=true;
         }
         isMgrTeamsExist=false;
        mgrTeams  =  [SELECT id, EmpID__c, First_Name__c, Last_Name__c FROM Employee__c  where Manager_Employee_Number__r.EmpID__c=:emp.EmpID__c and Is_Active__c = true order by First_Name__c asc ] ;
       if(mgrTeams.size()>0){
         isMgrTeamsExist=true;
       }
    }
     }
   
  
    
     public List<Employee__c> getPeers() {
            //if(peers == null ){peers =  [SELECT id, EmpID__c, First_Name__c, Last_Name__c FROM Employee__c  where Manager_Employee_Number__c  = :emp.Manager_Employee_Number__c and  Manager_Employee_Number__c <> null  and  EmpID__c <> :empId order by First_Name__c asc ] ;}
        return peers;
    }

    public List<Employee__c> getMgdTeams() {
        //if (mgrTeams ==null ){mgrTeams  =  [SELECT id, EmpID__c, First_Name__c, Last_Name__c FROM Employee__c  where Manager_Employee_Number__r.EmpID__c=:empId order by First_Name__c asc  ] ;}
       return mgrTeams;
    }

  
     /* public static testmethod void test() {
         Employee__c objEmp=new Employee__c();
         employeedetails2012new  obj2=new employeedetails2012new ();
         ApexPages.StandardController controller=new ApexPages.StandardController(objEmp);
        employeedetailsnew obj=new employeedetailsnew (controller);
        System.currentPagereference().getParameters().put('id','123345');
        obj.getEmpDetails();
        obj.getPeers();
        obj.getMgdTeams();
        
    }*/
    
}