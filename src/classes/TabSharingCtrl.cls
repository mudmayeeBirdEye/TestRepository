public class TabSharingCtrl {

	/* IEE = Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');// For IE9 

    public List<Intranet_Main_Tab__Share> tabShareList{ get ; set;}
    public List<TabShareWrapper>  tabSList{ get ; set;}
    public Map<ID , String> nameOfUG; 
    public Boolean isValidUser { get; set; }
	
	private String recordId;
	private static final String groupPrefix = Schema.SObjectType.Group.getKeyPrefix();*/
	   
    public TabSharingCtrl(ApexPages.StandardController controller) {
      
    }
    
  /* public List<TabShareWrapper> getTabShare() {
   	   	    
   	   tabShareList = [Select 
   	    					id, 
   	    					RowCause, 
   	    					UserOrGroupId , 
   	    					AccessLevel 
   	    				From 
   	    					Intranet_Main_Tab__Share 
   	    				Where 
   	    					ParentID =:recordId];
        
        tabSList = new List<TabShareWrapper>();
        nameOfUG = new Map<ID , String>();
        
        Set<ID> userOrGroupID = new Set<ID>();
        
        for(Intranet_Main_Tab__Share ts : tabShareList ){
                 userOrGroupID.add(ts.UserOrGroupId);  
        }
        if(!userOrGroupID.isEmpty()){
        	for(Group grup : [Select Name From Group Where id IN : userOrGroupID ]){
        		nameOfUG.put( grup.Id , grup.Name );
        	 }		
        	 for(User usr : [Select Name From User Where id IN : userOrGroupID ]){
        		nameOfUG.put( usr.Id , usr.Name );
        	 }		
        }
        for(Intranet_Main_Tab__Share tabshare : tabShareList ){
              tabSList.add(new TabShareWrapper( tabshare , nameOfUG.get( tabshare.UserOrGroupId) ));
        }	
   	  return tabSList;
   } */
   
  /* public PageReference onCancel() {
       PageReference pageRef = page.tabCreationView;
       pageRef.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));     
       return  pageRef; 
    } */
    
 /*  public PageReference delShare() {
       Set<ID> delIds = new Set<ID>();
       List<Integer> index = new List<Integer>();
     
        for(Integer i=0 ; i <tabSList.size();i++ ){
        	if( tabSList.get(i).isDel == true ){
        		 delIds.add(tabSList.get(i).tabSh.id);
        	}
        }
        
        if( delIds.isEmpty() ) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'First select atleast one records.'));
              return null; 
        }
        
      	try {
             Database.delete([Select id from Intranet_Main_Tab__Share where id IN: delIds], false);
             return   null; 
         } catch (Exception ex) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Deletion Problem : ' +ex.getMessage() )); 
            return   null;   
        }
      getTabShare();
      return  null; 
    } */
    
   /* public PageReference userValidate(){
    	isValidUser = true;
    	String SYSADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
    	String Owner_id = [Select Owner.ID From Intranet_Main_Tab__c Where id =:recordId].Owner.ID;
      	if(!(Owner_id == UserInfo.getUserId() || SYSADMIN_PROFILE_ID == UserInfo.getProfileId()) ) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You Can not Share This Record to Anyone Because You Are Not An Admin or Owner Of This Record.'));
    		 isValidUser = false;
    		return ApexPages.CurrentPage(); 
    	}
    	return null;    
    } */
    
    /* public class TabShareWrapper{
        public Boolean isDel { get ; set ;}
        public Intranet_Main_Tab__Share  tabSh { get; set; }
        public String userType { get; set; }
        public String name { get; set; }
        
        public TabShareWrapper(Intranet_Main_Tab__Share ts , String typeName) {
            tabSh = ts;
            isDel = false;
            userType = ( String.valueOf(ts.UserOrGroupId).startsWith(groupPrefix) ? 'Public Group' : 'User' );
            name =  typeName;
        }
    }*/
   
   /*Test Method
   -------------------------------------------------------------------------
   */ 
 
   /*@isTest(SeeAllData=true)
   static  void TabSharingCtrlTest() {
   	
   	  Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
	  intraTest.IsDisabled__c = false;
	  intraTest.Name ='Home';
	  intraTest.IsPublic__c = true;
	  intraTest.Position_Type__c ='Top';
	  intraTest.Content__c = '';
	  insert intraTest;
	  
	  ApexPages.StandardController sc = new ApexPages.StandardController(intraTest);
	  TabSharingCtrl tabSharingTest = new TabSharingCtrl(sc); 
	  
	  /*tabSharingTest.getTabShare();
	  tabSharingTest.onCancel();
	  tabSharingTest.userValidate();
	  tabSharingTest.delShare();*/
	  
   //}
}