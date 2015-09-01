public with sharing class TabVisibilityCtrl {
   /* public String sel { get; set; }
	public String idsOfProfiles { get; set; }
    public String tabId { get; set;}
    public String[] profileIds;
    public List<ProfileWrapper> proList {get;set;}
    
    Map<id,Intranet_Main_Tab__c> tabMap ;*/
  
   /**
     * @Constructor load tabs in construtor for Admin/non Admin
    */     
    public TabVisibilityCtrl() {
    	/* String SYSADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
    	
    		if(SYSADMIN_PROFILE_ID == UserInfo.getProfileId() ){
		    	tabMap = new Map<id,Intranet_Main_Tab__c>([Select 
		    													Name, 
		    													IsMainTab__c, 
		    													Tab_Visibilty_Setting__c,
		    													Id 
		    												From 
		    													Intranet_Main_Tab__c 
		    												Where 
		    													 isDisabled__c = false]);
	    	} else {
		    	tabMap = new Map<id,Intranet_Main_Tab__c>([Select 
		    													Name,
		    													IsMainTab__c,
		    													Tab_Visibilty_Setting__c,
		    													Id 
		    												From 
		    													Intranet_Main_Tab__c 
		    												Where
		    													isDisabled__c = false 
		    												AND 
		    													Ownerid =:UserInfo.getUserId()]);	
	    	}											
        profileIds = new String[]{};
        idsOfProfiles = ''; */
    }

   /* public List<SelectOption> getTabs(){
       ///List<SelectOption> options = new List<SelectOption>();
        // for(Intranet_Main_Tab__c tab : tabMap.values() ) {
          //   options.add(new SelectOption( tab.Id , tab.Name ));
        // }
       // return options;
    } */
    
   // public List<ProfileWrapper> proList 
     
  /*  public List<ProfileWrapper> getProfileName(){
    	//proList = new List<ProfileWrapper>();
    	//for(Profile pro : [Select 
    							//UserLicense.Name, 
    							//UserLicenseId, 
    							//Name,
    				//			Id 
    				//		From 
    				//			Profile  
    				//		Where 
    				//			UserLicense.Name ='Salesforce' 
    				//	  	AND 
    			//		  		Name !='System Administrator']) {
           //  proList.add(new ProfileWrapper( false, pro ));
        // }
    	//return proList;  * 
    } */
    
   /* public List<SelectOption> getProfiles(){
      // List<SelectOption> options = new List<SelectOption>();
        // for(Profile pro : [Select 
        // 						UserLicense.Name, 
        // 						UserLicenseId, 
        // 						Name, 
        // 						Id 
        // 					From 
        // 						Profile  
        // 					Where 
         //						UserLicense.Name ='Salesforce' 
         ////					AND 
         //						Name !='System Administrator']) {
        //  //   options.add(new SelectOption(pro.Id,pro.Name));
       //  }
       // return options;
    }*/
    
   // public PageReference setVisibility(){
    /*	idsOfProfiles = '';	
    	
    	for(ProfileWrapper pw : proList) {
    			if(pw.isChecked){
    				idsOfProfiles = idsOfProfiles + pw.pro.id + ',';
    		}
    	}
    	
        if( tabId != null && profileIds != null ) {
             Intranet_Main_Tab__c  tab =  tabMap.get(tabId);
            tab.Tab_Visibilty_Setting__c = idsOfProfiles;
             try {
               update tab;
             } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, e.getMessage()));
            //return ApexPages.currentPage();
            return null;
             }    
           ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.INFO, 'Profiles Updated With Selected TAB.' ));
           //return ApexPages.currentPage();
           return null;
          } else {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, 'Please Select Tab and Profiles. And Try Again.' ));
            //return ApexPages.currentPage();
            return null;
        }  
          //return ApexPages.currentPage();
          return null; */
   // } 
    
   // public String getProfileString(){
      /*  String temp='';
        for(String s : getProfileIds() ){
            temp = temp +s+',';
        }
        return temp;*/
   // }
    
  //  public String[] getProfileIds () {
           //  return profileIds ;
   // }

  //  public void setProfileIds (String[] Profileids) {
  //      this.profileIds = Profileids;
  //  }
   
   // public PageReference onClose() {
  //      String keyPrefix = '/' + Schema.SObjectType.Intranet_Main_Tab__c.getKeyPrefix() + '/o'; 
   //     return  new PageReference(keyPrefix);
  //  }
    
  //  public class ProfileWrapper {
    /*	public Boolean isChecked { get; set; }
    	public Profile pro { get; set; }
    	
    	public ProfileWrapper(Boolean isChecked, Profile pro){
    		this.isChecked = isChecked;
    		this.pro = pro;
    	}*/
   //  } 
     
        /*Test Method
   -------------------------------------------------------------------------
   */ 
   /*@isTest(SeeAllData=true)
   static void TabVisibilityCtrlTest() {
   			TabVisibilityCtrl  testVisiblity = new  TabVisibilityCtrl();
   		  /*List<Intranet_Main_Tab__c> intraList = new List<Intranet_Main_Tab__c>();
			   
			   for(Integer i=0; i<10; i++) {
			  	  Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
			  	  intraTest.IsDisabled__c = false;
			  	  intraTest.Name ='test';
			  	  intraTest.IsPublic__c = true;
			   	  intraTest.Position_Type__c ='Top';
			   	  intraTest.Content__c ='test';
			   	  intraTest.ContentType__c ='Static';
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
				   	  intraTestChild.Content__c ='test';
			   	  	  intraTestChild.ContentType__c ='Page';
				   	  intraListChild.add(intraTestChild);
		      }
		      insert intraListChild;  
   
			
			testVisiblity.getTabs();
			testVisiblity.getProfileName();
			testVisiblity.getProfiles();
			testVisiblity.setVisibility();
			testVisiblity.getProfileString();
			testVisiblity.getProfileIds();
			List<String> temp = new List<String>();
			temp.add('test');
			testVisiblity.setProfileIds(temp);
			
			testVisiblity.onClose();  */
   
  // }
   	
}