/**************************************************************************************************
* Project Name..........: Implementation Scheduler.                                               *
* File..................: SchedulerAdminConfiguration.cls                                         *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 20-05-2013                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 26-05-2013                                                              *
* Description...........: This class for SchedulerAdminConfiguration.class                        *
**************************************************************************************************/

public class schedulerAdminConfiguration {
    
    // Declaring Variables
    public List<Folder> lstFolder {get;set;}    
    public List<schedulerConfiguration__c> lstschedulerConfiguration{get;set;}
    public List<EmailTemplate> lstEmailTemplate{get;set;}
    public List<Resource_Pool__c> lstResourcePool{get;set;}
    public List<Advisor__c> listAdvisor{get;set;}
    public List<Time__c> listTimeSlots{get;set;}
    public List<schedulerConfigWrapper> newlistBrand {get; set;}
    
    public Boolean isadvisordata{get;set;}
    public Boolean isconfiguredata{get;set;}
    public Boolean isAddAdvisor {get; set;}
    public Boolean isResourceData {get; set;}
    public Boolean isAdvisorData1 {get; set;}
    public Boolean isTimeSlot {get; set;}
    public Boolean display {get;set;}
    public Boolean displayPopup {get; set;} 
    
    public String selectedFolder{get;set;}
    public String selectedTemplate{get;set;}
    public String resourcePoolName {get; set;}
    public String advisorName {get; set;}
    
    public Integer emailTemplate {get; set;}
     
    public Resource_Pool__c objResourcePool {get;set;}
    public schedulerConfiguration__c objschedulerConfiguration {get;set;} 
    public Advisor__c objadvisor {get;set;}
    public Time__c objTimeSlot {get; set;}
    
