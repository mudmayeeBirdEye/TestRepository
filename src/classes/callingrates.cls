public class callingrates {
    public List<SelectOption> lstCountry {get;set;}
    public List<SelectOption> lstDomesticCode {get;set;}
    public List<String> lstCountryName{get;set;}
    public List<Integer> lstDomesticName{get;set;}
    public Map<String,List<RatesWrapp>> mapInternationalRates {get;set;}
    public Map<String,List<RatesWrapp>> mapDomesticRates {get;set;}
    public Map<String,Set<String>> mapCountry {get;set;}
    public String strSingleWord {get;set;}
    public String strSelectedCountry {get;set;}
    public String strDomesticCode {get;set;}
    public List<RatesWrapp> domesticRates {get;set;}
    public List<String> filterKey{get;set;}
    
    public static String domestic_CountryName = 'united kingdom';
    public Set<Integer> domesticSet;
    Blob csvBlob;
    List<List<String>> lstContentRow;

    public callingrates(){
        try{
            lstCountry = new List<SelectOption>();
            lstDomesticCode = new List<SelectOption>();
            filterKey = new List<String>();
            lstCountryName = new List<String>();
            lstDomesticName = new List<Integer>();
            domesticRates = new List<RatesWrapp>();
            mapInternationalRates = new Map<String,List<RatesWrapp>>();
            mapDomesticRates = new Map<String,List<RatesWrapp>>();
            mapCountry = new Map<String,Set<String>>();
            List<Document> lstDoc = [SELECT body, bodyLength, ContentType, Url FROM Document WHERE Name ='BT_Calling_Rates'];
            system.debug('#### lstDoc - '+lstDoc);
            if(lstDoc != null && lstDoc.size() > 0){
                csvBlob = lstDoc[0].body;
                lstContentRow = parseCSV(csvBlob.toString(), true);
                processCSVData(lstContentRow);
            }
        }catch(Exception ex){
            system.debug('Exception == ' + ex.getMessage() + ex.getStackTraceString());
        }
    }
    
    private void processCSVData(List<List<String>> lstRows){
        try{
            if(lstRows != null && lstRows.size() > 0){
                domesticSet = new Set<Integer>();
                for(List<String> obj : lstRows){
                    List<RatesWrapp> lstRWI = new List<RatesWrapp>();
                    List<RatesWrapp> lstRWD = new List<RatesWrapp>();
                    Set<String> nameList = new Set<String>();
                    String countryCode = String.isNotBlank(obj.get(0)) ? obj.get(0).replace('"','') : '';
                    String countryName = String.isNotBlank(obj.get(1)) ? obj.get(1).replace('"','') : '';
                    String domesticCode = String.isNotBlank(obj.get(2)) ? obj.get(2).replace('"','') : '';
                    String domesticName = String.isNotBlank(obj.get(3)) ? obj.get(3).replace('"','') : '';
                    String type = String.isNotBlank(obj.get(4)) ? obj.get(4).replace('"','') : '';
                    String rates = String.isNotBlank(obj.get(5)) != null ? obj.get(5).replace('"','') : '';
                    RatesWrapp rwObj = new RatesWrapp(countryCode, countryName, domesticCode, domesticName, type, rates);
                    String countryName_lowercase = countryName.toLowerCase();
                    
                    String firstLetter = countryName.Substring(0,1).trim().toUpperCase();
                    if(mapCountry != null && mapCountry.containsKey(firstLetter)){
                        nameList = mapCountry.get(firstLetter);
                        nameList.add(countryName_lowercase);
                        mapCountry.put(firstLetter,nameList);
                    }else{
                        nameList.add(countryName_lowercase);
                        mapCountry.put(firstLetter,nameList);
                    }
                    if(mapInternationalRates != null && mapInternationalRates.containsKey(countryName_lowercase)){
                        lstRWI = mapInternationalRates.get(countryName_lowercase);
                        lstRWI.add(rwObj);
                        mapInternationalRates.put(countryName_lowercase,lstRWI);
                    }else{
                        lstRWI.add(rwObj);
                        mapInternationalRates.put(countryName_lowercase,lstRWI);
                    }
                    if(String.isNotBlank(countryName_lowercase) && domestic_CountryName.equalsIgnoreCase(countryName_lowercase)){
                        domesticSet.add(Integer.valueOf(domesticCode));
                        if(mapDomesticRates != null && mapDomesticRates.containsKey(domesticCode)){
                            lstRWD = mapDomesticRates.get(domesticCode);
                            lstRWD.add(rwObj);
                            mapDomesticRates.put(domesticCode,lstRWD);
                        }else{
                            lstRWD.add(rwObj);
                            mapDomesticRates.put(domesticCode,lstRWD);
                        }
                    }
                }
                
                if(mapCountry != null){
                    filterKey.addAll(mapCountry.keySet());
                    filterKey.sort();
                }
                
                lstDomesticCode.add(new SelectOption('','Select Domestic Code'));
                lstDomesticCode.add(new SelectOption('a_','All'));
                List<Integer> lstDomestic = new List<Integer>();
                lstDomestic.addAll(domesticSet);
                lstDomestic.sort();
                for(Integer code : lstDomestic){
                    lstDomesticCode.add(new SelectOption('' + code,'' + code));
                }
                
                lstCountry.add(new SelectOption('','Select Country'));
                lstCountry.add(new SelectOption('a_','All'));
                if(mapInternationalRates != null){
                    Set<String> countryNameSet = mapInternationalRates.keySet();
                    for(String nameStr : countryNameSet){
                        if(mapInternationalRates != null && mapInternationalRates.containsKey(nameStr)){
                            lstCountry.add(new SelectOption(nameStr, mapInternationalRates.get(nameStr).get(0).countryName));
                        }
                    }
                    lstCountry.sort();
                }
            }
        }catch(Exception ex){
            system.debug('Exception == ' + ex.getMessage() + ex.getStackTraceString());
        }
    }
    
    public PageReference getCountryDetailBasedCountry(){
        strDomesticCode = '';
        try{
            lstCountryName.clear();
            lstDomesticName.clear();
            strSingleWord = 'a_'.equalsIgnoreCase(strSelectedCountry) && String.isBlank(strSingleWord) ? 'A' : strSingleWord;
            Set<String> setCountryName = mapCountry.get(strSingleWord);
            lstCountryName.addAll(setCountryName);
            lstCountryName.sort();
        }catch(Exception ex){
            system.debug('Exception == ' + ex.getMessage() + ex.getStackTraceString());
        }
        return null;
    }
    
    public PageReference getCountryWiseDetail(){
        try{
            lstCountryName.clear();
            lstDomesticName.clear();
            strDomesticCode = '';
            if('a_'.equalsIgnoreCase(strSelectedCountry)){
                strSingleWord = '';
                getCountryDetailBasedCountry();
            }else{
                List<RatesWrapp> lstRW = mapInternationalRates.get(strSelectedCountry);
                if(lstRW != null && lstRW.size() > 0){
                    Set<String> setCName = new Set<String>();
                    for(RatesWrapp rwObj : lstRW){
                        setCName.add(rwObj.countryName.toLowerCase().trim());
                    }
                    lstCountryName.addAll(setCName);
                    lstCountryName.sort();
                }
            }
        }catch(Exception ex){
            system.debug('Exception == ' + ex.getMessage() + ex.getStackTraceString());
        }
        return null;
    }
    
    public PageReference getAllDomesticRates(){
        try{
            lstCountryName.clear();
            lstDomesticName.clear();
            strSelectedCountry = '';
            strSingleWord = '';
            if(String.isNotBlank(strDomesticCode) && 'a_'.equalsIgnoreCase(strDomesticCode)){
                lstDomesticName.addAll(domesticSet);
                lstDomesticName.sort();
            }
        }catch(Exception ex){
            system.debug('Exception == ' + ex.getMessage() + ex.getStackTraceString());
        }
        return null;
    }
    
    public PageReference getDomesticRates(){ 
        lstCountryName.clear();
        lstDomesticName.clear();
        strSelectedCountry = '';
        strSingleWord = '';
        try{
            if(String.isNotBlank(strDomesticCode) && 'a_'.equalsIgnoreCase(strDomesticCode)){
                getAllDomesticRates();
            }else{
                if(String.isNotBlank(strDomesticCode)){
                    lstDomesticName.add(Integer.valueOf(strDomesticCode));
                }
            }
        }catch(Exception ex){
            system.debug('Exception == ' + ex.getMessage() + ex.getStackTraceString());
        }
        return null;
    }
    
    public Boolean getShowInternationalResultPanel(){
        if(lstCountryName != null && lstCountryName.size() > 0){
            return true;
        }
        return false;
    }
    
    public Boolean getShowDomesticResultPanel(){
        if(lstDomesticName != null && lstDomesticName.size() > 0){
            return true;
        }
        return false;
    }
    
    private static List<List<String>> parseCSV(string contents, Boolean skipHeaders) {
        List<List<String>> allFields = new List<List<String>>();
        try{
            contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            contents = contents.replaceAll('""','DBLQT');
            List<String> lines = new List<String>();
            try {
                lines = contents.split('\r');
            } catch (System.ListException e) {
                System.debug('Limits exceeded?' + e.getMessage());
            }
            Integer num = 0;
            for(String line : lines) {
                if (line.replaceAll(',','').trim().length() == 0) break;
                List<String> fields = line.split(',');  
                List<String> cleanFields = new List<String>();
                String compositeField;
                Boolean makeCompositeField = false;
                for(String field : fields) {
                    if (field.startsWith('"') && field.endsWith('"')) {
                        cleanFields.add(field.replaceAll('DBLQT','"').trim());
                    } else if (field.startsWith('"')) {
                        makeCompositeField = true;
                        compositeField = field.trim();
                    } else if (field.endsWith('"')) {
                        compositeField += ',' + field;
                        cleanFields.add(compositeField.replaceAll('DBLQT','"').trim());
                        makeCompositeField = false;
                    } else if (makeCompositeField) {
                        compositeField +=  ',' + field.trim();
                    } else {
                        cleanFields.add(field.replaceAll('DBLQT','"').trim());
                    }
                }
                allFields.add(cleanFields);
            }
            if (skipHeaders && !Test.isRunningTest()) allFields.remove(0);
        }catch(Exception ex){
            system.debug('Exception == ' + ex.getMessage() + ex.getStackTraceString());
        }
        return allFields; 
    }
    
    public class RatesWrapp{
        public String countryCode {get;set;}
        public String countryName {get;set;}
        public String domesticCode {get;set;}
        public String domesticName {get;set;}
        public String type {get;set;}
        public String rates {get;set;}
        
        public RatesWrapp(String countryCode, String countryName, String domesticCode, String domesticName, String type, String rates){
            this.countryCode = countryCode;
            this.countryName = countryName;
            this.domesticCode = domesticCode;
            this.domesticName = domesticName;
            this.type = type;
            this.rates = rates;
        }
    }
}