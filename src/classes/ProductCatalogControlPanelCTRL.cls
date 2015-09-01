/**************************************************************************************************
* Project Name..........: Quoting Tool 3.0                                                        *
* File..................: ProductCatalogControlPanelCTRL.class                                    *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 3/7/2014 11:44 PM                                                       *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 4/15/2014 4:34 AM                                                       *
* Description...........: This is a class used for VF page ProductCatalogControlPanel. It's been  *    
*						  used to add/edit/remove product catalog and Templates. This section is  *
*                         is visible on left side under home page components.                     *
**************************************************************************************************/
public class ProductCatalogControlPanelCTRL {
    public List<RC_Product__c> productList{get;set;}
    public List<RC_Product_Line_Item__c> productLineItemList{get;set;}
    public List<RC_Quote_Template__c> templateList{get;set;}
    public List<TemplateSections__c> sectionList{get;set;}
    
    public String selectedTemplate{get;set;}
    public String selectedSection{get;set;}
    /******************************************************************************
    * @Description : Constructor                                                  *
    * @Params      : Void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public ProductCatalogControlPanelCTRL() {
        productList = new List<RC_Product__c>();
        productLineItemList = new List<RC_Product_Line_Item__c>();
        templateList = new List<RC_Quote_Template__c>();
        sectionList = new List<TemplateSections__c>();
        
        prepareProductList();
        prepareProductLineItemList();
        prepareTemplateList();
        prepareSectionList();
    }
    /******************************************************************************
    * @Description : Prepare Product List                                         *
    * @Params      : Void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    private void prepareProductList() {
        productList = [SELECT Id, Name FROM RC_Product__c];
    }
    /******************************************************************************
    * @Description : Prepare ProductLineItem List                                 *
    * @Params      : Void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    private void prepareProductLineItemList() {
        productLineItemList = [SELECT Id, Name FROM RC_Product_Line_Item__c];
    }
    /******************************************************************************
    * @Description : Prepare Template List                                        *
    * @Params      : Void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    private void prepareTemplateList() {
        templateList = [SELECT Id, Name FROM RC_Quote_Template__c];
    }
    /******************************************************************************
    * @Description : Prepare TemplateSections__c List                             *
    * @Params      : Void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/
    private void prepareSectionList() {
        sectionList = [SELECT Id, Name FROM TemplateSections__c];
    }
    /******************************************************************************
    * @Description : Remove Template                                              *
    * @Params      : Void                                                         *
    * @Return      : Pagereference                                                * 
    ******************************************************************************/
    public Pagereference removeTemplate() {
        if(selectedTemplate != null) {
            RC_Quote_Template__c obj = new RC_Quote_Template__c(id=selectedTemplate);
            delete obj;
            selectedTemplate = null;
        }
        return ApexPages.currentPage();
    }
    /******************************************************************************
    * @Description : Remove Section                                              *
    * @Params      : Void                                                         *
    * @Return      : Pagereference                                                * 
    ******************************************************************************/
    public Pagereference removeSection() {
        if(selectedSection != null) {
            TemplateSections__c obj = new TemplateSections__c(id=selectedSection);
            delete obj;
            selectedSection = null;
        }
        return ApexPages.currentPage();
    }
}