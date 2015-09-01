public with sharing class RCArticleRatingDetails {

   public List<SelectOption> listUser{get;set;}
   public String strTitle{get;set;}
   public String strcreatedBy{get;set;}
   public String strModifiedBy{get;set;}
    public ApexPages.StandardSetController con {get; set;} 
    public List<RC_Article_Rating__c> enh {get;set;}
    
    public RCArticleRatingDetails (){
         strTitle='';
	    strcreatedBy='None';
	    strModifiedBy='None';
	    listUser=new List<SelectOption>();
	    Map<String,String> mapUser=new   Map<String,String>();
    
     for(RC_Article_Rating__c obj:[Select RCCreatedById__c,RCCreatedByName__c,RCLastModifiedById__c,RCLastModifiedByName__c,
                                       RCCreatedDate__c,RCLastModifiedDate__c,RCLastPublishedDate__c,RCFirstPublishedDate__c,
                                       RCArticle_Title__c,name,of_User_Rate_This_Article__c,
                                       Article_Id__c,Article_Rating_Count__c,RC_Average_Rating__c from RC_Article_Rating__c]){
     mapUser.put(obj.RCCreatedById__c,obj.RCCreatedByName__c);
     mapUser.put(obj.RCLastModifiedById__c,obj.RCLastModifiedByName__c);
     }
      listUser.add(new SelectOption('None','---None--'));  
     for(String str:mapUser.keySet()){
      listUser.add(new SelectOption(str,mapUser.get(str)));  
     }
     
     showArticleDetails();
    }
    
    public void showArticleDetails(){
    String strQuery='Select RCCreatedById__c,RCCreatedByName__c,RCLastModifiedById__c,RCLastModifiedByName__c,'+
                        ' RCCreatedDate__c,RCLastModifiedDate__c,RCLastPublishedDate__c,RCFirstPublishedDate__c, '+
                        ' RCArticle_Title__c,name,of_User_Rate_This_Article__c,'+
                        '  Article_Id__c,Article_Rating_Count__c,RC_Average_Rating__c from RC_Article_Rating__c where id!=null';
    
      if(strTitle!=null && strTitle!=''){
       //strQuery=strQuery+' and RCArticle_Title__c=\''+strTitle+'\'';
      }
     if(strcreatedBy!='None'){
          strQuery=strQuery+' and RCCreatedById__c=\''+strcreatedBy+'\'';
      }
      if(strModifiedBy!='None'){
         strQuery=strQuery+' and RCLastModifiedById__c=\''+strModifiedBy+'\'';
      }
     strQuery=strQuery+' order by  RC_Average_Rating__c desc';
     enh = new List<RC_Article_Rating__c>();
     
   /* List<RC_Article_Rating__c> enh2 = [Select RCCreatedById__c,RCCreatedByName__c,RCLastModifiedById__c,RCLastModifiedByName__c,
                                       RCCreatedDate__c,RCLastModifiedDate__c,RCLastPublishedDate__c,RCFirstPublishedDate__c,
                                       RCArticle_Title__c,name,of_User_Rate_This_Article__c,
                                       Article_Id__c,Article_Rating_Count__c,RC_Average_Rating__c from RC_Article_Rating__c ];  */
                                           
    List<RC_Article_Rating__c> enh2 =new  List<RC_Article_Rating__c>();
          try{
               enh2=Database.query(strQuery);
            }catch(Exception e){
              enh2 = [Select RCCreatedById__c,RCCreatedByName__c,RCLastModifiedById__c,RCLastModifiedByName__c,
                                       RCCreatedDate__c,RCLastModifiedDate__c,RCLastPublishedDate__c,RCFirstPublishedDate__c,
                                       RCArticle_Title__c,name,of_User_Rate_This_Article__c,
                                       Article_Id__c,Article_Rating_Count__c,RC_Average_Rating__c from RC_Article_Rating__c ];
             }    
    
     con = new ApexPages.StandardSetController(enh2);
     con.setPageSize(25);
        for(RC_Article_Rating__c obj: (List<RC_Article_Rating__c>)con.getRecords()) {
            enh.add(obj);
        }
   
   
   
    }
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            if(con!=null){
                return con.getHasNext();
            }
            else return false;
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            if(con!=null)
                return con.getHasPrevious(); 
            else return false;
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
    public void first() {
        con.first();
        enh.clear();
        for(RC_Article_Rating__c obj: (List<RC_Article_Rating__c>)con.getRecords()) {
            enh.add(obj);
        }
    }

    // returns the last page of records
    public void last() {
        con.last();
        enh.clear();
        for(RC_Article_Rating__c obj: (List<RC_Article_Rating__c>)con.getRecords()) {
            enh.add(obj);
        }
    }

    // returns the previous page of records
    public void previous() {
        con.previous();
        enh.clear();
        for(RC_Article_Rating__c obj: (List<RC_Article_Rating__c>)con.getRecords()) {
            enh.add(obj);
        }
    }

    // returns the next page of records
    public void Next() {
        con.next();
        enh.clear();
        for(RC_Article_Rating__c obj: (List<RC_Article_Rating__c>)con.getRecords()) {
            enh.add(obj);
        }
    }
/* public static testmethod void test() {
    try{
      RCArticleRatingDetails  objRCArticleRatingDetails  =new RCArticleRatingDetails();
       Boolean b;
       b=objRCArticleRatingDetails.hasNext;
       b=objRCArticleRatingDetails.HasPrevious;
        Integer i=objRCArticleRatingDetails.PageNumber;
        objRCArticleRatingDetails.first();
        objRCArticleRatingDetails.last() ;
        objRCArticleRatingDetails.previous();
        objRCArticleRatingDetails.Next();
          
    }catch(Exception e){}
  
  }*/
    
  
    
    

}