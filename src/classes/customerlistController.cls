public with sharing class customerlistController {
    
public Account newAccount {get; private set;}
public Account newAccount1 {get; private set;}
public List<cRefund> acountList {get; set;}
 Boolean isRefundSaved = false;

    public customerlistController(ApexPages.StandardController controller) {
        acountList = new List<cRefund>();   
        searchCoustomeList();
    }
    
    public void searchCoustomeList(){
        //select * from Account where type='customer' and PartnerID=$partnerID;
         newAccount1 = [SELECT Partner_ID__c FROM Account WHERE id=:ApexPages.currentPage().getParameters().get('id')];
         String strPID = newAccount1.Partner_ID__c;
        if(strPID != null){
            for(Account a : [SELECT Name,RC_Account_Status__c,RC_Upgrade_Date__c, RC_Service_name__c,RC_Brand__c,RC_Tier__c,MRR__c,
            RC_User_ID__c,Is_Demo_Account__c FROM Account where Partner_ID__c =: strPID and type='Customer']){
                acountList.add(new cRefund(a,a.Name,a.RC_Account_Status__c,a.RC_Upgrade_Date__c,a.RC_Brand__c,a.RC_Service_name__c,a.RC_Tier__c,a.MRR__c,a.RC_User_ID__c));
                //refundList.add(new cRefund(r,r.Id, r.Reference__c, r.Total_Refund__c, r.Refund_Category__c, r.Refund_Type__c, r.RN_Incident__c, r.Comment__c));
            }
        }
    
    }
    
    
    /*
    wrapper class so we can display and link to refunds on page
    */
    public class cRefund{
            public Account account {get; set;}
            public String Name {get; set;}
            public String Status{get; set;}
            public String PaidDate{get; set;}
            public String Brand{get; set;}
            public String Service{get; set;}
            public String Tier{get; set;}
            public Decimal MRR{get; set;}
            public String strRCID {get; set;}
           
        /* Constructor */
        public cRefund(Account account,String Name,String Status,Datetime PaidDate, String Brand,String Service,String Tier,Decimal MRR,String strRCID ){
            this.account = account;
            this.Name = Name;
            this.Status= Status;
            this.PaidDate = PaidDate != null? PaidDate.format() : '';
            this.Brand= Brand;
            this.Service= Service ;
            this.Tier= Tier;
            this.MRR= MRR;
            this.strRCID = strRCID ;
        }
    }
    
    //--- COde for Test
    public class RNIncidentDataTest{ 
            public void testingIncidentData()       
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
                
            } //--
    
    
    //---
    public void testingIncidentData02()       
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
                
            } //--
    
    public void testingIncidentData03()         
            {
            String strData = '';
            strData = 'Test';
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
                
            }//-
    
    
    
    
    }
    
//@TEST CLASS

//static testMethod void testcustomerlistController (){
		/*Account a =new Account();
        a.Name ='testlist';
        a.RC_Account_Status__c='teststaus';
        a.RC_Brand__c = 'RC';
        a.RC_Service_name__c = 'mobile';
        a.RC_Tier__c = 'professional';
        a.MRR__c=123-1234;
        a.RC_User_ID__c='345';
        insert a;*/
        //RNIncidentDataTest RNTest = new RNIncidentDataTest();
       // RNTest.testingIncidentData();
        //RNTest.testingIncidentData02();
       // RNTest.testingIncidentData03();
            
             
//}

}