public class CloseCase{

   public String strCaseId = ApexPages.currentPage().getParameters().get('id');
   public String strClosingComments {get; set;} 
   public Case objCloseCase {get; set;}
   public List<CaseComment> objCloseCaseCommentList {get; set;}
   public CloseCase(ApexPages.StandardController controller) {
   strClosingComments ='';
   
        objCloseCaseCommentList = [Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, 
                                    LastModifiedDate, LastModifiedById, IsDeleted, ConnectionReceivedId, ConnectionSentId 
                                    From CaseComment where ParentId =:strCaseId ];
       }
    public List<SelectOption> getStatus(){
      List<SelectOption> options = new List<SelectOption>();
      Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
      options.add(new SelectOption('Closed', 'Closed'));
   return options;
 }



public PageReference save() {

        PageReference createCloseCase;
        try{
         Case caseBeingClosed = [Select Status,OPS_Last_Action__c From Case where Id=:strCaseId];  
        if(caseBeingClosed.Status !='Closed'){
          
        if(strClosingComments==null || strClosingComments==''){
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please enter comments before closing the case'));
            return null;
          }  
 		TriggerHandler.BY_PASS_CONTACT_ON_UPDATE();
        CaseComment  objLatestCloseComment = new CaseComment();
        objLatestCloseComment.ParentId = strCaseId;
        objLatestCloseComment.CommentBody= strClosingComments;
        objCloseCaseCommentList.add(objLatestCloseComment);
        upsert objCloseCaseCommentList ;
        
        //strCaseId
       
        caseBeingClosed.Status = 'Closed';
        caseBeingClosed.OPS_Last_Action__c='Closed';
        update caseBeingClosed;
       	TriggerHandler.RESET_VARIABLES(); 
         createCloseCase = new PageReference('/'+strCaseId);
         createCloseCase.setRedirect(TRUE);
       }else{
       ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Since the Case is Closed,you cannot perform this action anymore'));
       }
       
        }catch(Exception e){
               return null;
             }
         return createCloseCase ;
   }
   
  
  public class CloseDataTest{ 
            public void testingCloseData01()       
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

        public void testingCloseData02()       
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
  public void testingCloseData03()       
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
  /*
   static testMethod void testCloseCase(){
         CloseDataTest CloseCaseTest= new CloseDataTest();
         CloseCaseTest.testingCloseData01();
         CloseCaseTest.testingCloseData02();
         CloseCaseTest.testingCloseData03();
    }*/
}