    /******************************************************************************
    * @Description : Contructor.                                                  *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public schedulerAdminConfiguration(){
        isconfiguredata= false;
        isResourceData = false; 
        isAdvisorData1 = false; 
        isTimeSlot = false;      
        display = true;
        objadvisor = new advisor__c();
        objResourcePool = new Resource_Pool__c();
        objTimeSlot = new  Time__c();
        
        // Fetching list of all available brands
        objschedulerConfiguration= new schedulerConfiguration__c();   
        lstschedulerConfiguration= new list<schedulerConfiguration__c>([SELECT Id,Name,Brand_Id__c, Preferred_Language__c,Parent_Brand_Id__c,Buffer_Days__c,Cancellation_Email_Template_Customer__c,
                                                                               Cancellation_Email_Template_Internal__c,Confirmation_Email_Template_Name__c,
                                                                               Reminder_E_mail_Template_Name__c,Rescheduling_Email_Template_Customer__c,
                                                                               Rescheduling_Email_Template_Internal__c FROM schedulerConfiguration__c]);
                                                                               
           
           newlistBrand =  new List<schedulerConfigWrapper>();
           newlistBrand.clear();
           for(schedulerConfiguration__c sConfig : lstschedulerConfiguration){
                schedulerConfigWrapper templistBrand =  new schedulerConfigWrapper();
                EmailTemplate Template;
                templistBrand.id = sConfig.id;
                templistBrand.brandName = sConfig.Name;
                templistBrand.brandId = sConfig.Brand_Id__c;
                templistBrand.ParentbrandId= sConfig.Parent_Brand_Id__c;
                templistBrand.preferredLanguage =sConfig.Preferred_Language__c;
                templistBrand.bufferDays = Integer.valueOf(sConfig.Buffer_Days__c);
                templistBrand.cancellationEmailTemplateCustomer = [SELECT Id, Name FROM EmailTemplate WHERE Id =: sConfig.Cancellation_Email_Template_Customer__c];
                templistBrand.cancellationEmailTemplateInternal = [SELECT Id, Name FROM EmailTemplate WHERE Id =: sConfig.Cancellation_Email_Template_Internal__c];
                templistBrand.confirmationEmailTemplateName = [SELECT Id, Name FROM EmailTemplate WHERE Id =: sConfig.Confirmation_Email_Template_Name__c];
                templistBrand.reminderEmailTemplateName = [SELECT Id, Name FROM EmailTemplate WHERE Id =: sConfig.Reminder_E_mail_Template_Name__c];
                templistBrand.reschedulingEmailTemplateCustomer = [SELECT Id, Name FROM EmailTemplate WHERE Id =: sConfig.Rescheduling_Email_Template_Customer__c];
                templistBrand.reschedulingEmailTemplateInternal = [SELECT Id, Name FROM EmailTemplate WHERE Id =: sConfig.Rescheduling_Email_Template_Internal__c];                
                newlistBrand.add(templistBrand);                
           }                                                             
                                                                               
        // If records fetched,then make the brands list visible                                                               
        if(lstschedulerConfiguration.size()>0){
            isconfiguredata =true;
        }       
        
        // Fetching list of all Folders
        lstFolder = new List<Folder>([SELECT Type, Name, Id, DeveloperName FROM Folder WHERE Type = 'Email']);
        Id brandId = ApexPages.currentPage().getParameters().get('id');      
        if(brandId != null){
            // Fetching list of all Resource Pool
            lstResourcePool = new  List<Resource_Pool__c>(getResourcePool(brandId));            
            objResourcePool.Brand_Name__c = brandId;  
            
            // If records fetched, make resource list visible                                              
            if(lstResourcePool.size() > 0){
                isResourceData = true;
            }    
            
        }
        
        Id resourcePoolId = ApexPages.currentPage().getParameters().get('rpid');
        if(resourcePoolId != null){
            //Fetching list of all advisors
            listAdvisor = new List<Advisor__c> ([SELECT Id, Name, Advisor_Name__c,Advisor_Name__r.Name, Advisor_Name__r.Email,Resource_Pool__r.Name,Preferred_Language__c 
                                                FROM Advisor__c WHERE Resource_Pool__c =: resourcePoolId ORDER BY Createddate Asc]);
                                                
            objadvisor.Resource_Pool__c =resourcePoolId;
            
            // If records fetched, make advisor list visible
            if(listAdvisor.size()>0){
                isAdvisorData1 = true;
            }                                     
        }
        
        Id editBrandid = ApexPages.currentPage().getParameters().get('editBrandid');
        if(editBrandid != null){
            schedulerConfiguration__c listBrand = [SELECT Id,Name,Brand_Id__c,Preferred_Language__c,Parent_Brand_Id__c,Buffer_Days__c,Cancellation_Email_Template_Customer__c,
                                                   Cancellation_Email_Template_Internal__c,Confirmation_Email_Template_Name__c,
                                                   Reminder_E_mail_Template_Name__c,Rescheduling_Email_Template_Customer__c,
                                                   Rescheduling_Email_Template_Internal__c 
                                                   FROM schedulerConfiguration__c
                                                   WHERE Id =: editBrandid];
                                                                               
            // Auto populating brand fields for editing                                                                   
            if(listBrand != null){
                objschedulerConfiguration = setSchedulerConfig(objschedulerConfiguration, listBrand);                
            }                                     
        }
        
        Id editResourceid = ApexPages.currentPage().getParameters().get('editRPid');
        if(editResourceid != null){
            Resource_Pool__c listResource = [SELECT Id,Name,Active__c,Brand_Name__c,Criteria__c,Dispatch_Admin__c,
                                                    No_of_User_DLs__c,Resource_Pool_Email__c,Preferred_Language__c,Premium_Support__c,
                                                    Time_zone__c,Brand_Name__r.Name,Dispatch_Admin__r.Name
                                             FROM Resource_Pool__c WHERE Id =: editResourceid];
                                             
            // Auto populating resource fields for editing                                 
            if(listResource !=null){
                objResourcePool = setResourcePool(objResourcePool, listResource);
            }                                     
        }
        
        //Id advisorId = 'a2XQ0000000TSvL';
        Id advisorId = ApexPages.currentPage().getParameters().get('advisorId');
        system.debug('#### advisor Id -'+advisorId);
        if(advisorId != null){
            listTimeSlots = new List<Time__c>();
            listTimeSlots = [SELECT Start_Time__c,End_Time__c,Time_Zone__c,Day__c,Advisor_Name__c,Advisor_Name__r.Name,availableFor__c 
                             FROM Time__c WHERE Advisor_Name__c =: advisorId ];
            
            advisorName = [SELECT Name FROM Advisor__c WHERE Id =: advisorId LIMIT 1].Name;
            objTimeSlot.Advisor_Name__c = advisorId;                         
            system.debug('#### listTimeSlots -'+listTimeSlots );
            if(listTimeSlots.size()>0){
                isTimeSlot = true;
            }
        }
        
        Id toEditTS = ApexPages.currentPage().getParameters().get('toEditTS');
        system.debug('#### toEditTS -'+toEditTS);
        if(toEditTS!=null){
            Time__c timeRecord = [SELECT Start_Time__c,End_Time__c,Time_Zone__c,Day__c,Advisor_Name__c,Advisor_Name__r.Name,availableFor__c 
                                  FROM Time__c WHERE Id =: toEditTS];
            if(timeRecord!=null){
                objTimeSlot.Day__c = timeRecord.Day__c;
                objTimeSlot.Start_Time__c = timeRecord.Start_Time__c;
                objTimeSlot.Time_Zone__c =timeRecord.Time_Zone__c;
                objTimeSlot.End_Time__c = timeRecord.End_Time__c;
                objTimeSlot.availableFor__c = timeRecord.availableFor__c;
                objTimeSlot.Id = toEditTS;
            }
        }
        
    }
    
    /******************************************************************************
    * @Description : Setter for resource pool.                                    *
    * @Params      : Resource_Pool__c, Resource_Pool__c                           *
    * @Return      : Resource_Pool__c                                             * 
    ******************************************************************************/
    public Resource_Pool__c setResourcePool(Resource_Pool__c objResourcePool, Resource_Pool__c listResource) {
        objResourcePool.Id = listResource.Id;
        objResourcePool.Brand_Name__c = listResource.Brand_Name__c;
        objResourcePool.Dispatch_Admin__c = listResource.Dispatch_Admin__c;
        objResourcePool.Resource_Pool_Email__c = listResource.Resource_Pool_Email__c;
        objResourcePool.Preferred_Language__c = listResource.Preferred_Language__c;
        objResourcePool.Criteria__c = listResource.Criteria__c;
        objResourcePool.No_of_User_DLs__c = listResource.No_of_User_DLs__c;
        objResourcePool.Active__c = listResource.Active__c;
        objResourcePool.Premium_Support__c = listResource.Premium_Support__c;
        objResourcePool.Time_zone__c = listResource.Time_zone__c;
        return objResourcePool;
    }
    
