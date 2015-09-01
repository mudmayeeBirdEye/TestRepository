@isTest
private class TestSupportPortalBTController {

    static testMethod void myUnitTest() {
        
        PageReference pageRef1 = new PageReference('/apex/btcloduphone');
        Test.setCurrentPageReference(pageRef1);
        
        SupportPortalControllerNew objSupportPortalControllerNew=new SupportPortalControllerNew();
        RCSiteSetup__c objRCSiteName= (RCSiteSetup__c)SmartFactory.createSObject('RCSiteSetup__c', true);
        objRCSiteName.RCSiteName__c='btcloudphone';
        upsert objRCSiteName;
       
        //PageReference pageRef = Page.ATTSupportHome;
        //PageReference pageRef = new PageReference('/apex/btcloduphone');
        //Test.setCurrentPageReference(pageRef);
       
        objSupportPortalControllerNew.emailSend();
        ApexPages.currentPage().getParameters().put('ARTICLEID','1234');
        objSupportPortalControllerNew.redirectToDetailPage();
        
        ApexPages.currentPage().getParameters().put('brand','BT');
        ApexPages.currentPage().getParameters().put('token','z9F0QUf+yk2vnPp2Ckq81lAV4+FLcnzlnXjSzScnckPXM40gzFAWY3gyonmvCyoEU/pD2w1pHQ4wA4gXZg80xQ==');
        ApexPages.currentPage().getParameters().put('startURL','/apex/btcloduphone');
        objSupportPortalControllerNew.isTokenFound = true;
        objSupportPortalControllerNew.isValidTokenFound();
        objSupportPortalControllerNew.getAuthToken(); 
        objSupportPortalControllerNew.getBrandFilter();
        objSupportPortalControllerNew.getCacheMaxAge();
        objSupportPortalControllerNew.getCanUserSeeKnowledge();
        objSupportPortalControllerNew.getCategoryDescriptions();
        objSupportPortalControllerNew.getCategoryGroupName();
        objSupportPortalControllerNew.getFramedParam();
        objSupportPortalControllerNew.getHomeAdText();
        objSupportPortalControllerNew.getHomeAdTitle();
        objSupportPortalControllerNew.getHomePage();
        objSupportPortalControllerNew.getHomeUrl();
        objSupportPortalControllerNew.getIsAnswerSearch();
        objSupportPortalControllerNew.getIsArticleDetailsPage();
        objSupportPortalControllerNew.getIsContact();
        objSupportPortalControllerNew.getIsContactSupportPage();
        objSupportPortalControllerNew.getIsCustomArticleListPage();
        objSupportPortalControllerNew.getIsExternalPage();
        objSupportPortalControllerNew.getIsHomePage();
        objSupportPortalControllerNew.getIsProductPage();
        objSupportPortalControllerNew.getRootCategoryName();
        objSupportPortalControllerNew.getIsVideoLinkPage();
        objSupportPortalControllerNew.getPage(ApexPages.currentpage().getUrl());
        objSupportPortalControllerNew.getPageId();
        objSupportPortalControllerNew.getParentId();
        objSupportPortalControllerNew.getProductPage();
        objSupportPortalControllerNew.getProductUrl();
        objSupportPortalControllerNew.getRootCategoryName();
        objSupportPortalControllerNew.getSearchPage();
        objSupportPortalControllerNew.getValidToken();
        objSupportPortalControllerNew.getNextPageName();
        objSupportPortalControllerNew.login();
        objSupportPortalControllerNew.PageAuthorization();
        objSupportPortalControllerNew.getPageAuthorization();
        objSupportPortalControllerNew.validateLoginDetail();
        objSupportPortalControllerNew.openCase();
        objSupportPortalControllerNew.openCreateCase();
        objSupportPortalControllerNew.openMyCase();
        objSupportPortalControllerNew.getUKPortal();
        objSupportPortalControllerNew.getSearchPageUrl();
        objSupportPortalControllerNew.getSearchUrl();
        objSupportPortalControllerNew.getSearchUrl1();
        String str2= objSupportPortalControllerNew.currentArticleType;
        str2= objSupportPortalControllerNew.currentArticleTypeLabel;
        str2= objSupportPortalControllerNew.currentCategory;
        str2= objSupportPortalControllerNew.currentCategoryName;
        str2= objSupportPortalControllerNew.currentKeyword;
        String strCurrent=objSupportPortalControllerNew.currentKeywordSerach;
        str2= objSupportPortalControllerNew.currentPage;
        Integer pageNum= objSupportPortalControllerNew.currentPageNumber;
        PageReference objpage= objSupportPortalControllerNew.currentPageReference;
        objSupportPortalControllerNew.doSearch();
        objSupportPortalControllerNew.doAdvanceSearch();
       
        str2= objSupportPortalControllerNew.categoryParameterName; 
        str2= objSupportPortalControllerNew.keywordParameterName; 
        str2= objSupportPortalControllerNew.articleTypeParameterName; 
        str2= objSupportPortalControllerNew.articleTypeLabelParameterName; 
        str2= objSupportPortalControllerNew.pageNumberParameterName ;
        objSupportPortalControllerNew.getSiteSetup();
        objSupportPortalControllerNew.getServiceFilter();
        objSupportPortalControllerNew.getServiceFilterURL();
        objSupportPortalControllerNew.getSupportSearchPageUrl();
        objSupportPortalControllerNew.getIsSearchPage();
        objSupportPortalControllerNew.cleanKeyword();
        ApexPages.currentPage().getParameters().put('emailPage','rcindiateam@simplion.com');
        String recMail=ApexPages.currentPage().getParameters().put('recMail','rcindiateam@simplion.com');
        String senderMail=ApexPages.currentPage().getParameters().put('senderMail','rcindiateam@simplion.com');
        String senderName=ApexPages.currentPage().getParameters().put('sendername','rcindiateam');
        String strTitle='';
        
        
       
       /*SELECT RCSiteName__c, RootCategoryName__c, CategoryGroupName__c, CacheMaxAge__c,
       
                       Category1Description__c, Category2Description__c, Category3Description__c,
                       Category4Description__c, Category5Description__c, Category6Description__c,
                       HomeAdText__c, HomeAdTitle__c, Brand_Filter__c
                       FROM RCSiteSetup__c
                       WHERE RCSiteName__c = :siteName ];*/
    
 
        
    }
    
}