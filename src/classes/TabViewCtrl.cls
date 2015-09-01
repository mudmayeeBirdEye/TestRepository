public with sharing class TabViewCtrl {
   
   // private Intranet_Main_Tab__c tab ;
   // private Boolean relatedListView;
    
    public TabViewCtrl(ApexPages.StandardController controller) {
      //  tab = (Intranet_Main_Tab__c)controller.getRecord();
    }
    
  /*  public Boolean getRelatedListView(){
        tab = [Select 
                IsMainTab__c     
              From 
                Intranet_Main_Tab__c
              Where
                id=:tab.id];
       
       if(tab != null && tab.IsMainTab__c  == 'true'){ 
           return true;
       }             
    return false;            
    } */
/*Test*/
        /*@isTest(SeeAllData=true)
   static  void TabViewCtrlTest() {
        
                                  Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
                                  intraTest.IsDisabled__c = false;
                                  intraTest.Name ='test';
                                  intraTest.IsPublic__c = true;
                                  intraTest.Position_Type__c ='Top';
                                  intraTest.Content__c ='test';
                                  intraTest.ContentType__c ='Static';
                                  insert intraTest;
                                  
                                /*  Intranet_Main_Tab__c intraTest0 = new Intranet_Main_Tab__c();
                                  intraTest0.IsDisabled__c = false;
                                  intraTest0.Name ='test';
                                  intraTest0.IsPublic__c = true;
                                  intraTest0.Position_Type__c ='Top';
                                  intraTest0.Content__c ='test';
                                  intraTest0.ContentType__c ='Static';
                                  intraTest0.ParentID__c = intraTest.id;
                                  insert intraTest0; */
                                 
                                 //ApexPages.StandardController  sc = new  ApexPages.StandardController(intraTest);
                                 //TabViewCtrl tvc = new TabViewCtrl(sc);
                                // tvc.getRelatedListView();
                                 
                               //  ApexPages.StandardController  sc0 = new  ApexPages.StandardController(intraTest0);
                               //  TabViewCtrl tvc0 = new TabViewCtrl(sc0);
                               //  tvc0.getRelatedListView();
                                 
                                 
                                  
   
   //}
}