    /******************************************************************************
    * @Description : Setter for scheduler configuration.                          *
    * @Params      : schedulerConfiguration__c, schedulerConfiguration__c         *
    * @Return      : schedulerConfiguration__c                                    * 
    ******************************************************************************/
    public schedulerConfiguration__c setSchedulerConfig(schedulerConfiguration__c objschedulerConfiguration, schedulerConfiguration__c listBrand) {
        objschedulerConfiguration.Id = listBrand.Id;
        objschedulerConfiguration.Name = listBrand.Name;
        objschedulerConfiguration.Brand_Id__c = listBrand.Brand_Id__c ;
        objschedulerConfiguration.Parent_Brand_Id__c = listBrand.Parent_Brand_Id__c;
        objschedulerConfiguration.Preferred_Language__c =listBrand.Preferred_Language__c;
        objschedulerConfiguration.Buffer_Days__c = listBrand.Buffer_Days__c;
        objschedulerConfiguration.Cancellation_Email_Template_Customer__c = listBrand.Cancellation_Email_Template_Customer__c;
        objschedulerConfiguration.Cancellation_Email_Template_Internal__c = listBrand.Cancellation_Email_Template_Internal__c; 
        objschedulerConfiguration.Confirmation_Email_Template_Name__c = listBrand.Confirmation_Email_Template_Name__c;
        objschedulerConfiguration.Reminder_E_mail_Template_Name__c = listBrand.Reminder_E_mail_Template_Name__c;
        objschedulerConfiguration.Rescheduling_Email_Template_Customer__c = listBrand.Rescheduling_Email_Template_Customer__c; 
        objschedulerConfiguration.Rescheduling_Email_Template_Internal__c = listBrand.Rescheduling_Email_Template_Internal__c;
        return objschedulerConfiguration;
    }
    
    /******************************************************************************
    * @Description : Setting flag to close popup.                                 *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/  
     public void closePopup() {        
        displayPopup = false;    
     }
     
    /******************************************************************************
    * @Description : Setting flag to show popup.                                  *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/ 
     public void showPopup() {
       displayPopup = true; 
     }
     
    /******************************************************************************
    * @Description : Populating select list data.                                 *
    * @Params      : void                                                         *
    * @Return      : List<SelectOption>                                           * 
    ******************************************************************************/
    public List<SelectOption> getFolderName() {
         List<SelectOption> folderName = new List<SelectOption>();
         folderName.add(new selectOption('','--NONE--'));
         
         for(Folder objF : lstFolder){
            folderName.add(new selectOption(objF.Id, objF.Name));
         }
        return folderName; 
    }
    
    /******************************************************************************
    * @Description : Fetching Templates.                                          *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public void fetchEmailTemplate(){         
        lstEmailTemplate = new List<EmailTemplate>([SELECT TimesUsed, TemplateType, TemplateStyle, Subject, OwnerId, NamespacePrefix, 
                                                            Name, Markup, LastUsedDate, LastModifiedDate, LastModifiedById, IsActive, Id, 
                                                            HtmlValue, FolderId, Encoding, DeveloperName, Description, BrandTemplateId, Body  
                                                    FROM EmailTemplate]);
    }
    
    /******************************************************************************
    * @Description : Populating select list for templates.                        *
    * @Params      : void                                                         *
    * @Return      : List<SelectOption>                                           * 
    ******************************************************************************/
     public List<SelectOption> getTemplateList() {
             List<SelectOption> templateList = null;           
             templateList = new List<SelectOption>();
             lstEmailTemplate = new List<EmailTemplate>([SELECT Name, Id, FolderId FROM EmailTemplate WHERE FolderId =: selectedFolder]);
             for(EmailTemplate objET: lstEmailTemplate){            
                templateList.add(new selectOption(objET.Id,objET.Name));
             }
     return templateList;
     }   
    
