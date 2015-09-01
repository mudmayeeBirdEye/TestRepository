public with sharing class OpsReAssignCaseController {
 public String strCaseId = ApexPages.currentPage().getParameters().get('id');
    public String strClosingComments {get; set;}    
   
    public Case objCase {get; set;}
    public String status {get; set;}  
    public List<CaseComment> objOpsReAssignCaseControllerCommentList {get; set;}
    public OpsReAssignCaseController(ApexPages.StandardController controller) {
    objCase =[Select id,ownerid,Ops_ReAssig__c,Assign_To__c,Assigned_OPS_User__c,Ops_Bussiness_Units__c,Ops_Department__c from Case where id=:strCaseId];
    strClosingComments ='';
    status ='Yes';
        objOpsReAssignCaseControllerCommentList = [Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, 
                                    LastModifiedDate, LastModifiedById, IsDeleted, ConnectionReceivedId, ConnectionSentId 
                                    From CaseComment where ParentId =:strCaseId ];
       
    }
   public PageReference save()
     {
     PageReference assignPageRef;
    try {
         if(objCase.ownerid==userinfo.getUserId()){
         
           if(objCase.Assign_To__c=='User' && objCase.Assigned_OPS_User__c==null){
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,' You must enter a assigned OPS User'));
               return null;
       }
       else if(strClosingComments==null || strClosingComments==''){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please enter the reason for reassigning the case'));
        //ApexPages.addMessages('Please enter the reason for reassigning the case');
                    
        return null;
       }
        CaseComment  objLatestOpsReAssignCase = new CaseComment();
        objLatestOpsReAssignCase.ParentId = strCaseId;
        objLatestOpsReAssignCase.CommentBody= strClosingComments;
        objOpsReAssignCaseControllerCommentList.add(objLatestOpsReAssignCase);
        upsert objOpsReAssignCaseControllerCommentList;
        objCase.Ops_ReAssig__c=objCase.Ops_ReAssig__c+1; 
        update objCase ;
        assignPageRef = new PageReference('/'+strCaseId);
        assignPageRef.setRedirect(TRUE);
      }
      else{
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Since you are not the assignee of the case, you are not allowed to edit this case'));
      }
      }
    catch(Exception e){
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,''+e.getMessage()));
     return null;
    }
  return assignPageRef ;
  }
  
  /* public class ReAssignDataTest{ 
            public void testingReAssignData01()       
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

        public void testingReAssignData02()       
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
  public void testingReAssignData03()       
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
 
  }*/
  
    /*static testMethod void testReAssignCase(){
         ReAssignDataTest ReAssignCaseTest= new ReAssignDataTest();
         ReAssignCaseTest.testingReAssignData01();
         ReAssignCaseTest.testingReAssignData02();
         ReAssignCaseTest.testingReAssignData03();
        
      
    }*/

  
  
  
}