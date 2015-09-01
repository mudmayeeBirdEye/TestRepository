public class UpdateCsv {
          
    public Boolean bol{get;set;}
    public String Value{get;set;}
    public String badValue{get;set;}
    public String fieldType{get;set;}
    public String fieldSearch{get;set;}
    public String goodValSearch{get;set;}
    public String badValSearch{get;set;}
    public string selectedValue{get;set;} 
    public String selectedField{get;set;}       
    public String columnHeader1{get;set;}
    public String columnHeader2{get;set;}
    public String columnHeader3{get;set;}      
    public Map<String, Schema.SobjectField> fields;    
    public List<SelectOption> leadfieldoptions{get;set;} 
    public List<WrapperCsv> wrapCsv{get;set;}
    public List<WrapperCsv> filterWrapCsv{get;set;}
    public Map<string,List<SelectOption>> apiValueMap{get;set;}
    public List<Lead_Field_Map__c> fieldlst;
    public String newFieldType{get;set;} 
    public Integer delId{get;set;}
    public boolean errmsg{get;set;}
    public boolean successmsg{get;set;}
    private list<document> lstdoc; 
    
    public UpdateCsv(ApexPages.StandardController Con){
         lstdoc= new list<document>(); 
         errmsg=false; 
         successmsg=false;                
         leadfieldoptions = new List<SelectOption>();        
         fields = new Map<String, Schema.SobjectField>();
         fields = Lead.getSObjectType().getDescribe().fields.getMap();              
         lstDoc=getMyDocument('No_Employee_Mapping');
         List<Lead_Field_Map__c> fieldlst = Lead_Field_Map__c.getAll().Values();
         apiValueMap=fieldValueMap(fieldlst);                   
         leadfieldoptions.addAll(getFieldOption(fieldlst)); 
         String csv = lstDoc[0].body.tostring();
         String[] csvRows = csv.split('#EOL#');
         system.debug('************* My Csv ##############'+csv);
         wrapCsv = new List<wrapperCsv>();
         filterwrapCsv = new List<wrapperCsv>();
         Integer i=0;
         Integer j=0;
         For(String row: csvRows){
            String fieldType;
            String[] values = row.split(',#,');
            If(i==0){
                system.debug('************* My header ##############'+values[0]);
                columnHeader1 = 'Field Name'; //values[0];
                columnHeader2 = 'Bad Value';//values[1];
                columnHeader3 = 'Good Value';//values[2];
                i++;
                
            } else if(values[0].trim()!=null && values[0].trim()!='' ){
                fieldType=getGoodValue(values[0]);
                WrapperCsv wrap =new WrapperCsv(j++,values[0],values[1],values[2].replace(';',','),fieldType);
                    wrapCsv.add(wrap);
            }        
         }                        
            filterWrapCsv.addAll(WrapCsv);
    }
    
    public void getNewGoodValue(){
        For(WrapperCsv c:filterWrapCsv){
            c.fieldtype=getGoodValue(c.api_Name);           
        }
        
    }
    
    public String getGoodValue(String value){
        string fieldType;
        System.debug('Type Value=====================>'+value);
        Schema.DescribeFieldResult F = fields.get(value.trim()).getDescribe();
            if(String.valueOf(F.getType()).trim()=='PICKLIST'){
                fieldType=String.valueOf(F.getType()).trim();
            }else{
                fieldType=String.valueOf(F.getType()).trim();
            }
          return fieldType;  
    }
    
    public List<selectOption> getFieldOption(List<Lead_Field_Map__c> fieldlst){
        List<SelectOption> leadfieldoption = new List<SelectOption>();
        For(Lead_Field_Map__c lfield:fieldlst){         
                    System.debug('--------------------->'+fields.get(String.valueOf(lfield.api_name__c)).getDescribe().getlabel()+'@@@@@@@@'+lfield.api_name__c);
                    leadfieldoptions.add(new SelectOption(lfield.api_name__c,fields.get(String.valueOf(lfield.api_name__c).trim()).getDescribe().getlabel()));          
             }
             return leadfieldoption;
    }
    
    public static List<Document> getMyDocument(String docName){
        return [SELECT body, Name, bodyLength, ContentType, Url FROM Document WHERE Name = :docName];
    }
    
    public Map<String,List<SelectOption>> fieldValueMap(List<Lead_Field_Map__c> fieldName){     
        Map<String,List<SelectOption>> newMap = new Map<String,List<SelectOption>>();
        For(Lead_Field_Map__c a: fieldname){
            List<SelectOption> pickValue = new List<SelectOption>();
            If(a.api_name__c=='Job_Function__c'){
                List<SelectOption> pickValue1 = new List<SelectOption>();
                Lead_Field_Correct_Value__c lfcv=Lead_Field_Correct_Value__c.getInstance('Job Function');
                For(String s:lfcv.Field_Value__c.split(';')){
                    pickvalue1.add(new SelectOption(String.valueOf(s),String.valueOf(s)));
                }
                newMap.put(String.ValueOf(a.api_name__c).trim(),pickValue1);
            }
            for(String field: fields.keyset()){             
                If(field==String.valueOf(a.api_name__c) && a!=null){                                
                   Schema.DescribeFieldResult F = fields.get(String.valueOf(a.api_name__c)).getDescribe(); 
                    If(String.valueOf(F.getType()).trim()=='PICKLIST'){
                         system.debug('$$$ Matched Field *****');
                        For(Schema.PicklistEntry fi: F.getPicklistValues()){
                            pickValue.add(new SelectOption(String.valueOf(fi.getvalue()),String.valueOf(fi.getvalue())));
                        }
                        system.debug('$$$ pickValue *****'+pickValue);
                        newMap.put(String.ValueOf(a.api_name__c).trim(),pickValue);                     
                    }            
                } 
            }           
        }
        return newMap;
    }
    
    public PageReference reset(){
        PageReference reference=new PageReference('/apex/UpdateCsv');
            reference.setRedirect(true);
            return reference;
    }
    
    public void csvSearch(){
        filterWrapCsv.clear(); 
        successmsg=false;
        errmsg=false; 
        filterWrapCsv = wrapCsv; 
        If(fieldSearch!='--None--'){
            filterWrapCsv = Criteria1(filterWrapCsv);
        }
        If(!String.isBlank(badValSearch)){
            system.debug('Sorry------->');
            filterWrapCsv = Criteria2(filterWrapCsv);
        }
        If(!String.isBlank(goodValSearch)){
            filterWrapCsv = Criteria3(filterWrapCsv);
        }           
    }
    
    public list<wrapperCsv> Criteria1(list<wrapperCsv> filterWrapCsv){
        list<WrapperCsv> tempWrapCsv = new list<WrapperCsv>();
        system.debug('apivalue********>'+filterWrapCsv);
        For(WrapperCsv objCsv:filterWrapCsv){
            if(objCsv.api_Name.equalsIgnoreCase(fieldSearch)){                          
                tempWrapCsv.add(objCsv);                            
            }
        }
        return tempWrapCsv;
    }
    
    public list<wrapperCsv> Criteria2(list<wrapperCsv> filterWrapCsv){
        list<WrapperCsv> tempWrapCsv = new list<WrapperCsv>();
        system.debug('badvalue********>'+filterWrapCsv);
        For(WrapperCsv objCsv:filterWrapCsv){
            system.debug('badvalue********>'+objCsv.bad_Value);
            if(objCsv.bad_Value.containsIgnoreCase(badValSearch)){                          
                tempWrapCsv.add(objCsv);    
                system.debug('my list========>');                       
            }
        }
        system.debug('my list========>'+tempWrapCsv);
        return tempWrapCsv;
    }
    
    public list<wrapperCsv> Criteria3(list<wrapperCsv> filterWrapCsv){
        list<WrapperCsv> tempWrapCsv = new list<WrapperCsv>();
        For(WrapperCsv objCsv:filterWrapCsv){
            if( objCsv.good_Value.containsIgnoreCase(goodValSearch)){                           
                tempWrapCsv.add(objCsv);                            
            }
        }
        return tempWrapCsv;
    }
    
    public pageReference deleteRow(){
        try{
            String newCsv='Field Name,#,Bad Values,#,Good Values,#,#EOL#\r\n';
            System.debug('WrapperList----------------->'+wrapCsv);          
                For(WrapperCsv fw:wrapCsv){
                    if(delid!=fw.index){
                        newCsv+= fw.api_Name+',#,'+fw.bad_value+',#,'+fw.good_value.replace(',',';')+',#,'+'#EOL#\r\n';   
                    }
                }                           
            lstDoc[0].body=Blob.valueOf(newCsv);
            update lstDoc;            
        }catch(exception e){
            
        }
        PageReference reference=new PageReference('/apex/UpdateCsv');
            reference.setRedirect(true);
            return reference;
    }
    
    public Void updateDocCsv(){
        	String newCsv;
            errmsg = false;
            successmsg = false;
            newCsv='Field Name,#,Bad Values,#,Good Values,#,#EOL#\r\n';
            set<integer> index= new set<integer>();
            For(WrapperCsv objCsv:WrapCsv){
                for(WrapperCsv objfCsv:filterWrapCsv){                  
                        If(objfCsv.index==objCsv.index){
                            if(!String.isblank(objfCsv.bad_Value)){                         
                                index.add(objfcsv.index);
                                newCsv+= objfCsv.api_Name+',#,'+objfCsv.bad_value+',#,'+objfCsv.good_value.replace(',',';')+',#,'+'#EOL#\r\n';
                            }else{
                                errmsg=true;                              
                                break;                                
                            }   
                        }
                }
            }
            If(errmsg!=true){               
                For(WrapperCsv objCsv:WrapCsv){
                    If(!String.isblank(objcsv.bad_Value)){
                        If(!index.contains(objCsv.index)){
                            newCsv+= objCsv.api_Name+',#,'+objCsv.bad_value+',#,'+objCsv.good_value.replace(',',';')+',#,'+'#EOL#\r\n';
                        }
                    }else{
                        errmsg=true;                        
                        break;                                          
                    }   
                }
            }   
            If(errmsg!=true){       
                For(WrapperCsv objfCsv:filterWrapCsv){
                    If(!String.isblank(objfcsv.bad_Value)){
                        If(!index.contains(objfCsv.index)){
                            newCsv+= objfCsv.api_Name+',#,'+objfCsv.bad_value+',#,'+objfCsv.good_value.replace(',#,',';')+','+'#EOL#\r\n';
                        }
                    }else{
                        errmsg=true;                     
                        break;                       
                    }   
                }   
            }   
            lstDoc[0].body=Blob.valueOf(newCsv);
            update lstDoc; 
        
        If(errmsg!=true){
            successmsg=true;                    
        }
        
    }
    
    public PageReference addColumn(){
    	successmsg=false;
        try{
            WrapperCsv nwc = new WrapperCsv(wrapCsv.size()+1,'NumberOfEmployees__c','','','');           
            filterwrapCsv.add(nwc);
        }catch(exception e){
            errmsg=true;            
        }
        return null;
    }
        
    public class WrapperCsv{
       public Integer index{get;set;}
       public String api_Name{get;set;}
       public String bad_Value{get;set;}
       public String good_Value{get;set;}
       public String fieldtype{get;set;}
        
        public WrapperCsv(Integer index,String api,String bad,String good,String typ){
            this.index = index;
            api_Name = api.trim();
            bad_Value = bad.trim();
            good_Value = good.trim();
            fieldtype = typ.trim();
        }
    }
}