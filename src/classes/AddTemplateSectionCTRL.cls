/**************************************************************************************************
* Project Name..........: Quoting Tool 3.0                                                        *
* File..................: AddTemplateSectionCTRL.class                                            *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 27-03-2014                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 27-03-2014                                                              *
* Description...........: This class is used to add various sections when we create new Template  *
**************************************************************************************************/

public class AddTemplateSectionCTRL{
    public RC_Quote_Template__c rcTemplateObj{get;set;}
    public TemplateSections__c templateSectionObj {get;set;}
    
    public List<TemplateSections__c> sections {get;set;}
    public List<TemplateSectionJunction__c> sectionJunctionList {get;set;}
    
    // Map for objects,describe fields.
    public Map<String,List<SelectOption>> objFieldAPIList {get; set;}
    public String strQuoteField {get;set;}
    /* DEPRECATED
    // Select Options List for generating merge fields for different objects.
    public List<SelectOption> oppFieldAPIList{get;set;}
    public List<SelectOption> quoteFieldAPIList{get;set;}
    public List<SelectOption> rcProductFieldAPIList{get;set;}
    public List<SelectOption> rcProductLineItemFieldAPIList{get;set;}
    public List<SelectOption> accountFieldAPIList{get;set;}
    public List<SelectOption> contactFieldAPIList{get;set;}
    */
    /* DEPRECATED
    // Fields to store the final merge fields value.
    public String strOppField {get;set;}
    public String strRCProductField {get; set;}
    public String strRCProductLineItemField {get; set;}
    public String strAccountField {get; set;}
    public String strContactField {get; set;}
    */
    /*DEPRECATED
    // Fields for different objects, to fetch field details from schema.
    public Opportunity oppObj{get;set;}
    public RC_Quote__c quoteObj{get;set;} 
    public RC_Product__c rcProductObj {get; set;}
    public RC_Product_Line_Item__c rcProductLineItemObj {get; set;}
    public Account accountObj {get; set;}
    public Contact contactObj {get; set;}
    */
    public String sectionContent {get;set;}
    
    public Integer position {get;set;}
    
    public String strHeader {get;set;}
    /*DEPRECATED
    public String strLineItem {get;set;}
    public String strCondition {get;set;}
    public String strTerms{get;set;}
    */
    public String strSelectedObject {get;set;}
    /*DEPRECATED
    public static String strStaticHeader{get;set;}
    public static String strStaticItem{get;set;}
    public static String strStaticCondition{get;set;}
    public static String strStaticTerm{get;set;}    
    public Boolean addSection {get;set;}
    */
    /*
    private Set<String> childObjectSet = new Set<String>{ 'Account','Line Item','Quote','RC Quote','RC Product','RC Product Line Item','Opportunity Contact Role' };
    public List<SelectOption> childFieldAPIList{get;set;}
    public String childFieldSelected{get;set;}
    public Boolean childFlag {get; set;}
    */
    ApexPages.StandardController controller {get;set;}
    
