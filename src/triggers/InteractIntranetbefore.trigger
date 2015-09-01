trigger InteractIntranetbefore on Intranet_Main_Tab__c (before insert, before update, after Update, before delete) {
    Map<Id,Intranet_Main_Tab__c>  tabMap = new Map<Id,Intranet_Main_Tab__c>([select Id, Name, Tab_Order__c,Content__c,
                            ParentID__c,Position_Type__c,
                            (select Id, Name, Tab_Order__c,Content__c,ParentID__c from Intranet_Main_Tabs__r) FROM Intranet_Main_Tab__c]);
    
    //System.Debug('>>>1234');
    
    Folder objDocument=[Select id from Folder where name='Intranet Tab Images'];
    
    if(trigger.IsBefore && (trigger.isInsert || trigger.isUpdate)) {
        if(objDocument != null) {
            Document  docObj = [SELECT Id FROM Document WHERE folderId=:objDocument.Id AND Name='Default'];
            for(Intranet_Main_Tab__c obj : trigger.new) {
                if(docObj.Id != null && obj.Tab_Image_Id__c == null){
                    obj.Tab_Image_Id__c = docObj.Id;
                    // obj.addError('#### => '+ docObj.Id);
                }
            }
        }
    }
    
    if(trigger.IsBefore && trigger.isInsert) {
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
        for(Intranet_Main_Tab__c tabObj : trigger.new) {
            tabObj.Tab_Order__c = ++order;
            
            if(tabObj.ContentType__c == 'Static') {
                 //trigger.NewMap.get(tabObj.Id).Vf_Page_Url__c = 'intranetStaticContent';
                 tabObj.Vf_Page_Url__c = 'intranetStaticContent';
            }
            if( tabObj.ParentID__c != NULL ){ // set Default Potion to Child Tab
                tabObj.Position_Type__c  =  tabMap.get( tabObj.ParentID__c ).Position_Type__c;
            }
        }
        
        // For Validations-----------------------------------------------------------------------------------------
        
        for(Intranet_Main_Tab__c tabObj : trigger.new) {
           /* if(tabObj.ParentID__c != null && tabMap != null) {
                Intranet_Main_Tab__c tabParentObj = tabMap.get(tabObj.ParentID__c);
                if(tabParentObj.Content__c != null && tabParentObj.Content__c.trim().length() != 0) {
                    tabObj.addError('Selected Parent Tab contains static contents. Please delete the content of parent tab before creating its child.');    
                }                    
            } */
           /* if(tabObj.ParentID__c == NULL && UserInfo.getProfileId() == '00e80000000l1hK') {
                 tabObj.addError('You are not allowed to create or update the Main Menu Tab.');    
            } */
        } 
    }
    else if(trigger.IsBefore && Trigger.isUpdate) {
       
       for(Intranet_Main_Tab__c tabObj : trigger.new) {
           Intranet_Main_Tab__c tabObjOld = Trigger.oldMap.get(tabObj.id);
           if(tabObj.ContentType__c == 'Static') {
                 tabObj.Vf_Page_Url__c = 'intranetStaticContent';
           }
           if( tabObj.ParentID__c != null && tabObjOld.ParentID__c != tabObj.ParentID__c ) {
                tabObj.Position_Type__c = tabMap.get(tabObj.ParentID__c).Position_Type__c;
           }
          
          
       
           
         /*  List<Intranet_Main_Tab__c> childTabList = tabMap.get(tabObj.Id).Intranet_Main_Tabs__r; 
           if(childTabList !=null && childTabList.size()>0 && tabObj.Content__c != NULL && tabObj.Content__c.trim().length() != 0) {
               trigger.newmap.get(tabObj.Id).addError('Parent Tab must not contains static contents.');         
           }
           if(tabObj.ParentID__c != null && tabMap != null) {
                Intranet_Main_Tab__c tabParentObj = tabMap.get(tabObj.ParentID__c);
                if(tabParentObj.Content__c != null && tabParentObj.Content__c.trim().length() != 0) {
                    tabObj.addError('Selected Parent Tab contains static contents. Please delete the content of parent tab before creating its child.');    
                }                    
            }  */  
       }        
    } else if(trigger.IsBefore && Trigger.isDelete) { // we have to move this to Helper class
       Set<ID> imgIds = new Set<id>();
       
        for(Intranet_Main_Tab__c tabObj : trigger.old) {
            if(tabObj.ParentID__c == NULL) {
                 List<Intranet_Main_Tab__c> childTabList = tabmap.get(tabObj.Id).Intranet_Main_Tabs__r;
                 if(childTabList != NULL && childTabList.size() > 0) {
                     tabObj.addError('<font color="red">This Tab cannot be deleted as it contains child menus.</font>');
                 } 
                 imgIds.add(tabObj.Tab_Image_Id__c);
            }
        } 
        List<Document> imgList =  new List<Document>([Select Id FROM Document WHERE folderId=:objDocument.Id AND Name !='Default' AND Id IN : imgIds]);   
        delete imgList;
    }
    
    
    /* 
    if(Trigger.isAfter && Trigger.isUpdate ){
        List<Intranet_Main_Tab__c> subTabList = new  List<Intranet_Main_Tab__c>();
        Set<ID> mainTabIds = new Set<ID>();
        Map<id,String> positionMap = new Map<id ,String>();
        
        String tabChangedValue;
          for( Intranet_Main_Tab__c tabObj : trigger.new ) {
               Intranet_Main_Tab__c tabObjOld = Trigger.oldMap.get( tabObj.id );
               
              if( tabObjOld.Position_Type__c != tabObj.Position_Type__c ) {
                   mainTabIds.add(tabObj.id);
                   positionMap.put( tabObj.id , tabObj.Position_Type__c );
               }
              
               
               
           }  
          subTabList  = [Select Position_Type__c , ParentID__c from Intranet_Main_Tab__c Where ParentID__c IN : mainTabIds ];
          
          for( Intranet_Main_Tab__c subTabObj : subTabList  ){
              subTabObj.Position_Type__c = positionMap.get( subTabObj.ParentID__c );
          }
            update subTabList; 
      }*/
}