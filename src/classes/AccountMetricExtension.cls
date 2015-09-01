/********************************************************************************************************
 * Project Name..........:                                                                               *
 * File..................: AccountMetricExtension.class                                                  *
 * Version...............: 1.0                                                                           *
 * Created by............: Simplion Technologies                                                         *
 * Created Date..........:                                                                               *
 * Last Modified by......: Simplion Technologies                                                         *
 * Last Modified Date....: 24-06-2014                                                                    *
 * Description...........:                                                                               *
 ********************************************************************************************************/

public class AccountMetricExtension {
    public Account accObj {get;set;}
    public Account rcInteralAccount {get;set;}
    public Account_Metric__c accountMetricObj {get;set;}
    Integer perGroupNumber;
    public List<Peer_Group__c> peerGroupPerAccountMetricList {get;set;}
    public map<Integer,Peer_Group__c> peergroupMap {get;set;}
    public string emailaddress {get;set;}
    public List<string> selectedContacts {get;set;}
    public string toAddress {get;set;}
    public Set<String> AllAdditionalToSet {get;set;} 
    public List<string> selectedAdditionalToList {get;set;} 
    public List<string> selectedCCList {get;set;} 
    public set<string> AllCCOptionsSet {get;set;} 
    public List<string> selectedBccList {get;set;} 
    public set<string> AllBccOptionsSet {get;set;}
	public HealthScoreWrapper objHealthScore{get;set;}
    // Start of OJ's Modifications
    public Implementation__c impObj {get;set;}
    public Case caseObj {get;set;}
    public Case case2Obj {get;set;}
    public Account accInfoObj {get;set;}
    public Network_Information__c netObj {get;set;}

    //Completion Rate
    public double Completion30D {get;set;}
    public double Completion60D {get;set;}    
    public double Completion90D {get;set;}    

    public double IC_ACCReview_Score {get;set;}
    public double IC_CompanyInfo_Score {get;set;}
    public double IC_Users_Score {get;set;}
    public double IC_Phones_Score {get;set;}    
    public double IC_Groups_Score {get;set;}    
    public double IC_Tools_Score {get;set;}
    public double IC_Score {get;set;}

    public List<string> IC_ACCReview {get;set;}
    public List<string> IC_CompanyInfo {get;set;}
    public List<string> IC_Users {get;set;}
    public List<string> IC_Phones {get;set;}
    public List<string> IC_Groups {get;set;}
    public List<string> IC_Tools {get;set;}

    //Buttons    

    //Implementations Phase
    public Boolean ImpCompleted_Green {get;set;}
    public Boolean ImpCompleted_Red {get;set;}

    public Boolean WebPortal_Green {get;set;}
    public Boolean WebPortal_Red {get;set;}

    public Boolean AcctNetwork_Green {get;set;}
    public Boolean AcctNetwork_Red {get;set;}

    public Boolean ImpCheckList_Green {get;set;}
    public Boolean ImpCheckList_Orange {get;set;}
    public Boolean ImpCheckList_Red {get;set;}

    public Boolean ACCReview_Green {get;set;}
    public Boolean ACCReview_Orange {get;set;}
    public Boolean ACCReview_Red {get;set;}

    public Boolean IC_CompanyInfo_Green {get;set;}
    public Boolean IC_CompanyInfo_Orange {get;set;}
    public Boolean IC_CompanyInfo_Red {get;set;}

    public Boolean IC_Users_Green {get;set;}
    public Boolean IC_Users_Orange {get;set;}
    public Boolean IC_Users_Red {get;set;}

    public Boolean IC_Phones_Green {get;set;}
    public Boolean IC_Phones_Orange {get;set;}
    public Boolean IC_Phones_Red {get;set;}

    public Boolean IC_Groups_Green {get;set;}
    public Boolean IC_Groups_Orange {get;set;}
    public Boolean IC_Groups_Red {get;set;}

    public Boolean IC_Tools_Green {get;set;}
    public Boolean IC_Tools_Orange {get;set;}
    public Boolean IC_Tools_Red {get;set;}

    //Adoption
    public Boolean MobileUser_Green {get;set;}
    public Boolean MobileUser_Orange {get;set;}
    public Boolean MobileUser_Red {get;set;}

    public Boolean FaxUser_Green {get;set;}
    public Boolean FaxUser_Orange {get;set;}
    public Boolean FaxUser_Red {get;set;}

    public Boolean PortedIn_Green {get;set;}
    public Boolean PortedIn_Red {get;set;}

    public Boolean ConfUser_Green {get;set;}
    public Boolean ConfUser_Red {get;set;}

