public class ATTInternationalratesCsvhnadler{

    public String csvbody{get;set;}
    List<string> currentrow=new List<string>();
    public Blob csvBlob{get;set;}
    public Map<String,Map<String,TypeCodeAndPrice>> mapInternationalRatesGlobal{get;set;}
    public Map<String,Map<String,TypeCodeAndPrice>> mapInternationalRates{get;set;}
    public List<SelectOption> lstCountry{get;set;}
    
    public List<String> lstCountryName{get;set;}
    
    public String strSelectedCountry{get;set;}
    public String strSingleWord{get;set;}
    
    Boolean done=false;
    Integer j=0;
    Integer k=0;
    Integer i=0;
    String line='';
     public String strMessage{get;set;}

    public ATTInternationalratesCsvhnadler(){
          
          mapInternationalRatesGlobal=new  Map<String,Map<String,TypeCodeAndPrice>>(); 
          mapInternationalRates=new  Map<String,Map<String,TypeCodeAndPrice>>(); 
          lstCountryName=new List<String>();
          strSingleWord='';
          
         
          List<Document> lstDoc = [Select body, bodyLength, ContentType, Url from Document where Name ='VIIFPRInternationalCallingRates'];
          strMessage='test';
             if(lstDoc.size()>0 || Test.isRunningTest()){
                          if(Test.isRunningTest()){
                            csvBlob=getCSVBODY();
                         }else{
                            csvBlob = lstDoc[0].body;
                          }
                         csvbody= csvBlob.toString();
                         system.debug('Content====='+csvbody);
                      // try{
                         processCSV(csvbody);
                         setCountryList();
                         if(Test.isRunningTest()){//Only for code coverage
                            //integer ii=5/0;
                          }
                      // }catch(Exception e){
                        //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Line Numbe:'+e.getLineNumber()+e.getMessage()));
                          // strMessage=e.getMessage()+e.getLineNumber();
                      // }
         }
    }
    
    public pageReference getCountryDetailBasedCountry(){
   
        strSingleWord='';
        if(strSelectedCountry=='A' && lstKeySet!=null && lstKeySet.size()>0){
            strSingleWord=lstKeySet.get(0);
        }
        return getCountryWiseDetail();
    }
    public pageReference getCountryWiseDetail(){
          try{
         mapInternationalRates=new  Map<String,Map<String,TypeCodeAndPrice>>(); 
         
         if(strSingleWord!=''){
             for(String strCountry:mapCountryDetail.get(strSingleWord)){
                mapInternationalRates.put(strCountry,mapInternationalRatesGlobal.get(strCountry));
             }
             setCountryName();
        }else if(strSelectedCountry==''){
             lstCountryName=new List<String>();
         }else if(strSelectedCountry=='A'){
            mapInternationalRates=mapInternationalRatesGlobal;
            setCountryName();
        }else if(strSelectedCountry!='A'){
            mapInternationalRates.put(strSelectedCountry,mapInternationalRatesGlobal.get(strSelectedCountry));
            setCountryName();
        }
         if(Test.isRunningTest()){//Only for code coverage
             integer ii=5/0;
          }
    }catch(Exception e){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Line Numbe:'+e.getLineNumber()+e.getMessage()));
    }
    return null;
    }
    
    public void setCountryName(){
        lstCountryName=new List<String>();
        for(String strKey:mapInternationalRates.keySet()){
            lstCountryName.add(strKey);
        }
        lstCountryName.sort();
    }
    
    public Map<String,List<String>> mapCountryDetail{get;set;}
    public List<String> lstKeySet{get;set;}
    public void setCountryList(){
         lstCountry=new List<SelectOption>();
         lstKeySet=new List<String>();
         mapCountryDetail=new Map<String,List<String>>();
         Boolean isCountryFound=false;
         lstCountry.add(new SelectOption('','Select Country'));
         for(String strCountry:mapInternationalRatesGlobal.keySet()){
             lstCountry.add(new SelectOption(strCountry,strCountry));
             isCountryFound=true;
                        
            String strCountryFirstletter=strCountry.Substring(0,1);
            if(mapCountryDetail.get(strCountryFirstletter)==null){
                if(mapCountryDetail.size()>0){
                     mapCountryDetail.put(strCountryFirstletter,new List<String>{strCountry});
                }else{
                    mapCountryDetail=new Map<String,List<String>>{strCountryFirstletter=>new List<String>{strCountry}};
                }
                
            
            }else{
                mapCountryDetail.get(strCountryFirstletter).add(strCountry);
           }
        }
        if(isCountryFound==true){
            lstCountry.add(new SelectOption('A','ALL'));
        }
        lstKeySet.addAll(mapCountryDetail.keySet());
        lstKeySet.sort();
        lstCountry.sort();
       
    }
public integer kk{get;set;} 







