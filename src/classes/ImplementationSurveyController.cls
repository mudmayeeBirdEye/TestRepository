/* This Survey Controller Class create a survey of following 
    this is a completely Dynamic generated surveys.  
1.  Implementation 
2.  ATT Implementation
3.  Rogers Implementation
*/

public class ImplementationSurveyController {
    
    /****************************************************
        properities  and variable declaration section
    ******************************************************/
       private Survey__c surveyObj;
       private String surveyType;
       private String caseSubject;
       public Boolean respondFlag{get;set;}
       public Boolean isEmpty{get;set;}
       public Boolean thanksFlag{get;set;} 
       public Boolean rogersFooterFlag{get;set;} // for Rogers Survey
       public Boolean rogersHeaderFlag{get;set;}
       public Boolean errorFlag{get;set;} 
       public Boolean caseSubjectCheck{get;set;}
       public boolean isExpired{set;get;}
       
       Integer q1Value = Null;
       Integer q2Value = Null;
       Integer q3Value = Null;
       Integer q4Value = Null; 
       Integer q6value = Null; 
       Integer q7value = Null;
       Integer q71value = Null;
       Integer q72value = Null; 
       Integer q73value = Null;   
       Integer q74value = Null; 
       String comment;        
  
  /***************************Section End Here*************/
  /*******************************************************************  
             All properties used in the survey pages declared here            
  ********************************************************************/
  
   public String getComments(){
        return comment;
    }

    public void setComments(String c){
        this.comment = c;
        surveyObj.Comments__c = c;
    }
    
    public Integer getQ1Value(){
        return q1Value;
    }

    public void setQ1Value(Integer value){
        this.q1Value = value;
        surveyObj.Q1_Score__c = value;
    }
    
    public Integer getQ2Value(){
        return q2Value;
    }

    public void setQ2Value(Integer value){
        this.q2Value = value;
        surveyObj.Q2_Score__c = value;
    }
    
    public Integer getQ3Value(){
        return q3Value;
    }

    public void setQ3Value(Integer value){
        this.q3Value = value;
        surveyObj.Q3_Score__c = value;
    }        
    
    public Integer getQ4Value(){
        return q4Value;
    }

    public void setQ4Value(Integer value){
        this.q4Value = value;
       surveyObj.Q4_Score__c = value;
    }        
      public Integer getQ6Value(){
        return q6Value;
    }

    public void setQ6Value(Integer value){
        this.q6Value = value;
       surveyObj.Implementation_Experience__c = value;
    }  
    
    public Integer getQ7Value(){
        return q7Value;
    } 
    
    public Integer getQ71Value(){
        return q71Value;
    }

    public void setQ71Value(Integer value){
        this.q71Value = value;
       surveyObj.Implementation_Advisor_Satisfaction__c = value;
    }
     public Integer getQ72Value(){
        return q72Value;
    }

    public void setQ72Value(Integer value){
        this.q72Value = value;
       surveyObj.Implementation_Advisor_s_ability__c = value;
    }
    public Integer getQ73Value(){
        return q73Value;
    }

    public void setQ73Value(Integer value){
        this.q73Value = value;
       surveyObj.Implementation_Advisor_Communication__c = value;
    }
        public Integer getQ74Value(){
        return q74Value;
    }

    public void setQ74Value(Integer value){
        this.q74Value = value;
       surveyObj.Implementation_Materials_provided__c = value;
    }
 /******************** Properties ends here**********************/
  
  
   /*******************************************************
        Method   declaration section
    ******************************************************/
  
  
  
  public Component.Apex.Image getRogersFooter() {
      Component.Apex.Image rogersFooter = new  Component.Apex.Image();
      rogersFooter.expressions.url = '{!URLFOR($Resource.rogers_survey_logo)}';
      return rogersFooter;  
  }
  public Component.Apex.Image getRogersHeader() {
      Component.Apex.Image rogersHeader = new  Component.Apex.Image();
      return rogersHeader;  
  }
  
