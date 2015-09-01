/*-----------------------------------------------------------------------------
* Case Name.............: Sales Battle Cards                                  *
* File..................: SalesBattleCards.Page                               *
* Created by............: Simplion Technologies                               *
* Created Date..........: 25-06-2014                                          *
* Last Modified by......: Simplion Technologies                               *
* Description...........: This Controller is used  for SalesBattleCards Page  *
------------------------------------------------------------------------------>*/
public class IndustryListViewControlr {
	Public List<Industry__c> indsList {get;set;} 
	public List<Industry__c> industryList {get;set;}
	public string strIndustryName {get;set;}
    
    /*.....Constructor........*/
	public IndustryListViewControlr(ApexPages.StandardController controller) {
		try {
			industryList = new list<industry__c>();
			indsList = new list<industry__c>();
			if(controller.getId() != null) {
				list<industry__c> indusLst = [select id, name from industry__c where id =:controller.getId()];
				strIndustryName = indusLst[0].name;
				if(!string.isBlank(indusLst[0].name)) {
					industryList = getIndustry(indusLst[0].name);
				}
			}
		} catch(Exception ex) {}
	}
       
       
    /*.....Method to get the list of Industry object record.......*/
    public List<Industry__c> getIndustry(String myIndustryName) {
		indsList = new list<industry__c>();
		indsList = [select id, Name ,How_the_Phone_System_works__c ,Value_Benefit__c,Industry_Pain_Point__c,Pain_Reliever__c,
						Web_Resource__c,LastModifiedDate ,What_it_is__c from Industry__c   
						where name = :myIndustryName ORDER BY  LastModifiedDate DESC];			
		return indsList;
    }
		
	/*..Method to Back VF Page to Salesforce List View....  
	public PageReference redirectToPartnerRequest() {
	    PageReference objPageRef = new PageReference('/a31/o');   
		objPageRef.setRedirect(true); 
	    return objPageRef;
	}   */     
 }