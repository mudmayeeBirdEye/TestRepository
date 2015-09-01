public  class MultiSheetExcelGenerate {
    public DataModel dm {get;set;}
       
   //TerritoryChangeController controller
 
     public String obj {get;set;}
   	 public Id userid;
   	 public String objType;	
   	 public String name;
       
    public MultiSheetExcelGenerate(){
       userid = Apexpages.currentPage().getParameters().get('userid');
       objType = Apexpages.currentPage().getParameters().get('objtype');
       name = Apexpages.currentPage().getParameters().get('username');
       obj = objtype;
        
        dm = new DataModel();
        dm.data = new list<DataModel.Model>();
        /**
        Fetching Accout data
        */
   System.debug('--------------------------------------------ExcelClass-----------------'+userid);     
   System.debug('--------------------------------------------ExcelClass-----------------'+objType); 
   System.debug('--------------------------------------------ExcelClass-----------------'+obj); 
   //CURRENT_OWNER__C   CURRENT_OWNER_EMAIL__C  CURRENT_OWNER_NAME__C
   
    if(objType == 'Account'){
    DataModel.Model model = new DataModel.Model();
        model.sheetname = 'Account';
        model.headers = new list<string>{'Id','OwnerId','Current_Owner__c','CURRENT_OWNER_EMAIL__C','CURRENT_OWNER_NAME__C'};
        model.data = new list<map<string,string>>();
        for(Account act: [SELECT Id, OwnerId,Current_Owner__c,Current_Owner_Email__c ,CURRENT_OWNER_NAME__C  from Account Where Current_Owner__c =:userid LIMIT 10000]){
            map<string,string> rowdata = new map<string,string>();
             rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
            rowdata.put('Current_Owner__c',act.Current_Owner__c);
            rowdata.put('CURRENT_OWNER_EMAIL__C',(act.CURRENT_OWNER_EMAIL__C == null ? '':act.CURRENT_OWNER_EMAIL__C));
            rowdata.put('CURRENT_OWNER_NAME__C',(act.CURRENT_OWNER_NAME__C == null ? '':act.CURRENT_OWNER_NAME__C)); 
            model.data.add(rowdata);
        }
        dm.data.add(model);
    } 
     if(objType == 'Lead'){
    DataModel.Model model = new DataModel.Model();
        model.sheetname = 'Lead';
       model.headers = new list<string>{'Id','OwnerId','OWNER_MANAGER_EMAIL__C','OWNER_MANAGER_NAME__C'};
        model.data = new list<map<string,string>>();
        for(Lead act: [SELECT Id, OwnerId,OWNER_MANAGER_EMAIL__C,OWNER_MANAGER_NAME__C   from Lead Where Ownerid =:userid And isConverted=false LIMIT 10000]){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
            rowdata.put('OWNER_MANAGER_EMAIL__C',(act.OWNER_MANAGER_EMAIL__C == null ? '':act.OWNER_MANAGER_EMAIL__C));
            rowdata.put('OWNER_MANAGER_NAME__C',(act.OWNER_MANAGER_NAME__C == null ? '':act.OWNER_MANAGER_NAME__C)); 
            model.data.add(rowdata);
        }
        dm.data.add(model);
    } 
    
    if(objType == 'Case'){
    DataModel.Model model = new DataModel.Model();
        model.sheetname = 'Case';
       model.headers = new list<string>{'Id','OwnerId'};
        model.data = new list<map<string,string>>();
        for(Case act: [SELECT Id, OwnerId  from Case Where Ownerid =:userid LIMIT 10000]){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
            model.data.add(rowdata);
        }
        dm.data.add(model);
    } 
    
    if(objType == 'Contact'){
    DataModel.Model model = new DataModel.Model();
        model.sheetname = 'Contact';
       model.headers = new list<string>{'Id','OwnerId'};
        model.data = new list<map<string,string>>();
        for(Contact act: [SELECT Id, OwnerId  from Contact Where Ownerid =:userid LIMIT 10000]){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
            model.data.add(rowdata);
        }
        dm.data.add(model);
    } 
    
      if(objType == 'Opportunity'){
    DataModel.Model model = new DataModel.Model();
        model.sheetname = 'Opportunity';
       model.headers = new list<string>{'Id','OwnerId','OWNER_MANAGER_EMAIL__C','OWNER_MANAGER_NAME__C'};
        model.data = new list<map<string,string>>();
        for(Opportunity act: [SELECT Id, OwnerId,OWNER_MANAGER_EMAIL__C,OWNER_MANAGER_NAME__C   from Opportunity Where Ownerid =:userid LIMIT 10000]){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
            rowdata.put('OWNER_MANAGER_EMAIL__C',(act.OWNER_MANAGER_EMAIL__C == null ? '':act.OWNER_MANAGER_EMAIL__C));
            rowdata.put('OWNER_MANAGER_NAME__C',(act.OWNER_MANAGER_NAME__C == null ? '':act.OWNER_MANAGER_NAME__C)); 
            model.data.add(rowdata);
        }
        dm.data.add(model);
    } 
    
    
    
    
    
     /*  if(objType == 'Account'){
       integer ii = 0;
       
       List<Account> acct = [SELECT Id, OwnerId,Current_Owner__c,Current_Owner_Email__c ,CURRENT_OWNER_NAME__C  from Account Where Current_Owner__c =:userid];
        
        Integer k = 1000;
        Double L = acct.size()/(k+0.0);
        L = Math.ceil(L);
        integer M = integer.valueOf(L); 
        List<List<Account>>  ListAccounts= new List<List<Account>>(); 
        
        for(Integer i =0 ; i<M ; i++){
            List<Account> listAccount = new List<Account>();
                for(Integer j=0; j<k; j++){
                    if(ii >= acct.size()) break;
                    listAccount.add(acct[ii]);
                    ii++;
                }
                ListAccounts.add(listAccount);
            }
       
       
     
        /* model.data = new list<map<string,string>>();
        
      Integer z=1;
      
       for(List<Account> a:ListAccounts ){ 
       
          DataModel.Model model = new DataModel.Model();
          model.sheetname = 'Account_Part'+z;
          model.headers = new list<string>{'Id','OwnerId','Current_Owner__c','CURRENT_OWNER_EMAIL__C','CURRENT_OWNER_NAME__C'};
          model.data = new list<map<string,string>>();
        
        for(Account act: a){
              
            map<string,string> rowdata = new map<string,string>();
            rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
            rowdata.put('Current_Owner__c',act.Current_Owner__c);
            rowdata.put('CURRENT_OWNER_EMAIL__C',(act.CURRENT_OWNER_EMAIL__C == null ? '':act.CURRENT_OWNER_EMAIL__C));
            //quote_obj.Term_months__c == null ? 0 : quote_obj.Term_months__c.intValue()
            rowdata.put('CURRENT_OWNER_NAME__C',(act.CURRENT_OWNER_NAME__C == null ? '':act.CURRENT_OWNER_NAME__C)); 
           
            model.data.add(rowdata);
        }
        dm.data.add(model);
        z++;    
    }
  } */ 
    
  /*  if(objType == 'Lead'){
    	integer ii = 0;
        
        List<Lead> led = [SELECT Id, OwnerId,OWNER_MANAGER_EMAIL__C,OWNER_MANAGER_NAME__C   from Lead Where Ownerid =:userid];
        
        Integer k = 1000;
        Double L = led.size()/(k+0.0);
        L = Math.ceil(L);
        integer M = integer.valueOf(L); 
        
        List<List<Lead>>  ListLeads= new List<List<Lead>>(); 
        
         for(Integer i =0 ; i<M ; i++){
            List<Lead> listLead = new List<Lead>();
                for(Integer j=0; j<k; j++){
                    if(ii >= led.size()) break;
                    listLead.add(led[ii]);
                    ii++;
                }
                ListLeads.add(listLead);
            }
            
        
        Integer z=1;
      
       for(List<Lead> le:ListLeads ){ 
       
          DataModel.Model model = new DataModel.Model();
          model.sheetname = 'Lead_Part'+z;
          model.headers = new list<string>{'Id','OwnerId','OWNER_MANAGER_EMAIL__C','OWNER_MANAGER_NAME__C'};
          model.data = new list<map<string,string>>();
        
        for(Lead act: le){
              
            map<string,string> rowdata = new map<string,string>();
            rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
            rowdata.put('OWNER_MANAGER_EMAIL__C',(act.OWNER_MANAGER_EMAIL__C == null ? '':act.OWNER_MANAGER_EMAIL__C));
            rowdata.put('OWNER_MANAGER_NAME__C',(act.OWNER_MANAGER_NAME__C == null ? '':act.OWNER_MANAGER_NAME__C));
           
            model.data.add(rowdata);
        }
        dm.data.add(model);
        z++;    
    }
        
 }*/
 
 /*if(objType == 'Contact'){
        
        integer ii = 0;
        
        List<Contact> Cont = [SELECT Id, OwnerId  from Contact Where Ownerid =:userid];
        
        Integer k = 1000;
        Double L = Cont.size()/(k+0.0);
        L = Math.ceil(L);
        integer M = integer.valueOf(L); 
        
        List<List<Contact>>  ListConts= new List<List<Contact>>(); 
        
         for(Integer i =0 ; i<M ; i++){
            List<Contact> listCont = new List<Contact>();
                for(Integer j=0; j<k; j++){
                    if(ii >= Cont.size()) break;
                    listCont.add(Cont[ii]);
                    ii++;
                }
                ListConts.add(listCont);
            }
            
        
        Integer z=1;
      
       for(List<Contact> co:ListConts ){ 
       
          DataModel.Model model = new DataModel.Model();
          model.sheetname = 'Contact_Part'+z;
          model.headers = new list<string>{'Id','OwnerId'};
          model.data = new list<map<string,string>>();
        
        for(Contact act: co){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
          
            model.data.add(rowdata);
        }
        dm.data.add(model);
        z++;    
    }
        
   
        
        
    }*/
    /*if(objType == 'Opportunity'){
    	integer ii = 0;
        
        List<Opportunity> opp = [SELECT Id, OwnerId,OWNER_MANAGER_EMAIL__C,OWNER_MANAGER_NAME__C   from Opportunity Where Ownerid =:userid];
        
        Integer k = 1000;
        Double L = opp.size()/(k+0.0);
        L = Math.ceil(L);
        integer M = integer.valueOf(L); 
        
        List<List<Opportunity>>  ListOpps= new List<List<Opportunity>>(); 
        
         for(Integer i =0 ; i<M ; i++){
            List<Opportunity> listOpp = new List<Opportunity>();
                for(Integer j=0; j<k; j++){
                    if(ii >= opp.size()) break;
                    listOpp.add(opp[ii]);
                    ii++;
                }
                ListOpps.add(listOpp);
            }
            
        
        Integer z=1;
      
       for(List<Opportunity> op:ListOpps ){ 
       
          DataModel.Model model = new DataModel.Model();
          model.sheetname = 'Opportunity_Part'+z;
          model.headers = new list<string>{'Id','OwnerId','OWNER_MANAGER_EMAIL__C','OWNER_MANAGER_NAME__C'};
          model.data = new list<map<string,string>>();
        
        for(Opportunity act: op){
              
            map<string,string> rowdata = new map<string,string>();
            rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
            rowdata.put('OWNER_MANAGER_EMAIL__C',(act.OWNER_MANAGER_EMAIL__C == null ? '':act.OWNER_MANAGER_EMAIL__C));
            rowdata.put('OWNER_MANAGER_NAME__C',(act.OWNER_MANAGER_NAME__C == null ? '':act.OWNER_MANAGER_NAME__C));
           
            model.data.add(rowdata);
        }
        dm.data.add(model);
        z++;    
    }
        
    }*/
  /*  if(objType == 'Case'){
        integer ii = 0;
        
        List<Case> cas = [SELECT Id, OwnerId  from Case Where Ownerid =:userid];
        
        Integer k = 1000;
        Double L = cas.size()/(k+0.0);
        L = Math.ceil(L);
        integer M = integer.valueOf(L); 
        
        List<List<Case>>  ListCases= new List<List<Case>>(); 
        
         for(Integer i =0 ; i<M ; i++){
            List<Case> listCase = new List<Case>();
                for(Integer j=0; j<k; j++){
                    if(ii >= Cas.size()) break;
                    listCase.add(cas[ii]);
                    ii++;
                }
                ListCases.add(listCase);
            }
            
        
        Integer z=1;
      
       for(List<Case> cs:ListCases ){ 
       
          DataModel.Model model = new DataModel.Model();
          model.sheetname = 'Case_Part'+z;
          model.headers = new list<string>{'Id','OwnerId'};
          model.data = new list<map<string,string>>();
        
        for(Case act: cs){
            map<string,string> rowdata = new map<string,string>();
            rowdata.put('Id',act.Id);
            rowdata.put('OwnerId',act.OwnerId);
          
            model.data.add(rowdata);
        }
        dm.data.add(model);
        z++;    
    }
    
    }*/
  
}
 /*Test Method*/
 
 /*	static testMethod void myTest(){
 	/*MultiSheetExcelGenerate msg = new MultiSheetExcelGenerate();
 	
 	
   	 
   	 PageReference pageRef = ApexPages.currentPage();
   	 pageref.getParameters().put('userid',uid);
   	 pageref.getParameters().put('objtype','Account');
   	 */
   	 
 	//ID uid = [SELECT id FROM USER Limit 1].id;
 	/*ID uid ='00580000003d9rB';
 	PageReference pageRef = Page.MultiSheetExcelGenerate;
    Test.setCurrentPage(pageRef);
 	
 	ApexPages.currentPage().getParameters().put('userid',uid);
 	ApexPages.currentPage().getParameters().put('objtype','Account');
 	
 	MultiSheetExcelGenerate msg = new MultiSheetExcelGenerate();
 	msg.objType= 'Account';
 	msg.userid = uid;
 	msg.dm = new DataModel(); 
 	
 	pageRef = Page.MultiSheetExcelGenerate;
    Test.setCurrentPage(pageRef);
 	ApexPages.currentPage().getParameters().put('userid',uid);
 	ApexPages.currentPage().getParameters().put('objtype','Lead');
 	msg = new MultiSheetExcelGenerate();
 	msg.objType= 'Lead';
 	msg.userid = uid;
 	msg.dm = new DataModel(); 
 	
 	pageRef = Page.MultiSheetExcelGenerate;
    Test.setCurrentPage(pageRef);
 	ApexPages.currentPage().getParameters().put('userid',uid);
 	ApexPages.currentPage().getParameters().put('objtype','Case');
 	msg = new MultiSheetExcelGenerate();
 	msg.objType= 'Case';
 	msg.userid = uid;
 	msg.dm = new DataModel(); 
 	
 	pageRef = Page.MultiSheetExcelGenerate;
    Test.setCurrentPage(pageRef);
 	ApexPages.currentPage().getParameters().put('userid',uid);
 	ApexPages.currentPage().getParameters().put('objtype','Contact');
 	msg = new MultiSheetExcelGenerate();
 	msg.objType= 'Contact';
 	msg.userid = uid;
 	msg.dm = new DataModel(); 
 	
 	pageRef = Page.MultiSheetExcelGenerate;
    Test.setCurrentPage(pageRef);
 	ApexPages.currentPage().getParameters().put('userid',uid);
 	ApexPages.currentPage().getParameters().put('objtype','Opportunity');
 	msg = new MultiSheetExcelGenerate();
 	msg.objType= 'Opportunity';
 	msg.userid = uid;
 	msg.dm = new DataModel(); 
 	
 	/*Pagereference pgref =  new PageReference('/apex/MultiSheetExcelGenerate');
 	pgref.getParameters().put('userid',uid);
 	pgref.getParameters().put('objtype','Account');*/
 	
 	
 	//}
  }