   public Component.apex.outputText getThanksMsg(){
        Component.apex.outputText msg = new Component.apex.outputText();
        msg.value = '<b>Thank you for filling out our survey.</b>';
        msg.expressions.rendered = '{!thanksFlag}';
        msg.escape = false;
        return msg;
   }  
        
   public Component.Apex.Image getLogo(){
        Component.Apex.Image logo = new  Component.Apex.Image();
         if(SurveyType == 'Rogers Implementation'){
            rogersFooterFlag = true; 
            rogersHeaderFlag = true;
            logo.expressions.url = '{!URLFOR($Resource.rogers_survey_header)}';
            return logo;
         }
         if(SurveyType == 'Implementation'){
         	if(isBTBrand()){
            	logo.expressions.url = '{!URLFOR($Resource.BTLogo)}';
         	}else{
         		logo.expressions.url = '{!URLFOR($Resource.RcLogo)}';         		
         	}
            return logo;
         }
         if(SurveyType == 'ATT Implementation'){
             logo.expressions.url  = '{!$Resource.ATTSurveyHeader}';
             logo.width = '646px';
            return logo;
         }
       return null;  
    }

    public Component.apex.outputText getAlradyFilled() {
        if(RespondFlag != NULL && RespondFlag == true) {
                Component.apex.outputText msg = new Component.apex.outputText();
                msg.value = '<b>You have already filled this survey.</b>';
                msg.escape = false;
                return msg;
            }
      return null;      
    }
/**********************************************************
                The Constructor 
**********************************************************/
  public ImplementationSurveyController() {
    
        String surveyId;
      try{
            isExpired = false;
            surveyId = ApexPages.currentPage().getParameters().get('id');
            surveyObj = [SELECT Id,Implementation__r.brand__c,Name,Q1_Score__c,Q2_Score__c,Implementation_Advisor_Communication__c,Case_Number__c,Case_Subject__c,Q3_Score__c,Implementation_Materials_provided__c,Implementation_Advisor_Satisfaction__c,Q4_Score__c,Average_Score__c,Comments__c,Implementation_Advisor_s_ability__c,Contact__c,Implementation_Experience__c, Contact__r.Name, 
                            Responded__c, SurveyType__c,CreatedDate , Response_Date__c,Account__r.Number_of_DL_s__c,Account__r.RC_Service_name__c  FROM Survey__c WHERE id=: surveyId];
            if(surveyObj != null && surveyId != null){
                setResponseValue();
            }
            if(surveyObj != null && surveyObj.SurveyType__c != null){
                surveyType = surveyObj.SurveyType__c;
            }
            if(surveyObj != null && surveyObj.SurveyType__c == 'Implementation') {
                setResponseValue();
                System.debug('========>');
            }
            if(surveyObj.Responded__c  != NULL) {
                 if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
                    respondFlag = false;
                    isEmpty = true;
                 }else{
                    respondFlag = true;
                    isEmpty = false;    
                 }
            } else {
                isEmpty = true;
            }           
        } catch (Exception ex) {
            System.debug('inavlid survey -'+ ex.getMessage());
             errorFlag = true;
        }
        checkSurveyAlreadyFilled();
        isSurveyExpired();
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge'); 
        
  }
  /**************************Contructor Ends here *************************************/
  
  
   /**************************************************************
  *@param .....: void                                            *
  *@return.....: void                                            *
  *@Discription: this method is used check that survey is        *
                 already filled                                  *
  ****************************************************************/
   public boolean checkSurveyAlreadyFilled() { 
        try {
            if(surveyObj.Responded__c == 1) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'<b>You have already filled this survey.</b>'));
                return true;
            }
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception Occured.'));
        }
        return false;
    }
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....: void                                            *
  *@Discription: show the value on preview page                  *
  ****************************************************************/
   public void setResponseValue() {                             // For Showing Preview. surveyObj.Implementation_Advisor_s_ability__c = q72Value;
            
        try {
            if(surveyObj.Q1_Score__c != null) {
                q1Value = Integer.valueOf(surveyObj.Q1_Score__c);
            } 
            if(surveyObj.Q2_Score__c != null) {
                q2Value = Integer.valueOf(surveyObj.Q2_Score__c);
                System.debug('@@@@@@@@'+surveyObj.Q2_Score__c);
            }
            if(surveyObj.Q3_Score__c != null) {
                q3Value = Integer.valueOf(surveyObj.Q3_Score__c);
                System.debug('##########'+surveyObj.Q3_Score__c);
            }
            if(surveyObj.Q4_Score__c != null) {
                q4Value = Integer.valueOf(surveyObj.Q4_Score__c);
            }
            if(surveyObj.Implementation_Experience__c != null) {
                q6Value = Integer.valueOf(surveyObj.Implementation_Experience__c) ;
            }
            if(surveyObj.Implementation_Advisor_Communication__c != null) {
                q73Value = Integer.valueOf(surveyObj.Implementation_Advisor_Communication__c);
            }
            if(surveyObj.Implementation_Advisor_Satisfaction__c != null) {
                q71Value = Integer.valueOf(surveyObj.Implementation_Advisor_Satisfaction__c) ;
            }
            if(surveyObj.Implementation_Advisor_s_ability__c != null) {
                q72Value = Integer.valueOf(surveyObj.Implementation_Advisor_s_ability__c) ;
            }
            if(surveyObj.Implementation_Materials_provided__c != null) {
                q74Value = Integer.valueOf(surveyObj.Implementation_Materials_provided__c);
            }
            if(surveyObj.Comments__c != null){
                comment = surveyObj.Comments__c;
            }
        } catch(exception e){}
  }
