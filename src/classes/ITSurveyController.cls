public class ITSurveyController {

       public Boolean respondFlag{get;set;}
       public Boolean isEmpty{get;set;}
       public Boolean thanksFlag{get;set;} 
       public Boolean rogersFooterFlag{get;set;} // for Rogers Survey
       public Boolean errorFlag{get;set;} 

       private Survey__c surveyObj;

       Integer q1Value = Null;
       Integer q2Value = Null;
       Integer q3Value = Null;
       Integer q4Value = Null;
       Integer q5Value = Null;
       Integer q6Value = Null;       
       Integer q7Value = Null;       
       Integer q8Value = Null;       
       Integer q9Value = Null;       
       Integer q10Value = Null;       
       Integer q11Value = Null;              
       
       public String comment;        
   
   public ITSurveyController(){
   
   try{
    surveyObj = [Select Who_to_contact__c, Resolution__c, Quality_and_Reliability__c, Print_Printers_Service__c, New_Hire_Process__c, Mobility_cell_phone_Service__c, 
       Mac_Support_Services__c, Initial_response__c, Email_Outlook_Service__c, Customer_service_attitude__c, Communicates__c , Responded__c ,Comments__c From Survey__c 
       Where (SurveyType__c ='RC - IT Internal Survey' )
       AND id=:ApexPages.currentPage().getParameters().get('id')];
      
     if(surveyObj != null && surveyObj.Responded__c  != NULL) {
           respondFlag = true;
     } else {
           isEmpty = true;
      } 
    
    }catch(Exception ex ){
          errorFlag = true;  
    }
   
    
   }
 
 /*Response Msg*/
  public Component.apex.outputText getAlradyFilled() {
        if(RespondFlag != NULL && RespondFlag == true) {
                Component.apex.outputText msg = new Component.apex.outputText();
                msg.value = '<b>You have already filled this survey.</b>';
                msg.escape = false;
                return msg;
            }
      return null;      
    }

/*Options*/
 public  List<SelectOption> getValues1() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('5','Very satisfied')); 
        options.add(new SelectOption('4','Somewhat satisfied')); 
        options.add(new SelectOption('3','Neither satisfied nor dissatisfied')); 
        options.add(new SelectOption('2','Somewhat dissatisfied'));
        options.add(new SelectOption('1','Very dissatisfied'));  
        return options; 
    }    

    public  List<SelectOption> getValues2() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('5','Strongly Agree')); 
        options.add(new SelectOption('4','Agree')); 
        options.add(new SelectOption('3','Neutral')); 
        options.add(new SelectOption('2','Disagree'));
        options.add(new SelectOption('1','Strongly Disagree'));  
        return options; 
    } 
    
     public List<SelectOption> getValues3() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('5','5')); 
        options.add(new SelectOption('4','4')); 
        options.add(new SelectOption('3','3')); 
        options.add(new SelectOption('2','2'));
        options.add(new SelectOption('1','1'));  
        return options; 
    }     
 
 
 /*LOGO*/
 public Component.Apex.Image getLogo(){
        Component.Apex.Image logo = new  Component.Apex.Image();
        logo.expressions.url = '{!URLFOR($Resource.It_survey_logo)}';
        return logo;
 }
 
    public Component.apex.selectOptions getStaticOptions1(){
       Component.apex.selectOptions staticSelectOptions = new Component.apex.selectOptions();
       staticSelectOptions.expressions.value = '{!values1}';
       return staticSelectOptions; 
    }
    public Component.apex.selectOptions getStaticOptions2(){
       Component.apex.selectOptions staticSelectOptions = new Component.apex.selectOptions();
       staticSelectOptions.expressions.value = '{!values2}';
       return staticSelectOptions; 
    } 
    
    public Component.apex.selectOptions getStaticOptions3(){
       Component.apex.selectOptions staticSelectOptions = new Component.apex.selectOptions();
       staticSelectOptions.expressions.value = '{!values3}';
       return staticSelectOptions; 
    }
    
 public Component.Apex.PanelGrid getITSurvey() {
         Component.Apex.PanelGrid itSurveyPanel = new Component.Apex.PanelGrid();
         itSurveyPanel.id = 'thePanel';
         itSurveyPanel.columns = 1;
         itSurveyPanel.childComponents.add(getUserMsg());
         itSurveyPanel.childComponents.add(getLogo());
         
        itSurveyPanel.childComponents.add(getQ1());
        Component.Apex.SelectRadio r1 = radio1Select();
        r1.childComponents.add(getStaticOptions1());
        itSurveyPanel.childComponents.add(r1); 
        
        itSurveyPanel.childComponents.add(getQ2());
        r1 = radio2Select();
        r1.childComponents.add(getStaticOptions2());
        itSurveyPanel.childComponents.add(r1); 
        
        itSurveyPanel.childComponents.add(getQ3());
        r1 = radio3Select();
        r1.childComponents.add(getStaticOptions3());
        itSurveyPanel.childComponents.add(r1);
        
        itSurveyPanel.childComponents.add(getQ4());
        r1 = radio4Select();
        r1.childComponents.add(getStaticOptions3());
        itSurveyPanel.childComponents.add(r1);             
        
        
        itSurveyPanel.childComponents.add(getQ5());
        r1 = radio5Select();
        r1.childComponents.add(getStaticOptions2());
        itSurveyPanel.childComponents.add(r1); 
        
        itSurveyPanel.childComponents.add(getQ6());
        r1 = radio6Select();
        r1.childComponents.add(getStaticOptions2());
        itSurveyPanel.childComponents.add(r1); 
        
        
        itSurveyPanel.childComponents.add(getQ7());
        r1 = radio7Select();
        r1.childComponents.add(getStaticOptions1());
        itSurveyPanel.childComponents.add(r1); 
        
        
        itSurveyPanel.childComponents.add(getQ8());
        r1 = radio8Select();
        r1.childComponents.add(getStaticOptions1());
        itSurveyPanel.childComponents.add(r1); 
        
        itSurveyPanel.childComponents.add(getQ9());
        r1 = radio9Select();
        r1.childComponents.add(getStaticOptions1());
        itSurveyPanel.childComponents.add(r1); 
        
        itSurveyPanel.childComponents.add(getQ10());
        r1 = radio10Select();
        r1.childComponents.add(getStaticOptions1());
        itSurveyPanel.childComponents.add(r1); 
        
        itSurveyPanel.childComponents.add(getQ11());
        r1 = radio11Select();
        r1.childComponents.add(getStaticOptions1());
        itSurveyPanel.childComponents.add(r1); 
        
       Component.apex.InputTextArea commentArea = new Component.apex.InputTextArea();
       commentArea.expressions.value = '{!comments}'; 
       commentArea.Rows = 4;
       commentArea.cols = 100;
       commentArea.id='comment';
       commentArea.style='width:100%';
       commentArea.onchange = 'checkLength(this, 2000);';
       
       itSurveyPanel.childComponents.add(getQ12());
       itSurveyPanel.childComponents.add(commentArea); 
       itSurveyPanel.childComponents.add(getFooterMsg());
       itSurveyPanel.childComponents.add(theSave());  
       return itSurveyPanel ;
 }
 /*Welcome msg*/
 public Component.apex.outputText getUserMsg() {
         Component.apex.outputText msg = new Component.apex.outputText();
         msg.value = '<h1>Please provide your feedback and have a Coffee on us!!!!</h1>';
         msg.escape = false;
         return msg;            
    }
 /*Questions*/   
  public Component.apex.outputText getFooterMsg() { 
         Component.apex.outputText msgFooter = new Component.apex.outputText();
         msgFooter.value = '<h1><br/><b>Did you know you can create Support cases using the Web? Checkout <a  href ="http://success.ringcentral.com/RCContactSupp" target="_blank">success.ringcentral.com </a> today!!</b>  <br/><br/></h1>';
         msgFooter.escape = false;
         return msgFooter;            
    }
   public Component.apex.outputText getQ1(){
        Component.apex.outputText q1 = new Component.apex.outputText();
        q1.value = '<font color=red>*</font><b>1. Overall, I am satisfied with the <u>quality and reliability</u> of services provided by IT.</b>';
        q1.escape = false;   
       return q1;
   } 
    public Component.apex.outputText getQ2(){
        Component.apex.outputText q2 = new Component.apex.outputText();
        q2.value = '<font color=red>*</font><b>2. I know <u>who to contact</u> when I have a technology question or problem.</b>';   
        q2.escape = false; 
       return q2;
   }  
    public Component.apex.outputText getQ3(){
        Component.apex.outputText q3 = new Component.apex.outputText();
        q3.value = '<font color=red>*</font><b>3. Please rate IT team’s timeliness of <u>initial response</u> to Help Desk request. (5 being highest)</b>';   
        q3.escape = false; 
       return q3;
   }  
    public Component.apex.outputText getQ4(){
        Component.apex.outputText q4 = new Component.apex.outputText();
        q4.value = '<font color=red>*</font><b>4. Please rate IT team’s timeliness of <u>resolution</u> to Help Desk request. (5 being highest).</b>';   
        q4.escape = false; 
       return q4;
   }  
    public Component.apex.outputText getQ5(){
        Component.apex.outputText q5 = new Component.apex.outputText();
        q5.value = '<font color=red>*</font><b>5. IT staff is courteous and demonstrates <u>customer service attitude</u>.</b>';   
         q5.escape = false; 
       return q5;
   }  
    public Component.apex.outputText getQ6(){
        Component.apex.outputText q6 = new Component.apex.outputText();
        q6.value = '<font color=red>*</font><b>6. IT team <u>communicates</u> the service downtime/change windows timely and effectively.</b>';   
        q6.escape = false; 
       return q6;
   }  
    public Component.apex.outputText getQ7(){
        Component.apex.outputText q7 = new Component.apex.outputText();
        q7.value = '<font color=red>*</font><b>7. Overall, I am satisfied with <u>New Hire Process</u> at RingCentral.</b>';   
        q7.escape = false; 
       return q7;
   }  
    public Component.apex.outputText getQ8(){
        Component.apex.outputText q8 = new Component.apex.outputText();
        q8.value = '<font color=red>*</font><b>8. Overall, I am satisfied with <u>Mac Support/Services</u>.</b>';   
        q8.escape = false; 
       return q8;
   }  
    public Component.apex.outputText getQ9(){
        Component.apex.outputText q9 = new Component.apex.outputText();
        q9.value = '<font color=red>*</font><b>9. Overall, I am satisfied with <u>Email/Outlook</u> Service.</b>';   
        q9.escape = false; 
       return q9;
   }  
    public Component.apex.outputText getQ10(){
        Component.apex.outputText q10 = new Component.apex.outputText();
        q10.value = '<font color=red>*</font><b>10. Overall, I am satisfied with <u>Print/Printers</u> Service.</b>';   
         q10.escape = false; 
       return q10;
   }  
    public Component.apex.outputText getQ11(){
        Component.apex.outputText q11 = new Component.apex.outputText();
        q11.value = '<font color=red>*</font><b>11. Overall, I am satisfied with <u>mobility (cell phone)</u> Service.</b>';   
         q11.escape = false; 
       return q11;
   } 
    /*Please enter any additional comments you may have about your level of satisfaction with IT services.*/
   public Component.apex.outputText getQ12(){
        Component.apex.outputText q12 = new Component.apex.outputText();
        q12.value = '<b>12. Please enter any additional comments you may have about your level of satisfaction with IT services.</b>';   
         q12.escape = false; 
       return q12;
   } 
   
   /*Getter/setter*/
  
   public String getComments(){
        return comment;
    }

    public void setComments(String c){
        this.comment = c;
        //surveyObj.Comments__c = c;
    }
    
    public Integer getQ1Value(){
        return q1Value;
    }

    public void setQ1Value(Integer value){
        this.q1Value = value;
       // surveyObj.Q1_Score__c = value;
    }
    
    public Integer getQ2Value(){
        return q2Value;
    }

    public void setQ2Value(Integer value){
        this.q2Value = value;
       // surveyObj.Q2_Score__c = value;
    }
    
    public Integer getQ3Value(){
        return q3Value;
    }

    public void setQ3Value(Integer value){
        this.q3Value = value;
       // surveyObj.Q3_Score__c = value;
    }        
    
    public Integer getQ4Value(){
        return q4Value;
    }

    public void setQ4Value(Integer value){
        this.q4Value = value;
      // surveyObj.Q4_Score__c = value;
    }  
    
     public Integer getQ5Value(){
        return q5Value;
    }

    public void setQ5Value(Integer value){
        this.q5Value = value;
      // surveyObj.Q4_Score__c = value;
    } 
    
     public Integer getQ6Value(){
        return q6Value;
    }

    public void setQ6Value(Integer value){
        this.q6Value = value;
      // surveyObj.Q4_Score__c = value;
    }               
    
     public Integer getQ7Value(){
        return q7Value;
    }

    public void setQ7Value(Integer value){
        this.q7Value = value;
      // surveyObj.Q4_Score__c = value;
    }   
    
     public Integer getQ8Value(){
        return q8Value;
    }

    public void setQ8Value(Integer value){
        this.q8Value = value;
      // surveyObj.Q4_Score__c = value;
    } 
    
     public Integer getQ9Value(){
        return q9Value;
    }

    public void setQ9Value(Integer value){
        this.q9Value = value;
      // surveyObj.Q4_Score__c = value;
    }
    
     public Integer getQ10Value(){
        return q10Value;
    }

    public void setQ10Value(Integer value){
        this.q10Value = value;
      // surveyObj.Q4_Score__c = value;
    } 
    
     public Integer getQ11Value(){
        return q11Value;
    }

    public void setQ11Value(Integer value){
        this.q11Value = value;
      // surveyObj.Q4_Score__c = value;
    } 
    
    /* Radios*/ 
    public Component.apex.SelectRadio radio1Select(){
        Component.apex.SelectRadio radio1 = new Component.apex.SelectRadio();
        radio1.expressions.value = '{!q1Value}';
        radio1.layout = 'pageDirection'; 
        return radio1;
   } 
   public Component.apex.SelectRadio radio2Select(){
        Component.apex.SelectRadio radio2 = new Component.apex.SelectRadio();
        radio2.expressions.value = '{!q2Value}';
        radio2.layout = 'pageDirection'; 
        return radio2;
   } 
   public Component.apex.SelectRadio radio3Select(){
        Component.apex.SelectRadio radio3 = new Component.apex.SelectRadio();
        radio3.expressions.value = '{!q3Value}';
        radio3.layout = 'pageDirection'; 
        return radio3;
   } 
   public Component.apex.SelectRadio radio4Select(){
        Component.apex.SelectRadio radio4 = new Component.apex.SelectRadio();
        radio4.expressions.value = '{!q4Value}';
        radio4.layout = 'pageDirection'; 
        return radio4;
   } 
   public Component.apex.SelectRadio radio5Select(){
        Component.apex.SelectRadio radio5 = new Component.apex.SelectRadio();
        radio5.expressions.value = '{!q5Value}';
        radio5.layout = 'pageDirection'; 
        return radio5;
   } 
   public Component.apex.SelectRadio radio6Select(){
        Component.apex.SelectRadio radio6 = new Component.apex.SelectRadio();
        radio6.expressions.value = '{!q6Value}';
        radio6.layout = 'pageDirection'; 
        return radio6;
   }
   public Component.apex.SelectRadio radio7Select(){
        Component.apex.SelectRadio radio7 = new Component.apex.SelectRadio();
        radio7.expressions.value = '{!q7Value}';
        radio7.layout = 'pageDirection'; 
        return radio7;
   }  
   
   public Component.apex.SelectRadio radio8Select(){
        Component.apex.SelectRadio radio8 = new Component.apex.SelectRadio();
        radio8.expressions.value = '{!q8Value}';
        radio8.layout = 'pageDirection'; 
        return radio8;
   }  
   public Component.apex.SelectRadio radio9Select(){
        Component.apex.SelectRadio radio9 = new Component.apex.SelectRadio();
        radio9.expressions.value = '{!q9Value}';
        radio9.layout = 'pageDirection'; 
        return radio9;
   }
   public Component.apex.SelectRadio radio10Select(){
        Component.apex.SelectRadio radio10 = new Component.apex.SelectRadio();
        radio10.expressions.value = '{!q10Value}';
        radio10.layout = 'pageDirection'; 
        return radio10;
   } 
     public Component.apex.SelectRadio radio11Select(){
        Component.apex.SelectRadio radio11 = new Component.apex.SelectRadio();
        radio11.expressions.value = '{!q11Value}';
        radio11.layout = 'pageDirection'; 
        return radio11;
   }
   /*Save Action*/  
   public PageReference save() {
     
     if( q1Value == NULL || q2Value == NULL|| q3Value == NULL || q4Value == NULL || q5Value == NULL || q6Value == NULL || q7Value == NULL || q8Value == NULL 
         || q9Value == NULL || q10Value == NULL || q11Value == NULL){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill mandatory Questions.')); 
                  return ApexPages.currentPage();
     }
    else{
      surveyObj.Quality_and_Reliability__c = q1Value; 
      surveyObj.Who_to_contact__c = q2Value;
      surveyObj.Initial_response__c = q3Value;
      surveyObj.Resolution__c = q4Value; 
      surveyObj.Customer_service_attitude__c = q5Value; 
      surveyObj.Communicates__c =  q6Value;     
      surveyObj.New_Hire_Process__c = q7Value;     
      surveyObj.Mac_Support_Services__c = q8Value;     
      surveyObj.Email_Outlook_Service__c = q9Value;      
      surveyObj.Print_Printers_Service__c = q10Value;     
      surveyObj.Mobility_cell_phone_Service__c = q11Value;
      }
      
      if(comment.length() > 2000){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please limit your comments in 2000 characters.')); 
           return ApexPages.currentPage();
      }
      surveyObj.Comments_IT_Survey__c = comment;
      surveyObj.Responded__c = 1;
      surveyObj.Response_Date__c = System.Today();
       
        isEmpty = false;
        thanksFlag = true;
     
     update surveyObj;
   
     return null;
  }  
  /*Thanks*/ 
   public Component.apex.outputText getThanksMsg(){
        Component.apex.outputText msg = new Component.apex.outputText();
        msg.value = '<b>Thank you for filling out our survey.</b>';
        msg.expressions.rendered = '{!thanksFlag}';
        msg.escape = false;
        return msg;
   }  
  /*Save Button*/
    public Component.Apex.commandButton theSave(){
    Component.Apex.commandButton dysaveButton = new Component.Apex.commandButton();
    dysaveButton.value = 'Submit';
    dysaveButton.expressions.action = '{!Save}';
    return dysaveButton;
  }  
  
   /*The Test Method*/
