/************************************************************************************************************
* Project Name................: Quoting Tool 3.0                                                          *
* File........................: ProductQuoteWizardCls.class                                               *
* Version.....................: 1.0                                                                       *
* Created by..................: Simplion Technologies                                                     *
* Created Date................: 3/7/2014 11:44 PM                                                         *
* Last Modified by............: Simplion Technologies                                                     *
* Last Modified Date @Log 1...: 4/15/2014 4:34 AM                                                        *
*                    @Log 2...: 12/20/2014 - for Case# 03027437                        *
* Description.................: This is a class used for VF page ProductQuoteWizard. Its been used for-   *
*                    for selecting products, adding to cart, creating, updating RC Quotes,-    *
*                    Converting to Sales agreement, creating Approval Record for Non-Standard  *    
*                    discounts etc.                                                            *
************************************************************************************************************/
public class ProductQuoteWizardCls{
  
  public boolean isRCPartnerUser{get;set;} 
  // @Log 2 @Log 2 As on 12/20/2014
  public String initialTerm{get;set;}
  public String renewalTerm{get;set;}
  //variables for showing correct URL for partner profiles 
  public String hrefText{get;set;}
    public String hrefTextId{get;set;}
  
  //Variables for product search
    public String strProductFamily{get;set;}  
    public String strChargeTerm {get;set;}
    public String strServiceType {get;set;}
    public String strProductName{get;set;}
    public String JustificationandDescription{get;set;}
    public string oldSpecialTermValue{get;set;}
    
    //Varibales for URL parameters
    public String strOpportunityId;
    public String responseFrom; 
    public String strQuoteId;     
     
    //Variable for Product picklist values
    public RC_Product__c productObj;
    
    //Variables for rendering blocks on VF page
    public Boolean showProductBlock {get;set;}
    public Boolean showJustificationBool{set;get;}
    public Boolean showPage{get;set;}
    public Boolean menuFlag{get;set;}
    public Boolean wasQuotePrimaryBool{get;set;}
    
    //SelectOption picklists for product tab and discount type
    public List<selectOption> productFamilyLst{get;set;}
    public List<selectOption> productChargeTermLst{get;set;}
    public List<selectOption> productServiceTypeLst{get;set;}
    public List<SelectOption> discountTypeOptions{set;get;}
    
    //Global list used in whole code
    public List<RC_Product__c> productList;
    public List<Opportunity> opportunityLst;
    public List<RC_Quote__c> quoteList;
    public List<RC_Product_Line_Item__c> productLineItemList;
    public List<Line_Item__c> lineItemGlobalList;
    public List<Line_Item__c> lineItemDeleteList;
    
    //getting recodType of approval
    public Map<String,Id> appRecordtypeMap = new Map<String,Id>();
    
    //Lists binded on VF page
    public List<productWrapper> productWrapperLst{get;set;}     
    public List<Approval__c> approvalList{get;set;}
    
    //Variables to store values that are used on VF page.
    public Opportunity oppObj{get;set;}
    public RC_Quote__c quoteObj{get;set;}   
    public RC_Quote__c tempQuoteObj{get;set;}  
    public OpportunityContactRole oppContactRoleObj{get;set;}
    public String openTab{get;set;}
    public String currencyCode{get;set;}   
    public Id parentProductId {get;set;}
    public Id childProductId {get;set;}
    public Boolean showQuoteEditMode{get;set;}
    public Boolean showQuoteReadOnlyMode{get;set;}
    public Integer cartSize{get;set;}
    public Decimal grandTotal{get;set;}    
    public Boolean showIsNewQuote{get;set;}
    
    //Redirect to PDF generation page.
    public List<SelectOption> templateList{get;set;}
    public String selectedTemplate{get;set;}
    public Boolean showTemplatePanel{get;set;}    
    public List<RC_Quote_Template__c> templateRecordList {get;set;}
    
    //Map to store selected Product Line Item records Ids
    public Map<Id,Boolean> selectedProductMap;
    
    //Map to store ProductId as first key and return Map which contains Lower Limit of PLI as Key and corresponding PLI as value.    
    public Map<Id,Map<Integer,RC_Product_Line_Item__c>> productMap;
    
    //Map store productId as key and DependentSKUs as value.
    public Map<id,String> productDependentSKUMap;
    
    //Map store SKU OF PLI as Key and lineItemWrapper as value.
    public Map<String,lineItemWrapper> productLineItemSKUMap;
    
    //Map to hold line Item items
    public Map<id,Line_Item__c> lineItemsMap;
    
    //Map to be shown on Cart Tab as per grouping of products.
    public Map<Id,List<lineItemWrapper>> wrapperObjMap{get;set;} 
    
