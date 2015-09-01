/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_AccountMetricExtension {

    static testMethod void accountMetricExtensionTest() { 
        // TO DO: implement unit test
        
        ApexPages.StandardController controller; 
        Account objAccount = new Account(Name='RC Internal',RC_Service_name__c='Office', Number_of_DL_s__c=10);
        insert objAccount;
        List<Contact> contactList = new List<Contact>();
        Contact objContact1 = new Contact(FirstName='Test', LastName='Test',email='abc@cc.com', AccountId=objAccount.id);
        Contact objContact2 = new Contact(LastName='Test',email='abc1@cc.com',AccountId=objAccount.id);
        Contact objContact3 = new Contact(LastName='Test',email='abc2@cc.com',AccountId=objAccount.id);
        contactList.add(objContact1);
        contactList.add(objContact2);
        contactList.add(objContact3);
        insert contactList; 
        Peer_Group__c objPG = new Peer_Group__c(Peer_Group_ID__c = 22);
        insert objPG;
        Implementation__c objImp = new Implementation__c(Account__c=objAccount.id,Implementation_Status__c = '6a. Completed', 
        													Implementation_Status_2__c = 'Completed',
        													Account_Review__c='Overview;Messages', Company_Numbers_and_Info__c='Company Caller ID;Company Address',
        													Users__c='Unassigned Ext;Add Users',Phones_Devices__c='Phone Serial Number;Phone Nickname',
        													Groups__c='Add Group;Call Queues',Tools__c='Mobile App;Softphone');
        //insert objImp;
        Account_Metric__c objAccMatric = new Account_Metric__c(Account_ID__c=objAccount.id, Metric_18_value__c = 0.5,Peer_Group_ID__c = 22);
        insert objAccMatric;
        ApexPages.currentPage().getParameters().put('accid', objAccount.id);
        List<Case> lstCase = new List<Case>();
        lstCase.add(new Case(Origin = 'Web', AccountId=objAccount.id, Status='Completed')); 
        lstCase.add(new Case(Origin = 'Web', AccountId=objAccount.id, Status='Closed'));
        insert  lstCase;
        Network_Information__c objNetwork = new Network_Information__c(Account__c=objAccount.id);
        Survey__c survey1 = new Survey__c(Account__c= objAccount.id,SurveyType__c=AccountScoreCardHelper.SURVEY_SUPPORT, support_overall_sat_eval__c=2, Likely_to_Recommend_Rel__c=2, 
        									Implementation_Advisor_Satisfaction__c=2, sales_overall_sat_eval__c=2, Response_Date__c= system.today());
        Survey__c survey2 = new Survey__c(Account__c= objAccount.id,SurveyType__c=AccountScoreCardHelper.SURVEY_RELATIONSHIP, support_overall_sat_eval__c=2, Likely_to_Recommend_Rel__c=2, 
        									Implementation_Advisor_Satisfaction__c=2, sales_overall_sat_eval__c=2, Response_Date__c= system.today());
        Survey__c survey3 = new Survey__c(Account__c= objAccount.id,SurveyType__c=AccountScoreCardHelper.SURVEY_NEWCUSTOMER, support_overall_sat_eval__c=2, Likely_to_Recommend_Rel__c=2, 
        									Implementation_Advisor_Satisfaction__c=2, sales_overall_sat_eval__c=2, Response_Date__c= system.today());
        Survey__c survey4 = new Survey__c(Account__c= objAccount.id,SurveyType__c=AccountScoreCardHelper.SURVEY_IMPLEMENTATION, support_overall_sat_eval__c=2, Likely_to_Recommend_Rel__c=2, 
        									Implementation_Advisor_Satisfaction__c=2, sales_overall_sat_eval__c=2, Response_Date__c= system.today());
        Survey__c survey5 = new Survey__c(Account__c= objAccount.id,SurveyType__c=AccountScoreCardHelper.SURVEY_ATTIMPLEMENTATION, support_overall_sat_eval__c=2, Likely_to_Recommend_Rel__c=2, 
        									Implementation_Advisor_Satisfaction__c=2, sales_overall_sat_eval__c=2, Response_Date__c= system.today());
        List<Survey__c> lstSurevy = new List<Survey__c>();
        lstSurevy.add(survey1);
       	lstSurevy.add(survey2);
       	lstSurevy.add(survey3);
       	lstSurevy.add(survey4);
       	lstSurevy.add(survey5);
       	insert lstSurevy;
        AccountMetricExtension objAccountMetricExtension = new AccountMetricExtension(controller);
        objAccountMetricExtension.inputtxtsearch = 'Test';
        for(Contact cont:contactList){
        	 objAccountMetricExtension.selectedContacts.add(cont.id); 
        }
        objAccountMetricExtension.selectedCCList.add(''+contactList[0].Id);
        objAccountMetricExtension.AllCCOptionsSet.add(''+contactList[0].Id);
	    objAccountMetricExtension.selectedBccList.add(''+contactList[1].Id);
	    objAccountMetricExtension.AllBccOptionsSet.add(''+contactList[1].Id);
	    objAccountMetricExtension.selectedAdditionalToList.add(''+contactList[2].Id); 
	    objAccountMetricExtension.AllAdditionalToSet.add(''+contactList[2].Id);
	    objAccountMetricExtension.IC_Phones = new List<String>();
        objAccountMetricExtension.IC_Groups = new List<String>();
        objAccountMetricExtension.IC_Phones.addAll(new List<String>{'Phone Serial Number','Phone Nickname','E911'});
        objAccountMetricExtension.IC_Groups.addAll( new List<String>{'Add Group','Call Queues','Paging','Shared Lines'});  
        objAccountMetricExtension.getContactOptions();
        objAccountMetricExtension.getMetricSet();
        objAccountMetricExtension.setToAddress();
        objAccountMetricExtension.removeToAddress();
        objAccountMetricExtension.setAdditionalTo(); 
        objAccountMetricExtension.removeAdditionalTo();
        objAccountMetricExtension.getAllAdditionalTo(); 
        objAccountMetricExtension.setCCList();
        objAccountMetricExtension.getAllCCOptions();
        objAccountMetricExtension.removeCCList();
        objAccountMetricExtension.setBccList();
        objAccountMetricExtension.getAllBccOptions();
        objAccountMetricExtension.removeBccList();
        objAccountMetricExtension.getemailonSearch();
        objAccountMetricExtension.sendMailToCustomerCall();
        objAccountMetricExtension.exportasPDF();
        objAccountMetricExtension.redirectToSendMailPage();
        objAccountMetricExtension.cancel();
        objAccMatric.Metric_18_value__c=0.87;
        objAccount.Number_of_DL_s__c=300;
        objAccountMetricExtension = new AccountMetricExtension(controller);
    }
}