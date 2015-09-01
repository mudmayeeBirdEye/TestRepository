/*************************************************
Trigger on Opportunity object
Before Insert: Set Owner Manger/Last Touched/Responded fields. 
               Enforce activepipe limit (require that user have an employee record with division field filled in)
Before Update: Update Owner Manger/Last Touched/Responded fields.
               Enforce activepipe limit.
               Actions if downgraded: Set date, create cancelled trial based on reason
               Actions if closed:  Set date, create and send sales survey. 
               Update 12 Month QC.
               Check warm transfer box for implemenation creation
/************************************************/

trigger Opportunity on Opportunity (before insert, before update) {
    /*********************** DFR CODE *******************************/
    if(Trigger.isUpdate  && trigger.isBefore){            
        for(Opportunity l : Trigger.new) {
           Opportunity oldL = Trigger.oldMap.get(l.id);               
           if(l.IsClosed  && !oldL.IsClosed){
                l.DFR_Actual_Close_DateTime__c = datetime.now(); 
           }
        }   
    } 
    if(Trigger.isInsert  && trigger.isBefore){            
        for(Opportunity l : Trigger.new) {  
           if(l.IsClosed){
                l.DFR_Actual_Close_DateTime__c = datetime.now();
           }
        }           
    }
    
    /*if(Trigger.isInsert) {
        if(UserInfo.getUserType().containsIgnoreCase('Partner')) {
            User userObj = [select ContactId,Contact.AccountId,Contact.Account.Partner_ID__c, Contact.Account.Permitted_Brands__c
                                from User where Id = : UserInfo.getUserId()];
            set<Id> accountIdSet = new set<Id>();
            for(Opportunity oppObj : Trigger.New) {
                if(oppObj.AccountId != null) {
                    accountIdSet.add(oppObj.AccountId);
                }
            }
            map<Id,Account> accountPartnerMap = new map<Id,Account>([select Id,Partner_ID__c from account where Id IN :accountIdSet ]);
            for(Opportunity oppObj : Trigger.New) {
                oppObj.Partner_Owner__c = UserInfo.getUserId();
                if(oppObj.AccountId != null && accountPartnerMap != null && accountPartnerMap.get(oppObj.AccountId) != null) {
                    oppObj.AccountId = oppObj.AccountId;
                    oppObj.Partner_ID__c = accountPartnerMap.get(oppObj.AccountId).Partner_ID__c;
                } else if(userObj != null) {
                    if(userObj.Contact.AccountId != null) {
                        oppObj.AccountId = userObj.Contact.AccountId;
                        oppObj.Partner_ID__c = userObj.Contact.Account.Partner_ID__c;
                    }
                }   
            }
        }
    }*/
    
    try {
        Set<Id> accountIdSet = new Set<Id>();
        for(Opportunity oppObj : Trigger.New) {
            if(oppObj.AccountId != null) {
                accountIdSet.add(oppObj.AccountId);
            }
        }
        User userObj = [select ContactId, Contact.AccountId, Contact.Account.Partner_ID__c from User where Id = : UserInfo.getUserId()];
        map<Id,Account> accountPartnerMap = new map<Id,Account>([select Id,Partner_ID__c from account where Id IN :accountIdSet]);
        for(Opportunity oppObj : Trigger.New) {
            if(UserInfo.getUserType().containsIgnoreCase('Partner') && trigger.isInsert) {
                oppObj.Partner_Owner__c = UserInfo.getUserId();
            }
            if(oppObj.AccountId != null && accountPartnerMap != null && accountPartnerMap.get(oppObj.AccountId) != null) {
                if(oppObj.Partner_ID__c != accountPartnerMap.get(oppObj.AccountId).Partner_ID__c) {
                    oppObj.Partner_ID__c = accountPartnerMap.get(oppObj.AccountId).Partner_ID__c;
                }
            } else if(UserInfo.getUserType().containsIgnoreCase('Partner') && userObj != null && Trigger.isInsert) {
                if(userObj.Contact.AccountId != null) {
                    oppObj.AccountId = userObj.Contact.AccountId;
                    oppObj.Partner_ID__c = userObj.Contact.Account.Partner_ID__c;
                }
            }   
        }   
    } catch(Exception ex) {}
    
    /******************************COMMON CODE FOR INSERT/UPDATE ******************************************/
     OpportunityHelper.checkPartnerOpportunityPermittedByBrand(trigger.new, (Trigger.isInsert ? null : trigger.oldMap),OpportunityHelper.getApprovedBrandList(trigger.new));
    /*********************************************************************************************************************************/
    
    /************************************* Opportunity Amount from Lead Source Mapping **********************************************/      
    if(Trigger.isInsert) {
        Schema.DescribeSObjectResult recordtypemapresult = Opportunity.SObjectType.getDescribe();
        Map<ID,Schema.RecordTypeInfo> rtMapByName = recordtypemapresult.getRecordTypeInfosById();
        map<string,Decimal> leadSourceAmountMapping = OpportunityMethods.getAmountByLeadSource();
        /************************* Code for Calculating Amount Based on RC Tier and Brand. Added on 25th April,14 - Starts *************************/
        map<string,Decimal> leadBrandTierAmountMap = OpportunityMethods.getAmountByBrandAndTier();
        
        for(Opportunity NewOppObj : trigger.new) {
            if(NewOppObj.RecordTypeId != null && (rtMapByName.get(NewOppObj.RecordTypeId).getName() == 'Sales Opportunity' 
                || rtMapByName.get(NewOppObj.RecordTypeId).getName() == 'VAR Opportunity'
                || rtMapByName.get(NewOppObj.RecordTypeId).getName() == 'Sales Opportunity zQuote')) {
                if(NewOppObj.Forecasted_Users__c == 0){
                    NewOppObj.Forecasted_Users__c = 1 ; // Asked from Tucker.
                }   
                if(NewOppObj.Brand_Name__c != NULL && NewOppObj.Tier_Name__c != NULL && NewOppObj.Forecasted_Users__c!= NULL){
                    String brandTier = NewOppObj.Brand_Name__c+'-'+NewOppObj.Tier_Name__c;
                    if(leadBrandTierAmountMap != null && leadBrandTierAmountMap.containskey(brandTier) && leadBrandTierAmountMap.get(brandTier)!=NULL){
                        NewOppObj.Total_MRR__c = NewOppObj.Forecasted_Users__c*leadBrandTierAmountMap.get(brandTier);
                        if(NewOppObj.Total_MRR__c != NULL)
                            NewOppObj.X12_Month_Booking__c = 12*(NewOppObj.Total_MRR__c);
                            NewOppObj.Amount = NewOppObj.X12_Month_Booking__c;
                    }
                } else if(NewOppObj.LeadSource != null && leadSourceAmountMapping != null && leadSourceAmountMapping.containskey(NewOppObj.LeadSource)) {
                    NewOppObj.X12_Month_Booking__c = leadSourceAmountMapping.get(NewOppObj.LeadSource);
                    if(NewOppObj.X12_Month_Booking__c != NULL){
                        if(NewOppObj.Probability != NULL){
                            NewOppObj.Amount = NewOppObj.X12_Month_Booking__c;
                        }
                        NewOppObj.Total_MRR__c = (NewOppObj.X12_Month_Booking__c)/12;
                    }   
                }   
            } else {
                NewOppObj.Amount = 0;
            }   
        }
        /************************* Code for Calculating Amount Based on RC Tier and Brand. Added on 25th April,14 - Ends *************************/
    }
    /***********************************************************************************************************/
    
    if(TriggerHandler.BY_PASS_OPPORTUNITY_ON_INSERT || TriggerHandler.BY_PASS_OPPORTUNITY_ON_UPDATE){
        System.debug('### RETURNED FROM OPP INSERT TRG ###');
        return;
    } else {
        System.debug('### STILL CONTINUE FROM OPP INSERT TRG ###');
    }
    Integer j=0;
    Double k;
    String Division;
    
    /*
    All sales agents must have a Employee record with Division filled in.
    The Division field is used when checking the activepipe limits. Different divisions have different limits
    */
    Profile prof = [select Name from Profile where Id = :UserInfo.getProfileId()];
    if (!'System Administrator'.equalsIgnoreCase(prof.Name) 
        && !'Channel Sales Manager'.equalsIgnoreCase(prof.Name)
        && !(UserInfo.getUserType().containsIgnoreCase('Partner'))
        ) { 
        try {
            Division = [SELECT Id, Division__c FROM Employee__c WHERE user__c =: UserInfo.getUserId()].Division__c;
        } catch(Exception e) {
            for(Opportunity obj :trigger.new) {
                obj.addError('This user does not have access privilege to Employee object.');
            }
        }
    }
    
    // Establish Activepipelimits for divisions
    // Integer activePipeLimitGeneral = 60;
    
    /*Limit is changed to 80 changed on Oct 11, 2011*/
    Integer activePipeLimitGeneral = 80;
    Integer activePipeLimitVP_OB2 = 100;
    
    /* Optimized on Jan 09, 2012*/
    Set<Id> setOwnerId=new Set<Id>();
    for(Opportunity opp: trigger.new){
        setOwnerId.add(opp.OwnerId);
    }
    Map<Id,Id> mapUserManagerId=new Map<Id,Id>(); 
    Set<Id> setManagerId=new Set<Id>();
    for(User u:[SELECT id,ManagerId FROM User WHERE Id IN:setOwnerId]){
        setManagerId.add(u.ManagerId);
        mapUserManagerId.put(u.id,u.ManagerId);
    } 
    Map<ID,User> mapUser=new Map<id,User>([SELECT ManagerId,name,email FROM User WHERE Id IN:setManagerId]);
    /* Created a global user map */
    Set<Id> setOppId=new Set<Id>();
    Set<Id> setAccId=new Set<Id>();
    for(Opportunity NewOppObj :trigger.new ){
        setOppId.add(NewOppObj.id);
        setAccId.add(NewOppObj.AccountId);
    }
    Id rcId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');
    Map<String,Integer> mapOwnerOPPCount=new Map<String,Integer>();
    for(AggregateResult objAggregateResult:[SELECT OwnerId, count(id) cnt FROM Opportunity where OwnerId IN:setOwnerId AND 
                                            StageName IN : OpportunityHelper.alteredStages
                                            AND (RecordTypeId  =: rcId OR RecordTypeId = NULL) group by OwnerId]){
        mapOwnerOPPCount.put(String.valueOf(objAggregateResult.get('OwnerId')),Integer.valueOf(objAggregateResult.get('cnt')));
    }
    
    if(trigger.isInsert && trigger.isBefore){
        //Schema.DescribeSObjectResult recordtypemapresult = Opportunity.SObjectType.getDescribe();
        //Map<ID,Schema.RecordTypeInfo> rtMapByName = recordtypemapresult.getRecordTypeInfosById();
        //map<string,Decimal> leadSourceAmountMapping = OpportunityMethods.getAmountByLeadSource();
        Date firstDayOfMonth = System.today().toStartOfMonth();
        Date lastDayOfMonth = firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
        // for(integer i=0; i<trigger.new.size();i++)
        for(Opportunity NewOppObj :trigger.new ){
            //Opportunity NewOppObj = trigger.newMap.get(oppObj.Id);        
            /*
            Set Owner Manager fields
            */
            // if owner is Dave D, set himself as manager
            if(NewOppObj.OwnerId == '005800000037xj5'){
                NewOppObj.Owner_Manager_Email__c = 'daved@ringcentral.com';
                NewOppObj.Owner_Manager_Name__c = 'Dave Demink'; 
            } else {
                // find manager of owner and fill in owner manager fields                   
                // String manager = [SELECT ManagerId FROM User WHERE Id=:NewOppObj.OwnerId].ManagerId;
                String manager = mapUserManagerId.get(NewOppObj.OwnerId);
                try { 
                    User u = mapUser.get(manager);
                    // User u = [SELECT name, email from User WHERE id=:manager];
                    if(u != null) {
                        NewOppObj.Owner_Manager_Email__c = u.email;
                        NewOppObj.Owner_Manager_Name__c = u.name;
                    }
                } catch(System.QueryException e) {
                    
                }
            }
            
            /*
            Set Last Touched/Responded fields and enforce ActivePipe limit. The limit makes sure that agents do not hold activepipe opportunities
            with the thought that eventually a order will come in and they can get "free" credit.
            */
            if (!'System Administrator'.equalsIgnoreCase(prof.Name) 
            && !'Channel Sales Manager'.equalsIgnoreCase(prof.Name)) {
                // set touched and responded fields
                NewOppObj.Last_Touched_Date__c = datetime.now(); 
                NewOppObj.Last_Touched_By__c = UserInfo.getUserId();
                NewOppObj.Responded_Date__c = datetime.now();
                NewOppObj.Responded_By__c = UserInfo.getUserId();

                // enforce activepipe limit
                //Id rcId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');
                //Integer activePipeCount = [SELECT count() FROM Opportunity WHERE OwnerId =: NewOppObj.OwnerId AND StageName = '3. ActivePipe' AND (RecordTypeId  =: rcId OR RecordTypeId = NULL)];
                
                Integer activePipeCount = mapOwnerOPPCount.get(NewOppObj.OwnerId) == null?0:mapOwnerOPPCount.get(NewOppObj.OwnerId);
                system.debug('THIS IS activepipecount: ' + activePipeCount);
                if((activePipeCount >= activePipeLimitVP_OB2 && (division == 'VISTAPRINT OB' || division == 'Sales - Fax' 
                || division.toUpperCase().equals('OUTBOUND 2- INITIALS'))) || (activePipeCount >= activepipeLimitGeneral 
                && (division != 'VISTAPRINT OB' && division != 'Sales - Fax' && !division.toUpperCase().equals('OUTBOUND 2- INITIALS')))){
                    OpportunityMethods om = new OpportunityMethods();
                                                            
                    if(division == 'VISTAPRINT OB' || division == 'Sales - Fax' 
                    || division.toUpperCase().equals('OUTBOUND 2- INITIALS'))
                    {
                      if(!'Solve Then Sell'.equalsIgnoreCase(newOppObj.LeadSource)){
                     om.sendActivePipeLimitEmail(NewOppObj, activePipeCount+1, activePipeLimitVP_OB2);
                    }
                     }
                    else { if(!'Solve Then Sell'.equalsIgnoreCase(newOppObj.LeadSource)){
                    om.sendActivePipeLimitEmail(NewOppObj, activePipeCount+1, activePipeLimitGeneral); 
                    }
                    }                 
                }       
            }
            /*if(NewOppObj.RecordTypeId != null && (rtMapByName.get(NewOppObj.RecordTypeId).getName() == 'Sales Opportunity' 
                || rtMapByName.get(NewOppObj.RecordTypeId).getName() == 'VAR Opportunity' ||
                   rtMapByName.get(NewOppObj.RecordTypeId).getName() == 'Sales Opportunity zQuote')) {
                if(NewOppObj.LeadSource != null && leadSourceAmountMapping != null && leadSourceAmountMapping.containskey(NewOppObj.LeadSource)) {
                    NewOppObj.X12_Month_Booking__c = leadSourceAmountMapping.get(NewOppObj.LeadSource);
                    NewOppObj.Amount = (NewOppObj.X12_Month_Booking__c * NewOppObj.Probability)/100;
                }   
            } else {
                NewOppObj.Amount = 0;
            }*/
            /*if(NewOppObj.CloseDate != System.Today()) {       // Close Date validation (Forecasting)
                NewOppObj.CloseDate = lastDayOfMonth;   
            }*/                                     
        }
    }
    
     
    
    Set<Id> ownerIds = new Set<Id>();
    for(Opportunity oppObj : trigger.new){
        ownerIds.add(oppObj.OwnerId);
    }
    ownerIds.add(UserInfo.getUserId());
    Map<Id,User> userMap = new Map<Id, User>([SELECT Name, Profile.Name, IsTmtTriggersDisabled__c, Email, Manager.Email, Phone,Manager.Username, 
                                                IsActive, ManagerId, Mkto_Reply_Email__c From User WHERE Id IN: ownerIds]);
    if(trigger.isUpdate || trigger.isInsert) {
        /*************** MARKETO DUPLICATE CONTACT ***********************/
        try {
            List<Opportunity> opptyList = new List<Opportunity>();   
            for(Opportunity oppObj : trigger.new ) {
                User userObj = userMap.get(oppObj.ownerId);
                if(userObj == null || !userObj.isActive || (userObj.Name.equalsIgnoreCase('RCSF Sync') || 
                    userObj.Name.equalsIgnoreCase('India Team') || userObj.Name.equalsIgnoreCase('RCPartner Sync'))) {
                    opptyList.add(oppObj);
                }
            }            
            //if ('Marketo Integration Profile'.equalsIgnoreCase(userMap.get(UserInfo.getUserId()).Profile.Name)) {
            if(!Test.isRunningTest()) {
                OpportunityLARHelper.assignCampaignToOpportunity(opptyList);
                OpportunityLARHelper.initialOpportunities(opptyList, userMap);     
            }
                          
            //}
        } catch(Exception e) {trigger.new[0].addError(e.getMessage());}
        /**************** MARKETO DUPLICATE CONTACT **********************/     
       /***************** SETTING OPPORTUNITY CURRENCY ********************/
       try{
            for(Opportunity oppObj : trigger.new){
                    if(oppObj.Brand_Name__c == 'RingCentral UK'){
                        oppObj.CurrencyIsoCode = 'GBP';
                    } else if(oppObj.Brand_Name__c == 'RingCentral Canada'){
                        oppObj.CurrencyIsoCode ='CAD';
                    } else {
                        oppObj.CurrencyIsoCode ='USD';
                    }
            }
       } catch(Exception e) {trigger.new[0].addError(e.getMessage());}
      /***************** SETTING OPPORTUNITY CURRENCY ********************/ 
    }   
     
    if(trigger.isUpdate){
    /*Survey Sets for CSAT/Sales */
    Set<ID> oppSetForCsatSurvey = new Set<ID>();
    Set<ID> oppSetForSaleSurvey = new Set<ID>();    
        
        
    Boolean byPass  = [SELECT IsTmtTriggersDisabled__c FROM User Where Id=: UserInfo.getUserId()].IsTmtTriggersDisabled__c;
    if(!byPass){        
        
        Map<String,List<OpportunityLineItem>> mapOpportunityLineItem = new Map<String,List<OpportunityLineItem>>();
        for(Opportunity oli : [Select id,(SELECT id,PricebookEntry.Id, PricebookEntry.Product2.Subscription_Plan__c,TotalPrice 
                                           FROM OpportunityLineItems) from Opportunity WHERE Id IN :setOppId]){
            if(oli.OpportunityLineItems != null && oli.OpportunityLineItems.size()>0) {
               mapOpportunityLineItem.put(oli.id,oli.OpportunityLineItems);  
            }                                   
        }
        
        /*Map<Id,List<zqu__Quote__c>> mapZuoraQuotes = new Map<Id,List<zqu__Quote__c>>();
        for(Opportunity obj : [Select (Select Estimated_12Month_Booking__c,Id From zqu__Quotes__r order by lastmodifieddate desc limit 1) 
                                From Opportunity WHERE Id IN :setOppId]) {
            if(obj.zqu__Quotes__r != null && obj.zqu__Quotes__r.size() > 0) {
               mapZuoraQuotes.put(obj.id,obj.zqu__Quotes__r);  
            }                                   
        }*/
        
        
        Map<String,Integer> mapAccountImplementation=new Map<String,Integer>();     
        /* for(AggregateResult objAggregateResult:[SELECT Account__c,count(id) cnt FROM Implementation__c WHERE Account__c IN:setAccId AND Type__c='New' 
                                                   AND (Implementation_Status__c != 'Completed' OR Implementation_Status__c != 'Completed - No Help Needed') 
                                                   group by Account__c ]){
            mapAccountImplementation.put(String.valueOf(objAggregateResult.get('Account__c')),Integer.valueOf(objAggregateResult.get('cnt')));              
        }  */
          
        //------------------------------------------As/Simplion/7/22/2014/--------------------------------------
        //------------------------------------------Code update to resolve "Non-selective query against large object type" error------------------  
        
        /*for(AggregateResult objAggregateResult:[SELECT Account__c,count(id) cnt FROM Implementation__c WHERE Account__c IN:setAccId AND Type__c='New' 
                                                   AND (Implementation_Status__c != '6a. Completed' AND
                                                            Implementation_Status__c != '6b. Completed - No Help Needed') 
                                                   group by Account__c ]){
            mapAccountImplementation.put(String.valueOf(objAggregateResult.get('Account__c')),Integer.valueOf(objAggregateResult.get('cnt')));              
        }*/
        for(List<Account> accObjList : [SELECT id, (SELECT id FROM Implementations__r WHERE Type__c='New' AND Implementation_Status__c != '6a. Completed' AND
                                    Implementation_Status__c != '6b. Completed - No Help Needed' limit 1) FROM Account WHERE id IN:setAccId]){
            for(Account accObj : accObjList){
                if(accObj.Implementations__r != null && (accObj.Implementations__r).size() > 0){
                    mapAccountImplementation.put(accObj.id,1);
                }
            }
        }
            
        User obhRCSFSyncUser=[SELECT Id FROM User WHERE name= 'RCSF Sync'];     
        Map<String,Contact> mapAccContact=new Map<String,Contact>();
        for(Account objAccount:[Select id,(Select id from Contacts limit 1) from Account where ID IN:setAccId]){
            if(objAccount!= null && objAccount.Contacts != null &&objAccount.Contacts.size()>0){
                mapAccContact.put(objAccount.id,objAccount.Contacts.get(0));
            }
        }
        
        
        
        for(Opportunity NewOppObj :trigger.new ){
            Opportunity OldOppObj = trigger.oldMap.get(NewOppObj.Id);
            
            /*
            Update Last Touched/Responded fields and enforce ActivePipe limit. 
            */
            if (!'System Administrator'.equalsIgnoreCase(prof.Name) && !'Channel Sales Manager'.equalsIgnoreCase(prof.Name)) {
                if ((OldOppObj.Responded_Date__c==null)&& (OldOppObj.Responded_By__c==null))
                {
                    NewOppObj.Responded_Date__c = datetime.now();
                    NewOppObj.Responded_By__c = UserInfo.getUserId();   
                }
                NewOppObj.Last_Touched_Date__c = datetime.now();
                NewOppObj.Last_Touched_By__c = UserInfo.getUserId();
                
                //Check for number of activepipe opps
                if(OpportunityHelper.isActiveOpp(NewOppObj.StageName) && !OpportunityHelper.isActiveOpp(OldOppObj.StageName)){
                    //Id rcId = OpportunityHelper.getOppRecordTypeMap('Sales Opportunity');
                    //Integer activePipeCount = [SELECT count() FROM Opportunity WHERE OwnerId =: NewOppObj.OwnerId AND StageName = '3. ActivePipe' AND (RecordTypeId  =: rcId OR RecordTypeId = NULL)];
                    
                    Integer activePipeCount = mapOwnerOPPCount.get(NewOppObj.OwnerId) == null?0:mapOwnerOPPCount.get(NewOppObj.OwnerId);
                    system.debug('THIS IS activepipecount: ' + activePipeCount);
                 
                    if((activePipeCount >= activePipeLimitVP_OB2 && (division == 'VISTAPRINT OB' 
                    || division == 'Sales - Fax' || division.toUpperCase().equals('OUTBOUND 2- INITIALS'))) 
                    || (activePipeCount >= activePipeLimitGeneral 
                    && (division != 'VISTAPRINT OB' && division != 'Sales - Fax' && !division.toUpperCase().equals('OUTBOUND 2- INITIALS')))){  
                        OpportunityMethods om = new OpportunityMethods();
                        

                        if(division == 'VISTAPRINT OB' || division == 'Sales - Fax' 
                        || division.toUpperCase().equals('OUTBOUND 2- INITIALS'))
                        { om.sendActivePipeLimitEmail(NewOppObj, activePipeCount+1, activePipeLimitVP_OB2);}
                        
                        
                        else { om.sendActivePipeLimitEmail(NewOppObj, activePipeCount+1, activePipeLimitGeneral); }                     
                    }   
                }                           
            }               
            
            /*
            Update Owner Manager fields
            */
            if(NewOppObj.OwnerId != OldOppObj.OwnerId){
                // if new owner is Dave D, set himself as manager
                if(NewOppObj.OwnerId == '005800000037xj5'){
                    NewOppObj.Owner_Manager_Email__c = 'daved@ringcentral.com';
                    NewOppObj.Owner_Manager_Name__c = 'Dave Demink'; 
                }
                else{
                    if(UserInfo.getUserName() != 'rcsfsync@ringcentral.com' && UserInfo.getUserName() != 'sunilm@ringcentral.com' 
                        && UserInfo.getUserName() != 'rajesh@simplion.com' && UserInfo.getUserName() != 'rcindia@simplion.com'){                    
                        // find manager of new owner and set owner manager fields
                        String manager = mapUserManagerId.get(NewOppObj.OwnerId);
                        try{
                            // User u = [SELECT name, email from User WHERE id=:manager];
                            User u = mapUser.get(manager);
                            if(u != NULL) {
                                NewOppObj.Owner_Manager_Email__c = u.email;
                                NewOppObj.Owner_Manager_Name__c = u.name;
                            }
                        }
                        catch(System.QueryException e){
                            
                        }
                    }
                } 
            }
            
                        if(NewOppObj.StageName == '0. Downgraded' && OldOppObj.StageName != '0. Downgraded'){
                NewOppObj.Downgrade_Date_Opp__c = Date.Today();
            }
            
            /*
            If Opp is closed set date and send 
                *Sales survey
                *Added CSAT survey
            */
            if(OpportunityHelper.isClosedOpp(NewOppObj.StageName) && !OpportunityHelper.isClosedOpp(OldOppObj.StageName) && !'Channel Sales Manager'.equalsIgnoreCase(prof.Name)){
                // Channel sales manager profile is excluded because we dont want to send those contacts surveys
                NewOppObj.CloseDate = Date.Today();

                if(!'System Administrator'.equalsIgnoreCase(prof.Name)) {
                    
                    /*Here we prepare the Sets for CSAT and Sales surveys
                        *IF RecordType Save Opportunity AND Brand contains RingCentral Then CREATE CSAT Survey 
                        *ELSE CREATE Sales Survey
                    */  
        
                     if(NewOppObj.RecordTypeId  == OpportunityHelper.getOppRecordTypeMap('Saves Opportunity') 
                        && NewOppObj.Brand_Name__c.contains('RingCentral')) {
                            oppSetForCsatSurvey.add(NewOppObj.id);
                     } else {
                            oppSetForSaleSurvey.add(NewOppObj.id);
                     }
                                
                }
            }
            
            /* 
            If Opp has been closed and user is trying to change closedate reset back to original closedate
            */
            if((OpportunityHelper.isClosedOpp(NewOppObj.StageName) && OpportunityHelper.isClosedOpp(OldOppObj.StageName)) && (NewOppObj.CloseDate != OldOppObj.CloseDate)){
                NewOppObj.CloseDate = OldOppObj.CloseDate;
            }
            
            /*
            Check product line items and update 12 Month Booking
            */
            system.debug('THIS IS username: ' + UserInfo.getUserName());
            if(UserInfo.getUserName() != 'rcsfsync@ringcentral.com' 
            && UserInfo.getUserName() != 'sunilm@ringcentral.com' 
            && UserInfo.getUserName() != 'rcindia@simplion.com'){
                if(mapOpportunityLineItem.get(NewOppObj.Id)!=null){
                    Double twelveMB = 0.00;
                    for(OpportunityLineItem oli :mapOpportunityLineItem.get(NewOppObj.Id)){
                       //  if(oli!=null){
                                if(oli.PricebookEntry.Product2.Subscription_Plan__c == 'One-Time'){
                                    System.debug('12MB before onetime: ' + twelveMB);
                                    twelveMB += oli.TotalPrice;
                                    System.debug('12MB after onetime: ' + twelveMB);
                                }
                                else if(oli.PricebookEntry.Product2.Subscription_Plan__c == 'Monthly'){
                                    System.debug('12MB before monthly: ' + twelveMB);
                                    twelveMB += (oli.TotalPrice * 12);
                                    System.debug('12MB after monthly: ' + twelveMB);
                                }
                                else if(oli.PricebookEntry.Product2.Subscription_Plan__c == 'Annual'){
                                    twelveMB += (oli.TotalPrice * 12);
                                }
                        //} 
                    }
                    System.debug('12MB done: ' + twelveMB);
                    NewOppObj.X12_Month_Booking__c = twelveMB;   
                }   
            }
            
            /* 12 Month Forcast ***********************************************/
            
            if(NewOppObj.X12_Month_Booking__c != null && NewOppObj.X12_Month_Booking__c != OldOppObj.X12_Month_Booking__c 
                && (mapOpportunityLineItem.get(NewOppObj.Id) == null || ( mapOpportunityLineItem.get(NewOppObj.Id) != null 
                        && mapOpportunityLineItem.get(NewOppObj.Id).size() == 0))) {
                NewOppObj.Amount = NewOppObj.X12_Month_Booking__c;
            }
            
            
            /******************** Updates from Zuora *****************************/
            
            Map<String, Quoting_Tool_Setings__c> QuotingSettingsMap = Quoting_Tool_Setings__c.getAll();
           /* Boolean runQuotingToolCode = false;
            if(QuotingSettingsMap!= NULL && QuotingSettingsMap.containsKey('Quoting tool') && QuotingSettingsMap.get('Quoting tool')!= NULL){
                runQuotingToolCode = QuotingSettingsMap.get('Quoting tool').Enabled_Quoting_Tool_Code__c;           
            }
            if(!runQuotingToolCode){
                if(mapZuoraQuotes != null && mapZuoraQuotes.get(NewOppObj.id) != null && mapZuoraQuotes.get(NewOppObj.id).size() == 1 && 
                    mapZuoraQuotes.get(NewOppObj.id)[0].Estimated_12Month_Booking__c != null) {
                    //System.debug('NewOppObj.X12_Month_Booking__c>>' + NewOppObj.X12_Month_Booking__c);
                    List<zqu__Quote__c> listZQuotes = mapZuoraQuotes.get(NewOppObj.id);
                    if(NewOppObj.X12_Month_Booking__c != listZQuotes[0].Estimated_12Month_Booking__c) {
                        NewOppObj.X12_Month_Booking__c = listZQuotes[0].Estimated_12Month_Booking__c;   
                        //System.debug('NewOppObj.X12_Month_Booking__c-11>>' + NewOppObj.X12_Month_Booking__c);         
                    }
                    NewOppObj.Amount = NewOppObj.X12_Month_Booking__c;
                    //System.debug('Amount 1>>' + NewOppObj.Amount);    
                }   
            }*/
            
            
            /* 
            Check to see if call was warm transfer to an SE so implementation can be created.
            This piece causes issues sometimes because agents will check warm transfer box even though customer is not using Office service. 
            It could be improved by checking brand and tier on Opportunity itself or looking to Opportunities Account for details.
            */
            
            //if((NewOppObj.Warm_transfer_to_SE__c == True && OldOppObj.Warm_transfer_to_SE__c == False && (0 == [SELECT count() FROM Implementation__c WHERE Account__c=:NewOppObj.AccountId AND Type__c='New' AND (Implementation_Status__c != 'Completed' OR Implementation_Status__c != 'Completed - No Help Needed')])))
              if((NewOppObj.Warm_transfer_to_SE__c == True && OldOppObj.Warm_transfer_to_SE__c == False && 
                    (0 ==(mapAccountImplementation.get(NewOppObj.AccountId)==null?0:mapAccountImplementation.get(NewOppObj.AccountId))))){  
                //create new implementation
                Implementation__c imp = new Implementation__c();
                imp.Name = NewOppObj.Name + ' - ' + Datetime.now().format();
                //imp.Implementation_Status__c = 'Needed';
                imp.Implementation_Status__c = '1. New';
                imp.office_service_change_date__c = Date.today();
                imp.Account__c = NewOppObj.AccountId;
                imp.Type__c = 'New';
                imp.Brand__c = NewOppObj.Brand_Name__c;
                imp.Tier__c = NewOppObj.Tier_Name__c;
                //imp.Service__c = NewOppObj.RC_Service_Name__c;
                //imp.OwnerId = [SELECT Id FROM User WHERE name= 'RCSF Sync'].Id;
                imp.OwnerId = obhRCSFSyncUser.id;
                try{
                    //imp.Contact__c = [SELECT Id FROM Contact WHERE accountId=:NewOppObj.AccountId Limit 1].Id;
                    if(mapAccContact.get(NewOppObj.AccountId)!=null){
                      imp.Contact__c=mapAccContact.get(NewOppObj.AccountId).id;
                    }  
                    insert imp;
                }
                catch(Exception e){ }               
            } 
            
            if(OldOppObj.Partner_Owner__c != NewOppObj.Partner_Owner__c && !string.IsBlank(NewOppObj.Partner_Owner__c)){
                NewOppObj.Partner_Owner_Assignment_Date__c = System.today();
            }               
        }
    }
    /*Creating survey*/
    if(oppSetForCsatSurvey.size() > 0) {
        OpportunitySurveyClass Osc = new OpportunitySurveyClass(oppSetForCsatSurvey,'Saves CSAT' );
        System.debug('---------------------CSAT Survey created---------------');    
    }
    if(oppSetForSaleSurvey.size() > 0) {
        OpportunitySurveyClass Osc = new OpportunitySurveyClass(oppSetForSaleSurvey,'Sales');
        System.debug('---------------------Sales Survey created---------------');   
    }   
}}