    /************************************* Constructor Code Starts ************************************
  * @Description - Initializing variable, Querying for related recordtypes, dispaying appropriate - *
  *         tabs by calling displayTab() Method.                                             *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/ 
    public ProductQuoteWizardCls(){
        try{
          hrefText = '';
          hrefTextId = '';
          oldSpecialTermValue = '';
          hrefTextId = (Site.getBaseUrl() != NULL && Site.getBaseUrl() != ''? Site.getBaseUrl() : '/');
          hrefText = (Site.getBaseUrl() != NULL && Site.getBaseUrl() != ''? Site.getBaseUrl() : '/apex/');
          //Fetching URL parameters
            strOpportunityId = ApexPages.currentPage().getParameters().get('oppId');   
            responseFrom = ApexPages.currentPage().getParameters().get('response'); 
            strQuoteId = ApexPages.currentPage().getParameters().get('quoteId');
            String profileName = '' ;  
            if(!Test.isRunningTest()){
              profileName = [Select id,Name from Profile where Id =: userInfo.getProfileId()].Name;
            }
            
            isRCPartnerUser = false;
            isRCPartnerUser = (profileName.startsWith('RC Partner') ? true : false);
            
            //Initialization and assigning default values    
            productObj = new RC_Product__c();
            oppObj = new Opportunity();
            oppContactRoleObj = new OpportunityContactRole();
            quoteObj = new RC_Quote__c();
            tempQuoteObj = new RC_Quote__c();
            showIsNewQuote = false;
            quoteList = new List<RC_Quote__c>();
            selectedProductMap = new Map<Id,Boolean>();            
            wrapperObjMap = new Map<Id,List<lineItemWrapper>>();
            approvalList = new List<Approval__c>();
            lineItemGlobalList = new List<Line_Item__c>();
            lineItemDeleteList = new List<Line_Item__c>();
            productFamilyLst = new List<selectOption>();
            productChargeTermLst = new List<selectOption>();
            productServiceTypeLst = new List<selectOption>();
            lineItemsMap = new Map<Id,Line_Item__c>();
            productFamilyLst = getPickValues(productObj,'Category__c','--None--');
            productChargeTermLst = getPickValues(productObj,'Charge_Term__c','--None--');
            productServiceTypeLst = getPickValues(productObj,'Service_Type__c','--None--');
            strProductFamily = 'Service';
            showProductBlock = false;
            showPage = false;
            showQuoteEditMode = true;
          showQuoteReadOnlyMode = false;
          menuFlag=false;
          wasQuotePrimaryBool = false;
          cartSize = 0;
          grandTotal = 0;
            productMap = new Map<Id,Map<Integer,RC_Product_Line_Item__c>>();
            productDependentSKUMap = new Map<id,String>();            
            productLineItemSKUMap = new Map<String,lineItemWrapper>();
            openTab = 'productTab';  
            
            List<RecordType> recordTypeList = [SELECT Id,name,developername,sObjectType FROM RecordType WHERE sObjectType='Approval__c'];
            if(recordTypeList.size() >0){
              for(RecordType recType : recordTypeList){
                appRecordtypeMap.put(recType.developername,recType.Id);  
              }
            }
            JustificationandDescription='';// variable holding value of JustificationandDescription of approval
            //Check If URL contains Opportunity ID       
            if(!String.isBlank(strOpportunityId)){
                opportunityLst = new List<Opportunity>();
                opportunityLst = [SELECT id,name,Primary_Opportunity_Contact__c,CurrencyIsoCode,AccountId,Account.Name,RecordType.Name, Brand_Name__c,
                          (SELECT id FROM RC_Quotes__r WHERE IsPrimary__c=true) FROM Opportunity WHERE id=: strOpportunityId];  
                List<OpportunityContactRole> oppContactRoleList = new List<OpportunityContactRole>();
                oppContactRoleList = [SELECT Id,ContactId,Contact.FirstName,Contact.LastName,Contact.Email,Contact.Phone,IsPrimary,OpportunityId,Role 
                          FROM OpportunityContactRole WHERE IsPrimary=true AND OpportunityId=: strOpportunityId ];                        
                if(opportunityLst!=null && opportunityLst.size() > 0){
                  oppObj = opportunityLst[0];
                  quoteObj.Opportunity__c = oppObj.id;                  
                  oppContactRoleObj = (oppContactRoleList != NULL && oppContactRoleList.size() > 0 ? oppContactRoleList[0]:NULL);
                  currencyCode = opportunityLst[0].CurrencyIsoCode;
                  showPage = true;
                  displayTab();
                }else{
                  addMessage('Invalid Opportunity Id!!!');
                }
            }else{
              addMessage('No Opportunity Provided!!!');                
            }            
        }catch(exception e){
           addMessage(e.getMessage()+e.getLineNumber());             
        }
    }
    /************************************* Constructor Code- Ends ************************************/
    
    
    /************************************* Method for displaying the tab- Starts **********************
  * @Description - Method to find which tab(Product/Cart/Quote) to display on page load.This method-*
  *         is being called FROM Constructor code.                                        *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/ 
    public void displayTab(){      
      
      Set<String> quoteRecordIds = new Set<String>();
      if(!String.isBlank(strQuoteId)) {
        quoteList = [SELECT id,Approved_Status__c,Total_12M_Amount__c, Total_Initial_Amount__c,Name,Contact__c,Valid_Until_Date__c,Start_Date__c,CurrencyIsoCode,
                  Initial_Term__c,Agreement_Status__c,Auto_Renewal__c,End_Date__c,IsPrimary__c,Opportunity__c,Quote_Type__c,Renewal_Term__c,
                  Special_Terms_and_Notes__c,Special_Terms_and_Notes_Picklist__c,Special_Terms_Approval_Level__c,Total_12M_Discount__c,Initial_Total_Discount__c,Opportunity_Record_Type__c,
                  (SELECT id FROM Line_Items__r ORDER BY order__c ASC) FROM RC_Quote__c WHERE Id=:strQuoteId LIMIT 1];
      } else {
        quoteList = [SELECT id,Approved_Status__c,Total_12M_Amount__c, Total_Initial_Amount__c,Name,Contact__c,Valid_Until_Date__c,Start_Date__c,CurrencyIsoCode,
            Initial_Term__c,Agreement_Status__c,Auto_Renewal__c,End_Date__c,IsPrimary__c,Opportunity__c,Quote_Type__c,Renewal_Term__c,
            Special_Terms_and_Notes__c,Special_Terms_and_Notes_Picklist__c,Special_Terms_Approval_Level__c,Total_12M_Discount__c,Initial_Total_Discount__c,Opportunity_Record_Type__c,
            (SELECT id FROM Line_Items__r ORDER BY order__c ASC) FROM RC_Quote__c WHERE Opportunity__c=:strOpportunityId and IsPrimary__c=true LIMIT 1];
      }
      for(RC_Quote__c qObj : quoteList) {
        quoteRecordIds.add(qObj.Id);
      }
          
    List<Line_Item__c> lineItemList = new List<Line_Item__c>();
    
    if(quoteList!=null && quoteList.size() > 0){
        lineItemList = [SELECT id,Discount__c,Discount_Type__c,Effective_Discount__c,Effective_Price__c,List_Price__c,Approval_Required__c,RC_Product_Line_Item__r.RC_Product__r.Excluded_SKUs__c,
                  Opportunity__c,Quantity__c,RC_Product_Line_Item__c,Total_Price__c,RC_Product_Line_Item__r.RC_Product__c,RC_Product_Line_Item__r.RC_Product__r.Excluded_Types__c,
                  RC_Product_Line_Item__r.Product_Name__c,RC_Product_Line_Item__r.Name,RC_Product_Line_Item__r.RC_Product__r.Dependent_SKUs__c,
                  RC_Product_Line_Item__r.Max_Discount__c,RC_Product_Line_Item__r.Product_SKU__c,RC_Quote__c,RC_Product_Line_Item__r.RC_Product__r.Charge_Term__c,
                  RC_Product_Line_Item__r.price__c,RC_Product_Line_Item__r.RC_Product__r.Product_Type__c,RC_Product_Line_Item__r.RC_Product__r.Category__c FROM Line_Item__c
                  WHERE RC_Quote__c IN:quoteRecordIds ORDER BY order__c ASC];            
    }else{
      lineItemList = [SELECT id,Discount__c,Discount_Type__c,Effective_Discount__c,Effective_Price__c,List_Price__c,Approval_Required__c,RC_Product_Line_Item__r.RC_Product__r.Excluded_SKUs__c,
                            Opportunity__c,Quantity__c,RC_Product_Line_Item__c,Total_Price__c,RC_Product_Line_Item__r.RC_Product__c,RC_Product_Line_Item__r.RC_Product__r.Excluded_Types__c,
                            RC_Product_Line_Item__r.Product_Name__c,RC_Product_Line_Item__r.Name,RC_Product_Line_Item__r.RC_Product__r.Dependent_SKUs__c,
                            RC_Product_Line_Item__r.Max_Discount__c,RC_Product_Line_Item__r.Product_SKU__c,RC_Quote__c,RC_Product_Line_Item__r.RC_Product__r.Charge_Term__c,                           
                            RC_Product_Line_Item__r.price__c,RC_Product_Line_Item__r.RC_Product__r.Product_Type__c,RC_Product_Line_Item__r.RC_Product__r.Category__c FROM Line_Item__c
                            WHERE Opportunity__c=:strOpportunityId ORDER BY order__c ASC];
    }
    
    //If Product already exists for Opportunity
      if(lineItemList!=null && lineItemList.size() > 0){        
        Map<String,List<Id>> dependentProductMap = new Map<String,List<Id>>();
        set<String> productSKUSet = new Set<String>();
        for(Line_Item__c lineItem: lineItemList){
          lineItemsMap.put(lineItem.Id,lineItem);
          grandTotal+=(lineItem.Total_Price__c).setScale(2);
          selectedProductMap.put(lineItem.RC_Product_Line_Item__r.RC_Product__c,true);
          productSKUSet.add(lineItem.RC_Product_Line_Item__r.Product_SKU__c);
          if(lineItem.RC_Product_Line_Item__r.RC_Product__r.Dependent_SKUs__c!=null){
            for(String str : lineItem.RC_Product_Line_Item__r.RC_Product__r.Dependent_SKUs__c.split(';')){
              productSKUSet.add(str.trim());
              if(dependentProductMap!=null && dependentProductMap.get(str.trim())!=null){
              List<id> tempProductIdList = dependentProductMap.get(str.trim());
              tempProductIdList.add(lineItem.RC_Product_Line_Item__r.RC_Product__c);
              dependentProductMap.put(str.trim(),tempProductIdList);
            }else{
              dependentProductMap.put(str.trim(),new List<Id>{lineItem.RC_Product_Line_Item__r.RC_Product__c});
            }
            }
          }
        }
        
        setAllMapValues(lineItemList,dependentProductMap);        
        
        if(productSKUSet!=null && productSKUSet.size() > 0){
          List<RC_Product_Line_Item__c> prdLineItemList = new List<RC_Product_Line_Item__c>();
          prdLineItemList = [SELECT id,RC_Product__c,Product_SKU__c,Product_Name__c,Lower_Limit__c,Upper_Limit__c,
                      RC_Currency__c,Max_Discount__c,RC_Product__r.Product_Type__c,RC_Product__r.Category__c,
                      RC_Product__r.Charge_Term__c,RC_Product__r.Dependent_SKUs__c,Price__c,name,RC_Product__r.Excluded_SKUs__c, 
                      RC_Product__r.Excluded_Types__c FROM RC_Product_Line_Item__c WHERE Product_SKU__c IN : productSKUSet
                      AND isActive__c=true AND RC_Currency__c=:currencyCode AND Price__c!=null Order BY Name ASC];          
          createProductMap(prdLineItemList);
        }
      }
      
      if(responseFrom=='product'){
        if(lineItemList!=null && lineItemList.size() > 0){
          //@Log 2 As on 12/20/2014
          //openTab = 'cartTab';
        }
        if(quoteList!=null && quoteList.size() > 0){
          quoteObj = quoteList[0];
        oldSpecialTermValue = (quoteObj.Special_Terms_and_Notes_Picklist__c != null ? quoteObj.Special_Terms_and_Notes_Picklist__c :'');       
          quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == '0' ? NULL : quoteObj.Renewal_Term__c);
          //@Log 2 As on 12/20/2014
          initialTerm = quoteObj.Initial_Term__c;
          renewalTerm  = quoteObj.Renewal_Term__c;
          
          approvalList = [SELECT id,Name,Status__c,RC_Quote_Formula__c,RC_Quote__c,RC_Quote__r.Name,Initial_Total_Discount__c,CreatedDate FROM Approval__c WHERE RC_Quote__c=:quoteObj.Id];
          wasQuotePrimaryBool = (quoteObj.IsPrimary__c==true ? true:false);      
        showQuoteReadOnlyMode=true;
        showQuoteEditMode=false;
        }else{
          wasQuotePrimaryBool = false;
          quoteObj.IsPrimary__c = true;
          quoteObj.Agreement_Status__c = 'Draft'; 
        if(oppObj.Primary_Opportunity_Contact__c != NULL){
          quoteObj.Contact__c = oppObj.Primary_Opportunity_Contact__c;  
        }else{
          quoteObj.Contact__c = (oppContactRoleObj != NULL ? oppContactRoleObj.ContactId : NULL);
        } 
        quoteObj.CurrencyIsoCode = oppObj.CurrencyIsoCode;
        quoteObj.name = 'RC Quote For '+oppObj.name;
        }
        
        }else if(responseFrom=='quote'){          
          openTab = 'quoteTab';
          if(!String.isBlank(strQuoteId)){
            quoteList = [SELECT id,Approved_Status__c,Total_12M_Amount__c, Total_Initial_Amount__c,Name,Contact__c,Valid_Until_Date__c,Start_Date__c,Total_12M_Discount__c,
                Initial_Term__c,Agreement_Status__c,Auto_Renewal__c,End_Date__c,IsPrimary__c,Opportunity__c,Quote_Type__c,Renewal_Term__c,Initial_Total_Discount__c,
                Special_Terms_and_Notes__c,Special_Terms_and_Notes_Picklist__c,Special_Terms_Approval_Level__c,Opportunity_Record_Type__c,(SELECT id FROM Line_Items__r ORDER BY order__c ASC) FROM RC_Quote__c WHERE Opportunity__c=:strOpportunityId and Id=: strQuoteId];
            if(quoteList!=null && quoteList.size() > 0){
              quoteObj = quoteList[0];
              oldSpecialTermValue = (quoteObj.Special_Terms_and_Notes_Picklist__c != null ? quoteObj.Special_Terms_and_Notes_Picklist__c :'');
              approvalList = [SELECT id,Name,Status__c,RC_Quote_Formula__c,RC_Quote__c,RC_Quote__r.Name,Initial_Total_Discount__c,CreatedDate FROM Approval__c WHERE RC_Quote__c=:quoteObj.Id];
            }
        wasQuotePrimaryBool = (quoteObj.IsPrimary__c==true ? true:false);
        quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == '0' ? NULL : quoteObj.Renewal_Term__c);
        //@Log 2 As on 12/20/2014
          initialTerm = quoteObj.Initial_Term__c;
          renewalTerm  = quoteObj.Renewal_Term__c;
                  
        showQuoteReadOnlyMode=true;
        showQuoteEditMode=false;        
          }else{
            wasQuotePrimaryBool = false;
            quoteObj.IsPrimary__c = true;
            quoteObj.Agreement_Status__c = 'Draft';
        if(oppObj.Primary_Opportunity_Contact__c != NULL){
          quoteObj.Contact__c = oppObj.Primary_Opportunity_Contact__c;  
        }else{
          quoteObj.Contact__c = (oppContactRoleObj != NULL ? oppContactRoleObj.ContactId : NULL);
        } 
        quoteObj.CurrencyIsoCode = oppObj.CurrencyIsoCode;
        quoteObj.name = 'RC Quote For '+oppObj.name; 
          }          
        }
    }
    /************************************* Method for displaying the tab- Ends ************************/
    
    
    /************************************* Method for populating "productMap"- Starts *****************
  * @Description - Method to populating "productMap". This method is being used in displaytab() and-*
  *         searchProduct() methods.                               *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/ 
    public void createProductMap(List<RC_Product_Line_Item__c> prdLineItemList){
      for(RC_Product_Line_Item__c prdLineItem : prdLineItemList){
      Integer rangeValue = 0;
      if(prdLineItem.Lower_Limit__c!=null){
        rangeValue = Integer.valueOf(prdLineItem.Lower_Limit__c);
      }
      if(productMap.get(prdLineItem.RC_Product__c)!=null){
        Map<Integer,RC_Product_Line_Item__c> rangeLineItemMap = productMap.get(prdLineItem.RC_Product__c);
        rangeLineItemMap.put(rangeValue,prdLineItem);
        productMap.put(prdLineItem.RC_Product__c,rangeLineItemMap);
      }else{
        productMap.put(prdLineItem.RC_Product__c,new Map<Integer,RC_Product_Line_Item__c>{rangeValue=>prdLineItem});
      }
    }
    }
    /************************************* Method for populating "productMap"- Ends ********************/
    
    
    
    /***************** Method for populating data into all required maps for this class.- Starts ******
    * @Description - Method to populating data into all required maps for this class.            *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public void setAllMapValues(List<Line_Item__c> lineItemList,Map<String,List<Id>> dependentProductMap){
      system.debug('=list Size='+lineItemList.size());
    for(Line_Item__c lineItem: lineItemList){      
      lineItemWrapper liWrapper = new lineItemWrapper(
                                                              lineItem.Id,
                                                              lineItem.Discount__c,
                                                              lineItem.RC_Product_Line_Item__c,
                                                              lineItem.RC_Product_Line_Item__r.RC_Product__c,
                                                              lineItem.RC_Product_Line_Item__r.Product_Name__c,
                                                              lineItem.RC_Product_Line_Item__r.RC_Product__r.Product_Type__c,
                                                              lineItem.RC_Product_Line_Item__r.name,
                                                              lineItem.RC_Product_Line_Item__r.Max_Discount__c,
                                                              Integer.valueOf(lineItem.Quantity__c),
                                                              Integer.valueOf(lineItem.Quantity__c),
                                                              lineItem.Effective_Price__c,
                                                              lineItem.Effective_Discount__c,
                                                              lineItem.Total_Price__c,
                                                              (lineItem.Discount_Type__c == 'Percentage')?'%':currencyCode,
                                                              lineItem.List_Price__c,
                                                              lineItem.Approval_Required__c,
                                                              currencyCode,                                                              
                                                              (dependentProductMap!=null && dependentProductMap.get(lineItem.RC_Product_Line_Item__r.Product_SKU__c)!=null ? true : false),
                                                              lineItem.RC_Product_Line_Item__r.Product_SKU__c,
                                                              lineItem.RC_Product_Line_Item__r.RC_Product__r.Dependent_SKUs__c,
                                                              lineItem.RC_Product_Line_Item__r.RC_Product__r.Excluded_SKUs__c,
                                                              lineItem.RC_Product_Line_Item__r.RC_Product__r.Excluded_Types__c,
                                                              lineItem.RC_Product_Line_Item__r.RC_Product__r.Category__c,
                                                              lineItem.RC_Product_Line_Item__r.RC_Product__r.Charge_Term__c
                                                            );
      
      productDependentSKUMap.put(lineItem.RC_Product_Line_Item__r.RC_Product__c,lineItem.RC_Product_Line_Item__r.RC_Product__r.Dependent_SKUs__c);
        productLineItemSKUMap.put(lineItem.RC_Product_Line_Item__r.Product_SKU__c,liWrapper);        
        
        if(dependentProductMap!=null && dependentProductMap.get(liWrapper.productSKU)!=null){
        List<id> productIdList = dependentProductMap.get(liWrapper.productSKU);
        for(Id productId : productIdList){    
          createWrapperObjMap(productId,liWrapper);  
        }              
      }else{
        createWrapperObjMap(liWrapper.productId,liWrapper);
      }       
                     
    }
    
    calculateCartSize(wrapperObjMap);    
    sortMapList(wrapperObjMap);
    
  }
  /***************** Method for populating data into all required maps for this class.- Ends ********/
  
