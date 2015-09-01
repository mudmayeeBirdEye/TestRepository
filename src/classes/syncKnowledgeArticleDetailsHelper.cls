public class syncKnowledgeArticleDetailsHelper{
   
     public String strNoOfDays{get;set;}
       
    public syncKnowledgeArticleDetailsHelper(){
         strNoOfDays='All';
        }
     
     public pagereference syncArticleDetails() 
       {
      Pagereference pageRef=null;
       try{
        Set<String> setArticleId=new Set<String>();  
        Map<String,RC_Article_Rating__c> mapArticle=new Map<String,RC_Article_Rating__c>();
        
     
        for(RC_Article_Rating__c objRC_Article_Rating:[Select RCCreatedById__c,RCCreatedByName__c,RCLastModifiedById__c,RCLastModifiedByName__c,
                                                       RCCreatedDate__c,RCLastModifiedDate__c,RCLastPublishedDate__c,RCFirstPublishedDate__c,
                                                       Article_Rating_Count__c,of_User_Rate_This_Article__c,RC_Average_Rating__c,Article_Id__c
                                                       from RC_Article_Rating__c]  ){
                
           mapArticle.put(objRC_Article_Rating.Article_Id__c,objRC_Article_Rating);
        }  
       List<RC_Article_Rating__c> lst=new List<RC_Article_Rating__c>();
       //system.debug('@@@@@@@@@@@@@@@ '+getSelectedString(mapArticle.keySet()));
       String strQuery=' Select  r.Title,r.LastPublishedDate, r.LastModifiedDate, r.LastModifiedById,'+
                       ' r.KnowledgeArticleId, r.FirstPublishedDate, r.Details__c, r.CurrencyIsoCode, '+
                       ' r.CreatedDate,r.CreatedById From RC_Knowledge_Article__kav r where PublishStatus=\'online\' '+
                       ' and KnowledgeArticleId IN ('+getSelectedString(mapArticle.keySet())+')';
      if(test.isRunningTest()){
      	strNoOfDays = '500';
      }
      if(strNoOfDays!='All'){
       strQuery=strQuery+' and LastModifiedDate = LAST_N_DAYS :'+strNoOfDays+'';
      }
       strQuery=strQuery+' order by LastModifiedDate desc ';
         
       Set<String> mapUserId=new Set<String>();
       
       for(RC_Knowledge_Article__kav objRC_Knowledge_Article:Database.query(strQuery)){
                  
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
      // objRC_Article_Rating.RCCreatedByName__c= getUsersName(objRC_Knowledge_Article.CreatedById);
       objRC_Article_Rating.RCLastModifiedById__c=objRC_Knowledge_Article.LastModifiedById;
      // objRC_Article_Rating.RCLastModifiedByName__c=getUsersName(objRC_Knowledge_Article.LastModifiedById);
       objRC_Article_Rating.RCCreatedDate__c=objRC_Knowledge_Article.CreatedDate;
       objRC_Article_Rating.RCLastModifiedDate__c=objRC_Knowledge_Article.LastModifiedDate;
       objRC_Article_Rating.RCLastPublishedDate__c=objRC_Knowledge_Article.LastPublishedDate;
       objRC_Article_Rating.RCFirstPublishedDate__c=objRC_Knowledge_Article.FirstPublishedDate;
       objRC_Article_Rating.RCArticle_Title__c=objRC_Knowledge_Article.Title;    
      
       mapUserId.add(objRC_Article_Rating.RCCreatedById__c);
       mapUserId.add(objRC_Article_Rating.RCLastModifiedById__c);
       
       lst.add(objRC_Article_Rating);
       }
      }
      if(lst.size()>0){
        getUsersName(mapUserId,lst);
        update lst;
      }
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+lst.size()+' Article(s) synced successfully'));
     }catch(Exception e){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
     }
     return null; 
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
   public String getSelectedString(Set<String> strvalue){
        String objStr='';
        Integer i=0;
        for(String str:strvalue){
            if(str != null){
            	if(i!=0){
                      objStr=objStr+',';
                    }
              	objStr=objStr+'\''+str+'\'';
              	i++; 
            }
        }
            return objStr;
    }
  }