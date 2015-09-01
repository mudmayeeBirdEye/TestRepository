global class syncKnowledgeArticleDetails implements Schedulable {
   
     global void execute(SchedulableContext ctx) 
       {
       try{
            Set<String> setArticleId=new Set<String>();  
            Map<String,RC_Article_Rating__c> mapArticle=new Map<String,RC_Article_Rating__c>();
             Set<String> setUserId=new Set<String>();
        
            for(RC_Article_Rating__c objRC_Article_Rating:[Select RCCreatedById__c,RCCreatedByName__c,RCLastModifiedById__c,RCLastModifiedByName__c,
                                                       RCCreatedDate__c,RCLastModifiedDate__c,RCLastPublishedDate__c,RCFirstPublishedDate__c,
                                                       Article_Rating_Count__c,of_User_Rate_This_Article__c,RC_Average_Rating__c,Article_Id__c
                                                       from RC_Article_Rating__c]  ){
                
           mapArticle.put(objRC_Article_Rating.Article_Id__c,objRC_Article_Rating);
        }  
       List<RC_Article_Rating__c> lst=new List<RC_Article_Rating__c>();
       Date d = System.today() - 7;
       if(test.isRunningTest()){
       	d = System.today()-500;
       }
       //system.debug('@@@@@@@@ This is it ');
       for(RC_Knowledge_Article__kav objRC_Knowledge_Article:[Select  r.Title,r.LastPublishedDate, r.LastModifiedDate, r.LastModifiedById, r.KnowledgeArticleId, r.FirstPublishedDate, r.Details__c, r.CurrencyIsoCode, r.CreatedDate,
                                                              r.CreatedById From RC_Knowledge_Article__kav r where PublishStatus='online' 
                                                              and KnowledgeArticleId IN :mapArticle.keySet()
                                                              and LastModifiedDate >= :d order by LastModifiedDate desc]){  
    
      //system.debug('@@@@@@@@ This is it '+objRC_Knowledge_Article.LastModifiedDate);
      String KnowledgeArticleId=objRC_Knowledge_Article.KnowledgeArticleId;
      Integer len=(String.valueOf(objRC_Knowledge_Article.KnowledgeArticleId)).length();
      Integer len2=0;
      if(KnowledgeArticleId.length()>15){
         len2=len-15;
      }
      KnowledgeArticleId=KnowledgeArticleId.subString(0,len-len2);
      
      if(mapArticle.get(KnowledgeArticleId)!=null){
      
       RC_Article_Rating__c  objRC_Article_Rating=mapArticle.get(KnowledgeArticleId);
       objRC_Article_Rating.RCCreatedById__c=objRC_Knowledge_Article.CreatedById;
       //objRC_Article_Rating.RCCreatedByName__c= getUsersName(objRC_Knowledge_Article.CreatedById);
       objRC_Article_Rating.RCLastModifiedById__c=objRC_Knowledge_Article.LastModifiedById;
       //objRC_Article_Rating.RCLastModifiedByName__c=getUsersName(objRC_Knowledge_Article.LastModifiedById);
       objRC_Article_Rating.RCCreatedDate__c=objRC_Knowledge_Article.CreatedDate;
       objRC_Article_Rating.RCLastModifiedDate__c=objRC_Knowledge_Article.LastModifiedDate;
       objRC_Article_Rating.RCLastPublishedDate__c=objRC_Knowledge_Article.LastPublishedDate;
       objRC_Article_Rating.RCFirstPublishedDate__c=objRC_Knowledge_Article.FirstPublishedDate;
       objRC_Article_Rating.RCArticle_Title__c=objRC_Knowledge_Article.Title;    
       
       setUserId.add(objRC_Article_Rating.RCCreatedById__c);
       setUserId.add(objRC_Article_Rating.RCLastModifiedById__c);
       
       lst.add(objRC_Article_Rating);
       }
      }
      if(lst.size()>0){
        getUsersName(setUserId,lst);
       update lst;
      }
      }catch(Exception e){}
    } 
    public String getUsersName(Set<String> id, List<RC_Article_Rating__c> lst){
      String strname='';
       try{
            Map<String,String> mapName=new Map<String,String>();
          
           for(User u:[Select id,u.Name From User u where id IN:id]){
               mapName.put(u.id,u.Name);
               }
           for(RC_Article_Rating__c obj:lst){    
           obj.RCCreatedByName__c=mapName.get(obj.RCCreatedById__c);
           obj.RCLastModifiedByName__c=mapName.get(obj.RCLastModifiedById__c);
           }
               
        }catch(Exception e){
           system.debug('>>>>>>'+e.getMessage());     
         }
      return strname;
   }
 
  }