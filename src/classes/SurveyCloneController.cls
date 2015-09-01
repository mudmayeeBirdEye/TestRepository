public with sharing class SurveyCloneController {
  
  public Survey_Details__c surveyCloneObj {get;set;}
  public boolean toShowPanel {get;set;}
  string surveyParentId;
  List<Survey_Details__c> selectedSurveyDetail;
  List<SurveyQuestionJunction__c> questionListClone = new List<SurveyQuestionJunction__c>();
  
  public SurveyCloneController(ApexPages.StandardController controller) {
    try {
      toShowPanel = true;
      surveyCloneObj = new Survey_Details__c();
      if(ApexPages.currentPage().getParameters().get('parentId') != null && ApexPages.currentPage().getParameters().get('parentId') != '') {
        surveyParentId = ApexPages.currentPage().getParameters().get('parentId');
        if(surveyParentId != null && surveyParentId != '') {
          selectedSurveyDetail = [select title__c from Survey_Details__c where ID =:surveyParentId limit 1];
              List<EmailTemplate> emailTemplateList = [Select DeveloperName From EmailTemplate where 
                                                              Folder.Name = 'Survey Template' and IsActive = true order by CreatedDate];
                  if(emailTemplateList != null && emailTemplateList.size()>0) {
                      surveyCloneObj.Survey_Template__c = emailTemplateList[0].DeveloperName;
                  }
              if(selectedSurveyDetail != null && selectedSurveyDetail.size() == 1) {
                surveyCloneObj.Title__c = selectedSurveyDetail[0].Title__c;
              }
            questionListClone = [select IsMandatory__c,Logo_Position__c,Position__c,QuestionAndAnswers__c,Submit_Button_Position__c,Survey_Details__c 
                      from SurveyQuestionJunction__c where Survey_Details__c = :surveyParentId];
        
        }
      } else {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Id.'));
        toShowPanel = false;
      }  
    } catch(Exception ex) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
      toShowPanel = false;
    }
  }
  
  public pageReference cloneNewSurvey() {
      try {
        List<Survey_Details__c> surveyList = new List<Survey_Details__c>(); 
              surveyList = [select Id from Survey_Details__c where Title__c = :surveyCloneObj.Title__c];
              if(surveyList != null && surveyList.size()>0) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Survey with this name already exist. Cannot create duplicate survey.'));       
                  return null;
              } else {
                insert surveyCloneObj;
                if(surveyCloneObj != null ) {
            if(questionListClone != null && questionListClone.size()>0) {
              for(SurveyQuestionJunction__c questionObjJun : questionListClone) {
                SurveyQuestionJunction__c questionObjJunNew = new SurveyQuestionJunction__c();
                questionObjJunNew.QuestionAndAnswers__c = questionObjJun.QuestionAndAnswers__c;
                questionObjJunNew.Survey_Details__c = surveyCloneObj.id;
                questionObjJunNew.IsMandatory__c = questionObjJun.IsMandatory__c;
                questionObjJunNew.Position__c = questionObjJun.Position__c;
                questionObjJunNew.Logo_Position__c = questionObjJun.Logo_Position__c;
                questionObjJunNew.Submit_Button_Position__c = questionObjJun.Submit_Button_Position__c;
                Database.DMLOptions dlo = new Database.DMLOptions();
                    Database.insert(questionObjJunNew,dlo);
              }
            }
            PageReference rtnPage = new PageReference('/apex/QuestionAndAnswersPage?id='+surveyCloneObj.Id);
            rtnPage.setRedirect(true);
            return rtnPage;  
          }
              }  
      } catch(Exception ex) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        toShowPanel = false;
      }
    return null;
  }
  
  public pageReference cancelSurveyClone() {
    PageReference rtnPage = new PageReference('/apex/SurveyDetailsViewPage');
    rtnPage.setRedirect(true);
    return rtnPage;
  } 
}