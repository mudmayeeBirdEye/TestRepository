@isTest
private class TestATTControllers {

     public static testMethod void MYUnitTest(){
 	ATTControllerNew objATTControllerNew=new ATTControllerNew();
 	RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
 	   objRCSiteName.RCSiteName__c='ATT';
 	   upsert objRCSiteName;
 	   
 	   //PageReference pageRef = Page.ATTSupportHome;
 	   PageReference pageRef = new PageReference('/apex/ATTSupportHome');
       Test.setCurrentPageReference(pageRef);
 	   
 	   objATTControllerNew.emailSend();
 	    ApexPages.currentPage().getParameters().put('ARTICLEID','1234');
 	    objATTControllerNew.redirectToDetailPage();
 	   
 	   objATTControllerNew.getAuthToken(); 
 	   objATTControllerNew.getBrandFilter();
 	   objATTControllerNew.getCacheMaxAge();
 	   objATTControllerNew.getCanUserSeeKnowledge();
 	   objATTControllerNew.getCategoryDescriptions();
 	   objATTControllerNew.getCategoryGroupName();
 	   objATTControllerNew.getFramedParam();
 	   objATTControllerNew.getHomeAdText();
 	   objATTControllerNew.getHomeAdTitle();
 	   objATTControllerNew.getHomePage();
 	   objATTControllerNew.getHomeUrl();
 	   objATTControllerNew.getIsAnswerSearch();
 	   objATTControllerNew.getIsArticleDetailsPage();
 	   objATTControllerNew.getIsContact();
 	   objATTControllerNew.getIsContactSupportPage();
 	   objATTControllerNew.getIsCustomArticleListPage();
 	   objATTControllerNew.getIsExternalPage();
 	   objATTControllerNew.getIsHomePage();
 	   objATTControllerNew.getIsProductPage();
 	   objATTControllerNew.getRootCategoryName();
 	   objATTControllerNew.getIsVideoLinkPage();
 	   objATTControllerNew.getPage(ApexPages.currentpage().getUrl());
 	   objATTControllerNew.getPageId();
 	   objATTControllerNew.getParentId();
 	   objATTControllerNew.getProductPage();
 	   objATTControllerNew.getProductUrl();
 	   objATTControllerNew.getRootCategoryName();
 	   objATTControllerNew.getSearchPage();
 	   objATTControllerNew.getSearchPageUrl();
 	   objATTControllerNew.getSearchUrl();
 	   objATTControllerNew.getSearchUrl1();
 	  String str2= objATTControllerNew.currentArticleType;
 	  str2= objATTControllerNew.currentArticleTypeLabel;
 	   str2= objATTControllerNew.currentCategory;
 	   str2= objATTControllerNew.currentCategoryName;
 	    str2= objATTControllerNew.currentKeyword;
     String strCurrent=objATTControllerNew.currentKeywordSerach;
 	     str2= objATTControllerNew.currentPage;
 	     Integer pageNum= objATTControllerNew.currentPageNumber;
 	     PageReference objpage= objATTControllerNew.currentPageReference;
 	   objATTControllerNew.doSearch();
 	   objATTControllerNew.doAdvanceSearch();
 	   
		  str2= objATTControllerNew.categoryParameterName; 
		str2= objATTControllerNew.keywordParameterName; 
		str2= objATTControllerNew.articleTypeParameterName; 
		str2= objATTControllerNew.articleTypeLabelParameterName; 
		str2= objATTControllerNew.pageNumberParameterName ;
		objATTControllerNew.getSiteSetup();
		objATTControllerNew.getServiceFilter();
		objATTControllerNew.getServiceFilterURL();
		objATTControllerNew.getSupportSearchPageUrl();
		objATTControllerNew.getIsSearchPage();
		objATTControllerNew.cleanKeyword();
		 ApexPages.currentPage().getParameters().put('emailPage','kanishk.singh@simplion.com');
	   String recMail=ApexPages.currentPage().getParameters().put('recMail','kanishk.singh@simplion.com');
	   String senderMail=ApexPages.currentPage().getParameters().put('senderMail','kanishk.singh@simplion.com');
	   String senderName=ApexPages.currentPage().getParameters().put('sendername','kanishk');
	   String strTitle='';
		
		
 	   
 	   /*SELECT RCSiteName__c, RootCategoryName__c, CategoryGroupName__c, CacheMaxAge__c,
 	   
                       Category1Description__c, Category2Description__c, Category3Description__c,
                       Category4Description__c, Category5Description__c, Category6Description__c,
                       HomeAdText__c, HomeAdTitle__c, Brand_Filter__c
                       FROM RCSiteSetup__c
                       WHERE RCSiteName__c = :siteName ];*/
 	
 
 	}
 	