    //Graduation
    public Boolean MinuteTrend_Green {get;set;}
    public Boolean MinuteTrend_Red {get;set;}

    public Boolean T3Case_Green {get;set;}
    public Boolean T3Case_Red {get;set;}

    public Boolean RedAcc_Green {get;set;}
    public Boolean RedAcc_Red {get;set;}

    public Boolean Farming_Green {get;set;}
    public Boolean Farming_Red {get;set;}
    public Boolean Farming_Orange {get;set;}  

    public Boolean GradKit_Green {get;set;}
    public Boolean GradKit_Red {get;set;}
    
    // Non referenced field, to be removed.
    public Boolean AccountBuildOut_Red {get; set;}
    public Boolean AccountBuildOut_Green {get; set;}
    public Boolean AccountBuildOut_Orange {get; set;}
    public Boolean Webinar_Red {get; set;}
    public Boolean Webinar_Green {get; set;}
    public Boolean EnduserTraining_Green {get; set;}
    public Boolean EnduserTraining_Red {get; set;}
    public Boolean DLs_Green {get; set;}
    public Boolean DLs_Orange {get; set;}
    public Boolean DLs_Red {get; set;}
    
    
    // End of OJ's Modifications
    map<Id,string> contactIdToEmailMap; 
    map<string,string> contactIdToEmailAddressMap;
    List<Contact> contactList;
    AccountScoreCardHelper accountScoreCardHelperObj; 
    public Quote quoteObj{get;set;}

    // Constants 
    public final Set<String> ICACCREVIEWSET = new Set<String>{'Overview','Messages','Activity Log','Contacts','Billing','Webinars','Support Portal','Survey'};
    public final Set<String> ICCOMPANYINFOSET = new Set<String>{'Company Caller ID','Company Address','Add Number','User My Existing Number (Porting)'};
    public final Set<String> ICUSERSSET = new Set<String>{'Unassigned Ext','Add Users','Permissions','User Info','Phones & Numbers','Screening, Greeting, & Hold Music',
                                                            'Call Handling and Forwarding','Messages & Notifications','Outbound Caller ID','Outbound Fax Settings'};
    public final Set<String> ICPHONESSET = new Set<String>{'Phone Serial Number','Phone Nickname','E911'};
    public final Set<String> ICGROUPSSET = new Set<String>{'Add Group','Call Queues','Paging','Shared Lines'};  
    public final Set<String> ICTOOLSSET = new Set<String>{'Mobile App','Softphone','RC Meetings'};

