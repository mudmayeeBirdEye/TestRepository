public with sharing class ProfileObjectAccess {
    
    public list<selectOption> display { get; set; }
    public string selectedId {get;set;}
    
    public map<Id, Profile> mProf = new map<Id, Profile>();
    
    public list<wrapper> lWrap {get;set;}
    
    public ProfileObjectAccess(){
        //lWrap = new list<wrapper>();  
        display= new list<selectOption>();    
        mProf = new map<Id, Profile>([SELECT Id, Name FROM Profile]);
        
        for (Id idKey : mProf.keyset()){
            string sName = mProf.get(idKey).name;
            display.add(new SelectOption(idKey,sName));
        }       
    }
  
    public PageReference DisplayPermission(){

        list<ObjectPermissions> op = [SELECT Parent.ProfileId, sObjectType, PermissionsCreate, PermissionsRead, PermissionsEdit, 
                                             PermissionsDelete, PermissionsViewAllRecords, PermissionsModifyAllRecords 
                                      FROM ObjectPermissions 
                                     WHERE Parent.ProfileId =: this.selectedId];
        system.debug('SELECTED ID ------------------------' + this.selectedId);
        
                     lWrap = new list<wrapper>();
                     
        for(ObjectPermissions o: op){
            
            wrapper wProf = new wrapper();                  
            
            wProf.ProfileId = o.Parent.ProfileId;
            wProf.ProfileName = mProf.get(o.Parent.ProfileId).name;
            wProf.ObjectName = o.sObjectType;
            wProf.hasCreate = o.PermissionsCreate;
            wProf.hasRead = o.PermissionsRead;
            wProf.hasEdit = o.PermissionsEdit;
            wProf.hasDelete = o.PermissionsDelete;
            wProf.hasViewAll = o.PermissionsViewAllRecords;
            wProf.hasModifyAll = o.PermissionsModifyAllRecords;
            lWrap.add(wProf);
        }
        
        return null;

    }
    
    public class wrapper{   
        public string ProfileId {get;set;}
        public string ProfileName {get;set;}
        public string ObjectName {get;set;}
        public boolean hasCreate {get;set;}
        public boolean hasRead {get;set;}
        public boolean hasEdit {get;set;}
        public boolean hasDelete {get;set;}
        public boolean hasViewAll {get;set;}
        public boolean hasModifyAll {get;set;}
    }
   
}