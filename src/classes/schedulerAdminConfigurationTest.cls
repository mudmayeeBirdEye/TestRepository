/**************************************************************************************************
* Project Name..........: Implementation Scheduler.                                               *
* File..................: SchedulerWebServiceTest.cls                                             *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 15-06-2013                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 18-03-2014                                                              *
* Description...........: This is a Test class for SchedulerWebService.class                      *
**************************************************************************************************/

@IsTest
public class schedulerAdminConfigurationTest{

    private static List<schedulerConfiguration__c> schedulerConfigList = new List<schedulerConfiguration__c>();
    private static List<Resource_Pool__c> resourcePoolList = new List<Resource_Pool__c>();
    private static List<User> userList =  new List<User>();
    private static List<Advisor__c> advisorList = new List<Advisor__c>();
    private static List<Time__c> timeList = new List<Time__c>();
    private static PageReference pageRef;
    
    /******************************************************************************
    * @Description : Method to setup records.                                     *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    private static void setupRecords(){
        
        Test_Utils testUtilsObject =  new Test_Utils();
        userList = testUtilsObject.createUserRecord(new List<User>{new User(), new User()});
        EmailTemplate emailTemplate = testUtilsObject.createTemplates(); 
        schedulerConfigList = testUtilsObject.createSchedulerConfigurationRecords(new List<schedulerConfiguration__c>{new schedulerConfiguration__c( Cancellation_Email_Template_Customer__c = emailTemplate.Id,
                                                                                                                                                     Cancellation_Email_Template_Internal__c = emailTemplate.Id,
                                                                                                                                                     Confirmation_Email_Template_Name__c = emailTemplate.Id,
                                                                                                                                                     Reminder_E_mail_Template_Name__c = emailTemplate.Id,
                                                                                                                                                     Rescheduling_Email_Template_Customer__c = emailTemplate.Id,
                                                                                                                                                     Rescheduling_Email_Template_Internal__c = emailTemplate.Id)});
        
        resourcePoolList = testUtilsObject.createResourcePoolRecords(new List<Resource_Pool__c>{new Resource_Pool__c(Brand_Name__c = schedulerConfigList != null && schedulerConfigList.size() > 0 ? schedulerConfigList[0].Id : '', 
                                                                                                                     Dispatch_Admin__c = userList != null && userList.size() > 0 ? userList[0].Id : '')});
        Advisor__c advisor = new Advisor__c();
        advisor.Advisor_Name__c = userList != null && userList.size() > 0 ? userList[1].Id : '';
        advisor.Resource_Pool__c = resourcePoolList != null && resourcePoolList.size() > 0 ? resourcePoolList[0].Id : '';
        advisor.Preferred_Language__c = 'en_US';
        insert advisor; 
        advisorList.add(advisor);
        
        timeList = testUtilsObject.createTimeSlotRecords(new List<Time__c>{new Time__c(Advisor_Name__c = advisorList != null && advisorList.size() > 0 ? advisorList[0].Id : '')});
        
    }
    
    /******************************************************************************
    * @Description : Testing for brand page.                                      *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public static testMethod void testingBrandPage(){     

        /* Calling method to setup records. */
        setupRecords();

        //Testing Brand Screen
        pageRef = Page.BrandManagment;
        Test.setCurrentPage(pageRef);
        schedulerConfiguration__c brand = schedulerConfigList != null && schedulerConfigList.size() > 0 ? schedulerConfigList[0] : new schedulerConfiguration__c();
        schedulerAdminConfiguration scAdminConfig = new schedulerAdminConfiguration();
        scAdminConfig.objschedulerConfiguration = brand;       
        scAdminConfig.saveBrand(); 
        
