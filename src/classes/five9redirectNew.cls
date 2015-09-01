public class five9redirectNew {
	public five9redirectNew(){}          
    public PageReference actCreateLeadFromContact() {
        
        PageReference myPage = ApexPages.CurrentPage(); 
        /*
        String str1= myPage.getUrl();  
        String str2 = '';
        Integer intPos = str1.lastIndexOf('=');
        if(intPos != -1){
            str2 = str1.substring(intPos+1,str1.length());       
            PageReference createLeadPage = new PageReference('/search/SearchResults?searchType=2&sen=0&setLast=1&str='+str2);
            createLeadPage.setRedirect(true);
            return createLeadPage;
        }
        */
        String strSearchParam = ApexPages.CurrentPage().getParameters().get('number3');
        if(strSearchParam != null && strSearchParam != ''){
	    	PageReference createLeadPage = new PageReference('/search/SearchResults?searchType=2&sen=0&setLast=1&str='+strSearchParam);
	        createLeadPage.setRedirect(true);
	        return createLeadPage;
        }            
      return null;
    }   
    
    
   /*static testMethod void testfive9redirectNew(){
        five9redirectNew F9Test = new five9redirectNew();
        String strSearchParam = 'test';
        F9Test.actCreateLeadFromContact();
    }*/

}