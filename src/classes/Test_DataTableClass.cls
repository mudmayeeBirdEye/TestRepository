@isTest
private class Test_DataTableClass {
	 static void createSobjectData(Map<String,Object> paramMap){
		List<Sobject> sobjList = new List<Sobject>();
	    System.debug(paramMap);
	    Integer count = (Integer)paramMap.get('sobjCount');
	    String SobjectName = (String)paramMap.get('ObjectName');
	    Map<String,Object> valueMap = (Map<String,Object>)paramMap.get('valueMap');
	    Map<String,Schema.SObjectType> sobjectMap = Schema.getGlobalDescribe();
			if(count != null && count > 0){
				for(Integer i =0 ;i<count;i++){
	                String finalName = '';
	                if(valueMap.containsKey('Name')){
	                	finalName = String.format((String)valueMap.get('Name'),new LIST<String> {SobjectName,String.valueof(i)});    
	                }
	                Sobject tempSobject =  sobjectMap.get(SobjectName).newSObject();
	                
	                for(String key : valueMap.keyset()){
	                    if(key.equals('Name')){
	                        tempSobject.put(key,finalName);
	                    }else{
	                        tempSobject.put(key,valueMap.get(key));
	                    }
	                }
	                sobjList.add(tempSobject);
				}
	            insert sobjList;
			}
			
		}
    static testMethod void testMethodForController() {
        DataTableClass tableClass = new DataTableClass();
        tableClass.setObjectType('Account');
        tableClass.setCounter(0); 
        tableClass.setList_size(10);
        tableClass.setSizeOptions(new List<String>{'10','20','30','40','50'});
        tableClass.setSortDirection('DESC');
        tableClass.setSortByField('CreatedDate');
        tableClass.setFieldList(new List<String>{'Name','CreatedDate','CreatedBy'});
        List<Object> paramList  = new List<Object>();
        paramList.add(new Map<String,Object>{
	        'name' 			=>'Name',
	        'operator'		=>'=',
	        'seperator'		=>'No',
	        'value'			=>'TestValue'
	    });
        tableClass.setParamList(paramList);
        Map<String,Object> paramMapToPass = new Map<String,Object> {
  		'ObjectName' => 'Account',
    	'sobjCount'  => 50,
        'valueMap'	 => new Map<String,Object>{
            'Name' => 'Test{1}FromTestClass{2}',
            'RC_Account_Status__c' => 'Paid',
            'RC_Brand__c' => 'RingCentral',
            'Service_Type__c' => 'RC Office',
            'RC_Tier__c' => 'testTier',
            'Total_DLs__c' => 10,
            'Account_Mobile_Number__c' => '1234567890',
            'RC_Account_Number__c'	=> '123456789'
        	}
		};
		createSobjectData(paramMapToPass);
		System.debug([Select Id from Account]);
        tableClass.prepareTable();
        
        System.debug(tableClass.total_size+'~~~~~~~~tableClass.total_size');
        tableClass.showpage = '1';
        tableClass.changePage();
        tableClass.sortTable();
        tableClass.pageNumber = tableClass.pageNumber;
        tableClass.Beginning();
        System.debug(tableClass.counter+'~~~~~~~~~~~~~~~~~~~~~counter');
        System.assert(tableClass.disablePrevious == true);
        tableClass.End();
        System.debug(tableClass.counter+'~~~~~~~~~~~~~~~~~~~~~counter');
        System.assert(tableClass.disableNext == true);
       // tableClass.Previous();
       // tableClass.Next();
        
        
    }
}