public with sharing class Employee_Email_Component_CLS {

    public String employeeId {get;set;}
    public String publicDomain {get;set;}
    
    public String QMF_Id {get;set;}
    
    public Employee_Email_Component_CLS(){
        publicDomain = 'http://ringcentral.force.com/employee';
    }
    
    public String getUserProfilePicURLQMF() 
    {
        String photoUrl = '';
        List<Quality_Monitoring_Form__c > lstQMF= [SELECT Agent_Name__r.FullPhotoUrl FROM Quality_Monitoring_Form__c WHERE Id =:QMF_Id];
        if(lstQMF!= null && lstQMF.size() > 0){
            String fullPhotoUrl = lstQMF.get(0).Agent_Name__r.FullPhotoUrl;
            if(fullPhotoUrl != null && fullPhotoUrl.trim() != ''){
                photoUrl = publicDomain + fullPhotoUrl.split('.com')[1]; //Creating the Public URL of Image
            }
        }
        return photoUrl;
    }
    
    public String getUserProfilePicURL()
    {
        String photoUrl = '';
        List<Employee__c> lstEmployee = [SELECT User__r.FullPhotoUrl FROM Employee__c WHERE Id =:employeeId];
        if(lstEmployee != null && lstEmployee.size() > 0){
            String fullPhotoUrl = lstEmployee.get(0).User__r.FullPhotoUrl;
            if(fullPhotoUrl != null && fullPhotoUrl.trim() != ''){
                photoUrl = publicDomain + fullPhotoUrl.split('.com')[1]; //Creating the Public URL of Image
            }
        }
        return photoUrl;
    }
    
    
}