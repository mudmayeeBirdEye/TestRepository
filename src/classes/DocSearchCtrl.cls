//@RestResource(urlMapping='/v.9/member/*/results/*') 
global with sharing class DocSearchCtrl {
    
    
   /* public Boolean isLoggedIn{get;set;}
    public Boolean blankSearchText{get;set;}
    public String searchText {get;set;}
    public string loginUrl {get;set;}*/
    
    /*** Library Search Variables ***/
   /* public Boolean recordSize{get;set;}
    public List<InnerView> innerViewList {get;set;}
    public List<LibSearchViewWrapper>  libList {get;set;}*/
    /********************************/
    
    /********** Document Search Variables *********/
  //  public List<DocumentChildNode> listViewDox{get;set;}
    /**********************************************/
   /* public String searchTextNew {get;set;}
    public PageReference searchContentNew() {
        isLoggedIn = false;
        blankSearchText = false;
        innerViewList = new List<InnerView>();
        listViewDox = new List<DocumentChildNode>();
        recordSize = false;
        searchText = searchTextNew;
        searchContent();
        return null;
    }
    public PageReference searchContent() {
        try {
        isLoggedIn = LoginTokenSetter.getLoggedInStatus();
        blankSearchText = false;
            if(isLoggedIn != null && isLoggedIn == true ) {
                if(searchText != null && searchText.trim() != ''){
                    // get doc search
                    // get library search
                    getDocumentRecords();
                    //getLibrarySearchResults();
                    getLibrarySoslRecords();
                    blankSearchText = false;
                } else {
                    blankSearchText = true;
                }
            } else {
            	getLoginUrl();
                blankSearchText = false;
                isLoggedIn = false;
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+','+ e.getLineNumber()));
        }
        return null;
    }
    
    public PageReference getLoginUrl() {
		try {
			IntranetPortal__c intPortalCS = IntranetPortal__c.getValues('portalsite');
			if(intPortalCS != null && intPortalCS.token__c != null && intPortalCS.orgURL__c != null && intPortalCS.SiteURL__c != null) {
	    		String token = intPortalCS.token__c;
	    		string orgURL = intPortalCS.orgURL__c;
	    		string returnURL = 	intPortalCS.SiteURL__c;
	        	loginUrl = orgURL+token+returnURL;
			}
		} catch(Exception ex) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Set/Check your Intranet Portal Site Custom Settings'));
    	}
    	return null;
	}*/

    public DocSearchCtrl(){
        /*isLoggedIn = false;
        blankSearchText = false;
        searchText = ApexPages.currentPage().getParameters().get('srch');
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' == ' + searchText));
        innerViewList = new List<InnerView>();
        libList = new List<LibSearchViewWrapper>();
        listViewDox = new List<DocumentChildNode>();
        recordSize = false;
        searchContent();*/
    }
    
    /*public String getLibrarySearchResults() {
        String json;
        try {
              if(LoginTokenSetter.accessTokenValue != null && LoginTokenSetter.accessTokenValue != '' && LoginTokenSetter.instanceUrl != null && LoginTokenSetter.instanceUrl != '') {
                  // strsearchText =  strsearchText.trim();    
                  HttpRequest req = new HttpRequest();
                  Http http = new Http();
                  req.setMethod('GET');
                  req.setHeader('Authorization', 'OAuth ' + LoginTokenSetter.accessTokenValue);
                  String temp = searchText.trim();
                  // temp = temp.replaceAll(' ', '%20');
                  temp = EncodingUtil.urlEncode(temp, 'UTF-8');
                  String url = LoginTokenSetter.instanceUrl+'/services/data/v24.0/query/?q=SELECT+title+,+OwnerId+,Owner.Name+from+ContentDocument+where+Title+like+' +'\''+ '%25' + String.escapeSingleQuotes(temp) + '%25' +'\'';
                  req.setEndpoint(url);
                  HTTPResponse resp = http.send(req);
                  json = resp.getBody();
               
                  if(json != null && json != '') {
                      createLibraryView(json);
                   
                  }
              }
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+','+ ex.getLineNumber()+','+ json));
        }
        return null;
   }*/
   /* public void createLibraryView(String strJson) {
          System.debug('-------007------------>'+strJson);   
       try {
           innerViewList = new List<InnerView>();
           JSONParser parser = System.JSON.createParser(strJson);
           InnerJsonParse innerJsonParseObj = (InnerJsonParse)parser.readValueAs(InnerJsonParse.class);
           if(innerJsonParseObj != null && Integer.valueOf(innerJsonParseObj.totalSize) > 0) {
               for(InnerJsonParseRecords innerRecordObj: innerJsonParseObj.records) {
                   InnerView innerViewObj = new InnerView();
                   innerViewObj.title = innerRecordObj.Title;
                   InnerJsonParseOwner ownerObj  = innerRecordObj.Owner;
                   innerViewObj.ownername = ownerObj.Name;
                   innerViewList.add(innerViewObj);
               }
           }
           if(innerViewList != null && innerViewList.size() >0) {
               recordSize = true;
           } else {
                recordSize = false;   
           } 
       } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+','+ ex.getLineNumber()));
       }
   }*/ 
  /* public void getDocumentRecords() {
        listViewDox = new List<DocumentChildNode>();
        String jsonData;
        try {
            
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth ' + LoginTokenSetter.accessTokenValue);
        String strFinal = getReplacedString(searchText.trim());
        String url1 =  LoginTokenSetter.instanceUrl+'/services/data/v20.0/search/?q=FIND'+ strFinal;
        String url2 = '+IN+ALL+FIELDS+RETURNING+Document(Id,URL,Name,FolderId,DeveloperName,ContentType,AuthorId,CreatedDate,CreatedById)';
        req.setEndPoint( url1 + url2 );
        HTTPResponse resp = http.send(req);
        jsonData = resp.getBody();
        
            if(resp.getStatus() == 'Ok' && resp.getStatusCode() == 200) {
                createDocView(jsonData);
            } else if(resp.getStatusCode() == 400) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please refine the Search Criteria & search again.'));       
            } else if(resp.getStatusCode() == 401) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'UnAuthorized. Please login again.'));           
            }
        
        }   catch(Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+','+ ex.getLineNumber() +','+ jsonData));   
        }
   }
    public void createDocView(String jsonData) {
        listViewDox = new List<DocumentChildNode>();
        String JSONContent = jsonData;
        System.Debug('>>!@#>>>'+jsonData);
        listViewDox  = (List<DocumentChildNode>)System.Json.deserialize( jsonData ,List<DocumentChildNode>.class);
        setAuthorMap( listViewDox );
    }
    
    public Map<id, User> authorMap { get;set; }
    
    public void setAuthorMap(List<DocumentChildNode> docWrapper){
        Set<ID> uId = new Set<ID>();
        
        if(docWrapper != null && docWrapper.size() > 0){
            for(DocumentChildNode doc :  docWrapper){
                uId.add( doc.AuthorId );
            }
            if( !uId.isEmpty() ){
                authorMap = new Map<id, User>([ Select Name From User Where ID IN: uId]);       
            }
        }   
    }
  
    public class InnerView {
        public String title {get;set;}
        public String ownername {get;set;}
   }
  
   public class InnerJsonParse {
       public String totalSize;                                                                           
       public String done;
       public List<InnerJsonParseRecords> records;
   }
    
   public class InnerJsonParseRecords {
       public String Title;
       public String OwnerId;
       public InnerJsonParseOwner Owner;
       public InnerJsonParseAttributes attributes;
   }
   
   public class InnerJsonParseAttributes {
       public String type;
       public String url;    
   }
   
   public class InnerJsonParseOwner {
       public String Name;
       public InnerJsonParseAttributes attributes;    
   }
  
  public class DocumentParentNode{
        public Integer totalSize;
        public Boolean done;
        public List<DocumentChildNode> records;
        public DocumentParentNode(Integer totalSize, Boolean done){
             this.totalSize = totalSize;
             this.done = done;
             records = new  List<DocumentChildNode>();   
       }
    }
  
  /*Updated For new Jason*/
 // public class DocumentChildNode {
      /*public String Name { get; set;}
        public String Type { get; set;}
        
        public Attribute attributes;
        public DocumentChildNode(String name, String type){
            this.Name = name;
            this.Type = type;
       }*/
       
     /*   public String Name {get; set;}
        public String Id   {get; set;}
        public String Url {get;set;}
        public String FolderId {get;set;}
        public String DeveloperName {get;set;}
        public String ContentType {get;set;} 
        public String AuthorId {get;set;}
        public String CreatedDate {get;set;}
        public String CreatedById {get;set;}
        public Attribute attributes;
        
        public DocumentChildNode(String name, String id, String url, String folderid, String developerName, String contentType, String authorID, String CreatedDate, String CreatedById){
            this.Name = name;
            this.id = id;
            this.Url = url;
            this.FolderId  = folderid;
            this.DeveloperName = developerName;
            this.ContentType = contentType;
            this.AuthorId  = authorID;
            this.CreatedDate = CreatedDate;
            this.CreatedById = CreatedById;
        }
  }
  public class Attribute{
        public String type;
        public String url;
        public Attribute(String type, String url){
            this.type = type;
            this.url = url;  
        }
  }
  
  public String getReplacedString(String strSearch) {
      String strReturn;
      String urlEncode1 = EncodingUtil.urlEncode('{"','UTF-8');
      String urlEncode2 = EncodingUtil.urlEncode('*"}','UTF-8'); 
      String strFinal = String.escapeSingleQuotes(strSearch.trim());
      Pattern charPattern = Pattern.compile('[-?!^~)&|{}+*"(:]');   // ? & | ! { } [ ] ( ) ^ ~ * : \ " ' + -
      Matcher matcher = charPattern.matcher(strFinal);
      while (matcher.find()) {
            System.Debug('Start index: ' + matcher.start());
            System.Debug(' End index: ' + matcher.end());
            System.Debug(matcher.group());
            strFinal = strFinal.Replace(matcher.group(),'\\'+ matcher.group());
            System.Debug('>>str1>>'+strFinal);
        }
      strFinal = EncodingUtil.urlEncode(strFinal, 'UTF-8');
      System.Debug('>>1>>'+strFinal);
      strReturn = urlEncode1 + strFinal + urlEncode2; 
      return strReturn;
  }
  
  public void getLibrarySoslRecords() {
      libList= new List<LibSearchViewWrapper>();
       String jsonSOSL;
       try {
           HttpRequest req1 = new HttpRequest();
           Http http1 = new Http();
           req1.setMethod('GET');
           req1.setHeader('Authorization', 'OAuth ' + LoginTokenSetter.accessTokenValue );
           String url1 = LoginTokenSetter.instanceUrl +'/services/data/v24.0/search/?q=FIND+';
           String url2 = getReplacedString(searchText.trim());
           String url3 = '+IN+ALL+FIELDS+RETURNING+Contentversion(Id,Title,ContentDocumentId,ContentDocument.ParentId,'+
                           'IsLatest,PublishStatus,OwnerId,Owner.Name,LastModifiedById,LastModifiedBy.Name,LastModifiedDate,CreatedDate,CreatedById,CreatedBy.Name,ContentSize,ContentUrl,Description,'+
                           'FirstPublishLocationId,Origin,PathOnClient,ReasonForChange,VersionData,VersionNumber)';
           String url = url1 + url2 + url3;
           System.Debug('>>3>>'+url); 
           req1.setEndpoint(url);
           HTTPResponse resp1 = http1.send(req1);
           jsonSOSL = resp1.getBody();
           if(resp1.getStatus() == 'Ok' && resp1.getStatusCode() == 200) {
               createLibViewSOSL(jsonSOSL);
           } else if(resp1.getStatusCode() == 400) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please refine the Search Criteria & search again.'));       
            } else if(resp1.getStatusCode() == 401) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'UnAuthorized. Please login again.'));           
            }
       } catch(Exception ex) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+','+ ex.getLineNumber() +','+ jsonSOSL));   
       }
   }
   
  /* public class TestClass {
        public LibSearchSOSLWrapper[] test{get;set;}
   }*/
  /* Set<Id> contentDocIdSet = new Set<Id>();
   
   Set<Id> workspaceIdSet = new Set<Id>();
   map<Id,String> workspaceNameMap = new map<Id,String>();
   map<Id,LibSearchViewWrapper> ContentVersionMap = new map<Id,LibSearchViewWrapper>();
  
   public void createLibViewSOSL(String strJson) {
    system.debug('--------------009-----------'+strJson);
       recordSize = false;
       try {
           libList= new List<LibSearchViewWrapper>();
           contentDocIdSet = new Set<Id>();
           ContentVersionMap = new map<Id,LibSearchViewWrapper>();
           JSONParser parser = System.JSON.createParser(strJson);
           System.Debug('>>!@#$1#@#'+ strJson);
           List<LibSearchSOSLWrapper>  innerJsonLibParseObj = (List<LibSearchSOSLWrapper>)parser.readValueAs(List<LibSearchSOSLWrapper>.class);
           System.Debug('>>!@#$#@#'+ innerJsonLibParseObj);
           if(innerJsonLibParseObj != null &&  innerJsonLibParseObj.size()>0) {
               for(LibSearchSOSLWrapper innerRecordObj: innerJsonLibParseObj) {
                   LibSearchViewWrapper innerViewObj = new LibSearchViewWrapper();
                   contentDocIdSet.add(innerRecordObj.ContentDocumentId);    
               }
               if(contentDocIdSet != null && contentDocIdSet.size()>0) {
                       getDocWorkspaceInfo(contentDocIdSet);
               }
               for(LibSearchSOSLWrapper innerRecordObj: innerJsonLibParseObj) {
                   LibSearchViewWrapper innerViewObj = new LibSearchViewWrapper();
                   innerViewObj.title = innerRecordObj.Title;
                   InnerJsonParseOwner ownerObj  = innerRecordObj.Owner;
                   innerViewObj.owner = ownerObj.Name;
                   innerViewObj.id= innerRecordObj.Id;
                   if(innerRecordObj.publishstatus == 'P' || innerRecordObj.publishstatus == 'R') {
                       innerViewObj.publishstatus = 'Published';
                   } else if(innerRecordObj.publishstatus == 'U') {
                         innerViewObj.publishstatus = 'Unpublished';  
                   }
                   innerViewObj.isLatest= innerRecordObj.isLatest;
                   innerViewObj.ContentSize= innerRecordObj.ContentSize;
                   innerViewObj.ContentUrl= innerRecordObj.ContentUrl;
                   innerViewObj.Description= innerRecordObj.Description;
                   innerViewObj.FirstPublishLocationId= innerRecordObj.FirstPublishLocationId;
                   innerViewObj.PathOnClient= innerRecordObj.PathOnClient;
                   innerViewObj.ReasonForChange= innerRecordObj.ReasonForChange;
                   innerViewObj.VersionData= innerRecordObj.VersionData;
                   innerViewObj.VersionNumber= innerRecordObj.VersionNumber;
                   InnerJsonParseOwner ownerObj1 = innerRecordObj.LastModifiedBy;
                   innerViewObj.LastModifiedBy = ownerObj1.Name;
                   Date tempDate = (date.ValueOf(innerRecordObj.LastModifiedDate));
                   String strDate = (tempDate).format();
                   innerViewObj.LastModifiedDate = strDate;
                   Date tempDate1 = Date.valueOf(innerRecordObj.CreatedDate);
                   String strDate1 = tempDate1.format();
                   innerViewObj.CreatedDate = strDate1;
                   InnerJsonParseOwner ownerObj2 = innerRecordObj.CreatedBy;
                   innerViewObj.CreatedBy = ownerObj2.Name;
                   innerViewObj.contentDocId = innerRecordObj.ContentDocumentId;
                   if(workspaceNameMap != null && workspaceNameMap.values().size()>0) {
                      if(workspaceNameMap.keySet().contains(innerRecordObj.ContentDocumentId)) {
                           innerViewObj.workSpaceName = workspaceNameMap.get(innerRecordObj.ContentDocumentId);
                       }
                       else {
                           innerViewObj.workSpaceName = 'Personal Library';
                       }
                   }
                   else {
                       innerViewObj.workSpaceName = 'Personal Library';    
                   }  
                   libList.add(innerViewObj);
                   ContentVersionMap.put(innerRecordObj.Id,innerViewObj);
                }
                if(libList != null && libList.size() > 0) {
                    recordSize = true;
                } else {
                    recordSize = false;   
                } 
           }
       } catch(Exception ex) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+','+ ex.getLineNumber()));   
       }    
   }
   
   
   public void getDocWorkspaceInfo(Set<Id> idDocSet) {
       String strSet =  callSetIterator(idDocSet);
       if(strSet != null && strSet != '') {
           HttpRequest req = new HttpRequest();
           Http http = new Http();
           req.setMethod('GET');
           req.setHeader('Authorization', 'OAuth ' + LoginTokenSetter.accessTokenValue );
         //  System.Debug('>>123>'+strsearchText);
           String url1 = LoginTokenSetter.instanceUrl +'/services/data/v24.0/query/?q=SELECT+ContentWorkspace.Name+,ContentWorkspace.Id+,ContentDocument.Id+,+ContentDocument.title+From+ContentWorkspaceDoc+where+ContentDocumentId+IN+';
           String url2 = '%28' + strSet + '%29';
           String url = url1 + url2;
           req.setEndpoint(url);
           HTTPResponse resp = http.send(req);
           String strJsonWorkspace = resp.getBody();
           createWorkSpace(strJsonWorkspace);
       }
   } 
   
   public String callSetIterator(Set<Id> idSet) {       //'069U00000001MLTIA2','069U00000001NfSIAU' 068U00000001XmEIAU   +'\''+ '' + idSet + '' +'\'
       System.Debug('>>9>>'+idSet);
       String strReturn = null;
       for(Id idObj : idSet) {
           if(strReturn == null) {
               strReturn = '' + '\''+ '' + idObj + '' +'\'';
           } else {
               strReturn = strReturn + ',' + '' + '\''+ '' + idObj+ '' +'\'';
           }                    
       }
       System.Debug('>>10>>'+strReturn);
       return strReturn;
   }
   
   public void createWorkSpace(String strJsonWorkspace) {
    system.debug('----------008-----------'+strJsonWorkspace);
       JSONParser parser = System.JSON.createParser(strJsonWorkspace);
       workspaceIdSet = new Set<Id>();
       workspaceNameMap = new map<Id,String>();
       InnerWorkSpaceJsonParse innerworkSpaceJsonParseObj = (InnerWorkSpaceJsonParse)parser.readValueAs(InnerWorkSpaceJsonParse.class);
       System.Debug('>>@!>>'+innerworkSpaceJsonParseObj);
       if(innerworkSpaceJsonParseObj != null && Integer.valueOf(innerworkSpaceJsonParseObj.totalSize) > 0) {
           for(InnerWorkSpaceRecordJsonParse workSpaceRecordObj : innerworkSpaceJsonParseObj.Records) {
               InnerWorkSpace workspaceObj =  workSpaceRecordObj.ContentWorkspace;
               InnerContentDocument contDocObj = workSpaceRecordObj.ContentDocument;
               workspaceIdSet.add(workspaceObj.Id);
               workspaceNameMap.put(contDocObj.Id,workspaceObj.Name);       
           }
       }
   }
   
   public class InnerWorkSpaceJsonParse {
       public String totalSize;                                                                           
       public String done;
       public List<InnerWorkSpaceRecordJsonParse> records;
   }
   
    public class InnerWorkSpaceRecordJsonParse {
        public InnerJsonParseAttributes attributes;
        public InnerWorkSpace ContentWorkspace;
        public InnerContentDocument ContentDocument;
    }
    
    public class InnerWorkSpace {
        public InnerJsonParseAttributes attributes;
        String Name;
        String Id;
    }
    
    public class InnerContentDocument {
        public InnerJsonParseAttributes attributes;
        String Title;
        String Id;
    }
   
   
   public class LibSearchViewWrapper {
       public String id {get;set;}
       public String title  {get;set;}
       public String publishstatus  {get;set;}
       public String owner  {get;set;}
       public Boolean isLatest  {get;set;}
       public String ContentSize {get;set;}
       public String ContentUrl{get;set;}
       public String Description{get;set;}
       public String FirstPublishLocationId{get;set;}
       public String Origin{get;set;}
       public String PathOnClient{get;set;}
       public String ReasonForChange{get;set;}
       public String  VersionData{get;set;}
       public String VersionNumber{get;set;}
       public String LastModifiedById{get;set;}
       public String LastModifiedBy{get;set;}
       public String LastModifiedDate{get;set;}
       public String CreatedDate{get;set;}
       public String CreatedById{get;set;}
       public String CreatedBy{get;set;}
       public String workSpaceName {get;set;}
       public String contentDocId {get;set;}
   }
   
   public class LibSearchSOSLWrapper {
       public InnerJsonParseAttributes attributes;                         
       Id Id;
       String Title;
       String ContentDocumentId;
       public LibConDocSOSLWrapper ContentDocument;
       boolean IsLatest;
       String PublishStatus;
       String OwnerId;
       public InnerJsonParseOwner Owner;
       
       String LastModifiedById;
       public InnerJsonParseOwner LastModifiedBy;
       String LastModifiedDate;
       String CreatedDate;
       String CreatedById;
       public InnerJsonParseOwner CreatedBy;
       
       String ContentSize;
       String ContentUrl;
       String Description;
       String FirstPublishLocationId;
       String Origin;
       String PathOnClient;
       String ReasonForChange;
       String  VersionData;
       String VersionNumber;
  }
   
   public class LibConDocSOSLWrapper {
       String ParentId;
       public InnerJsonParseAttributes attributes;
   }
  
   /*Test Methods*/
   /*@isTest(SeeAllData=true)
   static  void DocSearchCtrlTest() {
        ApexPages.currentPage().getParameters().put('srch','test');
        DocSearchCtrl docTest = new DocSearchCtrl();
        
     /*   docTest.isLoggedIn = true;
        docTest.searchText = 'test';
        docTest.searchContent();
        docTest.getDocumentRecords();
      //    docTest.getLibrarySearchResults();
        docTest.getLibrarySoslRecords();
        docTest.searchContentNew();
        DocSearchCtrl.LibConDocSOSLWrapper libSosl = new DocSearchCtrl.LibConDocSOSLWrapper();
        DocSearchCtrl.LibSearchSOSLWrapper libSSosl = new DocSearchCtrl.LibSearchSOSLWrapper();
        DocSearchCtrl.LibSearchViewWrapper libVSosl = new DocSearchCtrl.LibSearchViewWrapper();
        DocSearchCtrl.InnerContentDocument innerDoc = new DocSearchCtrl.InnerContentDocument();
        DocSearchCtrl.InnerWorkSpace innerWDoc = new DocSearchCtrl.InnerWorkSpace();
        DocSearchCtrl.InnerWorkSpaceRecordJsonParse innerWSDoc = new DocSearchCtrl.InnerWorkSpaceRecordJsonParse();
        DocSearchCtrl.InnerWorkSpaceJsonParse innerWSJson = new DocSearchCtrl.InnerWorkSpaceJsonParse();
        DocSearchCtrl.Attribute attr = new DocSearchCtrl.Attribute('a','b');
        DocSearchCtrl.DocumentChildNode  dcn = new DocSearchCtrl.DocumentChildNode('a','b','c','d','e','f','g','h','i');
        DocSearchCtrl.DocumentParentNode  dpn = new DocSearchCtrl.DocumentParentNode(10, true);
        DocSearchCtrl.InnerJsonParseOwner ijpo  = new DocSearchCtrl.InnerJsonParseOwner();
        DocSearchCtrl.InnerJsonParseAttributes  ijpa  = new DocSearchCtrl.InnerJsonParseAttributes ();
        DocSearchCtrl.InnerJsonParseRecords   ijpr  = new DocSearchCtrl.InnerJsonParseRecords();
        DocSearchCtrl.InnerJsonParse  ijp = new DocSearchCtrl.InnerJsonParse();
        DocSearchCtrl.InnerView   iv = new DocSearchCtrl.InnerView ();
        docTest.createDocView('[{"attributes":{"type":"Document","url":"/services/data/v20.0/sobjects/Document/01590000000H0RmAAK"},"Id":"01590000000H0RmAAK","Url":null,"Name":"Test","FolderId":"00590000000HBhAAAW","DeveloperName":"Test","ContentType":"text/plain","AuthorId":"00590000000HBhAAAW","CreatedDate":"2012-06-05T06:25:19.000+0000","CreatedById":"00590000000HBhAAAW"}]');
        docTest.createWorkSpace('{"totalSize":1,"done":true,"records":[{"attributes":{"type":"ContentWorkspaceDoc","url":"/services/data/v24.0/sobjects/ContentWorkspaceDoc/059V00000008drTIAQ"},"ContentWorkspace":{"attributes":{"type":"ContentWorkspace","url":"/services/data/v24.0/sobjects/ContentWorkspace/05880000000L4iiAAC"},"Name":"Business Services","Id":"05880000000L4iiAAC"},"ContentDocument":{"attributes":{"type":"ContentDocument","url":"/services/data/v24.0/sobjects/ContentDocument/069V00000008a5sIAA"},"Id":"069V00000008a5sIAA","Title":"Test"}}]}');
        docTest.createLibViewSOSL('[{"attributes":{"type":"ContentVersion","url":"/services/data/v24.0/sobjects/ContentVersion/068V00000008aUhIAI"},"Id":"068V00000008aUhIAI","Title":"Test","ContentDocumentId":"069V00000008a5sIAA","ContentDocument":{"attributes":{"type":"ContentDocument","url":"/services/data/v24.0/sobjects/ContentDocument/069V00000008a5sIAA"},"ParentId":"05880000000L4iiAAC"},"IsLatest":true,"PublishStatus":"P","OwnerId":"00580000003d9rBAAQ","Owner":{"attributes":{"type":"User","url":"/services/data/v24.0/sobjects/User/00580000003d9rBAAQ"},"Name":"India Team"},"LastModifiedById":"00580000003d9rBAAQ","LastModifiedBy":{"attributes":{"type":"User","url":"/services/data/v24.0/sobjects/User/00580000003d9rBAAQ"},"Name":"India Team"},"LastModifiedDate":"2012-05-23T12:57:30.000+0000","CreatedDate":"2012-05-23T12:57:03.000+0000","CreatedById":"00580000003d9rBAAQ","CreatedBy":{"attributes":{"type":"User","url":"/services/data/v24.0/sobjects/User/00580000003d9rBAAQ"},"Name":"India Team"},"ContentSize":462752,"ContentUrl":null,"Description":null,"FirstPublishLocationId":null,"Origin":"C","PathOnClient":"RingCentral SFDC Structure Documentation.docx","ReasonForChange":null,"VersionData":"/services/data/v24.0/sobjects/ContentVersion/068V00000008aUhIAI/VersionData","VersionNumber":"1"}]'); */
   //}
}