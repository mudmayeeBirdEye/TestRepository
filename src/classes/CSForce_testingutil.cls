public with sharing class CSForce_testingutil {

  public CSForce_testingutil(){
  	
  }

  public void addData(){
  	Account ac = new Account();
  	ac.Name = 'test account';
  	insert ac;
  	
  	
  	CustomerStory__c cs = new CustomerStory__c();
  	cs.Name = 'test';
  	cs.Account__c = ac.id;
  	cs.Business_Focus__c = 'testing';
  	cs.Lessons_Learned__c = 'blah';
  	cs.Products__c = 'test';
  	cs.Sharing_Restriction__c='no';
  	cs.Solutions__c = 'blah';
  	cs.Story_Type__c = 'winner';
  	cs.Synopsis__c = 'we won';
  	cs.Team__c ='Lary, Moe, and Curly';
  	cs.Win_Against__c = 'Ralph Wiggum';
  	cs.Status__c = 'Available';
  	insert cs;
  }

}