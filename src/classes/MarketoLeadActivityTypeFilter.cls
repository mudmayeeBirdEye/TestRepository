public class MarketoLeadActivityTypeFilter{

public List<SelectOption> listLeftFilter{get;set;}
public List<SelectOption> listRightFilter{get;set;}
Public String[] SelectedOptionsLeft{get;set;}
Public String[] SelectedOptionsRight{get;set;}

public Static  List<SelectOption> getAllAvailableActivityFilter(){
     List<SelectOption> listLeftFilter=new List<SelectOption>();
     
      listLeftFilter.add(new SelectOption('AttendEvent','AttendEvent'));  
      listLeftFilter.add(new SelectOption('AddToList','AddToList'));
      listLeftFilter.add(new SelectOption('AssocWithOpprtntyInSales','AssocWithOpprtntyInSales'));
     
      listLeftFilter.add(new SelectOption('ChangeDataValue','ChangeDataValue'));
      listLeftFilter.add(new SelectOption('CreateTask','CreateTask'));
      listLeftFilter.add(new SelectOption('ConvertLead','ConvertLead'));
      listLeftFilter.add(new SelectOption('ChangeScore','ChangeScore'));
      listLeftFilter.add(new SelectOption('ChangeOwner','ChangeOwner'));
      listLeftFilter.add(new SelectOption('ChangeStatusInSFDCCampaign','ChangeStatusInSFDCCampaign'));    
      listLeftFilter.add(new SelectOption('ClickSalesEmail','ClickSalesEmail')); 
      
      listLeftFilter.add(new SelectOption('DeleteLeadFromSales','DeleteLeadFromSales')); 
      listLeftFilter.add(new SelectOption('DeleteLead','DeleteLead'));
      listLeftFilter.add(new SelectOption('DissocFromOpprtntyInSales','DissocFromOpprtntyInSales'));
               
     listLeftFilter.add(new SelectOption('EmailBouncedSoft','EmailBouncedSoft'));
             
     listLeftFilter.add(new SelectOption('InterestingMoment','InterestingMoment'));   
      
     listLeftFilter.add(new SelectOption('LeadAssigned','LeadAssigned'));
    
     listLeftFilter.add(new SelectOption('MergeLeads','MergeLeads'));
     
     listLeftFilter.add(new SelectOption('NewSFDCOpprtnty','NewSFDCOpprtnty'));
     listLeftFilter.add(new SelectOption('NewLead','NewLead'));
     
     listLeftFilter.add(new SelectOption('OpenSalesEmail','OpenSalesEmail'));
     listLeftFilter.add(new SelectOption('PushLeadUpdatesToSales','PushLeadUpdatesToSales'));
     listLeftFilter.add(new SelectOption('PushLeadToSales','PushLeadToSales'));
     
     
      listLeftFilter.add(new SelectOption('RemoveFromList','RemoveFromList'));
      listLeftFilter.add(new SelectOption('ResolveConflicts','ResolveConflicts'));
      listLeftFilter.add(new SelectOption('RemoveFromSFDCCampaign','RemoveFromSFDCCampaign'));
      listLeftFilter.add(new SelectOption('ReceiveSalesEmail','ReceiveSalesEmail'));
      listLeftFilter.add(new SelectOption('RequestCampaign','RequestCampaign'));
      listLeftFilter.add(new SelectOption('RunSubflow','RunSubflow'));
      listLeftFilter.add(new SelectOption('RegisterForEvent','RegisterForEvent'));
      
         
      listLeftFilter.add(new SelectOption('SFDCActivity','SFDCActivity'));
      listLeftFilter.add(new SelectOption('SFDCActivityUpdated','SFDCActivityUpdated'));
      listLeftFilter.add(new SelectOption('SFDCMergeLeads','SFDCMergeLeads'));
      listLeftFilter.add(new SelectOption('SendAlert','SendAlert'));
      listLeftFilter.add(new SelectOption('SendSalesEmail','SendSalesEmail'));
      listLeftFilter.add(new SelectOption('SalesEmailBounced','SalesEmailBounced'));
    
      listLeftFilter.add(new SelectOption('UpdateOpprtntyInSales','UpdateOpprtntyInSales'));
          
      listLeftFilter.add(new SelectOption('Wait','Wait'));
   
     
  //listLeftFilter.sort();
return listLeftFilter; 

}
public Static  List<SelectOption> getDefaultActivityFilter(){
     List<SelectOption> listRightFilter=new List<SelectOption>();
     
      listRightFilter.add(new SelectOption('AddtoSFDCCampaign','Lead added to a SalesForce Campaign'));
      listRightFilter.add(new SelectOption('ClickLink','Lead clicked a link'));
      listRightFilter.add(new SelectOption('ClickEmail','Lead clicked on an email'));
      listRightFilter.add(new SelectOption('EmailBounced','Lead\'s email address bounced'));
      listRightFilter.add(new SelectOption('EmailDelivered','Lead received an email'));
      listRightFilter.add(new SelectOption('FillOutForm','Lead filled out a form'));
      listRightFilter.add(new SelectOption('UnsubscribeEmail','Lead unsubscribed to emails'));
      listRightFilter.add(new SelectOption('OpenEmail','Lead opened an email'));
      listRightFilter.add(new SelectOption('RemoveFromFlow','Removed from email campaign'));
      listRightFilter.add(new SelectOption('SendEmail','Sent Email'));
      listRightFilter.add(new SelectOption('VisitWebpage','Lead visited Website'));
     
      return listRightFilter;
      }
 
  public Static  List<String> getDefaultSelectedActivityFilter(){
      List<String> listRightFilter=new List<String>();
   
      listRightFilter.add('AddtoSFDCCampaign');
      listRightFilter.add('ClickLink');
      listRightFilter.add('ClickEmail');
      listRightFilter.add('EmailBounced');
      listRightFilter.add('EmailDelivered');
      listRightFilter.add('FillOutForm');
      listRightFilter.add('UnsubscribeEmail');
      listRightFilter.add('OpenEmail');
      listRightFilter.add('RemoveFromFlow');
      listRightFilter.add('SendEmail');
      listRightFilter.add('VisitWebpage');
      
      return listRightFilter;
      }

 /*static testMethod void testMarketoLeadActivityTypeFilter() {
 	MarketoLeadActivityTypeFilter.getAllAvailableActivityFilter();
 	MarketoLeadActivityTypeFilter.getDefaultActivityFilter();
 	MarketoLeadActivityTypeFilter.getDefaultSelectedActivityFilter();
 	
 }*/

}