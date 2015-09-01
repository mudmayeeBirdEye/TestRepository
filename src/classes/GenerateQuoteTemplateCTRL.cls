/**************************************************************************************************
* Project Name..........: Quoting Tool 3.0                                                        *
* File..................: GenerateQuoteTemplateCTRL.class                                         *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 4/15/2014                                                               *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 4/15/2014                                                               *
* Description...........: This is a class used for VF page GenerateQuoteTemplate. Its been used - *
*						  for generating new Template for PDF. User can create new Templates, add-*
*                         sections to the templates using this controller class.                  *
**************************************************************************************************/
public class GenerateQuoteTemplateCTRL{
    public RC_Quote_Template__c rcTemplateObj{get;set;}
    
    public List<TemplateSections__c> sections {get;set;}
    public List<TemplateSectionJunction__c> sectionJunctionList {get;set;}
    
    // Select Options List for generating merge fields for different objects.
    
    // Fields to store the final merge fields value.
    public String strOppField {get;set;}
    public String strQuoteField {get;set;}
    public String strRCProductField {get; set;}
    public String strRCProductLineItemField {get; set;}
    public String strAccountField {get; set;}
    public String strContactField {get; set;}
    
    // Fields for different objects, to fetch field details from schema.
    public Opportunity oppObj{get;set;}
    public RC_Quote__c quoteObj{get;set;} 
    public RC_Product__c rcProductObj {get; set;}
    public RC_Product_Line_Item__c rcProductLineItemObj {get; set;}
    public Account accountObj {get; set;}
    public Contact contactObj {get; set;}
    
    public String sectionContent {get;set;}
    
    public Integer position {get;set;}
    
    public String strHeader {get;set;}
    public String strLineItem {get;set;}
    public String strCondition {get;set;}
    public String strTerms{get;set;}
    
    public String strSelectedObject {get;set;}
    public static String strStaticHeader{get;set;}
    public static String strStaticItem{get;set;}
    public static String strStaticCondition{get;set;}
    public static String strStaticTerm{get;set;}    
    
    public Boolean addSection {get;set;}
    
    private Set<String> childObjectSet = new Set<String>{ 'Account','Line Item','Quote','RC Quote','RC Product','RC Product Line Item','Opportunity Contact Role' };
    public List<SelectOption> childFieldAPIList{get;set;}
    public String childFieldSelected{get;set;}
    public Boolean childFlag {get; set;}
    
    public List<TemplateSectionWrapper> previewWrapperList{get;set;}
    private String recordType {get;set;}
    private String previewId {get;set;}
    public String selectedPreviewId {get;set;}
    
    public List<SelectOption> sectionList{get;set;}
    public String selectedSection {get;set;} 
    private Map<String, TemplateSections__c> sectionMap{get;set;}
    