        // Consrtuctor 
        public AccountMetricExtension(ApexPages.StandardController controller) {
            accountScoreCardHelperObj = new  AccountScoreCardHelper();
            String accountId = ApexPages.currentPage().getParameters().get('accid');        //  controller.getId();
            accountMetricObj = new Account_Metric__c();
            contactIdToEmailMap = new map<Id,string>();
            contactIdToEmailAddressMap = new map<string,string>();
            contactList = new List<Contact>();
            AllAdditionalToSet = new set<string>();
            selectedAdditionalToList = new List<string>();
            AllCCOptionsSet = new set<string>();
            selectedBccList = new List<string>();
            selectedCCList = new List<string>();
            AllBccOptionsSet = new set<string>();
            if(accountId != null) {
                try {                
                    selectedContacts = new List<string>();
                    rcInteralAccount = accountScoreCardHelperObj.getRCInternalAccountInfo();
                    accObj = accountScoreCardHelperObj.getAccountValues(accountId);
					objHealthScore = new HealthScoreWrapper();
                	objHealthScore = getHealthScore(accObj);
                    // Start of OJ's Modifications

                    accInfoObj = accountScoreCardHelperObj.getAccountInfoValues(accountId);

                    // End of OJ's Modifications
					impObj = accountScoreCardHelperObj.getImplementationValues(accountId);
                    quoteObj = accountScoreCardHelperObj.getSalesAgreement(accObj);                
                    for(Contact contactObj : rcInteralAccount.contacts) {
                        contactList.add(contactObj);
                        contactIdToEmailMap.put(contactObj.Id,contactObj.Name + '-' +contactObj.Email);
                        contactIdToEmailAddressMap.put(contactObj.Id,contactObj.Email);
                    }           
                    accountMetricObj = accountScoreCardHelperObj.getAccountMetricValues(accountId);
                    if(accountMetricObj != null) {
                        perGroupNumber = Integer.valueOf(accountMetricObj.Peer_Group_ID__c!=null?accountMetricObj.Peer_Group_ID__c:0);

                        // Start of OJ's Modifications
                        //Set all Values to 0
                        Completion30D=0;
                        Completion60D=0;
                        Completion90D=0;
                        IC_ACCReview_Score=0;
                        IC_CompanyInfo_Score=0;
                        IC_Users_Score=0;
                        IC_Phones_Score=0;
                        IC_Groups_Score=0;
                        IC_Tools_Score=0;

                        //Minute Trend, Last 60 vs Previous 60 days
                        if(accountMetricObj.Metric_3_value__c != null){
                            if (accountMetricObj.Metric_3_value__c<=1){MinuteTrend_Red=true;} 
                            else {
                                MinuteTrend_Green=true;
                                if (accObj.Number_of_DL_s__c<=250){
                                    Completion90D=Completion90D+50;
                                }
                                else{
                                    Completion90D=Completion90D+40;
                                }                            
                            }
                        }                                     
                        //% of Users Active on Mobile App for the Last 30 Days
                        if (accountMetricObj.Metric_18_value__c != null){
                            if (accountMetricObj.Metric_18_value__c<=0.60){
                                MobileUser_Red=true;
                                Completion60D=Completion60D+accountMetricObj.Metric_18_value__c*25;
                            } 
                            if (accountMetricObj.Metric_18_value__c>0.60 && accountMetricObj.Metric_18_value__c<0.81){
                                MobileUser_Orange=true;
                                Completion60D=Completion60D+accountMetricObj.Metric_18_value__c*25;
                            } 
                            if (accountMetricObj.Metric_18_value__c>=0.81){
                                MobileUser_Green=true;
                                Completion60D=Completion60D+accountMetricObj.Metric_18_value__c*25;
                            }
                        }

                        //Fax Completion Rate, Last 30 Days
                        if (accountMetricObj.Metric_27_value__c != null){
                            if (accountMetricObj.Metric_27_value__c<=0.60){FaxUser_Red=true;} 
                            if (accountMetricObj.Metric_27_value__c>0.60 && accountMetricObj.Metric_27_value__c<0.81){FaxUser_Orange=true;} 
                            if (accountMetricObj.Metric_27_value__c>=0.81){FaxUser_Green=true;}
                            if (accountMetricObj.Metric_27_value__c>=0){Completion60D=Completion60D+25;}
                        }
                        //Conference Calling Mins Trends, Last 30 vs Previous 30 Days
                        if(accountMetricObj.Metric_23_value__c != null){
                            if (accountMetricObj.Metric_23_value__c<=1){ConfUser_Red=true;} 
                            else {
                                ConfUser_Green=true;
                                Completion60D=Completion60D+25;
                            }
                        }
                        //Red Account Object Created in the Past 180 Days
                        if (accountMetricObj.Metric_28_value__c!=null){
                            if (accountMetricObj.Metric_28_value__c>=1){RedAcc_Red=true;} 
                            else {
                                RedAcc_Green=true;
                                Completion90D=Completion90D+20;
                            }
                        }
                        //Current Owner
                        /*
                        Above is refactor by Simplion to meet business need as per OJ's mail point below :

                        Any account that has an agent as current owner we should mark as green.
                        For any account that has >= 250 DLs and Current Owner Email is null, sfdchelp@ringcentral.com or rcsfsync@ringcentral.com mark them as Red.
                        For any account that has < 250 DLs and Current Owner Email is null mark them as Red.
                        For any account that has < 250 DLs and Current Owner Email is sfdchelp@ringcentral.com or rcsfsync@ringcentral.com mark them as Orange.
                         */                   

                        //OJ's edited logic
                        if(accInfoObj.Current_Owner_Email__c == null ){
                            Farming_Red=true;
                        }else {
                            if(accInfoObj.Current_Owner_Email__c != null &&
                                    accInfoObj.Current_Owner_Email__c != UserRc.indiaTeamUserObj.Email__c &&
                                    accInfoObj.Current_Owner_Email__c != UserRC.rcsfSyncUserObj.Email__c) {
                                Farming_Green=true;
                                Completion90D=Completion90D+10;
                            }else if(accObj.Number_of_DL_s__c<250 && 
                                    (accInfoObj.Current_Owner_Email__c== UserRc.indiaTeamUserObj.Email__c ||
                                     accInfoObj.Current_Owner_Email__c== UserRC.rcsfSyncUserObj.Email__c)){
                                Farming_Orange=true;
                            }else {
                                Farming_Red=true;
                            }
                        }

                        //Graduation Kit (re-purposed welcome kit)
                        if (accInfoObj.Graduation_Kit__c==true) {
                            GradKit_Green=true;
                            Completion90D=Completion90D+10;
                        } 
                        else {GradKit_Red=true;}

                        //Ported In
                        if (accountMetricObj.Metric_11_value__c!=null){
                            if (accountMetricObj.Metric_11_value__c==0){PortedIn_Red=true;} 
                            if (accountMetricObj.Metric_11_value__c==1){
                                PortedIn_Green=true;            
                                Completion60D=Completion60D+25;
                            } 
                        }

                        //Implementation Completed & End User Training & Account Build Out
                        try {
                            //impObj = accountScoreCardHelperObj.getImplementationValues(accountId);
                            system.debug('impObj--->'+impObj);
                            if (impObj != null && (impObj.Implementation_Status_2__c =='Completed' || 
                                impObj.Implementation_Status_2__c =='Completed - No Help Needed' || 
                                impObj.Implementation_Status_2__c =='Completed - By Partners')){
                                    ImpCompleted_Green=true;Completion30D=Completion30D+10;
                            }else{
                                ImpCompleted_Red=true;
                            }                              

                            //Split Multipicklist        
                            IC_ACCReview = (impObj.Account_Review__c !=NULL ?  impObj.Account_Review__c.split(';') : NULL);
                            IC_CompanyInfo = (impObj.Company_Numbers_and_Info__c !=NULL ?  impObj.Company_Numbers_and_Info__c.split(';') : NULL);
                            IC_Users = (impObj.Users__c !=NULL ?  impObj.Users__c.split(';') : NULL); 
                            IC_Phones = (impObj.Phones_Devices__c !=NULL ?  impObj.Phones_Devices__c.split(';') : NULL);
                            IC_Groups = (impObj.Groups__c !=NULL ?  impObj.Groups__c.split(';') : NULL);
                            IC_Tools = (impObj.Tools__c !=NULL ?  impObj.Tools__c.split(';') : NULL);

                            // Modified by Simplion Technologies
                            try
                            {
                                if(IC_ACCReview.size() > 0){
                                    for(String ICAccReviewValue : IC_ACCReview){
                                    	
                                    	if(!String.isBlank(impObj.Brand__c) && impObj.Brand__c.equalsIgnoreCase(GraduationScoreCardHelper.BRAND_TELUS)){
	                                        if(AccountScoreCardHelper.ICACCREVIEWSET_TELUS.contains(ICAccReviewValue)){
	                                        	IC_ACCReview_Score = IC_ACCReview_Score+(0.10/9);
	                                        }
	                                    }else{
	                                        if(ICACCREVIEWSET.contains(ICAccReviewValue)){
	                                            IC_ACCReview_Score = IC_ACCReview_Score+(0.10/8);
	                                        }
                                    	}
                                    }
                                }
                            }                      
                            catch (Exception ex) {}
                            // Modified by Simplion Technologies
                            try {
                                if(IC_CompanyInfo.size() > 0){
                                    for(String ICCompanyInfoValue : IC_CompanyInfo){
                                        if(ICCOMPANYINFOSET.contains(ICCompanyInfoValue)){
                                            IC_CompanyInfo_Score = IC_CompanyInfo_Score+(0.10/4);
                                        }
                                    }
                                }
                            }                      
                            catch (Exception ex) {}   
                            // Modified by Simplion Technologies
                            try {
                                if(IC_Users.size() > 0){
                                    for(String ICUsersValue : IC_Users){
                                        if(ICUSERSSET.contains(ICUsersValue)){
                                            IC_Users_Score=IC_Users_Score+(0.25/10);
                                        }
                                    }
                                }
                            }                      
                            catch (Exception ex) {}       
                            // Modified by Simplion Technologies
                            try {
                                if(IC_Phones.size() > 0){
                                    for(String ICPhonesValue : IC_Phones){
                                        if(ICPHONESSET.contains(ICPhonesValue)){
                                            IC_Phones_Score=IC_Phones_Score+(0.25/3);
                                        }
                                    }
                                }
                            }                      
                            catch (Exception ex) {}    
                            // Modified by Simplion Technologies
                            try{
                                if(IC_Groups.size() > 0){
                                    for(String ICGroupsValue : IC_Groups){
                                        if(ICGROUPSSET.contains(ICGroupsValue)){
                                            IC_Groups_Score=IC_Groups_Score+(0.15/4);
                                        }
                                    }
                                }
                            }                      
                            catch (Exception ex) {}      

                            // Modified by Simplion Technologies
                            try {
                                if(IC_Tools.size() > 0){
                                    for(String ICToolsValue : IC_Tools){
                                        if(ICTOOLSSET.contains(ICToolsValue)){
                                            IC_Tools_Score=IC_Tools_Score+(0.15/3);
                                        }
                                    }
                                }
                            }                      
                            catch (Exception ex) {}
                            //Implementations Checklist Completion %
                            IC_Score =(IC_ACCReview_Score+IC_CompanyInfo_Score+IC_Users_Score+IC_Phones_Score+IC_Groups_Score+IC_Tools_Score);
                            if (IC_Score<0.60){ImpCheckList_Red=true;} 
                            if (IC_Score>=0.60 && IC_Score<0.80){ImpCheckList_Orange=true;} 
                            if (IC_Score>=0.80){ImpCheckList_Green=true;}
                            if (IC_Score>=0){Completion30D=Completion30D+((IC_Score*.7)*100);}

                            if (IC_ACCReview_Score<0.060){ACCReview_Red=true;} 
                            if (IC_ACCReview_Score>=0.060 && IC_ACCReview_Score<0.080){ACCReview_Orange=true;} 
                            if (IC_ACCReview_Score>=0.080){ACCReview_Green=true;}

                            if (IC_CompanyInfo_Score<0.060){IC_CompanyInfo_Red=true;} 
                            if (IC_CompanyInfo_Score>=0.060 && IC_CompanyInfo_Score<0.080){IC_CompanyInfo_Orange=true;} 
                            if (IC_CompanyInfo_Score>=0.080){IC_CompanyInfo_Green=true;}

                            if (IC_Users_Score<0.15){IC_Users_Red=true;} 
                            if (IC_Users_Score>=0.15 && IC_Users_Score<0.2){IC_Users_Orange=true;} 
                            if (IC_Users_Score>=0.2){IC_Users_Green=true;}

                            if (IC_Phones_Score<0.15){IC_Phones_Red=true;} 
                            if (IC_Phones_Score>=0.15 && IC_Phones_Score<0.2){IC_Phones_Orange=true;} 
                            if (IC_Phones_Score>=0.2){IC_Phones_Green=true;}

                            if (IC_Groups_Score<0.09){IC_Groups_Red=true;} 
                            if (IC_Groups_Score>=0.09 && IC_Groups_Score<0.12){IC_Groups_Orange=true;} 
                            if (IC_Groups_Score>=0.12){IC_Groups_Green=true;}

                            if (IC_Tools_Score<0.09){IC_Tools_Red=true;} 
                            if (IC_Tools_Score>=0.09 && IC_Tools_Score<0.12){IC_Tools_Orange=true;} 
                            if (IC_Tools_Score>=0.12){IC_Tools_Green=true;}
                        }
                        catch (Exception ex) {
                            ImpCompleted_Red=true;
                        }

                        //Network Info
                        try {
                            netObj = accountScoreCardHelperObj.getNetworkValues(accountId);
                            if(netObj != null) {AcctNetwork_Green=true;Completion30D=Completion30D+10;}
                            else {}
                        }catch (Exception ex) {
                            AcctNetwork_Red=true;                        
                        }

                        //No Open Tier 3 Cases / Pending PKI's
                        try {
                            caseObj = accountScoreCardHelperObj.getCaseValues(accountId);
                            if(caseObj != null) {T3Case_Red=true;}
                        }catch (Exception ex) {
                            T3Case_Green=true;
                            Completion90D=Completion90D+20;
                        }

                        //Web Portal
                        try {
                            case2Obj = accountScoreCardHelperObj.getCaseValues(accountId);
                            if(case2Obj != null) {WebPortal_Green=true;Completion30D=Completion30D+10;}
                        }catch (Exception ex) {
                            WebPortal_Red=true;
                        }
                        // End of OJ's Modifications
                    }
                    set<Integer> metricintSet = new set<Integer>();
                    metricintSet = getMetricSet();
                    if(perGroupNumber != null && metricintSet != null && metricintSet.size()>0) {
                        peerGroupPerAccountMetricList = getPeerGroupPerAccountMetric(perGroupNumber,metricintSet);  
                        List<Peer_Group__c> lstPeerGrpPerAccountMetric = getPeerGroupPerAccountMetric(perGroupNumber,metricintSet);
                        peergroupMap = new map<Integer,Peer_Group__c>();
                        peergroupMap = accountScoreCardHelperObj.getPeerGroupMapValues(metricintSet,lstPeerGrpPerAccountMetric);                
                    }
                } catch(Exception ex) {}    
            }
        }

