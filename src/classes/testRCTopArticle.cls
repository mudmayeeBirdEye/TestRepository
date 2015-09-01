@isTest
     private  class testRCTopArticle {
     @isTest(seeAlldata = true)	
     static void UnittestRCTopArticle() {
      try{
          RCNEW_Knowledge_Article__c objKnowledge=new RCNEW_Knowledge_Article__c();
          objKnowledge.ArticleNumber__c = '000002018';
          ApexPages.StandardController controller=new ApexPages.StandardController(objKnowledge);
          RCTopArticle obj=new RCTopArticle(controller);
         
           obj=new RCTopArticle();
          obj.isRecordExist = true;
          obj.strAricleId='000002018';
          obj.getArticleDetails();
          obj.strBrand = 'RingCentral';
          
          obj.objKnowledgeArticle.Article_List_Order__c=1;
          obj.saveArticleOrder();
         
          obj=new RCTopArticle();
          obj.objKnowledgeArticle.Article_List_Order__c=1;
          obj.saveArticleOrder();
     }catch(Exception e){}
     }
 }