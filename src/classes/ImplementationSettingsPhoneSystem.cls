/**************************************************************************************************
* Project Name..........: Implementation                                                          *
* File..................: ImplementationSettingsPhoneSystem                                       *
* Version...............: 1.0                                                                     *
* Created by............: Simplion Technologies                                                   *
* Created Date..........: 26-06-2014                                                              *
* Last Modified by......: Simplion Technologies                                                   *
* Last Modified Date....: 26-06-2014                                                              *
* Description...........: This class is used for inline ImplementationSettingsPhoneSystem VF page *
**************************************************************************************************/

public class ImplementationSettingsPhoneSystem {
    
    // Declaring Variables
    public List<SelectOption> lstAccountReviewOptions{get;set;}
    public List<SelectOption> lstAUserOptions{get;set;}
    public List<SelectOption> companyNumbersInfoOptions{get;set;}
    public List<SelectOption> groupsOptions{get;set;}
    public List<SelectOption> phonesDevicesOptions{get;set;}
    public List<SelectOption> toolsOptions{get;set;}
 
    public List<String> accountReviewsList{get;set;}
    public List<String> usersList{get;set;} 
    public List<String> companyNumbersInfoList{get;set;}
    public List<String> groupsList{get;set;}
    public List<String> phonesDevicesList{get;set;}
    public List<String> toolsInfoList{get;set;}
    
    public String strEdit{get;set;}
    public String strDisabled{get;set;}
    public Boolean isDisplay {get;set;}
    public Boolean isDisabled{get;set;}
    public Implementation__c objImplementation{get;set;}
    public Implementation__c implementationObj {get;set;}
    /* 
    public String accountReviewsList{get;set;}
    public String usersList{get;set;} 
    public String companyNumbersInfoList{get;set;}
   
    public String groupsList{get;set;}
    public String phonesDevicesList{get;set;}
    public String toolsInfoList{get;set;}
    */
    
    /**********************************************************************************************
    * @Description : ImplementationSettingsPhoneSystem Constructor used for,initialization and    *
    *                Assignment of existing values.                                               *
    * @Params      : ApexPages.StandardController                                                 *
    * @Return      : none                                                                         * 
    **********************************************************************************************/
    public ImplementationSettingsPhoneSystem(ApexPages.StandardController controller){
        
        try{
            isDisabled = true;
            isDisplay = true ;           
            strDisabled = 'Disabled';
            objImplementation = new Implementation__c();
            objImplementation = (Implementation__c)controller.getRecord();
            ApexPages.currentPage().getParameters().get('Test');
            accountReviewsList = new List<String>();
            usersList = new List<String>();
            companyNumbersInfoList = new List<String>();
            groupsList = new List<String>();
            phonesDevicesList = new List<String>();
            toolsInfoList = new List<String>();
             
            lstAccountReviewOptions = getPicklistValues(objImplementation, 'Account_Review__c');
            //lstAccountReviewOptions.add(new selectoption('Int\'l Calling and Fraud Prevention','Int\'l Calling and Fraud Prevention'));
            lstAUserOptions = getPicklistValues(objImplementation, 'Users__c');
            companyNumbersInfoOptions = getPicklistValues(objImplementation, 'Company_Numbers_and_Info__c');
            groupsOptions = getPicklistValues(objImplementation, 'Groups__c');
            phonesDevicesOptions = getPicklistValues(objImplementation, 'Phones_Devices__c');
            toolsOptions = getPicklistValues(objImplementation, 'Tools__c');
            
            String strId =  ApexPages.currentPage().getParameters().get('Id');
            system.debug('strId------>'+strId);
            if(strId != null){
                objImplementation = [SELECT Id,Final_Call_Completed__c,Welcome_Call_Completed__c,First_Call_Completed__c,Brand__c, Second_Call_Completed__c,Third_Call_Completed__c,
                                            Fourth_Call_Completed__c,No_Show__c,Account_Review__c,Users__c,Company_Numbers_and_Info__c, Groups__c,
                                            Phones_Devices__c, Tools__c 
                                     FROM Implementation__c WHERE Id =: strId];                                
                accountReviewsList  = convertStringToList(objImplementation.Account_Review__c);
                usersList = convertStringToList(objImplementation.Users__c);
                companyNumbersInfoList = convertStringToList(objImplementation.Company_Numbers_and_Info__c);
                groupsList = convertStringToList(objImplementation.Groups__c);
                phonesDevicesList = convertStringToList(objImplementation.Phones_Devices__c);
                toolsInfoList = convertStringToList(objImplementation.Tools__c);
                
            }
        }catch(Exception ex){
             system.debug('Exception-->'+ex.getMessage()+'  Line-->'+ex.getLineNumber());
        }
    }
    
