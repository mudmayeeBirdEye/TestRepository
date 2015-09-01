public with sharing class  IntranetTabCtrl {
//String IEE = Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');// For IE9 
   /* public  Intranet_Main_Tab__c tab{get;set;}
    public List<SelectOption> pageOption{get;set;}
    
    public Boolean isHtml{get;set;}
    public Boolean isPage{ get; set; }
    public Boolean isEditable{ get; set; }
    
    public String pageName{ get ; set; }
    
    Map<String, String > pageMap { get; set; }
    public String contentArea { get; set; } 
    
    public String selectdContentType{ get; set; }
    public String selectdPositionType{ get; set; }
    
    Map<Id,Intranet_Main_Tab__c>  allTabMap;*/
    
    public IntranetTabCtrl(ApexPages.StandardController controller) {
    
       /* allTabMap = new Map<Id,Intranet_Main_Tab__c>([select Id, Name, ParentID__r.Name ,Tab_Order__c,Content__c,ParentID__c, Position_Type__c, Vf_Page_Url__c,Tab_Visibilty_Setting__c,
                        (Select Id, Name, Tab_Order__c,Content__c,ParentID__c from Intranet_Main_Tabs__r) 
                        FROM Intranet_Main_Tab__c]);
        /*TODO Replace id with Production before moving*/
       /* String parent_lkid = ApexPages.currentPage().getParameters().get('CF00NV0000000VaEB_lkid');
   		
        isHtml = false;
        isPage = false;
        
        tab =  new Intranet_Main_Tab__c();
        tab.Position_Type__c ='Top';
        
        if( parent_lkid != null ) {
            tab.ParentID__c = allTabMap.get(Parent_lkid).id;
        }
        
        String recordId = ApexPages.currentPage().getParameters().get('id');
        
        isEditable = true;
        selectdContentType = 'Static';
        isHtml = true;
        
        if(recordId  != null && recordId  != '') {
          tab = [SELECT Id,Name, RecordTypeId, ParentID__r.Name,Content__c, ContentType__c, Tab_Image_Id__c, IsDisabled__c,
                    IsMainTab__c, IsPublic__c, ParentID__c, Tab_Order__c, Vf_Page_Url__c,Tab_Image__c , OwnerId , Position_Type__c ,Tab_Visibilty_Setting__c,
                     (Select Id, Name, Tab_Order__c,Content__c,ParentID__c from Intranet_Main_Tabs__r) 
                    FROM Intranet_Main_Tab__c WHERE Id=: recordId];
            contentArea = tab.Content__c; 
          if(tab.ContentType__c != null ) {
                selectdContentType = tab.ContentType__c;
          }
          if(tab.ContentType__c == 'Static') {
             isHtml = true;
             isPage = false;
           // selectdContentType = 'Static';
          } else {
            isHtml = false;
            isPage = true;
          }
           isEditable = IntranetTabHelper.chkUserEdit(tab); 
           pageName = tab.Vf_Page_Url__c;
        }
         pageMap = new Map<String, String>();
         
        for(ApexPage ap : [SELECT Id, Name  from ApexPage Where Name Like 'intranet%'] ) {
            pageMap.put( ap.Name, ap.Name );
        }
       //pageMap = new Map<id, ApexPage>([SELECT Id, Name  from ApexPage Where Name Like 'intranet%']);
       //tab.Vf_Page_Url__c = 'intranetStaticContent';*/
       
    }
    
  /* public static List<SelectOption> getPageOptions(LIST<ApexPage> apexPageList) {
      List<SelectOption> pageOption = new List<SelectOption>();                      
      for(ApexPage  pageObject : apexPageList) {
          pageOption.add(new SelectOption(pageObject.id ,pageObject.Name));  
       }   
      return pageOption; 
   }*/
    
  /*  public List<SelectOption> getPageOptions() {
        pageOption = IntranetTabHelper.getPageOptions(pageMap.values());
        return pageOption; 
    }   

    public PageReference contentType() {
      String temp = selectdContentType;
        if(temp == 'Static'){
            isHtml = true;
            isPage = false;
        }
        if(temp == 'Page' ){
            isPage = true;
            isHtml = false;
        }
        return null;
    }
    
   /***** Save Action ******************************/
   
  /* public PageReference onSave() {
       if(pageName != null) {
           tab.Vf_Page_Url__c = pageMap.get(pageName);
       }
       if(selectdContentType == 'Static') {
          tab.Vf_Page_Url__c = 'intranetStaticContent'; 
       }
       if(selectdContentType == 'Page'){
           tab.Content__c = null;
       }
       String strErrorMessage = NULL;
       strErrorMessage = IntranetTabHelper.validationSave( tab , allTabMap );
       if(strErrorMessage != NULL) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,strErrorMessage));
           return Apexpages.currentPage();
       }
       
       try {
           if(selectdContentType != null) {
              tab.ContentType__c = selectdContentType;
           }
           upsert tab;
      } catch (Exception ex) {
           
           if(ex.getMessage().contains('INSUFFICIENT_ACCESS_OR_READONLY')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You are not authorized for updating this record.' ));
            return Apexpages.currentPage();
           } else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage() ));
            return Apexpages.currentPage();
           }
           
       }   
       ApexPages.StandardController controller = new  ApexPages.StandardController(tab);
       return controller.view(); 
    }

    /******* Order Tab ********************/
   
    /* public void getTabOrder(){

        Id loginUser = UserInfo.getProfileId();
        Integer order = 0;
        try {
            List<Intranet_Main_Tab__c> tabList = [SELECT Id, Name, Tab_Order__c FROM Intranet_Main_Tab__c WHERE Owner.ProfileId =: loginUser ORDER BY Tab_Order__c ASC];
            if(tabList != null && tabList.size() != 0) {
                Intranet_Main_Tab__c lastObj = tabList.get(tabList.size()-1);
                order = (lastObj.Tab_Order__c == null ? 0: Integer.valueOf(''+lastObj.Tab_Order__c)); 
            }
        } catch(Exception e) {
            
        }
        tab.Tab_Order__c = ++order;
   } */

  /**************set Content type radio**************/

 /* public List<SelectOption> getContentTypeOption(){
        List<SelectOption> contentTypeOption = IntranetTabHelper.getContentTypeOption();
        return contentTypeOption; 
  }
  
   public List<SelectOption> getPositionTypeOption(){
        List<SelectOption> positionTypeOption = IntranetTabHelper.getPositionTypeOption();
        return positionTypeOption; 
   }
    
    public PageReference cancel() {
        PageReference  pageRef = IntranetTabHelper.cancel();
        return pageRef;
    }
    
    public PageReference setTabOrder() {
        PageReference setTabOrderPageRef = IntranetTabHelper.setTabOrder(tab);
        setTabOrderPageRef.setRedirect(true);
        return setTabOrderPageRef;
    }
    
    public PageReference setTabImage() {
        PageReference setTabOrderPageRef = IntranetTabHelper.setTabImage(tab);
        setTabOrderPageRef.setRedirect(true);
        return setTabOrderPageRef;
    }
    
    public PageReference onEdit() {
        PageReference editPageRef = IntranetTabHelper.onEdit(tab);
        editPageRef.setRedirect(true);
        return editPageRef;
    }
    public PageReference clearContent() {
        if(tab.id != null){
            tab.Content__c = null;
            update tab;
        }else{
            tab.Content__c = null; 
        }
        return null;
    }*/
    
  /* @isTest(SeeAllData=true)
   static  void IntranetTabCtrlTest() {
   			 //Select r.SobjectType, r.Name, r.Id From RecordType r Where  r.SobjectType ='Intranet_Main_Tab__c'
   			Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
		    intraTest.IsDisabled__c = false;
		    intraTest.Name ='Home';
		    intraTest.IsPublic__c = true;
		    intraTest.Position_Type__c ='Top';
		    intraTest.Content__c = '';
		    insert intraTest;
	  
	  		ApexPages.StandardController sc = new ApexPages.StandardController(intraTest);
   			 
   			 IntranetTabCtrl inTabCtrlTest = new IntranetTabCtrl(sc);
   			/* Map<String,String> recordTypeMap = new Map<String, String>();
   			 for(RecordType r : [Select SobjectType, Name, Id From RecordType  Where  SobjectType ='Intranet_Main_Tab__c' ] ){
   			 	recordTypeMap.put(r.Name, r.id);
   			 }
   			 
   			  List<Intranet_Main_Tab__c> intraList = new List<Intranet_Main_Tab__c>();
			   
			   for(Integer i=0; i<10; i++) {
			  	  Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
			  	  intraTest.IsDisabled__c = false;
			  	  intraTest.Name ='test';
			  	  intraTest.IsPublic__c = true;
			   	  intraTest.Position_Type__c ='Top';
			   	  intraTest.RecordTypeId = recordTypeMap.get('Admin');
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
				   	  intraTestChild.RecordTypeId = recordTypeMap.get('Others');
				   	  intraTestChild.Content__c ='test';
			   	  	  intraTestChild.ContentType__c ='Page';
				   	  intraListChild.add(intraTestChild);
		      }
		      insert intraListChild;  
		ApexPages.currentPage().getParameters().put('CF00NV0000000ZUEJ_lkid',intraList[0].id);  
		ApexPages.currentPage().getParameters().put('id',intraList[0].id);  
		IntranetTabCtrl inTabCtrlTest = new IntranetTabCtrl(null);
		inTabCtrlTest.getPageOptions();
		inTabCtrlTest.getContentTypeOption();
		inTabCtrlTest.getPositionTypeOption();
		inTabCtrlTest.cancel();
		inTabCtrlTest.setTabOrder();
		inTabCtrlTest.setTabImage();
		inTabCtrlTest.onEdit();
		inTabCtrlTest.clearContent();
		
		inTabCtrlTest.selectdContentType = 'Static';
		inTabCtrlTest.contentType();
		
		inTabCtrlTest.selectdContentType = 'Page';
		inTabCtrlTest.contentType();
		
		inTabCtrlTest.onSave();
		
		inTabCtrlTest.selectdContentType = 'Static';
		inTabCtrlTest.onSave();
		
		Profile p = [SELECT Id FROM Profile WHERE Name='Read Only']; 
      	User u = new User(Alias = 'alias', Email='email@testorg.com', 
      	EmailEncodingKey='UTF-8', LastName='aslias', LanguageLocaleKey='en_US', 
      	LocaleSidKey='en_US', ProfileId = p.Id, 
      	TimeZoneSidKey='America/Los_Angeles', UserName='alias@testorg.com');


       System.runAs(u) {
      	inTabCtrlTest.onSave();
       }
		
		inTabCtrlTest.tab = null;
		//inTabCtrlTest.clearContent();
		ApexPages.currentPage().getParameters().put('id',intraListChild[0].id);  
		IntranetTabCtrl inTabCtrlTest0 = new IntranetTabCtrl(null);*/
	      	  
   //}
   
   /* @isTest(SeeAllData=true)
   static  void IntranetTabCtrlTest0() {
   		
   		Profile p = [SELECT Id FROM Profile WHERE Name='Read Only']; 
      	User u = new User(Alias = 'test0', Email='test0@testorg.com', 
      	EmailEncodingKey='UTF-8', LastName='test0', LanguageLocaleKey='en_US', 
      	LocaleSidKey='en_US', ProfileId = p.Id, 
      	TimeZoneSidKey='America/Los_Angeles', UserName='test0@testorg.com');


       System.runAs(u) {
      	IntranetTabCtrl inTabCtrlTest0 = new IntranetTabCtrl(null);
      	inTabCtrlTest0.onSave();
       }
   }*/
}