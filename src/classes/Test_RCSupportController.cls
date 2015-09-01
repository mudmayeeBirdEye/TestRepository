@IsTest 
	private class Test_RCSupportController {
		static testmethod void testRCSupportController(){
	    		
	        RCSupportController objRCSupportController=new RCSupportController();
	        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
	        objRCSiteName.RCSiteName__c='rcsupport';
	        upsert objRCSiteName;
	
	        PageReference pageRef = new PageReference('/apex/RCSupportHome');
	        Test.setCurrentPageReference(pageRef);
	       
	        objRCSupportController.getAuthToken(); 
	        objRCSupportController.getBrandFilter();
	        objRCSupportController.getCacheMaxAge();
	        objRCSupportController.getCategoryDescriptions();
	        objRCSupportController.getCategoryGroupName();
	        objRCSupportController.getFramedParam();
	        objRCSupportController.getHomeAdText();
	        objRCSupportController.getHomeAdTitle();
	        objRCSupportController.getHomePage();
	        objRCSupportController.getHomeUrl();
	        objRCSupportController.getIsAnswerSearch();
	        objRCSupportController.getIsArticleDetailsPage();
	        objRCSupportController.getIsContact();
	        objRCSupportController.getIsContactSupportPage();
	        objRCSupportController.getIsCustomArticleListPage();
	        objRCSupportController.getIsExternalPage();
	        objRCSupportController.getIsHomePage();
	        objRCSupportController.getIsProductPage();
	        objRCSupportController.getRootCategoryName();
	
	        objRCSupportController.getPage(ApexPages.currentpage().getUrl());
	        objRCSupportController.getPageId();
	        objRCSupportController.getParentId();
	        objRCSupportController.getProductPage();
	        objRCSupportController.getProductUrl();
	        objRCSupportController.getRootCategoryName();
	        objRCSupportController.getSearchPage();
	        objRCSupportController.getSearchPageUrl();
	        objRCSupportController.getSearchUrl();
	        objRCSupportController.getSearchUrl1();
	        
	        String str2= objRCSupportController.currentArticleType;
	        str2= objRCSupportController.currentArticleTypeLabel;
	        str2= objRCSupportController.currentCategory;
	        str2= objRCSupportController.currentCategoryName;
	        str2= objRCSupportController.currentKeyword;
	        str2= objRCSupportController.currentPage;
	        Integer pageNum= objRCSupportController.currentPageNumber;
	        PageReference objpage= objRCSupportController.currentPageReference;
	        objRCSupportController.doSearch();
	        objRCSupportController.doAdvanceSearch();
	       
	        str2= objRCSupportController.categoryParameterName; 
	        str2= objRCSupportController.keywordParameterName; 
	        str2= objRCSupportController.articleTypeParameterName; 
	        str2= objRCSupportController.articleTypeLabelParameterName; 
	        str2= objRCSupportController.pageNumberParameterName ;
	        objRCSupportController.getSiteSetup();
	        objRCSupportController.getServiceFilter();
	        objRCSupportController.getServiceFilterURL();
	        objRCSupportController.getSupportSearchPageUrl();
	        objRCSupportController.getIsSearchPage();
	        objRCSupportController.cleanKeyword();
	        
	        ApexPages.currentPage().getParameters().put('emailPage','kanishk.singh@simplion.com');
	        String recMail=ApexPages.currentPage().getParameters().put('recMail','kanishk.singh@simplion.com');
	        String senderMail=ApexPages.currentPage().getParameters().put('senderMail','kanishk.singh@simplion.com');
	        String senderName=ApexPages.currentPage().getParameters().put('sendername','kanishk');
	        String strTitle='';
	        
	        objRCSupportController.emailSend();
	        objRCSupportController.getIdeaURL();
	        objRCSupportController.getCaseURL();
	        ApexPages.CurrentPage().getParameters().put('retUrl','service=1&brand=Ringcentral&token=test');
	        ApexPages.CurrentPage().getParameters().put('brand','RC_UK');
	        objRCSupportController.getIdeaURL();
	        objRCSupportController.getCaseURL();
	        
	        ApexPages.CurrentPage().getParameters().put('token','test');
	        objRCSupportController.getIdeaURL();
	        objRCSupportController.getCaseURL();
	     
	        ApexPages.CurrentPage().getParameters().put('token','PFK8fqxUQZ3qw1nIWm0gVoPE1O1xEhiRFh0X3n0PxvEIzdYo+J2ihXuaSvfrFoOGXg5uqTH8KYo/2oohN5A7wQ==');
	        objRCSupportController.getIdeaURL(); 
	        objRCSupportController.getCaseURL();
	       
	        objRCSupportController.getIdeaURL(); 
	        objRCSupportController.updateUserProfile();
	        objRCSupportController.getCommunityId();
	
	        objRCSupportController.localeSetting();
	        objRCSupportController.getURLCategory();
	    
	   	}
	}