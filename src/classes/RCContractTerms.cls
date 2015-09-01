/*************************************************
RCContractTerms class
RCContractTerms takes information sent by RCContractDetails via URL parameters
Shows preview of contract with filled in fields from passed data
Allows user to render as PDF and automatically mail to customer which also saves it as an attachment to a new Contact object
The rendering of page as PDR, which also hides the buttons, is done by a URL parameter which controls the renderAs="{!chooserender}" of page header. 
/************************************************/
public class RCContractTerms {
    Account acc;
    Boolean renderButton;
    
    public RCContractTerms(ApexPages.StandardController controller) {
        renderButton = true;  
    }
    
    public String getStrName() {
        return ApexPages.currentPage().getParameters().get('name');
    }    
    
    public String getStrEmail() {
        return ApexPages.currentPage().getParameters().get('email');
    }  

    public String getStrNoLines() {
        return ApexPages.currentPage().getParameters().get('noOfLines');
    }
    
    public String getStrNoAddLines() {
        return String.valueOf(Decimal.valueOf(ApexPages.currentPage().getParameters().get('noOfLines')) - 10);
    }    
     
    public String getStrPrice() {
        return ApexPages.currentPage().getParameters().get('price');
    }  
    
    public String getStrOperatorEmail() {
        return ApexPages.currentPage().getParameters().get('operatorEmail');
    }
    
    public String getStrOperatorFax() {
        return ApexPages.currentPage().getParameters().get('operatorFax');
    }
    
    public String getStrAccountId() {
        return ApexPages.currentPage().getParameters().get('accountId');
    }
    
    public String getStrTerm(){
    	return ApexPages.currentPage().getParameters().get('term');
    }
    
    public String getStrYears(){
    	return ApexPages.currentPage().getParameters().get('years');
    }    
    
    /*
    This is the method used in RCContracTerm.page <apex:page> tag. 
    If it returns pdf then the page will render as a pdf and not display the buttons.
	*/    
    public String getChooserender() {
        if (ApexPages.currentPage().getParameters().get('p') != null){
            renderButton = false;
            return 'pdf';
        }         
        else
        return null;
    }
    
    public Boolean getRenderButton(){
        return renderButton;
    }     
    
    /* 
    deliverAsPDF is called by button on RCContractTerms.page.
    creates new page instance with all the parameters and also parameter p which signals getChooseRender to render page as PDF.
    Then it takes the content of that instance and creates a PDF attachment so it can be emailed to Contact.
    A new Contract object is created also under related Account. The PDF is saved to that Contract object as an attachment. 
    Send user to RCContractSent to confirm for them that contract has been sent. 
    */    
    public PageReference deliverAsPDF() {
    	PageReference sent = Page.RCContractSent;
    	
        PageReference pdf =  Page.RCContractTerms;
        //pdf.getParameters().put('startDate',getStrStart()); 
        pdf.getParameters().put('term',getStrTerm());
        pdf.getParameters().put('years',getStrYears());
        pdf.getParameters().put('accountId',getStrAccountId());        
        pdf.getParameters().put('name',getStrName()); 
        pdf.getParameters().put('email',getStrEmail());            
        pdf.getParameters().put('noOfLines',getStrNoLines());  
        pdf.getParameters().put('price',getStrPrice());  
        pdf.getParameters().put('operatorEmail',getStrOperatorEmail());
        pdf.getParameters().put('operatorFax',getStrOperatorFax());  

        pdf.getParameters().put('p','p');
        pdf.setRedirect(true);
        //return pdf;
        Blob b = pdf.getContent();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        email.setSubject('IMPORTANT: RingCentral contract enclosed');    
        String [] toAddresses = new String[] {getStrEmail()};
        email.setToAddresses(toAddresses);
        List<String> BccAddresses = new List<String>();
        BccAddresses.add(getStrOperatorEmail());
        email.setBccAddresses(BccAddresses);
        email.setHtmlBody('Dear ' + getStrName() + ', <BR><BR>Thanks for taking the time to learn about RingCentral office. We’re excited to have you as a customer, and confident that RingCentral Office will take care of all your business phone system needs!<BR><BR>Complete your RingCentral Office purchase by signing the enclosed contract and returning it by fax or email. You can find my direct fax and email contact information in the contract.<BR><BR>We look forward to serving you!<BR><BR>Best regards, <BR>' + UserInfo.getName());
        // Create an email attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Contract.pdf'); // neat - set name of PDF
        efa.setBody(b); //attach the PDF
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        // send it, ignoring any errors (bad!)
        Messaging.SendEmailResult [] r ;
        try{
           r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        }catch(Exception exp){}
        system.debug('THIS are r [] values: ' + r);
        
        Contract contract = new Contract();
        contract.OwnerId = UserInfo.getUserId();
        contract.AccountId = getStrAccountId();
        contract.ContractTerm = integer.valueOf(getStrTerm());
        contract.Total_Number_Of_Lines__c = decimal.valueOf(ApexPages.currentPage().getParameters().get('noOfLines'));
        contract.Initial_Monthly_Price__c = decimal.valueOf(getStrPrice());
        contract.Customer_Name__c = getStrName();
        contract.Customer_Email__c = getStrEmail();
        insert contract;
       
        Attachment attach = new Attachment();
        attach.Name = 'Contract Generated and Sent ' + DateTime.now().format() + '.pdf';
        attach.Body = pdf.getContent();
        attach.OwnerId = UserInfo.getUserId();
        attach.ParentId = contract.Id;
        insert attach;             

        return sent;
    }    

}