 	public static testMethod void MYUnitTest1(){
 	ATTController objATTControllerNew;
 	RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
 	   objRCSiteName.RCSiteName__c='ATT';
 	   upsert objRCSiteName;
 	   
 	   objATTControllerNew = new TestATT();
 	   //PageReference pageRef = Page.ATTSupportHome;
 	   PageReference pageRef = new PageReference('/apex/ATTSupportHome');
       Test.setCurrentPageReference(pageRef);
 	  
 	   objATTControllerNew.getBrandFilter();
 	   objATTControllerNew.getCacheMaxAge();
 	   objATTControllerNew.getCanUserSeeKnowledge();
 	   objATTControllerNew.getCategoryDescriptions();
 	   objATTControllerNew.getCategoryGroupName();
 	   objATTControllerNew.getHomeAdText();
 	   objATTControllerNew.getHomeAdTitle();
 	   objATTControllerNew.getHomePage();
 	   objATTControllerNew.getHomeUrl();
 	   objATTControllerNew.getIsAnswerSearch();
 	   objATTControllerNew.getIsContact();
 	   objATTControllerNew.getIsExternalPage();
 	   objATTControllerNew.getIsHomePage();
 	   objATTControllerNew.getIsProductPage();
 	   objATTControllerNew.getRootCategoryName();
 	   objATTControllerNew.getIsVideoLinkPage();
 	   objATTControllerNew.getPage(ApexPages.currentpage().getUrl());
 	   objATTControllerNew.getProductPage();
 	   objATTControllerNew.getProductUrl();
 	   objATTControllerNew.getRootCategoryName();
 	   objATTControllerNew.getSearchPage();
 	   objATTControllerNew.getSearchPageUrl();
 	   objATTControllerNew.getSearchUrl();
 	   objATTControllerNew.getSearchUrl1();
 	  	String str2= objATTControllerNew.currentArticleType;
 	  	str2= objATTControllerNew.currentArticleTypeLabel;
 	   str2= objATTControllerNew.currentCategory;
 	    str2= objATTControllerNew.currentKeyword;
 	     str2= objATTControllerNew.currentPage;
 	     Integer pageNum= objATTControllerNew.currentPageNumber;
 	     PageReference objpage= objATTControllerNew.currentPageReference;
 	   objATTControllerNew.doSearch();
 	 	  str2= objATTControllerNew.categoryParameterName; 
		str2= objATTControllerNew.keywordParameterName; 
		str2= objATTControllerNew.articleTypeParameterName; 
		str2= objATTControllerNew.articleTypeLabelParameterName; 
		str2= objATTControllerNew.pageNumberParameterName ;
		objATTControllerNew.getSiteSetup();
		objATTControllerNew.getIsSearchPage();
		objATTControllerNew.cleanKeyword();
		 ApexPages.currentPage().getParameters().put('emailPage','kanishk.singh@simplion.com');
	   String recMail=ApexPages.currentPage().getParameters().put('recMail','kanishk.singh@simplion.com');
	   String senderMail=ApexPages.currentPage().getParameters().put('senderMail','kanishk.singh@simplion.com');
	   String senderName=ApexPages.currentPage().getParameters().put('sendername','kanishk');
	   String strTitle='';
	   objATTControllerNew.emailSend();
	    
	}
	
	public class TestATT extends ATTController {
		
	}
}