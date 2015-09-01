public with sharing class TestBTDealRegistrationAPI {
    
    public String partnerAgentName {get;set;} 
    public String partnerAgentId {get;set;} 
    public String company {get;set;} 
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String emailId {get;set;}
    public String phone {get;set;}
    public String numberOfEmployees {get;set;} 
    public String zipCode {get;set;}
    public Map<String,Object> responseObj {get;set;}
    public decimal responseTime {get;set;}
    
    public TestBTDealRegistrationAPI(){}
    
    public PageReference callBTAPI(){
        decimal startTime = System.currentTimeMillis();
        try{
            partnerSoapSforceCom_pro.Soap sp = new partnerSoapSforceCom_pro.Soap();
            String username = 'rajeev_pandey@simplion.com';
            String password = 'myfriend@22073DyEtpbdDC330RNjA9A2xp1Pc';
            partnerSoapSforceCom_pro.LoginResult loginResult = sp.login(username , password);
            DealRegistrationSubmissionCls_pro.DealRegistrationSubmissionCls apexWebSvc = new DealRegistrationSubmissionCls_pro.DealRegistrationSubmissionCls();
            DealRegistrationSubmissionCls_pro.SessionHeader_element sessionHeader = new DealRegistrationSubmissionCls_pro.SessionHeader_element();
            sessionHeader.sessionId = loginResult.sessionId;
            apexWebSvc.timeout_x = 120000;
            apexWebSvc.SessionHeader = sessionHeader;
            
            // Invoke API Method
            String responseString = apexWebSvc.submitDealRegistration(partnerAgentName, partnerAgentId, company, firstName, lastName, emailId, phone, numberOfEmployees, zipCode);
            responseObj = (Map<String,Object>) JSON.deserializeUntyped(responseString);
            system.debug('responseObj ===== ' + responseObj);
        }catch(Exception ex){
            system.debug('Exception ===== ' + ex.getMessage());
            system.debug('Exception ===== ' + ex.getStackTraceString());
        }
        decimal endTime = System.currentTimeMillis();
        responseTime = (endTime - startTime) * 0.001;
        return null;
    }
}