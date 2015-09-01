/*************************************************
accountsummary class
This Class is used by accountsummary.page which is used with a public site shown in a tab in RightNow.
The page/class takes RC User Id from URL and displays a table of account details and lists related notes and activities.
It is very similar to accountnotes.cls
/************************************************/

public with sharing class accountsummary{

    public String case1 { get; set; }

    public String getCase() {
        return null;
    }

    public String caselist { get; set; }
    public String Account { get; set; }

    public Account acct {get; set;}
    public List<cNote> noteList {get; set;}
    public List<cEvent> eventList {get; set;}
    public List<cTask> taskList {get; set;}
    public List<cContract> contractList {get; set;}
    //Code By India Team 07/30/2010 starts  
    public List<cCase> caseList1 {get; set;}
    //Code By India Team 07/30/2010 ends  
    public Boolean userIdFound = false;
    
    /* Constructor */
    public accountsummary() {
        noteList = new List<cNote>();
        eventList = new List<cEvent>();
        taskList = new List<cTask>();
        contractList = new List<cContract>(); 
        //Code By India Team 07/30/2010 starts  
        caseList1 = new List<cCase>();       
        //Code By India Team 07/30/2010 starts
        /*
        Using RC User Id find all notes, events, tasks contracts, and cases related to account
        */   
        try{
                acct = [SELECT id,name,RC_Account_Number__c,RC_User_ID__c,RC_Account_Status__c,RC_Service_name__c,RC_Brand__c,RC_Tier__c,Current_Owner_Name__c,RC_Signup_Date__c,RC_Activation_Date__c,RC_Upgrade_Date__c,RC_Cancel_Date__c,RC_Churn_Date__c,RC_Attribution_Channel__c,RC_Attribution_L2__c,RC_Attribution_L3__c,RC_Attribution_Campaign__c FROM Account WHERE RC_User_ID__c=:ApexPages.currentPage().getParameters().get('userid')];
                userIdFound = true;
                Id rcId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');
                for(Note n : [SELECT id, title, body, lastmodifieddate, createdbyid FROM Note WHERE parentId =: acct.Id]){                    
                    noteList.add(new cNote(n,n.title,n.body,n.lastmodifieddate.format(),[SELECT id, name FROM User WHERE id =: n.createdById].name));
                }
                for(Opportunity o : [SELECT id FROM Opportunity WHERE accountId =: acct.Id  AND (RecordTypeId =: rcId OR RecordTypeId = NULL)]){
                        for(Note n : [SELECT id, title, body, lastmodifieddate, createdbyid FROM Note WHERE parentId =: o.Id]){
                        	noteList.add(new cNote(n,n.title,n.body,n.lastmodifieddate.format(),[SELECT id, name FROM User WHERE id =: n.createdById].name));
                        }               
                }
                for(Contact c : [SELECT id FROM Contact WHERE accountId =: acct.Id]){
                        for(Note n : [SELECT id, title, body, lastmodifieddate, createdbyid FROM Note WHERE parentId =: c.Id]){
							noteList.add(new cNote(n,n.title,n.body,n.lastmodifieddate.format(),[SELECT id, name FROM User WHERE id =: n.createdById].name));
                        }               
                }
                /*
                Implementations are custom objects with their own notes and events so we need to look for records tie to them.
                */                
                for(Implementation__c imp : [SELECT id FROM Implementation__c WHERE account__c=: acct.Id]){
                        for(Note n : [SELECT id, title, body, lastmodifieddate, createdbyid FROM Note WHERE parentId =: imp.Id]){
                            noteList.add(new cNote(n,n.title,n.body,n.lastmodifieddate.format(),[SELECT id, name FROM User WHERE id =: n.createdById].name));
                        }
                        for(Event e : [SELECT id, subject, description, activitydate, createdbyid FROM Event WHERE whatId =: imp.Id]){                    
                            eventList.add(new cEvent(e,e.subject,e.description,e.activitydate,[SELECT id, name FROM User WHERE id =: e.createdById].name));
                        }               
                }
                for(Event e : [SELECT id, subject, description, activitydate, createdbyid FROM Event WHERE accountId =: acct.Id]){                    
                    eventList.add(new cEvent(e,e.subject,e.description,e.activitydate,[SELECT id, name FROM User WHERE id =: e.createdById].name));
                }
                for(Task t : [SELECT id, subject, description, activitydate, createdbyid, status FROM Task WHERE accountId =: acct.Id]){                    
                   taskList.add(new cTask(t,t.subject,t.description,t.activitydate,[SELECT id, name FROM User WHERE id =: t.createdById].name,t.status));
                }
                for(Contract contract : [SELECT id, ContractTerm, StartDate, EndDate, createdbyid, Status, Total_Number_Of_Lines__c FROM Contract WHERE accountId =: acct.Id]){                  
                    contractList.add(new cContract(contract,String.valueOf(contract.ContractTerm),contract.StartDate,contract.EndDate,[SELECT id, name FROM User WHERE id =: contract.createdById].name,contract.Status, String.valueOf(contract.Total_Number_Of_Lines__c)));

                }
                //Code By India Team 07/30/2010 starts  
                for(Case case1 : [SELECT id,CaseNumber,Contactid,Subject,Priority,CreatedDate,Status FROM Case WHERE accountId =: acct.Id]){                  
                    caseList1.add(new cCase(case1,case1.CaseNumber,[SELECT id, name FROM Contact WHERE id =: case1.Contactid].name,case1.Subject,case1.Priority,case1.CreatedDate,case1.Status));
                }                               
                //Code By India Team 07/30/2010 ends  
        }
        catch (System.QueryException e){
                userIdFound = false;
        }
    }
    
    public Boolean getAccountFound(){
        return userIdFound;
    }
    
    public Boolean getAccountNotFound(){
        return !userIdFound;
    }
    
    public String getAccountID(){
        return acct.Id;
    }

    public String getAccountName(){
        return acct.Name;
    }
    
    public Note getSelectedNote(){
        Id id = System.currentPageReference().getParameters().get('noteId');
        
        return id == null ? new Note() : [SELECT Id, title FROM Note WHERE Id = :id];
    }

    public Event getSelectedEvent(){
        Id id = System.currentPageReference().getParameters().get('eventId');
        
        return id == null ? new Event() : [SELECT Id, subject FROM Event WHERE Id = :id];
    }
    
    public Task getSelectedTask(){
        Id id = System.currentPageReference().getParameters().get('taskId');
        
        return id == null ? new Task() : [SELECT Id, subject FROM Task WHERE Id = :id];
    }
    
    public Contract getSelectedContract(){
        Id id = System.currentPageReference().getParameters().get('contractId');
        
        return id == null ? new Contract() : [SELECT Id, status FROM Contract WHERE Id = :id];
    }     
    
    
    // by india team start
    
    public Case getSelectedCase(){
        Id id = System.currentPageReference().getParameters().get('caseId');
        
        return id == null ? new Case() : [SELECT Id, caseNumber FROM Case WHERE Id = :id];
    }           
    
    // by india team end
    
    /*
    The following classes (cNote, cEvent, cTask, cContract, cCase) are container classes.
    They allow us to group together the actual objects with some descriptive fields.
    With these we can provide a link to the actual object and show columns like title or subject. 
    */
    public class cNote {
            public Note note {get; set;}  
            public String title {get; set;}
            public String body {get; set;}
            public String modifiedDate {get; set;}
            public String createdBy {get; set;}            
        
        /* Constructor */
        public cNote(Note note, String title, String body, String modified,String creator){
            this.note = note;
            this.title = title;
            this.body = body;
            this.modifiedDate = modified;
            this.createdBy = creator;
        }
    }
    
    public class cEvent{
            public Event event {get; set;}  
            public String subject {get; set;}
            public String description {get; set;}
            public Date activityDate {get; set;}
            public String createdBy {get; set;}            
        
        
        public cEvent(Event event, String subject, String description, Date activityDate,String creator){
            this.event = event;
            this.subject= subject;
            this.description= description;
            this.activityDate= activityDate;
            this.createdBy = creator;
        }
    }
    
    public class cTask{
            public Task task {get; set;}  
            public String subject {get; set;}
            public String description {get; set;}
            public Date activityDate {get; set;}
            public String createdBy {get; set;}            
            public String Status {get; set;}            
        
        
        public cTask(Task task, String subject, String description, Date activityDate,String creator,String status){
            this.task = task;
            this.subject= subject;
            this.description= description;
            this.activityDate= activityDate;
            this.createdBy = creator;
            this.status = status;
        }
    }
    
    public class cContract{
            public Contract contract {get; set;}  
            public String term {get; set;}
            public String startDate {get; set;}
            public String endDate {get; set;}
            public String createdBy {get; set;}            
            public String Status {get; set;}
            public String nOfLines {get; set;}              
        
        
        public cContract(Contract contract, String term, Date startDate, Date endDate,String creator,String status, String lines){
            this.contract = contract;
            this.term= term;
            if(startDate != null){
                this.startDate= startDate.format();     
            }
            else{
                this.startDate = '';
            }
            if(endDate != null){
                this.endDate= endDate.format(); 
            }
            else{
                this.endDate = '';
            }            
            this.createdBy = creator;
            this.status = status;
            this.nOfLines = lines;
        }
    } 
    
    //Code By India Team 07/30/2010 starts   

 public class cCase {
            public Case casedata {get; set;}  
            public String title {get; set;}
            public String caseNumber {get; set;}
            public String contactName {get; set;}
            public String subject {get; set;}   
            public String priority {get; set;}        
            public Datetime dtCreateDate {get; set;}     
            public String status {get; set;}         
        
        /* Constructor */
        public cCase (Case casedata, String caseNumber, String contactName, String subject,String priority,Datetime dtCreateDate, String status){
            this.casedata = casedata;
            this.caseNumber= caseNumber;
            this.contactName= contactName;
            this.subject= subject;
           this.priority= priority;
            this.dtCreateDate= dtCreateDate;
            this.status= status;
        }
    }



    //Code By India Team 07/30/2010 ends
    
       /* static testMethod void testaccountsummary(){
        Account a = new Account();
        a.Name = 'TestbyJesse';
        a.RC_User_ID__c = '345';
        insert a;
        
        Contact c = new Contact();
        c.LastName = 'contactLast';
        c.AccountId = [SELECT id FROM Account WHERE name=: a.Name].id;
        c.email='test@rc.com';
        try{
        	insert c;	
        }catch(Exception exp){
        	
        }
        
        Opportunity o = new Opportunity();
        o.Name = 'TestaOpp';
        o.AccountId = c.AccountId;
        o.Type = 'New Business';
        o.CloseDate = Date.today();
        o.StageName = OpportunityHelper.defaultOpportunityStage;
        o.OwnerId = '005800000036sJJ';
        o.RC_User_ID__c = '345';
        o.Date_Submitted__c = Datetime.now();
        insert o;
        
        Implementation__c imp = new Implementation__c();
        imp.Name = 'testImp';
        imp.Account__c = a.Id;
        imp.Implementation_Status__c = 'Contacted';
        insert imp;
        
        Contract contract = new Contract();
        contract.AccountId = a.Id;
        insert contract;

        Note n1 = new Note();
        n1.Title = 'n1';
        n1.Body = 'n1';
        n1.ParentId = a.Id;
        insert n1;

        Note n2 = new Note();
        n2.Title = 'n2';
        n2.Body = 'n2';
        n2.ParentId = o.Id;
        insert n2;      
                
        Note n3 = new Note();
        n3.Title = 'n3';
        n3.Body = 'n3';
        try{
            n3.ParentId = c.Id;
            insert n3;	                	
        }catch(Exception exp){
        	
        }
                	                
        Note n4 = new Note();
        n4.Title = 'n4';
        n4.Body = 'n4';
        n4.ParentId = imp.Id;
        insert n4;      
                
        Event event1 = new Event(subject='testEvent1', whatId = imp.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
        insert event1;

        Event event2 = new Event(subject='testEvent2', whatId = a.Id, StartDateTime = DateTime.now(), DurationInMinutes = 10);
        insert event2;
        
        Task t1 = new Task(subject='testTask1', whatId = imp.Id, ActivityDate = Date.Today());        
        insert t1;                      
        
        Task t2 = new Task(subject='testTask2', whatId = a.Id, ActivityDate = Date.Today());
        insert t2;
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('userid', a.RC_User_ID__c);
        
        accountsummary an = new accountsummary();
        String aId = an.getAccountID();
        String aName = an.getAccountName();
        Boolean acctFound = an.getAccountFound();
        Boolean acctNotFound = an.getAccountNotFound();
            
        ApexPages.currentPage().getParameters().put('noteId', n1.Id);
        Note getNote = an.getSelectedNote();
        
        ApexPages.currentPage().getParameters().put('eventId', event1.Id);
        Event getEvent = an.getSelectedEvent();
        
        ApexPages.currentPage().getParameters().put('taskId', t1.Id);
        Task getTask = an.getSelectedTask();
        
        ApexPages.currentPage().getParameters().put('contractId', contract.Id);
        Contract getContract = an.getSelectedContract();  
             
        ApexPages.currentPage().getParameters().put('userid', '111');        
        an = new accountsummary(); 
        Test.stopTest();              
    } */
            
}