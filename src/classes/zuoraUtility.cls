public class zuoraUtility{
    /*public map<string,Id> addressContactMap = new map<string,Id>();// key=> (country-state-locality) and Value will be ContactId
    public  map<Contact,String> contactJuridnMap = new map<Contact,String>();// key=> sold-to-Contact and Value will be JuridictionId
    public map<string,String> QuoteChargJuridcnMap = new map<string,String>();// key Quote and Value will be Juridiction Id.
    public set<string> conAddressSet = new set<string>();// country-state-locality
    public set<Id> quoteIdSet = new set<Id>();
    public map<id,Contact> quoteConMap = new map<id,Contact>();// key= quote id
    public map<id,Contact> conMap = new map<id,Contact>();
    public map<id,List<zqu__QuoteCharge__c>> quoteChargeMap = new map<id,List<zqu__QuoteCharge__c>>();
    public List<sf_tax__c> allTaxList = new List<sf_tax__c>();
    public map<String,Map<String,taxWrapper>> mapTaxWrapper = new map<String,Map<String,taxWrapper>>(); // key => 'Fed' or 'state' and in Value=> map Key => tax name and value => taxWrapper class instance
    public List<zqu__Quote__c> quoteList = new List<zqu__Quote__c>();
    public static FINAL decimal fedralTaxUSF = decimal.valueOf(System.Label.fedralTaxUSF); 
    
    public Boolean isUpdated=false;
    
    public Map<String,QuoteWrapper2> getTaxList(Set<Id> quoteIdSe,Boolean isUpdated){
        system.debug('@@@@@@@@@@@ isUpdated ' + isUpdated);
        this.isUpdated=isUpdated;
        return getTaxList(quoteIdSe);
    }
    
    public Map<String,QuoteWrapper2> getTaxList(Set<Id> quoteIdSe){
       // quoteIdSet = quoteIdSe;
        for(String s : quoteIdSe){
          string ss = string.valueOf(s).substring(0,15);
          quoteIdSet.add(ss);
        }
        quoteList = [select id,zqu__Opportunity__r.Account.BillingCity,zqu__Opportunity__r.Account.BillingCountry,zqu__Opportunity__r.Account.BillingPostalCode,zqu__Opportunity__r.Account.BillingState,
                            zqu__SoldToContact__c,zqu__SoldToContact__r.id,tax_jurisdiction__c,
                            (select id,zqu__Total__c,name,zqu__Quote__r.tax_jurisdiction__c,zqu__ProductRatePlanCharge__r.CrmTaxCode__c,zqu__ProductRatePlanCharge__r.ChargeType__c from zqu__QuoteCharge__r where zqu__Quote__c IN : quoteIdSet)
                             from zqu__Quote__c where Id IN:quoteIdSet];
        set<Id> conIdSet = new set<Id>();
        set<string> taxCategorySet = new set<string>();
        set<string> JurisdictionIdSet = new set<string>();
        for(zqu__Quote__c quote : quoteList){
            quoteChargeMap.put(quote.id,quote.zqu__QuoteCharge__r);
            conIdSet.add(quote.zqu__SoldToContact__r.id);    
        }
        conMap = new map<id,contact>([select id, account.billingCountry,account.billingState,account.billingCity from contact where id IN : conIdSet]);
        List<zqu__QuoteCharge__c> quoteChargeList = [select id,name,zqu__Quote__r.Account_Zip_Code__c,zqu__Quote__r.tax_jurisdiction__c,zqu__Quote__r.Run_Time_Zip__c,zqu__ProductRatePlanCharge__r.ChargeType__c,zqu__Quote__r.Run_Time_Jurisdiction__c,
                              zqu__Quantity__c,zqu__ProductRatePlanCharge__r.CrmTaxCode__c from zqu__QuoteCharge__c where zqu__Quote__c IN : quoteIdSet];
        for(zqu__QuoteCharge__c qCharge : quoteChargeList){
            taxCategorySet.add(qCharge.zqu__ProductRatePlanCharge__r.CrmTaxCode__c);
            if(qCharge.zqu__Quote__r.Run_Time_Zip__c == qCharge.zqu__Quote__r.Account_Zip_Code__c ){
                   JurisdictionIdSet.add(qCharge.zqu__Quote__r.tax_jurisdiction__c);
            }else{
                system.debug('@@@@@@@@@@@ isUpdated ' + isUpdated);
              JurisdictionIdSet.add((isUpdated==false?qCharge.zqu__Quote__r.tax_jurisdiction__c:qCharge.zqu__Quote__r.Run_Time_Jurisdiction__c));
            }
        } 
        allTaxList = [select id,VALUE__c ,TAXLEVEL__c,TAXTYPE__c,TAXNAME__c,TAXCATEGORY__c,STATE__c,LOCALITY__c,
                                        JURISDICTION__c,COLLECTIONTYPENAME__c,DESCRIPTION__c,County__c,TAXABLEMEASUREPERCENT__c,
                                        COUNTRYID__c from sf_tax__c where JURISDICTION__c IN : JurisdictionIdSet AND TAXCATEGORY__c IN : taxCategorySet AND JURISDICTION__c != NULL AND TAXCATEGORY__c != NULL limit 10000];
        for(zqu__Quote__c quote : quoteList){
            quoteConMap.put(quote.id,conMap.get(quote.zqu__SoldToContact__r.Id));
        }
        Map<String,QuoteWrapper2> quoteWarpperMap = calculateTax();
        return quoteWarpperMap;      
    }  
    
  
    public Map<String,QuoteWrapper2> calculateTax(){
        Map<String,QuoteWrapper2> mapDisplayData=new  Map<String,QuoteWrapper2>();
        for(zqu__Quote__c quoteObj : quoteList){
            if(!mapTaxWrapper.isEmpty()){
                mapTaxWrapper.clear();
            }
            if(quoteChargeMap.containsKey(quoteObj.id)){
                QuoteWrapper2 objQuoteWrapper2= createTaxDetailsQcharge(quoteChargeMap.get(quoteObj.id),conMap.get(quoteObj.zqu__SoldToContact__r.Id)); // create map where we put taxlevel as key and get taxwrapper rows for same Fed/state and local tax 
                string quote15DigitId = '';
                quote15DigitId = string.valueOf(quoteObj.id).substring(0,15);
                mapDisplayData.put(quote15DigitId,objQuoteWrapper2);
            }
        }
        return mapDisplayData;
    }
    public QuoteWrapper2 createTaxDetailsQcharge(List<zqu__QuoteCharge__c> qChargeList,Contact soldToContact){ // here in return map key => Qcharge id
        if(!allTaxList.isEmpty()){
            for(zqu__QuoteCharge__c qCharge : qChargeList){
                List<taxWrapper> taxWrapList = new List<taxWrapper>();
                for(sf_tax__c sfTax : allTaxList){
                    if(sfTax.JURISDICTION__c == qCharge.zqu__Quote__r.tax_jurisdiction__c && sfTax.TAXCATEGORY__c == qCharge.zqu__ProductRatePlanCharge__r.CrmTaxCode__c){
                        if(sfTax.TAXLEVEL__c==0){
                            setMapValue(qCharge,sfTax,'Fed');
                        }else{
                            setMapValue(qCharge,sfTax,'State');
                        }
                    }
                }
                if(qCharge.zqu__ProductRatePlanCharge__r.ChargeType__c != 'DLFee'){// Adding Federal Tax (USF) for every Quotecharge item where chargetype is nor DLfee
                  taxWrapper objtaxWrapper=new taxWrapper(qCharge.zqu__Total__c,allTaxList[0]);
                objtaxWrapper.taxLevel = 0;
                objtaxWrapper.taxPercent = fedralTaxUSF;
                objtaxWrapper.taxName = 'Federal - USF';
                objtaxWrapper.description = 'Federal USF'; 
                objtaxWrapper.total = (qCharge.zqu__Total__c*objtaxWrapper.taxPercent).Divide(100,2);
                if(mapTaxWrapper.containsKey('Fed') && mapTaxWrapper.get('Fed')!=null){
                  if(mapTaxWrapper.get('Fed').get('Federal - USF')!=null){
                    taxWrapper objNewtaxWrapper = mapTaxWrapper.get('Fed').get('Federal - USF');                     
                    objNewtaxWrapper.total = objNewtaxWrapper.total+objtaxWrapper.total;
                }else{
                      mapTaxWrapper.get('Fed').put('Federal - USF',objtaxWrapper);
                  }
              }else{
                   mapTaxWrapper.put('Fed',new Map<String,taxWrapper>{objtaxWrapper.taxName => objtaxWrapper});
              }
            }
            }
        }
        return displayData();
    }
    
    public void setMapValue(zqu__QuoteCharge__c qCharge,sf_tax__c sfTax,String strKey){
        taxWrapper objtaxWrapper=new taxWrapper(qCharge.zqu__Total__c,sfTax);
        if(mapTaxWrapper.get(strKey)!=null){
            if(mapTaxWrapper.get(strKey).get(sfTax.TaxName__c)!=null){
                taxWrapper objNewtaxWrapper = mapTaxWrapper.get(strKey).get(sfTax.TaxName__c);                     
                mapTaxWrapper.get(strKey).get(sfTax.TaxName__c).total = objNewtaxWrapper.total+objtaxWrapper.total;
            }else{
                mapTaxWrapper.get(strKey).put(sfTax.TaxName__c,objtaxWrapper);
            }

        }else{
             mapTaxWrapper.put(strKey,new Map<String,taxWrapper>{sfTax.TaxName__c=>objtaxWrapper});
        }
    }
    
    public  QuoteWrapper2 displayData(){
        Map<String,List<taxWrapper>> mapDisplayData = new Map<String,List<taxWrapper>>();
        Decimal dFedTotal=0.0;
        Decimal dStateTotal=0.0;
        for(String strKey:mapTaxWrapper.keySet()){
            for(String strTaxName:mapTaxWrapper.get(strKey).keySet()){
                if(strKey=='Fed'){
                    if(mapDisplayData.get('Fed')==null){
                        mapDisplayData.put('Fed',new List<taxWrapper>{mapTaxWrapper.get(strKey).get(strTaxName)});
                    }else{
                        mapDisplayData.get('Fed').add(mapTaxWrapper.get(strKey).get(strTaxName));
                    }
                    dFedTotal=dFedTotal+mapTaxWrapper.get(strKey).get(strTaxName).total;
                }else{
                    if(mapDisplayData.get('State')==null){
                        mapDisplayData.put('State',new List<taxWrapper>{mapTaxWrapper.get(strKey).get(strTaxName)});
                    }else{
                        mapDisplayData.get('State').add(mapTaxWrapper.get(strKey).get(strTaxName));
                    }       
                    dStateTotal=dStateTotal+mapTaxWrapper.get(strKey).get(strTaxName).total;
                }
            }
        }
        return new QuoteWrapper2(dFedTotal,dStateTotal,mapDisplayData);
    }   
    
    public class taxWrapper{
        public decimal taxLevel{get; set;}// Level : federal OR State and Local
        public decimal taxPercent{get; set;} //how much tax in percent
        public string taxName {get; set;} //name of the tax
        public string description {get;set;} 
        public decimal total{get;set;}
        public string taxType{get;set;}// fee or Tax
           
        public taxWrapper(decimal prinAmount,sf_tax__c sfTax) {
            this.taxLevel = 0;
            this.taxPercent = 0;
            this.taxType= '';
            this.taxName = '';
            this.description = '';
            this.taxLevel = sfTax.TAXLEVEL__c;
            this.taxPercent = sfTax.VALUE__c;
            this.taxType= sfTax.COLLECTIONTYPENAME__c;
            this.taxName = sfTax.TAXNAME__c;
            this.description = sfTax.DESCRIPTION__c; 
            this.total =0;
            this.total = finalTaxAmount(sfTax.TAXABLEMEASUREPERCENT__c,sfTax.VALUE__c,prinAmount,sfTax.COLLECTIONTYPENAME__c);
        }
        public decimal finalTaxAmount(decimal TAXABLEMEASUREPERCENT,decimal Value,decimal pAmount,string taxType){
        decimal total = 0.0;
        pAmount = (pAmount != null ? pAmount : 0.0);
        Value = (Value != null ? Value : 0.0);
        TAXABLEMEASUREPERCENT = (TAXABLEMEASUREPERCENT != null ? TAXABLEMEASUREPERCENT : 0.0);
        
        if(!String.isBlank(taxType) && taxType.equalsIgnoreCase('Fee')){
          total = (Value * (TAXABLEMEASUREPERCENT/100));  
        }else{
          total = pAmount*(Value/100) * (TAXABLEMEASUREPERCENT/100);
        }  
        total = total.setScale(2);
        return total;
      }
    }
    
    public class QuoteWrapper2{
        public decimal fedTotal{get;set;}
        public decimal StateTotal{get;set;}
        public decimal TotalTax{get;set;}
        public Map<String,List<taxWrapper>> mapDisplayData{get;set;}
    
        public QuoteWrapper2(decimal fedTotal,decimal StateTotal, Map<String,List<taxWrapper>> mapDisplayData){
            this.fedTotal=0;
            this.StateTotal=0;
            this.TotalTax =0;
            this.mapDisplayData= new Map<String,List<taxWrapper>>();
            this.fedTotal=fedTotal;
            this.StateTotal=StateTotal;
            this.mapDisplayData=mapDisplayData;
        }
    
    }*/
}