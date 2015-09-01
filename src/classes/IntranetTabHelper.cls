public class IntranetTabHelper {
	
	public IntranetTabHelper() {
		
	}
//static String SYSADMIN_PROFILE_ID = null;
///*static {
    //(SYSADMIN_PROFILE_ID == null) {
        //  SYSADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
     // } 
//}*/

  //public static String getSysAdminProfileId() {
     /* if(SYSADMIN_PROFILE_ID == null) {
          SYSADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
      }
      return SYSADMIN_PROFILE_ID;*/
 // }
  
 // public static PageReference cancel() {
    /*  string strRtnUrl = NULL;
      PageReference  pageRef;
      if(ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL') != '') {
          strRtnUrl = ApexPages.currentPage().getParameters().get('retURL');
      }
      if(strRtnUrl != NULL) {
          pageRef = new PageReference(strRtnUrl);
      }
      else {
          string keyPrefix = '/' + Schema.getGlobalDescribe().get('Intranet_Main_Tab__c').getDescribe().getKeyPrefix() + '/o'; 
          pageRef =  new PageReference(keyPrefix);
      }
      return pageRef;*/
 // }
  
  //public static string validationSave(Intranet_Main_Tab__c tab,Map<Id,Intranet_Main_Tab__c>  tabMap) {
     
     /* string strMessage = NULL;
      if(tab.ParentID__c == NULL && UserInfo.getProfileId() != IntranetTabHelper.SYSADMIN_PROFILE_ID){ //'00e80000000l1hKAAQ') { //00e80000000l1hKAAQ   System Administrator Profile Id
          strMessage = 'Only System Admin can create or update the Main Menu Tab.';    
          return strMessage; 
      }
      if(tab.ParentID__c != NULL && tab.Intranet_Main_Tabs__r.size() > 0 ){
          strMessage = 'Tab with child tabs can not be a child of another Tab';
          return strMessage;
      }
      string[] strArrName = (tab.Name).trim().split('\\s');            // Code to check size of Tab Name;
      if(strArrName.size() > 2) {
          strMessage = 'Tab Name is acceptable with one space only.';    
          return strMessage;
      } 
      Integer intLength = 0;
      for(string str : strArrName) {
          intLength = intLength + str.length();
      }
      if(intLength > 15) {
          strMessage = 'Number of characters in the Tab Name must be less than or equal to 15.';    
          return strMessage;
      }    
      if(tab.Name == 'Home' && tab.isDisabled__c == true) {
			return 'Home tab can not be disabled.';
      }
      if(tab.Name == 'Home' && tab.IsPublic__c == false) {
			return 'Home tab is required to be public.';
      }
      if( tab.Content__c != null && tab.Content__c.length() > 32768 ){
          strMessage = 'Data Value Too Large (max length=32768). Please Limit Your Content And Save Again.' ;
       	  return strMessage;
      }
      return null;*/
  //}
  
  //public static boolean chkUserEdit(Intranet_Main_Tab__c tab) {
     /* boolean isAdminOrOwner = false;
      // if(UserInfo.getProfileId() == '00e80000000l1hKAAQ' || UserInfo.getUserId() == tab.OwnerId) {
      if(UserInfo.getProfileId() == IntranetTabHelper.SYSADMIN_PROFILE_ID || UserInfo.getUserId() == tab.OwnerId) {
          isAdminOrOwner = true;
      }
      return isAdminOrOwner;*/
  //}
  
  //public static List<SelectOption> getContentTypeOption() {
     /* List<SelectOption> contentTypeOption = new List<SelectOption>();          
      Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Intranet_Main_Tab__c.fields.ContentType__c;
      for(Schema.PicklistEntry  pkListObj : fieldResult.getPicklistValues()) {
          contentTypeOption.add(new SelectOption( pkListObj.getValue() , pkListObj.getValue()));  
      }
      return contentTypeOption;*/
  //}
  
  // public static List<SelectOption> getPositionTypeOption() {
     /* List<SelectOption> positionTypeOption = new List<SelectOption>();          
      Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Intranet_Main_Tab__c.fields.Position_type__c;
      for(Schema.PicklistEntry  pkListObj : fieldResult.getPicklistValues()) {
          positionTypeOption.add(new SelectOption( pkListObj.getValue() , pkListObj.getValue()));  
      }
      return positionTypeOption;*/
 // }
  
  
//  public static List<SelectOption> getPageOptions(LIST<String> apexPageList) {
     /* List<SelectOption> pageOption = new List<SelectOption>();                      
      for(String  pageObject : apexPageList) {
          pageOption.add(new SelectOption(pageObject ,pageObject));  
       }   
      return pageOption; */
 // } 
  
  
 // public static PageReference setTabOrder(Intranet_Main_Tab__c tab) {
    //  PageReference setTabOrderPageRef = new PageReference('/apex/SetTabOrder?id='+tab.Id+'&retURL='+ApexPages.currentPage());
    //  return setTabOrderPageRef;
 // }
  
//  public static PageReference setTabImage(Intranet_Main_Tab__c tab) {
  //    PageReference setTabImagePageRef = new PageReference('/apex/UploadTabImage?id='+tab.Id+'&retURL='+ApexPages.currentPage());
  //    return setTabImagePageRef;
 // }
  
 // public static PageReference onEdit(Intranet_Main_Tab__c tab) {
 //     PageReference editPageRef = new PageReference('/apex/tabCreation?id='+tab.Id+'&retURL='+ApexPages.currentPage());
  //    return editPageRef;
  //}/*
  
    /*Test Methods*/
  //@isTest(SeeAllData=true)
 // static  void IntranetTabHelper() {
   	//	IntranetTabHelper intTabHelpObj = new IntranetTabHelper();
   	 /* List<Intranet_Main_Tab__c> intraList = new List<Intranet_Main_Tab__c>();
	   
	   for(Integer i=0; i<10; i++) {
	  	  Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
	  	  intraTest.IsDisabled__c = false;
	  	  intraTest.Name ='test';
	  	  intraTest.IsPublic__c = true;
	   	  intraTest.Position_Type__c ='Top';
	   	  intraList.add(intraTest);
	   }  
	  insert intraList;
      
      List<Intranet_Main_Tab__c> intraListChild = new List<Intranet_Main_Tab__c>(); 
      
      for(Intranet_Main_Tab__c  intrTemp : intraList) {
	      	  Intranet_Main_Tab__c intraTestChild = new Intranet_Main_Tab__c();
		  	  intraTestChild.IsDisabled__c = false;
		  	  intraTestChild.Name ='test';
		  	  intraTestChild.ParentID__c = intrTemp.id;
		  	  intraTestChild.IsPublic__c = true;
		   	  intraTestChild.Position_Type__c ='Top';
		   	  intraListChild.add(intraTestChild);
      }
      insert intraListChild; 
       	  
  	 IntranetTabHelper helperTest = new IntranetTabHelper();
  	 
  	 IntranetTabHelper.chkUserEdit(intraList[0]);
  	 
  	 IntranetTabHelper.getContentTypeOption();
  	 IntranetTabHelper.getPositionTypeOption();
  	 IntranetTabHelper.setTabOrder(intraList[0]);
  	 IntranetTabHelper.setTabImage(intraList[0]);
  	 IntranetTabHelper.onEdit(intraList[0]);
  	 List<String> temp = new List<String>();
  	 temp.add('A');
  	 temp.add('B');
  	 temp.add('C');
  	 IntranetTabHelper.getPageOptions(temp);
  	 
  	 ApexPages.currentPage().getParameters().put('retURL','www.test.com');
  	 IntranetTabHelper.cancel();
  	 
  	 ApexPages.currentPage().getParameters().put('retURL',null);
  	 IntranetTabHelper.cancel();*/
  	   	 
  // }
   
   /*@isTest(SeeAllData=true)
   static  void IntranetTabHelper0() {
   		
   		
   		
   		
   		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      	User u = new User(Alias = 'helpe', Email='helper@testorg.com', 
      	EmailEncodingKey='UTF-8', LastName='helpre', LanguageLocaleKey='en_US', 
      	LocaleSidKey='en_US', ProfileId = p.Id, 
      	TimeZoneSidKey='America/Los_Angeles', UserName='helper@testorg.com');

       System.runAs(u) {
       	 
       	List<Intranet_Main_Tab__c> intraList = new List<Intranet_Main_Tab__c>();
	   
	   for(Integer i=0; i<10; i++) {
	  	  Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
	  	  intraTest.IsDisabled__c = false;
	  	  intraTest.Name ='test';
	  	  intraTest.IsPublic__c = true;
	   	  intraTest.Position_Type__c ='Top';
	   	  intraList.add(intraTest);
	   }  
	  insert intraList;
      
      List<Intranet_Main_Tab__c> intraListChild = new List<Intranet_Main_Tab__c>(); 
      
      for(Intranet_Main_Tab__c  intrTemp : intraList) {
	      	  Intranet_Main_Tab__c intraTestChild = new Intranet_Main_Tab__c();
		  	  intraTestChild.IsDisabled__c = false;
		  	  intraTestChild.Name ='test';
		  	  intraTestChild.ParentID__c = intrTemp.id;
		  	  intraTestChild.IsPublic__c = true;
		   	  intraTestChild.Position_Type__c ='Top';
		   	  intraListChild.add(intraTestChild);
      }
      insert intraListChild; 
       	 
       	 
       	 
       	 Map<id, Intranet_Main_Tab__c> testMap = new Map<id, Intranet_Main_Tab__c>([select Id, Name, ParentID__r.Name ,Tab_Order__c,Content__c,ParentID__c, Position_Type__c, Vf_Page_Url__c,Tab_Visibilty_Setting__c,
                        (Select Id, Name, Tab_Order__c,Content__c,ParentID__c from Intranet_Main_Tabs__r) 
                        FROM Intranet_Main_Tab__c]);
       	 
       	 
       	 Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
	  	 intraTest.IsDisabled__c = false;
	  	 intraTest.Name ='test123 456789012345 12345 2312312';
	  	 intraTest.IsPublic__c = true;
	   	 intraTest.Position_Type__c ='Top';
	   	 	   	 
       	IntranetTabHelper.validationSave(intraTest, testMap);
       	      	    	      	
      	
       }
       
       
       
       Intranet_Main_Tab__c intraTest0 = new Intranet_Main_Tab__c();
	   intraTest0.IsDisabled__c = false;
	   intraTest0.Name ='test123 456789012345 12345 2312312';
	   intraTest0.IsPublic__c = true;
	   intraTest0.Position_Type__c ='Top';
	   	 
	   IntranetTabHelper.validationSave(intraTest0, null);
	   
	   Intranet_Main_Tab__c intraTest1 = new Intranet_Main_Tab__c();
	   intraTest1.IsDisabled__c = false;
	   intraTest1.Name ='test123456789012345123452312312';
	   intraTest1.IsPublic__c = true;
	   intraTest1.Position_Type__c ='Top';
	   	 
	   IntranetTabHelper.validationSave(intraTest1, null);
	   
	   Intranet_Main_Tab__c intraTest2 = new Intranet_Main_Tab__c();
	   intraTest2.IsDisabled__c = false;
	   intraTest2.Name ='Home';
	   intraTest2.IsPublic__c = true;
	   intraTest2.Position_Type__c ='Top';
	   intraTest2.isDisabled__c = true;
	   	 
	   IntranetTabHelper.validationSave(intraTest2, null);
	   
	   Intranet_Main_Tab__c intraTest3 = new Intranet_Main_Tab__c();
	   intraTest3.IsDisabled__c = false;
	   intraTest3.Name ='Home';
	   intraTest3.IsPublic__c = false;
	   intraTest3.Position_Type__c ='Top';
	  	   	 
	   IntranetTabHelper.validationSave(intraTest3, null);
	   
	   Intranet_Main_Tab__c intraTest4 = new Intranet_Main_Tab__c();
	   intraTest4.IsDisabled__c = false;
	   intraTest4.Name ='Home';
	   intraTest4.IsPublic__c = true;
	   intraTest4.Position_Type__c ='Top';
	   intraTest4.Content__c = '';
	   for(integer i = 0 ;i < 35000; i++){
	   		intraTest4.Content__c =  intraTest4.Content__c + i;
   	   }
   	  IntranetTabHelper.validationSave(intraTest4, null);
   	  
   	  Intranet_Main_Tab__c intraTest5 = new Intranet_Main_Tab__c();
	  intraTest5.IsDisabled__c = false;
	  intraTest5.Name ='Home';
	  intraTest5.IsPublic__c = true;
	  intraTest5.Position_Type__c ='Top';
	  intraTest5.Content__c = '';
	  IntranetTabHelper.validationSave(intraTest5, null);
	  
	  Intranet_Main_Tab__c intraTest6 = new Intranet_Main_Tab__c();
	  intraTest6.IsDisabled__c = false;
	  intraTest6.Name ='Home';
	  intraTest6.IsPublic__c = true;
	  intraTest6.Position_Type__c ='Top';
	  intraTest6.Content__c = '';
	  insert intraTest6;
	  
	  
	  Intranet_Main_Tab__c intraTest7 = new Intranet_Main_Tab__c();
	  intraTest7.IsDisabled__c = false;
	  intraTest7.Name ='Home';
	  intraTest7.IsPublic__c = true;
	  intraTest7.Position_Type__c ='Top';
	  intraTest7.Content__c = '';
	  intraTest7.ParentID__c = intraTest6.id;
	  insert intraTest7;
	  
	  
	  Intranet_Main_Tab__c intraTest8 = new Intranet_Main_Tab__c();
	  intraTest8.IsDisabled__c = false;
	  intraTest8.Name ='Home';
	  intraTest8.IsPublic__c = true;
	  intraTest8.Position_Type__c ='Top';
	  intraTest8.Content__c = '';
	  insert intraTest8;
	  
	  
	  
	  intraTest6.ParentID__c  = intraTest8.id;
	  	  
	  IntranetTabHelper.validationSave(intraTest6, null);
   }*/
   
}