    /******************************************************************************
    * @Description : Save new Brand.                                              *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public pagereference saveBrand(){       
        
        Map<id,String> mapBrand = new Map<id,String>();
        for(schedulerConfiguration__c listBrand : [SELECT Id,Parent_Brand_Id__c, Brand_Id__c FROM schedulerConfiguration__c]){
                mapBrand.put(listBrand.Id,listBrand.Brand_Id__c);   
        }
        
        if(objschedulerConfiguration.Name == null){
            objschedulerConfiguration.Name.addError('Brand Name Required');
            return null;
        }   
        if(objschedulerConfiguration.Brand_Id__c == null){
            objschedulerConfiguration.Brand_Id__c.addError('Brand Id Required');
            return null;
        }
        if(objschedulerConfiguration.Preferred_Language__c == null){
            objschedulerConfiguration.Preferred_Language__c.addError('Preferred Language Required');
            return null;
        }
        
        if(objschedulerConfiguration.Buffer_Days__c == null){
            objschedulerConfiguration.Buffer_Days__c.addError('Buffer Days Required');  
            return null;
        }       
        if(objschedulerConfiguration.Cancellation_Email_Template_Customer__c == null){
            objschedulerConfiguration.Cancellation_Email_Template_Customer__c.addError('Template Required');
            return null;
        }
        if(objschedulerConfiguration.Cancellation_Email_Template_Internal__c == null){
            objschedulerConfiguration.Cancellation_Email_Template_Internal__c.addError('Template Required');
            return null;
        }
        if(objschedulerConfiguration.Confirmation_Email_Template_Name__c == null){    
            objschedulerConfiguration.Confirmation_Email_Template_Name__c.addError('Template Required');
            return null;
        }
        if(objschedulerConfiguration.Reminder_E_mail_Template_Name__c == null){
            objschedulerConfiguration.Reminder_E_mail_Template_Name__c.addError('Template Required');
            return null;
        }
        if(objschedulerConfiguration.Rescheduling_Email_Template_Customer__c == null){    
            objschedulerConfiguration.Rescheduling_Email_Template_Customer__c.addError('Template Required');
            return null;
        }
        if(objschedulerConfiguration.Rescheduling_Email_Template_Internal__c == null){    
            objschedulerConfiguration.Rescheduling_Email_Template_Internal__c.addError('Template Required');
            return null;
        }       
        
       PageReference page = new PageReference('/apex/BrandManagment');
       page.setRedirect(true);
       
       if(objschedulerConfiguration.Id!=null && objschedulerConfiguration.Brand_Id__c == mapBrand.get(objschedulerConfiguration.Id) ){
            update objschedulerConfiguration;
            return page;
       }                       
              
        if(objschedulerConfiguration.Brand_Id__c!=null){
                List<schedulerConfiguration__c> brand = new List<schedulerConfiguration__c>([SELECT Brand_Id__c,Parent_Brand_Id__c FROM schedulerConfiguration__c 
                                                                                             WHERE Brand_Id__c =: objschedulerConfiguration.Brand_Id__c]);
                if(brand.size()>0){
                    objschedulerConfiguration.Brand_Id__c.addError('Brand Id already exists!');
                    return null;
                }                                   
        }       
                                                           
      upsert objschedulerConfiguration;
      return page;
    }
    
    /******************************************************************************
    * @Description : Class to query resource pool object and fetch the            *
    *                resource pool details, for the input brand.                  *
    * @Params      : String                                                       *
    * @Return      : List<Resource_Pool__c>                                       * 
    ******************************************************************************/
    public List<Resource_Pool__c> getResourcePool(String brandName) {
        return  [SELECT Id,Name,Brand_Name__c,No_of_User_DLs__c,Criteria__c,Active__c,Dispatch_Admin__c,
                        Brand_Name__r.Name,Time_zone__c,Resource_Pool_Email__c,Preferred_Language__c,Premium_Support__c,Dispatch_Admin__r.Name 
                 FROM Resource_Pool__c 
                 WHERE Brand_Name__c =: brandName]; 
    }
    
