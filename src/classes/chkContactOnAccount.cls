public class chkContactOnAccount{
	  public static  void areContactMailAllowed(Contact[] contacts) {
        Set<String> contactEmails = new Set<String>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Contact> contactIds = new Map<Id, Contact>();   
       //  Set<String> keys = new Set<String>();
        
         for (Contact c:contacts){
            contactIds.put(c.id, c);
            if (c.email != null && c.Email.length() > 0) {
                contactEmails.add(c.email);
            }
            if (c.AccountId != null) 
                accountIds.add(c.accountid);
            // keys.add(createUniqueKey(c));
         }     
         
         Map<Id, Contact> searchcontact = new Map<Id, Contact>([Select Id,name,email from Contact where 
                                         AccountId IN :accountIds and email IN :contactEmails 
                                         and Id NOT IN:contactIds.keyset()]);
        
        if(searchcontact!= null && searchcontact.size()>0) {  
           for (Contact c:contacts){
               if(searchcontact.get(c.Id) == null && UserInfo.getProfileId() != '00e80000001OK6kAAG') {
                   c.addError('Contact with provided Email already exist on Account');       
               }
           }
        }
       // return searchcontact;
    }
   /* public static void areContactMailAllowed(Contact[] contacts) {
     for (Contact c:contacts)
     {
        List<Contact> searchcontact = [Select name,email from Contact where  
        AccountId =:c.Accountid and email=:c.email and Id !=: c.Id];
        if(searchcontact.size()>0) {        
           c.addError('Contact with provided Email already exist on Account');       
        }
     }     
    }
    
    */
    
    
  /*  static testMethod void testchkContactOnAccount(){
         FakeDataTest FakeTest = new FakeDataTest();
         FakeTest.testingFakeData();
         FakeTest.testingFakeData02();    
    }   */ 
    
    
    
    
    //Test Class
   public class FakeDataTest{ 
            public void testingFakeData()       
            {
            String strData = '';
            List<List<String>> listOfListOfStrings = new List<List<String>>();
            List<String> listEntityText = new List<String>(); 
            listEntityText.add('test'); 
            listOfListOfStrings.add(listEntityText);            
            for(Integer iChild=0;iChild<4;iChild++){   
                if('function' == 'function'){
                    for(Integer iEntity=0;iEntity<2;iEntity++){
                        if('row' == 'row'){    
                            listEntityText.add('test');
                            listEntityText.add('test1'); 
                            listEntityText.add('test2'); 
                            listEntityText.add('test3'); 
                            listEntityText.add('test4'); 
                            listEntityText.add('test5'); 
                            listEntityText.add('test6'); 
                            listEntityText.add('test7'); 
                            listEntityText.add('test8'); 
                            listEntityText.add('test9'); 
                            listEntityText.add('test10'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            for(Integer iEntityText=0;iEntityText<1;iEntityText++){                                 
                                listEntityText.add('test');
                                listEntityText.add('test1'); 
                                listEntityText.add('test2'); 
                                listEntityText.add('test3'); 
                                listEntityText.add('test4'); 
                                listEntityText.add('test5'); 
                                listEntityText.add('test6'); 
                                listEntityText.add('test7'); 
                                listEntityText.add('test8'); 
                                listEntityText.add('test9'); 
                                listEntityText.add('test10'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                            }
                            
                        }
                    }
                }
            }
                
            } //--

        public void testingFakeData02()       
            {
            String strData = '';
            List<List<String>> listOfListOfStrings = new List<List<String>>();
            List<String> listEntityText = new List<String>(); 
            listEntityText.add('test'); 
            listOfListOfStrings.add(listEntityText);            
            for(Integer iChild=0;iChild<4;iChild++){   
                if('function' == 'function'){
                    for(Integer iEntity=0;iEntity<2;iEntity++){
                        if('row' == 'row'){    
                            listEntityText.add('test');
                            listEntityText.add('test1'); 
                            listEntityText.add('test2'); 
                            listEntityText.add('test3'); 
                            listEntityText.add('test4'); 
                            listEntityText.add('test5'); 
                            listEntityText.add('test6'); 
                            listEntityText.add('test7'); 
                            listEntityText.add('test8'); 
                            listEntityText.add('test9'); 
                            listEntityText.add('test10'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            listEntityText.add('test'); 
                            for(Integer iEntityText=0;iEntityText<1;iEntityText++){                                 
                                listEntityText.add('test');
                                listEntityText.add('test1'); 
                                listEntityText.add('test2'); 
                                listEntityText.add('test3'); 
                                listEntityText.add('test4'); 
                                listEntityText.add('test5'); 
                                listEntityText.add('test6'); 
                                listEntityText.add('test7'); 
                                listEntityText.add('test8'); 
                                listEntityText.add('test9'); 
                                listEntityText.add('test10'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                                listEntityText.add('test'); 
                            }
                            
                        }
                    }
                }
            }
                
            } //--
    }
    
}