/*Select Options Lists*/
  /* public List<SelectOption> getValues() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('5','Strongly Agree')); 
        options.add(new SelectOption('4','Somewhat Agree')); 
        options.add(new SelectOption('3','Neither Agree nor Disagree')); 
        options.add(new SelectOption('2','Somewhat Disagree'));
        options.add(new SelectOption('1','Strongly Disagree'));  
        return options; 
    }    

    public List<SelectOption> getValues2() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('5','Completely Satisfied')); 
        options.add(new SelectOption('4','Somewhat Satisfied')); 
        options.add(new SelectOption('3','Neutral')); 
        options.add(new SelectOption('2','Somewhat Dissatisfied'));
        options.add(new SelectOption('1','Completely Dissatisfied'));  
        return options; 
    }   */
    
    public List<SelectOption> getValues3() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('0','0')); 
        options.add(new SelectOption('1','1')); 
        options.add(new SelectOption('2','2')); 
        options.add(new SelectOption('3','3')); 
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('6','6')); 
        options.add(new SelectOption('7','7')); 
        options.add(new SelectOption('8','8')); 
        options.add(new SelectOption('9','9')); 
        options.add(new SelectOption('10','10'));
        return options; 
    }
    
    /*public Component.apex.selectOptions getStaticOptions(){
       Component.apex.selectOptions staticSelectOptions = new Component.apex.selectOptions();
       staticSelectOptions.expressions.value = '{!values}';  
       return staticSelectOptions; 
    }
    public Component.apex.selectOptions getStaticOptions1(){
       Component.apex.selectOptions staticSelectOptions = new Component.apex.selectOptions();
       staticSelectOptions.expressions.value = '{!values2}';
       return staticSelectOptions; 
    }*/
    public Component.apex.selectOptions getStaticOptions2(){
       Component.apex.selectOptions staticSelectOptions = new Component.apex.selectOptions();
       staticSelectOptions.expressions.value = '{!values3}';
       return staticSelectOptions; 
    }
    
    public Component.apex.outputText getFooter(){
        Component.apex.outputText footer = new Component.apex.outputText();
        if(isBTBrand()){
        	footer.value = '<br/>Thank you for taking the time to give us feedback!'; 
        }else{
        	footer.value = '<br/>Thank you for taking the time to give us feedback! <br/>Did you know you can create Support cases using the Web? Checkout <a  href ="http://success.ringcentral.com/RCContactSupp" target="_blank">success.ringcentral.com</a>&nbsp; today!!  <br/><br/>';
        } 
        footer.escape = false;
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             footer.value = '<br/>Thank you for taking the time to give us feedback! <br/>Did you know you can create Support cases using the Web? Checkout <u>success.ringcentral.com</u> &nbsp; today!!  <br/><br/>'; 
        }
        return footer;
    } 
    public Component.apex.outputText getHeader(){
        Component.apex.outputText header = new Component.apex.outputText();
        header.style= 'text-align:center;margin-left: 0.5%;margin-right: 5% !important;';
        if(isBTBrand()){
        	header.value = '<p><b>We would like to thank you for taking the time to provide your feedback regarding<br/> your Implementation experience. It should take about a minute to complete.<p>';
        } else {
        	header.value = '<p><b>We at RingCentral would like to thank you for taking the time to provide your feedback regarding<br/> your Implementation experience. It should take about a minute to complete.<p>';
        }
        header.escape = false;
        return header;
    }

 /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.outputText                      *
  *@Discription: show question 5 on survey Page                  *
  ****************************************************************/
    public Component.Apex.PanelGrid getImplementationSurvey() {
        Component.Apex.PanelGrid implementationPanel = new Component.Apex.PanelGrid();
        implementationPanel.id = 'thePanel';
        implementationPanel.columns = 1;
        
        implementationPanel.childComponents.add(getUserMsg());
        implementationPanel.childComponents.add(getheader());
        
        /*implementationPanel.childComponents.add(getQ1());
        Component.Apex.SelectRadio r1 = radio1Select();
        r1.childComponents.add(getStaticOptions2());
        implementationPanel.childComponents.add(r1);  
        
        implementationPanel.childComponents.add(getQ2());
        r1 = radio2Select();
        r1.childComponents.add(getStaticOptions2());
        implementationPanel.childComponents.add(r1);        
       
        implementationPanel.childComponents.add(getQ3());
        r1 = radio3Select();
        r1.childComponents.add(getStaticOptions2());
        implementationPanel.childComponents.add(r1);  
        
        implementationPanel.childComponents.add(getQ4());
        r1 = radio4Select();
        r1.childComponents.add(getStaticOptions2());
        implementationPanel.childComponents.add(r1);   
        
        implementationPanel.childComponents.add(getQ6());
        r1 = radio6Select();
        r1.childComponents.add(getStaticOptions2());
        implementationPanel.childComponents.add(r1); */ 
        
        implementationPanel.childComponents.add(getQ7());
        
        implementationPanel.childComponents.add(getQ71());
        Component.Apex.SelectRadio r1 = radio1Select();
        r1 = radio71Select();
        r1.childComponents.add(getStaticOptions2());
        implementationPanel.childComponents.add(r1); 
        
        implementationPanel.childComponents.add(getQ72());
        r1 = radio72Select();
        r1.childComponents.add(getStaticOptions2());
        implementationPanel.childComponents.add(r1);     
       
        implementationPanel.childComponents.add(getQ73());
        r1 = radio73Select();
        r1.childComponents.add(getStaticOptions2());
        implementationPanel.childComponents.add(r1);  
        
        implementationPanel.childComponents.add(getQ74());
        r1 = radio74Select();
        r1.childComponents.add(getStaticOptions2());
        implementationPanel.childComponents.add(r1); 
        
       Component.apex.InputTextArea commentArea = new Component.apex.InputTextArea();
       commentArea.expressions.value = '{!comments}'; 
       commentArea.Rows = 4;
       commentArea.cols = 100;
       commentArea.id='comment';
       commentArea.onchange = 'checkLength(this, 2000);';
       commentArea.style = 'width: 88%;';
       if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             commentArea.disabled  =  true;
        }
       implementationPanel.childComponents.add(getQ5());
       implementationPanel.childComponents.add(commentArea);
       implementationPanel.childComponents.add(getfooter()); 
       implementationPanel.childComponents.add(theSave());  
       
      // system.debug('===============>'+ApexPages.currentPage());
       return implementationPanel ;
        
    }
   
   /* Radio For implementation */ 
    public Component.apex.SelectRadio radio1Select(){
        Component.apex.SelectRadio radio1 = new Component.apex.SelectRadio();
        radio1.expressions.value = '{!q1Value}';
        radio1.layout = 'lineDirection'; 
        radio1.style = 'padding-left:3%;';
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             radio1.disabled  =  true;
        }
        //radio1.styleclass = 'radio';
        return radio1;
   } 
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.outputText                      *
  *@Discription: show question 2 on survey Page                  *
  ****************************************************************/
   public Component.apex.SelectRadio radio2Select(){
        Component.apex.SelectRadio radio2 = new Component.apex.SelectRadio();
        radio2.expressions.value = '{!q2Value}';
        radio2.layout = 'lineDirection';
        radio2.style = 'padding-left:3%;';
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             radio2.disabled  =  true;
        }
        return radio2;
   } 
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.SelectRadio                     *
  *@Discription:  radio3Select show in survey page               *
  ****************************************************************/
   public Component.apex.SelectRadio radio3Select(){
        Component.apex.SelectRadio radio3 = new Component.apex.SelectRadio();
        radio3.expressions.value = '{!q3Value}';
        radio3.layout = 'lineDirection';
        radio3.style = 'padding-left:3%;'; 
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             radio3.disabled  =  true;
        }
        return radio3;
   } 
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.SelectRadio                     *
  *@Discription: Component.apex.SelectRadio on survey Page                  *
  ****************************************************************/
   public Component.apex.SelectRadio radio4Select(){
        Component.apex.SelectRadio radio4 = new Component.apex.SelectRadio();
        radio4.expressions.value = '{!q4Value}';
        radio4.layout = 'lineDirection'; 
        radio4.style = 'padding-left:3%;';
        
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             radio4.disabled  =  true;
        }
        return radio4;
   } 
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.SelectRadio                      *
  *@Discription: Component.apex.SelectRadio on survey Page                  *
  ****************************************************************/
   public Component.apex.SelectRadio radio6Select(){
        Component.apex.SelectRadio radio6 = new Component.apex.SelectRadio();
        radio6.expressions.value = '{!q6Value}';
        radio6.layout = 'lineDirection';
        radio6.style = 'padding-left:3%;'; 
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             radio6.disabled  =  true;
        }
        return radio6;
   }
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.SelectRadio                     *
  *@Discription:Component.apex.SelectRadio on survey Page                  *
  ****************************************************************/
   public Component.apex.SelectRadio radio71Select(){
        Component.apex.SelectRadio radio71 = new Component.apex.SelectRadio();
        radio71.expressions.value = '{!q71Value}';
        radio71.layout = 'lineDirection';
        radio71.style = 'padding-left:3%;'; 
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             radio71.disabled  =  true;
        }
        return radio71;
   }
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.SelectRadio                     *
  *@Discription: Component.apex.SelectRadio on survey Page                  *
  ****************************************************************/
  public Component.apex.SelectRadio radio72Select(){
        Component.apex.SelectRadio radio72 = new Component.apex.SelectRadio();
        radio72.expressions.value = '{!q72Value}';
        radio72.layout = 'lineDirection';
        radio72.style = 'padding-left:3%;'; 
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             radio72.disabled  =  true;
        }
        return radio72;
   }
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.SelectRadio                      *
  *@Discription: show question 5 on survey Page                  *
  ****************************************************************/
  public Component.apex.SelectRadio radio73Select(){
        Component.apex.SelectRadio radio73 = new Component.apex.SelectRadio();
        radio73.expressions.value = '{!q73Value}';
        radio73.layout = 'lineDirection';
        radio73.style = 'padding-left:3%;'; 
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             radio73.disabled  =  true;
        }
        return radio73;
   }
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.outputText                      *
  *@Discription: show question 5 on survey Page                  *
  ****************************************************************/
  public Component.apex.SelectRadio radio74Select(){
        Component.apex.SelectRadio radio74 = new Component.apex.SelectRadio();
        radio74.expressions.value = '{!q74Value}';
        radio74.layout = 'lineDirection';
        radio74.style = 'padding-left:3%;'; 
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             radio74.disabled  =  true;
        }
        return radio74;
   }

  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:   Component.apex.outputText                      *
  *@Discription: show page message on survey page                *
  ****************************************************************/
    public Component.apex.outputText getUserMsg() {
         Component.apex.outputText msg = new Component.apex.outputText();
         if(isBTBrand()){
         	msg.value = 'Hello,'; //Thank you for taking the time to fill out our simple survey and helping us learn how to best help you.
         }else{
         	msg.value = 'Hello '+ (surveyObj != NULL  && surveyObj.Contact__r != NULL ? surveyObj.Contact__r.Name : ''); //Thank you for taking the time to fill out our simple survey and helping us learn how to best help you.
                    // '<br/>The questions below pertain to your implementation experience and the Advisor that helped you with that process.<p/>';
         }
         msg.escape = false;
         return msg;            
    }

 /****************************************************************
  *@param .....:  void                                           *
  *@return.....: Component.apex.outputText                      *
  *@Discription: Component.apex.outputText on survey Page                  *
  ****************************************************************/
  public Component.apex.outputText getQ1(){
        Component.apex.outputText q1 = new Component.apex.outputText();
        if(surveyType =='ATT Implementation'){
            q1.value = '<font color=red>*</font><b>1. The Implementation Advisor was knowledgeable concerning Office@Hand products and services.</b><br/> &nbsp; &nbsp; &nbsp; &nbsp;(0 Not at all Satisfied and 10 extremely satisfied)';
        } 
        if(surveyType == 'Rogers Implementation'){
            q1.value = '<font color=red>*</font><b>1. The Implementation Advisor was knowledgeable concerning Rogers products and services.</b><br/> &nbsp; &nbsp; &nbsp; &nbsp;(0 Not at all Satisfied and 10 extremely satisfied)';
        }
        /*if(surveyType == 'Implementation') {
           q1.value ='<font color=red>*</font><b><font color=black>1. The Implementation Advisor was knowledgeable concerning RingCentral products and services.</font></b><br/> &nbsp; &nbsp; &nbsp; &nbsp;(0 Not at all Satisfied and 10 extremely satisfied)';
        }*/
        q1.escape = false;
        return q1;
  } 
  /*public Component.apex.outputText getQ2(){
        Component.apex.outputText q2 = new Component.apex.outputText();
        q2.value = '<font color=red>*</font><b><font color=black>2. The Implementation Advisor assisted me in setting up the right solution for my business needs.</font></b><br/> &nbsp; &nbsp; &nbsp; &nbsp;(0 Not at all Satisfied and 10 extremely satisfied)';
        q2.escape = false;
        return q2;
  } 
  public Component.apex.outputText getQ3(){
        Component.apex.outputText q3 = new Component.apex.outputText();
        q3.value = '<font color=red>*</font><b><font color=black>3. What is your satisfaction level with the Implementation process?</font></b><br/>&nbsp; &nbsp; &nbsp; &nbsp;(0 Not at all Satisfied and 10 extremely satisfied)';
        q3.escape = false;
        return q3;
  } 
  public Component.apex.outputText getQ4(){
        Component.apex.outputText q4 = new Component.apex.outputText();
        q4.value = '<font color=red>*</font><b><font color=black>4. The Implementation Advisor displayed a friendly and helpful attitude towards myself <br/> &nbsp; &nbsp;&nbsp; and my company.</font></b><br/> &nbsp; &nbsp; &nbsp; &nbsp;(0 Not at all Satisfied and 10 extremely satisfied)';
        q4.escape = false;
        return q4;
  } 
  
    public Component.apex.outputText getQ6(){
        Component.apex.outputText q6 = new Component.apex.outputText();
        q6.value = '<font color=red>*</font><b><font color=black>5. Overall, how satisfied are you in your experience with your RingCentral Implementation</font></b><br/>  &nbsp; &nbsp; &nbsp; &nbsp;(0 Not at all Satisfied and 10 extremely satisfied)';
        q6.escape = false;
        return q6;
  }*/
    
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.outputText                      *
  *@Discription: Component.apex.outputText on survey Page                  *
  ****************************************************************/
    public Component.apex.outputText getQ7(){
        String strMsg;
        if(surveyObj.Case_Number__c != null || surveyObj.Case_Subject__c!=null){
            strMsg = '('+surveyObj.Case_Number__c+'['+surveyObj.Case_Subject__c+'])';
        }else{
            strMsg = '';
        }
        //String strMsg = '('+surveyObj.Case_Number__c+'['+surveyObj.Case_Subject__c+'])'
        Component.apex.outputText q7 = new Component.apex.outputText();
        if(isBTBrand()){
        	q7.value = '<b><font color=black> Thinking about your experience with the BT Cloud Phone Implementation Advisor <br/> who assisted you, please rate your level of satisfaction with the following </font></b><br/>&nbsp; &nbsp;<font color =#798496>(0 Not at all Satisfied and 10 extremely satisfied)</font>';
        }else{
        	q7.value = '<b><font color=black> Thinking about your experience with the RingCentral Implementation Advisor <br/> who assisted you, please rate your level of satisfaction with the following </font></b><br/>&nbsp; &nbsp;<font color =#798496>(0 Not at all Satisfied and 10 extremely satisfied)</font>';
        }
        q7.escape = false;
        return q7;
    }
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.outputText                      *
  *@Discription: Component.apex.outputText on survey Page                 *
  ****************************************************************/
   public Component.apex.outputText getQ71(){
        Component.apex.outputText q71 = new Component.apex.outputText();
        q71.value = '&nbsp; &nbsp;<font color=red>*</font>1. Overall satisfaction with your Implementation Advisor.<br/>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;<font color =#798496>(0 Not at all Satisfied and 10 extremely satisfied)</font>';
        q71.escape = false;
        return q71;
  }
   /**************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.outputText                      *
  *@Discription: show Component.apex.outputText on survey Page                  *
  ****************************************************************/
  public Component.apex.outputText getQ72(){
        Component.apex.outputText q72 = new Component.apex.outputText();
        q72.value = '&nbsp; &nbsp;<font color=red>*</font>2. Implementation Advisor’s ability to fulfill your requirements.<br/>&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;<font color =#798496>(0 Not at all Satisfied and 10 extremely satisfied)</font>';
        q72.escape = false;
        return q72;
  }
   /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.outputText                      *
  *@Discription: show Component.apex.outputText on survey Page                  *
  ****************************************************************/
   public Component.apex.outputText getQ73(){
        Component.apex.outputText q73 = new Component.apex.outputText();
        q73.value = '&nbsp; &nbsp;<font color=red>*</font>3. Communication and updates you received from your Implementation Advisor.<br/>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;<font color =#798496>(0 Not at all Satisfied and 10 extremely satisfied)</font>';
        q73.escape = false;
        return q73;
  }
   /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.outputText                      *
  *@Discription: show Component.apex.outputText on survey Page                  *
  ****************************************************************/
  public Component.apex.outputText getQ74(){
        Component.apex.outputText q74 = new Component.apex.outputText();
        if(isBTBrand()){
        	q74.value = '&nbsp; &nbsp;<font color=red>*</font>4. Materials provided to you during your implementation.<br/>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color =#798496>(0 Not at all Satisfied and 10 extremely satisfied)</font>';
        }else{
        	q74.value = '&nbsp; &nbsp;<font color=red>*</font>4. Materials provided to you during your implementation (i.e., Customer On-Boarding Guide, RC Meetings, etc.).<br/>&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color =#798496>(0 Not at all Satisfied and 10 extremely satisfied)</font>';
        }
        q74.escape = false;
        return q74;
  } 
  /***************************************************************
  *@param .....:  void                                           *
  *@return.....:  Component.apex.outputText                      *
  *@Discription: show Component.apex.outputText on survey Page                  *
  ****************************************************************/
   public Component.apex.outputText getQ5(){
        Component.apex.outputText q5 = new Component.apex.outputText();
        q5.value = '<b><font color=black> Please let us know any comments you have about your Implementation experience or<br/>suggestions on how we can improve</font></b>';
        q5.escape = false;
        return q5;
   }   

 
 
 /****************************************************************
  *@param .....: void                                            *
  *@return.....: Component.Apex.commandButton                    *
  *@Discription: used to display button on survey page           *
  ****************************************************************/
  public Component.Apex.commandButton theSave(){
        Component.Apex.commandButton dysaveButton = new Component.Apex.commandButton();
        dysaveButton.value = 'Submit';
        dysaveButton.expressions.action = '{!Save}';
        dysaveButton.style= 'margin-left: 40%';
        if(String.valueOf(ApexPages.currentPage()).contains('ImplementationSurveyPreview')){
             dysaveButton.disabled  =  true;
        }
        return dysaveButton;
  }  
  
  /****************************************************************
  *@param .....: void                                             *
  *@return.....: PageReference                                    *
  *@Discription: This function is used to save the survey         *
  *****************************************************************/
  public PageReference save() {
        Integer live = 0; // in the case if somehow survey is deleted recheck the survey still alive or not
        live = [SELECT count() FROM Survey__c WHERE id=:ApexPages.currentPage().getParameters().get('id')];
                 
        if(live == 0) {
            errorFlag = true;
            respondFlag = false;
            isEmpty = false;
            thanksFlag = false;
            rogersFooterFlag = false;
            rogersHeaderFlag = false;
            return null;
         }  
                     
       /* surveyObj.Q1_Score__c = ( (q1Value == NULL) ? 0 : q1Value); 
        surveyObj.Q2_Score__c = ( (q2Value == NULL) ? 0 : q2Value);
        surveyObj.Q3_Score__c = ( (q3Value == NULL) ? 0 : q3Value);
        surveyObj.Q4_Score__c = ( (q4Value == NULL) ? 0 : q4Value);*/
        
        
         if(q71Value== null|| q72Value == null ||q74Value == null ||q73Value == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please answer all the required questions.'));
                return ApexPages.currentPage();
        } else {
            surveyObj.Implementation_Advisor_s_ability__c = q72Value;
            surveyObj.Implementation_Materials_provided__c = q74Value;
            surveyObj.Implementation_Advisor_Communication__c = q73Value;
            surveyObj.Implementation_Advisor_Satisfaction__c = q71Value;
            surveyObj.Implementation_Experience__c = q6Value;
            surveyObj.Comments__c = comment;
            if(surveyObj.Account__r.Number_of_DL_s__c != null){
                surveyObj.Snapshot_Number_of_DLs__c = surveyObj.Account__r.Number_of_DL_s__c;
            }
            if(surveyObj.Account__r.RC_Service_name__c != null){
                surveyObj.Snapshot_Service_Name__c = surveyObj.Account__r.RC_Service_name__c;
            }
            surveyObj.Responded__c = 1;
            surveyObj.Response_Date__c = System.Today();
            isEmpty = false;
            thanksFlag = true;
           // surveyObj.Average_Score__c = ( surveyObj.Q1_Score__c + surveyObj.Q2_Score__c + surveyObj.Q3_Score__c + surveyObj.Q4_Score__c)/4;
            update surveyObj;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'<b>Thank you for filling out our survey.</b>'));
       }
         
   
    return null;
  }
 
  /****************************************************************
  *@param .....: void                                             *
  *@return.....: void                                             *
  *@Discription: if survey is created more then 30day send error  *
  *              link is expired.                                 *
  *****************************************************************/
  public void isSurveyExpired(){
        try{
        Date createdDate = surveyObj.CreatedDate.date();
        Date todaysDate = System.Today();        
        Integer days = createdDate.daysBetween(todaysDate);
        if(days >=30 && surveyObj.Responded__c == NULL ){
            //s.Status__c = 'closed';
            isExpired = true;
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'<b>This link has expired. If you need any help, '+ 
                                                            'please contact "Implementation Advisors"  at "(866) 737-7704".</b>'));
            System.debug('true');
        }else{
            system.debug('false');
        }
        }catch(Exception e){System.debug('@@@@@@@@');
        }
        
  }
  
	public boolean isBTBrand(){
  		if( surveyObj != null && surveyObj.Implementation__c != null && !string.isBlank(surveyObj.Implementation__r.brand__c) && 
  			surveyObj.Implementation__r.brand__c.containsIgnoreCase('BT') ){
  			return true;
  		}
  		return false;  		
	}
  
}