    /******************************************************************************
    * @Description : Remove Brand Configuration list from database.               *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public pagereference removeRecord(){        
        // Fetching brand id from page param    
        schedulerConfiguration__c toDelSC = new schedulerConfiguration__c(Id = ApexPages.CurrentPage().getParameters().get('Name'));
        List<Resource_Pool__c> listResBrand = getResourcePool(toDelSC.Id);//[SELECT id FROM Resource_Pool__c WHERE Brand_Name__c = :toDelSC.id];
        List<Advisor__c> listResAdv = [SELECT Id FROM Advisor__c WHERE Resource_Pool__c IN :listResBrand];
        List<Time__c> listTimeSlots = [SELECT Id FROM Time__c WHERE Advisor_Name__c IN :listResAdv];
         
        if(listTimeSlots.size()!=0){
            delete listTimeSlots;
        }
        if(listResAdv.size()!=0){
            delete listResAdv;          
        }
        if(listResBrand.size()!=0){
            delete listResBrand;    
        }             
        if(toDelSC != null){
             delete toDelSC ;
        }
        PageReference page = new PageReference('/apex/BrandManagment');
        page.setRedirect(true);
        return page;
    }
     
    /******************************************************************************
    * @Description : Edit Brand Records.                                          *
    * @Params      : void                                                         *
    * @Return      : PageReference                                                * 
    ******************************************************************************/
    public PageReference editBrandRecords(){     
        schedulerConfiguration__c toEditSC = new schedulerConfiguration__c(Id = ApexPages.CurrentPage().getParameters().get('NameBrand'));          
        if(toEditSC != null){
            PageReference page = new PageReference('/apex/BrandManagment?editBrandid='+toEditSC.Id);
            page.setRedirect(true);
            return page;
        }else{
            PageReference page = new PageReference('/apex/BrandManagment');
            page.setRedirect(true);
            return page;
        }
    }
     
    /******************************************************************************
    * @Description : Save new Resource Pool.                                      *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
     public pagereference saveResourcePool(){       
        
          if(objResourcePool.Brand_Name__c == null){
                objResourcePool.Brand_Name__c.addError('Brand Name Required');
                return null;
          }
          if(objResourcePool.Dispatch_Admin__c == null){
                objResourcePool.Dispatch_Admin__c.addError('Dispatch Admin Required');
                return null;
          }
          if(objResourcePool.Resource_Pool_Email__c == null){
                objResourcePool.Resource_Pool_Email__c.addError('Resource Pool Email Required');
                return null;
          }
           if(objResourcePool.Preferred_Language__c == null){
                objResourcePool.Preferred_Language__c.addError('Preferred Langauge Required');
                return null;
          }
          
          if(objResourcePool.No_of_User_DLs__c == null){
                objResourcePool.No_of_User_DLs__c.addError('No of User/DL\'s Required');
                return null;
          }  
        
          PageReference page = new PageReference('/apex/ResourcePoolManagement?id='+objResourcePool.Brand_Name__c);
          page.setRedirect(true);
          
          Map<Id,String> idAdmin = new Map<Id,String>(); 
          
          if(objResourcePool.Brand_Name__c!=null){
          List<Resource_Pool__c> listResPool = getResourcePool(objResourcePool.Brand_Name__c);//[SELECT id,Brand_Name__c,No_of_User_DLs__c,Criteria__c,Active__c,Dispatch_Admin__c FROM Resource_Pool__c WHERE Brand_Name__c = :objResourcePool.Brand_Name__c];                                                
              
                  if(listResPool.size()>0){                                 
                          Integer count = 0;
                          Integer position = 0;                                  
                          for(Resource_Pool__c resource : listResPool){                          
                                idAdmin.put(resource.Id,resource.Dispatch_Admin__c); 
                                if(resource.Id == objResourcePool.Id){
                                    position = count;
                                }   
                                count++;            
                          }
                          
                          if(objResourcePool.Id!=null){
                                listResPool.remove(position);
                          }
                                                              
                          for(Resource_Pool__c resource : listResPool){
                                if((resource.Brand_Name__c==objResourcePool.Brand_Name__c) && 
                                    (resource.No_of_User_DLs__c==objResourcePool.No_of_User_DLs__c) &&
                                        (resource.Criteria__c==objResourcePool.Criteria__c) &&
                                            (resource.Active__c==objResourcePool.Active__c) &&
                                             (resource.Preferred_Language__c == objResourcePool.Preferred_Language__c)){
                                                
                                                                    
                                            objResourcePool.Brand_Name__c.addError('Brand Name should be unique');
                                            objResourcePool.Preferred_Language__c.addError('Preferred Language should be unique');
                                            objResourcePool.No_of_User_DLs__c.addError('No of User/DL\'s should be unique');
                                            
                                            objResourcePool.Active__c.addError('No of User/DL\'s should be unique');                                        
                                            return null;
                                                    
                                } 
                                
                                if(resource.Dispatch_Admin__c == objResourcePool.Dispatch_Admin__c){
                                            objResourcePool.Dispatch_Admin__c.addError('Dispatch Admin should be unique'); 
                                            return null;                                
                                }
                          }
                                
                                if(objResourcePool.Id != null && objResourcePool.Dispatch_Admin__c == idAdmin.get(objResourcePool.Id)){
                                    update objResourcePool;
                                    return page;
                                }
                  }
          }                                     
          upsert objResourcePool;         
          return page;
     }              
     
    /******************************************************************************
    * @Description : Remove resource pool records from database.                  *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public pagereference removeRpRecord(){
        Resource_Pool__c toDelResPool = new Resource_Pool__c(Id = ApexPages.CurrentPage().getParameters().get('Name'));
        List<Advisor__c> listResAss = [SELECT Id FROM Advisor__c WHERE Resource_Pool__c = :toDelResPool.Id]; 
        List<Time__c> listTimeSlots = [SELECT Id FROM time__c WHERE Advisor_Name__c IN :listResAss];
         
        if(listTimeSlots.size() != 0){
            delete listTimeSlots;
        }
        if(listResAss.size() != 0){
            delete listResAss;              
        } 
        Resource_Pool__c brandId = [SELECT Id, Brand_Name__c FROM Resource_Pool__c WHERE Id =: toDelResPool.Id];
         
        if(toDelResPool != null){
            delete toDelResPool;
        }                    
                  
        PageReference page = new PageReference('/apex/ResourcePoolManagement?id='+brandId.Brand_Name__c);
        page.setRedirect(true);
        return page;
    }
     
    /******************************************************************************
    * @Description : Edit resource pool.                                          *
    * @Params      : void                                                         *
    * @Return      : PageReference                                                * 
    ******************************************************************************/
    public PageReference editResourcePoolRecords(){     
        Resource_Pool__c toEditRP = new Resource_Pool__c(Id = ApexPages.CurrentPage().getParameters().get('ResourcePoolName'));
        schedulerConfiguration__c EditRPbId = new schedulerConfiguration__c(Id = ApexPages.CurrentPage().getParameters().get('Id'));
        if(toEditRP!=null && EditRPbId !=null){
            PageReference page = new PageReference('/apex/ResourcePoolManagement?editRPid='+toEditRP.Id+'&id='+EditRPbId.Id);
            page.setRedirect(true);
            return page;
        }else{
            PageReference page = new PageReference('/apex/ResourcePoolManagement');
            page.setRedirect(true);
            return page;
        }    
    }
    