        public List<SelectOption> getContactOptions() {
            List<SelectOption> contactListPerAccount = new List<SelectOption>();
            try {
                for(Contact contactObj : contactList) {
                    contactListPerAccount.add(new SelectOption(contactObj.Id,contactObj.Name + '-' +contactObj.Email));
                }
            } catch(Exception ex) {}
            return contactListPerAccount;
        }

        public List<Peer_Group__c> getPeerGroupPerAccountMetric(Integer peerGroupNumber, set<Integer> metricNumberSet) {
            List<Peer_Group__c> rtnListPeerGroup = accountScoreCardHelperObj.getPeerGroupPerAccountMetric(peerGroupNumber, metricNumberSet);
            return rtnListPeerGroup;
        }

        public Set<Integer> getMetricSet() {
            Set<Integer> rtnSetMetricId = accountScoreCardHelperObj.getMetricSet();
            return rtnSetMetricId;
        }

        public PageReference setToAddress() {
            try {
                for(Id obj : selectedContacts) {
                    toAddress = contactIdToEmailMap.get(obj);
                    //isrecipientselected = true;
                    break;
                }
            } catch(Exception ex) {}
            return null;
        }

        public PageReference removeToAddress() {
            //isrecipientselected = false;
            toAddress = null;
            return null;
        }