  /************************ Method for populating data into WrapperObjMap- Starts *******************
    * @Description - Method to populating data into into WrapperObjMap                       *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
  public void createWrapperObjMap(Id productId,lineItemWrapper liWrapper){
    if(wrapperObjMap!=null && wrapperObjMap.get(productId)!=null){              
      List<lineItemWrapper> tempWrapperList = wrapperObjMap.get(productId);
      tempWrapperList.add(liWrapper);
      wrapperObjMap.put(productId,tempWrapperList);
      grandTotal+=(liWrapper.totalPrice).setScale(2);
    }else{      
      grandTotal+=(liWrapper.totalPrice).setScale(2);        
      wrapperObjMap.put(productId,new List<lineItemWrapper>{liWrapper});  
    }
  }
    /************************ Method for populating data into WrapperObjMap- Ends *******************/
    
    
    /************************ Method to fetch picklist value- Starts **********************************
    * @Description - Generic Mehtod to fetch picklist value of any object by passing necessary para-  *
    *         meters.                                                               *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
        List<selectOption> options = new List<selectOption>();
        if (first_val != null) {
            options.add(new selectOption((first_val.equalsIgnoreCase('--none--') ? '' : first_val), first_val));
        }
        Schema.sObjectType sobject_type = object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues();
        //@Log 2 As on 12/20/2014
        // getting excluded cateogry for Partner profiles from Custom Settings.
        String excludedCategory = System.Label.CategoryExcludedForPartners;
        for (Schema.PicklistEntry a : pick_list_values) {
          if(field_name == 'Category__c' && isRCPartnerUser && excludedCategory.contains(a.getLabel())){
          continue;
          }
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }
    /************************ Method to fetch picklist value- Ends ***********************************/
    
    
    /***************** Getter setter for "Discount Type" Option picklist.- Starts *********************
    * @Description - Populating Discount Type drop down with appropriate options                      *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public List<SelectOption> getDiscountTypeOptns() {
        if(discountTypeOptions==NULL){
            discountTypeOptions = new List<SelectOption>();
            String currecyType = this.oppObj.currencyIsoCode;
            discountTypeOptions.add(new SelectOption(currecyType,currecyType));
            discountTypeOptions.add(new SelectOption('%','%'));            
        }
        return discountTypeOptions;
    }
    /***************** Getter setter for "Discount Type" Option picklist.- Ends *********************/
    
    
    /*********************** Method to Search Products - Starts ***************************************
    * @Description - Method to Search Products. Called when user hits "Search" button FROM Product tab*
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public void searchProduct(){       
        try{
          String queryStr = 'SELECT id,RC_Product__c,Product_SKU__c,Product_Name__c,Lower_Limit__c,Upper_Limit__c,RC_Currency__c,Max_Discount__c,'+
                      'RC_Product__r.Product_Type__c,RC_Product__r.Category__c, RC_Product__r.Charge_Term__c,RC_Product__r.Dependent_SKUs__c, '+
                      'Price__c,name '+
                      'FROM RC_Product_Line_Item__c WHERE isActive__c=true AND ' +
                      ' ' +(!String.isBlank(strProductFamily) && !strProductFamily.equalsIgnoreCase('--none--') ? ' RC_Product__r.Category__c =:strProductFamily AND ' : '')+ 
                      ' ' +(!String.isBlank(strChargeTerm) && !strChargeTerm.equalsIgnoreCase('--none--') ? ' RC_Product__r.Charge_Term__c =:strChargeTerm AND ' : '')+ 
                      ' ' +(!String.isBlank(strServiceType) && !strServiceType.equalsIgnoreCase('--none--') ? ' RC_Product__r.Service_Type__c =:strServiceType AND ' : '')+ 
                      ' ' +(!String.isBlank(strProductName) && !strProductName.equalsIgnoreCase('--none--') ? ' Product_Name__c LIKE \'%'+ strProductName.trim()+ '%\' AND ' : '')+
                      ' ' + ' Allowed_Record_Type__c INCLUDES (\'' + oppObj.RecordType.Name + '\') AND '+
                      ' ' + 'RC_Currency__c=:currencyCode AND Price__c!=null Order by Name ASC';
      
      productLineItemList = new List<RC_Product_Line_Item__c>();                
            productLineItemList = Database.query(queryStr);
            
            productWrapperLst = new List<productWrapper>();
            Map<id,Boolean> uniqueProductIdMap = new Map<id,Boolean>();
            Set<String> skuSet = new Set<String>(); 
            
            for(RC_Product_Line_Item__c prdLineItem : productLineItemList){
            skuSet.add(prdLineItem.Product_SKU__c.trim());
              if(prdLineItem.RC_Product__r.Dependent_SKUs__c!=null){
            for(String str : prdLineItem.RC_Product__r.Dependent_SKUs__c.split(';')){
              skuSet.add(str.trim());
            }
          }
          //For unique product list and filter DL-Fee Products.
          if(uniqueProductIdMap!=null && uniqueProductIdMap.get(prdLineItem.RC_Product__c)!=null){
            //Do Nothing....
          }else{
            uniqueProductIdMap.put(prdLineItem.RC_Product__c,false);
            if(prdLineItem.RC_Product__r.Product_Type__c!='DL-Fee'){
                  productWrapperLst.add(new productWrapper(prdLineItem.RC_Product__c,prdLineItem.Product_Name__c,prdLineItem.RC_Product__r.Category__c,prdLineItem.RC_Product__r.Charge_Term__c,prdLineItem.Product_SKU__c,prdLineItem.RC_Product__r.Dependent_SKUs__c));
              }
          }
            }
                        
      String newQueryStr = 'SELECT id,RC_Product__c,Product_SKU__c,Product_Name__c,Lower_Limit__c,Upper_Limit__c,RC_Currency__c,Max_Discount__c,'+
                      'RC_Product__r.Product_Type__c,RC_Product__r.Category__c, RC_Product__r.Charge_Term__c,RC_Product__r.Dependent_SKUs__c, '+
                      'RC_Product__r.Excluded_SKUs__c,RC_Product__r.Excluded_Types__c,Price__c,name FROM RC_Product_Line_Item__c WHERE isActive__c=true AND Price__c!=null AND RC_Currency__c=:currencyCode '+
                      'AND Product_SKU__c in : skuSet AND Allowed_Record_Type__c INCLUDES (\'' + oppObj.RecordType.Name + '\') Order by Name ASC';
      
      List<RC_Product_Line_Item__c> productLineItmList = Database.query(newQueryStr);
      
      createProductMap(productLineItmList);
      
      if(productWrapperLst.size() > 0){
              showProductBlock=true;
            }          
        }catch(exception e){            
             addMessage(e.getMessage()+e.getLineNumber());  
        }
    }
    /*********************** Method to Search Products - Ends ***************************************/
    
   
    /*********************** Method to display Products on Cart Tab - Starts **************************
    * @Description - Method to display selected products on Cart tab. Called when user hits -         *
    *         "Add To Cart" button on wizard page.                        *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public pageReference addToCart(){
      try{
        //Create a set of all depenedent SKUs.
        if(quoteObj.Approved_Status__c == 'Submitted'){
          Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,'Cannot do this operation as this quote is pending for approval.') );
            return NULL;
        }
        
        Set<String> skuSet = new Set<String>(); 
        Map<String,List<Id>> dependentProductMap = new Map<String,List<Id>>();
        
        if(productWrapperLst!=null && productWrapperLst.size() > 0){      
          for(productWrapper pw : productWrapperLst){
            if(pw.bolSelectedProduct){
              if(selectedProductMap==null || selectedProductMap.get(pw.productId)==null){
                skuSet.add(pw.productSKU);
                if(pw.dependentSKU!=null){
                  for(String str : pw.dependentSKU.split(';')){
                    skuSet.add(str.trim());
                    if(dependentProductMap!=null && dependentProductMap.get(str.trim())!=null){
                      List<id> tempProductIdList = dependentProductMap.get(str.trim());
                      tempProductIdList.add(pw.productId);
                      dependentProductMap.put(str.trim(),tempProductIdList);
                    }else{
                      dependentProductMap.put(str.trim(),new List<Id>{pw.productId});
                    }
                  }
                }
              }
            }
          }
          
          //Create a lineItemWrapper to display on Cart tab.
          if(skuSet!=null && skuSet.size() > 0){
            for(RC_Product__c rcProduct : [SELECT id,Dependent_SKUs__c,Excluded_SKUs__c,Excluded_Types__c FROM RC_Product__c WHERE SKU__c in : skuSet]){              
              if(productMap!=null && productMap.get(rcProduct.id)!=null){            
                productDependentSKUMap.put(rcProduct.id,rcProduct.Dependent_SKUs__c);
              List<Integer> lstIntLowerValueOfValidRange = new List<Integer>(productMap.get(rcProduct.Id).keySet());
              lstIntLowerValueOfValidRange.sort();              
              if(lstIntLowerValueOfValidRange!=null && lstIntLowerValueOfValidRange.size() > 0){          
                RC_Product_Line_Item__c prodLineItem = productMap.get(rcProduct.Id).get(lstIntLowerValueOfValidRange[0]);                
                if(selectedProductMap.get(prodLineItem.RC_Product__c)==null){
                  lineItemWrapper wraperObj = new lineItemWrapper(
                                          prodLineItem.id,
                                          prodLineItem.Product_Name__c,
                                          prodLineItem.RC_Product__r.Product_Type__c,
                                          prodLineItem.RC_Product__c,
                                          prodLineItem.Max_Discount__c,
                                          strOpportunityId,
                                          (prodLineItem.Price__c!=null ? prodLineItem.Price__c : 0),
                                          prodLineItem.name,
                                          currencyCode,                                          
                                          (dependentProductMap!=null && dependentProductMap.get(prodLineItem.Product_SKU__c)!=null ? true : false),
                                          1,
                                          1,
                                          0,
                                          false,
                                          prodLineItem.Product_SKU__c,
                                          prodLineItem.RC_Product__r.Dependent_SKUs__c,
                                          prodLineItem.RC_Product__r.Excluded_SKUs__c,
                                          prodLineItem.RC_Product__r.Excluded_Types__c,
                                          prodLineItem.RC_Product__r.Category__c,
                                          prodLineItem.RC_Product__r.Charge_Term__c
                                          );
                  
                  productLineItemSKUMap.put(prodLineItem.Product_SKU__c,wraperObj);
                  selectedProductMap.put(rcProduct.id,true);
                  
                  if(dependentProductMap!=null && dependentProductMap.get(wraperObj.productSKU)!=null){
                      List<id> productIdList = dependentProductMap.get(wraperObj.productSKU);
                      for(Id productId : productIdList){                                          
                        createWrapperObjMap(productId,wraperObj);  
                      }              
                    }else{
                      createWrapperObjMap(wraperObj.productId,wraperObj);
                    } 
                }
              }
              }
            }
            
            calculateCartSize(wrapperObjMap);
            sortMapList(wrapperObjMap);
          }
        }
        return NULL;
      }catch(exception e){               
             addMessage(e.getMessage()+e.getLineNumber()); 
             return NULL;
        }
    }
    /*********************** Method to display Products on Cart Tab - Ends **************************/
    
