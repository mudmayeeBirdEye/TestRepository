public with sharing class ExceptionNotificationHistory {

  public boolean alldel{get;set;} 
  public ApexPages.StandardSetController con {get; set;} 
  
  
  
  
  
     
    public PageReference AllDeletecheck() {
        alldel = true;
        return null;
    }


    public PageReference test() {
        return null;
    }


    Set<ID> ids = new Set<ID>();
    
     public Set<id> getIds() {
        return ids;
    }

    public void setIds(set<id> ids) {
        this.ids = ids;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
     for(Exception_And_Notification_History__c e:enh)
        {options.add(new SelectOption(e.id,e.id));}
        

        return options;
    }


    public PageReference del() {
      if(alldel != true){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select All.'));
        return null;
      
      }
    if(recordTypename == null){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select RecordType.'));
        return null;
    }
    else{
        Exception_And_Notification_History__c[] delList =[SELECT id FROM Exception_And_Notification_History__c WHERE RecordType.Name =: recordTypename ORDER BY CreatedDate DESC];
        
        try{
        Database.delete(delList);
        }catch(Exception e){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
    
    
    }
  


   public PageReference  go() {
       if(recordTypename!= null)
         enh = [Select Name, RecordType.Name,  Object_Type__c,  isEmailSent__c, File_Associated__c From Exception_And_Notification_History__c WHERE RecordType.Name =: recordTypename ORDER BY CreatedDate DESC]; 
         con =new Apexpages.Standardsetcontroller(enh);
         con.setPageSize(10);
         enh.clear();
        for(Exception_And_Notification_History__c u : (List<Exception_And_Notification_History__c>)con.getRecords()) {
            enh.add(u);
        }
         
            return null;
    }

  // List<Exception_And_Notification_History__c> selectedeanh = new List<Exception_And_Notification_History__c>();
    
    public List<Exception_And_Notification_History__c> enh {get;set;}
   
    public String recordTypename {get;set;}

  public ExceptionNotificationHistory(){
    
     
    
    
      alldel = false;
    enh = new List<Exception_And_Notification_History__c>();
    //enh = [Select Name, RecordType.Name,  Object_Type__c,  isEmailSent__c From Exception_And_Notification_History__c ORDER BY CreatedDate DESC];
    
   con =new  Apexpages.Standardsetcontroller([Select Name, RecordType.Name,  Object_Type__c,  isEmailSent__c, File_Associated__c From Exception_And_Notification_History__c ORDER BY CreatedDate DESC LIMIT 1000]);
    con.setPageSize(10);
    
    for(Exception_And_Notification_History__c u : (List<Exception_And_Notification_History__c>)con.getRecords()) {
            enh.add(u);
        }
    
    }
   
    public List<selectOption> recordType {
        get {
            List<selectOption> options = new List<selectOption>();
            options.add(new SelectOption('Email Notification','Email Notification'));
            options.add(new SelectOption('Exception History','Exception History'));
            return options;
         }
        set;
    }
    
 
     public Boolean hasNext {
        get {
            if(con!=null){
                return con.getHasNext();
            }
            else return false;
        }
        set;
    }

      public Boolean hasPrevious {
        get {
            if(con!=null)
                return con.getHasPrevious(); 
            else return false;
        }
        set;
    }
 
    
       public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
    public void first() {
        con.first();
        enh.clear();
        for(Exception_And_Notification_History__c u : (List<Exception_And_Notification_History__c>)con.getRecords()) {
          enh.add(u);
        }
       
    }

   
    public void last() {
        con.last();
        enh.clear();
        for(Exception_And_Notification_History__c u : (List<Exception_And_Notification_History__c>)con.getRecords()) {
          enh.add(u);
        }
    }

    
    public void previous() {
        con.previous();
         enh.clear();
        for(Exception_And_Notification_History__c u : (List<Exception_And_Notification_History__c>)con.getRecords()) {
          enh.add(u);
        }
       
    }

   
    public void Next() {
        con.next();
         enh.clear();
        for(Exception_And_Notification_History__c u : (List<Exception_And_Notification_History__c>)con.getRecords()) {
          enh.add(u);
        }
      
    }
    
 
  /* public static testMethod void testExceptionNotificationHistory() {
     try {
        ExceptionNotificationHistory obj = new ExceptionNotificationHistory();
        obj.AllDeletecheck();
        obj.del();
        obj.first();
        obj.last();
        obj.test();
        obj.go();
        obj.Next();
        obj.previous();
        if(obj.hasPrevious){System.debug('true');}
        Set<id> s = obj.getIds();
        
        List<SelectOption> l = obj.getItems();
        } catch(Exception e){}
   }*/

   

}