public class RackspaceController{
  public RackspaceDistributionModel objRackspaceDistributionModelNew{get;set;}
      
    public String strAccountNumber{get;set;}
    public String strDomainName{get;set;}
    public String strDistributionListName{get;set;}
    public String strSignature{get;set;}
    public String strMessage{get;set;}
    public Boolean isMessageShow{get;set;}
    public RackspaceDistributionModel objRackspaceDistributionModel{get;set;}
    public String strNewMemberName{get;set;}
    public String strNewMemberName2{get;set;}
    public String strRemoveEmail{get;set;}
    public String strName{get;set;}
    public String strSelectedMember{get;set;}
    Public List<SelectOption> lstAvailableMember{get;set;}
   
    public RackspaceController(){
      try{
        RackSpaceCredentialController.CredentialModel objRackSpaceCredential  = RackSpaceCredentialController.getRackspaceCredential();
        lstAvailableMember=new List<SelectOption>();
        if(objRackSpaceCredential.strMessage!='' && objRackSpaceCredential.strMessage!=null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO,objRackSpaceCredential.strMessage));
        }else{
      		if(Test.isRunningTest()) {
            strAccountNumber= '205207';
            strDomainName= 'ringcentral.com';
            strSignature= 'Test';
      		}else {
	          strAccountNumber=objRackSpaceCredential.strAccountNumber;
	          strDomainName=objRackSpaceCredential.strDomainName;
	          strSignature=objRackSpaceCredential.strSignature;
      		}
       
        getAllDistributionList();
        objRackspaceDistributionModel=new RackspaceDistributionModel();
        strNewMemberName='';
       
      }
     }catch(Exception e){
        isMessageShow=true;
        strMessage=e.getMessage();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO,e.getMessage()));
     }
    }
  
  
  
  public void getAllDistributionList(){
     try{
     	system.debug('*** Inside getAllDistributionList ***');
        String strJsonString=RackspaceControllerHelperNew.getAllDistributionList(strAccountNumber,strDomainName,strSignature);
        objRackspaceDistributionModelNew=RackspaceDistributionModel.getDistributionListObject(strJsonString);
        List<RackspaceDistributionModel.distributionlists>lstLocal=new List<RackspaceDistributionModel.distributionlists>();
       
       for(RackspaceDistributionModel.distributionlists obj:objRackspaceDistributionModelNew.distributionlists){
       	  system.debug('obj === ' + obj);
          if(obj.displayName.endsWith('UN')){
             lstLocal.add(obj); 
          }
       }
      objRackspaceDistributionModelNew.distributionlists=lstLocal; 
     
     }catch(Exception e){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO,e.getMessage()));
     }
   }
   
   public PageReference showDLDetail(){
      try{
           getAvailableMember();
        }catch(Exception e){
           isMessageShow=true;
          strMessage=e.getMessage();
          ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO,e.getMessage()+e.getLineNumber()+'=='+strDistributionListName));
       }
       // isDLDetailShow=true;
          PageReference objPageRef=new PageReference('/apex/showDistributionListDetail');
          objPageRef.getParameters().put('retURL','/apex/rackspace');
          objPageRef.getParameters().put('nooverride','1');
           strName='';
           strNewMemberName='';
          objPageRef.setRedirect(false);
     return objPageRef;
   }
   
    public PageReference showPreviousPage(){
       PageReference objPageRef=new PageReference('/apex/rackspace');
        objPageRef.getParameters().put('retURL','/apex/rackspace');
        objPageRef.getParameters().put('nooverride','1');
       objPageRef.setRedirect(false);
    return objPageRef;
    }
   
   public void getAvailableMember(){
       RackspaceDistributionModel objDL=getDistributionListDetail();
       lstAvailableMember=new List<SelectOption>();
       for(String objDLMember:objDL.memberList){
           String[] strArray=objDLMember.split('@');
           String strMemberName=strArray[0];
           lstAvailableMember.add(new SelectOption(strMemberName,objDLMember));
       }
   }
  
   public String strEmailId{get;set;}
  public RackspaceDistributionModel getDistributionListDetail(){
  try{
  	  system.debug('strDistributionListName === ' + strDistributionListName);
      String strJsonString=RackspaceControllerHelperNew.getDistributionListDetail(strDistributionListName,strAccountNumber,strDomainName,strSignature);
      system.debug('strJsonString == ' + strJsonString);
      objRackspaceDistributionModel=RackspaceDistributionModel.getDistributionListObject(strJsonString);
      
      for(RackspaceDistributionModel.emailAddressList objEmail:objRackspaceDistributionModel.emailAddressList){
         if(objEmail.replyTo){
            strEmailId=objEmail.address;
         }
      }
      
    }catch(Exception e){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO,e.getMessage()));
    } 
    return objRackspaceDistributionModel;
 }
  public pageReference addMemberToDL(){
    try{
         isMessageShow=false;
         strNewMemberName2='';
         strNewMemberName=strNewMemberName.trim();
         strMessage='';
      if(strNewMemberName==null || strNewMemberName==''){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Member name must not be blank'));
          isMessageShow=true;
          strMessage='Member Email must not be blank.';
          return null;
        }
         if(!validateEmailAddress(strNewMemberName)){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Invalid Email Address'));
               strMessage='Please enter a valid Email Address.';
             isMessageShow=true;
              return null;
         }else if(!isValidEmailDomainName(strNewMemberName)){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Invalid Domain'));
              strMessage='Email with'+strDomainName+'domain would be accepted.';
              isMessageShow=true;
              return null;
            }
           
         if(!isEmailExist(strNewMemberName)){
            String strMember=strNewMemberName.subString(0,strNewMemberName.indexOf('@'));
            RackspaceControllerHelperNew.addMemberToDLList2(strDistributionListName,strMember,strAccountNumber,strDomainName,strSignature);
            getAvailableMember();
            saveDistributionChangeLog(objRackspaceDistributionModel.displayName,strNewMemberName,'Add');
           
           strSelectedMember=strMember;
         }
           strNewMemberName='';
           strName='';
           
         
           
        }catch(Exception e){
             isMessageShow=true;
             strMessage=e.getMessage();
           ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO,e.getMessage()));
        }
     return null;
 }
 
   public Boolean validateEmailAddress(String strEmailId){
    String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
    Pattern MyPattern = Pattern.compile(emailRegex);
  
    Matcher MyMatcher = MyPattern.matcher(strEmailId);

    return MyMatcher.matches();
  }
 public Boolean isValidEmailDomainName(String strEmail){
    
    String strUserDomainName=strEmail.subString(strEmail.indexOf('@')+1,strEmail.length());
    
    if(strUserDomainName.equalsIgnoreCase(strDomainName)){
       return true; 
    }
    return false; 
    
 }
 private Boolean isEmailExist(String strName){
   Boolean isExist=false;
   for(integer ii=0;ii<lstAvailableMember.size()&& !isExist;ii++){
     if(lstAvailableMember.get(ii).getLabel().equalsIgnoreCase(strName)){
       isExist=true;
     }
  
  }
  return isExist;

 }
 public pageReference removeFromDLEmailAddressList(){
    try{
          strNewMemberName='';
          isMessageShow=false;
          strMessage='';
        if(strSelectedMember==null || strSelectedMember==''){
          return null;
        }
       
       String strJsonString=RackspaceControllerHelperNew.removeFromDLEmailAddressList(strDistributionListName,strSelectedMember,strAccountNumber,strDomainName,strSignature);
     
       getAvailableMember();
       saveDistributionChangeLog(objRackspaceDistributionModel.displayName,strSelectedMember+'@'+strDomainName,'Removed');
     }catch(Exception e){
          strMessage=e.getMessage();
          isMessageShow=true;
       ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO,e.getMessage()));
    }
    
  return null;
 
 
 }
  
    public void saveDistributionChangeLog(String strDLName,String strEmail,String strAction){
        Rackspace_Distribution_Log__c objRackspaceDistribution=new Rackspace_Distribution_Log__c();
        objRackspaceDistribution.Action__c=strAction;
        objRackspaceDistribution.Distribution_List__c=strDLName;
        objRackspaceDistribution.DL_Email_address__c=strEmail;
        objRackspaceDistribution.SFDC_User__c=UserInfo.getUserId();
        objRackspaceDistribution.Timestamp__c=datetime.now();
       
        insert objRackspaceDistribution;
     
     }
 

  public Boolean getIsSiteUser(){
 
 return (Site.getName()!=null?true:false);
 }  
    

    
}