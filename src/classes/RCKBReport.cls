public class RCKBReport {
public transient List<KBWrapper> lstKBArticleDetail{get;set;}
public string xmlheader {get;set;}
public string endfile{get;set;}  
public String docContentType {get;set;} 
  
public RCKBReport(){
	         xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
            endfile = '</Workbook>';   
	
	
	lstKBArticleDetail=new List<KBWrapper>();
	lstKBArticleDetail=getAllArticleDetail();
 }

public List<KBWrapper> getAllArticleDetail(){
	 List<KBWrapper> objList = new List<KBWrapper>();
	 Set<String> setArticleId=new Set<String>();
	 Map<String,KBWrapper> mapKBDetail=new  Map<String,KBWrapper>();
	 List<KBWrapper> lstArticleList=new List<KBWrapper>();
	
	  for(RC_Knowledge_Article__DataCategorySelection objdata:[Select r.Parent.ArticleNumber,r.Parent.KnowledgeArticleId, r.ParentId,
                                                               r.DataCategoryGroupName,r.DataCategoryName  From RC_Knowledge_Article__DataCategorySelection r 
                                                               where r.Parent.PublishStatus='Online']){
           setArticleId.add(objdata.ParentId);                        	
         if(mapKBDetail.get(objdata.ParentId)==null){
         	KBWrapper objKbDetail=new KBWrapper();
         	setDataCategoryDetail(objKbDetail,objdata,false);
         	mapKBDetail.put(objdata.ParentId,objKbDetail);
         }else{
			KBWrapper objKbDetail=mapKBDetail.get(objdata.ParentId);
			setDataCategoryDetail(objKbDetail,objdata,true);
		}
         
      }
     /* Select r.UrlName, r.Title,r.KnowledgeArticleId,r.LastPublishedDate,r.Ranking__c From RC_Knowledge_Article__kav r  where PublishStatus='Online'
                                       AND id IN:setArticleId AND IsVisibleInPkb = true ORDER BY r.Ranking__c,LastPublishedDate DESC]*/
	for(RC_Knowledge_Article__kav obj: [Select ArticleNumber,r.UrlName, r.Title, r.Ranking__c, r.LastPublishedDate, r.LastModifiedDate, r.LastModifiedBy.Name, 
		                                r.LastModifiedById, r.KnowledgeArticleId, r.Key_Words__c, r.IsVisibleInPkb, r.IsVisibleInCsp, 
		                                r.IsVisibleInApp, r.FirstPublishedDate, r.CreatedDate, r.CreatedBy.Name, r.CreatedById
		                                From RC_Knowledge_Article__kav r  where PublishStatus='Online'
                                        AND id IN:setArticleId AND IsVisibleInPkb = true ORDER BY r.Ranking__c,LastPublishedDate DESC]){ 
		                                
		
		/*if(mapKBDetail.get(obj.KnowledgeArticleId)==null){
			KBWrapper objKbDetail=new KBWrapper();
			setArticleDetail(objKbDetail,obj,false);
			mapKBDetail.put(obj.KnowledgeArticleId,objKbDetail);
		}else{
			KBWrapper objKbDetail=mapKBDetail.get(obj.KnowledgeArticleId);
			setArticleDetail(objKbDetail,obj,true);
		}*/
		KBWrapper objKbDetail=mapKBDetail.get(obj.id);
		setArticleObjectDetail(objKbDetail,obj);
		lstArticleList.add(objKbDetail);
		
	}
	return lstArticleList;
}


public void setDataCategoryDetail(KBWrapper objKbDetail,RC_Knowledge_Article__DataCategorySelection objdata,Boolean isKBFound){
	if(!isKBFound){
		//objKbDetail.objKB=objdata;
	}
	if(objdata.DataCategoryGroupName=='Brand'){
		objKbDetail.lstBrand.add(objdata.DataCategoryName);
		objKbDetail.strBrand=(objKbDetail.strBrand==''?'':objKbDetail.strBrand+',')+objdata.DataCategoryName;
	}
	if(objdata.DataCategoryGroupName=='RCProductVesion'){
		objKbDetail.lstProductVersion.add(objdata.DataCategoryName);
		objKbDetail.strProductVersion=(objKbDetail.strProductVersion==''?'':objKbDetail.strProductVersion+',')+objdata.DataCategoryName;
	}
	if(objdata.DataCategoryGroupName=='Topic'){
		objKbDetail.lstTopic.add(objdata.DataCategoryName);
		objKbDetail.strTopic=(objKbDetail.strTopic==''?'':objKbDetail.strTopic+',')+objdata.DataCategoryName;
	}
	
}
public void setArticleObjectDetail(KBWrapper objKbDetail,RC_Knowledge_Article__kav objdata){
	objKbDetail.objKB=objdata;	
}

   public Pagereference downloadCSV(){
       try{
           lstKBArticleDetail=getAllArticleDetail();
            docContentType = 'application/vnd.ms-excel#KB-Report-'+String.valueOf(system.now().format())+'.xls';
            //pageReference pg = Page.Sim_CaseSummaryReportDownLoadExcel;
            pageReference pg = Page.KBReportDownLoadExcel;        
            return pg;
        }catch(Exception e){
            System.debug('Exception:'+e.getMessage());
            return null;
        }
   }
   

public class KBWrapper{
	public RC_Knowledge_Article__kav objKB{get;set;}
	public List<String> lstBrand{get;set;}
	public List<String> lstProductVersion{get;set;}
	public List<String> lstTopic{get;set;}
	public String strBrand{get;set;}
	public String strProductVersion{get;set;}
	public String strTopic{get;set;}
	
	public KBWrapper(){
		lstBrand=new List<String>();
		lstProductVersion=new List<String>();
		lstTopic=new List<String>();
		strBrand=strProductVersion=strTopic='';
	}
	
}



}