    /******************************************************************************
    * @Description : Navigate to Reource Pool page for respective brand.          *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
     public pagereference toBrandScreen(){
        schedulerConfiguration__c toScreenId = new schedulerConfiguration__c(Id = ApexPages.CurrentPage().getParameters().get('Brandid'));
        if(toScreenId != null){
            PageReference page = new PageReference('/apex/ResourcePoolManagement?id='+toScreenId.Id);
            page.setRedirect(true);
            return page;
        }else{
            PageReference page = new PageReference('/apex/BrandManagment');
            page.setRedirect(true);
            return page;
        }                
     }
     
    /******************************************************************************
    * @Description : Add the advisor to Database.                                 *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public pagereference addAdvisor(){
        
        if(objadvisor.Resource_Pool__c == null){
            objadvisor.Resource_Pool__c.addError('Resource Pool Required');
            return null;
        }
        if(objadvisor.Advisor_Name__c == null){
            objadvisor.Advisor_Name__c.addError('Advisor Name Required');
            return null;
        }
        if(objadvisor.Preferred_Language__c == null){
            objadvisor.Advisor_Name__c.addError('Preferred Language Required');
            return null;
        }
        
        PageReference page = new PageReference('/apex/AdvisorManagment?rpid='+objadvisor.Resource_Pool__c);
        page.setRedirect(true);
        
        if(objadvisor.Resource_Pool__c != null){
            List<Advisor__c> listAdvisor = [SELECT Resource_Pool__c,Advisor_Name__c,Preferred_Language__c FROM Advisor__c 
                                            WHERE Resource_Pool__c = :objadvisor.Resource_Pool__c];
            for(Advisor__c advisor : listAdvisor){
                if((advisor.Advisor_Name__c == objadvisor.Advisor_Name__c) && (advisor.Resource_Pool__c == objadvisor.Resource_Pool__c )&&(advisor.Preferred_Language__c == objadvisor.Preferred_Language__c)){
                    objadvisor.Resource_Pool__c.addError('Resource Pool should be unique');  
                    objadvisor.Advisor_Name__c.addError('Advisor Name should be unique'); 
                    objadvisor.Preferred_Language__c.addError('Preffered Language should be unique');                               
                    return null;
                }
            }
        }
        insert objadvisor;        
        return page;
    }
    
    /******************************************************************************
    * @Description : Remove the advisor from the database.                        *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public pagereference removeAdvisor(){        
        Advisor__c toDelSC = new Advisor__c(Id = ApexPages.CurrentPage().getParameters().get('Name'));
        List<Time__c> listTimeSlots = [SELECT Id FROM Time__c WHERE Advisor_Name__c =: toDelSC.Id ];
 
        if(listTimeSlots.size() != 0){
            delete listTimeSlots;
        }
        List<Advisor__c> advisorToDelete;                  
        if(toDelSC != null){
            advisorToDelete = [SELECT Id, Resource_Pool__c FROM Advisor__c WHERE Id =: toDelSC.Id ]; 
            delete toDelSC ;
        }
        PageReference page = new PageReference('/apex/AdvisorManagment?rpid='+advisorToDelete[0].Resource_Pool__c);
        page.setRedirect(true);
        return page;      
    }
     
    /******************************************************************************
    * @Description : Navigate to Advisor screen for respective resource pool.     *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public PageReference toResourceScreen(){
        Resource_Pool__c toScreenId = new Resource_Pool__c(Id = ApexPages.CurrentPage().getParameters().get('Resourceid')); 
        if(toScreenId != null){
            PageReference page = new PageReference('/apex/AdvisorManagment?rpid='+toScreenId.Id);
            page.setRedirect(true);
            return page;
        }else{
            PageReference page = new PageReference('/apex/BrandManagment');
            page.setRedirect(true);
            return page;
        }   
    }                 
     
    /******************************************************************************
    * @Description : Setter for scheduler configuration.                          *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/ 
    public PageReference showTemplates() {
       display=true;
       return null;
    }
     
    /******************************************************************************
    * @Description : Logic to save templates to respective template object.       *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public PageReference saveTemplate(){       
        if(emailTemplate == 1)
            objschedulerConfiguration.Cancellation_Email_Template_Customer__c = selectedTemplate;
        if(emailTemplate == 2)
            objschedulerConfiguration.Cancellation_Email_Template_Internal__c = selectedTemplate;
        if(emailTemplate == 3) 
            objschedulerConfiguration.Confirmation_Email_Template_Name__c = selectedTemplate;
        if(emailTemplate == 4)   
            objschedulerConfiguration.Reminder_E_mail_Template_Name__c = selectedTemplate;
        if(emailTemplate == 5)  
            objschedulerConfiguration.Rescheduling_Email_Template_Customer__c = selectedTemplate;
        if(emailTemplate == 6)
            objschedulerConfiguration.Rescheduling_Email_Template_Internal__c = selectedTemplate; 
        displayPopup = false;       
        return null;       
    }     
    
    /******************************************************************************
    * @Description : Class to create the brand link.                              *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public PageReference brandLink(){
        PageReference page = new PageReference('/apex/BrandManagment');
        page.setRedirect(true);
        return page;
    }
    
    /******************************************************************************
    * @Description : Method to create the resouurce pool link.                    *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public PageReference resourceLink(){
        Resource_Pool__c rpid = new Resource_Pool__c(Id = ApexPages.CurrentPage().getParameters().get('rpid'));
        Resource_Pool__c bid = [SELECT Brand_Name__c FROM Resource_Pool__c WHERE Id =: rpid.Id];
        PageReference page = new PageReference('/apex/ResourcePoolManagement?id='+bid.Brand_Name__c);
        page.setRedirect(true);
        return page;
    }
    
    /******************************************************************************
    * @Description : Method to remove time slot.                                  *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public PageReference removeTimeSlot(){
        Time__c toDelTS = new Time__c(id = ApexPages.CurrentPage().getParameters().get('timeSlotId'));
        Id advisorId = ApexPages.currentPage().getParameters().get('advisorId');
        Id rpid = [Select Id,Resource_Pool__c from Advisor__c where Id = :advisorId LIMIT 1].Resource_Pool__c;
                
        if(toDelTS!=null){
            delete toDelTS;
        }   
        PageReference page = new PageReference('/apex/TimeManagment?advisorId='+advisorId+'&rpid='+rpid);
        page.setRedirect(true);
        return page;
    }
    
    /******************************************************************************
    * @Description : Method to add time slots.                                    *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public PageReference addTimeSlot(){          
        String convSlot;
    	String convSlots;
        if(objTimeSlot.Day__c == null){
            objTimeSlot.Day__c.addError('Day Required');
            return null;        
        }    
        if(objTimeSlot.Start_Time__c == null){
            objTimeSlot.Start_Time__c.addError('Start Time Required');
            return null;            
        }
        if(objTimeSlot.End_Time__c == null){
            objTimeSlot.End_Time__c.addError('End Time Required');
            return null;        
        }       
        if(objTimeSlot.End_Time__c <= objTimeSlot.Start_Time__c){
            objTimeSlot.End_Time__c.addError('End Time cannot be less than or Equal to Start Time');
            return null;
        } 
        if(objTimeSlot.Time_Zone__c == null){
            objTimeSlot.Time_Zone__c.addError('Please insert Time Zone ');
            return null;
        }
        if(objTimeSlot.availableFor__c == null){
            objTimeSlot.Start_Time__c.addError('Available for Required');
            return null;            
        }
       
        Id advisorId = ApexPages.currentPage().getParameters().get('advisorId');
        Id rpid = [SELECT Id,Resource_Pool__c FROM Advisor__c WHERE Id =: advisorId LIMIT 1].Resource_Pool__c;
        listTimeSlots = new List<Time__c>();
        listTimeSlots = [SELECT Start_Time__c, End_Time__c, Day__c, Time_Zone__c, Advisor_Name__c, Advisor_Name__r.Name, availableFor__c 
         				 FROM Time__c 
                         WHERE Advisor_Name__c =: advisorId AND Id != :objTimeSlot.Id ];
        
        for(Time__c timeSlot : listTimeSlots ){
            if(timeSlot.Day__c == objTimeSlot.Day__c){
                if(objTimeSlot.Start_Time__c >= timeSlot.Start_Time__c && objTimeSlot.Start_Time__c < timeSlot.End_Time__c){
                    objTimeSlot.Day__c.addError('Time Slot already exists');
                    return null;                        
                }else if(objTimeSlot.End_Time__c > timeSlot.Start_Time__c && objTimeSlot.End_Time__c <= timeSlot.End_Time__c){
                    objTimeSlot.Day__c.addError('Time Slot already exists');
                    return null;                    
                }
            }
        }
        
        /* Logic to convert Start and End Time to respective Time Zone.*/
        Decimal offSetDifference = eventSchedulerUtility.getOffsetValue(objTimeSlot.Time_Zone__c,'America/Los_Angeles');
        Decimal startTime = eventSchedulerUtility.converToDecimal(objTimeSlot.Start_Time__c);
        Decimal endTime = eventSchedulerUtility.converToDecimal(objTimeSlot.End_Time__c);
       