        //Testing for null input
        scAdminConfig.objschedulerConfiguration.Name = null;
        scAdminConfig.saveBrand();
        scAdminConfig.objschedulerConfiguration = brand;
        scAdminConfig.objschedulerConfiguration.Brand_Id__c = null;
        scAdminConfig.saveBrand();
        scAdminConfig.objschedulerConfiguration = brand;
        scAdminConfig.objschedulerConfiguration.Buffer_Days__c = null;
        scAdminConfig.saveBrand();
        scAdminConfig.objschedulerConfiguration = brand;
        scAdminConfig.objschedulerConfiguration.Cancellation_Email_Template_Customer__c = null;
        scAdminConfig.saveBrand();
        scAdminConfig.objschedulerConfiguration = brand;
        scAdminConfig.objschedulerConfiguration.Cancellation_Email_Template_Internal__c = null;
        scAdminConfig.saveBrand();
        scAdminConfig.objschedulerConfiguration = brand;
        scAdminConfig.objschedulerConfiguration.Confirmation_Email_Template_Name__c = null;
        scAdminConfig.saveBrand();
        scAdminConfig.objschedulerConfiguration = brand;
        scAdminConfig.objschedulerConfiguration.Reminder_E_mail_Template_Name__c = null;
        scAdminConfig.saveBrand();
        scAdminConfig.objschedulerConfiguration = brand;
        scAdminConfig.objschedulerConfiguration.Rescheduling_Email_Template_Customer__c = null;
        scAdminConfig.saveBrand();
        scAdminConfig.objschedulerConfiguration = brand;
        scAdminConfig.objschedulerConfiguration.Rescheduling_Email_Template_Internal__c = null;
        scAdminConfig.saveBrand(); 
            