    //Constructor
    public AddTemplateSectionCTRL(){}
    /******************************************************************************
    * @Description : Constructor                                                  *
    * @Params      : ApexPages.StandardController                                 *
    * @Return      : void                                                         * 
    ******************************************************************************/
    public AddTemplateSectionCTRL(ApexPages.StandardController controller) {
        this.controller = controller;
        // addMessage('## INSIDE 3##'+ System.now());
        position = 1;
        /*DEPRECATED
        addSection = false;
        childFlag = false;
        */
        /* DEPRECATED
        // Instantiating Select Options List for generating merge fields for different objects. 
        oppFieldAPIList = new List<SelectOption>();
        quoteFieldAPIList = new List<SelectOption>();
        rcProductFieldAPIList = new List<SelectOption>();
        rcProductLineItemFieldAPIList = new List<SelectOption>();
        accountFieldAPIList = new List<SelectOption>();
        contactFieldAPIList = new List<SelectOption>();
        */
        objFieldAPIList = new Map<String,List<SelectOption>>();
        for(SelectOption thisOption : getObjects()){
            system.debug('#### select option value - '+thisOption.getValue());
            if(thisOption.getValue() != null && thisOption.getValue() != ''){
                objFieldAPIList.put(thisOption.getValue(),getPickValues(getNewSobject(thisOption.getValue()),thisOption.getValue()));
            }
        }
        system.debug('#### objectAPIList - '+objFieldAPIList);
        /*DEPRECATED
        // Instantiating Fields for different objects, to fetch field details from schema.
        oppObj = new Opportunity();
        quoteObj = new RC_Quote__c();
        rcProductObj =  new RC_Product__c();
        rcProductLineItemObj =  new RC_Product_Line_Item__c();
        accountObj =  new Account();
        contactObj = new Contact();
        */
        templateSectionObj = new TemplateSections__c(); 
        rcTemplateObj = new RC_Quote_Template__c();
        sections = new List<TemplateSections__c>();
        sectionJunctionList = new List<TemplateSectionJunction__c>();
        
        /*DEPRECATED
        // Calling methods to generate schema fields pickList, based on input Object.
        oppFieldAPIList = getPickValues(oppObj,'Opportunity');
        quoteFieldAPIList = getPickValues(quoteObj,'RC_Quote__c');
        rcProductFieldAPIList = getPickValues(rcProductObj,'RC_Product__c');
        rcProductLineItemFieldAPIList = getPickValues(rcProductLineItemObj,'RC_Product_Line_Item__c');
        accountFieldAPIList = getPickValues(accountObj,'Account');
        contactFieldAPIList = getPickValues(contactObj,'Contact');
        */
        
        sectionWrapperList = new List<TemplateSectionWrapper>();
        sectionContent = '';
        selectedSection = '';
        sectionList = new List<SelectOption>();
        
        String recordId = controller.getId();
        if(recordId != null) {
            try {
                templateSectionObj = prepareSectionList(recordId);
                strHeader = prepareContent(templateSectionObj); 
            } catch(Exception ex) { addMessage(ex.getMessage());}
        }
    }
    
