global class MassUpdateRecord implements  Database.Batchable<sObject> {
List<sObject> sobj { get; set;}

global MassUpdateRecord (List<sObject> obj)
{
   sobj = new List<sObject>();
   for(sObject ob : obj) {
    sobj.add(ob);
   }
}
global MassUpdateRecord ()
{
   
}
global Iterable<sObject> start(Database.BatchableContext BC){

   return sobj;
}

public Database.SaveResult[] s1;


global void execute(Database.BatchableContext BC, List<sObject> scope){
    System.debug('^^^^^^^^^^^^^^^&&&&&&&&&&&&&&&&&&&&&**************************-' + scope.size());
  
Database.update(scope);
 
  //update scope;
}



public void sendMail(String result, String objType,String name ){
	
	
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {'benjieb@ringcentral.com'};
    mail.setToAddresses(toAddresses);
    mail.setSubject('Result');
      mail.setHtmlBody
   ('<table border=1 width=100%><th>Count</th> <th>ID - 1</th><th>ID - 2</th> <th>ERROR</th> <th>STATUS</th>'+result+'</table>');
   try{
   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }catch(Exception e){}
   String data = '<html><Body><table border=1 width=100%><th>Count</th> <th>ID - 1</th><th>ID - 2</th> <th>ERROR</th> <th>STATUS</th>'+result+'</table></body></html>';
   
   Document doc = new Document();
   //doc.FolderId = '00lQ0000000DsKb';
   doc.FolderId = '00l80000001lt7E';
   doc.Name = 'TC-'+objType+'-'+name+'-'+System.now();
   doc.Type ='xls';
  // doc.ContentType ='application/vnd.ms-excel';
  // doc.ContentType ='text/html'; application/vnd.ms-excel
   doc.ContentType ='application/vnd.ms-excel';
  //doc.ContentType ='text/rtf';
  doc.Body = Blob.valueOf(data);
   insert doc;
   
 
  
   
}







global void finish(Database.BatchableContext BC){

	

    String result = '';
     AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
      TotalJobItems, CreatedBy.Email
      from AsyncApexJob where Id =
      :BC.getJobId()];
   // Send an email to the Apex job's submitter notifying of job completion.  
    
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   String[] toAddresses = new String[] {'gunjan.deogam@simplion.com','virendra.singh@simplion.com'};
   mail.setToAddresses(toAddresses);
   mail.setSubject('Result' + a.Status);
  
  Integer count = 1;
  String head1 ='';
  String Caption ='';  
  boolean Objectflag = false;   
   
   for(Sobject s:sobj){
   if(s.getsObjectType() == Lead.sObjectType){
      
      Lead l = (Lead)s;
      
      result +='<tr><td>'+count+'</td><td>'+l.id+'</td><td>'+l.ownerid+'</td></tr>';     
      count++;
      Caption ='Lead';
      Objectflag = true;
   }
   else if(s.getsObjectType() == Opportunity.sObjectType){
      
      Opportunity opp = (Opportunity)s;
      
      result +='<tr><td>'+count+'</td><td>'+opp.id+'</td><td>'+opp.ownerid+'<td></tr>';     
      count++;
      Caption ='Opportunity';
      Objectflag = true;
   } 
   else if(s.getsObjectType() == Case.sObjectType){
      
      Case cs = (Case)s;
      
      result +='<tr><td>'+count+'</td><td>'+cs.id+'</td><td>'+cs.ownerid+'</td></tr>';     
      count++;
      Caption ='Case';
      Objectflag = true;
   } 
   else if(s.getsObjectType() == Contact.sObjectType){
      
      Contact ct = (Contact)s;
      
      result +='<tr><td>'+count+'</td><td>'+ct.id+'</td><td>'+ct.ownerid+'<td></tr>';     
      count++;
      Caption ='Contact';
      Objectflag = true;
   }  
   
   else if(s.getsObjectType() == Account.sObjectType){
       Account acc =(Account)s;
       result +='<tr><td>'+count+'</td><td>'+acc.id+'</td><td>'+acc.Current_Owner__c+'<td></tr>'; 
       count++;
       Caption ='Account';
       Objectflag = false;
   }
   }
   
   if(Objectflag == true){
   head1 ='Owner ID';
   }
   else{
   head1 ='Current Owner ID';
   }
   
   mail.setHtmlBody
   ('The batch Apex job processed ' + a.TotalJobItems +
   ' batches with '+ a.NumberOfErrors + ' failures.'+'<br/><br/>'+
   '<table border=1><legend>'+Caption+'</legend><tr><th>Count</th> <th>ID</th> <th>'+head1+'</th></tr>' +result+'</table><br/><br/><hr/>');
   try{
   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }catch(Exception e){}


}
}