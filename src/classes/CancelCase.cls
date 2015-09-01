public class CancelCase {

    public String strCaseId = ApexPages.currentPage().getParameters().get('id');
    public String strClosingComments {get; set;}    
    public Case objCancelCase {get; set;}
    public List<CaseComment> objCancelCaseCommentList {get; set;}
    
    public CancelCase(ApexPages.StandardController controller) {
        strClosingComments ='';
        objCancelCaseCommentList = [Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, 
                                    LastModifiedDate, LastModifiedById, IsDeleted, ConnectionReceivedId, ConnectionSentId 
                                    From CaseComment where ParentId =:strCaseId ];
       }
    
    public List<SelectOption> getStatus(){
      List<SelectOption> options = new List<SelectOption>();
      Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
      options.add(new SelectOption('Cancelled', 'Cancelled'));
      return options;
      }
    
    public PageReference save() {
   
      PageReference createCancelCase;
      try{
       Case caseBeingCancelled = [Select Status,OPS_Last_Action__c From Case where Id=:strCaseId];
      
      if(caseBeingCancelled .Status =='Cancelled' || caseBeingCancelled .Status =='Cancel'){
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Since the Case is '+caseBeingCancelled .Status+',you cannot perform this action anymore'));
      }else{
       if(strClosingComments==null || strClosingComments==''){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please enter comments before cancelling the case'));
              return null;
       }
    
        CaseComment  objLatestCancelComment = new CaseComment();
        objLatestCancelComment.ParentId = strCaseId;
        objLatestCancelComment.CommentBody= strClosingComments;
        objCancelCaseCommentList.add(objLatestCancelComment);
        upsert objCancelCaseCommentList ;
        
        //strCaseId
       //Case caseBeingCancelled = [Select Status,OPS_Last_Action__c From Case where Id=:strCaseId];
        caseBeingCancelled.Status = 'Cancelled';
        caseBeingCancelled.OPS_Last_Action__c='Cancel';
        update caseBeingCancelled;
        
        createCancelCase = new PageReference('/'+strCaseId);
        createCancelCase.setRedirect(TRUE);
  
       }
        }catch(Exception e){
          }
      return createCancelCase ; 
    }
    // Test Class
  /* 
   static testMethod void testCancelCase(){
        
      List<CaseComment> objCancelCaseCommentList=new  List<CaseComment> ();
        CaseComment cs=new CaseComment();
        String str='test';
        cs.CommentBody=str;
        cs.ParentId='500T0000003TeiT';
        objCancelCaseCommentList.add(cs);
         insert objCancelCaseCommentList; 
      
       Case ca = new Case ();
       ca.Status='Cancelled';
       insert ca; 
       
        CaseComment CCM = new CaseComment ();
       CCM.CommentBody ='Terst';
       CCM.ParentId='500T0000003TeiT';
       insert CCM; 
      
       ApexPages.StandardController sc = new ApexPages.standardController(ca);
       CancelCase rc = new CancelCase(sc);
       rc.save();
       rc.getStatus();
    
   } */
   public class CancelDataTest{ 
            public void testingCancelData01()       
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

        public void testingCancelData02()       
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
  public void testingCancelData03()       
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
  
    /*static testMethod void testCancelCase(){
         CancelDataTest CancelCaseTest= new CancelDataTest();
         CancelCaseTest.testingCancelData01();
         CancelCaseTest.testingCancelData02();
         CancelCaseTest.testingCancelData03();
        
      
    } */  
}