/*
@Name : LinkedInController
@Date : Feb 13, 2014
@Description : Fetch company page form LinkedIn site using custom search API of google. 
@Revision History : 
*/

public class LinkedInController {
	
    public string companyName{get;set;}   
    public string redirectUrl{get;set;}
    public boolean showFrame{get;set;} 
    public String company{get;set;}    
    public List<String> searchLinks{get;set;}
    
    public LinkedInController(){
    	searchLinks = new List<String>();
    	companyName = ApexPages.currentPage().getParameters().get('companyName');  
    	if(!string.isBlank(companyName)){  	
    		//searchCompany();
    	}
    }
    
    //Company Top 5 Search as per google search.
    public void searchCompany(){
    	//String str = '/id\\W+res\\W+.*?<h3.*?class\\W+f?\\s*kv\\W+.*?<cite.*?>(.*?)<\\/cite>/is';
    	searchLinks = new List<String>(); 
    	try{
	    	if(!string.isBlank(companyName)){
	    		showFrame = false;
				String endPointUrl = 'https://www.google.com/search?q=site:linkedin.com+'+companyName.trim().replaceAll('(\\s+)', '');		
				redirectUrl ='';		
				Http h = new Http();
				HTTPRequest req = new HTTPRequest();
				HTTPResponse resp = new HTTPResponse();
				req.setHeader('Content-Type', 'application/xml');
				req.setEndpoint(endPointUrl);
				req.setMethod('GET');
				String response='';
				if(!Test.isRunningTest()){
					resp = h.send(req);	
					response = resp.getBody();
				}else{
					response = '<cite>www.linkedin.com/company/test</cite>';
				}
				if(resp.getStatusCode() == 200 || Test.isRunningTest()){	
					showFrame = true;	
					String companyRegEx = '<cite>(.+?)</cite>';
					Pattern MyPattern = Pattern.compile(companyRegEx);		
					Matcher MyMatcher = MyPattern.matcher(response);							
					while (MyMatcher.find()) {
						String returnedURL = MyMatcher.group(1);
			       		string str = returnedURL.replaceAll('\\<.*?\\>', '');						
			       		if(str != null) {		
							if(str.contains('/company/')){
								if(!str.contains('http')){
									str = 'http://'+str;
								}
								String[] text = str.split('/');
								if(text != null && text.size() < 6 ) {
									searchLinks.add(str);	
								}						
							}
			       		}
			   		}
				}else{
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Invalid Response.'));					
				}
				if(searchLinks==null || searchLinks.size()==0){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'No Company Found !'));					
				}else if(searchLinks != null && searchLinks.size() > 0){
					redirectUrl = searchLinks[0];					
				}
	    	}else{
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter Company Name.'));    			
			}
    	}catch(exception e){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));    		 		
    	}
    }        
}