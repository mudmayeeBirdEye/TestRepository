public with sharing class CSForce_SearchHelper {
/*
  <apex:inputField value="{!csSearch.name}"/>
        <apex:inputField value="{!csSearch.Story_Type__c}"/>
        <apex:inputField value="{!csSearch.Win_Against__c}"/>
        <apex:inputField required="true" value="{!csSearch.Products__c}"/>
        <apex:inputField value="{!csSearch.Sales_Reference__c}"/>
        <apex:inputField value="{!csSearch.Sharing_Restriction__c}"/>
*/

  public String title       {get; set;}
  public String link        {get; set;}
  public String storyType   {get; set;}
  public String winAgainst  {get; set;}
  public String products    {get; set;}
  public String synopsis    {get; set;}
  public String salesRef    {get; set;}
  public String sharingRes  {get; set;}
  
  public CSForce_SearchHelper(CustomerStory__c cs){
  	title = cs.Name;
  	link = '/'+cs.Id;
  	storyType = cs.Story_Type__c;
  	if(cs.Win_Against__c != null && cs.Win_Against__c.length()>0)
  	 winAgainst = cs.Win_Against__c.replace(';',', ');
  	if(cs.Products__c != null && cs.Products__c.length()>0)
  	 products = cs.Products__c.replace(';',', ');
  	if(cs.Synopsis__c != null && cs.Synopsis__c.length() >=50)
  	 synopsis = cs.Synopsis__c.substring(0,50)+'...';
  	else
  	 synopsis = cs.Synopsis__c;
  	salesRef = getImageUrl(cs.callRef__c);
  	sharingRes = getImageUrl(cs.sharingR__c);
  }
  
  private String getImageUrl(String img){
  	integer s = img.indexOf('/');
  	img = img.substring(s, img.length());
  	integer e = img.indexOf('"');
  	return img.substring(0,e);
  }

}