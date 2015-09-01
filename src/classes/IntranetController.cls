public class IntranetController{
 /*public List<Intranet_Main_Tab__c> lstMainTab{get;set;}
 public List<Intranet_Main_Tab__c> lstChildTab{get;set;}
 public List<Intranet_Main_Tab__c> lstLeftMainTab{get;set;}
 public List<Intranet_Main_Tab__c> lstLeftChildTab{get;set;}
  
 public String strParentTabId{get;set;} 
 public String strContentPageName{get;set;} 
 public String strChildTabId{get;set;} 
  
 public Map<String,Intranet_Main_Tab__c> mapTab{get;set;}
 public Map<String,Intranet_Main_Tab__c> mapParentTab{get;set;}
 public  Map<Id, List<Intranet_Main_Tab__c>> leftMainToChildTabs{get;set;}
 public String defaultContent{get;set;}*/
 
 public IntranetController(){
     
    /* mapTab=new Map<String,Intranet_Main_Tab__c>();
     lstMainTab=new List<Intranet_Main_Tab__c>();
     lstLeftMainTab = new List<Intranet_Main_Tab__c>();

     leftMainToChildTabs= new Map<Id, List<Intranet_Main_Tab__c>>();
     
     Set<Id> leftParentIds = new Set<Id>();
     Id homeId = null;
    try {
     for(Intranet_Main_Tab__c objTab:[Select Tab_Image__c,Tab_Image_Id__c,Content__c, Site_Tab_Image__c, id,Name,IsMainTab__c,ParentID__c,Vf_Page_Url__c, Position_Type__c   from Intranet_Main_Tab__c where IsPublic__c=true AND IsDisabled__c=false 
                                       and IsMainTab__c='true' order by Tab_Order__c ASC]){
       if(objTab.Position_Type__c  == null || objTab.Position_Type__c =='Top' ) {
           lstMainTab.add(objTab);
       } else if(objTab.Position_Type__c  == 'Left') {
           lstLeftMainTab.add(objTab);
           leftParentIds.add(objTab.Id);
       }
       mapTab.put(objTab.id,objTab);
       if(homeId == null && objTab.Name == 'Home') {
            homeId = objTab.id;
       }
    }
    if(leftParentIds.size() != 0) {
       leftMainToChildTabs = getLeftChildTabs(leftParentIds);
    }
     String strParentId = Apexpages.currentpage().getParameters().get('parentId');
     if(!isBlank(strParentId)){
            if(mapTab.get(strParentId) == null) {
                strParentId = getParentId(strParentId);
            }
            setSubMenuBar(strParentId);
     } else {
        strParentTabId = lstMainTab.get(0).Id;
        setSubMenuBar(strParentTabId);
     }
     } catch(Exception e) {
     	// ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR -- ' + e.getStackTraceString()));
     }
     // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR -- ON LOGIn '));
     getUserDetails(); */
   }
   
 /*  public String getParentId(String childId) {
        try {
            return [SELECT ParentID__c FROM Intranet_Main_Tab__c WHERE Id=: childId].ParentID__c;
        } catch(Exception e) {}
        return null;
   }
   
   public Map<Id, List<Intranet_Main_Tab__c>> getLeftChildTabs(Set<Id> parentIds) {
        lstLeftChildTab = new List<Intranet_Main_Tab__c>();
        Map<Id, List<Intranet_Main_Tab__c>> mainToChildTabs = new Map<Id, List<Intranet_Main_Tab__c>>();
        for(Id idObj : parentIds){
            List<Intranet_Main_Tab__c> childTabs = new List<Intranet_Main_Tab__c>();
            mainToChildTabs.put(idObj, childTabs);
        }
        for(Intranet_Main_Tab__c objTab:[SELECT Tab_Image__c,Tab_Image_Id__c,Site_Tab_Image__c,id,Name,Position_Type__c, IsMainTab__c,ParentID__c,Vf_Page_Url__c FROM Intranet_Main_Tab__c WHERE IsPublic__c=true AND IsDisabled__c=false 
                                      AND ParentID__c IN:parentIds order by Tab_Order__c ASC]) {
             List<Intranet_Main_Tab__c> childTabs = new List<Intranet_Main_Tab__c>();
             if(mainToChildTabs.get(objTab.ParentID__c) != null) {
                 childTabs = mainToChildTabs.get(objTab.ParentID__c);
             }
            lstLeftChildTab.add(objTab);
             childTabs.add(objTab);
             mainToChildTabs.put(objTab.ParentID__c, childTabs);
             mapTab.put(objTab.id,objTab);
        }
        return mainToChildTabs;
   }  
   
   public void setSubMenuBar(String strId){
      lstChildTab=new List<Intranet_Main_Tab__c>();
      for(Intranet_Main_Tab__c objTab:[Select Tab_Image__c, Tab_Image_Id__c,Site_Tab_Image__c,id,Name,Position_Type__c, IsMainTab__c,ParentID__c,Vf_Page_Url__c from Intranet_Main_Tab__c where IsPublic__c=true and IsDisabled__c=false 
                                      and ParentID__c=:strId order by Tab_Order__c ASC]){
         if(mapTab != null && mapTab.get(objTab.ParentID__c)  != null && (mapTab.get(objTab.ParentID__c).Position_Type__c ==  'Top' || mapTab.get(objTab.ParentID__c).Position_Type__c == '' || mapTab.get(objTab.ParentID__c).Position_Type__c == null)) {
            lstChildTab.add(objTab);
         } 
         mapTab.put(objTab.id,objTab);
      }
   }
  public PageReference loadLeftSubMenu() {
    // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' == '+ strParentTabId));
    try {
        String strContentPageName= loadSelectedTabContent(lstLeftMainTab, lstLeftChildTab);//'/apex/'+mapTab.get(strChildTabId).Vf_Page_Url__c+'?id='+strChildTabId+'&parentId='+strParentTabId;
        if(strContentPageName == null) {
            strContentPageName = Site.getCurrentSiteUrl();
        } 
        Pagereference objPage=new Pagereference (strContentPageName); 
        objPage.getParameters().put('nooverride','0');
        objPage.setRedirect(true);
        return objPage;
    } catch(Exception e){
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+'===='+strParentTabId+'==Page===='+mapTab.get(strParentTabId).Vf_Page_Url__c));
    }
    return null;  
}
public String searchTxt {get;set;}
public PageReference searchText() {
        /*if(searchTxt == null || searchTxt == '')
            searchTxt = 'test';*/
       /* searchTxt = EncodingUtil.urlEncode(String.escapeSingleQuotes(searchTxt.trim()), 'UTF-8');
        String strContentPageName='/apex/DocSearch?srch='+searchTxt;
        Pagereference objPage=new Pagereference (strContentPageName); 
        objPage.getParameters().put('nooverride','0');
        objPage.setRedirect(true);
        return objPage;
}

  public pagereference loadSubMenu(){
    try{
         setSubMenuBar(strParentTabId);
            return loadSubMenuContent();
       }catch(Exception e){
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+'===='+strParentTabId+'==Page===='+mapTab.get(strParentTabId).Vf_Page_Url__c));
       }
       return null;     
   }
    public pagereference loadSubMenuContent(){
        
        String strContentPageName= loadSelectedTabContent(lstMainTab, lstChildTab);//'/apex/'+mapTab.get(strChildTabId).Vf_Page_Url__c+'?id='+strChildTabId+'&parentId='+strParentTabId;
        if(strContentPageName == null) {
            strContentPageName = Site.getCurrentSiteUrl();
        } 
        Pagereference objPage=new Pagereference (strContentPageName);
        objPage.getParameters().put('nooverride','0');
        objPage.setRedirect(true);
        return objPage ;
    }
    String getPageURL(String Id) {
        if(mapTab == null) 
            return null;
        if(mapTab.get(id) == null)
            return null;
        if(isBlank(mapTab.get(id).Vf_Page_Url__c)) {
            return null;
        }
        return mapTab.get(id).Vf_Page_Url__c;
    }
   /* private Map<Id,Id> tabDeletionStatus(String childId, String parentId) {
        List<Id> tabIds = new Id[]{childId, parentId};
        Map<Id,Id> tabStatus = new Map<Id,Id>();
        for(Intranet_Main_Tab__c tabObj : [SELECT Id,  (Select Id, Name From Intranet_Main_Tabs__r ORDER BY Tab_Order__c ASC) FROM Intranet_Main_Tab__c WHERE Id IN: tabIds]) {
            if(tabObj.Intranet_Main_Tabs__r != null && tabObj.Intranet_Main_Tabs__r.size() != 0) {
                tabStatus.put(tabObj.id, tabObj.Intranet_Main_Tabs__r.get(0).Id);
            } else {
                tabStatus.put(tabObj.id, tabObj.id);
            }
        }
        return tabStatus;
    }
    */
   /* private Id searchIdInList(List<Intranet_Main_Tab__c> childTabList, String childId) {
        for(Intranet_Main_Tab__c tabObj : childTabList) {
            if(tabObj.id == childId) {
                return childId;
            }
        }
        return childTabList.get(0).Id;
    }
    private Map<Id,Id> tabDeletionStatus(String childId, String parentId) {
        Map<Id,Id> tabStatus = new Map<Id,Id>();
        for(Intranet_Main_Tab__c tabObj : [SELECT Id,  (Select Id, ParentID__c, Name From Intranet_Main_Tabs__r WHERE IsPublic__c=true AND IsDisabled__c=false ORDER BY Tab_Order__c ASC) FROM Intranet_Main_Tab__c WHERE Id=: parentId AND IsPublic__c=true AND IsDisabled__c=false]) {
            if(tabObj.Intranet_Main_Tabs__r != null && tabObj.Intranet_Main_Tabs__r.size() != 0) {
                tabStatus.put(tabObj.id, searchIdInList(tabObj.Intranet_Main_Tabs__r, childId));
            } else {
                tabStatus.put(tabObj.id, tabObj.id);
            }
        }
        return tabStatus;
    }
    
    
    private String returnPageUrl(String childId, String parentId, String page) {
        Map<Id,Id> tabStatus = tabDeletionStatus(childId, parentId);
        if(!tabStatus.containsKey(parentId)) {
            return null;
        } 
        if(!tabStatus.containsKey(childId)) {
            childId = tabStatus.get(parentId);
        }
        /*strChildTabId = childId;
        strParentTabId = parentId;
        */
      //  return '/apex/'+page+'?id='+childId+'&parentId='+parentId;
   /* }
    public String loadSelectedTabContent(List<Intranet_Main_Tab__c> mainTabList, List<Intranet_Main_Tab__c> childTabList) {
        try {
        if(!isBlank(strParentTabId) && !isBlank(strChildTabId) ) {
            String page = getPageURL(strChildTabId);
            if(page != null) {
                return returnPageUrl(strChildTabId, strParentTabId, page);//'/apex/'+page+'?id='+strChildTabId+'&parentId='+strParentTabId;
            }
        }
        if(!isBlank(strParentTabId) && isBlank(strChildTabId) ) {
            if(childTabList != null && childTabList.size() != 0) {
                strChildTabId = childTabList.get(0).Id;
                String page = getPageURL(strChildTabId);
                if(page != null) {
                    return returnPageUrl(strChildTabId, strParentTabId, page);//'/apex/'+page+'?id='+strChildTabId+'&parentId='+strParentTabId;
                } 
            } else {
                String page = getPageURL(strParentTabId);
                if(page != null) {
                    return returnPageUrl(strParentTabId, strParentTabId, page);// '/apex/'+page+'?id='+strParentTabId+'&parentId='+strParentTabId;
                }
            }
        }
        if(isBlank(strParentTabId) && !isBlank(strChildTabId) ) {
            strParentTabId = mapTab.get(strChildTabId).ParentID__c;
            String page = getPageURL(strChildTabId);
            if(page != null) {
                return returnPageUrl(strChildTabId, strParentTabId, page);// '/apex/'+page+'?id='+strChildTabId+'&parentId='+strParentTabId;
            }
        }
        if(isBlank(strParentTabId) && isBlank(strChildTabId) ) {
            if(mainTabList != null && mainTabList.size() != 0) {
                strParentTabId = mainTabList.get(0).Id;
                if(childTabList != null && childTabList.size() != 0) {
                    strChildTabId = childTabList.get(0).Id;
                    String page = getPageURL(strChildTabId);
                    if(page != null) {
                        return returnPageUrl(strChildTabId, strParentTabId, page);// '/apex/'+page+'?id='+strChildTabId+'&parentId='+strParentTabId;
                    }
                } else {
                    String page = getPageURL(strParentTabId);
                    if(page != null) {
                        return returnPageUrl(strParentTabId, strParentTabId, page);// '/apex/'+page+'?id='+strParentTabId+'&parentId='+strParentTabId;
                    }
                }
            } 
            if(childTabList != null && childTabList.size() != 0) {
                strChildTabId = childTabList.get(0).Id;
                strParentTabId = mapTab.get(strChildTabId).ParentID__c; 
                String page = getPageURL(strChildTabId);
                if(page != null) {
                    return returnPageUrl(strChildTabId, strParentTabId, page);// '/apex/'+page+'?id='+strChildTabId+'&parentId='+strParentTabId;
                } 
            } 
        }
        } catch(Exception e){
        }
        return null;
    }
    public Boolean isBlank(String str) {
        return (str == null || str == '' ? true : false);
    }
    /*Login Logout*/
   /* private Boolean isLoginRequired;
    public String acc_token{get;set;}
    public Boolean getIsLoginRequired(){
        acc_token = Site.getDomain();
        if(ApexPages.currentPage().getCookies().get('ACCESS_TOKEN') == null 
            || ApexPages.currentPage().getCookies().get('ACCESS_TOKEN').getValue() == null 
            || ApexPages.currentPage().getCookies().get('ACCESS_TOKEN').getValue() == '') {
            return true;    
        } else {
            return false;   
        }
        return true;
    }
    public String cookiesValue{get;set;}    
    public Boolean loggedInStatus{get;set;}
    public PageReference onLogout(){
        // ApexPages.currentPage().getCookies().remove('token');
        Cookie counter = new Cookie('ACCESS_TOKEN',null,null,0,false);
        Cookie instanceVar = new Cookie('Instance_Variable',null,null,0,false);
        Cookie sid= new Cookie('sid',null,null,0,false);
        Cookie firstName = new Cookie('FIRST_NAME',null,null,0,false);
        Cookie lastName = new Cookie('LAST_NAME',null,null,0,false);
        Cookie photoURL = new Cookie('PHOTO_URL',null,null,0,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter,instanceVar,sid,firstName,lastName,photoURL});
        isLoginRequired = true;
        String strContentPageName='/logout';
        Pagereference objPage=new Pagereference (strContentPageName); 
        //objPage.getParameters().put('nooverride','0');
        objPage.setRedirect(true);
        return objPage;
    }   
    public Pagereference login() {
    	try {
        loggedInStatus = getIsLoginRequired();
        if(ApexPages.currentPage().getparameters().get('access_token')!=null 
        	&& ApexPages.currentPage().getparameters().get('access_token')!='' ){
            String strAccessToken=ApexPages.currentPage().getparameters().get('access_token');
            String strInstanceURL=ApexPages.currentPage().getparameters().get('instance_url');
            String userDetailsUrl=ApexPages.currentPage().getparameters().get('id');
            LoginTokenSetter.setLoginCredentials(strAccessToken,strInstanceURL,userDetailsUrl);
            String strContentPageName = loadSelectedTabContent(lstMainTab, lstChildTab);
            String url = (strContentPageName == null ? Site.getCurrentSiteUrl() : strContentPageName);
            PageReference objPage=new PageReference(url);
            objPage.setRedirect(true);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,' ACCESS TOKEN 1'));
            // return null;
            return objPage;
          }else if(getIsLoginRequired()){
            return (loginToSite());
          } else if(mapTab != null && mapTab.size() != 0 && ApexPages.currentPage().getUrl().indexOf('DocSearch') == -1 && ApexPages.currentPage().getparameters().get('id')==null && ApexPages.currentPage().getparameters().get('parentId')==null){
            String strContentPageName= loadSelectedTabContent(lstMainTab, lstChildTab);
            String url = (strContentPageName == null ? Site.getCurrentSiteUrl() : strContentPageName);
            PageReference objPage=new PageReference(url);
            objPage.setRedirect(true);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,' ACCESS TOKEN 2'));
            return objPage;
           // return objPage;
          }
    	} catch(Exception e) {
    		// ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR -- ' + e.getStackTraceString()));
    	}
        return null;
    }
    
    public Pagereference loginToSite() {
        //PageReference objPage=new PageReference('https://login.salesforce.com/services/oauth2/authorize?client_id=3MVG9CVKiXR7Ri5qqVutIcb42dc5rJTVnkhicV4Khg6qyrupLQK84E9RdFYA0OXEv._FRoBuf8GpEvdqsut5y&redirect_uri=https://ringcentral.secure.force.com/rcintranet/IntranetCookieSetting&display=popup&scope=full&response_type=token');
        //objPage.setRedirect(true);
        //return objPage;
        try {
	    	IntranetPortal__c intPortalCS = IntranetPortal__c.getValues('portalsite');
	    	if(intPortalCS != null && intPortalCS.token__c != null && intPortalCS.orgURL__c != null && intPortalCS.SiteURL__c != null) {
	    		String token = intPortalCS.token__c;
	    		string orgURL = intPortalCS.orgURL__c;
	    		string returnURL = 	intPortalCS.SiteURL__c;
	        	PageReference objPage=new PageReference(orgURL+token+returnURL);
	        	objPage.setRedirect(true);
	        	return objPage;
	    	}
    	} catch(Exception ex) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Set/Check your Intranet Portal Site Custom Settings'));
    	}
    	return null;
    }
    
    public string firstName {get;set;}
    public string lastName {get;set;}
    public string photoUrl {get;set;}
    
    public void getUserDetails() {
        try {
            firstName = lastName = '';
            photoUrl = 'profilephoto/005/F';
            LoginTokenSetter.UserDetailWrapper userDetailObj =  LoginTokenSetter.getUserDetailsCookie();
            firstName = userDetailObj.firstName;
            lastName = userDetailObj.lastName;
            //photoUrl = userDetailObj.photoUrl;
            photoUrl = userDetailObj.photoUrl.subString(userDetailObj.photoUrl.indexOf('.com')+5);
            photoUrl = photoUrl + '?oauth_token=' + ApexPages.currentPage().getCookies().get('ACCESS_TOKEN').getValue();
            System.Debug('>>>userDetailObj>>>'+userDetailObj);
            System.Debug('>>>userDetailObj1>>>'+firstName);
            System.Debug('>>>userDetailObj2>>>'+lastName);
            System.Debug('>>>userDetailObj3>>>'+photoUrl);
        } catch(Exception e) {}
    } */
   /*Test Methods*/
  // @isTest(SeeAllData=true)
   //static  void IntranetControllerTest0() {
       
      // IntranetController InCtrlTest0 = new IntranetController();
        
       /*List<Intranet_Main_Tab__c> intraList = new List<Intranet_Main_Tab__c>();
       
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
     Apexpages.currentpage().getParameters().put('parentId',intraList[0].id);  
     
     
     InCtrlTest0.loadLeftSubMenu(); 
     InCtrlTest0.searchTxt ='test';
     InCtrlTest0.searchText();
     InCtrlTest0.loadSubMenu();
     //InCtrlTest0.loadSubMenuContent();
     InCtrlTest0.searchIdInList(intraListChild, intraListChild[0].id);
     InCtrlTest0.getIsLoginRequired();
     InCtrlTest0.onLogout();
     
     InCtrlTest0.lstChildTab = intraListChild;
     InCtrlTest0.lstMainTab = intraList;
     
     InCtrlTest0.login();
     InCtrlTest0.loginToSite();
     
     InCtrlTest0.strChildTabId = intraListChild[0].id;
     InCtrlTest0.strParentTabId = intraList[0].id;
     
     InCtrlTest0.loadSelectedTabContent( intraList , intraListChild);
     
     InCtrlTest0.strChildTabId = '';
     InCtrlTest0.strParentTabId = intraList[0].id;
     
     InCtrlTest0.loadSelectedTabContent( intraList , intraListChild);
     
     InCtrlTest0.strChildTabId = intraListChild[0].id;
     InCtrlTest0.strParentTabId = '';
     
      InCtrlTest0.loadSelectedTabContent( intraList , intraListChild);
      
     Cookie tempCook = new Cookie('ACCESS_TOKEN', '123412312312',null,-1,false);
     ApexPages.currentPage().setCookies(new Cookie[]{tempCook});
    // ApexPages.currentPage().getCookies().getCookies().get('ACCESS_TOKEN');
     InCtrlTest0.getUserDetails(); */
     
     
   //}
   
  /* @isTest(SeeAllData=true)
   static  void IntranetControllerTest1() {
        Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
        intraTest.IsDisabled__c = false;
        intraTest.Name ='test';
        intraTest.IsPublic__c = true;
        intraTest.Position_Type__c ='Top';
        insert intraTest;
        
        Intranet_Main_Tab__c intraTestChild = new Intranet_Main_Tab__c();
        intraTestChild.IsDisabled__c = false;
        intraTestChild.Name ='test';
        intraTestChild.ParentID__c = intraTest.id;
        intraTestChild.IsPublic__c = true;
        intraTestChild.Position_Type__c ='Top';
        insert intraTestChild;
        
        Apexpages.currentpage().getParameters().put('parentId',intraTestChild.id);          
        IntranetController InCtrlTest0 = new IntranetController(); 
        
        Apexpages.currentpage().getParameters().put('parentId',null);
        IntranetController InCtrlTest1 = new IntranetController(); 
        String temp = InCtrlTest1.getParentId('oo'); 
        InCtrlTest1.login();
         
         ApexPages.currentPage().getparameters().put('access_token','12341243');
         ApexPages.currentPage().getparameters().put('instance_url','abc');
         ApexPages.currentPage().getparameters().put('id','123412412');
         
         InCtrlTest1.login();   
         
         
         
   } */
        
}