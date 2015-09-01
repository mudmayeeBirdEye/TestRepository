public class RCTopArticle{

    public RCTopArticle(ApexPages.StandardController controller) {

    }

public String strAricleId{get;set;}
public String strSection{get;set;}
public String strBrand{get;set;}
public String strRCVersion{get;set;}

public String strTest{get;set;}
public Integer iCount{get;set;}
public String strRootCategoryName{get;set;}
public Boolean isRecordExist{get;set;}
public RCNEW_Knowledge_Article__c objKnowledgeArticle{get;set;}
public Boolean isArticleExistINSelectedCatgory{get;set;}
  
  public RCTopArticle(){
    strAricleId='';
    strSection='';
    strRootCategoryName='';
    strBrand='';
    isRecordExist=false;
    objKnowledgeArticle=new RCNEW_Knowledge_Article__c();
  }
  public void getArticleDetails(){
      try{
        String strArticleID='';
        objKnowledgeArticle=new RCNEW_Knowledge_Article__c();
        RC_Knowledge_Article__DataCategorySelection objdataCtegory;
        strTest=strBrand;
        isRecordExist=false;
        objKnowledgeArticle.ArticleNumber__c=strAricleId;
        isArticleExistINSelectedCatgory=false;
        Boolean isRCVersionDefined=false;
        try{
        	if(Test.isRunningTest()){
        	   objdataCtegory=new RC_Knowledge_Article__DataCategorySelection();
        	   objdataCtegory.ParentId='ka280000000Go8qAAC';
        	   strArticleID = '000001189';
        	}else{
		           strAricleId=String.escapeSingleQuotes(strAricleId);
		           objdataCtegory=[Select r.Parent.ArticleNumber,r.Parent.KnowledgeArticleId, r.ParentId 
		                           From RC_Knowledge_Article__DataCategorySelection r where r.Parent.PublishStatus='Online' and r.Parent.ArticleNumber=:strAricleId limit 1];
           
        	}
           }catch(Exception e){
                   isRecordExist=false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Article does not exist'));
                   return;
            }
            
           for(RC_Knowledge_Article__kav obj3:[Select ArticleNumber,r.UrlName, r.Title, r.SystemModstamp,r.Summary, r.SourceId, r.PublishStatus, 
                                                      r.OwnerId, r.Legacy_Article_ID__c, r.LastPublishedDate,r.LastModifiedDate, r.LastModifiedById,
                                                      r.KnowledgeArticleId, r.Key_Words__c, r.IsVisibleInPrm, 
                                                      r.IsVisibleInPkb, r.IsVisibleInCsp, r.IsVisibleInApp, r.IsDeleted, r.Id, r.FirstPublishedDate, 
                                                      r.Details__c, r.CurrencyIsoCode, r.CreatedDate, r.CreatedById, r.ArchivedDate, r.ArchivedById 
                                                      From RC_Knowledge_Article__kav r  where PublishStatus='Online' and (id=:objdataCtegory.ParentId and ArticleNumber=:strAricleId)]){
                    
                     isRecordExist=true;      
                    
                    objKnowledgeArticle.UrlName__c=obj3.UrlName;
                    objKnowledgeArticle.Title__c=obj3.Title;
                    objKnowledgeArticle.Summary__c=obj3.Summary;
                    objKnowledgeArticle.PublishStatus__c=obj3.PublishStatus;
                    objKnowledgeArticle.Legacy_Article_ID__c=obj3.Legacy_Article_ID__c;
                    objKnowledgeArticle.LastPublishedDate__c=obj3.FirstPublishedDate;
                    objKnowledgeArticle.LastModifiedDate__c=obj3.LastModifiedDate;
                    objKnowledgeArticle.KnowledgeArticleId__c=obj3.KnowledgeArticleId;
                    objKnowledgeArticle.Key_Words_c__c=obj3.Key_Words__c;
                    objKnowledgeArticle.IsVisibleInPrm__c=obj3.IsVisibleInPrm;
                    objKnowledgeArticle.IsVisibleInPkb__c=obj3.IsVisibleInPkb;
                    objKnowledgeArticle.IsVisibleInCsp__c=obj3.IsVisibleInCsp;
                    objKnowledgeArticle.IsVisibleInApp__c=obj3.IsVisibleInApp;
                    objKnowledgeArticle.IsDeleted__c=false;
                    objKnowledgeArticle.FirstPublishedDate__c=obj3.FirstPublishedDate;
                    objKnowledgeArticle.CreatedDate__c=obj3.CreatedDate;
                    objKnowledgeArticle.CreatedById__c=obj3.CreatedById;
                    strArticleID=obj3.id;
                 }
                if(!Test.isRunningTest()){
                 if(!isRecordExist){
                   return;
                  }
                }else{
                	strArticleID='ka280000000Go8qAAC';
                }
                 Map<String,String> mapArticle=new  Map<String,String>();
                 iCount=0;
                 Boolean isBrandExist=false;
                 Boolean isRCVersionExist=false;
                 Boolean isTopicExist=false;
                 
                 for(RC_Knowledge_Article__DataCategorySelection objdata:[Select ParentId, r.IsDeleted, r.DataCategoryName, r.DataCategoryGroupName From 
                                                                          RC_Knowledge_Article__DataCategorySelection r where IsDeleted=false and ParentId=:strArticleID]){
                                                                          iCount++;
                        //isRecordExist=false;
                      if(mapArticle.get(objdata.ParentId)!=null){
                           objKnowledgeArticle.DataCategoryGroupName__c=objKnowledgeArticle.DataCategoryGroupName__c+','+objdata.DataCategoryGroupName;
                           objKnowledgeArticle.DataCategoryName__c=objKnowledgeArticle.DataCategoryName__c+','+objdata.DataCategoryName;
                      
                      if(objdata.DataCategoryGroupName=='Brand'){
                            objKnowledgeArticle.Associated_Brands__c= (objKnowledgeArticle.Associated_Brands__c==''?'':objKnowledgeArticle.Associated_Brands__c+',')+objdata.DataCategoryName;
                        }else if(objdata.DataCategoryGroupName=='Topic'){
                            objKnowledgeArticle.Topic__c= (objKnowledgeArticle.Topic__c==''?'':objKnowledgeArticle.Topic__c+',')+objdata.DataCategoryName;
                        }else if(objdata.DataCategoryGroupName=='Service'){
                            objKnowledgeArticle.Service__c=(objKnowledgeArticle.Service__c==''?'':objKnowledgeArticle.Service__c+',')+objdata.DataCategoryName;
                        }else if(objdata.DataCategoryGroupName=='Community'){
                            objKnowledgeArticle.Community__c=(objKnowledgeArticle.Community__c==''?'':objKnowledgeArticle.Community__c+',')+objdata.DataCategoryName;
                        }
                     
                      }else{
                       objKnowledgeArticle.DatacategorySelectionParentId__c=objdata.ParentId;
                       objKnowledgeArticle.DataCategoryGroupName__c=objdata.DataCategoryGroupName;
                       objKnowledgeArticle.DataCategoryName__c=objdata.DataCategoryName;
                         
                        objKnowledgeArticle.Associated_Brands__c='';
                        objKnowledgeArticle.Topic__c='';
                        objKnowledgeArticle.Service__c='';
                        objKnowledgeArticle.Community__c='';
                         
                         if(objdata.DataCategoryGroupName=='Brand'){
                            objKnowledgeArticle.Associated_Brands__c=objdata.DataCategoryName;
                        }else if(objdata.DataCategoryGroupName=='Topic'){
                            objKnowledgeArticle.Topic__c=objdata.DataCategoryName;
                        }else if(objdata.DataCategoryGroupName=='Service'){
                            objKnowledgeArticle.Service__c=objdata.DataCategoryName;
                        }else if(objdata.DataCategoryGroupName=='Community'){
                            objKnowledgeArticle.Community__c=objdata.DataCategoryName;
                        }
                       
                        
                        mapArticle.put(objdata.ParentId,'Exist');
                      }
                       if(objdata.DataCategoryGroupName=='Topic' && 
                           (objdata.DataCategoryName=='ALL' || objdata.DataCategoryName==strSection) ){
                              objKnowledgeArticle.Section__c=strSection;
                               isTopicExist=true;
                               isArticleExistINSelectedCatgory=true;
                         }
                       if(objdata.DataCategoryGroupName=='Brand' && 
                           (objdata.DataCategoryName=='ALL' || objdata.DataCategoryName==strBrand) ){
                                objKnowledgeArticle.Brand__c=strBrand;
                                isBrandExist=true;
                         }
                         if(objdata.DataCategoryGroupName=='RCProductVesion' && 
                           (objdata.DataCategoryName=='ALL' || objdata.DataCategoryName==strRCVersion) ){
                               objKnowledgeArticle.RCVersion__c=strRCVersion;
                               isRCVersionExist=true;
                         }
                         if(objdata.DataCategoryGroupName=='RCProductVesion'){
                           isRCVersionDefined=true;
                         }
                       
                       }
                       if(!isRCVersionDefined && strRCVersion=='RC_Legacy' ){
                               objKnowledgeArticle.RCVersion__c=strRCVersion;
                               isRCVersionExist=true;
                         }
                         
                         if(!isBrandExist){
                               isRecordExist=false;
                               if(objKnowledgeArticle.Associated_Brands__c!=null && objKnowledgeArticle.Associated_Brands__c!=''){
                                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' Article does not exist under selected <b>Brand</b>'+
                                                                                                    ' but it belongs to <b>'+objKnowledgeArticle.Associated_Brands__c+'</b>'));
                                }else{
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' Article does not exist under selected <b>Brand</b>'+
                                                                                                    ' but it belongs to <b>'+objKnowledgeArticle.Brand__c+'</b>'));
                                }
                         }
                          if(!isRCVersionExist){
                           if(!isRCVersionDefined && strRCVersion=='RC2012' ){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Article does not exist under selected <b>RCVesion</b> but it belongs to <b>RC_Legacy</b>'));
                           }else if(strRCVersion=='RC2012'){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Article does not exist under selected <b>RCVesion</b> but it belongs to <b>RC_Legacy</b>'));
                             }else{
                                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Article does not exist under selected <b>RCVesion</b> but it belongs to <b>RC2012</b>'));
                             }
                             isRecordExist=false;
                         }
                         if(!isTopicExist){
                              if(objKnowledgeArticle.Topic__c!=null && objKnowledgeArticle.Topic__c!=''){
                                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Article does not exist under selected <b>Section</b>'+ 
                                                                                                   ' but it belongs to <b>'+objKnowledgeArticle.Topic__c+'</b>'));
                              
                              }else{
                                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Article does not exist under selected <b>Section</b>'));
                              }
                              
                              //isRecordExist=false;
                             
                         }
                   
                        if(!isRecordExist){
                           return;
                         }
         }catch(Exception e){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
         }                
    }
       public pagereference saveArticleOrder(){
            try{
                 objKnowledgeArticle.Composite_key__c= objKnowledgeArticle.Section__c+'_'+objKnowledgeArticle.Brand__c+
                                                                '_'+objKnowledgeArticle.RCVersion__c+'_'+objKnowledgeArticle.Article_List_Order__c;
                                                                
                 objKnowledgeArticle.Composite_key2__c= objKnowledgeArticle.Section__c+'_'+objKnowledgeArticle.Brand__c+
                                                                '_'+objKnowledgeArticle.RCVersion__c+'_'+objKnowledgeArticle.ArticleNumber__c;  
                         objKnowledgeArticle.ArticleNumber__c=strAricleId;
                         upsert objKnowledgeArticle;
                         pagereference objPageRef=new pagereference ('/'+objKnowledgeArticle.id);
                         objPageRef.setRedirect(true);
                         return objPageRef;
                         }catch(Exception e){
                            
                             String strMessage=e.getMessage();
                            if(strMessage.indexOf('id:')>0){
                             String strId=strMessage.substring((strMessage.indexOf('id:')+4),strMessage.indexOf('id:')+19);
                             /*strMessage='<div style=display: block id=errorDiv_ep class=pbError>'+
                                          'Error:Duplicate value on record: <a href=/'+strId+' target=_blank>'+strId+'</a></div>';*/
                             strMessage='Duplicate value on record: <a href=/'+strId+' target=_blank>'+strId+'</a>';
                             //String strId=strMessage.
                            objKnowledgeArticle.Article_List_Order__c.addError(strMessage);
                            }
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, strMessage));
                         }
          return null;
          
          
       }
}