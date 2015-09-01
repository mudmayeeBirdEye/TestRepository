public class TabSharingCtrlExt {
	/*String IEE = Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');// For IE9 
    
    private static final String userPrefix = Schema.SObjectType.User.getKeyPrefix();
    private static final String groupPrefix = Schema.SObjectType.Group.getKeyPrefix();
    
    public String recordId { get ; set; }
   	public List<string> leftselected{ get;set; }
    public List<string> rightselected{ get;set; }
    public String guValue { get; set; }
    public String shareType { get; set; }
   
    
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
    Set<String> originalvalues = new Set<String>();
    Set<String> contactValues = new Set<String>();
    Set<Id> usersID = new Set<ID>();
    Set<String> selValue;
    
    Map<id , Group> groupMap {  get ; set ; } 
    Map<id , User> userMap {  get ; set ; } 
    Map<id , GroupMember > groupMemberMap ;
    Map<String , String> guMap {  get ; set ; }
    
    Intranet_Main_Tab__c tab; */

   // public PageReference find() {
     /*  if( guValue != null && guValue.trim() != ''  ){
           String searchString = '%'+guValue+'%';
           if(shareType == 'pgroup' ) {
                 groupMap = new Map<id , Group>([Select 
                 									Name , 
                 									id   
                 								From 
                 									Group 
                 								Where 
                 									type = 'Regular' 
                 									AND 
                 										Name != null 
                 									AND 
                 										Name Like : String.escapeSingleQuotes(searchString) 
                 										Limit : 100]);    
           }
           if(shareType == 'user' ) {
                 userMap = new Map<id , User>([Select 
                 									Name , 
                 									Id ,
                 									UserRole.name,
                 									Manager.name,
                 									Profile.name,
                 									email,
                 									Manager.email 
                 								From 
                 									User 
                                                Where 
                                                		Profile.Name !=:'Customer Portal User' 
                                                	AND  
                                                		Profile.Name !=:'Chatter Free User' AND IsActive=true
                                               		AND 
                                               			ID !=: tab.OwnerId 
                                               		AND 
                                               			Name Like : String.escapeSingleQuotes(searchString) 
                                               		Order By 
                                               			Name 
                                               			Limit : 100]);        
           }
       } 
       guValue = null;
       getunSelectedValues();
       return null; */
   // }
    
    public TabSharingCtrlExt () {
    	/*	 shareType = 'pgroup';
     		Set<id> groupIds = new Set<id>();
     
	     groupMap = new Map<id , Group>([Select 
	     									Name, 
	     									id   
	     								From 
	     									Group 
	     								Where 
	     									type = 'Regular' 
	     								AND 
	     									Name != null
	     									Limit : 100	]);
	     
				     for(Group g : groupMap.values()) {
				   //  		groupIds.add(id);
				     }
   					 groupMemberMap = new Map<id , GroupMember>();
				    for (GroupMember gm : [Select UserOrGroupId , GroupId From GroupMember ]) {
				  	    groupMemberMap.put( gm.GroupId , gm );	
				    }
    				 recordId = ApexPages.currentPage().getParameters().get('parentid');
        
     guMap = new Map<String , String>();
     
     tab = [Select 
     			Name,
     			id,
     			OwnerId 
     		From 
     			Intranet_Main_Tab__c 
     		Where 
     			id=:recordId];
     
     userMap = new Map<id , User>([Select 
     									Name,
     									Id,
     									UserRole.name,
     									Manager.name,
     									Profile.name,
     									email,
     									Manager.email 
     								From User 
     								Where 
     										Profile.Name !=:'Customer Portal User' 
     									AND  
     										Profile.Name !=:'Chatter Free User' 
     									AND 
     										IsActive=true 
     									AND 
     										ID !=: tab.OwnerId
         									Order By Name 
         									Limit : 100]);*/
  
    
    }

  //  public PageReference selectclick(){
      /*  rightselected.clear();
        for(String s : leftselected){
            rightvalues.add(s);
        }
        return null; */
  //  }
    
   // public PageReference unselectclick(){
      /*  leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
        }
        return null; */
  //  }
    
  // public List<SelectOption> getunSelectedValues(){
    /*   List<SelectOption> options = new List<SelectOption>();
       List<string> tempList = new List<String>();
           if( shareType == 'pgroup' ) {
                    for(Group g : groupMap.values() ){
                      originalvalues.add(g.id);
                    }
           }
           if(shareType == 'user'){
                  for(User u : userMap.values() ){
                      originalvalues.add(u.id);
                    }
           }
              leftselected = new List<String>();
              rightselected = new List<String>();
              leftvalues.addAll(originalValues);
              tempList.addAll(leftvalues);

           for(String s : tempList ) {
                if ( shareType == 'pgroup' && s.startsWith(groupPrefix)) {
                  try {  
                  	options.add(new SelectOption(s ,  'Group : '+groupMap.get(s).Name)); 
                  	} catch(Exception ex){
                 	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Problem With : ' +ex.getMessage()  ));
                  }
                   try {   
                   	guMap.put( s ,groupMap.get(s).Name ); 
                   	} catch(Exception ex){
                  	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Problem With : ' +ex.getMessage()  ));
                  }
                }
                if ( shareType == 'user' && s.startsWith(userPrefix)) {
                	try { 
                	    options.add(new SelectOption( s , 'User : '+userMap.get(s).Name ) );
                        guMap.put( s , userMap.get(s).Name ); 
                     }catch(Exception ex){
                 	 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ' Problem With : ' +ex.getMessage()  ));
                  }
                }
             }   
        return options; */
   //  }

   // public List<SelectOption> getShareWith(){
       /* List<SelectOption> options1 = new List<SelectOption>();
        options1.add(new SelectOption('user','User'));
        options1.add(new SelectOption('pgroup','Public Group'));
        return options1; */
   // }
   
  //  public List<SelectOption> getSelectedValues(){
      /*  selValue = new Set<String>();
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);

           for(String s : tempList){
              options1.add(new SelectOption( s , guMap.get(s)));
              selValue.add(s); 
           }
        return options1; */
  //  }

  // public PageReference onShare() {
   	/*	try {
	   	 	Set<id> guSId = new Set<id>();
	     	if(selValue != null && selValue.size() > 0){
	          List<String> tempList = new List<String>();
	          tempList.addAll(selValue);
	              for(String gpid : tempList ) {
	                 if(! manualShareRead( recordId , gpid ) ) {
	                 	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sharing Problem With : ' +groupMap.get(gpid).Name ));
	                 } else {
	                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Sharing Success With : ' +guMap.get(gpid) ));
		                  	if( String.valueOf(gpid).startsWith(groupPrefix) ){
		                   		 getUsers(gpid);
		                    }
		                    if(String.valueOf(gpid).startsWith(userPrefix)){
		                    	 usersID.add(gpid);
		                    }
	                  }
	              }
	             List<Id> guList = new List<Id>();
	             guList.addAll(guSId); 
	             if(!usersID.isEmpty()){
	                sendEmail(setEmail(usersID ),tab) ;	
	             }
	           }
   		} catch(Exception ex) {
  			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()+','+ex.getLineNumber()));
    		return null;
  		} 
     return null;  */
 //	}
     
  //public String[] getEmailIds( ID guID){
     /* if(String.valueOf(guID).startsWith(userPrefix) ) {
            List<User> userList = [Select Email From User Where  Id =: guID];
            String[] emails = new String[userList.size()];
            Integer i = 0;
            
            for (User u : userList ) {
                emails[i] = u.email;    
                i++;
            }
            return emails;
        }
        return null;*/
 // }

 //public void getUsers(ID ids){ 	
	/*GroupMember temp = groupMemberMap.get(ids);
	  if(temp != null) {	
		 if( String.valueOf( temp.UserOrGroupId).startsWith(groupPrefix) ){
  			getUsers(temp.UserOrGroupId);
  		 }  	
  		 if( String.valueOf( temp.UserOrGroupId ).startsWith(userPrefix) ){
  			usersID.add( temp.UserOrGroupId );
  		 }
	  }*/
 //}
 
 //public String[] setEmail(Set<ID> ids){
            /*  List<User> uEmail = [Select email from User where Id IN: ids ];
              String[] emails = new String[uEmail.size()];
              Integer ii =0;
              for(User u: uEmail){
                  emails[ii] = u.email;
                  ii++; 
              }
            return emails;*/
 //}

 //public boolean manualShareRead(Id recordId, Id userOrGroupId) { 
	/*try {
	      Intranet_Main_Tab__Share tabShr  = new Intranet_Main_Tab__Share();
	      tabShr.ParentId = recordId;
	      tabShr.UserOrGroupId = userOrGroupId;
	      tabShr.AccessLevel = 'Edit';
	      tabShr.RowCause = Schema.Intranet_Main_Tab__Share.RowCause.Manual;
	      Database.SaveResult sr = Database.insert(tabShr,false);
	      if(sr.isSuccess()){
	             return true;
	      }
	      else {
	           Database.Error err = sr.getErrors()[0];
	            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
	                  err.getMessage().contains('AccessLevel')){
	              return true;
	         }
	         else{
	             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sharing Problem With : ' +err  ));
	            return false;
	         }
	    }
  } catch(Exception ex) {
  	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
    return null;
  }
  return false;*/
//}
   /*Send An Email*/
   // public void sendEmail(String[] email, Intranet_Main_Tab__c  tab){
      /* try{
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Content Sharing Notification');
        mail.setToAddresses(email);
        mail.setHtmlBody('<style type="text/css">'
                    +'.font_label{color:Teal;font-weight:bold;font-size:12px;font-family:Arial;}'
                    +'.font_text{color:Black;font-weight:normal;font-size:12px;font-family:Arial;}'
                    +'.trStyle{background-color:White;}'
                    +'.link{color:blue;font-weight:normal;font-size:12px;font-family:Arial;font-style:underline;}'
                    +'</style>'
                    +'One of the Tab record Share With you. You can update The content of the records ,<br/><br/>'
                    +'<table cellpadding="2" cellspacing="5" style="background-color:#e0e0e0;" width="100%">'
                    +'<tr class="trStyle">'
                    +'<td class="font_label" colspan="2">'
                    +'Tab Name : <font class="font_text">'+tab.Name+'</font>'
                    +'</td></tr><tr class="trStyle"><td class="font_label" colspan="2">'
                    +'<font class="font_text"></font></td></tr>'
                    +'<tr><td colspan="2">'
                    +'<a href=\'https://cs12.salesforce.com/'+tab.Id+'\' class=link>'
                    +'Please click here to access the Tab Content:</a></td></tr></table>'
                    +'<br/>'
                    +'Thanks<br/>'
                    +'RingCentral'); 
          mail.setSaveAsActivity(false);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
       //} catch(Exception ex){
         //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error , 'Email Sending Fail: '+ ex.getMessage()));
      //}   */         
   // }  

   /*Test Methods*/ 
   /*@isTest(SeeAllData=true)
   static  void TabSharingCtrlExtTest() {
   	TabSharingCtrlExt extTest = new TabSharingCtrlExt();
   /*	List<Intranet_Main_Tab__c> intraList = new List<Intranet_Main_Tab__c>();
	   
	   for(Integer i=0; i<10; i++) {
	  	  Intranet_Main_Tab__c intraTest = new Intranet_Main_Tab__c();
	  	  intraTest.IsDisabled__c = false;
	  	  intraTest.Name ='test';
	  	  intraTest.IsPublic__c = true;
	   	  intraTest.Position_Type__c ='Top';
	   	  intraList.add(intraTest);
	   }  
	  insert intraList;
      
      	    ApexPages.currentPage().getParameters().put('parentid',intraList[0].id);
   			TabSharingCtrlExt extTest = new TabSharingCtrlExt();
   			extTest.getunSelectedValues(); 
   			extTest.selectclick();
   			extTest.unselectclick();
   			extTest.getShareWith();
			extTest.getSelectedValues();
			extTest.onShare();
			String userOrGroupId = [Select Name , id   From Group Where type = 'Regular' AND Name != null Limit 1].id;
			extTest.manualShareRead( intraList[0].id , userOrGroupId);
			
			Map<id, user> userMap = new Map<id,user>([Select id from User limit 10]);
			Map<id, Group> grMap = new Map<id,Group>([Select id from Group Where type = 'Regular' AND Name != null limit 10]);
			
			extTest.getEmailIds(userMap.values()[0].id);
			extTest.setEmail(userMap.keySet());
			
			extTest.guValue ='tab';
			extTest.shareType ='pgroup';
			extTest.find();
			
			extTest.guValue ='india';
			extTest.shareType ='user';
			extTest.find();
			List<String> emails = new List<String>();
			emails.add('a@test.com');
			emails.add('b@teset.com');
			
			extTest.sendEmail( emails, intraList[0]);
			set<String> stringSet = new Set<String>();
			
			for(ID s : grMap.keySet()){
				stringSet.add(s);
			}
			for(ID s : userMap.keySet()){
				stringSet.add(s);
			}
			
			 extTest.selValue.addAll( stringSet);
			extTest.onShare();*/
			
  //}
}