public with sharing class multiselect {


    public Map<String, String> globalContactMap{get;set;}
    public Map<String, String> varContactMap{get;set;}
    
    public List<String> globalSelectedList{get;set;}
    public List<String> globalContactList{get;set;}
    public List<String> OptedOutOfEmail{get;set;}
    
    
    public Set<String> allAdditionalToList{get;set;}
    public List<String> selectedAdditionalToList{get;set;}
    
    public Set<String> allCCList{get;set;}
    public List<String> selectedCCList{get;set;}
    
    public Set<String> allBccList{get;set;}
    public List<String> selectedBccList{get;set;}
    
    public Case temp{get;set;}
    public boolean msg1 { get; set;}
    public boolean msg2 { get; set;}
    public boolean msg3 { get; set; }
    public boolean msg4 { get; set; }
    public boolean byPass { get; set; }
    public boolean disable { get; set; }
    
    public String toAddress{get;set;}
    
    public map<String, String> toContactmap{get;set;}
    public map<String, String> addToContactMap{get;set;}
    public map<String, String> bccContactMap{get;set;} 
    public map<String, String> ccContactMap{get;set;}
    
    
    public String objectId;
    public String RobjectId;
    public String relName{get;set;} 
    public String RAccount_Id = null;
    public String conatct_Id = null;
    public String objectType = null;
    public String lead_email = null;
    
    public Boolean isEmailValidated{get;set;}
    
 /*   private Boolean isToEmailValidated = true;
    private Boolean isAddToEmailValidated = true;
    private Boolean isCCEmailValidated = true;
    private Boolean isBCCEmailValidated = true;*/
   
    
    
   /* public String finalList{get;set;} */
   
    /*Constructor */
    public void clearList() {
        varContactMap = new Map<String, String>();
        globalContactMap = new Map<String, String>();
        
        allAdditionalToList = new Set<String>();
        selectedAdditionalToList = new List<String>(); 
        
        allCCList = new Set<String>();
        selectedCCList = new List<String>();
        
        allBccList = new Set<String>();
        selectedBccList = new List<String>();
        
        globalSelectedList = new List<String>();
        globalContactList = new List<String>();
        temp = new Case();
        toAddress = null;
        
        toContactmap = new Map<String, String>();
        addToContactMap = new Map<String, String>();
        ccContactMap = new map<String, String>();
        bccContactMap = new map<String, String>();
        OptedOutOfEmail = new List<String>();
        System.debug('##### = CALING = ######');
        isEmailValidated = true;
        msg3 = false;
        disable = true;     
    }
    
    public multiselect() {
        clearList();
               
                   RAccount_Id = ApexPages.currentPage().getParameters().get('acc_id');
                   objectId = ApexPages.currentPage().getParameters().get('p3_lkid');
                   relName = ApexPages.currentPage().getParameters().get('p3');
                   conatct_Id = ApexPages.currentPage().getParameters().get('p2_lkid');
                   RobjectId = ApexPages.currentPage().getParameters().get('view');
                   objectType = ApexPages.currentPage().getParameters().get('rtype');
                   
                  byPass = false; 
                  if(objectType != null &&  objectType!='' && objectType =='00Q') {
                	lead_email = ApexPages.currentPage().getParameters().get('lemail');
                	
                	for(Contact contactObj:[SELECT id, Name, Email, Account.Name, HasOptedOutOfEmail  From Contact 
                		WHERE  Email!=null AND Email =: lead_email ORDER BY Name ASC]) {
                		 varContactMap.put(contactObj.Id, contactObj.Name+'-'+contactObj.Email);
                         globalContactList.add(contactObj.Id);
                	}
                	
                	if(varContactMap.size() == 0) {
                	   	varContactMap.put(RobjectId,lead_email);	
	                	globalContactList.add(RobjectId);
	                	byPass = true;
	                	disable = false;
                	}
                 } else {
                	msg4 = true;
                 }     
                 
                if(RAccount_Id != null &&  RAccount_Id  != ''){   
                  temp.SEAccount__c = RAccount_Id;
                        for(Contact contactObj:[Select id, Name,Email, Account.Name, HasOptedOutOfEmail  From Contact  Where
                        	Email!=null AND AccountId =: RAccount_Id ORDER BY Name ASC]){
                                // originalvalues.add(contactObj.id);
                                varContactMap.put(contactObj.Id, contactObj.Name+'-'+contactObj.Email);
                                globalContactList.add(contactObj.Id);
                        }
                }else{
                msg2 = true;
                }
        
    }
  /*Searching Contact*/
    public PageReference searchContact() {
        msg2 = false;
       if(temp != null && temp.SEAccount__c !=null){
          globalContactList.clear();
          for(Contact conObj:[Select Id, Name, Email From Contact Where Email!=null AND AccountId =: temp.SEAccount__c Order By Name ASC]){
             varContactMap.put(conObj.Id, conObj.Name+'-'+conObj.Email);
             globalContactList.add(conObj.Id);
          }      
          if(varContactMap.size() != 0) {
                globalContactMap.putAll(varContactMap);        
          }
       } 
    return null;
    }
   /*End Serching*/
    public List<SelectOption> getGlobalContactOptions(){
        List<SelectOption> options = new List<SelectOption>();
         for(String Id: globalContactList) {
             options.add(new SelectOption(Id,varContactMap.get(Id)));
         }
        return options;
    }
     
    public PageReference setToAddress() {
        
        msg1 = false;
        
        Set<String> tempSet = toContactmap.keySet();
        tempSet.retainAll(globalSelectedList);
        
        if(globalSelectedList == null || tempSet.size()> 0) {
            isEmailValidated = true;
        } else {
            isEmailValidated = false;
        }
        
        for(String Id : globalSelectedList){
           toAddress = varContactMap.get(Id);
           toContactmap.put(Id, toAddress);
           break;
        }
        return null;
    }
    /* To Address*/ 
    public PageReference removeToAddress() {
        msg1 = false;
        
        toContactmap.clear();
        toAddress = null;
        return null;
    }
    
     /*Additional To */
    public PageReference setAdditionalTo(){
        msg1 = false;
        
        Set<String> tempSet = addToContactMap.keySet();
        tempSet.retainAll(globalSelectedList);
        if(globalSelectedList == null || tempSet.size()> 0) {
           isEmailValidated = true;
        } else {
          isEmailValidated = false;
        }
        
        for(String Id : globalSelectedList){
            allAdditionalToList.add(Id);
            addToContactMap.put(Id, varContactMap.get(Id));
        }
      System.debug('########Additional Contact Map ' + addToContactMap.values());
        return null;
    }
    
    public List<SelectOption> getAllAdditionalTo(){
        List<SelectOption> options = new List<SelectOption>();
        try {
        for(String id:  allAdditionalToList) {
                 options.add(new SelectOption(id,varContactMap.get(id)));
                 if(!addToContactMap.containsKey(id)) {
                    addToContactMap.put(id, varContactMap.get(id));
                 }
         }
        } catch(Exception e){}
        return options;
    }
    
    
     public PageReference removeAdditionalTo(){
         msg1 = false;
         
        for(String Id : selectedAdditionalToList){
            allAdditionalToList.remove(Id);
            addToContactMap.remove(Id);
        }
        
        selectedAdditionalToList.clear();
        return null;
    }
    
    
    /* CC Panel*/
     
    public PageReference setCCList(){
        msg1 = false;
        Set<String> tempSet = ccContactMap.keySet();
        tempSet.retainAll(globalSelectedList);
        if(globalSelectedList == null || tempSet.size()> 0) {
           isEmailValidated = true;
        }  else {
          isEmailValidated = false;
        }
       for(String Id : globalSelectedList){
            allCCList.add(Id);
            ccContactMap.put(Id, varContactMap.get(Id));
        }
      System.debug('CC Contact Map ' + ccContactMap.values());   
        return null;
    }
    
    public List<SelectOption> getAllCCOptionsList(){
        List<SelectOption> options1 = new List<SelectOption>();
        try {
         for(String Id : allCCList) {
                options1.add(new SelectOption(Id,varContactMap.get(Id)));
                if(!ccContactMap.containsKey(Id)) {
                    ccContactMap.put(Id, varContactMap.get(Id));
                }
         } 
        } catch(Exception e) {}
        return options1;
    }
    
    public PageReference removeCCList(){
        msg1 = false;
    
        for(String Id : selectedCCList){
            allCCList.remove(Id);
            ccContactMap.remove(Id);
        }
        selectedCCList.clear();
        return null;
    }
    
    /* BCC Panel*/
    
     public PageReference setBccList(){
         msg1 = false;
        Set<String> tempSet = bccContactMap.keySet();
        tempSet.retainAll(globalSelectedList);
        if(globalSelectedList == null || tempSet.size()> 0) {
         isEmailValidated = true;
        }  else {
           isEmailValidated = false;
        }
        for(String Id : globalSelectedList){
            allBccList.add(Id);
            bccContactMap.put(Id, varContactMap.get(Id));
        }
       System.debug('#############BCC Contact Map ' + bccContactMap.values()); 
        return null;
    }
    
     public PageReference removeBccList(){
         msg1 = false;
        for(String Id: selectedBccList){
            allBccList.remove(Id);
            bccContactMap.remove(Id);
        }
        selectedBccList.clear();
        return null;
    }
    
     public List<SelectOption> getAllBccOptionsList(){

        List<SelectOption> options1 = new List<SelectOption>();
        for(String Id : allBccList) {
            options1.add(new SelectOption(Id,varContactMap.get(Id)));
            if(!bccContactMap.containsKey(Id)) {
                bccContactMap.put(Id, varContactMap.get(Id));
            }
            /*emailBcc.add(Id);*/
          }
      if(options1 == null)
            options1.add(new SelectOption(null,varContactMap.get(null)));  
      return options1;
    }
    
    
    
    /*Email Author Redirect*/
   public PageReference emailAuthor(){
       
       /*if(!isToEmailValidated || !isAddToEmailValidated || !isCCEmailValidated || !isBCCEmailValidated){
           isEmailValidated = false;
           return null;
       }*/
       
     System.debug('#################### = '+isEmailValidated);
        
        if(!isEmailValidated){
                isEmailValidated = false;
                msg3 = false;
             return null;
        }
        
          
        List<Contact> temp_emailAddTO = new List<Contact>();
        List<Contact> temp_emailCc    = new List<Contact>();
        List<Contact> temp_emailBcc   = new List<Contact>();
                  
        
       System.debug('#########-->['+addToContactMap.keySet()+']');  
       System.debug('#########-->['+ccContactMap.keySet()+']');
       System.debug('#########-->['+bccContactMap.keySet()+']');
       
       Integer i = 0;
       Integer tempTo =0;
       
       String emailAddTO_k       = '';
       String rightselectedcc_k  = '';
       String rightselectedbcc_k = '';
          
       try{   
       if(addToContactMap.size()>0){
       temp_emailAddTO = [ Select Name, Email, HasOptedOutOfEmail From Contact Where ID IN: allAdditionalToList AND Email != null];
         i = temp_emailAddTO.size();
          
       tempTo = 1;
      
        for(Contact c1:temp_emailAddTO ){
        
            if(i == tempTo){
                emailAddTO_k += c1.Email;
            }else{
                emailAddTO_k += c1.Email+';';
            }
            
          tempTo++;  
        }
       } 
       }catch(Exception e){
        System.debug('Exception:Additional TO :-'+e);
       } 
        
   
       try{ 
        if(ccContactMap.size()>0){
            temp_emailCc =  [ Select Name, Email, HasOptedOutOfEmail From Contact Where ID IN: allCCList AND Email!=null];
        
        i = temp_emailCc.size();
        tempTo = 1;
                
            for(Contact c2:temp_emailCc){
                if(i == tempTo){
                   rightselectedcc_k += c2.Email;
                }else{
                   rightselectedcc_k += c2.Email+';';
                }
                tempTo++;  
            }
         } 
       }catch(Exception e){
        System.debug('Exception:CC :-'+e);
       }
        
      
        try{
       if(bccContactMap.size()>0){  
            
            temp_emailBcc = [Select Name, Email, HasOptedOutOfEmail From Contact Where ID IN: allBccList AND Email!=null];
            
            i = temp_emailBcc.size();
            tempTo = 1;
       
        
        for(Contact c3: temp_emailBcc){
            
            if(i == tempTo){
               rightselectedbcc_k += c3.Email;
            }else{
               rightselectedbcc_k += c3.Email+';';
            }
            tempTo++;  
         }
        }         
       }catch(Exception e){
            System.debug('Exception:BCC TO :-'+e);
        }
      /*Getting STD Email Author page*/  
      
       PageReference emailAuthorPage = new PageReference('/_ui/core/email/author/EmailAuthor');
              
        if(toContactmap != null && toContactmap.size() > 0 ){
                 List<String> ids = new List<String>();
                 ids.addAll(toContactmap.keySet());
           
                 emailAuthorPage.getParameters().put('p2_lkid',ids[0]);
        }
       
        if(objectId != null){
             emailAuthorPage.getParameters().put('p3_lkid',objectId);
             if(objectId.startsWith('001')){
             acc_name = [Select Name From Account Where id =: objectId limit 1].Name;
                     emailAuthorPage.getParameters().put('p3',acc_name);
             }        
        }
     
               
       emailAuthorPage.getParameters().put('retURL',RobjectId);
        
        
       System.debug('##'+emailAddTO_k);
       System.debug('###'+rightselectedcc_k);
       System.debug('####'+rightselectedbcc_k);
     
        
        /*for Additional Field*/
        if(emailAddTO_k != ''){
            emailAuthorPage.getParameters().put('p24',emailAddTO_k);
        } 
        /*for CC Field*/
        if(rightselectedcc_k !=''){
            emailAuthorPage.getParameters().put('p4',rightselectedcc_k);
        }
        /*for BCC Field*/
        if(rightselectedbcc_k !=''){
            emailAuthorPage.getParameters().put('p5',rightselectedbcc_k);
        }
        
        emailAuthorPage.setRedirect(true);
        
        System.debug('------------->'+emailAuthorPage.getUrl());
        
        
        return emailAuthorPage;
        
     
     }
     
   /**Check For  OptedOutOfEmails*/
   
  public boolean msg{get;set;}
  
  public Set<String> ooe {get;set;}
  public Set<String> OptedOutOfEmailSet {get;set;}
  public String acc_name{get;set;}
   
   
 /*---------------Validation----------------*/  
/*public  List<String> finalListNew {get;set;}*/

    public PageReference OptedOutOfEmail() {
      
    isEmailValidated = true; 
        
     ooe = new Set<String>();
       if(allAdditionalToList.size() != 0)
                ooe.addAll(allAdditionalToList);
       if(allCCList.size() != 0) 
                ooe.addAll(allCCList);              
       if(allBccList.size() != 0) 
                ooe.addAll(allBccList);     
       if(toContactmap != null && toContactmap.size() != 0) 
                ooe.addAll(toContactmap.keySet()); 
                
         OptedOutOfEmailSet = new Set<String>();
        
         msg1 = false;
      
      if(byPass) { 
    		if(ooe.size() != 0) {
			msg3 = true;
			} else {
      		msg3 = false;
			}
    	return null;
      }  
         
        
      if(ooe.size() != 0) { 
	      for(Contact c:[Select Name, Email, HasOptedOutOfEmail From Contact Where Id IN:ooe 
	            AND (HasOptedOutOfEmail = true OR marketingSuspend__c = true)]){
	                      OptedOutOfEmailSet.add(c.Name);
	                      msg1 = true;
	      }
      }
      if(msg1){
          msg3 = false;
      } else {
		if(ooe.size() != 0) {
			msg3 = true;
		} else {
      		msg3 = false;
		}
	}
	return null;
    }
   
   /*The Cancel Opreation*/
   
   public PageReference cancel() {
      return   new PageReference('/'+RobjectId );
   }
   
   
 /*Test Method  
   static testMethod void testMultiSelect(){
     
   
   ApexPages.currentPage().getParameters().put('acc_id', '0018000000sJnAT');
   ApexPages.currentPage().getParameters().put('p3_lkid','0018000000sJnAT' );
   ApexPages.currentPage().getParameters().put('p3', 'test');
   ApexPages.currentPage().getParameters().put('p2_lkid', '0038000001DFAq3');
   ApexPages.currentPage().getParameters().put('view', '0018000000sJnAT');
   
   multiselect ms = new multiselect();
  
   ms.addToContactMap.put('a','a');
   ms.addToContactMap.put('b','B'); 
   
   ms.varContactMap.put('c','c');
   ms.varContactMap.put('d','d');
   
   ms.bccContactMap.put('e','e');
   ms.bccContactMap.put('f','f');
   
   ms.ccContactMap.put('g','g');
   ms.ccContactMap.put('h','h');
   
   ms.globalContactMap.put('i','i');
   ms.globalContactMap.put('j','j');
   
   ms.toContactmap.put('k','k');
   ms.toContactmap.put('l','l');
   
   ms.isEmailValidated = true;
   
   ms.emailAuthor();
   
   ms.globalSelectedList.add('a');
   ms.globalSelectedList.add('b');
   ms.globalSelectedList.add('c');
   
   ms.allAdditionalToList.add('a');
   ms.allAdditionalToList.add('b');
   ms.allAdditionalToList.add('c');
   
   ms.allBccList.add('a');
   ms.allBccList.add('b');
   ms.allBccList.add('c');
   
   ms.allCCList.add('a');
   ms.allCCList.add('b');
   ms.allCCList.add('c');
   
   ms.clearList();
   ms.temp.Accountid = '0018000000sJnAT';
   
   ms.searchContact();
   ms.getGlobalContactOptions();
   
   ms.setAdditionalTo();
   ms.removeAdditionalTo();
   
   ms.setBccList();
   ms.removeBccList();
   
   ms.setCCList();
   ms.removeCCList();
   
   ms.getAllAdditionalTo();
   ms.isEmailValidated = false;
     
   ms.emailAuthor();
   ms.OptedOutOfEmail();
   ms.setToAddress();
   ms.removeToAddress();
   ms.cancel();
   ms.getAllCCOptionsList();
   ms.getAllBccOptionsList();
   
   }*/
     
}