        /* Additional Panel*/
        set<string> addToEmailset = new set<string>();
        public PageReference setAdditionalTo() {
            try {
                for(Id obj : selectedContacts) {
                    AllAdditionalToSet.add(obj);
                    addToEmailset.add(contactIdToEmailAddressMap.get(obj));
                }
            } catch(Exception ex) {}
            return null;
        }


        public PageReference removeAdditionalTo() {
            for(String Id : selectedAdditionalToList) {
                AllAdditionalToSet.remove(Id);
                addToEmailset.remove(contactIdToEmailAddressMap.get(Id));
            }
            selectedAdditionalToList.clear();
            return null;
        }

        public List<SelectOption> getAllAdditionalTo(){
            List<SelectOption> options = new List<SelectOption>();
            try {
                for(String id:  AllAdditionalToSet) {
                    options.add(new SelectOption(id,contactIdToEmailMap.get(id)));
                    //isrecipientselected = true;
                }
            } catch(Exception e){}
            return options;
        }

        /* CC Panel*/

        set<string> ccEmailset = new set<string>();
        public PageReference setCCList() {
            try {
                for(Id obj : selectedContacts) {
                    AllCCOptionsSet.add(obj);
                    ccEmailset.add(contactIdToEmailAddressMap.get(obj));
                }
            } catch(Exception ex) {}
            return null;
        }

