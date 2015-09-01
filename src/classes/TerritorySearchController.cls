public with sharing class TerritorySearchController {

  private String soql {get;set;}
  public List<Territory_Data__c> contacts {get;set;}

  public TerritorySearchController () {
  
  try {
    soql = 'select id, name, Country__c, Industry__c, Postal_Begin__c, Postal_End__c, Segment__c, State_Province__c, Territory_Owner__r.Name, Type__c,Territory_Owner__c, Alternate_Owner__c, Alternate_Owner__r.Name  from Territory_Data__c where Territory_Owner__c != null';
    runQuery();
   } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error! ' + e));
    }  
    
  }

  public void runQuery() {

    try {
      soql += ' LIMIT 1000';
      contacts = Database.query(soql);
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error! ' + soql));
    }

  }

  public PageReference runSearch() {
    
    try {
    
        String territoryname= Apexpages.currentPage().getParameters().get('territoryname');
        String state= Apexpages.currentPage().getParameters().get('state');
        String ownername= Apexpages.currentPage().getParameters().get('ownername');
        String alternateownername= Apexpages.currentPage().getParameters().get('alternateownername');
        String country= Apexpages.currentPage().getParameters().get('country');
        String industry= Apexpages.currentPage().getParameters().get('industry');
        String postalbegin= Apexpages.currentPage().getParameters().get('postalbegin');
        
        soql = 'select id, name, Country__c, Industry__c, Postal_Begin__c, Postal_End__c, Segment__c, State_Province__c, Territory_Owner__r.Name, Type__c, Territory_Owner__c, Alternate_Owner__c, Alternate_Owner__r.Name from Territory_Data__c where id != null';
        if (String.isNotBlank(territoryname))
          soql += ' and name LIKE \''+String.escapeSingleQuotes(territoryname.trim())+'%\'';
        if (String.isNotBlank(state))
          soql += ' and State_Province__c LIKE \''+String.escapeSingleQuotes(state.trim())+'%\'';
        if (String.isNotBlank(ownername))
          soql += ' and Territory_Owner__r.Name LIKE \''+String.escapeSingleQuotes(ownername.trim())+'%\'';  
        if (String.isNotBlank(alternateownername))
          soql += ' and Alternate_Owner__r.Name LIKE \''+String.escapeSingleQuotes(alternateownername.trim())+'%\'';  
        if (String.isNotBlank(country))
          soql += ' and Country__c LIKE \''+String.escapeSingleQuotes(country.trim())+'%\'';  
        if (String.isNotBlank(industry))
          soql += ' and Industry__c LIKE \''+String.escapeSingleQuotes(industry.trim())+'%\'';  
       
        if (String.isNotBlank(postalbegin)){
          if (postalbegin.trim().isNumeric()){
              soql += ' and (Postal_Begin_Integer__c <='+integer.valueof(postalbegin.trim())+' and Postal_End_Integer__c >='+integer.valueof(postalbegin.trim())+')';
              }
          else{
              soql += ' and (Postal_Begin__c LIKE \''+String.escapeSingleQuotes(postalbegin.trim())+'%\''; 
              soql += ' or Postal_End__c LIKE \''+String.escapeSingleQuotes(postalbegin.trim())+'%\')'; 
              }
        }
        runQuery();
        
     } catch (Exception e) {
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error! ' + e));
     }
    return null;
  }



}