        objTimeSlot.Start_Time__c = eventSchedulerUtility.convertToString(startTime+offSetDifference);
        objTimeSlot.End_Time__c  = eventSchedulerUtility.convertToString(endTime+offSetDifference);
         
        upsert objTimeSlot;       
        PageReference page = new PageReference('/apex/TimeManagment?advisorId='+advisorId+'&rpid='+rpid);
        page.setRedirect(true);
        return page;
    }
   
    /******************************************************************************
    * @Description : Method to navigate to time slot page.                        *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public PageReference toTimeSlotScreen(){
        Id advisorId = ApexPages.currentPage().getParameters().get('advisorId');
        Id rpid = [SELECT Id,Resource_Pool__c FROM Advisor__c WHERE Id =: advisorId LIMIT 1].Resource_Pool__c;
        PageReference page = new PageReference('/apex/TimeManagment?advisorId='+advisorId+'&rpid='+rpid);
        page.setRedirect(true);
        return page;    
    }
   
    /******************************************************************************
    * @Description : Method for top page advisor link.                            *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public PageReference advisorLink(){
        Id rpid = ApexPages.CurrentPage().getParameters().get('rpid');
        Id advisorId = ApexPages.currentPage().getParameters().get('advisorId');
        PageReference page = new PageReference('/apex/AdvisorManagment?rpid='+rpid);
        page.setRedirect(true);
        return page;
    }
   
    /******************************************************************************
    * @Description : Method to edit time slots.                                   *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/
    public PageReference editTimeSlot(){
        Id toEditTS = ApexPages.CurrentPage().getParameters().get('toEditTS');
        Id advisorId = ApexPages.currentPage().getParameters().get('advisorId');
        Id rpid = ApexPages.CurrentPage().getParameters().get('rpid');
        System.debug('#### - toEditTS '+toEditTS );
        System.debug('#### - advisorId '+advisorId );
        System.debug('#### - rpid '+rpid );
        if(toEditTS!=null && advisorId!=null && rpid!=null){
            PageReference page = new PageReference('/apex/TimeManagment?advisorId='+advisorId+'&rpid='+rpid+'&toEditTS='+toEditTS);
            page.setRedirect(true);
            return page;    
        }else{
            return null;
        }           
    } 
   
    /******************************************************************************
    * @Description : Wrapper class to populate the brand with template names.     *
    ******************************************************************************/
    public class schedulerConfigWrapper {
        public Id id {get; set;}
        public String brandName{get; set;}
        public String brandId{get; set;}
        public String ParentbrandId{get; set;}
        public String preferredLanguage{get; set;}
        public Integer bufferDays{get; set;}
        public EmailTemplate cancellationEmailTemplateCustomer{get; set;}
        public EmailTemplate cancellationEmailTemplateInternal{get; set;}
        public EmailTemplate confirmationEmailTemplateName{get; set;}
        public EmailTemplate reminderEmailTemplateName{get; set;}
        public EmailTemplate reschedulingEmailTemplateCustomer{get; set;}
        public EmailTemplate reschedulingEmailTemplateInternal{get; set;}       
    }
}// End of class.