    /*********************** Method to Calculate No. of Products in Cart - Starts *********************
    * @Description - Method to Calculate No. of Products in Cart                         *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public void calculateCartSize(Map<Id,List<lineItemWrapper>> wrapperObjMap){      
      cartSize = 0;
      grandTotal = 0;
      if(wrapperObjMap!=null && wrapperObjMap.size() > 0){
        for(Id idValue : wrapperObjMap.keySet()){          
          cartSize+= wrapperObjMap.get(idValue).size();
          for(lineItemWrapper wrpObj : wrapperObjMap.get(idValue)){
            grandTotal+=(wrpObj.totalPrice).setScale(2);
          } 
        }
      }
    }    
    /*********************** Method to Calculate No. of Products in Cart - Ends ***********************/
    
    /*********************** Method to Sort Product list on Cart Tab - Starts *************************
    * @Description - Method to Sort Product list in an order which it displays on Cart Tab           *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public void sortMapList(Map<Id,List<lineItemWrapper>> wrapperObjMap){
    for(Id productId : wrapperObjMap.keySet()){
      List<lineItemWrapper> mainProductList = new List<lineItemWrapper>();
      List<lineItemWrapper> childProductList = new List<lineItemWrapper>();
          for(lineItemWrapper limwObj : wrapperObjMap.get(productId)){            
            if(limwObj.productId == productId){                           
              mainProductList.add(limwObj);              
            }else{              
              childProductList.add(limwObj);
            }
        }        
        List<lineItemWrapper> tempList = new List<lineItemWrapper>();
        tempList.add(mainProductList[0]);
        tempList.addAll(childProductList);
        wrapperObjMap.put(productId,tempList);
    }
  }
    /*********************** Method to Sort Product list on Cart Tab - Ends *************************/
    
    /*********************** Method to recalculate Total Price on change - Starts *********************
    * @Description - Method called everytime user changes selected products fields like Quantity, -   *
    *                Discount,Discount Type on Cart tab                                           *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public Pagereference onChageQuantity(){           
        if(!wrapperObjMap.isEmpty()){            
            lineItemWrapper limwObj;
            if(wrapperObjMap!=null && wrapperObjMap.get(parentProductId)!=null){
        for(lineItemWrapper obj : wrapperObjMap.get(parentProductId)){
          if(childProductId == obj.productId){
            limwObj = obj;
          }
        }
      }            
            
            Line_Item__c lineItemObj = new Line_Item__c();
            
            // if already has line items records           
            if(lineItemsMap!= NULL && limwObj.lineItemId!=null && lineItemsMap.get(limwObj.lineItemId)!=NULL){
                lineItemObj =  lineItemsMap.get(limwObj.lineItemId);   
            }
           
            Boolean isError = false;
            isError = calculatePrice(limwObj,lineItemObj);           
            
            //Update dependent PLI on the basis of Dependent SKUs            
            if(!isError && productDependentSKUMap!=null && productDependentSKUMap.get(limwObj.productId)!=null){              
        for(String str : productDependentSKUMap.get(limwObj.productId).split(';')){
          if(productLineItemSKUMap!=null && productLineItemSKUMap.get(str.trim())!=null){
            lineItemWrapper limwObjChild = productLineItemSKUMap.get(str.trim());
            Line_Item__c lineItemObjChild = new Line_Item__c();
            if(lineItemsMap!= NULL && limwObjChild.lineItemId!=null && lineItemsMap.get(limwObjChild.lineItemId)!=NULL){
                            lineItemObjChild =  lineItemsMap.get(limwObjChild.lineItemId);    
                        }                
                        limwObjChild.quantity = limwObj.quantity;
            lineItemObjChild.Quantity__c = limwObjChild.Quantity;               
            
            calculatePrice(limwObjChild,lineItemObjChild); 
                        
          }
        }       
            }
            calculateCartSize(wrapperObjMap);
        }
        return NULL;    
    } 
    /*********************** Method to recalculate Total Price on change - Ends *********************/
    

    /*********************** Method to calculate Product price values - Starts ************************
    * @Description - Method to calculate Product price values. Called FROM "onChageQuantity()" -      *
    *                method.                                                                       *
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public Boolean calculatePrice(lineItemWrapper limwObj,Line_Item__c lineItemObj){ 
        if(productMap!=null && productMap.get(limwObj.productId)!=null){ 
          
      List<Integer> lstIntLowerValueOfValidRange = new List<Integer>(productMap.get(limwObj.productId).keySet());
      lstIntLowerValueOfValidRange.sort();
      Boolean prodLineItemFound = false;
      RC_Product_Line_Item__c prodLineItem;
      
      //Assign PLI on the basis of entered quantity value.      
      for(Integer intLowerRange : lstIntLowerValueOfValidRange){
        if(intLowerRange <= limwObj.Quantity){
          prodLineItem = productMap.get(limwObj.productId).get(intLowerRange);
          Integer lowerRange = (prodLineItem.Lower_Limit__c!=null ? Integer.valueOf(prodLineItem.Lower_Limit__c) : 0);
          Integer upperRange = (prodLineItem.Upper_Limit__c!=null ? Integer.valueOf(prodLineItem.Upper_Limit__c) : 0);
          if((limwObj.Quantity > = lowerRange && limwObj.Quantity < = upperRange) || (limwObj.Quantity > = lowerRange && upperRange==0)){
            prodLineItemFound = true;            
            break;            
          }
        } else {  
          break;
        }
      }
      
      //Update PLI details in "lineItemWrapper" object
      if(prodLineItemFound){        
        limwObj.productLineItemId = prodLineItem.id;
        limwObj.productName = prodLineItem.Product_Name__c;
        limwObj.productId = prodLineItem.RC_Product__c;
        limwObj.maxDiscount = prodLineItem.Max_Discount__c;        
        limwObj.listPrice = prodLineItem.Price__c;
        limwObj.productLineItemName = prodLineItem.name;
        limwObj.currencyCode = currencyCode;        
        limwObj.discount = Double.valueOf(limwObj.Discount);
        limwObj.oldQuantity = limwObj.Quantity;
        
        if(limwObj.selectedDiscountType !=NULL && limwObj.Discount !=NULL){
              if(limwObj.selectedDiscountType =='%' && limwObj.listPrice != NULL){
                limwObj.effectiveDiscount =  (limwObj.listPrice*(limwObj.discount)/100).setScale(2);
              }else if(limwObj.selectedDiscountType != '%' && limwObj.listPrice != NULL){
                limwObj.effectiveDiscount=(limwObj.discount).setScale(2); 
              }             
            }
            
            if(limwObj.effectiveDiscount > limwObj.maxDiscount){          
              limwObj.approvalRequired = true;  
            }else{          
              limwObj.approvalRequired = false;
            }
            
            limwObj.effectivePrice = (limwObj.listPrice - limwObj.effectiveDiscount).setScale(2);
            
            if(limwObj.effectivePrice != NULL && limwObj.quantity != NULL){
                limwObj.totalPrice = ((limwObj.effectivePrice)*(limwObj.quantity)).setScale(2);   
            }   
            lineItemObj.Effective_Discount__c = (limwObj.effectiveDiscount != NULL?limwObj.effectiveDiscount:0.0);            
            return false;  
          }else{
            limwObj.Quantity = limwObj.oldQuantity;
            addMessage('Pricing is not available for '+limwObj.productName+' Product in this quantity.');             
            return true;
          }
      }
      return true;
    }
    /*********************** Method to calculate Product price values - Ends ************************/   
    
    
    /*********************** Method to remove selected Product on Cart Tab - Starts *******************
    * @Description - Method to remove product FROM List on Cart tab. Called when user clicks on [X] - *
    *                button adjacent to all products on Cart Tab.
  * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public PageReference removeProduct(){      
    if(wrapperObjMap!=null && wrapperObjMap.get(parentProductId)!=null){      
      for(lineItemWrapper lineItemWrapper : wrapperObjMap.get(parentProductId)){              
        productMap.remove(lineItemWrapper.productId);
        selectedProductMap.remove(lineItemWrapper.productId);
        if(lineItemsMap!=NULL && lineItemsMap.containsKey(lineItemWrapper.lineItemId) && lineItemsMap.get(lineItemWrapper.lineItemId)!= NULL){
          //Delete FROM Database only when Product Quote is same as what we see in Quote Tab or if No Quote Available.
          if(quoteObj.Id!=null || lineItemsMap.get(lineItemWrapper.lineItemId).RC_Quote__c==null){
            lineItemDeleteList.add(lineItemsMap.get(lineItemWrapper.lineItemId));
          }
        }        
      }  
      wrapperObjMap.remove(parentProductId);
      calculateCartSize(wrapperObjMap);      
    }    
    return NULL;
    }
    /*********************** Method to remove selected Product on Cart Tab - Ends *******************/
    
