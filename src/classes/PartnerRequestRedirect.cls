/*............. controller class created for the Population required 
.........information of Lead and Contact object in Reseller...........
Request custom object created date ........15/05/2014   ............*/

public with sharing class PartnerRequestRedirect {
    public string leadId;
    public string contactId;
    public Lead leadObj;
    public Contact contactObj;
    
    /*..........  Constructor ......... */
    public PartnerRequestRedirect() {
        if(ApexPages.currentPage().getParameters().get('leadId') != null &&
            ApexPages.currentPage().getParameters().get('leadId') != '') {
            leadId = ApexPages.currentPage().getParameters().get('leadId');
            system.debug('@@@@@@@@@@7777'+leadId);
            leadObj = new Lead();
            leadObj = [select FirstName,LastName,Company,OwnerId,Owner.Name,Email,Phone,Country,State,City,PostalCode,Street,Partner_Address1__c,Partner_Address2__c from Lead where Id = :leadId];
        } else if(ApexPages.currentPage().getParameters().get('contactId') != null &&
            ApexPages.currentPage().getParameters().get('contactId') != '') {
            contactId = ApexPages.currentPage().getParameters().get('contactId');
            contactObj= new Contact();
            contactObj = [select FirstName,Company__c,LastName,Email,Owner.Name,Phone,MailingCountry,MailingCity,MailingStreet,MailingState,MailingPostalCode from Contact where Id=:contactId];
        }
    }
        
    /*..... Method to get redirect to reseller Custom Object
     and populate required info of Lead and Contact object .......... */
     
    public PageReference redirectToPartnerRequest() {
        if(leadId != null && leadId != '') {        	
            PageReference objPageRef = new PageReference('/a0S/e');            
            objPageRef.getParameters().put('leadId',leadObj.Id);
            objPageRef.getParameters().put('00N80000004hbZV',leadObj.FirstName);
            objPageRef.getParameters().put('00N80000004hbZk',leadObj.LastName);           
            objPageRef.getParameters().put('00N80000004hbZR',leadObj.Email);
            objPageRef.getParameters().put('00N80000004hbZG',leadObj.Company);
            objPageRef.getParameters().put('00N80000004hbZp',leadObj.Phone);
            objPageRef.getParameters().put('00N80000004hbYr',leadObj.Street);
            //objPageRef.getParameters().put('CF00NQ0000001Jjhb',UserInfo.getFirstName()+' '+Userinfo.getLastName());  // for Sandbox User only 
           // objPageRef.getParameters().put('CF00NQ0000001Jjhb_lkid',UserInfo.getUserId());     
            objPageRef.getParameters().put('CF00N80000005IIVk',UserInfo.getFirstName()+' '+Userinfo.getLastName());  
            objPageRef.getParameters().put('CF00N80000005IIVk_lkid',UserInfo.getUserId());                             
            objPageRef.getParameters().put('00N80000004hbYw',leadObj.Partner_Address2__c);
            objPageRef.getParameters().put('00N80000004hba4',leadObj.PostalCode);            
            objPageRef.getParameters().put('00N80000004hbZC',leadObj.State);
            objPageRef.getParameters().put('00N80000004hbZL',leadObj.Country);
            objPageRef.getParameters().put('00N80000004hbZB',leadObj.City);          
            objPageRef.getParameters().put('nooverride','1');
            objPageRef.getParameters().put('retURL',leadObj.Id); 
            objPageRef.setRedirect(true);
            return objPageRef;
        }
        else if(contactId !=null && contactId !='') {
        	PageReference objPageReff = new PageReference('/a0S/e');
            objPageReff.getParameters().put('contactId',contactObj.Id);
            objPageReff.getParameters().put('00N80000004hbZV',contactObj.FirstName);
            objPageReff.getParameters().put('00N80000004hbZk',contactObj.LastName);                      
            objPageReff.getParameters().put('00N80000004hbZR',contactObj.Email);
            objPageReff.getParameters().put('00N80000004hbZG',contactObj.Company__c);
            objPageReff.getParameters().put('00N80000004hbZp',contactObj.Phone);
            objPageReff.getParameters().put('00N80000004hbZB',contactObj.MailingCity);
            objPageReff.getParameters().put('00N80000004hbZL',contactObj.MailingCountry);           
            objPageReff.getParameters().put('00N80000004hbYr',contactObj.MailingStreet);
            //objPageReff.getParameters().put('CF00NQ0000001Jjhb',contactObj.Owner.Name); 
          //  objPageReff.getParameters().put('CF00NQ0000001Jjhb',UserInfo.getFirstName()+' '+Userinfo.getLastName());  // FOR SANDBOX  USER ONLY 
           // objPageReff.getParameters().put('CF00NQ0000001Jjhb_lkid',UserInfo.getUserId());   
            objPageReff.getParameters().put('CF00N80000005IIVk',UserInfo.getFirstName()+' '+Userinfo.getLastName());
            objPageReff.getParameters().put('CF00N80000005IIVk_lkid',UserInfo.getUserId());                    
            objPageReff.getParameters().put('00N80000004hbZC',contactObj.MailingState);
            objPageReff.getParameters().put('00N80000004hba4',contactObj.MailingPostalCode);
         	objPageReff.getParameters().put('retURL',contactObj.Id);        
            objPageReff.getParameters().put('nooverride','1');
            objPageReff.setRedirect(true);
            return objPageReff;
        }    	
        
        return null;
    }
}