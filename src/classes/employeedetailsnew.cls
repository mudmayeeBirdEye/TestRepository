public class employeedetailsnew {
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

 Employee__c manager = new Employee__c();*/

public employeedetailsnew () {
 // empId1=null;
}

    public employeedetailsnew (ApexPages.StandardController controller) {
      //getEmpDetails();
    }
 /* public void getEmpDetails(){
     String empId=null;
     emp = new Employee__c();
          //system.debug('OPERATING AS CONTROLLER');
           if(empId1!=null){
                empId=empId1;
           } else{   
              empId=System.currentPagereference().getParameters().get('empId');
           }
         isRecordExist=false;
        if(empId!=null){  
       for(Employee__c objEmp:[SELECT id,EmpID__c, First_Name__c, Last_Name__c, Title__c, Email__c, Phone_Work__c, Extension__c, Phone_Cell__c, Location__c, Manager_Employee_Number__r.First_Name__c, Manager_Employee_Number__r.Last_Name__c, Department__c,Division__c, Skills__c, Team__c,  User__c, ImageID__c, Manager_Employee_Number__c, Manager_Employee_Number__r.Email__c , Manager_Employee_Number__r.EmpID__c, Manager_Employee_Number__r.Is_Active__c, IM__c, Hire_Date__c, Employee_Nick_Name__c   FROM Employee__c where EmpID__c=:empId and Is_Active__c = true]){
             emp =objEmp;
             isRecordExist=true;
       }
        //emp = [SELECT id,EmpID__c, First_Name__c, Last_Name__c, Title__c, Email__c, Phone_Work__c, Extension__c, Phone_Cell__c, Location__c, Manager_Employee_Number__r.First_Name__c, Manager_Employee_Number__r.Last_Name__c, Department__c,Division__c, Skills__c, Team__c,  User__c, ImageID__c, Manager_Employee_Number__c, Manager_Employee_Number__r.Email__c , Manager_Employee_Number__r.EmpID__c, Manager_Employee_Number__r.Is_Active__c, IM__c, Hire_Date__c, Employee_Nick_Name__c   FROM Employee__c where EmpID__c=:empId and Is_Active__c = true];
        isPeersExist=false;
        peers =  [SELECT id, EmpID__c, First_Name__c, Last_Name__c,Team__c FROM Employee__c  where Manager_Employee_Number__c  = :emp.Manager_Employee_Number__c and  Manager_Employee_Number__c <> null  and  EmpID__c <> :empId  and Is_Active__c = true order by First_Name__c asc ] ;
         if(peers.size()>0){
           isPeersExist=true;
         }
         isMgrTeamsExist=false;
        mgrTeams  =  [SELECT id, EmpID__c, First_Name__c, Last_Name__c FROM Employee__c  where Manager_Employee_Number__r.EmpID__c=:empId and Is_Active__c = true order by First_Name__c asc ] ;
       if(mgrTeams.size()>0){
         isMgrTeamsExist=true;
       }
    }
     }
   
   //Displays No Image wherever there is no image
    String strImageId;
    public String getImageID(){
        if(emp.ImageID__c==null){
        strImageId='01580000000pUZU';
        return strImageId;
        }else{
        strImageId=emp.ImageID__c;
        return strImageId;

        }
    }

    public String getEmpID(){
        return emp.EmpID__c;
    }


    public  List<Employee__c>  getempDet(){
        curEmp.add(emp);
        return curEmp;
    }

    
   
    public String getEmpName(){
        return emp.First_Name__c + ' ' +  emp.Last_Name__c ;
    }
    
    public String getEmpNickName(){
        return emp.Employee_Nick_Name__c ;
    }
    
  public String getTitle(){
        return emp.Title__c;
    }
       
    public String getEmpEmail(){
        return emp.Email__c;
    }
    

   public String getPhoneWork(){
        return emp.Phone_Work__c;
    }

   public String getExtension(){
        return emp.Extension__c;
    }

    public String getPhoneCell(){
        return emp.Phone_Cell__c;
    }
 
    public String getLocation(){
        return emp.Location__c;
    }
    
    public String getImId(){
        return emp.IM__c;
    }
    
     public String getHireDate(){
        String strDate ;
        if (emp.Hire_Date__c != null){
        Datetime stDate = emp.Hire_Date__c;
        strDate = stDate.format('MMMM dd,yyyy');
       
        }else{
             strDate = '' ;
        }
        
         return strDate ;
        
        
    }
   
    /* public String getStartDate(){
        return emp.Start_Date__c.format('dd-mmm-yyyy');
        
    }*
    
public String IsManager(){
    String mId = emp.Manager_Employee_Number__r.EmpID__c ;
    if (mId == null){
        mId = '0';
    }

        return mId ;
    }


 public String getManagerId(){
    String mId = emp.Manager_Employee_Number__r.EmpID__c ;
    Boolean chk = !(emp.Manager_Employee_Number__r.Is_Active__c) ;
    if (mId == null || chk ){
        mId = getEmpID();
    }

        return mId ;
    }

   public String getManagerName(){
    String chkMgr = IsManager() ;
    String mName ;
    if (chkMgr .equals('0')) { mName = getEmpName() ;

    } else { mName = emp.Manager_Employee_Number__r.First_Name__c + ' ' + emp.Manager_Employee_Number__r.Last_Name__c  ;
    }   
    
        return mName;
    }

public String getMgrEmail(){
    String mMail = emp.Manager_Employee_Number__r.Email__c  ;
    if (mMail   == null){
        mMail   = getEmpEmail();
    }

        return mMail  ;
    }

    
    public String getDepartment(){
        return emp.Department__c;
    }
    
    public String getDivision(){
        return emp.Division__c;
    }
    
   public String getTeam(){
        return emp.Team__c;
    }
    
    public String getSkills(){
        return emp.Skills__c;
    }
    
     public List<Employee__c> getPeers() {
            //if(peers == null ){peers =  [SELECT id, EmpID__c, First_Name__c, Last_Name__c FROM Employee__c  where Manager_Employee_Number__c  = :emp.Manager_Employee_Number__c and  Manager_Employee_Number__c <> null  and  EmpID__c <> :empId order by First_Name__c asc ] ;}
        return peers;
    }

    public List<Employee__c> getMgdTeams() {
        //if (mgrTeams ==null ){mgrTeams  =  [SELECT id, EmpID__c, First_Name__c, Last_Name__c FROM Employee__c  where Manager_Employee_Number__r.EmpID__c=:empId order by First_Name__c asc  ] ;}
       return mgrTeams;
    }

    //Check visitors IP against list of acceptable IP's
    public Boolean getShowDirectory(){
        String visitorIP = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        system.debug('Visitor IP is: ' + visitorIP);
         if(visitorIP == '216.156.83.186' || visitorIP == null || visitorIP == '24.6.163.79' ){
            return true;
         }else if(visitorIP.startsWith('210.7.71')){
         	//India Team
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
          //  Done Changes as Per Wilson Email On 5/25/2011
      
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
      //  Above Changes As Per Wilson Email On 5/25/2011
    
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
 public pageReference showEmployeeDetails(){
       system.debug('>>>>>>>>>>>>>>> empId1='+empId1);
       getEmpDetails();
       system.debug('>>>>>>>>>>>>>>> isRecordExist='+isRecordExist);
       return null;
    }
    /*  public static testmethod void test() {
         Employee__c objEmp=new Employee__c();
         employeedetailsnew  obj2=new employeedetailsnew ();
         ApexPages.StandardController controller=new ApexPages.StandardController(objEmp);
        employeedetailsnew obj=new employeedetailsnew (controller);
        System.currentPagereference().getParameters().put('empId','123345');
        obj.getEmpDetails();
        obj.getPeers();
        obj.getMgdTeams();
        obj.getShowDirectory();
        obj.showEmployeeDetails();
        obj.getImageID();
        obj.getEmpID();
        obj.getEmpName();
        obj.getEmpNickName();
        obj.getTitle();
        obj.getTitle();
        obj.getEmpEmail();
        obj.getPhoneWork();
        obj.getExtension();
        obj.getPhoneCell();
        obj.getLocation();
        obj.getImId();
        obj.getHireDate();
        obj.IsManager();
        obj.getManagerId();
        obj.getManagerName();
        obj.getMgrEmail();
        obj.getDepartment();
        obj.getDivision();
        obj.getTeam();
        obj.getSkills();
        obj.getempDet();
        obj.getAuthorizationError();
    }*/
    
    
    }