        // Testing removeRecord()
        ApexPages.CurrentPage().getParameters().put('Name', brand.Id);
        scAdminConfig.removeRecord();
    }     
    
    /******************************************************************************
    * @Description : Testing for resource pool page.                              *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public static testMethod void testingResourcePoolPage(){        
        
        /* Calling method to setup records. */
        setupRecords();
        
        schedulerConfiguration__c brand = schedulerConfigList != null && schedulerConfigList.size() > 0 ? schedulerConfigList[0] : new schedulerConfiguration__c();
        Resource_Pool__c resourcePool = resourcePoolList != null && resourcePoolList.size() > 0 ? resourcePoolList[0] : new Resource_Pool__c();
        schedulerAdminConfiguration scAdminConfig = new schedulerAdminConfiguration();
        scAdminConfig.setSchedulerConfig(brand, brand);
        scAdminConfig.getResourcePool('testAccount');
        scAdminConfig.setResourcePool(resourcePool, resourcePool);
        //Testing Resource Pool
        pageRef = Page.ResourcePoolManagement;
        Test.setCurrentPage(pageRef); 
        
        //creating resource pool using save resource pool
        scAdminConfig.objResourcePool = resourcePool;              
        scAdminConfig.saveResourcePool();  
        
        //Testing for null input
        scAdminConfig.objResourcePool.Brand_Name__c = null;
        scAdminConfig.saveResourcePool(); 
        scAdminConfig.objResourcePool.Dispatch_Admin__c = null;
        scAdminConfig.saveResourcePool();
        scAdminConfig.objResourcePool.Resource_Pool_Email__c = null;
        scAdminConfig.saveResourcePool();
        scAdminConfig.objResourcePool.No_of_User_DLs__c = null;
        scAdminConfig.saveResourcePool(); 
        
        //Testing editResourcePoolRecords()
        scAdminConfig.editResourcePoolRecords();
        ApexPages.CurrentPage().getParameters().put('ResourcePoolName', resourcePool.Id);
        ApexPages.CurrentPage().getParameters().put('id', brand.Id);
        scAdminConfig.editResourcePoolRecords();
        
        //Testing removeRpRecord()
        ApexPages.CurrentPage().getParameters().put('Name', resourcePool.Id);
        scAdminConfig.removeRpRecord();   
    }          
    
    /******************************************************************************
    * @Description : Testing for Advisor page.                                    *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public static testMethod void testingAdvisorPage(){        
        
        /* Calling method to setup records. */
        setupRecords();
        schedulerAdminConfiguration scAdminConfig = new schedulerAdminConfiguration();
        schedulerConfiguration__c brand = schedulerConfigList != null && schedulerConfigList.size() > 0 ? schedulerConfigList[0] : new schedulerConfiguration__c();
        Resource_Pool__c resourcePool = resourcePoolList != null && resourcePoolList.size() > 0 ? resourcePoolList[0] : new Resource_Pool__c();
        Advisor__c advisor = advisorList != null && advisorList.size() > 0 ? advisorList[0] :  new Advisor__c();
        //Testing Add Advisor
        pageRef = Page.AdvisorManagment;
        Test.setCurrentPage(pageRef);
        
        scAdminConfig.objadvisor = advisor;     
        scAdminConfig.addAdvisor();
        
        //Testing for null input
        scAdminConfig.objadvisor.Resource_Pool__c = null;    
        scAdminConfig.addAdvisor();
        scAdminConfig.objadvisor.Advisor_Name__c = null;    
        scAdminConfig.addAdvisor();
        
        //Testing removeAdvisor()
        ApexPages.CurrentPage().getParameters().put('Name', advisor.Id);
        scAdminConfig.removeAdvisor();
    }
    
    /******************************************************************************
    * @Description : Testing for Time page.                                       *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public static testMethod void testingTimePage(){        
        
        /* Calling method to setup records. */
        setupRecords();
        
        schedulerConfiguration__c brand = schedulerConfigList != null && schedulerConfigList.size() > 0 ? schedulerConfigList[0] : new schedulerConfiguration__c();
        Resource_Pool__c resourcePool = resourcePoolList != null && resourcePoolList.size() > 0 ? resourcePoolList[0] : new Resource_Pool__c();
        Advisor__c advisor = advisorList != null && advisorList.size() > 0 ? advisorList[0] :  new Advisor__c();
        Time__c timeSlot = timeList != null && timeList.size() > 0 ? timeList[0] : new Time__c();
        schedulerAdminConfiguration scAdminConfig = new schedulerAdminConfiguration();
        //Testing for addTimeSlot()
        ApexPages.CurrentPage().getParameters().put('advisorId', advisor.Id);        
        scAdminConfig.addTimeSlot();
        //Testing for null input
        scAdminConfig.objTimeSlot.Start_Time__c = null;
        scAdminConfig.addTimeSlot();
        scAdminConfig.objTimeSlot = timeSlot;
        scAdminConfig.objTimeSlot.End_Time__c = null;
        scAdminConfig.addTimeSlot();
        scAdminConfig.objTimeSlot = timeSlot;  
        scAdminConfig.addTimeSlot();   
        scAdminConfig.objTimeSlot.Start_Time__c = null;  
        scAdminConfig.addTimeSlot();   
        
        ApexPages.CurrentPage().getParameters().put('advisorId', advisor.Id);
        scAdminConfig.toTimeSlotScreen();
        scAdminConfig.advisorLink();
        
        //Testing editTimeSlot()
        scAdminConfig.editTimeSlot(); 
        ApexPages.CurrentPage().getParameters().put('toEditTS', timeSlot.Id);  
        ApexPages.CurrentPage().getParameters().put('advisorId', advisor.id);  
        ApexPages.CurrentPage().getParameters().put('rpid', resourcePool.id); 
        scAdminConfig.editTimeSlot();
        
        // Testing removeTimeSlot()
        ApexPages.CurrentPage().getParameters().put('timeSlotId',timeSlot.Id);
        ApexPages.CurrentPage().getParameters().put('advisorId',advisor.Id);
        scAdminConfig.removeTimeSlot();
    
    }
    
    /******************************************************************************
    * @Description : Testing for Other functionality on page.                     *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public static testMethod void testingOthers(){        
        
        /* Calling method to setup records. */
        setupRecords();
        
        schedulerConfiguration__c brand = schedulerConfigList != null && schedulerConfigList.size() > 0 ? schedulerConfigList[0] : new schedulerConfiguration__c();
        Resource_Pool__c resourcePool = resourcePoolList != null && resourcePoolList.size() > 0 ? resourcePoolList[0] : new Resource_Pool__c();
        Advisor__c advisor = advisorList != null && advisorList.size() > 0 ? advisorList[0] :  new Advisor__c();
        schedulerAdminConfiguration scAdminConfig = new schedulerAdminConfiguration();       
        scAdminConfig.closePopup();
        scAdminConfig.showPopup();
        scAdminConfig.getTemplateList();
        scAdminConfig.getFolderName();
        scAdminConfig.fetchEmailTemplate();
        scAdminConfig.showTemplates();
    }
    
    /******************************************************************************
    * @Description : Testing for Other functionality on page.                     *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public static testMethod void testingOthers1(){        
        
        /* Calling method to setup records. */
        setupRecords();
        
        schedulerConfiguration__c brand = schedulerConfigList != null && schedulerConfigList.size() > 0 ? schedulerConfigList[0] : new schedulerConfiguration__c();
        Resource_Pool__c resourcePool = resourcePoolList != null && resourcePoolList.size() > 0 ? resourcePoolList[0] : new Resource_Pool__c();
        Advisor__c advisor = advisorList != null && advisorList.size() > 0 ? advisorList[0] :  new Advisor__c();
        schedulerAdminConfiguration scAdminConfig = new schedulerAdminConfiguration();      
        scAdminConfig.emailTemplate = 1;        
        scAdminConfig.saveTemplate();
        scAdminConfig.emailTemplate = 2;        
        scAdminConfig.saveTemplate();
        scAdminConfig.emailTemplate = 3;        
        scAdminConfig.saveTemplate();
        scAdminConfig.emailTemplate = 4;        
        scAdminConfig.saveTemplate();
        scAdminConfig.emailTemplate = 5;        
        scAdminConfig.saveTemplate();
        scAdminConfig.emailTemplate = 6;        
        scAdminConfig.saveTemplate();
    }
    
    /******************************************************************************
    * @Description : Testing for Other functionality on page.                     *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public static testMethod void testingOthers2(){        
        
        /* Calling method to setup records. */
        setupRecords();
        
        schedulerConfiguration__c brand = schedulerConfigList != null && schedulerConfigList.size() > 0 ? schedulerConfigList[0] : new schedulerConfiguration__c();
        Resource_Pool__c resourcePool = resourcePoolList != null && resourcePoolList.size() > 0 ? resourcePoolList[0] : new Resource_Pool__c();
        Advisor__c advisor = advisorList != null && advisorList.size() > 0 ? advisorList[0] :  new Advisor__c();
        schedulerAdminConfiguration scAdminConfig = new schedulerAdminConfiguration();      
        scAdminConfig.brandLink();       
        
        //Testing toBrandScreen()
        scAdminConfig.toBrandScreen();
        ApexPages.CurrentPage().getParameters().put('Brandid', brand.Id);
        scAdminConfig.toBrandScreen();
        
        //Testing editBrandRecords()
        scAdminConfig.editBrandRecords();
        ApexPages.CurrentPage().getParameters().put('NameBrand', brand.Id);
        scAdminConfig.editBrandRecords();
         
         //Testing toResourceScreen()
        scAdminConfig.toResourceScreen();
        ApexPages.CurrentPage().getParameters().put('Resourceid', resourcePool.Id);
        scAdminConfig.toResourceScreen();
        
        //Testing resourceLink()
        ApexPages.CurrentPage().getParameters().put('rpid', resourcePool.Id);
        scAdminConfig.resourceLink();    
    }
} // End of Class.