    public List<SelectOption> sectionList{get;set;}
    public String selectedSection {get;set;} 
    private Map<String, TemplateSections__c> sectionMap{get;set;}
    /******************************************************************************
    * @Description : Method to Prepare the TemplateSection__c List                *
    * @Params      : String                                                       *
    * @Return      : TemplateSections__c                                          * 
    ******************************************************************************/  
    private TemplateSections__c prepareSectionList(String recordId) {
        return [SELECT Id, Name, Content_1__c, Content_2__c, Content_3__c,Content_4__c, Content_5__c,Description__c  FROM TemplateSections__c WHERE Id=:recordId];
    }
    private void addMessage(String str) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, str));
    }
    private Boolean isEmpty(String str) {
        return (String.isBlank(str));
    }
     
    /******************************************************************************
    * @Description : Generic method to fetch any object field details             *
    * @Params      : Sobject, String                                              *
    * @Return      : List of SelectOptions                                        * 
    ******************************************************************************/ 
    public List<SelectOption> getPickValues(Sobject object_name,String objectName) {
        List<SelectOption> options = new List<SelectOption>();        
        options.add(new SelectOption('','--None--'));        
        
        Schema.sObjectType sobject_type = object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<String> fieldList = new List<String>();
        for(String fieldApi : field_map.keySet()){
            fieldList.add(fieldApi);
            //options.add(new SelectOption(fieldApi,field_map.get(fieldApi).getDescribe().getLabel()));
        }
        fieldList.sort();
        for(String fieldApi : fieldList){           
            options.add(new SelectOption('{!'+objectName+'.'+fieldApi+'}',field_map.get(fieldApi).getDescribe().getLabel()));
        }
        
        options.sort();
        return options;
    }
    public PageReference cancelRecord() {
        return controller.cancel();
    }
    /******************************************************************************
    * @Description : Method to fetch child field API List.                        *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/     
    /*public void getChildFields(){
        try{
            childFieldAPIList = new List<SelectOption>();
            childFlag = false;
            String objectName;
            
            if(strOppField != null){
                objectName = strOppField;
            }
            else if(strQuoteField != null){
                objectName = strOppField;
            }
            else{
                objectName = null;
            }
            
            if(objectName != null){
                
                childFieldAPIList.add(new SelectOption('','--None--'));
                
                // Getting child field sObject Type.
                Schema.sObjectType sChildobject_type = Schema.getGlobalDescribe().get(objectName);
                // Getting sObject Type of master field.
                Schema.sObjectType sobject_type = Schema.getGlobalDescribe().get(strSelectedObject);
                Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
                // Fetch name of all child relationships for associated master object.
                List<Schema.ChildRelationship> childRelationships = sobject_describe.getChildRelationships(); 
                system.debug('#### child relationship size - '+childRelationships.size());
                for(Schema.ChildRelationship thisRecord : childRelationships){
                    system.debug('#### thisRecord - '+thisRecord);
                    if(thisRecord.getChildSObject() == sChildobject_type){
                        system.debug('#### required thisRecord - '+thisRecord);
                        childFieldAPIList.add(new SelectOption('{!'+strSelectedObject+'.'+thisRecord.getRelationshipName()+'.'+thisRecord.getField()+'}',thisRecord.getRelationshipName()+'.'+thisRecord.getField()));
                        system.debug('#### fields - '+'{!'+strSelectedObject+'.'+thisRecord.getRelationshipName()+'.'+thisRecord.getField()+'}');
                        childFlag = true;
                    }
                    if(childObjectSet != null && !childObjectSet.isEmpty() && !childObjectSet.contains(objectName)){
                        childFlag = false;
                        childFieldSelected = null;
                    }
                }
            }
        } catch(Exception ex){
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());  
        }
    } 
    */
     
   
    /******************************************************************************
    * @Description : Getter Method for Object name picklist                       *
    * @Params      : void                                                         *
    * @Return      : List of SelectOptions                                        * 
    ******************************************************************************/
    public List<SelectOption> getObjects() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        try {
            if( Merge_Fields_Mapping__c.getAll() != null && !(Merge_Fields_Mapping__c.getAll()).isEmpty()){
                for(String thisField : Merge_Fields_Mapping__c.getAll().keyset()){
                    Merge_Fields_Mapping__c MergeFieldMapping = Merge_Fields_Mapping__c.getAll().get(thisField);
                    options.add(new SelectOption(MergeFieldMapping.Name,MergeFieldMapping.Display_Name__c));    
                }
            }
        } catch(Exception exc) {
            system.debug('#### Error on line - '+exc.getLineNumber());
            system.debug('#### Error message - '+exc.getMessage());     
        }
        system.debug('#### options - '+options);        
        return options;
    }
    /******************************************************************************
    * @Description : Method to split the string of sections contents              *
    * @Params      : void                                                         *
    * @Return      : pagereference                                                * 
    ******************************************************************************/ 
    public PageReference saveSection() {
        // addMessage('## NAME: ' + templateSectionObj.Name +'\n## CONTENT: ' + strHeader);
        if(isEmpty(templateSectionObj.Name) || isEmpty(strHeader)) {
            addMessage('Required field(s) missing.');
        } else {
            templateSectionObj = splitContent(strHeader, templateSectionObj);
            if(templateSectionObj.id != null)
                update templateSectionObj;
            else
                insert templateSectionObj;
            return new PageReference('/'+templateSectionObj.id);
        }
        return null;
    }
    /******************************************************************************
    * @Description : Method to split the string of sections contents              *
    * @Params      : String,TemplateSections__c                                   *
    * @Return      : TemplateSections__c                                          * 
    ******************************************************************************/ 
    private TemplateSections__c splitContent(String content, TemplateSections__c templateSectionObj) {
        String contentCondition1='';
        String contentCondition2='';
        String contentCondition3='';
        String contentCondition4='';
        String contentCondition5='';
        integer startLimit = 32000; 
        if(Test.isRunningTest()){
        	startLimit= 2;
        }
        if(content != null && content.length() > startLimit && content.length() < 163841){
            String tempText='';             
            contentCondition1 = content.subString(0,startLimit);             
            temptext = content.subString(startLimit);
            system.debug('==contentCondition1=='+contentCondition1.length());
            system.debug('==temptext2=='+temptext.length());
            if(temptext.length() >= startLimit){
                contentCondition2 = temptext.subString(0,startLimit);
                temptext = temptext.subString(startLimit);
            }else{
                contentCondition2 = temptext.subString(0,temptext.length());
                temptext ='';
            }
            system.debug('==contentCondition2=='+contentCondition2.length());
            system.debug('==temptext2=='+temptext.length());
            if(temptext.length() >= startLimit){
                contentCondition3 = temptext.subString(0,startLimit);
                temptext = temptext.subString(startLimit);
            }else{
                contentCondition3 = temptext.subString(0,temptext.length());
                temptext ='';
            }
            system.debug('==contentCondition3=='+contentCondition3.length());
            system.debug('==temptext3=='+temptext.length());
            if(temptext.length() >= startLimit){
                contentCondition4 = temptext.subString(0,startLimit);
                temptext = temptext.subString(startLimit);
            }else{
                contentCondition4 = temptext.subString(0,temptext.length());
                temptext ='';
            }
            system.debug('==contentCondition4=='+contentCondition4.length());
            system.debug('==temptext4=='+temptext.length());
            if(temptext.length() >= startLimit){
                contentCondition5 = temptext.subString(0,startLimit);
                temptext = temptext.subString(startLimit);
            }else{
                contentCondition5 = temptext.subString(0,temptext.length());
                temptext ='';
            }   
            system.debug('==contentCondition5=='+contentCondition5.length());
            system.debug('==temptext5=='+temptext.length());
            templateSectionObj.Content_1__c = contentCondition1;
            templateSectionObj.Content_2__c = contentCondition2;
            templateSectionObj.Content_3__c = contentCondition3;
            templateSectionObj.Content_4__c = contentCondition4;
            templateSectionObj.Content_5__c = contentCondition5;            
        }else if(content.length() <= startLimit){
            templateSectionObj.Content_1__c = content;              
        }
        return templateSectionObj;
    }
    public List<TemplateSectionWrapper> previewWrapperList{get;set;}
    
    /****************************************************/
    /*  Add Template Section                            */
    /****************************************************/
    public List<TemplateSectionWrapper> sectionWrapperList{get;set;}
    /******************************************************************************
    * @Description : Wrapper class to hold Template section variables             * 
    ******************************************************************************/
    public class TemplateSectionWrapper {
        public String juctionId {get;set;}
        public String templateId {get;set;}
        public String sectionId {get;set;}
        public Integer positionIndex{get;set;}
        public String content {get;set;}
        public TemplateSectionWrapper() {}
    }
    /******************************************************************************
    * @Description : Method to create a string of sections contents               *
    * @Params      : TemplateSections__c record                                   *
    * @Return      : String                                                       * 
    ******************************************************************************/
    private String prepareContent(TemplateSections__c section) {
        return (section.Content_1__c == null ? '' : section.Content_1__c)+''
                +(section.Content_2__c == null ? '' : section.Content_2__c)+''
                +(section.Content_3__c == null ? '' : section.Content_3__c)+''
                +(section.Content_4__c == null ? '' : section.Content_4__c)+''
                +(section.Content_5__c == null ? '' : section.Content_5__c);
    }

    /******************************************************************************
    * @Description : Method to create new sObject dynamically.                    *
    * @Params      : void                                                         *
    * @Return      : sObject                                                      * 
    ******************************************************************************/      
    public SObject getNewSobject(String objectName){
    
     // Call global describe to get the map of string to token.
     Map<String, Schema.SObjectType> schemaDescribe = Schema.getGlobalDescribe();
     // Get the token for the sobject based on the type.
     Schema.SObjectType objectType = schemaDescribe.get(objectName);
    
     // Instantiate the sobject from the token.
     Sobject s = objectType.newSobject();
    
     return s;
    }
}