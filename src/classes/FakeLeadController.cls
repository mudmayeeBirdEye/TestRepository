public with sharing class FakeLeadController {
    
    public FakeLeadController(ApexPages.StandardController controller) {    }
    
    public PageReference save() {
        //get all leads, created within last one day, to be checked in a list 
        List<Lead> leadList = [select Email, Name, FirstName, LastName, Phone from Lead where CreatedDate = LAST_N_DAYS:1]; 
        List<Lead> leadListToDel = new List<Lead>();
        
        for(Lead lead: leadList){
            if(lead.FirstName==null  || lead.LastName == null){ continue; }
            
            if( (lead.FirstName.equalsIgnoreCase( 'something') && lead.LastName.equalsIgnoreCase('new') ) 
                    || (lead.FirstName.equalsIgnoreCase('rctu') && lead.LastName.equalsIgnoreCase('2calls4me') ) ){                   
                      leadListToDel.add(lead); 
           }
        }
        
        System.debug('To delete list size = ' + leadListToDel.size());
        for(Lead lead: leadListToDel){
           System.debug('To delete, lead.FirstName=#' + lead.FirstName + '#, lead.LastName=#'+ lead.LastName+ '#');
        }
        
        //if size of leadListToDel is > 0, delete list of leads
        if(leadListToDel.size() > 0)
            delete leadListToDel;
                    
        return null;
   }


 // Test class
     //Test class
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

 /* static testMethod void testFakeLeadController(){
         //FakeDataTest FakeTest = new FakeDataTest();
         //FakeTest.testingFakeData();
         //FakeTest.testingFakeData02();

    
    }*/
  
}