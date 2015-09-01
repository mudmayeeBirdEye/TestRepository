/**************************************************************************************************
* Project Name..........: Quoting Tool 3.0                                                        *
* File..................: InlineQuoteDetailCls.class                                       	      *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 4/15/2014                                                               *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 4/15/2014                                                               *
* Description...........: This is a class used for VF page InlineQuoteDetail. Its been used for-  *
*						  for showing inline details of products/cart/quote under Opportunity -   *
*                         detail page.                                                            *
**************************************************************************************************/
public class InlineQuoteDetailCls {
    
    public String hrefText{get;set;}
    public RC_Quote__c primaryQuoteObj{get;set;}
    public List<RC_Quote__c> quoteList{get;set;}
    public Opportunity oppObj{get;set;}
    public List<Line_Item__c> lineItemList{get;set;}
    public apexpages.standardController controller {get; set;}
    public String sectionHeader{get;set;}
    public String primaryQuoteValidDate{get;set;}
    public List<lineItemWrapper> wrapperList{get;set;}
    public boolean isRCPartnerUser{get;set;}
    
    /************************************* Constructor Code Starts ************************************
	* @Description - Initializing variable, Querying for related Object records                       *
	* @Author      - Simplion Technologies                                                            * 
	**************************************************************************************************/
    public InlineQuoteDetailCls(ApexPages.StandardController stdController){
        controller = stdController;
        hrefText = '';
        hrefText = (Site.getCurrentSiteUrl() != NULL && Site.getCurrentSiteUrl() != ''? Site.getCurrentSiteUrl() : '/apex/');
        String profileName = [Select id,Name from Profile where Id =: userInfo.getProfileId()].Name;
        isRCPartnerUser = (profileName.startsWith('RC Partner') ? true : false);
        oppObj = (Opportunity)Controller.getRecord();
        system.debug('oppObj--->'+oppObj);
        wrapperList = new List<lineItemWrapper> ();
        primaryQuoteObj = new RC_Quote__c();
        quoteList = new List<RC_Quote__c>();
        lineItemList = new List<Line_Item__c>();
        List<RC_Quote__c> tempList = new List<RC_Quote__c>();
        tempList = [SELECT id,name,Quote_Type__c,Initial_Term__c,Total_Initial_Amount__c,Valid_Until_Date__c,Renewal_Term__c,Total_12M_Amount__c,
                           Approved_Status__c FROM RC_Quote__c WHERE Opportunity__c=: oppObj.Id AND IsPrimary__c=true LIMIT 1];
        if(tempList!=null && tempList.size() > 0){
            if(tempList[0].Quote_Type__c == 'Quote'){
                sectionHeader = 'Primary Quote';
            }else if(tempList[0].Quote_Type__c == 'Agreement'){
                sectionHeader = 'Primary Agreement';
            }
            primaryQuoteObj = tempList[0];
            primaryQuoteObj.Renewal_Term__c=(primaryQuoteObj.Renewal_Term__c == '0' ? NULL : primaryQuoteObj.Renewal_Term__c);// to not display 0 in renewal dropdown.
            primaryQuoteValidDate = primaryQuoteObj.Valid_Until_Date__c.format();
            lineItemList = [SELECT id,Name,Discount__c,Discount_Type__c,Effective_Discount__c,Effective_Price__c,List_Price__c,Quantity__c,
                            Total_Price__c,RC_Product_Line_Item__r.RC_Product__c,RC_Product_Line_Item__r.Product_Name__c FROM Line_Item__c
                            WHERE RC_Quote__c=:primaryQuoteObj.Id ORDER BY Order__c ASC];
            
        }else{              
            lineItemList = [SELECT id,Name,Discount__c,Discount_Type__c,Effective_Discount__c,Effective_Price__c,List_Price__c,Quantity__c,
                            Total_Price__c,RC_Product_Line_Item__r.RC_Product__c,RC_Product_Line_Item__r.Product_Name__c FROM Line_Item__c
                            WHERE Opportunity__c=: oppObj.Id ORDER BY Order__c ASC];
            sectionHeader = 'Products';             
        }                   
        quoteList = [SELECT id, name,CreatedDate,Valid_Until_Date__c,IsPrimary__c,Renewal_Term__c,Initial_Term__c,Total_Initial_Amount__c,
                        Total_12M_Amount__c,Approved_Status__c FROM RC_Quote__c WHERE Opportunity__c=: oppObj.Id AND IsPrimary__c=false];
         system.debug('quoteList.size()--->'+quoteList.size());                
        for(RC_Quote__c quoteObj : quoteList){
            wrapperList.add(new lineItemWrapper(quoteObj.Id,quoteObj.name,quoteObj.Valid_Until_Date__c.format(),quoteObj.Initial_Term__c,quoteObj.Renewal_Term__c,
                                                quoteObj.Total_Initial_Amount__c,quoteObj.Total_12M_Amount__c,quoteObj.Approved_Status__c,quoteObj.IsPrimary__c,quoteObj.CreatedDate.format()));
        }
    }
    /************************************* Constructor Code Ends ************************************/
    
    /************************************* Wrapper Class for showing line Items- Starts ***************
	* @Description - Wrapper Class for showing line Items                                             *
	* @Author      - Simplion Technologies                                                            * 
	**************************************************************************************************/
    public class lineItemWrapper{
        public Id quoteId{get;set;}
        public String QuoteName{get;set;}
        public String validUntilDate{get;set;}
        public String initialTerm{get;set;}
        public String renewalTerm{get;set;}
        public Decimal initialAmount{get;set;}
        public Decimal M12Amount{get;set;}
        public String approvedStatus{get;set;}
        public Boolean IsPrimary{get;set;}
        public String createdDate{get;set;}
        
        public lineItemWrapper(Id quoteId,String QuoteName,String validUntilDate,String initialTerm,String renewalTerm,Decimal initialAmount,Decimal M12Amount,
                                String approvedStatus,Boolean IsPrimary,String createdDate){
            this.quoteId = quoteId;
            this.QuoteName = QuoteName;
            this.validUntilDate = validUntilDate;
            this.initialTerm = initialTerm;         
            //this.renewalTerm = renewalTerm;
            this.renewalTerm = (renewalTerm == '0' ? NULL : renewalTerm);// to not display 0 in renewal dropdown.
            this.initialAmount = initialAmount;
            this.M12Amount = M12Amount;
            this.approvedStatus = approvedStatus;
            this.IsPrimary = IsPrimary;
            this.createdDate = createdDate;         
        }
    }
    /************************************* Wrapper Class for showing line Items- Ends ***************/
}