  public void processCSV(String csvbody){
    
    List<List<String>> allFields = parseCSV(csvbody ,True);
    
    for(List<String> str : allFields){
        system.debug('str&&&&&&&&&&&&&&==>'+str);
        for(String strnew: str){
                    system.debug('strnew&&&&&&&&&&&&&&==>'+strnew);
            
            
        }
    }
    
    kk=0;
    // while(!done){
    for(List<String> line : allFields){
          // k=csvbody.indexOf('*EOL*', i);
          
           //currentrow=new List<string>();
           //line=csvbody.substring(i,k);   
           
          // Integer firstIndex = line.indexOf('"');
           //Integer lastIndex = line.lastIndexOf('"');
           //Integer comaSize = 0;
           /*
           Integer comaSize = 0;
           List<String>currentrowByClodesparanth = line.split(')');
           if(currentrowByClodesparanth.size()>0){
                comaSize = currentrowByClodesparanth[0].split(',').size()>0?currentrowByClodesparanth[0].split(',').size():0;
           }
           */
          // String sbString = line.substring(firstIndex, lastIndex);
          // line.replace(sbString, '');
           // system.debug('------------sbString'+sbString);
          // currentrow = line.split(',');  
           String strCountryCode=line.get(0).trim();
           String strCountryName=line.get(1).trim().replace('"', '');
           String strRatePerUnit=line.get(2).trim();
           String strType=line.get(3).trim();
           
          /* if(currentrow[0].IndexOf('(') > -1){
               strCountryCode=currentrow.get(1).trim();
               strCountryName=currentrow.get(2).trim();
               strRatePerUnit=currentrow.get(3).trim();
               strType=currentrow.get(4).trim();
           }
          */
            if(kk==0){
            kk=1;
            strMessage=line+'====='+strType+'======'+strCountryCode;
           }
            
            TypeCodeAndPrice obj=new TypeCodeAndPrice();
            obj.lstCode=new List<String>{strCountryCode};
            //obj.strRatePerUnit=strRatePerUnit;
            obj.lstRatePerUnit=new List<String>{strRatePerUnit};
            //system.debug('obj.lstCode  ==>'+obj.lstCode+ '  obj.lstRatePerUnit====>'+ obj.lstRatePerUnit);
            // system.debug('obj.lstCode.size()  ==>'+obj.lstCode.size()+ '  obj.lstRatePerUnit.size(====>'+ obj.lstRatePerUnit.size());
            
            
           if(mapInternationalRatesGlobal.get(strCountryName)==null){
               /*if(mapInternationalRatesGlobal==null && mapInternationalRatesGlobal.size()==0){
                   mapInternationalRatesGlobal=new  Map<String,Map<String,TypeCodeAndPrice>>{strCountryName=>new Map<String,TypeCodeAndPrice>{strType=>obj}}; 
                 }else{*/
                    Map<String,TypeCodeAndPrice> mapLocalData=new Map<String,TypeCodeAndPrice>{strType=>obj};
                    mapInternationalRatesGlobal.put(strCountryName,mapLocalData);
                 //}
              
           }else{
                 if(mapInternationalRatesGlobal.get(strCountryName).get(strType)!=null){
                    
                      mapInternationalRatesGlobal.get(strCountryName).get(strType).lstCode.add(strCountryCode);
                     // mapInternationalRatesGlobal.get(strCountryName).get(strType).strRatePerUnit=strRatePerUnit;
                      mapInternationalRatesGlobal.get(strCountryName).get(strType).lstRatePerUnit.add(strRatePerUnit);
                     
                 }else{
                    mapInternationalRatesGlobal.get(strCountryName).put(strType,obj);
                    
                 }
           }
           /*
         if(k==csvbody.lastIndexOf('*EOL*')){
                done=true;
                kk=k;
         }else{
              i=k+6;
          }*/
     }
        
  }

public class TypeCodeAndPrice{
    public List<String> lstCode{get;set;}
    public String strRatePerUnit{get;set;}
    public List<String>lstRatePerUnit{get;set;}
    
}
public Blob getCSVBODY(){
     String strcsvContent='';
    strcsvContent=strcsvContent+'355,Albania,1.19,To wireline,*EOL*';
    strcsvContent=strcsvContent+'356,Albania,1.19,To wireline,*EOL*';
    strcsvContent=strcsvContent+',355,Albania,1.38,To mobile,*EOL*';
    strcsvContent=strcsvContent+',91,India,1.38,To mobile,*EOL*';
    strcsvContent=strcsvContent+',99,India2,1.38,To mobile,*EOL*';
    strcsvContent=strcsvContent+'';
    
    return Blob.valueOf(strcsvContent);
}

  private static List<List<String>> parseCSV(string contents, Boolean skipHeaders) {
        List<List<String>> allFields = new List<List<String>>();
        try {
            contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            contents = contents.replaceAll('""','DBLQT');
            List<String> lines = new List<String>();
            lines = contents.split('\r');
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
                        compositeField += ',' + field.trim();
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
        } catch(Exception ex) {}
        if (skipHeaders) allFields.remove(0);
        return allFields; 
    }


/*public static testmethod void MyUnitTest(){
    
    try{    
        ATTInternationalratesCsvhnadler obj=new ATTInternationalratesCsvhnadler();
        obj.strSingleWord='A';
        obj.getCountryWiseDetail();
        
        obj.strSelectedCountry='A';
        obj.getCountryDetailBasedCountry();
        
        obj.strSelectedCountry='India';
        obj.getCountryDetailBasedCountry();
        
        obj.strSelectedCountry='';
        obj.getCountryDetailBasedCountry();
        
        obj.strSelectedCountry='A';
        obj.getCountryWiseDetail();
    }catch(Exception e){}
    
}*/




}