/*static testMethod void testITSurveyController() {
   
   Survey__c surveyObj = new Survey__c();
   surveyObj.SurveyType__c = 'RC - IT Internal Survey';
   surveyObj.Contact_Email__c ='faks@fake.com';
   insert surveyObj;
   
    ApexPages.currentPage().getParameters().put('id', surveyObj.id);  
   	ITSurveyController its = new ITSurveyController();
   	its.setQ1Value(1);
    its.setQ2Value(2);
    its.setQ3Value(3);
    its.setQ4Value(4);
    its.setQ5Value(5);
    its.setQ6Value(4);
    its.setQ7Value(3);
    its.setQ8Value(2);
    its.setQ9Value(2);
    its.setQ10Value(2);
    its.setQ11Value(2);
    
     System.assertEquals(1, its.getQ1Value());
     System.assertEquals(2, its.getQ2Value());
     System.assertEquals(3, its.getQ3Value());
     System.assertEquals(4, its.getQ4Value());
     System.assertEquals(5, its.getQ5Value());
     System.assertEquals(4, its.getQ6Value());
     System.assertEquals(3, its.getQ7Value());
     System.assertEquals(2, its.getQ8Value());
     System.assertEquals(2, its.getQ9Value());
     System.assertEquals(2, its.getQ10Value());
     System.assertEquals(2, its.getQ11Value());
   
    
    its.setComments('these are my comments');
    System.assertEquals('these are my comments', its.getComments());
    
    its.getITSurvey();
    its.getAlradyFilled();
    its.save();
    its.getThanksMsg();
    its.getValues1();
    its.getValues2();
    its.getValues3();
    
   Survey__c surveyObj1 = new Survey__c();
   surveyObj1.SurveyType__c = 'RC - IT Internal Survey';
   surveyObj1.Contact_Email__c ='faks@fake.com';
   surveyObj1.Responded__c = 1;
   insert surveyObj1;
   
   ApexPages.currentPage().getParameters().put('id', surveyObj1.id);  
   ITSurveyController its1 = new ITSurveyController();
   its1.getAlradyFilled();
   its1.comment = '1';
   for(Integer i= 1;i<2200;i++){
   	its1.comment =  its1.comment + i;
   }
   its1.save();
    
   ApexPages.currentPage().getParameters().put('id', '11111111111');  
   ITSurveyController its2 = new ITSurveyController(); 
   } */                   
}