    //Constructor
    public GenerateQuoteTemplateCTRL(){}
    /************************************* Constructor Code Starts ***************************************************
	* @Description - Instantiating variable, Querying for related Object records, and populating required lists,Maps *
	* @Author      - Simplion Technologies                                                                           * 
	*****************************************************************************************************************/
    public GenerateQuoteTemplateCTRL(ApexPages.StandardController controller) {
        // addMessage('## INSIDE 3##'+ System.now());
        position = 1;
        addSection = false;
        childFlag = false;
        
        // Instantiating Fields for different objects, to fetch field details from schema.
        oppObj = new Opportunity();
        quoteObj = new RC_Quote__c();
        rcProductObj =  new RC_Product__c();
        rcProductLineItemObj =  new RC_Product_Line_Item__c();
        accountObj =  new Account();
        contactObj = new Contact();
        
        rcTemplateObj = new RC_Quote_Template__c();
        sections = new List<TemplateSections__c>();
        sectionJunctionList = new List<TemplateSectionJunction__c>();
        
        /*
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
       //  system.debug('#### templateId - '+templateId);
        /////////////////////////// TEMPLATE PREVIEW //////////////////////////////////////
        String parentRecordId = ApexPages.currentPage().getParameters().get('opptyid');
        //addMessage('OPPTYID = '+ parentRecordId);
        if(parentRecordId != null && parentRecordId != 'null') {
            previewId = parentRecordId;
            recordType = 'o';
        } 
        parentRecordId = ApexPages.currentPage().getParameters().get('quoteid');
        system.debug('#### parentRecordId - '+parentRecordId);
        //addMessage('QUOTEID = '+ parentRecordId);
        if(parentRecordId != null && parentRecordId != 'null') {
            previewId = parentRecordId;
            recordType = 'q';
        } 
        if(rcTemplateObj != null && rcTemplateObj.RC_Quote__c != null) {
            previewId = rcTemplateObj.RC_Quote__c;
            recordType = 'q';
        }
        ////////////////////////////////////////////////////////////////////////////////////
        
        ////////////////////// FOR TEMPLATE ADD/EDIT //////////////////////////////////////
        prepareSectionList();
        ///////////////////////////////////////////////////////////////////////////////////
        
        /////////////////////// FOR EDIT TEMPLATE //////////////////////////////////////
        Id recordId = controller.getId();
        if(recordId != null) {
            try {
            	//-------------------------------------------------------As/Simplion/8/20/2014---------------------------------------------------------------------
                rcTemplateObj = [SELECT Id, Name, Brand__c,Description__c, Type__c,RC_Quote__c,Sorting_Order__c,Version__c,Active__c,Opportunity_Record_Type__c, (SELECT Id, Position__c, RC_Quote_Template__c, Template_Section__c 
                FROM TemplateSectionJunction__r ORDER BY Position__c ASC,LastModifiedDate DESC) FROM RC_Quote_Template__c WHERE Id =:recordId ];
                if(rcTemplateObj != null && rcTemplateObj.TemplateSectionJunction__r != null) {
                    sectionJunctionList = rcTemplateObj.TemplateSectionJunction__r;
                    system.debug('***@@@*** sectionMap *** '+sectionMap);
                    if(sectionMap != null && sectionJunctionList != null) {
                        for(TemplateSectionJunction__c junction : sectionJunctionList) {
                            if(junction.Template_Section__c != null) {
                                TemplateSections__c section = sectionMap.get(junction.Template_Section__c);
                                if(section != null) {
                                    TemplateSectionWrapper obj = new TemplateSectionWrapper();
                                    obj.juctionId = junction.Id;
                                    obj.positionIndex = Integer.valueOf(junction.Position__c == null ? 1 : junction.Position__c);
                                    obj.sectionName = section.Name;
                                    obj.templateId = junction.RC_Quote_Template__c;
                                    obj.content = prepareContent(section);
                                    obj.sectionId = section.Id;
                                    sectionWrapperList.add(obj);
                                }
                            }
                        }
                    }
                }
            } catch(Exception ex) { 
                    system.debug('### ' + ex.getMessage() +', LINE NUMBER ' +ex.getLinenumber() );
                    addMessage('### ' + ex.getMessage() +', LINE NUMBER ' +ex.getLinenumber() );
            }
        }
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        ////////////////////////////////////////// FOR TEMPLATE PREVIEW //////////////////////////////////////////////////////////
        previewWrapperList = sectionWrapperList;
        ////////////////////////////////////////// FOR TEMPLATE PREVIEW WITH REAL DATA  //////////////////////////////////////////
        if(previewId != null) //please uncomment it close for code coverage
           prepareDynamicPreview(previewId);// please uncomment it is closed for code coverage;
    }
    /************************************* Constructor Code Ends ************************************/
   
    /************************************* Method prepareSectionList Starts ******************************************
	* @Description - Preparing list of Template Section Records.                                                     *
	* @Author      - Simplion Technologies                                                                           * 
	*****************************************************************************************************************/
    public void prepareSectionList() {
        sectionMap = new Map<String, TemplateSections__c>();
        sections = [SELECT Id, Name, Content_1__c, Content_2__c, Content_3__c,Content_4__c, Content_5__c FROM TemplateSections__c ORDER BY LastModifiedDate ASC];
        for(TemplateSections__c section : sections) {
            sectionMap.put(section.Id, section);
            SelectOption option = new SelectOption(section.Id, section.Name);
            sectionList.add(option);
        }
        system.debug('@@@@-----sectionMap------@@@ '+sectionMap);
    }
    /************************************* Method prepareSectionList Ends ******************************************/

    /************************************* Method to Messages - Starts ***********************************************
	* @Description - Generic Method to show Messages on visualforce page                                             *
	* @Author      - Simplion Technologies                                                                           * 
	*****************************************************************************************************************/
    private void addMessage(String str) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, str));
    }
    /************************************* Method to Messages - Ends ***********************************************/
    private Boolean isEmpty(String str) {
        return (String.isBlank(str));
    }
    
    /************************************* Method to Save the Template - Starts **************************************
	* @Description - Method to Save the Template                                                                     *
	* @Author      - Simplion Technologies                                                                           * 
	*****************************************************************************************************************/
    public void saveTemplate() {
        try {
            if(!isEmpty(rcTemplateObj.Name) && !isEmpty(rcTemplateObj.Brand__c) && !isEmpty(rcTemplateObj.Type__c)) {
                if(rcTemplateObj.Id != null)
                    update rcTemplateObj;
                else 
                    insert rcTemplateObj;
                // upsert rcTemplateObj; // will add the code to return preview
                
                try {
                    List<TemplateSectionJunction__c> juctionList = [SELECT Id FROM TemplateSectionJunction__c WHERE RC_Quote_Template__c =: rcTemplateObj.Id];
                    if(juctionList != null && juctionList.size() != 0) {
                        delete juctionList;
                    }
                } catch(Exception x) {
                    system.debug('### ' + x.getMessage() +', LINE NUMBER ' +x.getLinenumber() );
                    addMessage('### ' + x.getMessage() +', LINE NUMBER ' +x.getLinenumber() );
                }
                
                //Becuase of duplice id in list error...List is again initialized...
                sectionJunctionList = new List<TemplateSectionJunction__c>();
                
                for(TemplateSectionWrapper obj : sectionWrapperList) {
                    obj.templateId = rcTemplateObj.id;
                    
                    TemplateSectionJunction__c juction = new TemplateSectionJunction__c();
                    juction.Position__c = obj.positionIndex;
                    // juction.Id = obj.juctionId;
                    juction.RC_Quote_Template__c = rcTemplateObj.id;
                    juction.Template_Section__c = obj.sectionId; 
                    sectionJunctionList.add(juction);                   
                }
                
                if(!sectionJunctionList.isEmpty()) { 
                    upsert sectionJunctionList;
                }
                addMessage('Template is saved successfully');
                /*
                PageReference page = ApexPages.currentPage();
                page.getParameters().put('id', rcTemplateObj.Id);
                page.setRedirect(true);*/
                // return page;
            } else {
                addMessage('Required fields are missing.');
            }
        } catch(Exception e) {
            addMessage('Template could not be saved');
            system.debug('### ' + e.getMessage() +', LINE NUMBER ' +e.getLinenumber() );
            addMessage('### ' + e.getMessage() +', LINE NUMBER ' +e.getLinenumber() );
        }
        // return null;
    }
    /************************************* Method to Save the Template - Ends **************************************/
    /////////////// PREVIEW FROM TEMPLATE ADD/EDIT PAGE /////////////////////////
    
    /************************************* Method to preview the template - Starts ***********************************
	* @Description - Method to preview the newly creted Template                                                     *
	* @Author      - Simplion Technologies                                                                           * 
	*****************************************************************************************************************/
    public pageReference onPreview(){
        previewWrapperList = new List<TemplateSectionWrapper>();
        previewWrapperList.addAll(sectionWrapperList); 
        system.debug('@@@===> '+previewWrapperList);
        previewId = (previewId == null ? '' : previewId);
        recordtype = (recordtype == null ? 'o' : recordtype);
        if(rcTemplateObj.RC_Quote__c != null) {
            previewId = rcTemplateObj.RC_Quote__c;
            recordtype = 'q';
        }
        String additionalStr = '&quoteid='+rcTemplateObj.RC_Quote__c;
        system.debug('#### additionalStr - '+additionalStr);
        prepareDynamicPreview(previewId);
        
        pageReference viewTemplatePage =  new pageReference('/apex/ViewTemplate?id='+(rcTemplateObj == null ? '' : rcTemplateObj.Id)+additionalStr);
        //viewTemplatePage.setRedirect(true);       
        return viewTemplatePage;
    }
    /************************************* Method to preview the template - Ends ***********************************/
    public class DynamicData {
        public String type {get;set;}
        public List<String> values {get;set;}
        public DynamicData(){}
    }
    Map<String, List<String>> parentToDepencencyMap = new Map<String, List<String>>();
    Map<String, List<String>> parentToQueryFieldsMap = new Map<String, List<String>>();
    Map<String, String> fieldToObjectMap = new Map<String, String>();
    Map<String, String> childToParentMap = new Map<String, String>();
    Map<String, String> objToOrderByFieldMap = new Map<String, String>();
    /******************************************************************************
    * @Description : Method for field Mapping                                     *
    * @Params      : void                                                         *
    * @Return      : String                                                       * 
    ******************************************************************************/
    private List<String> getFieldsMapping() {
        // should be get from custom setting
        // List<String> fieldAPINames = new List<String>();
        List<String> orderList = new List<String>();
        try {
            if( Merge_Fields_Mapping__c.getAll() != null && !(Merge_Fields_Mapping__c.getAll()).isEmpty()){
                String parentName = null;
                for(String thisField : Merge_Fields_Mapping__c.getAll().keyset()){
                    List<String> dependents = new List<String>();
                    Merge_Fields_Mapping__c MergeFieldMapping = Merge_Fields_Mapping__c.getAll().get(thisField);
                    // Order_By__c
                    List<String> children = new List<String>();
                    String child = MergeFieldMapping.Name;
                    String parent = MergeFieldMapping.Dependency__c;//parentToDepencencyMap.get(thisField);
                    childToParentMap.put(child, parent);
                    objToOrderByFieldMap.put(child, MergeFieldMapping.Order_By__c);
                    
                    
                    String fieldToQuery = MergeFieldMapping.Dependent_Relationship_Name__c;
                    
                    fieldToObjectMap.put(child, fieldToQuery);
                    
                    if(parent != null) {
                        if(parentToDepencencyMap.get(parent) != null) {
                            children = parentToDepencencyMap.get(parent);
                            dependents = parentToQueryFieldsMap.get(parent);
                        }
                        children.add(child);
                        parentToDepencencyMap.put(parent, children);
                        
                        if(fieldToQuery != null)
                            dependents.add(fieldToQuery);
                        parentToQueryFieldsMap.put(parent, dependents);
                    }
                    if(parent == null) {
                        parentName = child;
                        fieldToObjectMap.put(child, parentName); // RC_Quote__c, RC_Quote__c
                    }
                    /*
                    if(parentToDepencencyMap.get(thisField) != null) {
                        dependents = parentToDepencencyMap.get(thisField);
                    }
                    if(!String.isBlank(MergeFieldMapping.Dependency__c)) {
                        dependents.add(MergeFieldMapping.Dependency__c);
                    }
                    parentToDepencencyMap.put(thisField, dependents);
                    */
                }
                if(parentName != null) {
                    orderList.add(parentName);
                    orderList = recursive(parentName, parentToDepencencyMap, orderList);
                    /*
                    for(String val : orderList) {
                        addMessage('ORDER LIST = ' + val);
                    }
                    */
                }   
            }
            system.debug(parentToDepencencyMap);
        } catch(Exception exc) {
            system.debug('### ' + exc.getMessage() +', LINE NUMBER ' +exc.getLinenumber() );
            addMessage('### ' + exc.getMessage() +', LINE NUMBER ' +exc.getLinenumber() );  
        }
        return orderList;//List<String>{'Opportunity', 'RC_Quote__c', 'RC_Product__c', 'RC_Product_Line_Item__c', 'Account', 'Contact','Line_Item__c' };
    }
    /******************************************************************************
    * @Description : Recursive Method for field Mapping. This Method has parent  -*
    *                as argument and find its child and so on. It makes a orderd -*
    *                list of all tree relationship.                               * 
    * @Params      : String,Map<String, List<String>>, List<String>               *
    * @Return      : List<String>                                                 * 
    ******************************************************************************/
    private List<String> recursive(String parentObj, Map<String, List<String>> m, List<String> orderList) {
        List<String> children = m.get(parentObj);
        if(children != null) {
            for(String child : children) {
                orderList.add(child);
                recursive(child, m, orderList);
            }
        }
        return orderList;
    }
    /******************************************************************************
    * @Description : Wrapper to hold related obj values                           * 
    ******************************************************************************/
    public class RecordWrapper{ 
        public Set<String> dependentIds{get;set;}
        public Map<String, List<SObject>> objToRecordsMap{get;set;}
        public String opptyId{get;set;}
        public String accountId{get;set;}
        public Map<String, List<String>> additionalFieldToValueMap{get;set;}
    }
    /******************************************************************************
    * @Description : Method to make a specific qurey for objects.                 * 
    * @Params      : Map<String, Set<String>> , Map<String, List<SObject>>        *
    * @Return      : Map<String, List<SObject>>                                   * 
    ******************************************************************************/
    private Map<String, List<SObject>> createSpecificQuery(Map<String, Set<String>> objToFieldsMap, Map<String, List<SObject>> objToRecordsMap) {
        RecordWrapper wrapperObj = new RecordWrapper();
        Set<String> dependentIds = new Set<String>();
        Map<String, List<String>> additionalFieldToValueMap = new Map<String, List<String>>();
        wrapperObj.dependentIds = dependentIds;
        wrapperObj.objToRecordsMap = objToRecordsMap;
        wrapperObj.opptyId = previewId;
        wrapperObj.additionalFieldToValueMap = additionalFieldToValueMap;
        // Get Order List
        List<String> objOrderList = getFieldsMapping();
        Integer counter = 0;
        for(String objName : objOrderList) {
            if(counter++ == 0) {
                additionalFieldToValueMap.put(objName, new List<String>{previewId}); // RC_Quote__c, RecordId
                wrapperObj.additionalFieldToValueMap = additionalFieldToValueMap;
            }
            // wrapperObj = dynamicSoql(objName, (objToFieldsMap.get(objName) == null ? new Set<String>() : objToFieldsMap.get(objName)), wrapperObj);
            wrapperObj = dynamicSoql(objName, (objToFieldsMap.get(objName) == null ? new Set<String>() : objToFieldsMap.get(objName)), wrapperObj, true);
        } 
        /*       
        // RC_Quote__c
        wrapperObj = dynamicSoql('RC_Quote__c', (objToFieldsMap.get('RC_Quote__c') == null ? new Set<String>() : objToFieldsMap.get('RC_Quote__c')), wrapperObj);
        // Opportunity
        wrapperObj = dynamicSoql('Opportunity', (objToFieldsMap.get('Opportunity') == null ? new Set<String>() : objToFieldsMap.get('Opportunity')), wrapperObj);
        // Account
        wrapperObj = dynamicSoql('Account', (objToFieldsMap.get('Account') == null ? new Set<String>() : objToFieldsMap.get('Account')), wrapperObj);
        // Contact
        wrapperObj = dynamicSoql('Contact', (objToFieldsMap.get('Contact') == null ? new Set<String>() : objToFieldsMap.get('Contact')), wrapperObj);
        // Line_Item__c
        wrapperObj = dynamicSoql('Line_Item__c', (objToFieldsMap.get('Line_Item__c') == null ? new Set<String>() : objToFieldsMap.get('Line_Item__c')), wrapperObj);
        // RC_Product_Line_Item__c
        wrapperObj = dynamicSoql('RC_Product_Line_Item__c', (objToFieldsMap.get('RC_Product_Line_Item__c') == null ? new Set<String>() : objToFieldsMap.get('RC_Product_Line_Item__c')), wrapperObj);
        // RC_Product__c
        wrapperObj = dynamicSoql('RC_Product__c', (objToFieldsMap.get('RC_Product__c') == null ? new Set<String>() : objToFieldsMap.get('RC_Product__c')), wrapperObj);
        */
        return wrapperObj.objToRecordsMap;
    }
    /******************************************************************************
    * @Description : Method to make a Dynamic SOQL qurey for particulr object  -  *
    * 				 whose name is given in argument                              *
    * @Params      : String, Set<String>, RecordWrapper, Boolean                  *
    * @Return      : RecordWrapper                                                * 
    ******************************************************************************/
    private RecordWrapper dynamicSoql(String objName, Set<String> fieldList, RecordWrapper wrapperObj, Boolean isCustomSettingAvailable) {
        if(fieldList == null) {
            return wrapperObj;
        }
        List<String> recordIds = new List<String>();
        if(objName.equalsIgnoreCase(objName)) {
            List<String> additionalFields = parentToQueryFieldsMap.get(objName);
            if(additionalFields != null) {
                fieldList.addAll(additionalFields);
            }
            // wrapperObj.additionalFieldToValueMap.get(fieldToObjectMap.get(objName)) 
            String apiName = null;
            if(fieldToObjectMap.get(objName) != null) {
                apiName = fieldToObjectMap.get(objName); // RC_Quote__c, OpportunityId, AccountId
            } else {
                apiName = childToParentMap.get(objName); // childToParentMap
            }
            if(apiName != null && wrapperObj.additionalFieldToValueMap != null && wrapperObj.additionalFieldToValueMap.get(apiName) != null) {
                recordIds.addAll(wrapperObj.additionalFieldToValueMap.get(apiName));
            }
            String queryStr = '';
            String orderBy = '';
            if(objToOrderByFieldMap != null && objToOrderByFieldMap.get(objName) != null)
                orderBy = 'ORDER BY '+ objToOrderByFieldMap.get(objName) +' ASC';
            if(objName == 'Opportunity') // Adding a unique case to populate Oppty Brand
                fieldList.add('Brand_Name__c');
            if(recordIds.size() == 0)
                return wrapperObj;
            if(fieldToObjectMap.get(objName) == null) {
                system.debug('#### objName - '+objName);
                queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ' WHERE '+apiName+' IN: recordIds ' + orderBy;
            } else {
                system.debug('#### recordIds - '+recordIds);
                system.debug('#### objName - '+objName);
                /*
                else if(recordIds.size() == 1) {
                    queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ' WHERE Id=\''+ recordIds.get(0) +'\' ';
                } else {
                */
                queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ' WHERE Id IN: recordIds '+ orderBy;
                        // + (objName.equalsIgnoreCase('RC_Product_Line_Item__c') ? ' ORDER BY ') 
            }
            // String queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ' WHERE Id=\''+ previewId +'\' ';
            /*
            addMessage(queryStr);
            for(String rc : recordIds)
                addMessage('##### QUERY FOR '+ rc+ ' #####');
                */
            try {
                List<SObject> sObjList = Database.query(queryStr);
                Map<String, List<String>> additionalFieldToValueMap = new Map<String, List<String>>();
                List<SObject> sortedListPerIds = new List<SObject>();
                try {
                    
                    for(String strId : recordIds) {
                        for(SObject obj : sObjList) {
                            String idValue = String.valueOf(obj.get('Id'));
                            if(idValue != null && idValue.containsIgnoreCase(strId)) {
                                sortedListPerIds.add(obj);
                                break;
                            } 
                        }
                    }
                } catch(Exception ext) { addMessage('## EXC ON ORDERING ' + ext.getMessage());}
                // addMessage('##### sortedListPerIds SIZE = '+ sortedListPerIds.size()+ ' #####');
                if(sortedListPerIds.size() == 0) {
                    system.debug('@@@============== sObjList ----------> '+sObjList);
                    sortedListPerIds = sObjList;
                }
                
                for(SObject obj : sortedListPerIds) {
                    system.debug('@@@============== sortedListPerIds ----------> '+sortedListPerIds);
                    // addMessage(' No Of Recods ' + String.valueOf(obj.get('Id')) + ', For OBJECT = ' + objName);
                    if(objName == 'Opportunity') {
                        oppObj = (Opportunity) obj;
                    }
                    try {
	                    if(objName == 'RC_Quote__c') {
	                    	String strVal = String.valueOf(obj.get('Renewal_Term__c') != null ? obj.get('Renewal_Term__c') : null);
	                    	if(!String.isBlank(strVal) && strVal == '0')
	                    	obj.put('Renewal_Term__c', null);
	                    }
                    } catch(Exception exc) {}
                    if(additionalFields != null) {
                        for(String addField : additionalFields) {
                            List<String> records = new List<String>();
                            if(obj.get(addField) != null) {
                                String strValue = String.valueOf(obj.get(addField));
                                if(additionalFieldToValueMap.get(addField) != null) {
                                    records = additionalFieldToValueMap.get(addField);
                                }
                                records.add(strValue);
                                // addMessage(' ADDITIONAL FIELD ' + addField + ', VALUE = ' + strValue);
                                additionalFieldToValueMap.put(addField, records);
                            } 
                            /*
                            else {
                                additionalFieldToValueMap.put(addField, null);
                            }
                            */
                            wrapperObj.additionalFieldToValueMap.putAll(additionalFieldToValueMap);
                        }
                    }
                }
                if(wrapperObj.objToRecordsMap.containsKey(objName))
                    wrapperObj.objToRecordsMap.put(objName, sortedListPerIds);
                    
                    system.debug('#### wrapperObj - '+wrapperObj);
            } catch(Exception ex) {addMessage(ex.getMessage());}
        }
        return wrapperObj;
    }
    /* DEPRECATED NOW
    private RecordWrapper dynamicSoql(String objName, Set<String> fieldList, RecordWrapper wrapperObj) {
        // String strQuery = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ( objName.containsIgnoreCase('oppo') ? ' WHERE Id=\''+ previewId +'\' LIMIT 1 ' : ' LIMIT 5')+ '';
        if(fieldList == null) {
            return wrapperObj;
        }
        // addMessage('OBJ NAME '+ objName +' ### FIELD SIZE = '+ fieldList.size());
        if(objName.equalsIgnoreCase('RC_Quote__c') && recordType == 'q') {
            // if(recordType == 'q') {
                fieldList.add('Opportunity__c');
            // }
            String queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ' WHERE Id=\''+ previewId +'\' LIMIT 1';
            addMessage(queryStr);
            try {
            List<SObject> sObjList = Database.query(queryStr);
            for(SObject obj : sObjList) {
                if(obj.get('Opportunity__c') != null)
                    wrapperObj.opptyId = String.valueOf(obj.get('Opportunity__c'));
            }
            if(wrapperObj.objToRecordsMap.containsKey(objName))
                wrapperObj.objToRecordsMap.put(objName, sObjList);
            } catch(Exception ex) {addMessage(ex.getMessage());}
        }
        if(objName.equalsIgnoreCase('Opportunity')) {
            fieldList.add('AccountId');
            String queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ' WHERE Id=\''+ (recordType == 'q' ? wrapperObj.opptyId : previewId) +'\' LIMIT 1';
            addMessage(queryStr);
            List<SObject> sObjList = Database.query(queryStr);
            for(SObject obj : sObjList) {
                if(obj.get('AccountId') != null)
                    wrapperObj.accountId = String.valueOf(obj.get('AccountId'));
            }
            if(wrapperObj.objToRecordsMap.containsKey(objName))
                wrapperObj.objToRecordsMap.put(objName, sObjList);
        }
        if(objName.equalsIgnoreCase('Account')) {
            system.debug('#### objName - ' + objName);
            String queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ' WHERE Id=\''+ (wrapperObj.accountId != null ? wrapperObj.accountId : '') +'\' LIMIT 1';
            system.debug('#### queryStr - ' + queryStr);
            List<SObject> sObjList = Database.query(queryStr);
            if(wrapperObj.objToRecordsMap.containsKey(objName))
                wrapperObj.objToRecordsMap.put(objName, sObjList);
        }
        if(objName.equalsIgnoreCase('Contact')) {
            String queryStr = 'SELECT Id,Contact__c,Contact__r.Name,Contact__r.Email FROM RC_Quote__c WHERE Id=\''+ previewId +'\' ';
            addMessage(queryStr);
            List<SObject> sObjList = Database.query(queryStr);
            if(sObjList != null && sObjList.size() != 0) {
                String contactRoleId = String.valueOf(sObjList.get(0).get('Contact__c'));
                if(contactRoleId != null) {
                    queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ' WHERE Id=\''+ contactRoleId +'\' LIMIT 1';
                    sObjList = Database.query(queryStr);
                }
            }
            if(wrapperObj.objToRecordsMap.containsKey(objName))
                wrapperObj.objToRecordsMap.put(objName, sObjList);
        }
        if(objName.equalsIgnoreCase('Line_Item__c')) {
            fieldList.add('RC_Product_Line_Item__c');
            String whereText = (recordType == 'o' ?' WHERE Opportunity__c=\''+ previewId +'\' ' :' WHERE RC_Quote__c=\''+ previewId +'\' ');
            String queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + whereText;
            addMessage(queryStr);
            List<SObject> sObjList = Database.query(queryStr);
            wrapperObj.dependentIds = new Set<String>();
            for(SObject obj : sObjList) {
                if(obj.get('RC_Product_Line_Item__c') != null)
                    wrapperObj.dependentIds.add( String.valueOf(obj.get('RC_Product_Line_Item__c')));
            }
            if(wrapperObj.objToRecordsMap.containsKey(objName))
                wrapperObj.objToRecordsMap.put(objName, sObjList);
        }
        if(objName.equalsIgnoreCase('RC_Product_Line_Item__c')) {
            fieldList.add('RC_Product__c');
            Set<String> dependentIds = wrapperObj.dependentIds;
            String whereText = ' WHERE Id IN: dependentIds';
            String queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + whereText;
            List<SObject> sObjList = Database.query(queryStr);
            addMessage(queryStr);
            wrapperObj.dependentIds = new Set<String>();
            for(SObject obj : sObjList) {
                if(obj.get('RC_Product__c') != null)
                    wrapperObj.dependentIds.add( String.valueOf(obj.get('RC_Product__c')));
            }
            if(wrapperObj.objToRecordsMap.containsKey(objName))
                wrapperObj.objToRecordsMap.put(objName, sObjList);
        }
        if(objName.equalsIgnoreCase('RC_Product__c')) {
            Set<String> dependentIds = wrapperObj.dependentIds;
            String whereText = ' WHERE Id IN: dependentIds';
            String queryStr = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + whereText;
            addMessage(queryStr);
            List<SObject> sObjList = Database.query(queryStr);
            if(wrapperObj.objToRecordsMap.containsKey(objName))
                wrapperObj.objToRecordsMap.put(objName, sObjList);
        }
        return wrapperObj; 
    }
    */
    /******************************************************************************
    * @Description : Method to make a Dynamic Preview for a template, without  -  *
    *                actually saving it to database.                              * 
    * @Params      : String                                                       *
    * @Return      : void                                                         * 
    ******************************************************************************/
    //-------------------As/simplion/8/12/2014---------------------------------------------------------
    //-------------------Method to create formated currency value start--------------------------------
    public String createFromatedCurrency(Decimal inputNumber){
    Map<Integer,String> tokens = new Map<Integer,String>();
    String result = '';
    String third = '';
    //------------------Seperating value after point---------------------------------------------------
    String pointValue = String.valueOf(inputNumber).split('\\.')[1];
    //------------------Seperating value before point--------------------------------------------------
    String numberString = String.valueOf(inputNumber.intValue());
    	if(numberString.length() >= 3){
				String token = numberString.substring(numberString.length()-3,numberString.length());
				numberString = numberString.substring(0,numberString.length()-3);
				third =  token;
		}
    	Integer count =0;
		/*while(numberString.length()>0){
			if(numberString.length() >2){
            	String token = numberString.subString(numberString.length()-2,numberString.length());	
            	tokens.put(++count,token);
            	numberString = numberString.subString(0,numberString.length()-2);
      		}else if(numberString.length() == 2){
          		String token = numberString;
          		tokens.put(++count,token);
          		numberString = '';
      		}else if(numberString.length() == 1){
         		 String token = numberString;
         		 tokens.put(++count,token);
         		 numberString = '';
			}
		}*/
		while(numberString.length()>0){
			if(numberString.length() >3){
            	String token = numberString.subString(numberString.length()-3,numberString.length());	
            	tokens.put(++count,token);
            	numberString = numberString.subString(0,numberString.length()-3);
      		} else if(numberString.length() == 3) {
          		String token = numberString;
          		tokens.put(++count,token);
          		numberString = '';
      		} else if(numberString.length() == 2) {
          		String token = numberString;
          		tokens.put(++count,token);
          		numberString = '';
      		} else if(numberString.length() == 1) {
         		 String token = numberString;
         		 tokens.put(++count,token);
         		 numberString = '';
			}
		}
		for(Integer i= tokens.size();i >= 1;i--){
        	result = result+tokens.get(i)+',';
		}
		if(third.length() == 3){
	    	result = result+third;    
	    }else{
	        result =result.subString(0,result.length()-1);
	    }
			return result+'.'+pointValue;
	}
	//-------------------Method to create formated currency value ends--------------------------------
    public void prepareDynamicPreview(String previewId) {
        // Map<String, String> childToParentMap = getFieldsMapping();
        //addMessage('ID INSIDE = ' + previewId);
        Map<String, DynamicData> placesToRemoveMap = new Map<String, DynamicData>(); 
        Map<String, Set<String>> objToFieldsMap = new Map<String, Set<String>>();
        ////////////////////////// Code to get dynamic variables added in section ///////////////////////////////////////////////////////////
        try {
        for(TemplateSectionWrapper section : previewWrapperList) {
            String text = section.content;
            system.debug('@@@ text ==> '+text);
            //String text = 'This 123 is my place where I can work {!Obj.Name} and to show the progress {!obj.email}. so whats are your thoughts.';
            String matchingExpression = '(\\{)(!)(.*?)(\\})';   // Matching Expression
            pattern patternObj = pattern.compile(matchingExpression);
            Matcher matcherObj = patternObj.matcher(text);
            
            while(matcherObj.find()) {
                String key1 = matcherObj.group();
                String key3 = matcherObj.group(3);
                 system.debug('@@@ key3 ==> '+key3);
                if(key3 != null && key3.indexOf('.') != -1) {
                    Set<String> fieldList = new Set<String>();
                    String objName = key3.substring(0,key3.indexOf('.'));
                    String fieldName = key3.substring(key3.indexOf('.')+1, key3.length());
                    if(objToFieldsMap.get(objName) != null) {
                        fieldList = objToFieldsMap.get(objName); 
                    }
                    fieldList.add(fieldName);
                    // addMessage('WORKING : ' + objName);
                    objToFieldsMap.put(objName, fieldList);
                }
                
                /* 
                This will fetch {!Obj.Name},{!obj.email} from the sample text commented above.
                To get value without braces, ie., Obj.Name,obj.email, use matcherObj.group(3);
                The 3rd group will contain that value, can be used to create query dynamically.
                 */
                placesToRemoveMap.put(key1, null);
                // addMessage('PARAMETERS : ' + key3 );
            }
        }
        } catch(Exception ex) {
            system.debug('### ' + ex.getMessage() +', LINE NUMBER ' +ex.getLinenumber() );
            addMessage('### ' + ex.getMessage() +', LINE NUMBER ' +ex.getLinenumber() );
        }
        ////////////////////// code to query obj/fields added in section  ////////////////////////////////////
        Map<String, String> objToQueryMap = new Map<String, String>();
        Map<String, List<SObject>> objToRecordsMap = new Map<String, List<SObject>>();
        for(String objName : objToFieldsMap.keySet()) {
            //objToRecordsMap.put(objName, null);
            objToRecordsMap.put(objName, new List<SObject>());
        }
        /*
        if(objToFieldsMap != null && objToFieldsMap.size() != 0) {
            List<String> queries = new List<String>();
            for(String objName : objToFieldsMap.keySet()) {
                Set<String> fieldList = objToFieldsMap.get(objName);
                if(fieldList != null) {
                    String strQuery = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ( objName.containsIgnoreCase('oppo') ? ' WHERE Id=\''+ previewId +'\' LIMIT 1 ' : ' LIMIT 5')+ '';
                    addMessage('QUERY : ' + strQuery);
                    objToQueryMap.put(objName, strQuery);
                    queries.add(strQuery);
                }
            }
            for(String objName : objToQueryMap.keySet()) {
                String queryStr = objToQueryMap.get(objName);
                // addMessage('OBJECT : ' + objName + '\n QUERY= '+ queryStr);
                try {
                    List<SObject> sObjList = Database.query(queryStr);
                    objToRecordsMap.put(objName, sObjList);
                } catch(Exception ex) {
                    addMessage('EXCEPTION ON EXECUTION : ' + ex.getMessage());
                }
            }
        }
        */
        try {
            objToRecordsMap = createSpecificQuery(objToFieldsMap, objToRecordsMap);
        } catch(Exception ex1) {system.debug('LINE NUMBER + '+ ex1.getLineNumber()+'\nEXCEPTION ON QUERIES: ' + ex1.getMessage());
            addMessage('LINE NUMBER + '+ ex1.getLineNumber()+'\nEXCEPTION ON QUERIES: ' + ex1.getMessage());
        }
        
        ////////////////////////////////////// logic to prepare format the added fields with queried records ///////////////////////////////////
        Map<String, List<String>> objNameAndFieldWithValueMap = new Map<String, List<String>>();
        try {
            system.debug('----> objToRecordsMap.keySet ==> '+objToRecordsMap.keySet());
            system.debug('----> objToRecordsMap ==> '+objToRecordsMap);
            
            /*****For Currency Sign***************/
	    	Map<String,Map<String, Schema.SObjectField>> sObjectFieldMap = new Map<String,Map<String, Schema.SObjectField>>();
	    	for(String objName : objToRecordsMap.keySet()) {
	    		List<SObject> sObjList = objToRecordsMap.get(objName);
	    		if(sObjList!=null && sObjList.size() > 0){
		    		Schema.sObjectType sobject_type = sObjList[0].getSObjectType();
					Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
					Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();	
					sObjectFieldMap.put(objName,field_map);
	    		}
	    	}
    		/*****End of For Currency Sign***************/
    		
        for(String objName : objToRecordsMap.keySet()) {
            List<SObject> sObjList = objToRecordsMap.get(objName);
            if(sObjList != null) {
                Set<String> fieldsName = objToFieldsMap.get(objName);// getObjFieldsName(objName, objToFieldsMap.get(objName));
                for(String fieldName : fieldsName) {
                    // addMessage('\n\n');
                    for(SObject sObj : sObjList) {
                        List<String> records = new List<String>();
                        String key = '{!'+objName + '.' + fieldName + '}';
                        //String value = String.valueOf(sObj.get(fieldName));
                        
                        /*****For Currency Sign***************/	
						String value=''; 				
						if(sObjectFieldMap!=null && sObjectFieldMap.get(objName)!=null && sObjectFieldMap.get(objName).get(fieldName)!=null && 
							String.valueOf(sObjectFieldMap.get(objName).get(fieldName).getDescribe().getType())=='CURRENCY'){
							String currencySign = '';
							if((oppObj.CurrencyIsoCode=='USD') || (oppObj.CurrencyIsoCode=='CAD')){
								currencySign = '$';
							}else if(oppObj.CurrencyIsoCode=='GBP'){
								currencySign = '&pound;';
							}
							//-------------------------As/Simplion/7/23/2014-----------------------------------
							//------------------------Code fix for null currency field-------------------------
							Decimal tempAmount = sObj.get(fieldName) == null  ? 0.00 : ((Decimal)sObj.get(fieldName)).setScale(2);
							// Double tempAmount = sObj.get(fieldName) == null  ? 0.0 : (Double)sObj.get(fieldName);
							
							value = currencySign + createFromatedCurrency(tempAmount);
						}else{
							//-------------------------As/Simplion/8/20/2014-----------------------------------
							if(fieldName == 'Initial_Term__c' || fieldName == 'Renewal_Term__c'){
	                        	if(!String.isBlank((String)sObj.get(fieldName)))
	                        		value = String.valueOf(sObj.get(fieldName))+' Months';
	                        	
	                        }
	                        else{
	                        	value = String.valueOf(sObj.get(fieldName));
	                        }
	                        //-------------------------As/Simplion/8/20/2014-----------------------------------							
						}
						/*****End of For Currency Sign***************/
						
                        // addMessage('Key: ' +key + ', value: ' + value);
                        if(objNameAndFieldWithValueMap.get(key) != null) {
                            records = objNameAndFieldWithValueMap.get(key);
                        }
                        records.add(value);
                        objNameAndFieldWithValueMap.put(key, records);
                    }
                }
            } 
        }
        system.debug('@@@ objNameAndFieldWithValueMap ==> '+objNameAndFieldWithValueMap);
        } catch(Exception ex) {
            system.debug('### ' + ex.getMessage() +', LINE NUMBER ' +ex.getLinenumber() );
            addMessage('### ' + ex.getMessage() +', LINE NUMBER ' +ex.getLinenumber() );
        }
        ////////////////////////////////////// logic to replace the added fields with queried records ////////////////////////////////////////////
        try {
        for(TemplateSectionWrapper section : previewWrapperList) {
            Set<String> fieldList = new Set<String>();
            String text = section.content;
            //String text = 'This 123 is my place where I can work {!Obj.Name} and to show the progress {!obj.email}. so whats are your thoughts.';
            String matchingExpression = '(\\{)(!)(.*?)(\\})';   // Matching Expression
            pattern patternObj = pattern.compile(matchingExpression);
            Matcher matcherObj = patternObj.matcher(text);
            
            while(matcherObj.find()) {
                String key1 = matcherObj.group(); 
                String key3 = matcherObj.group(3);
                if(key1 != null) {
                    if(objNameAndFieldWithValueMap.get(key1) != null)  {
                        // addMessage(section.content);
                        // addMessage('\n\n\nkey1= '+ key1+', REPLACING STR = ' + objNameAndFieldWithValueMap.get(key1)[0]);
                        String textStr = section.content;
                        String replaceWithStr = objNameAndFieldWithValueMap.get(key1)[0];
                        try {
                            if(objNameAndFieldWithValueMap.get(key1).size() > 1) {
                                String tblStr = '<table cellpadding="0" cellspacing="0" style="width:100%;border:0px solid white;">';
                                Integer counter = 0;
                                for(String cStr : objNameAndFieldWithValueMap.get(key1)) {
                                    tblStr +='<tr '+ (Math.mod(++counter, 2) == 0 ? 'style="background:#F5F4F4;"' : '')+'><td style="height:50px;vertical-align:top;width:100%;">'+ (String.isBlank(cStr) ? '' : cStr) +'</td></tr>';
                                }
                                tblStr +='</table>';
                                replaceWithStr = tblStr;
                                /*
                                String tblStr = '';
                                for(String cStr : objNameAndFieldWithValueMap.get(key1)) {
                                    tblStr +=''+(String.isBlank(cStr) ? '' : cStr) +'<BR/>';
                                }
                                replaceWithStr = tblStr;
                                */
                            }
                            // <tr><td>Office Entry - Annual</td></tr> 
                            try {
                                if(!String.isBlank(replaceWithStr)) {
                                    replaceWithStr = String.valueOf(Datetime.valueOf(replaceWithStr).date().format());
                                }
                            } catch(Exception ex2) {}
                            
                            section.content = textStr.replace(key1, (String.isBlank(replaceWithStr) ? '' : replaceWithStr));
                        } catch(Exception e) {
                            system.debug('### ' + e.getMessage() +', LINE NUMBER ' +e.getLinenumber() );
                            addMessage('### ' + e.getMessage() +', LINE NUMBER ' +e.getLinenumber() );
                        }
                        // section.content = matcherObj.replaceAll(objNameAndFieldWithValueMap.get(key1)[0]);
                    } else {
                        String textStr = section.content;
                        section.content = textStr.replace(key1, '');
                    }
                }
            }
        }
        } catch(Exception ex) {
            system.debug('### ' + ex.getMessage() +', LINE NUMBER ' +ex.getLinenumber() );
            addMessage('### ' + ex.getMessage() +', LINE NUMBER ' +ex.getLinenumber() );
        }
    }
    
    
    /*
    private List<String> getObjFieldsName(String objName, Set<String> fieldsAdded) {
        List<String> fieldsName = new List<String>();
        SObjectType objToken = Schema.getGlobalDescribe().get(objName);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        
        Set<String> fieldSet = fields.keySet();
        for(String s:fieldSet) {
            if(fieldsAdded.contains(s)) {
                SObjectField fieldToken = fields.get(s);
                DescribeFieldResult selectedField = fieldToken.getDescribe();
                fieldsName.add(selectedField.getName());
                addMessage('FIELD = '+s+', VALUE : ' + selectedField.getName());
            }
        }
        return fieldsName;
    }
    */
    /******************************************************************************
    * @Description : Method to mske a query                                       * 
    * @Params      : Set<String>                                                  *
    * @Return      : String                                                       * 
    ******************************************************************************/
    private String prepareQuery(Set<String> fieldList) {
        String str = '';
        if(fieldList == null || fieldList.size() == 0)
            return str;
        for(String fieldStr : fieldList) {
            str +=',' + fieldStr;
        }
        return str;
    }
    
    /******************************************************************************
    * @Description : Below code is for adding Template section. It has wrapper -  *
    *                class, methods.                                              *
    * @Params      : Set<String>                                                  *
    * @Return      : String                                                       * 
    ******************************************************************************/
    public List<TemplateSectionWrapper> sectionWrapperList{get;set;}
    public class TemplateSectionWrapper {
        public String juctionId {get;set;}
        public String templateId {get;set;}
        public String sectionId {get;set;}
        public String sectionName {get;set;}
        public Integer positionIndex{get;set;}
        public String content {get;set;}
        public TemplateSectionWrapper() {}
    }
    private String prepareContent(TemplateSections__c section) {
        return (section.Content_1__c == null ? '' : section.Content_1__c)+''
                +(section.Content_2__c == null ? '' : section.Content_2__c)+''
                +(section.Content_3__c == null ? '' : section.Content_3__c)+''
                +(section.Content_4__c == null ? '' : section.Content_4__c)+''
                +(section.Content_5__c == null ? '' : section.Content_5__c);
    }
    public PageReference addTemplateSection() {
        addSection = true;
        if(!String.isBlank(selectedSection) && sectionMap != null) {
            TemplateSections__c section = sectionMap.get(selectedSection);
            if(section != null) {
                position = (position == null ? 1 : position);
                List<TemplateSectionWrapper> refreshedList = new List<TemplateSectionWrapper>();
                if(position != null) {
                    if(sectionWrapperList != null && sectionWrapperList.size() != 0) {
                        Integer counter = 1;
                         for(TemplateSectionWrapper obj : sectionWrapperList) {
                            // addMessage('## POSITION = ' + position + ', INDEX ' + obj.positionIndex);
                            if(position >= obj.positionIndex ) {
                                refreshedList.add(obj);
                                if(counter == 1) {
                                    TemplateSectionWrapper objNew = new TemplateSectionWrapper();
                                    objNew.positionIndex = position;
                                    objNew.content = prepareContent(section);
                                    objNew.sectionId = section.Id;
                                    objNew.sectionName = section.Name;
                                    refreshedList.add(objNew);
                                    ++counter;
                                }
                            } else {
                                if(counter == 1) {
                                    TemplateSectionWrapper objNew = new TemplateSectionWrapper();
                                    objNew.positionIndex = position;
                                    objNew.content = prepareContent(section);
                                    objNew.sectionId = section.Id;
                                    objNew.sectionName = section.Name;
                                    refreshedList.add(objNew);
                                    ++counter;
                                }
                                refreshedList.add(obj);
                            }
                        }
                    } else {
                        TemplateSectionWrapper objNew = new TemplateSectionWrapper();
                        objNew.positionIndex = position;
                        objNew.content = prepareContent(section);
                        objNew.sectionId = section.Id;
                        objNew.sectionName = section.Name;
                        refreshedList.add(objNew);
                    }
                }
                if(refreshedList != null && refreshedList.size() != 0) {
                    sectionWrapperList = new List<TemplateSectionWrapper>();
                    sectionWrapperList.addAll(refreshedList);
                }
                /////////////////////////////////////////////////
                /*
                TemplateSectionWrapper obj = new TemplateSectionWrapper();
                obj.positionIndex = position;
                obj.content = prepareContent(section);
                obj.sectionId = section.Id;
                sectionWrapperList.add(obj);
                */
            }
        }
        addMessage('Total sections added: '+ sectionWrapperList.size());
        return null;
    }
    public String removalSectionId {get;set;}
    public Integer currentIndex {get;set;}
    public Pagereference deleteTemplateSection() {
        system.debug('######## ' + currentIndex);
        /*
        if(removalSectionId != null) {
            List<TemplateSectionWrapper> refreshedList = new List<TemplateSectionWrapper>();
            for(TemplateSectionWrapper obj : sectionWrapperList) {
                if(obj.sectionId != removalSectionId) {
                    refreshedList.add(obj);
                }
            }
            sectionWrapperList.clear();
            sectionWrapperList.addAll(refreshedList);
        }
        */
        if(currentIndex != null && sectionWrapperList.size() != 0 && sectionWrapperList.size() > currentIndex) {
            sectionWrapperList.remove(currentIndex);
        }
        previewWrapperList = sectionWrapperList;
        addMessage('Total Sections: '+ sectionWrapperList.size());
        return null;
    }
    
    /******************************************************************************
    * @Description : Method to create dynamic nested query.                       *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/   
    /* BACKUP METHOD FOR DYNAMIC CODE  
    public String createQueryDynamically(Map<String, Set<String>> objToFieldsMap){
        
        Set<String> fieldsToQuery = new Set<String>();
        Set<String> nestedFieldsToQuery = new Set<String>();
        String soqlQueryString;
        String nestedSoqlQueryString;
        try{
            for(String thisString : objToFieldsMap.keySet()){
                if(thisString.equalsIgnoreCase('Line_Item__c') || 
                   thisString.equalsIgnoreCase('RC_Product_Line_Item__c') || 
                   thisString.equalsIgnoreCase('RC_Product__c') ||
                   (thisString.equalsIgnoreCase('RC_Quote__c') && recordType != 'q')){
                    
                    nestedFieldsToQuery.addAll(createSoqlQuery(thisString,objToFieldsMap.get(thisString)));
                }else{
                    fieldsToQuery.addAll(createSoqlQuery(thisString,objToFieldsMap.get(thisString)));
                }       
            }   
            
            if(nestedFieldsToQuery != null || nestedFieldsToQuery.size() > 0){
                nestedSoqlQueryString = '(SELECT Id ' + prepareQuery(nestedFieldsToQuery) + ' FROM LineItem)';      
            }
            if(fieldsToQuery != null || fieldsToQuery.size() > 0){
                soqlQueryString = 'SELECT Id ' + prepareQuery(fieldsToQuery) + nestedSoqlQueryString +' FROM Opportunity WHERE Id=\''+ previewId +'\' LIMIT 1';     
            }
            system.debug('#### soqlQueryString - '+soqlQueryString);
        }catch (Exception ex){
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());  
        }
        //return null;
        return soqlQueryString;     
    }
    */
    /******************************************************************************
    * @Description : Method to create dynamic query.                              *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/     
    /* BACKUP METHOD FOR DYNAMIC CODE  
    public Set<String> createSoqlQuery(String objName, Set<String> fieldList){
        //String queryString = 'SELECT Id ' + prepareQuery(fieldList) + ' FROM ' + objName + ' WHERE Id=\''+ previewId +'\' LIMIT 1';
        Set<String> mainFieldList = new Set<String>();
        system.debug('#### RC Quote Id - '+ rcTemplateObj.RC_Quote__c);
        system.debug('#### - '+ rcTemplateObj.RC_Quote__c.getSObjectType());
        system.debug('#### - '+ rcTemplateObj.RC_Quote__c.getSObjectType().getDescribe());
        system.debug('#### - '+ rcTemplateObj.RC_Quote__c.getSObjectType().getDescribe().getName());
        try{
            for(String thisField : fieldList){
                if(objName.equalsIgnoreCase('Account')){
                    Schema.DescribeFieldResult f = Schema.sObjectType.Opportunity.fields.AccountId;
                    System.debug('#### Relationship Name - '+f.getRelationshipName());
                    mainFieldList.add(recordType == 'q' ? 'Opportunity__r.' : '' + f.getRelationshipName()+'.'+thisField);
                }
                if(objName.equalsIgnoreCase('Contact')){
                    Schema.DescribeFieldResult f = Schema.sObjectType.Opportunity.fields.Primary_Opportunity_Contact__c;
                    System.debug('#### Relationship Name - '+f.getRelationshipName());
                    mainFieldList.add(recordType == 'q' ? 'Opportunity__r.' : '' + f.getRelationshipName()+'.'+thisField);
                }
                if(objName.equalsIgnoreCase('Opportunity')){
                    mainFieldList.add(recordType == 'q' ? 'Opportunity__r.' : '' + thisField);
                }
                if(objName.equalsIgnoreCase('RC_Quote__c')){
                    if(recordType == 'q'){
                        mainFieldList.add(''+thisField);    
                    }else{
                        mainFieldList = createNestedSoqlQuery(objName, fieldList);
                    }
                }
                if(objName.equalsIgnoreCase('Line_Item__c')){
                    mainFieldList = createNestedSoqlQuery(objName, fieldList);
                }
                if(objName.equalsIgnoreCase('RC_Product_Line_Item__c')){
                    mainFieldList = createNestedSoqlQuery(objName, fieldList);
                }
                if(objName.equalsIgnoreCase('RC_Product__c')){
                    mainFieldList = createNestedSoqlQuery(objName, fieldList);
                }
            }
        }catch (Exception ex){
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());  
        }
        return mainFieldList;
    }
    */
    /******************************************************************************
    * @Description : Method to create dynamic nested query.                       *
    * @Params      : void                                                         *
    * @Return      : void                                                         * 
    ******************************************************************************/     
    /* BACKUP METHOD FOR DYNAMIC CODE  
    public Set<String> createNestedSoqlQuery(String objName, Set<String> nestedFieldList){
        Set<String> fieldList = new Set<String>();
        try{
            for(String thisField : nestedFieldList){
                if(objName.equalsIgnoreCase('RC_Quote__c')){
                    fieldList.add('Opportunity__c');
                    Schema.DescribeFieldResult f = Schema.sObjectType.Line_Item__c.fields.RC_Quote__c;
                    System.debug('#### Relationship Name - '+f.getRelationshipName());
                    fieldList.add(f.getRelationshipName()+'.'+thisField);
                }
                if(objName.equalsIgnoreCase('RC_Product_Line_Item__c')){
                    fieldList.add('RC_Product__c');
                    Schema.DescribeFieldResult f = Schema.sObjectType.Line_Item__c.fields.RC_Product_Line_Item__c;
                    System.debug('#### Relationship Name - '+f.getRelationshipName());
                    fieldList.add(f.getRelationshipName()+'.'+thisField);
                }
                if(objName.equalsIgnoreCase('Line_Item__c')){
                    fieldList.addAll(nestedFieldList);
                }
            }   
        // String nestedQueryString = '(SELECT Id ' + prepareQuery(fieldList) + ' FROM Line_Item__c)';
        // return nestedQueryString;
        }catch (Exception ex){
            system.debug('#### Error on line - '+ex.getLineNumber());
            system.debug('#### Error message - '+ex.getMessage());  
        }
        return fieldList;
    }
    */
}