    /**********************************************************************************************
    * @Description : Method is used for getting the picklist values without query.                *
    * @Params      : Sobject, String                                                              *
    * @Return      : list<SelectOption>                                                           * 
    **********************************************************************************************/ 
    public List<SelectOption> getPicklistValues(SObject obj, String fld){
        
        List<SelectOption> options = new List<SelectOption>();
        List<SelectOption> telusOptions = new List<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        // Get a map of fields for the SObject
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        List<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        String strTELUS = 'Int\'l Calling & Fraud Prevention';
        implementationObj = (Implementation__c)obj;
        // Add these values to the selectoption list.
        system.debug(fld + '-->'+values.size());
        system.debug('values -->'+values);
        for (Schema.PicklistEntry a : values){
            if(fld.equalsIgnoreCase('Account_Review__c')){
                if(!String.isBlank(implementationObj.Brand__c) && implementationObj.Brand__c.containsIgnoreCase(GraduationScoreCardHelper.BRAND_TELUS)){
                     options.add(new SelectOption(a.getValue(), a.getValue()));
                }else {
                    if(!a.getValue().containsIgnoreCase(strTELUS)){
                        options.add(new SelectOption(a.getValue(), a.getValue()));
                    }
                }
            }else{
                options.add(new SelectOption(a.getValue(), a.getValue()));
            }
        }
        return options;
    }

    /**********************************************************************************************
    * @Description : This method is used for edit and save implementation as well.                *
    * @Params      : None                                                                         *
    * @Return      : pageReference                                                                * 
    **********************************************************************************************/
    public pageReference saveImplementation(){
        try{
            if(!String.isBlank(strEdit) && strEdit.equalsIgnoreCase('editable')){
                isDisabled = false;
                strDisabled = '';
                strEdit='No Editable';
                return null;
            }   
            objImplementation.Account_Review__c = convertListToSingleString(accountReviewsList);
            objImplementation.Users__c =convertListToSingleString(usersList);
            objImplementation.Company_Numbers_and_Info__c = convertListToSingleString(companyNumbersInfoList);
            objImplementation.Groups__c = convertListToSingleString(groupsList);
            objImplementation.Phones_Devices__c = convertListToSingleString(phonesDevicesList);
            objImplementation.Tools__c = convertListToSingleString(toolsInfoList);
            upsert objImplementation;
        }catch(Exception ex){
            system.debug('Exception---------->'+ex.getMessage()+'  line Numebr--->'+ex.getLineNumber());
        }
        return null;
    } 
    
    /**********************************************************************************************
    * @Description : This method is used for conversion from List to String.                      *
    * @Params      : List<String>                                                                 *
    * @Return      : String                                                                       * 
    **********************************************************************************************/     
    public String convertListToSingleString(List<String> values){
        String  value = '';
        for(String thisValue : values){
            value = value+thisValue+';';
        }
        return value;
    }
    
    /**********************************************************************************************
    * @Description : This method is used to display welcome call field on implementation checklist *
    * @Params      : boolean                                                                       *                                                                 * 
    **********************************************************************************************/    
     public boolean getDisplayTelusValue() {     
         if(implementationObj.Brand__c != null && implementationObj.Brand__c.containsIgnoreCase('Telus')){
             return true;
         }
             return false;
     }

    /**********************************************************************************************
    * @Description : This method is used for conversion from String to List of String.            *
    * @Params      : String                                                                       *
    * @Return      : List<String>                                                                 * 
    **********************************************************************************************/
    public List<String> convertStringToList(String value){
        List<String> lstString = new List<String>();
        if(value != null){
            for(String thisValue : value.split(';')){
                lstString.add(thisValue);
            }
        }
        return lstString;
    }
    
}// End of Class