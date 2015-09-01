/*
  *Extension on VAR_Deal_Registration__c used for update record.
  *The deal should only be marked as closed if the status is Approved, otherwise just put an error message: "Please approve this deal registration before marking it closed"
    **It is ok to edit these two fields when the deal registration is approved
  *Do allow the Channel Sales Manager to edit the close flag if they choose to update it after it is set.
*/
public with sharing class DealRegistrationExt {
  String IEE = Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');// For IE9   
  
  public  VAR_Deal_Registration__c dealRegistration { get; set; }
  
  @TestVisible private String APPROVED = 'Approved';
  @TestVisible private Boolean oldDealClosedValue {
   get {
   VAR_Deal_Registration__c tempDeal = [Select 
                       Deal_Closed__c 
                      From   
                      VAR_Deal_Registration__c 
                     Where
                      Id = : Apexpages.currentPage().getParameters().get('id')];
  
  return   tempDeal.Deal_Closed__c;      
    }}
 
  @TestVisible private String oldDealRegistrationAccountValue {
     get{
     VAR_Deal_Registration__c tempDeal = [Select 
                         DealRegistrationAccount__c 
                        From   
                        VAR_Deal_Registration__c 
                       Where
                         Id = : Apexpages.currentPage().getParameters().get('id')];
    
    return   tempDeal.DealRegistrationAccount__c;
  }} 
    
  
    public DealRegistrationExt() {
     dealRegistration = new VAR_Deal_Registration__c();

     try {
     dealRegistration = [Select 
                Deal_Closed__c, 
                DealRegistrationAccount__c,
                Registration_Status__c 
              From  
                VAR_Deal_Registration__c 
              Where
                Id = : Apexpages.currentPage().getParameters().get('id')];
     } catch (Exception ex) {}            
        
    }
/*
  *Check Deal is approved or not
*/ 
  public Boolean getIsApproved() {
      if( dealRegistration != null && dealRegistration.Registration_Status__c == APPROVED ) {
        return true;
       }
    return false;  
  }    

  public pageReference onUpdate() {
       try {
         if(dealRegistration != null && ( !isNullDealClosed( dealRegistration ) || !isNullDealRegistration( dealRegistration ) ) && isChanged( dealRegistration )){
             update dealRegistration;
             ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.INFO, ' Updated Successfully. ' ));
         }
         return null;
       } catch (Exception ex) {
          return null;
       } 
    return null;
   } 
  
   @TestVisible private Boolean isNullDealClosed(VAR_Deal_Registration__c dealRegistration){
      if(  dealRegistration !=null  &&  dealRegistration.Deal_Closed__c == null ) {
        return true;
      }
    return false;  
   }
  
   @TestVisible private Boolean isNullDealRegistration(VAR_Deal_Registration__c dealRegistration){
      if(dealRegistration != null && dealRegistration.DealRegistrationAccount__c == null){
        return true;
      }
   return false;
   }
     
   @TestVisible private Boolean isChanged(VAR_Deal_Registration__c dealRegistration) {
      if( dealRegistration !=null  && ( oldDealClosedValue != dealRegistration.Deal_Closed__c  || oldDealRegistrationAccountValue != dealRegistration.DealRegistrationAccount__c ) ) {
        return true;
      }
   return false;  
   }
}