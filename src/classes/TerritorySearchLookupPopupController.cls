public with sharing class TerritorySearchLookupPopupController 
{
    public String query {get; set;}
    public List<User> Users {get; set;}
    public String Accountid {get; set;}
    public String SFUserId {get; set;}
    public String SFChecked {get;set;}
    public String tid {get; set;}
    public String ch {get; set;}
    public List<Account> ac {get; set;}
    
    public PageReference runQuery()
    {
        try {
        	if(String.isNotBlank(query)){
	            List<List<User>> searchResults=[FIND :query IN ALL FIELDS RETURNING User (id, name where isactive=true and usertype='Standard')];
	            if(searchResults != null && searchResults.size() > 0){
	            	Users =searchResults[0];
	            }else{
	            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Record not found!'));
	            }
        	}
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error! ' + e));
        }  
        return null;
    }
    
    public PageReference updateTerritory()
    {
        try {
                tid = Apexpages.currentPage().getParameters().get('myParam');
                ch = Apexpages.currentPage().getParameters().get('myParam3');
                SFChecked = Apexpages.currentPage().getParameters().get('myParam2');
                if (ch == 'to'){
                if(tid.length() < 20){
                    Territory_Data__c o = [Select id from Territory_Data__c where id=:tid];
                    if (o != null){
                        o.Territory_Owner__c = SFUserId;
                        o.Processed__c = true;
                            if(SFChecked.contains('transferaccounts'))
                                o.Transfer_Accounts__c = true;
                            if(!SFChecked.contains('transferaccounts'))
                                o.Transfer_Accounts__c = false;
                                
                            if(SFChecked.contains('transferleads'))
                                o.Transfer_Leads__c = true;
                            if(!SFChecked.contains('transferleads'))
                                o.Transfer_Leads__c = false;
                            
                            if(SFChecked.contains('transferopps'))
                                o.Transfer_Opportunities__c = true;
                            if(!SFChecked.contains('transferopps'))
                                o.Transfer_Opportunities__c = false;
                            
                        update o;
                    }
                }
                else
                {
                String[] chars = tid.split(',');
                     
                     for (List<Territory_Data__c> to:  [SELECT id, name FROM Territory_Data__c where id in :chars]) {
                     for(Territory_Data__c c : to) {
                        c.Territory_Owner__c  = SFUserId;
                        c.Processed__c = true;
                            if(SFChecked.contains('transferaccounts'))
                                c.Transfer_Accounts__c = true;
                            if(!SFChecked.contains('transferaccounts'))
                                c.Transfer_Accounts__c = false;
                                
                            if(SFChecked.contains('transferleads'))
                                c.Transfer_Leads__c = true;
                            if(!SFChecked.contains('transferleads'))
                                c.Transfer_Leads__c = false;
                                
                            if(SFChecked.contains('transferopps'))
                                c.Transfer_Opportunities__c = true;
                            if(!SFChecked.contains('transferopps'))
                                c.Transfer_Opportunities__c = false;
                            
                     }
                    update to;
                }
                }
                
                }
                
                if (ch == 'ao'){
                if(tid.length() < 20){
                    Territory_Data__c o = [Select id from Territory_Data__c where id=:tid];
                    if (o != null){
                        o.Alternate_Owner__c = SFUserId;
                        o.Processed__c = true;
                            if(SFChecked.contains('transferaccounts'))
                                o.Transfer_Accounts__c = true;
                            if(!SFChecked.contains('transferaccounts'))
                                o.Transfer_Accounts__c = false;
                                
                            if(SFChecked.contains('transferleads'))
                                o.Transfer_Leads__c = true;
                            if(!SFChecked.contains('transferleads'))
                                o.Transfer_Leads__c = false;
                            
                            if(SFChecked.contains('transferopps'))
                                o.Transfer_Opportunities__c = true;
                            if(!SFChecked.contains('transferopps'))
                                o.Transfer_Opportunities__c = false;
                            
                        update o;
                    }
                }
                else
                {
                String[] chars = tid.split(',');
                     
                     for (List<Territory_Data__c> to:  [SELECT id, name FROM Territory_Data__c where id in :chars]) {
                     for(Territory_Data__c c : to) {
                        c.Alternate_Owner__c = SFUserId;
                        c.Processed__c = true;
                            if(SFChecked.contains('transferaccounts'))
                                c.Transfer_Accounts__c = true;
                            if(!SFChecked.contains('transferaccounts'))
                                c.Transfer_Accounts__c = false;
                                
                            if(SFChecked.contains('transferleads'))
                                c.Transfer_Leads__c = true;
                            if(!SFChecked.contains('transferleads'))
                                c.Transfer_Leads__c = false;
                                
                            if(SFChecked.contains('transferopps'))
                                c.Transfer_Opportunities__c = true;
                            if(!SFChecked.contains('transferopps'))
                                c.Transfer_Opportunities__c = false;
                            
                     }
                    update to;
                }
                }
                
                }
                
        }  catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error! ' + e));
        }  
                
        return null;
    }
}