        public List<SelectOption> getAllCCOptions(){
            List<SelectOption> options = new List<SelectOption>();
            try {
                for(String id:  AllCCOptionsSet) {
                    options.add(new SelectOption(id,contactIdToEmailMap.get(id)));
                    //isrecipientselected = true;
                }
            } catch(Exception e){}
            return options;
        }

        public PageReference removeCCList() {
            for(String Id : selectedCCList) {
                AllCCOptionsSet.remove(Id);
                ccEmailset.remove(contactIdToEmailAddressMap.get(Id));
            }
            selectedCCList.clear();
            return null;
        }

        /* BCC Panel*/

        set<string> bccEmailset = new set<string>(); 
        public PageReference setBccList() {
            try {
                for(Id obj : selectedContacts) {
                    AllBccOptionsSet.add(obj);
                    bccEmailset.add(contactIdToEmailAddressMap.get(obj));
                }
            } catch(Exception ex) {}
            return null;
        }

        public List<SelectOption> getAllBccOptions(){
            List<SelectOption> options = new List<SelectOption>();
            try {
                for(String id:  AllBccOptionsSet) {
                    options.add(new SelectOption(id,contactIdToEmailMap.get(id)));
                    //isrecipientselected = true;
                }
            } catch(Exception e){}
            return options;
        }

        public PageReference removeBccList() {
            for(String Id : selectedBccList) {
                AllBccOptionsSet.remove(Id);
                bccEmailset.remove(contactIdToEmailAddressMap.get(Id));
            }
            selectedCCList.clear();
            return null;
        }

        public string inputtxtsearch {get;set;}
        public void getemailonSearch() {
            try {
                contactList.clear();
                if(!string.isBlank(inputtxtsearch)) {
                    string strQuery = 'SELECT Id,Name,(SELECT Name,email FROM Contacts WHERE Name '+ 
                            'like \''+ String.escapeSingleQuotes(inputtxtsearch.trim()) +'%\''+ 
                            ' ORDER BY Name asc limit 1000) FROM Account'+ 
                            ' WHERE Name = \'RC Internal\' LIMIT 1';
                    System.Debug('>>strQuery>>'+strQuery);                              
                    List<Account> accList = Database.Query(strQuery);
                    for(Contact contactObj : accList[0].Contacts) {
                        contactList.add(contactObj);
                        contactIdToEmailMap.put(contactObj.Id,contactObj.Name + '-' +contactObj.Email);
                        contactIdToEmailAddressMap.put(contactObj.Id,contactObj.Email);
                    }   
                } else {
                    rcInteralAccount = accountScoreCardHelperObj.getRCInternalAccountInfo();
                    for(Contact contactObj : rcInteralAccount.contacts) {
                        contactList.add(contactObj);
                        contactIdToEmailMap.put(contactObj.Id,contactObj.Name + '-' +contactObj.Email);
                        contactIdToEmailAddressMap.put(contactObj.Id,contactObj.Email);
                    }   
                }
            } catch(Exception ex) {}
        }