    /*********************** Method to save/update Line Items to DB - Starts **************************
    * @Description - Method to save/Update "Line Item" to DB when user hits "Update" button FROM Cart-*
    *         tab.                                                                             *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public Pagereference saveUpdateLineItems(){
      try{
        if(quoteObj.Id != NULL && quoteObj.Approved_Status__c == 'Not Submitted'){
          addMessage('An Approval has been created, but not Submitted. Please Return/Cancel that Approval in order to make this change.');
        return NULL;
        }
        if(lineItemDeleteList!=null && lineItemDeleteList.size() > 0){ 
          delete lineItemDeleteList;
          lineItemDeleteList = new List<Line_Item__c>();
        }
        if(!wrapperObjMap.isEmpty()){          
          Map<String,Integer> excludedSKUsMap = new Map<String,Integer>();
          Map<String,Integer> excludedTypesMap = new Map<String,Integer>();
          Map<Id,lineItemWrapper> parentProductWrapperMap = new Map<Id,lineItemWrapper>();
          for(Id productId : wrapperObjMap.keySet()){
              for(lineItemWrapper limwObj : wrapperObjMap.get(productId)){
                //Create Separate Maps for Excluded SKUs and Product Type
                if(limwObj.productId == productId){
                  parentProductWrapperMap.put(productId,limwObj);
                  if(limwObj.productExcludedSKUs!=null){
                    for(String str : limwObj.productExcludedSKUs.split(';')){
                      excludedSKUsMap.put(str.trim(),0);
                    }
                  }
                  if(limwObj.productExcludedTypes!=null){
                    for(String str : limwObj.productExcludedTypes.split(';')){
                      excludedTypesMap.put(str.trim(),0);
                    }
                  }
                }
                //Check if Product Quantity available or not
                if(productMap!=null && productMap.get(limwObj.productId)!=null){          
              List<Integer> lstIntLowerValueOfValidRange = new List<Integer>(productMap.get(limwObj.productId).keySet());
              lstIntLowerValueOfValidRange.sort();
              Boolean prodLineItemFound = false;
              RC_Product_Line_Item__c prodLineItem;
              
              //Assign PLI on the basis of entered quantity value.      
              for(Integer intLowerRange : lstIntLowerValueOfValidRange){
                if(intLowerRange <= limwObj.Quantity){
                  prodLineItem = productMap.get(limwObj.productId).get(intLowerRange);
                  Integer lowerRange = (prodLineItem.Lower_Limit__c!=null ? Integer.valueOf(prodLineItem.Lower_Limit__c) : 0);
                  Integer upperRange = (prodLineItem.Upper_Limit__c!=null ? Integer.valueOf(prodLineItem.Upper_Limit__c) : 0);
                  if((limwObj.Quantity > = lowerRange && limwObj.Quantity < = upperRange) || (limwObj.Quantity > = lowerRange && upperRange==0)){
                    prodLineItemFound = true;            
                    break;            
                  }
                } else {  
                  break;
                }
              }
              if(prodLineItemFound==false){
                addMessage('Pricing is not available for '+limwObj.productName+' Product in this quantity.');
                return null;
              }  
            }                              
              }
            }
            
            List<Line_Item__c> lineItemList = new List<Line_Item__c>();
            lineItemGlobalList = new List<Line_Item__c>();
            Boolean approvalRequiredVar = false;
            String errMsg = '';
            String imcompatibleParentProduct = '';
            
            for(Id productId : wrapperObjMap.keySet()){
              //Conditions to Check if Products are Incompatible with each other on basis on above crated Excluded SKUs and Product Type Maps
              if(
                (
                  (excludedSKUsMap==null || excludedSKUsMap.get(parentProductWrapperMap.get(productId).productSKU)==null) || 
                  (excludedSKUsMap!=null && excludedSKUsMap.get(parentProductWrapperMap.get(productId).productSKU)!=null && 
                    excludedSKUsMap.get(parentProductWrapperMap.get(productId).productSKU)==0)
                )
                && 
                (
                  (excludedTypesMap==null || excludedTypesMap.get(parentProductWrapperMap.get(productId).productCategory)==null) || 
                  (excludedTypesMap!=null && excludedTypesMap.get(parentProductWrapperMap.get(productId).productCategory)!=null && 
                    excludedTypesMap.get(parentProductWrapperMap.get(productId).productCategory)==0)
              )
          ){  
            if(excludedSKUsMap!=null && excludedSKUsMap.get(parentProductWrapperMap.get(productId).productSKU)!=null && excludedSKUsMap.get(parentProductWrapperMap.get(productId).productSKU)==0){
                    excludedSKUsMap.put(parentProductWrapperMap.get(productId).productSKU,1);
                    imcompatibleParentProduct+=parentProductWrapperMap.get(productId).productName+'<br/>';
                  }
                  
                  if(excludedTypesMap!=null && excludedTypesMap.get(parentProductWrapperMap.get(productId).productCategory)!=null && excludedTypesMap.get(parentProductWrapperMap.get(productId).productCategory)==0){
                    excludedTypesMap.put(parentProductWrapperMap.get(productId).productCategory,1);
                    imcompatibleParentProduct+=parentProductWrapperMap.get(productId).productName+'<br/>';
                  } 
                                                
                for(lineItemWrapper limwObj : wrapperObjMap.get(productId)){
                  
                  Line_Item__c lineItemObj = new Line_Item__c();
                        //If already has line items records
                        if(lineItemsMap!= NULL && lineItemsMap.containsKey(limwObj.lineItemId) && lineItemsMap.get(limwObj.lineItemId)!=NULL){
                            lineItemObj =  lineItemsMap.get(limwObj.lineItemId);
                            //Clone Line Item only if it is being copied FROM Other Quote
                            if(quoteObj.id==null && lineItemsMap.get(limwObj.lineItemId).RC_Quote__c!=null){                              
                              lineItemObj.id = null;
                              lineItemObj.RC_Quote__c = null;
                            }          
                        }               
                        
                    if(limwObj.selectedDiscountType !=NULL && limwObj.Discount !=NULL){
                      if(limwObj.selectedDiscountType =='%' && limwObj.listPrice != NULL){
                        limwObj.effectiveDiscount =  (limwObj.listPrice*(limwObj.discount)/100).setScale(2);
                      }else if(limwObj.selectedDiscountType != '%' && limwObj.listPrice != NULL){
                        limwObj.effectiveDiscount=(limwObj.discount).setScale(2); 
                      }                      
                    }                
                    
                    limwObj.effectivePrice = (limwObj.listPrice - limwObj.effectiveDiscount).setScale(2);
                    if(limwObj.effectivePrice != NULL && limwObj.quantity != NULL){
                      limwObj.totalPrice = ((limwObj.effectivePrice)*(limwObj.quantity)).setScale(2);
                    }     
                    
                    lineItemObj.Effective_Discount__c = limwObj.effectiveDiscount;
                    lineItemObj.Quantity__c = limwObj.quantity;
                    lineItemObj.Discount__c = limwObj.discount;
                    lineItemObj.Total_Price__c = limwObj.totalPrice;
                    lineItemObj.Opportunity__c=strOpportunityId;
                        lineItemObj.RC_Product_Line_Item__c=limwObj.productLineItemId;
                    lineItemObj.Discount_Type__c = (limwObj.selectedDiscountType == '%')?'Percentage':'Currency';
                    lineItemObj.currencyIsoCode = currencyCode;
                    lineItemObj.Order__c = lineItemList.size();
                    
                    
                    if(limwObj.effectiveDiscount > limwObj.maxDiscount){
                      lineItemObj.Approval_Required__c = true;
                      approvalRequiredVar = true;  
                    }else{
                      lineItemObj.Approval_Required__c = false;
                    }
                    
                    if(quoteObj.id!=null){
                      lineItemObj.RC_Quote__c = quoteObj.id;
                    }
                    
                    lineItemList.add(lineItemObj);  
                    lineItemGlobalList.add(lineItemObj);
                }
                    
              }else{                
                errMsg+=parentProductWrapperMap.get(productId).productName+'<br/>';                
              }
              
            }//End of For
            if(String.isBlank(errMsg)){
              if(lineItemList!=null && lineItemList.size() > 0){                
                //upsert lineItemList;
                List<Line_Item__c> updateLIList = new List<Line_Item__c>();
                List<Line_Item__c> insertLIList = new List<Line_Item__c>();
                Set<id> productLISet = new Set<id>(); 
                for(Line_Item__c lineItemObj : lineItemList){
              if(lineItemObj.id!=null){
                updateLIList.add(lineItemObj);
              }else{
                insertLIList.add(lineItemObj);
                productLISet.add(lineItemObj.RC_Product_Line_Item__c);
              }
            }
            
            //Clear Both LineItem List
            lineItemList.clear();
            lineItemGlobalList.clear();
            
            //Update Line Items
            if(updateLIList!=null && updateLIList.size() > 0){
              update updateLIList;
              lineItemList.addAll(updateLIList);
              lineItemGlobalList.addAll(updateLIList);
            }
            
            //To Check Clone(Orfins) and then update/insert
            if(insertLIList!=null && insertLIList.size() > 0){
            
              Map<String,Id> foreignKeyMap = new Map<String,Id>();
              
              List<Line_Item__c> orfinLIList = new List<Line_Item__c>();
              orfinLIList  = [ SELECT id,RC_Product_Line_Item__c,Opportunity__c FROM Line_Item__c WHERE RC_Quote__c=null and
                                 Opportunity__c =: oppObj.id and RC_Product_Line_Item__c in : productLISet];
              for(Line_Item__c liObj : orfinLIList){
                foreignKeyMap.put(liObj.RC_Product_Line_Item__c+'-'+liObj.Opportunity__c,liObj.id);
              }
              for(Line_Item__c lineItemObj : insertLIList){
                if(foreignKeyMap!=null && foreignKeyMap.get(lineItemObj.RC_Product_Line_Item__c+'-'+lineItemObj.Opportunity__c)!=null){
                  lineItemObj.id = foreignKeyMap.get(lineItemObj.RC_Product_Line_Item__c+'-'+lineItemObj.Opportunity__c);
                }
              }
              upsert insertLIList;
              lineItemList.addAll(insertLIList);
              lineItemGlobalList.addAll(insertLIList);
            }              
              }
            }else{
              addMessage('Following products are incompatible:<br/>'+errMsg+imcompatibleParentProduct);
              return null;
            }
            
            //For updating Line Item ID in Wrapper Object and Inserting New LIne Item value into lineItemsMap.
            /*Map<id,id> temporaryMap = new Map<id,id>();
            for(Line_Item__c lineItmObj : lineItemList){
              lineItemsMap.put(lineItmObj.id,lineItmObj);
              temporaryMap.put(lineItmObj.RC_Product_Line_Item__c,lineItmObj.Id);
            }
            for(Id productId : wrapperObjMap.keySet()){
              for(lineItemWrapper limwObj : wrapperObjMap.get(productId)){
                if(temporaryMap!=null && temporaryMap.get(limwObj.productLineItemId)!=null){
                  limwObj.lineItemId = temporaryMap.get(limwObj.productLineItemId);
                }
              }
            }*/
            
