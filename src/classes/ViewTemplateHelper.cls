/**************************************************************************************************
* Project Name..........: Quoting Tool 3.0                                                        *
* File..................: ViewTemplateHelper.class                                                *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 3/7/2014                                                                *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 4/15/2014                                                               *
* Description...........: This is a class used for VF page ViewTemplate. It's been called when -  *
*                         user hits on Generate PDF button on Quote page                          *
**************************************************************************************************/
public class ViewTemplateHelper {
	public String opptyId{get;set;}
	public String quoteId{get;set;}
	public RC_Quote_Template__c templateObj {get;set;}
	Opportunity oppObj{get;set;}
    RC_Quote__c quoteObj{get;set;} 
    public String hrefText{get;set;}
    public String hrefTextId{get;set;}
    /******************************************************************************
    * @Description : Constructor                                                  *
    * @Params      : ApexPages.StandardController                                 *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public ViewTemplateHelper(ApexPages.StandardController controller) {
    	hrefTextId = (Site.getCurrentSiteUrl() != NULL && Site.getCurrentSiteUrl() != ''? Site.getCurrentSiteUrl() : '/');
    	hrefText = (Site.getCurrentSiteUrl() != NULL && Site.getCurrentSiteUrl() != ''? Site.getCurrentSiteUrl() : '/apex/');
    	oppObj = new Opportunity();
        quoteObj = new RC_Quote__c();
    	//-------------------------------AS/Simplion/8/5/2014-------------------------------------------
        //-------------------------------Added version field in query----------------------------------
    	templateObj = [ SELECT Id,Version__c FROM RC_Quote_Template__c WHERE Id =:controller.getId()];
		opptyId = ApexPages.currentPage().getParameters().get('opptyid');
    	quoteId = ApexPages.currentPage().getParameters().get('quoteid');
    	try {
			//-------------------------------AS/Simplion/8/5/2014-------------------------------------------
        	//-------------------------------Added PDF_Template_Version__c field in query----------------------------------
			quoteObj = [SELECT Id, Opportunity__c, Quote_Type__c,PDF_Template_Version__c FROM RC_Quote__c WHERE Id =: quoteId];
			oppObj = [SELECT Id, Name FROM Opportunity WHERE Id =: quoteObj.Opportunity__c];
    	} catch(Exception ex) {addMessage('This is not a valid quote.');}
    }
    /******************************************************************************
    * @Description : Generic Method to add Message on VF page                     *
    * @Params      : String                                                       *
    * @Return      : void                                                         * 
    ******************************************************************************/
    private void addMessage(String str) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, str));
    }
    /******************************************************************************
    * @Description : Method to attach content with opportunity related list attac-*
    *                - ments                                                      *
    * @Params      : String                                                       *
    * @Return      : PageReference                                                * 
    ******************************************************************************/
    public PageReference attachContent() {
    	try {
		/* Get the page definition */
        PageReference pdfPage = Page.ViewTemplate;
        /* set the quote id on the page definition */
        pdfPage.getParameters().put('id',templateObj.Id); 
	    pdfPage.getParameters().put('opptyid',opptyId);
	    pdfPage.getParameters().put('quoteid',quoteId);
	    //-------------------------------AS/Simplion/8/5/2014-------------------------------------------
    	//-------------------------------Adding version of template in quoteObject----------------------------------
	    if(templateObj  != null && !String.isBlank(templateObj.Version__c) && quoteObj != null){
	    
	    	quoteObj.PDF_Template_Version__c = templateObj.Version__c;
	    }
	    
	    if(templateObj  != null && !String.isBlank(templateObj.Version__c) && oppObj != null){
	    
	    	oppObj.PDF_Template_Version__c = templateObj.Version__c;
	    }
	    update quoteObj;
	    update oppObj;
	    System.debug('~~~~~~~~~~~~~~~~~~~~~quoteId'+quoteId);	    
        /* generate the pdf blob */
        Blob pdfBlob;
        if(Test.isRunningTest()) {
	  		pdfBlob = EncodingUtil.base64Decode('Test');
	  	} else {
	  		pdfBlob = pdfPage.getContent();
        }
        /* create the attachment against the quote */
        String qType = quoteObj.Quote_Type__c;
        Attachment a = new Attachment(parentId = oppObj.Id, Name=(String.isBlank(qType) ? 'Quote' : qType)+' For '+ oppObj.Name+' - '+ system.Today().format()+' File.pdf', body = pdfBlob);
        /* insert the attachment */
        insert a;		

			// return null;//ApexPages.currentPage().getParameters().put('opptyid'=>opptyId, );
			return new PageReference('/'+oppObj.Id+'#'+oppObj.Id+'_RelatedNoteList_target');
    	} catch(Exception ex) {addMessage('Error occured while generating quote.');}
    	return null;
    }
    // Unused code, keeping for backup.
    /*
    private void alternateFunction() {
    	// Get the page definition
        PageReference pdfPage = Page.ViewTemplate;
        
        //set the quote id on the page definition
        pdfPage.getParameters().put('id',templateObj.Id); 
	    pdfPage.getParameters().put('opptyid',opptyId);
	    pdfPage.getParameters().put('quoteid',quoteId);
        
        //generate the pdf blob
        Blob pdfBlob = pdfPage.getContent();
        
        //create the attachment against the quote
        Attachment a = new Attachment(parentId = opptyId, name='This is Oppty Test '+system.now()+' File.pdf', body = pdfBlob);
        
        //insert the attachment 
        insert a;
    }
    */
}