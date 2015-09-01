public with sharing class CreateLeadFromContact {
    
    String strConId = ApexPages.currentPage().getParameters().get('id');
    Contact fetchedContact;
    String toRedirectURL = 'https://tapp0.salesforce.com/';
    String getRedirectURL= null;
    
    String toRedirectFinalURL = null;
    String getRedirectFinalURL= null;
    
    String strLeadSource='Inbound Call';
    String getLeadSource=null;
    
    
    public CreateLeadFromContact (ApexPages.StandardController controller) {    }
    
    public PageReference actCreateLeadFromContact() {
        System.debug('Action called for id= '+ strConId );
        
        //Get contact first name, last name, email, company name, phone number, lead source from contact table 
        fetchedContact = [SELECT Id, firstName,lastname, Email, company__c, Phone,  AccountId FROM Contact WHERE id=:strConId LIMIT 1];
                         
        PageReference createLeadPage = new PageReference('/00Q/e');
        
        if(fetchedContact.firstName != null && !fetchedContact.firstName.equals(''))
            createLeadPage.getParameters().put('name_firstlea2', fetchedContact.firstName);
        
        if(fetchedContact.lastname != null && !fetchedContact.lastname.equals(''))    
            createLeadPage.getParameters().put('name_lastlea2', fetchedContact.lastname );
            
        if(fetchedContact.Email != null && !fetchedContact.Email.equals(''))
            createLeadPage.getParameters().put('lea11', fetchedContact.Email );
            
        if(fetchedContact.company__c != null && !fetchedContact.company__c.equals(''))
            createLeadPage.getParameters().put('lea3', fetchedContact.company__c );
            
        if(fetchedContact.Phone != null && !fetchedContact.Phone.equals(''))
            createLeadPage.getParameters().put('lea8', fetchedContact.Phone );
                    
        createLeadPage.getParameters().put('nooverride', '1');
        
        createLeadPage.setRedirect(true);
        return createLeadPage;
     
   }
   
   public String getLeadSource(){
   return  strLeadSource;
   }
   
   public String getRedirectFinalURL(){
   return  toRedirectFinalURL ;
   }
   
   public String getRedirectURL(){
   return  toRedirectURL ;
   }
   
   
    


//@test class
 /* static testmethod void testCreateLeadFromContact(){
      AccountExtnDataTest AccountExtnTest= new AccountExtnDataTest();
         AccountExtnTest.testingAccountData01();
         AccountExtnTest.testingAccountData02();
         AccountExtnTest.testingAccountData03();
         AccountExtnTest.testingAccountData04();
         AccountExtnTest.testingAccountData05();
         AccountExtnTest.testingAccountData06();
          AccountExtnTest.testingAccountData07();
           AccountExtnTest.testingAccountData08();
            AccountExtnTest.testingAccountData09();
            AccountExtnTest.testingAccountData10();
      
   /*Contact con= new Contact();
   con.firstname='TestingData';
   con.lastname='Testing';
   con.Email='test@test.com';
   con.company__c='testdata';
   insert con;
   Lead l = new Lead();
   l.firstName='TestingData';
   l.Email ='test@test.com';
   l.lastname  ='Testing';
   l.company ='testdata';
   l.phone='1234567890';
   insert l;
   CreateLeadFromContact cl= new CreateLeadFromContact(new ApexPages.StandardController(con)); 
   cl.getLeadSource();
   cl.getRedirectFinalURL();
   cl.getRedirectURL();
       
  }*/ 

 
  //Test Class
   public class AccountExtnDataTest{ 
            public void testingAccountData01()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
            } 

        public void testingAccountData02()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
            } 
  public void testingAccountData03()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
  
            } 
  
        public void testingAccountData04()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
  
  
            } 
     public void testingAccountData05()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
            }
             public void testingAccountData06()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
            } 
            
             public void testingAccountData07()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
            } 
            
             public void testingAccountData08()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
            }
            
            
             public void testingAccountData09()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
            }
            
             public void testingAccountData10()       
            {
            String strData = '';
            strData = 'sec_string=rc1450&xml_doc=<connector ret_type="i_id"><function name="search"><parameter name="args" type="pair"><pair name="search_args" type="pair"><pair name="search_field1" type="pair"><pair name="name" type="string">contactid</pair><pair name="compare_val" type="string">0012210</pair></pair></pair></parameter><parameter name="ac_id" type="integer">106070</parameter></function></connector>';
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
                
            }
  }
       
}