            updatewrapperObjMap(lineItemList);            
            
          }//End of IF
          if(quoteObj.Id != NULL){
          List<RC_Quote__c> quoteList = new List<RC_Quote__c>();
          quoteList = [SELECT id,Approved_Status__c,Total_12M_Amount__c, Total_Initial_Amount__c,Name,Contact__c,
                          Valid_Until_Date__c,Start_Date__c,CurrencyIsoCode,Initial_Term__c,Agreement_Status__c,
                          Auto_Renewal__c,End_Date__c,IsPrimary__c,Opportunity__c,Quote_Type__c,Renewal_Term__c,
                          Special_Terms_and_Notes__c,Special_Terms_and_Notes_Picklist__c,Special_Terms_Approval_Level__c,Total_12M_Discount__c,Initial_Total_Discount__c,Opportunity_Record_Type__c
                          FROM RC_Quote__c WHERE Id=:quoteObj.Id LIMIT 1];
        if(quoteList!=null && quoteList.size() > 0){
          quoteObj = quoteList[0];  
          oldSpecialTermValue = (quoteObj.Special_Terms_and_Notes_Picklist__c != null ? quoteObj.Special_Terms_and_Notes_Picklist__c :'');
          quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == '0' ? NULL : quoteObj.Renewal_Term__c);// to not display 0 in renewal dropdown.  
          //@Log 2 As on 12/20/2014
            initialTerm = quoteObj.Initial_Term__c;
            renewalTerm  = quoteObj.Renewal_Term__c;      
              
          quoteList.clear();
        }
        }
          return NULL;             
      }catch(System.DmlException e){        
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,e.getDmlMessage(0)) ); 
            return null;
      }catch(exception e){
        addMessage(e.getMessage()+e.getLineNumber()); 
            return NULL;
        } 
    }
    /*********************** Method to save/update Line Items to DB - Ends *********************************/
    
    
    /*********************** Method to update updatewrapperObjMap - Starts ****************************
    * @Description - For updating Line Item ID in Wrapper Object and Inserting New Line Item value -  *
    *                into lineItemsMap.                                                               *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public void updatewrapperObjMap(List<Line_Item__c> lineItemList){
      Map<id,id> temporaryMap = new Map<id,id>();
    for(Line_Item__c lineItmObj : lineItemList){
      lineItemsMap.put(lineItmObj.id,lineItmObj);
      temporaryMap.put(lineItmObj.RC_Product_Line_Item__c,lineItmObj.Id);
    }
    for(Id productId : wrapperObjMap.keySet()){
          for(lineItemWrapper limwObj : wrapperObjMap.get(productId)){
          if(temporaryMap!=null && temporaryMap.get(limwObj.productLineItemId)!=null){
            limwObj.lineItemId = temporaryMap.get(limwObj.productLineItemId);
          }
          }
    }
    }
     /*********************** Method to update updatewrapperObjMap - Ends ****************************/
     
    
    /*********************** Method to show Justification Pop up - Starts *****************************
    * @Description - Request to show Justification Pop up.                                            *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public pageReference justificationCheckBeforeApproval(){
      showJustificationBool = true;
      return NULL;
    }
    /*********************** Method to show Justification Pop up - Ends *****************************/
    
    
    /*********************** Method to Create Approval - Starts ***************************************
    * @Description - Create Approval record on hit of "Create Approver" Button on Quote Tab           *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public pageReference createApproval(){
      try{
          Double highestApprovalAmnt = 0.0; // variable to hold highest approval amount from estimated discount from line items
      if(quoteObj.id == NULL){
        addMessage('Please save the Quote first.');
        return NULL;
        }
        Approval__c approvalObj = new Approval__c();
        Boolean approvalNeeded = false;
        showQuoteReadOnlyMode=true;
        showQuoteEditMode=false;
        showJustificationBool = false;  
        
        approvalObj.Special_Terms_and_Notes__c = quoteObj.Special_Terms_and_Notes__c;      
        approvalObj.Special_Terms_Approval_Level__c = quoteObj.Special_Terms_Approval_Level__c;
        
        if(quoteObj.Approved_Status__c == 'Required' || quoteObj.Approved_Status__c == 'Rejected'){
          approvalNeeded=true;
        }
        if(approvalNeeded){
          if(JustificationandDescription == NULL || JustificationandDescription == ''){
            showJustificationBool = true;
            return NULL;
          }
          String middleHTML = '';
          if(quoteObj.id != NULL){
            List<Line_Item__c> lineItemsTempList = [SELECT id,Discount__c,RC_Quote__c,Discount_Type__c,Effective_Discount__c,Effective_Price__c,List_Price__c,Approval_Required__c,RC_Product_Line_Item__r.RC_Product__r.Excluded_SKUs__c,
                            Opportunity__c,Quantity__c,RC_Product_Line_Item__c,Total_Price__c,RC_Product_Line_Item__r.RC_Product__c,RC_Product_Line_Item__r.RC_Product__r.Excluded_Types__c,
                            RC_Product_Line_Item__r.Product_Name__c,RC_Product_Line_Item__r.Name,RC_Product_Line_Item__r.RC_Product__r.Dependent_SKUs__c,
                            RC_Product_Line_Item__r.Max_Discount__c,RC_Product_Line_Item__r.Product_SKU__c,RC_Product_Line_Item__r.RC_Product__r.Service_Type__c,
                            RC_Product_Line_Item__r.price__c,RC_Product_Line_Item__r.RC_Product__r.Product_Type__c,RC_Product_Line_Item__r.RC_Product__r.Category__c FROM Line_Item__c
                            WHERE RC_Quote__c=:quoteObj.Id ORDER BY order__c ASC]; 
            
            for(Line_Item__c item : lineItemsTempList){
              if(item.RC_Product_Line_Item__r.RC_Product__r.Product_Type__c == 'DL'){
                approvalObj.Discounted_Price__c = item.Effective_Discount__c;
                approvalObj.List_Price__c = item.List_Price__c;
                approvalObj.Quantity__c = item.Quantity__c;
                approvalObj.Service_Name__c = item.RC_Product_Line_Item__r.RC_Product__r.Service_Type__c;
                approvalObj.Standard_Discount__c = item.RC_Product_Line_Item__r.Max_Discount__c;
              }
              //below HTML is for Line_item_c Field on Approval Object
              String productname = '<td>'+item.RC_Product_Line_Item__r.Product_Name__c+'</td>';  
              String quantity = '<td>'+item.Quantity__c+'</td>';
              String listPrice = '<td>'+item.List_Price__c+'</td>';
              String effectivePrice = '<td>'+item.Effective_Price__c+'</td>';
              middleHTML = middleHTML + '<tr>'+productname+quantity+listPrice+effectivePrice+'</tr>';
              // populating highest Discount Amount for which we are creating this approval record.
              highestApprovalAmnt = item.Effective_Discount__c > highestApprovalAmnt?item.Effective_Discount__c:highestApprovalAmnt;
            }
          }
          approvalObj.RC_Quote__c=quoteObj.Id;
          approvalObj.Account__c = oppObj.AccountId;
          if(oppObj.Primary_Opportunity_Contact__c != NULL){
          approvalObj.Contact__c = oppObj.Primary_Opportunity_Contact__c;  
        }else{
          approvalObj.Contact__c = (oppContactRoleObj != NULL ? oppContactRoleObj.ContactId : NULL);
        } 
          approvalObj.Quote_Approval_Required__c = true;
          approvalObj.CurrencyIsoCode=quoteObj.CurrencyIsoCode;
          String initialHTML = '<HTML><table border="1"><tr style="backgrouund:lightgray;"><th>Product</th><th>Quantity</th><th>List Price</th><th>Effective Price</th></tr>';
          String endHTML = '</table></HTML>';
          String finalHTML = initialHTML+middleHTML+endHTML;
          approvalObj.Line_Items__c = finalHTML;
          approvalObj.Initial_Total_Amount__c = quoteObj.Total_Initial_Amount__c;
          approvalObj.Initial_Total_Discount__c = quoteObj.Initial_Total_Discount__c;
          approvalObj.Total_12M_Amount__c = quoteObj.Total_12M_Amount__c ;
          approvalObj.Total_12M_Discount__c = quoteObj.Total_12M_Discount__c;
          //--------------------------As/5/23/2014 start-----------------------------------
          approvalObj.Start_Date__c = quoteObj.Start_Date__c;
          approvalObj.Initial_Term__c = quoteObj.Initial_Term__c;
          approvalObj.Renewal_Term__c = quoteObj.Renewal_Term__c;
          approvalObj.Highest_Approval_Amount__c = highestApprovalAmnt;
                //--------------------------As/5/23/2014 End-----------------------------------
          approvalObj.JustificationandDescription__c = JustificationandDescription;
          if(appRecordtypeMap!= NULL && appRecordtypeMap.get('QuoteApprovalProcess')!= NULL){
            approvalObj.RecordTypeId = appRecordtypeMap.get('QuoteApprovalProcess');//'012S00000004g0K';  
          }
          approvalObj.Possible_Approval_From__c ='Owner';
          quoteObj.Approved_Status__c = 'Not Submitted';
          
          // Check before inserting approval record that its JustificationandDescription field is not empty otherwise show popup
          TriggerHandler.BY_PASS_RCQUOTE_ON_UPDATE();
          //@Log 2 As on 12/20/2014
          quoteObj.Initial_Term__c = (initialTerm == '--None--'?NULL: initialTerm);
          quoteObj.Renewal_Term__c = (renewalTerm == '--None--'?NULL: renewalTerm);
          quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == NULL ? '0' : quoteObj.Renewal_Term__c);
        upsert quoteObj;
        quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == '0' ? NULL : quoteObj.Renewal_Term__c);// to not display 0 in renewal dropdown.            
          //@Log 2 As on 12/20/2014
          initialTerm = quoteObj.Initial_Term__c;
          renewalTerm  = quoteObj.Renewal_Term__c;
          
          insert approvalObj;
          TriggerHandler.BY_PASS_RCQUOTE_ON_UPDATE = false;
          JustificationandDescription = '';
        }
        approvalList = [SELECT id,Name,Status__c,RC_Quote_Formula__c,RC_Quote__c,RC_Quote__r.Name,CreatedDate,Initial_Total_Discount__c FROM Approval__c WHERE RC_Quote__c=:quoteObj.Id];
        if(approvalObj!= NULL && approvalObj.Id != NULL){
          return new Pagereference('/'+approvalObj.Id);
        }else{
          return NULL;
        }
      }catch(System.DmlException e){
        addMessage(e.getDmlMessage(0)+e.getLineNumber());         
            return null;
      }catch(exception e){
      addMessage(e.getMessage()+e.getLineNumber());        
            return NULL;
        }     
    }
    /*********************** Method to Create Approval - Ends ***************************************/
  
    
    /*********************** Method to insert/update RC Quote  - Starts *******************************
    * @Description - Insert/Update RC Quote record when user hits 'Save' Button on Quote Tab          *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public pageReference saveQuote(){ 
      try{     
        //@Log 2 As on 12/20/2014
        quoteObj.Initial_Term__c = (initialTerm == '--None--'?NULL: initialTerm);
      quoteObj.Renewal_Term__c = (renewalTerm == '--None--'?NULL: renewalTerm);
      
        if(quoteObj.Approved_Status__c == 'Submitted'){
        addMessage('Cannot do this operation as this quote is pending for approval.');
            return NULL;
      }
        if(quoteObj.Contact__c == NULL){
          addMessage('Contact is Mandatory Field');
              return null;
        }
      if(quoteObj.Renewal_Term__c == NULL && quoteObj.Auto_Renewal__c == true && quoteObj.Quote_Type__c == 'Agreement'){
          addMessage('Renewal Term is mandatory field when Auto Renewal is checked for a Sales Agreement.');
              return null;
        }
        if(quoteObj.Valid_Until_Date__c == NULL){
          addMessage('Valid Until Date is Mandatory Field');
              return null;
        }
        if(quoteObj.Valid_Until_Date__c < System.Today() && quoteObj.id == NULL){
          addMessage('Valid Until Date cannot be less than todays date.');
              return null;
        }
        if(quoteObj.start_date__c != null && quoteObj.End_Date__c != null && quoteObj.End_Date__c < quoteObj.start_date__c){
          addMessage('End Date cannot be less than Start Date');
              return null;
        }
        if((quoteObj.Approved_Status__c == 'Required' || quoteObj.Approved_Status__c == 'Not Submitted') && quoteObj.Agreement_Status__c =='Active'){
        addMessage('Cannot make status to active as this quote requires approval.');
            return NULL;
      }
      system.debug('oldSpecialTermValue='+oldSpecialTermValue+'=New='+quoteObj.Special_Terms_and_Notes_Picklist__c);
      if(quoteObj.Approved_Status__c == 'Not Submitted' && oldSpecialTermValue != (quoteObj.Special_Terms_and_Notes_Picklist__c!=null ? quoteObj.Special_Terms_and_Notes_Picklist__c :'')){
        addMessage('An Approval has been created, but not Submitted.  Please Return/Cancel that Approval in order to make this change.');
            return NULL;
      }

        
        if(quoteObj.id == NULL){
          showIsNewQuote = true;  
        }
        
        //Copying Line Items FROM Other Quote
      List<Line_Item__c> lineItemsForNewQuoteList = new List<Line_Item__c> ();
      //To Check that quote is saving first time && If user remove Products FROM cart and Update and cart is having no product.
      if(showIsNewQuote && (lineItemGlobalList==null || lineItemGlobalList.size()==0) && parentProductId==null){
        lineItemGlobalList = new List<Line_Item__c>();
        if(opportunityLst!=null && opportunityLst.size() > 0){
          //Means Opportunity have Primary Quote in it
          if(opportunityLst[0].RC_Quotes__r!=null && opportunityLst[0].RC_Quotes__r.size() > 0){
            lineItemsForNewQuoteList = [SELECT l.Total_Price__c, l.Total_Initial_Price__c, l.Total_Initial_Discount__c, l.Total_12_Month_Price__c,
                             l.Total_12M_Discount__c,l.RC_Quote__c, l.RC_Product_Line_Item__c, l.Quantity__c,
                             l.Opportunity__c, l.Name, l.Max_Discount__c, l.MRR__c, l.List_Price__c,
                             l.Id, l.Effective_Price__c, l.Effective_Discount__c, l.Discount__c,
                             l.Discount_Type__c, l.CurrencyIsoCode,l.Charge_Term__c, l.Category__c, l.Approval_Status__c,
                             l.Approval_Required__c FROM Line_Item__c l WHERE opportunity__c =:oppObj.Id AND
                             RC_Quote__r.IsPrimary__c=true ORDER BY order__c ASC];
          }else{
            lineItemsForNewQuoteList = [SELECT l.Total_Price__c, l.Total_Initial_Price__c, l.Total_Initial_Discount__c, l.Total_12_Month_Price__c,
                         l.Total_12M_Discount__c,l.RC_Quote__c, l.RC_Product_Line_Item__c, l.Quantity__c,
                         l.Opportunity__c, l.Name, l.Max_Discount__c, l.MRR__c, l.List_Price__c,
                         l.Id, l.Effective_Price__c, l.Effective_Discount__c, l.Discount__c,
                         l.Discount_Type__c, l.CurrencyIsoCode,l.Charge_Term__c, l.Category__c, l.Approval_Status__c,
                         l.Approval_Required__c FROM Line_Item__c l WHERE opportunity__c =:oppObj.Id AND
                         RC_Quote__c=null ORDER BY order__c ASC];
          }
        }
          
          for(Line_Item__c item : lineItemsForNewQuoteList){ 
            if(item.RC_Quote__c!=null){           
              item.id = null;
            }
            lineItemGlobalList.add(item);
          }
        }
      
      quoteObj.Opportunity__c = oppObj.Id;        
        quoteObj.Quote_Type__c = (quoteObj.Quote_Type__c != 'Agreement'? 'Quote' : 'Agreement');
            
      // Set Renewal term to '0' if Auto Renewal is unchecked OR Renewal term is NULL
      quoteObj.Renewal_Term__c = (quoteObj.Auto_Renewal__c == false || quoteObj.Renewal_Term__c == NULL ? '0' : quoteObj.Renewal_Term__c);
      
      Map<String, Quote_Tool_Special_Terms__c> specialTermsMap = Quote_Tool_Special_Terms__c.getAll();
      system.debug('Special='+quoteObj.Special_Terms_and_Notes_Picklist__c);
      if(quoteObj.Special_Terms_and_Notes_Picklist__c != null && oldSpecialTermValue != quoteObj.Special_Terms_and_Notes_Picklist__c && specialTermsMap!=null && specialTermsMap.size() > 0 && 
        specialTermsMap.get(quoteObj.Special_Terms_and_Notes_Picklist__c) != null){
        quoteObj.Special_Terms_and_Notes__c = (specialTermsMap.get(quoteObj.Special_Terms_and_Notes_Picklist__c).Full_Value__c != null ? specialTermsMap.get(quoteObj.Special_Terms_and_Notes_Picklist__c).Full_Value__c : '');
        quoteObj.Special_Terms_Approval_Level__c = (specialTermsMap.get(quoteObj.Special_Terms_and_Notes_Picklist__c).Approver_Level__c != null ? specialTermsMap.get(quoteObj.Special_Terms_and_Notes_Picklist__c).Approver_Level__c : '');
        quoteObj.Approved_Status__c = 'Required';
      } else if(!string.isBlank(oldSpecialTermValue) && string.isBlank(quoteObj.Special_Terms_and_Notes_Picklist__c)){
        quoteObj.Special_Terms_and_Notes__c = '';
        quoteObj.Special_Terms_Approval_Level__c = '';
        quoteObj.Approved_Status__c = '';
        for(Line_Item__c item : lineItemGlobalList){
                system.debug('Item='+item.Approval_Required__c);
          if(item.Approval_Required__c == true){
            quoteObj.Approved_Status__c = 'Required';
            break;  
          }
              }
              
              for(Id productId : wrapperObjMap.keySet()){
                for(lineItemWrapper wrapperObj : wrapperObjMap.get(productId)){
                  system.debug('Wrapper='+wrapperObj.approvalRequired);
                  if(wrapperObj.approvalRequired == true){
                    quoteObj.Approved_Status__c = 'Required';
              break;  
                  }
                }
              }
      }          
      
      upsert quoteObj;
        quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == '0' ? NULL : quoteObj.Renewal_Term__c);// to not display 0 in renewal dropdown. 
        //@Log 2 As on 12/20/2014
      initialTerm = quoteObj.Initial_Term__c;
      renewalTerm  = quoteObj.Renewal_Term__c;
          
      for(Line_Item__c item : lineItemGlobalList){        
        item.RC_Quote__c = quoteObj.Id;
      }
            
      showQuoteReadOnlyMode=true;
      showQuoteEditMode=false;
      upsert lineItemGlobalList;
            
        updatewrapperObjMap(lineItemGlobalList);
        pageReference pgRef = new pageReference('/apex/productquoteWizard?response=quote&oppid='+oppObj.Id+'&quoteId='+(quoteObj != null && quoteObj.Id != null ? quoteObj.Id: null));
          pgRef.setRedirect(true); 
          return pgRef;  
      }catch(System.DmlException e){
        //addMessage(e.getDmlMessage(0)+e.getLineNumber());
        quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == '0' ? NULL : quoteObj.Renewal_Term__c);// to not display 0 in renewal dropdown.
        //@Log 2 As on 12/20/2014
      initialTerm = quoteObj.Initial_Term__c;
      renewalTerm  = quoteObj.Renewal_Term__c;
          
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,e.getDmlMessage(0)) );
            return null;
      }catch(Exception e){
        quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == '0' ? NULL : quoteObj.Renewal_Term__c);// to not display 0 in renewal dropdown.
        //@Log 2 As on 12/20/2014
      initialTerm = quoteObj.Initial_Term__c;
      renewalTerm  = quoteObj.Renewal_Term__c;
        addMessage(e.getMessage()+e.getLineNumber());        
            return NULL;
        }     
    }
    /*********************** Method to insert/update RC Quote  - Ends *******************************/

    
    /*********************** Method to edit RC Quote  - Starts ****************************************
    * @Description - Method called when user hits 'Edit' Button on Quote tab. Its sets some booleans -*
    *                so that page gets rerended and fields shows in editable mode.
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public pageReference editQuote(){
      if(quoteObj.Approved_Status__c == 'Submitted'){
      Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.error,'Cannot do this operation as this quote is pending for approval.') );
          return NULL;
    }
      if(quoteObj.Id!=NULL){
        tempQuoteObj = quoteObj.clone(true,true,true,true);// to take copy of old values of quote before edit. This variable is being used in cancel quote button.
        showQuoteReadOnlyMode=false;
      showQuoteEditMode=true; 
      return NULL;  
      }else{
        return new pageReference('/'+oppObj.Id);
      }     
    }
    /*********************** Method to edit RC Quote  - Ends ****************************************/

    
    /*********************** Method to redirect to Quote Detail page  - Starts ************************
    * @Description - Method called when user hits 'Canel' Button on quote edit page Quote tab. Its -  *
    *                sets boolean variable so that page gets rerended and it show the Quote detail -  *
    *                page again.
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public pageReference cancelQuote(){     
        if(quoteObj.id == NULL){
            return new pageReference('/'+oppObj.Id);
        }else{
            if(tempQuoteObj != NULL){
                quoteObj = [SELECT id,Approved_Status__c,Total_12M_Amount__c, Total_Initial_Amount__c,Name,Contact__c,Valid_Until_Date__c,Start_Date__c,CurrencyIsoCode,
                                Initial_Term__c,Agreement_Status__c,Auto_Renewal__c,End_Date__c,IsPrimary__c,Opportunity__c,Quote_Type__c,Renewal_Term__c,
                                Special_Terms_and_Notes__c,Special_Terms_and_Notes_Picklist__c,Special_Terms_Approval_Level__c,Total_12M_Discount__c,Initial_Total_Discount__c,Opportunity_Record_Type__c
                                FROM RC_Quote__c WHERE Id=:tempQuoteObj.Id LIMIT 1];
            }
            tempQuoteObj = new RC_Quote__c();// empty the temp list
            showQuoteReadOnlyMode=true;
            showQuoteEditMode=false;
            return NULL; 
        }       
    }
    /*********************** Method to redirect to Quote Detail page  - Ends *************************/  
    
    
    /*********************** Method to reset Search filters  - Starts *********************************
    * @Description - Reset search filters. Called when user hits "Reset" button on Product tab        *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public void resetSearchFilters(){
      strProductFamily='';
      strChargeTerm='';
      strServiceType='';
      strProductName='';
      productWrapperLst = new List<productWrapper>();
      showProductBlock=false;
    }
    /*********************** Method to reset Search filters  - Ends ***********************************/
    //Call when user hit Opportunity link which is at top of the page.
    public pageReference redirectToOpportunity(){
      pageReference pg = new pageReference('/'+oppObj.Id);
      return pg;
    }
    
    //Call when user hit Account link which is at top of the page.
    public pageReference redirectToAccount(){
      pageReference pg = new pageReference('/'+oppObj.AccountId);
      return pg;
    }
    
    //To go to approver record.
    public pageReference redirectToApprover(){
      if(approvalList!=null && approvalList.size() > 0){
        pageReference pg = new pageReference('/'+approvalList[0].Id);
        return pg;
      }else{
        return NULL;   
      }
    }  
    /*********************** Method to validate Quote before converting to Sales Agreement - Starts ***
    * @Description - Method to validate Quote before converting to Sales Agreement. This method looks-*
    *                mandatory fields like startDate,validDate,initialTerm,renewalTerm.               *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public PageReference validateQuote() {
        menuFlag = false;
        if(quoteObj.Approved_Status__c == 'Submitted'){
      addMessage('Cannot do this operation as this quote is pending for approval.');
          return NULL;
    }
    if(quoteObj.Approved_Status__c == 'Not Submitted' || quoteObj.Approved_Status__c == 'Required'){
      addMessage('Cannot do this operation as this quote requires approval.');
          return NULL;
    }
        if (quoteObj != null) { 
          //@Log 2 As on 12/20/2014
      quoteObj.Initial_Term__c = (initialTerm == '--None--'?NULL: initialTerm);
      quoteObj.Renewal_Term__c = (renewalTerm == '--None--'?NULL: renewalTerm);
      
            String startDate = String.valueOf(quoteObj.Start_Date__c);
            String initialTerm = String.valueOf(quoteObj.Initial_Term__c);
            String renewalTerm = String.valueOf(quoteObj.Renewal_Term__c);
            String validDate = String.valueOf(quoteObj.Valid_Until_Date__c);
            
            if(String.isBlank(startDate) || String.isBlank(validDate) || String.isBlank(initialTerm) || (String.isBlank(renewalTerm) && quoteObj.Auto_Renewal__c == true)){
                menuFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Required field(s) missing.'));
                return null;
            } else if(quoteObj.Start_Date__c < system.today()) {
                menuFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date cannot be less than today.'));
                return null;
            } else if(quoteObj.Valid_Until_Date__c < system.today()) {
                menuFlag = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Valid Until Date cannot be less than today.'));
                return null;
            }
        } 
       
        if(menuFlag == false) {
            quoteObj.name = 'Sales Agreement for '+oppObj.name;
            quoteObj.Quote_Type__c = 'Agreement'; 
            quoteObj.Agreement_Status__c = 'Draft'; 
            try {
              // Set Renewal term to '0' if Auto Renewal is unchecked OR Renewal term is NULL
          //@Log 2 As on 12/20/2014
          quoteObj.Initial_Term__c = (initialTerm == '--None--'?NULL: initialTerm);
          quoteObj.Renewal_Term__c = (renewalTerm == '--None--'?NULL: renewalTerm);
        quoteObj.Renewal_Term__c = (quoteObj.Auto_Renewal__c == false || quoteObj.Renewal_Term__c == NULL ? '0' : quoteObj.Renewal_Term__c);
        update quoteObj;
          quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == '0' ? NULL : quoteObj.Renewal_Term__c);// to not display 0 in renewal dropdown.
          //@Log 2 As on 12/20/2014
          initialTerm = quoteObj.Initial_Term__c;
          renewalTerm  = quoteObj.Renewal_Term__c;
            } catch(System.DmlException e) {
              quoteObj.Renewal_Term__c=(quoteObj.Renewal_Term__c == '0' ? NULL : quoteObj.Renewal_Term__c);// to not display 0 in renewal dropdown. 
                //@Log 2 As on 12/20/2014
          initialTerm = quoteObj.Initial_Term__c;
          renewalTerm  = quoteObj.Renewal_Term__c;
                menuFlag = true;
                addMessage( e.getDmlMessage(0)+e.getLineNumber());                 
                return null; 
            }
        } 
        pageReference pgRef = new pageReference('/apex/productquoteWizard?response=quote&oppid='+oppObj.Id+'&quoteId='+(quoteObj != null && quoteObj.Id != null ? quoteObj.Id: null));
        pgRef.setRedirect(true); 
        return pgRef;
    } 
    /*********************** Method to validate Quote before converting to Sales Agreement - Ends ***/ 
    //To show "Conver To Sales Agreement" block
    public pageReference convertToSales(){
    menuFlag = true;
    return null;
    }  
    
    //For adding pageMessages on VF page.
    private void addMessage(String str) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, str,''));
    }
    
    /*********************** Navigate to PDF Generation Page - Starts *********************************
    * @Description - Wrapper Class for Product Object to show on Product tab.                         *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public PageReference generatePdf() {
      System.debug(quoteObj.Opportunity_Record_Type__c+'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~quoteObj');
      if(quoteObj.Approved_Status__c == 'Submitted'){
      addMessage('Cannot do this operation as this quote is pending for approval.');
          return NULL;
    }
    if(quoteObj.Approved_Status__c == 'Not Submitted' || quoteObj.Approved_Status__c == 'Required'){
      addMessage('Cannot do this operation as this quote requires approval.');
          return NULL;
    }
      showTemplatePanel = (showTemplatePanel==false || showTemplatePanel==null ? true : false);
      templateRecordList = new List<RC_Quote_Template__c>();
      if(showTemplatePanel){
        templateList = new List<SelectOption>();
        for(RC_Quote_Template__c templateObj : [SELECT Id, Name,LastModifiedDate,Sorting_Order__c, Description__c, Brand__c, Type__c,Active__c FROM RC_Quote_Template__c 
            WHERE Brand__c != NULL AND type__c != NULL AND Active__c != false  AND Opportunity_Record_Type__c includes (:quoteObj.Opportunity_Record_Type__c) ORDER BY Sorting_Order__c ASC NULLS LAST,LastModifiedDate DESC]) {           
          String brand = templateObj.Brand__c;
        String templateType = templateObj.type__c;
        
        Set<String> brandSet = new Set<String>();
        if(brand != null && brand.indexOf(';') != -1) {
          brandSet.addAll(brand.split(';'));
        } else {
          brandSet.add(brand);
        }
        Set<String> templateSet = new Set<String>();
        if(templateType != null && templateType.indexOf(';') != -1) {
          templateSet.addAll(templateType.split(';'));
        } else {
          templateSet.add(templateType);
        }
        
        if(oppObj != null && quoteObj != null && quoteObj.id != null ) {
          if((String.isBlank(oppObj.Brand_Name__c) || brandSet.contains( oppObj.Brand_Name__c)) 
          &&  (String.isBlank(quoteObj.Quote_Type__c) || templateSet.contains(quoteObj.Quote_Type__c))) {
            templateRecordList.add(templateObj);
            templateList.add(new SelectOption(templateObj.Id, templateObj.Name));
            selectedTemplate = templateRecordList.get(0).Id;
          }
        }
          
        }
        return null;
      }
      return null;      
    }
    /*********************** Navigate to PDF Generation Page - Ends *********************************/
    
    /*********************** Wrapper Class for Product - Starts ***************************************
    * @Description - Wrapper Class for Product Object to show on Product tab.                         *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public class productWrapper{
      public id productId{get;set;}
      public String productName{get;set;}
      public String productCategory{get;set;}
      public String productChargeTerm{get;set;}
      public String productSKU{get;set;}
      public String dependentSKU{get;set;}
      public Boolean bolSelectedProduct{get;set;}
     
      public productWrapper(id productId,String productName,String productCategory,String productChargeTerm,String productSKU,String dependentSKU){
          this.productId = productId;
          this.productName = productName;
          this.productCategory = productCategory;
          this.productChargeTerm = productChargeTerm;
          this.productSKU = productSKU;
          this.dependentSKU = dependentSKU;
          this.bolSelectedProduct = false;
      }
  }
    /*********************** Wrapper Class for Product - Ends ***************************************/
    
    
    /*********************** Product Line Item (PLI) - Starts *****************************************
    * @Description - Wrapper Class for Product Line Item (PLI) details to show on Cart Tab.           *
    * @Author      - Simplion Technologies                                                            * 
  **************************************************************************************************/
    public class lineItemWrapper{
        
        public Id lineItemId{get;set;}
        public Id productLineItemId{get;set;}
        public String productName{get;set;}
        public String productType{get;set;}
        public String productCategory{get;set;}
        public String chargeTerm{get;set;}
        public id productId{get;set;}
        public String productLineItemName{get;set;}
        public String productSKU{get;set;}
        public String productDependentSKU{get;set;}
        public Decimal maxDiscount{get;set;}
        public Decimal listPrice{get;set;}
        public Decimal effectivePrice{get;set;}
        public Decimal effectiveDiscount{get;set;}
        public Decimal discount{get;set;}
        public Integer quantity{get;set;}
        public Integer oldQuantity{get;set;}
        public Decimal totalPrice{set;get;}
        public String selectedDiscountType{set;get;}
        public String currencyCode{set;get;}
        public Boolean disableMode{get;set;}
        public Boolean approvalRequired{set;get;}
        public String productExcludedSKUs{get;set;}
        public String productExcludedTypes{get;set;}
        
        //Called when adding new Product FROM Product tab.
        public lineItemWrapper(Id productLineItemId,String productName,String productType,Id productId,Decimal maxDiscount,
                               Id strOpportunityId,Decimal listPrice,String productLineItemName,String currencyCode,Boolean disableMode,
                               Integer quantity, Integer oldQuantity,Decimal discount,Boolean approvalRequired,String productSKU,
                               String productDependentSKU,String productExcludedSKUs,String productExcludedTypes,String productCategory,
                               String chargeTerm){ 
            this.quantity = quantity;
            this.oldQuantity = oldQuantity;
            this.discount = discount;           
            this.productLineItemId = productLineItemId;
            this.productName = productName;
            this.productType = productType;
            this.productId = productId;
            this.productLineItemName = productLineItemName;
            this.maxDiscount = maxDiscount;
            this.listPrice = listPrice;
            this.effectiveDiscount=0;
            this.effectivePrice= this.listPrice-this.effectiveDiscount;
            this.totalPrice = this.effectivePrice;
            this.currencyCode = currencyCode;
            this.disableMode = disableMode;
            this.approvalRequired = approvalRequired;
            this.productSKU= productSKU;
            this.productDependentSKU = productDependentSKU;
            this.productExcludedSKUs = productExcludedSKUs;
            this.productExcludedTypes = productExcludedTypes;
            this.productCategory = productCategory;
            this.chargeTerm = chargeTerm;
        }
        
        //Called when Opportunity already contains Product in it.
        public lineItemWrapper(Id lineItemId,Decimal discount,Id productLineItemId,Id productId,String productName,String productType,
                    String productLineItemName,Decimal maxDiscount,Integer quantity,Integer oldQuantity,Decimal effectivePrice,
                    Decimal effectiveDiscount,Decimal totalPrice,String selectedDiscountType,Decimal listPrice,Boolean approvalRequired,
                                String currencyCode, Boolean disableMode,String productSKU,String productDependentSKU,String productExcludedSKUs,
                                String productExcludedTypes,String productCategory,String chargeTerm){
            this.lineItemId = lineItemId;
            this.discount = discount;
            this.productLineItemId = productLineItemId;
            this.productId = productId;
            this.productName = productName;
            this.productType = productType;
            this.productLineItemName= productLineItemName;
            this.maxDiscount = maxDiscount;
            this.effectivePrice = effectivePrice; 
            this.effectiveDiscount = effectiveDiscount;
            this.totalPrice = totalPrice;
            this.selectedDiscountType = selectedDiscountType; 
            this.listPrice = listPrice;
            this.currencyCode =currencyCode;
            this.disableMode = disableMode;
            this.approvalRequired = approvalRequired;
            this.quantity= quantity;
            this.oldQuantity = oldQuantity;
            this.productSKU= productSKU;
            this.productDependentSKU = productDependentSKU;
            this.productExcludedSKUs = productExcludedSKUs;
            this.productExcludedTypes = productExcludedTypes;
            this.productCategory = productCategory;
            this.chargeTerm = chargeTerm;
        }
    }
    
    /*********************** Method to get Initial Term Values Based on Profiles  - Starts ******************************************
    * @Description - Method to get Initial Term Values Based on Profiles                              *
    * @Author      - Simplion Technologies                                                                            * 
  ********************************************************************************************************************************/
    public List<SelectOption> getInitialTermValues() {
        List<SelectOption> options = new List<SelectOption>();
        options = populateOptionValues('initial');
        return options;
    } 
    /*********************** Method to get Renewal Term Values Based on Profiles  - Starts ******************************************
    * @Description - Method to get Renewal Term Values Based on Profiles                              *
    * @Author      - Simplion Technologies                                                                            * 
  ********************************************************************************************************************************/
    public List<SelectOption> getRenewalTermValues() {
        List<SelectOption> options = new List<SelectOption>();
        options = populateOptionValues('renewal');
        return options;
    } 
    /*********************** Method to get Initial/Renewal Term Values Based on Profiles  - Starts **********************************
    * @Description - Method to get Initial/Renewal Term Values Based on Profiles                          *
    * @Author      - Simplion Technologies                                                                            * 
  ********************************************************************************************************************************/
    private List<SelectOption> populateOptionValues(String term){
      List<SelectOption> options = new List<SelectOption>();
      // Find all the states we have in custom settings.
        InitialAndRenewalTermForQuoteTool__c CS = InitialAndRenewalTermForQuoteTool__c.getValues(System.Userinfo.getProfileId());
        if(CS == NULL){
          CS = InitialAndRenewalTermForQuoteTool__c.getOrgDefaults();
        }
        String termFromCustomSetting = '';
        if(term == 'initial'){
          termFromCustomSetting = CS.Initial_Term__c ; 
        }else if(term == 'renewal'){
          termFromCustomSetting = CS.Renewal_Term__c ; 
        }
        List<String> finalList= new List<String>();
        finalList = ((termFromCustomSetting != NULL && termFromCustomSetting != '') ? termFromCustomSetting.split(','): NULL);
      // Generate the Select Options based on the final list 
        if(finalList != NULL && finalList.size() > 0 ){
            for (String terms : finalList) {
                options.add(new SelectOption(terms, terms));
            }
        }    
        if(term == 'initial' && String.valueOf(quoteObj.Initial_Term__c) != NULL && String.valueOf(quoteObj.Initial_Term__c).contains('12')){
          if(isRCPartnerUser){
            options.add(new SelectOption(quoteObj.Initial_Term__c, quoteObj.Initial_Term__c));
          }
        }else if(term == 'renewal' && String.valueOf(quoteObj.Renewal_Term__c) != NULL && String.valueOf(quoteObj.Renewal_Term__c).contains('12')){
          if(isRCPartnerUser){
            options.add(new SelectOption(quoteObj.Renewal_Term__c, quoteObj.Renewal_Term__c));
          }
        }
        return options;
    }
    
}