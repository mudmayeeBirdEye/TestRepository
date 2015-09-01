public with sharing class clsViewTaxDetailsExtn {
    /*public decimal totalTaxes{get;set;}
    public boolean isProductsFound{get;set;}
    public decimal totalStateTaxes{get;set;}
    public decimal totalFederalTaxes{get;set;}
    public boolean isEmptyTaxMap {set;get;}
    public boolean zipMatch {set;get;}
    public boolean closeWindow {set;get;}
    public boolean zipOnAccountIsEmpty {set;get;}
    public boolean errorOccured {set;get;}
    public boolean isEmptyTaxJurisdiction {set;get;}
    public string quoteId = apexpages.currentpage().getparameters().get('id');
    public zqu__Quote__c quoteObj{get;set;}
    public List<zqu__QuoteCharge__c> quoteChargeList{get;set;}
    //public map<string,List<QuoteTriggerHelper.taxWrapper>> taxesMap = new map<string,List<QuoteTriggerHelper.taxWrapper>>();
    public map<string,zuoraUtility.QuoteWrapper2> taxesMap {get;set;}
    public set<Id> quoteIdSet = new set<Id>();
    public zuoraUtility.QuoteWrapper2 objDetail{get;set;}
    public string secondCall = '';
    //Constructor
    public clsViewTaxDetailsExtn(ApexPages.StandardController controller) {
      secondCall = apexpages.currentpage().getparameters().get('secondCall');
      errorOccured = false;
      isProductsFound = true;
      isEmptyTaxJurisdiction = false;
         taxesMap = new map<string,zuoraUtility.QuoteWrapper2>();
        zuoraUtility zuoraUtility = new zuoraUtility();
        totalFederalTaxes =0;
        totalStateTaxes =0;
        totalTaxes =0;
        List<zuoraUtility.taxWrapper> fedList = new List<zuoraUtility.taxWrapper>(); 
        List<zuoraUtility.taxWrapper> StateList = new List<zuoraUtility.taxWrapper>(); 
        quoteChargeList = new List<zqu__QuoteCharge__c>();
        try{
          if(quoteId != null && quoteId != ''){
              quoteObj = [select id,Run_Time_Jurisdiction__c,Run_Time_Zip__c,account_Zip_Code__c,zqu__Opportunity__r.Account.BillingPostalCode,tax_jurisdiction__c,total_federal_taxes__c,total_state_and_local_taxes__c from zqu__Quote__c where id =: quoteId];    
          }
          if(quoteId != null){
              quoteChargeList = [select id,name,zqu__Type__c,zqu__Model__c,zqu__ListPrice__c,zqu__Discount__c,zqu__EffectivePrice__c,
                              zqu__UOM__c,zqu__Quantity__c,zqu__Period__c,zqu__IncludedUnits__c,zqu__ListTotal__c,zqu__Total__c from zqu__QuoteCharge__c where zqu__Quote__c =:quoteId ] ;   
              string quoteId15Digit = string.valueOf(quoteId).substring(0,15);
              quoteIdSet.add(quoteId15Digit);
          }
          //taxesMap = QuoteTriggerHelper.getRecordsToDisplay(quoteChargeList);
          if(secondCall=='true'){
            system.debug('################### 1111111111');
            taxesMap = zuoraUtility.getTaxList(quoteIdSet,true);
          }else{
            system.debug('################### 2222222222');
            taxesMap = zuoraUtility.getTaxList(quoteIdSet);
          }
          
          totalFederalTaxes = (totalFederalTaxes + taxesMap.get(quoteId).fedTotal).setScale(2);
          totalStateTaxes= (totalStateTaxes + taxesMap.get(quoteId).StateTotal).setScale(2);
          totalTaxes = (totalFederalTaxes + totalStateTaxes).setScale(2); 
          
        }catch(Exception e){
          system.debug('Exception Occured  :  '+ e.getMessage());
        }
    }
    public List<zqu__QuoteCharge__c> getQuoteCharge(){
        return quoteChargeList;    
    }
    public List<zuoraUtility.taxWrapper> getfedList(){
      if(taxesMap.containsKey(quoteId)){
        if(taxesMap.get(quoteId).mapDisplayData.containsKey('Fed')){
          return taxesMap.get(quoteId).mapDisplayData.get('Fed');
        }  
      }
      return null;
    }
    public List<zuoraUtility.taxWrapper> getStateList(){
      if(taxesMap.containsKey(quoteId)){
        if(taxesMap.get(quoteId).mapDisplayData.containsKey('State')){
          return taxesMap.get(quoteId).mapDisplayData.get('State');
        }  
      }
      return null;
    }
    public pagereference validateZip(){
      try{
        if(!quoteChargeList.isEmpty()){
          string skipped = apexpages.currentpage().getparameters().get('skipped');
          String strJurisdiction='';
          if(secondCall=='true'){
            strJurisdiction=(quoteObj.Run_Time_Zip__c!=null?quoteObj.Run_Time_Zip__c:quoteObj.account_Zip_Code__c);
            system.debug('@@@@@@@@767676');
            }else{
                strJurisdiction=quoteObj.account_Zip_Code__c;
                system.debug('@@@@@@@@231123');
            }
          if(strJurisdiction != quoteObj.zqu__Opportunity__r.Account.BillingPostalCode && skipped != 'true' && secondCall !='true'){
            errorOccured = true;
            zipMatch = false;
            return null;
          }else {
            isEmptyTaxJurisdiction = false;
            errorOccured = false;
            zipMatch = true;
            return null;
          }
        }else{
          isProductsFound = false;
          return null;
        }      
      }catch(Exception e ){
        system.debug('Exception Occured  :  '+ e.getMessage());
            return null;    
        }
    }
    public pagereference updateQuote(){
        try{
            this.quoteObj.total_federal_taxes__c = totalFederalTaxes;
            this.quoteObj.total_state_and_local_taxes__c = totalStateTaxes;
            if(secondCall == 'true'){
              this.quoteObj.tax_jurisdiction__c = this.quoteObj.Run_Time_Jurisdiction__c;
              this.quoteObj.Account_Zip_Code__c = this.quoteObj.Run_Time_Zip__c;  
            }
            update this.quoteObj;
        }catch(Exception e){
            system.debug('Exception Occured  :  '+ e.getMessage());
            return null;    
        }
        
        return null;
    }
    public pagereference skip(){
        try{
            errorOccured = false;
            if( quoteObj.tax_jurisdiction__c == NULL || quoteObj.tax_jurisdiction__c == ''){
              isEmptyTaxJurisdiction = true;
            }
            return null;
        }catch(Exception e){
            system.debug('Exception Occured  :  '+ e.getMessage());
            return null;   
        }
        
        return null;
    }
    public pagereference continues(){
        try{
          return new pageReference('/apex/AddressValidationPage?id='+quoteObj.zqu__Opportunity__r.id + '&secondCall=true&currentCallSource=ViewTax&QuoteId='+string.valueOf(quoteObj.id).substring(0,15)); 
        }catch(Exception e){
            system.debug('Exception Occured  :  '+ e.getMessage());
            return null;    
        }
        
        return null;
    }
    
    public void close(){
        try{
          closeWindow = true;
          //update quoteObj;
        }catch(Exception e){
            system.debug('Exception Occured  :  '+ e.getMessage());
        }
        
    }*/
    
    

}