public with sharing class DataTableClass{ 
  	public List<ColumnData> fieldList{get;set;}
  	public String sortbyField{get;set;}
  	public String sortDirection{get;set;}
  	public Integer list_size{get;set;}
  	public Integer counter{get;set;}
  	private String query{get;set;}
  	private String countQuery{get;set;}
  	private String objectType{get;set;}
  	public Integer total_size{get;set;}
  	private String whereString{get;set;}
  	public String showpage{get;set;}
  	public List<Sobject> objectsList{get;set;}
  	public List<SelectOption> pageOptions{get;set;}
  	public List<SelectOPtion> sizeOptions{get;set;}
  	public List<Object> paramList{get;set;}
  	public DataTableClass(){
  		total_size = null;
  		counter = 0;
  		list_size = 10;
  		whereString = '';
  		pageOptions = new List<SelectOption>();
  		SizeOptions = new List<SelectOption>();
  		
  	}
  	public void setFieldList(List<String> fieldNameList){
  		fieldList = new List<ColumnData>();
  		Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new List<String>{objectType});
  		Map<String, Schema.SObjectField> fieldMap = results[0].fields.getMap();
  		for(String fieldString : fieldNameList){
  			if(fieldMap.containsKey(fieldString))
  			{
  				Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldString).getDescribe();
  				fieldList.add(new ColumnData(fieldDescribe.getName(),fieldDescribe.getLabel()));
  			}
  		}
  		
  	}
  	public void setSizeOptions(List<String> sizeOptionsList){
  		SizeOptions.clear();
  		for(String option : sizeOptionsList){
  			SizeOptions.add(new SelectOption(option,option));
  		}
  	}
  	public void setSortByField(String sortbyField){
  		this.sortbyField = sortbyField;
  	}
  	public void setSortDirection(String sortDirection){
  		this.sortDirection = sortDirection;
  	}
  	public void setList_size(Integer list_size){
  		this.list_size = list_size;
  	}
  	
  	public void setCounter(Integer counter){
  		this.counter = counter;
  	}
  	public void setObjectType(String objectType){
  		this.objectType = objectType;
  	}
  	public void setParamList(List<Object> paramList){
  		this.paramList = paramList;
  		prepareWhere();
  	}

public void prepareWhere(){
  		if(paramList.size() >0){
  			
  			whereString = ' Where';
            for(Object condition : paramList){
                Map<String,Object> conditionMap = (Map<String,Object>)condition;
                if(!(((String)conditionMap.get('seperator')).equals('No'))){
                    whereString+=' '+conditionMap.get('seperator');
                }
                
                Object Value = conditionMap.get('value');
                if(Value instanceof String){
                    whereString+=' '+conditionMap.get('name')+' '+conditionMap.get('operator')+' \''+conditionMap.get('value')+'\'';
                }
                else if(Value instanceof List<String>){
                    String stringRep = ' (';
                    List<String> listOfString=new List<String>();
					listOfString.addAll((List<String>)Value);
					for(STring s :listOfString){	

						stringRep+='\''+s+'\',';
					}
				  
						stringRep=stringRep.removeEnd(',');
						stringRep+=')';
						whereString+=' '+conditionMap.get('name')+' '+conditionMap.get('operator')+' '+stringRep;
                }else{
                    
                      whereString+=' '+conditionMap.get('name')+' '+conditionMap.get('operator')+' '+conditionMap.get('value');
                }
            }
  		}
  		
  	}

  	public void prepareTable(){
		 query = 'Select Id ' ;
  		 countQuery = 'Select count() ' ;
  		 for(ColumnData field : fieldList)  
         	{  
            	query += ','+ field.name + ' ' ;  
            	
         	}
         query+= 'FROM '+objectType;
         countQuery+= 'FROM '+objectType;
         query+=whereString;
         countQuery+=whereString+' LIMIT 50000';
         if(sortbyField !=null)
         	{
              query +=' ORDER BY '+sortbyField+' '+sortDirection +' LIMIT '+list_size + ' offset '+counter; 
              
            }
           else
            {
              query +=' LIMIT '+list_size + ' offset '+counter; 
               
            }  
            System.debug(query+'~~~~~~~~~~~~~~~~~~~~~~~~~~~querysearch');
			if(total_size == null){
			    total_size = database.countquery(countQuery);
			 }           
			objectsList = Database.query(query);
            
            Integer no = getTotalPages();
            pageOptions.clear();
            for(Integer i=1;i<=no;i++)
            	{
					pageOptions.add(new SelectOption(i+'',i+''));
            	}
  	}
  	public Integer getTotalPages() {
       if (math.mod(total_size, list_size) > 0) {
               return total_size/list_size + 1;
         }
        else {
              return (total_size/list_size);
      }
   }
	   //method to get begining page in pagination
	 public void Beginning() {
	              
	              counter = 0;
	              prepareTable();
	   }
	  //method to get previous page in pagination
	  public void Previous() {
	              
	              counter -= list_size;
	              prepareTable();
	   }
	   //method to get next page in pagination 
	  public void Next() {
	                counter += list_size;
	                prepareTable();
	   }
	   //method to get end page in pagination
	  public void End() { 
	               
	                counter = total_size - math.mod(total_size, list_size);
	                prepareTable();
	   }
	   //method to check and disable start and previous button according to counter value 
	  public Boolean disablePrevious {get{
	                if (counter>0) return false; else return true;
	  }set;}
	  //method to check and disable next and end button according to counter value 
	  public Boolean disableNext {get{ 
	                if (counter + list_size < total_size) return false; else return true;
	  }set;}
	
	     //method to get current visible page no  among all available pages of records
	  public Integer pageNumber {get{
	               return counter/list_size + 1;
	  }set;}
	  public void sortTable() {
	        if(sortbyField == null)
	            {
					sortDirection = 'DESC';
	            }
	        else
	            {
					if(sortDirection.equals('ASC'))
						{
							sortDirection = 'DESC';
					}
	            else
					{
						sortDirection = 'ASC';
					}
	        }
			prepareTable();
    	}
    	public void changePage() {
                 counter = (integer.valueOf(showpage)-1)*list_size;
                 prepareTable();
    	}
		public class ColumnData{
	  		public String name{get;set;}
	  		public String label{get;set;}
	  		public ColumnData(String name,String label){
	  			this.name = name;
	  			this.label= label;
	  		}
		}	
  }