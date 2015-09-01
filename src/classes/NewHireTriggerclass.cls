public class NewHireTriggerclass { 
    static User supportAgentUser = null;
    static { 
        supportAgentUser = [SELECT Id, Name FROM User WHERE Name = 'RC Support Agent' LIMIT 1];
    } 
    public static Case getAssignedChildCases(case objCaseChild, case objCaseTrigger, string strRecordType){
    	system.debug('objCaseTrigger'+objCaseTrigger);
        objCaseChild.ParentId = objCaseTrigger.id;
        objCaseChild.Origin = objCaseTrigger.Origin;
        objCaseChild.Hire_Name__c = objCaseTrigger.Hire_Name__c;
        objCaseChild.Hire_Type__c = objCaseTrigger.Hire_Type__c;
        objCaseChild.New_Hire_Title__c = objCaseTrigger.New_Hire_Title__c;
        objCaseChild.Employee_Department__c = objCaseTrigger.Employee_Department__c;
        objCaseChild.New_Hire_Start_Date__c = objCaseTrigger.New_Hire_Start_Date__c;
        objCaseChild.New_Hire_Manager_Name__c = objCaseTrigger.New_Hire_Manager_Name__c;
        if(supportAgentUser != null ) {
            objCaseChild.ownerId = supportAgentUser.Id;
        }
        objCaseChild.RecordTypeId =OpportunityHelper.getOppRecordTypeMap(strRecordType);
        objCaseChild.status = 'New';
        objCaseChild.Priority ='Medium';
        objCaseChild.contactId = objCaseTrigger.contactId;
        if(objCaseChild.contactId == null) {   
            try {
                getContact(objCaseChild, objCaseTrigger);
        
            } catch(exception e){}
        }
        objCaseChild.SuppliedEmail = objCaseTrigger.SuppliedEmail;
        objCaseChild.FormSubmitterEmail__c = objCaseTrigger.FormSubmitterEmail__c;
        objCaseChild.New_Hire_Location__c = objCaseTrigger.New_Hire_Location__c;
        objCaseChild.Location__c = objCaseTrigger.Location__c;
        objCaseChild.Job_title__c = objCaseTrigger.Job_title__c;
        return objCaseChild;            
    } 
    private static void getContact(Case objCaseChild, Case parentCase) {
        Account accObj = [SELECT id, (SELECT Id, Phone, Name, Email FROM Contacts
                                         WHERE Email =:parentCase.FormSubmitterEmail__c ORDER BY LastModifiedDate DESC LIMIT 1) FROM Account WHERE Name =:'RC Internal' LIMIT 1];
        if(accObj != null) {
            List<Contact> contactList = accObj.Contacts;
            if(contactList != null && contactList.size() != 0) {
                objCaseChild.ContactId = contactList.get(0).Id;
            } else {
                if(!String.isBlank(parentCase.FormSubmitterEmail__c)) {
                    Contact conObj = new Contact();
                    conObj.AccountId = accObj.Id;
                    conObj.LastName = parentCase.SuppliedName;
                    conObj.Email = parentCase.FormSubmitterEmail__c;
                    conObj.Phone = parentCase.SuppliedPhone;
                    if(!String.isBlank(conObj.LastName)&&conObj.LastName!=null){
                        insert conObj;
                        objCaseChild.ContactId = conObj.id;
                    }
                }
            }
        }           
    }        
    public static void createNewHireCases(Map<Id, Case> caseNewMap) {
        List<Case> caseList = caseNewMap.values();
        system.debug('@@@caseList@@@'+caseList);
        Schema.DescribeSObjectResult caseObjDetails = Case.SObjectType.getDescribe();
        Map<ID,Schema.RecordTypeInfo> rtMapByName = caseObjDetails.getRecordTypeInfosById(); 
        List<Case> lstCase = new List<Case>();
        List<string> stringList = new List<string>();
        for(Case cs : caseList) {
            // cs.addError('COMING HERE');
            if(rtMapByName.get(cs.RecordTypeId).getName()== 'IT New Hire Request') {
                Set<String> setString = new Set<String>(); 
                Set<string> setStrDP = new Set<String>();  
                try{                  
                    if(cs.New_Hire_Services_and_Applications__c != null) {
                        String [] arrayString = cs.New_Hire_Services_and_Applications__c.split(';');
                        setString.addAll(new List<String>(arrayString));
                        for(string result:arrayString ){
                            if(//result.indexOf('SalesForce') == -1 
                                //&& result.indexOf('inContact') == -1 
                                result.indexOf('Desk Required') == -1 
                                && result.indexOf('Keycard Required') == -1) {
                                 stringList.add(result);  
                            }              
                         }
                    }
                    System.debug('setString'+setString);
                    if(cs.New_Hire_Desk_Phone__c!=null) {
                         String [] arrayString =cs.New_Hire_Desk_Phone__c.split(';');
                         //List<String> lstStrDP = new List<String>(arrayString);
                         setStrDP.addAll(new List<String>(arrayString) );
                         System.debug('setStrDP'+setStrDP);
                    } 
                } catch(exception ex){ cs.addError(ex.getMessage());}                 
                if(cs.Computer_Type__c != null ){  //if computer type is selected
                    try{         
                        String strDiscription='Parent Case :'+ cs.casenumber+'\n Name:' +cs.Hire_Name__c +'\n Computer Type: '+cs.Computer_Type__c;   
                        String strSubject ='Computer Procurement for New Hire  '+cs.Hire_Name__c;
                        Case objCase = new Case(Request_Type__c ='Procurement', Computer_Type__c = cs.Computer_Type__c,Request_Subtype_1__c = 'Laptop/Desktop', Request_Subtype_2__c='New Purchase', Description=strDiscription, Subject = strSubject);                         
                        lstCase.add(getAssignedChildCases(objCase, cs, 'IT Helpdesk'));                                     
                        Case objCaseDep = new Case(Request_Type__c ='Helpdesk', Computer_Type__c = cs.Computer_Type__c, Request_Subtype_1__c ='Hardware');
                        objCaseDep.Subject ='Computer Deployment for New Hire '+cs.Hire_Name__c;
                        objCaseDep.Description ='Parent Case :'+cs.CaseNumber+'\n Name:'+ cs.Hire_Name__c +'\n Tech Note :\nThis request is for deployment of dedicated (non-temporary) computer for '+ cs.Hire_Name__c +'\nIt has the following dependency:\n 1)Computer and/or peripherals have to be ordered';
                        lstCase.add(getAssignedChildCases(objCaseDep, cs, 'IT Helpdesk'));                                                     
                    } catch(exception e){cs.addError(e.getMessage());}                        
                }
                /*****************************************************************
                *@Description :Creating new child case for Concur,Netsuite,Jobvite*
                *@Update Date :24/07/2014										 *
                *@case#       :02753886                 						 *
                *****************************************************************/
                 if(setString.contains('Netsuite')) {
                 // System.debug('setString Netsuite Required');
                   try{
                       Case objCase = new Case(Request_Type__c ='', Request_Subtype_1__c = '');
                       objCase.Subject ='Netsuite Access for New Hire '+cs.Hire_Name__c;
                       objCase.Description='Parent Case : '+cs.caseNumber+'\nName: '+cs.Hire_Name__c+'\nAdd User to Netsuite \nAccount Creation Request : '+'(Remote Access (VPN), RingCentral AI, Box, SalesForce, RC Training Site, WebEx Connect, Jira) ';
                       lstCase.add(getAssignedChildCases(objCase, cs,'IT Helpdesk'));
                   }catch(exception e){cs.addError(e.getMessage());}
               }
                if(setString.contains('Concur')) {
                  //System.debug('setString Concur Required');
                   try{
                       Case objCase = new Case(Request_Type__c ='', Request_Subtype_1__c = '');
                       objCase.Subject ='Concur Access for New Hire '+cs.Hire_Name__c;
                       objCase.Description='Parent Case : '+cs.caseNumber+'\nName: '+cs.Hire_Name__c+'\nAdd User to Concur  \nAccount Creation Request : '+'(Remote Access (VPN), RingCentral AI, Box, SalesForce, RC Training Site, WebEx Connect, Jira) ';
                       lstCase.add(getAssignedChildCases(objCase, cs,'IT Helpdesk'));
                   }catch(exception e){cs.addError(e.getMessage());}
               }
                if(setString.contains('Jobvite')) { 
                  //System.debug('setString Jobvite Required');
                   try{
                       Case objCase = new Case(Request_Type__c ='', Request_Subtype_1__c = '');
                       objCase.Subject ='Jobvite Access for New Hire '+cs.Hire_Name__c;
                       objCase.Description='Parent Case : '+cs.caseNumber+'\nName: '+cs.Hire_Name__c+'\nAdd User to Jobvite  \nAccount Creation Request : '+'(Remote Access (VPN), RingCentral AI, Box, SalesForce, RC Training Site, WebEx Connect, Jira) ';
                       lstCase.add(getAssignedChildCases(objCase, cs,'IT Helpdesk'));
                   }catch(exception e){cs.addError(e.getMessage());}
               } 
               /*********************************************************************************/      
                if(cs.Mobile_Phone_w_Justification__c!=null)  { //if mobile phone is selected
                    try{
                         Case objCase = new Case(Request_Type__c ='Procurement', Request_Subtype_1__c = 'Mobile Phone/Tablet', Request_Subtype_2__c='New Line');
                         objCase.Subject ='Mobile Phone Procurement for New Hire '+cs.Hire_Name__c;
                         objCase.Description='Parent Case :' +cs.CaseNumber+'\nName:'+cs.Hire_Name__c+'\nMobile Phone w/ Justification:'+ cs.Mobile_Phone_w_Justification__c;
                         lstCase.add(getAssignedChildCases(objCase, cs, 'IT Helpdesk'));
                    } catch(exception e){cs.addError(e.getMessage());}               
                } 
                
                if(setString.contains('SalesForce') || setString.contains('inContact') || cs.Requires_BizServ__c == true) {//if salesforce or incontains selected or both are selected
                       Case objCase =new Case();
                       objCase.inContact_Division__c = cs.inContact_Division__c;
                       objCase.inContact_Team_Name__c = cs.inContact_Team_Name__c;
                       objCase.SFDC_Division__c = cs.SFDC_Division__c;
                       objCase.SFDC_Team_Name__c = cs.SFDC_Team_Name__c;
                       objCase.New_Hire_Services_and_Applications__c = ''+stringList;
                       objCase.Subject ='Biz Serv Account Request for Business Services '+cs.Hire_Name__c;
                       objCase.Description='Parent Case :' +cs.CaseNumber+'\nName:'+cs.Hire_Name__c+'\n'+
                    					    'Add User to SFDC Call Center by default for Sales and Support Users.\n'+
										 	'Add User to DocuSign for Sales Users.\n'+
                      					   	'Account Creation Request:\n'+stringList ;
                       lstCase.add(getAssignedChildCases(objCase, cs, 'Internal Business Services'));
               }
               if(setString.contains('Desk Required')) {
                  System.debug('setStringDesktop Required');
                   try{
                       Case objCase =new Case(Request_Type__c ='Facility', Request_Subtype_1__c = 'Cubicle');
                       objCase.Subject ='Workstation/Cubicle with computer lock for New Hire '+cs.Hire_Name__c;
                       objCase.Description='Parent Case : '+cs.caseNumber+'\nName: '+cs.Hire_Name__c+'\nNew Hire Location:'+cs.New_Hire_Location__c;
                       lstCase.add(getAssignedChildCases(objCase, cs,'IT Helpdesk'));
                   }catch(exception e){cs.addError(e.getMessage());}
               }
               //if(setStrDP.contains('IP Phone and Extension')) {
                 if((cs.Hire_Type__c == 'Employee')|| setStrDP.contains('IP Phone and Extension')) {
                   try{
                       Case objCase =new Case(Request_Type__c ='Helpdesk',Request_Subtype_1__c = 'IP Phone', Request_Subtype_2__c='Installation');
                       //objCase.Description='Parent Case : '+cs.casenumber+'\nName: '+cs.Hire_Name__c+'\nPlease create a RingCentral Account and Extension for '+ cs.Hire_Name__c+' under the official corporate account.\n Please update Telephone entry in Active Directory.';
                       objCase.Subject ='IP Phone and Extension Deployment for New Hire '+cs.Hire_Name__c;
                       objCase.Subject ='IP Phone and Extension Deployment for New Hire '+cs.Hire_Name__c;
                       lstCase.add(getAssignedChildCases(objCase, cs, 'IT Helpdesk'));
                       objCase.Description='Parent Case : '+cs.casenumber+'\nName: '+cs.Hire_Name__c+'\nPlease create a RingCentral Account and Extension for '+ cs.Hire_Name__c+' under the official corporate account.\n Please update Telephone entry in Active Directory.'+'\nPlease update Telephone entry in Exchange/Rackspace.';
                       /********* update on 24/07/2014 for case#02735252 ***********/
                       if(setStrDP.contains('IP Phone and Extension')){ 
                       	 objCase.Description =  objCase.Description+'\nPlease verify if InContact Pseudo Number is needed';
                       }
                       /************************************************************/
                   }catch(exception e){cs.addError(e.getMessage());}
               }
               
               /*if(setStrDP.contains('Analog Line and Phone')) { 
                   try{
                       Case objCase =new Case(Request_Type__c ='Procurement', Request_Subtype_1__c = 'Other', Request_Subtype_2__c='Installation');
                       objCase.Subject ='Land line Phone Procurement for New Hire  '+cs.Hire_Name__c;
                       objCase.Description='Parent Case :'+ cs.casenumber +'\nName:'+cs.Hire_Name__c+'\nPlease procure a hardline phone for '+cs.Hire_Name__c+ 'under the official corporate account.'; 
                       lstCase.add(getAssignedChildCases(objCase, cs, 'IT Helpdesk'));
                   }catch(exception e){}
               }*/
               if(cs.ParentId == null) {
                   try{
                       Case objCase1 =new Case(Request_Type__c ='Helpdesk', Request_Subtype_1__c = 'Application', Request_Subtype_2__c='Account Creation');
                       objCase1.Subject ='IT Account Request for New Hire '+cs.Hire_Name__c;
                       objCase1.New_Hire_Services_and_Applications__c = ''+stringList;
                       //objCase1.Description='Parent Case :' +cs.casenumber+ '\nName:'+cs.Hire_Name__c+'\nAccount Creation Request w/ Justification:\n'+stringList ;
                       objCase1.Description='Parent Case :' +cs.casenumber+ '\nName:'+cs.Hire_Name__c+'\nAccount Creation Request w/ Justification:\n'+stringList+' \nCreate Exchange/Rackspace email account'+'\nCreate Active Directory account'+'\nAdd Email to the correct Office Email Distribution List: '+cs.Location__c+'.' ;
                       system.debug('---------->'+stringList );
                       lstCase.add(getAssignedChildCases(objCase1, cs,'IT Helpdesk'));
                       Case objCase2 =new Case(Request_Type__c ='Facility', Request_Subtype_1__c = 'Office Access');
                       objCase2.Description='Parent Case :'+cs.casenumber+'\nName: '+cs.Hire_Name__c+'\nNew Hire Location:'+cs.New_Hire_Location__c;
                       objCase2.Subject ='Office Access Card for New Hire '+cs.Hire_Name__c;
                       lstCase.add(getAssignedChildCases(objCase2, cs, 'IT Helpdesk'));
                       Case objCase3 =new Case();                                                   
                       objCase3.Subject ='Employee and Contact Creation in SFDC for New Hire '+cs.Hire_Name__c;
                       objCase3.Description='Parent Case :' +cs.casenumber+'\nName:' +cs.Hire_Name__c+'\nAdd this employee as a Contact on RC Internal, and to the Employee object in SFDC.';
                       lstCase.add(getAssignedChildCases(objCase3, cs, 'IT Helpdesk'));
                   }catch(exception e){cs.addError(e.getMessage());}
               }
            }                
        }
        if(lstCase.size()>0){
            try{
                insert lstCase;
            }catch(Exception ex){
                caseList[0].addError('Problem in creating child Case.'+ex.getMessage());    
            }
        }                           
    } 
    private static String excludeValues(Case caseObj) {
        String str = null;
        String apps = caseObj.New_Hire_Services_and_Applications__c;
        if(apps != null) {
            String[] values = apps.split(';');
            for(String result : values) {
                if(result.indexOf('SalesForce') != -1 || result.indexOf('inContact') != -1 || result.indexOf('Desk Required') != -1 && result.indexOf('Keycard Required') != -1) {
                    if(str == null )
                        str = '';
                    str += result +';';
                } 
            }
        }
        return str;
    }
    public static void newHireupdate(Map<Id, Case> caseNewMap,Map<id,Case> caseOldMap ) {
        List<Case> caseList = caseNewMap.values();
        Schema.DescribeSObjectResult result = Case.SObjectType.getDescribe();
        Map<ID,Schema.RecordTypeInfo> rtMapByName = result.getRecordTypeInfosById(); 
        Map<Id,Case> caseMap = new Map<Id,Case>([Select Id, (Select Id, Status From Cases where status = 'New' limit 1) From 
                                                    Case where Id IN :caseNewMap.keySet()]);
        for(Case caseobj:caseList) {
            if(rtMapByName.get(caseObj.RecordTypeId).getName()== 'IT New Hire Request') {
                Case caseoldObj = caseOldMap.get(caseobj.id); 
                if(caseoldObj.Status != 'Closed' && caseobj.Status == 'Closed') {
                    if(caseMap != null && caseMap.get(caseobj.id).Cases != null && caseMap.get(caseobj.id).Cases.size()>0) {
                        caseobj.addError('Please close all the child cases before closing the parent.');
                    }
                }  
            }
        }
    }
   /* @isTest
    public static void NewHireTriggerclasstest() {
      try{
        RecordType rt=[SELECT Name, NamespacePrefix, Id, DeveloperName, SobjectType  FROM RecordType where SobjectType='case'  AND Name=:'IT New Hire Request'];   
        case cs = new case();
        cs.RecordTypeId=rt.ID;
        cs.Computer_Type__c ='Mac Power User';
        cs.FormSubmitterEmail__c ='test@test.com';
        cs.New_Hire_Services_and_Applications__c ='salesforce;inContact;Desktop required';
        cs.Mobile_Phone_w_Justification__c = 'Andiord';
        cs.Requires_BizServ__c=true;
        cs.Status='New';
        cs.New_Hire_Desk_Phone__c ='IP Phone and Extension;Analog Line and Phone';
        case objCaseDep = new case(Request_Type__c ='Helpdesk', Request_Subtype_1__c ='Hardware');
       
        List<case> cas = new List<case>();
        cas.add(cs);
        insert cas;
        
        Map<id,case> mapTestCaseNew=new Map<id,case>();
        Map<id,case> mapTestCaseOld=new Map<id,case>();
        mapTestCaseNew.put(cs.id,cs);
        mapTestCaseOld.put(cs.id,cs);
        
        NewHireTriggerclass cls = new NewHireTriggerclass();
        NewHireTriggerClass.createNewHireCases(mapTestCaseNew);
        NewHireTriggerClass.newHireupdate(mapTestCaseNew,mapTestCaseOld);
        NewHireTriggerClass.excludeValues(cs);
        system.assertNotEquals(NewHireTriggerclass.getAssignedChildCases(objCaseDep, cs, 'IT Helpdesk'), null);
      }catch(exception ex){} 
    }*/
    
}