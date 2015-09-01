@isTest
private class Test_Rackspace_RCContact {

      public static testmethod void TestRackspaceDistributionModel() {
        RackspaceDistributionModel obj=new RackspaceDistributionModel();
        RackspaceDistributionModel.distributionlists obj2=new RackspaceDistributionModel.distributionlists('test','test');
        RackspaceDistributionModel.emailAddressList obj3=new RackspaceDistributionModel.emailAddressList();
        RackspaceDistributionModel.contacts obj4=new RackspaceDistributionModel.contacts();
      String strResponse='{"distributionlists":[{"displayName":"TestUnmanagedDL","name":"testunmanageddl"},{"displayName":"UnmanagedDL","name":"unmanageddl"}],"offset":0,"size":250,"total":2}';
      RackspaceDistributionModel.getDistributionListObject(strResponse);
    }
    public static testmethod void TestRCArticleRatingDetails() {
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
    }
    static testMethod void testRCContract() {
      try{  
 			Account a = new Account(name='opportunity');
          	insert a;
          	Opportunity o = new Opportunity(name='opportunity',account=a,type='New Business',sales_model__c='Direct',CloseDate=Date.Today(), StageName='3. ActivePipe');
          	insert o;
          	Contact c = new Contact(lastname='last2', account=a, email='email@rc.com', phone='7654568787');
          	insert c;
          	OpportunityContactRole ocr = new OpportunityContactRole(ContactId=c.Id, OpportunityId=o.Id);
          	insert ocr;
          	PageReference pr = new PageReference('/' + o.Id);
          	system.debug('THIS IS PR: ' + pr);
          	Test.setCurrentPage(pr);
          	ApexPages.currentPage().getParameters().put('id',o.Id);
          	ApexPages.StandardController sc = new ApexPages.standardController(o);
          
            // Create User
        	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        	User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                        UserName='standarduser00001@testorg.com',
                        EmailEncodingKey='UTF-8', LastName='Testing', 
                        LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id,               
                        TimeZoneSidKey='America/Los_Angeles', 
                        Fax = '1234567');
			insert(u);
    	
    		system.runAs(u){
          		RCContractDetails ui = new RCContractDetails(sc);
          		ui.getTerm();
          		String [] term = new String[]{'24'};
          		ui.setTerm(term);
          		List<SelectOption> options = ui.getItems();
          
          		Boolean cError = ui.getContactError();
        		Boolean nError = ui.getNumLinesError();
        		ui.setStrEmail('jesse1@ringcentral.com');
        		String sEmail = ui.getStrEmail();
          		ui.setStrName('string name');
        		String sName = ui.getStrName();
	          	String aEmail = ui.getAgentEmail();
	          	String aFax = ui.getAgentFax();
	          	ui.contract.Total_Number_Of_Lines__c = 19;
          		Opportunity gOpp = ui.getOpportunity();
          		Contract gCon = ui.getContract();
          		User gU = ui.getUser();
          		Boolean fError = ui.getFillError();
          		PageReference pf = ui.doSearch();
          
          		ui.contract.Total_Number_Of_Lines__c = 25;
          		pf = ui.doSearch();
          
            	Test.setCurrentPage(pf);
    		}
            
            RCContractTerms ct = new RCContractTerms(sc);
            
            ApexPages.currentPage().getParameters().put('name','jesse test');
            ApexPages.currentPage().getParameters().put('email','jesse2@ringcentral.com');
            ApexPages.currentPage().getParameters().put('noOfLines','35');
            ApexPages.currentPage().getParameters().put('price','499.99');
            ApexPages.currentPage().getParameters().put('operatorEmail','jesse1@ringcentral.com'); 
            ApexPages.currentPage().getParameters().put('operatorFax','6549873214');
            ApexPages.currentPage().getParameters().put('accountId',a.Id);
            ApexPages.currentPage().getParameters().put('term','36');
            ApexPages.currentPage().getParameters().put('years','3');
            
            PageReference pf2 = ct.deliverAsPDF();
            
          	String sName2 = ct.getStrName();
          	String sEmail2 = ct.getStrEmail();
          	String sLines = ct.getStrNoLines();
          	String sPrince = ct.getStrPrice();
          	String sOpEmail = ct.getStrOperatorEmail();
          	String sOpFax = ct.getStrOperatorFax();
          	String sAccId = ct.getStrAccountId();
          	String sTerm = ct.getStrTerm();
          	String sYears = ct.getStrYears();
          	String cRender = ct.getChooserender();
            Boolean rButton = ct.getRenderButton();
            
            ApexPages.currentPage().getParameters().put('p','p');
            cRender = ct.getChooserender();
         }catch(Exception e){} 
  }
  public static testmethod void TestRCCustomArticleListOrder() {
       try{
      RCSiteSetup__c siteSetup1 = new RCSiteSetup__c(RCSiteName__c='rcsupport1',Brand_Filter__c='Brand:RC_US');
      insert siteSetup1;
       
      RCNEW_Knowledge_Article__c objKnowledge=new RCNEW_Knowledge_Article__c(Article_List_Order__c=1);
      objKnowledge.Section__c='Getting_Started';
      objKnowledge.PublishStatus__c='Online';
      objKnowledge.IsVisibleInPkb__c=true;
      objKnowledge.Brand__c='RC_US';
      objKnowledge.RCVersion__c='RC_Legacy';
      insert objKnowledge;
    
      ApexPages.currentPage().getParameters().put('c','Getting_Started');
      ApexPages.currentPage().getParameters().put('retURL','token=12345');
           
      RCCustomArticleListOrder obj=new RCCustomArticleListOrder();
      String strCurrentCategory=obj.currentCategory;
      obj.getAuthToken();
      obj.getCacheMaxAge();
      Boolean value=obj.hasNext;
      value=obj.hasPrevious;
      obj.first();
      obj.last();
      obj.previous();
      obj.Next();
      obj.getURLCategory();
      Integer icount=obj.pageNumber;
      String strValue=obj.categoryParameterName;
      strValue=obj.currentCategoryName;
      obj.con=null;
      value=obj.hasNext;
      value=obj.hasPrevious;
      obj.first();
      obj.last();
      obj.previous();
      obj.Next();
         
      siteSetup1.RCSiteName__c='rcsupport1';
      siteSetup1.Brand_Filter__c='Brand:RC_US,RCProductVesion:RC2012';
          try{
             update siteSetup1;
          }catch(Exception e){
              
          }
      RCCustomArticleListOrder obj2=new RCCustomArticleListOrder();
           obj2.getArticleList();
          
      }catch(Exception e){
       }  
    }
     public  static testMethod void testRCSupportController2013(){
        try{
        RCSupportController2013 objRCSupportController2013=new RCSupportController2013();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='rcsupport2013';
        upsert objRCSiteName;

        PageReference pageRef = new PageReference('/apex/RCSupportHome2013');
        Test.setCurrentPageReference(pageRef);
       
        objRCSupportController2013.getAuthToken(); 
        objRCSupportController2013.getBrandFilter();
        objRCSupportController2013.getCacheMaxAge();
        objRCSupportController2013.getCanUserSeeKnowledge();
        objRCSupportController2013.getCategoryDescriptions();
        objRCSupportController2013.getCategoryGroupName();
        objRCSupportController2013.getFramedParam();
        objRCSupportController2013.getHomeAdText();
        objRCSupportController2013.getHomeAdTitle();
        objRCSupportController2013.getHomePage();
        objRCSupportController2013.getHomeUrl();
        objRCSupportController2013.getIsAnswerSearch();
        objRCSupportController2013.getIsArticleDetailsPage();
        objRCSupportController2013.getIsContact();
        objRCSupportController2013.getIsContactSupportPage();
        objRCSupportController2013.getIsCustomArticleListPage();
        objRCSupportController2013.getIsExternalPage();
        objRCSupportController2013.getIsHomePage();
        objRCSupportController2013.getIsProductPage();
        objRCSupportController2013.getRootCategoryName();

        objRCSupportController2013.getPage(ApexPages.currentpage().getUrl());
        objRCSupportController2013.getPageId();
        objRCSupportController2013.getParentId();
        objRCSupportController2013.getProductPage();
        objRCSupportController2013.getProductUrl();
        objRCSupportController2013.getRootCategoryName();
        objRCSupportController2013.getSearchPage();
        objRCSupportController2013.getSearchPageUrl();
        objRCSupportController2013.getSearchUrl();
        objRCSupportController2013.getSearchUrl1();
        
        String str2= objRCSupportController2013.currentArticleType;
        str2= objRCSupportController2013.currentArticleTypeLabel;
        str2= objRCSupportController2013.currentCategory;
        str2= objRCSupportController2013.currentCategoryName;
        str2= objRCSupportController2013.currentKeyword;
        str2= objRCSupportController2013.currentPage;
        Integer pageNum= objRCSupportController2013.currentPageNumber;
        PageReference objpage= objRCSupportController2013.currentPageReference;
        objRCSupportController2013.doSearch();
        objRCSupportController2013.doAdvanceSearch();
       
        str2= objRCSupportController2013.categoryParameterName; 
        str2= objRCSupportController2013.keywordParameterName; 
        str2= objRCSupportController2013.articleTypeParameterName; 
        str2= objRCSupportController2013.articleTypeLabelParameterName; 
        str2= objRCSupportController2013.pageNumberParameterName ;
        objRCSupportController2013.getSiteSetup();
        objRCSupportController2013.getServiceFilter();
        objRCSupportController2013.getServiceFilterURL();
        objRCSupportController2013.getSupportSearchPageUrl();
        objRCSupportController2013.getIsSearchPage();
        objRCSupportController2013.cleanKeyword();
        
        ApexPages.currentPage().getParameters().put('emailPage','kanishk.singh@simplion.com');
        String recMail=ApexPages.currentPage().getParameters().put('recMail','kanishk.singh@simplion.com');
        String senderMail=ApexPages.currentPage().getParameters().put('senderMail','kanishk.singh@simplion.com');
        String senderName=ApexPages.currentPage().getParameters().put('sendername','kanishk');
        String strTitle='';
        
        objRCSupportController2013.emailSend();
        objRCSupportController2013.getIdeaURL();
        objRCSupportController2013.getCaseURL();
        ApexPages.CurrentPage().getParameters().put('retUrl','service=1&brand=Ringcentral&token=test');
        ApexPages.CurrentPage().getParameters().put('brand','RC_UK');
        objRCSupportController2013.getIdeaURL();
        objRCSupportController2013.getCaseURL();
        
        ApexPages.CurrentPage().getParameters().put('token','test');
        objRCSupportController2013.getIdeaURL();
        objRCSupportController2013.getCaseURL();
     
        ApexPages.CurrentPage().getParameters().put('token','PFK8fqxUQZ3qw1nIWm0gVoPE1O1xEhiRFh0X3n0PxvEIzdYo+J2ihXuaSvfrFoOGXg5uqTH8KYo/2oohN5A7wQ==');
        objRCSupportController2013.getIdeaURL(); 
        objRCSupportController2013.getCaseURL();
       
        objRCSupportController2013.getIdeaURL(); 
        objRCSupportController2013.updateUserProfile();
        objRCSupportController2013.getCommunityId();

        objRCSupportController2013.localeSetting();
        }catch(Exception e){
          
        }  
    }
}