        public boolean isMailSent {get;set;}
        public boolean isrecipientnotselected {get;set;}
        public PageReference sendMailToCustomerCall() {
            isrecipientnotselected = true;
            isMailSent = false;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            PageReference pdf = Page.AccountHealthSummaryPDF;
            pdf.getParameters().put('accid',accObj.Id);
            pdf.setRedirect(true); 
            System.debug('>>!!>>'+ pdf);
            Blob blobBody;
            if(Test.isRunningTest()) {
                blobBody = Blob.valueOf('Test'); 
            } else {
                blobBody = pdf.getContentAsPDF(); 
            }
            System.debug('>>!!2>>'+ blobBody);
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('AccountHealthScoreCard :' + accObj.Name + '.pdf');
            efa.setBody(blobBody);
            efa.setContentType('application/pdf');
            efa.setInline(false);

            String[] toAddresses = new String[] {}; 
            if(!string.isBlank(toAddress)) {
                toAddresses.add(toAddress.split('-')[1]);
            }
            for(string str : addToEmailset) {
                toAddresses.add(str);
            }
            if(toAddresses != null && toAddresses.size()>0) {
                mail.setToAddresses(toAddresses);
                isrecipientnotselected = false;
            }

            String[] ccAddresses = new String[] {}; 
            for(string str : ccEmailset) {
                ccAddresses.add(str);
            }
            if(ccAddresses != null && ccAddresses.size()>0) {
                mail.setCcAddresses(ccAddresses);
                isrecipientnotselected = false;
            }

            String[] bccAddresses = new String[] {}; 
            for(string str : bccEmailset) {
                bccAddresses.add(str);
            }
            if(bccAddresses != null && bccAddresses.size()>0) {
                mail.setBccAddresses(bccAddresses);
                isrecipientnotselected = false;
            }

            if(isrecipientnotselected == true) {
                return null;
            } 

            mail.setSenderDisplayName(UserInfo.getName());
            mail.setSubject('Account Health Scorecard :' + accObj.Name);
            mail.setHtmlBody('Account Health ScoreCard : ' + accObj.Name);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});  
            try{             
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                isMailSent = true;
                selectedBccList.clear();
                AllBccOptionsSet.clear();
                selectedCCList.clear();
                AllCCOptionsSet.clear();
                selectedAdditionalToList.clear();
                AllAdditionalToSet.clear();
                toAddress = '';
            } catch(Exception exp){
                isMailSent = false;
            }
            return null; 
        }

        public PageReference exportasPDF() {
            return null;    
        }

        public PageReference redirectToSendMailPage() {
            try {
                PageReference emailPgRef = new PageReference('/apex/AccountHealthScoreCardSendEmail');
                emailPgRef.getParameters().put('accid',accObj.Id);
                emailPgRef.setRedirect(true);
                return emailPgRef;
            } catch(Exception ex) {}
            return null;
        }

        public PageReference cancel() {
            try {
                PageReference emailPgRef = new PageReference('/apex/AccountHealthScoreCard');
                emailPgRef.getParameters().put('accid',accObj.Id);
                emailPgRef.setRedirect(true);
                return emailPgRef;
            } catch(Exception ex) {}
            return null;
        }
        
        public HealthScoreWrapper getHealthScore(Account objAccount){
        HealthScoreWrapper objHealthScoreWrapper = new HealthScoreWrapper();
        try{
	        set<string> setSurveys = new set<string>{ AccountScoreCardHelper.SURVEY_ATTIMPLEMENTATION,AccountScoreCardHelper.SURVEY_IMPLEMENTATION,
	                                                    AccountScoreCardHelper.SURVEY_NEWCUSTOMER,AccountScoreCardHelper.SURVEY_RELATIONSHIP,
	                                                    AccountScoreCardHelper.SURVEY_SUPPORT};
	        list<double> lstLowestCSAT = new list<double>();
	        list<double> lstNewCustomer = new list<double>();
	        list<double> lstRelatioship = new list<double>();
	        list<double> lstImplementation = new list<double>();
	        double dLowestCSAT = 0;
	        double dNewCustomer = 0;
	        double dRelationship = 0;
	        double dImplementation = 0;
	        Integer counter = 0;
	        objHealthScoreWrapper.bLowestCSATNA = false;
	        objHealthScoreWrapper.bSupportNA = false;
	        objHealthScoreWrapper.bNewCustomerNA = false;
	        objHealthScoreWrapper.bRelationshipNA = false;
	        objHealthScoreWrapper.bImplementationNA = false;
	        for(Survey__c objSurvey : AccountScoreCardHelper.getAccountSurvey(objAccount.Id, setSurveys)){
	                
	                if(objSurvey.SurveyType__c == AccountScoreCardHelper.SURVEY_SUPPORT){
	                    //support_overall_sat_eval__c
	                    if(objSurvey.support_overall_sat_eval__c != null){
	                    	dLowestCSAT = dLowestCSAT+objSurvey.support_overall_sat_eval__c;
	                        lstLowestCSAT.add(objSurvey.support_overall_sat_eval__c);
	                    }
	                    
	                    if(counter == 0 && objSurvey.support_overall_sat_eval__c !=null){
	                    	
	                    	//if(objSurvey.support_overall_sat_eval__c != null){
	                    		objHealthScoreWrapper.dLowestCSAT = objSurvey.support_overall_sat_eval__c;
	                    		objHealthScoreWrapper.bLowestCSATNA = true;
	                    	//}
	                    	counter++;
	                    }
	                }
	                if(objSurvey.SurveyType__c == AccountScoreCardHelper.SURVEY_NEWCUSTOMER){
	                	if(objSurvey.sales_overall_sat_eval__c!=null){
	                		dNewCustomer = dNewCustomer+objSurvey.sales_overall_sat_eval__c;
	                    	lstNewCustomer.add(objSurvey.sales_overall_sat_eval__c);
	                	}
	                }
	                if(objSurvey.SurveyType__c == AccountScoreCardHelper.SURVEY_IMPLEMENTATION || objSurvey.SurveyType__c == AccountScoreCardHelper.SURVEY_ATTIMPLEMENTATION){
	                    //Implementation_Advisor_Satisfaction__c
	                    if(objSurvey.Implementation_Advisor_Satisfaction__c!=null){
	                    	dImplementation = dImplementation+objSurvey.Implementation_Advisor_Satisfaction__c;
	                    	lstImplementation.add(objSurvey.Implementation_Advisor_Satisfaction__c);
	                	}
	                }
	                if(objSurvey.SurveyType__c == AccountScoreCardHelper.SURVEY_RELATIONSHIP){
	                	if(objSurvey.Likely_to_Recommend_Rel__c!=null){
	                		dRelationship = dRelationship+objSurvey.Likely_to_Recommend_Rel__c;
	                    	lstRelatioship.add(objSurvey.Likely_to_Recommend_Rel__c);
	                	}
	                    //Likely_to_Recommend_Rel__c
	                }
	               //accObj.RC_Service_name__c 
	            //{!accObj.Number_of_DL_s__c}
	           
	            if(lstLowestCSAT.size()>0){
	            	objHealthScoreWrapper.dSupport = dLowestCSAT/lstLowestCSAT.size();
	            	objHealthScoreWrapper.bSupportNA = true;
	            }
	            
	           
	            if(lstNewCustomer.size()>0 && objAccount.RC_Service_name__c.containsIgnoreCase('OFFICE') && objAccount.Number_of_DL_s__c>=2){
	            	objHealthScoreWrapper.dNewCustomer = dNewCustomer/lstNewCustomer.size();
	            	objHealthScoreWrapper.bNewCustomerNA = true;
	            }
	            
	            if(lstRelatioship.size()>0){
	            	objHealthScoreWrapper.dRelationship = dRelationship/lstRelatioship.size();
	            	objHealthScoreWrapper.bRelationshipNA = true;
	            }
	            
	            if(lstImplementation.size()>0){
	            	objHealthScoreWrapper.dImplementation = dImplementation/lstImplementation.size();
	            	objHealthScoreWrapper.bImplementationNA = true;
	            }
	            
	        }
        }catch(Exception ex){system.debug('ex---------->'+ex.getMessage()+' Line N0--->'+ex.getLineNumber());}
    return objHealthScoreWrapper;
   }
        
  public class HealthScoreWrapper{
    public double dLowestCSAT{get;set;}
    public double dNewCustomer{get;set;}
    public double dRelationship{get;set;}
    public double dSupport{get;set;}
    public double dImplementation{get;set;}
    public boolean bSupportNA{get;set;}
    public boolean bLowestCSATNA{get;set;}
    public boolean bNewCustomerNA{get;set;}
    public boolean bRelationshipNA{get;set;}
    public boolean bImplementationNA{get;set;}
    
  }
}