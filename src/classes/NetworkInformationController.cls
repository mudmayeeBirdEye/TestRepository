public class NetworkInformationController {
	public NetworkInformationController(ApexPages.StandardController controller) { 
		
	}
	
	public PageReference redirectToStandardPage() {
		string keyPrefix = '/' + Schema.getGlobalDescribe().get('Network_Information__c').getDescribe().getKeyPrefix() + '/e'; 
	    PageReference networkInfoPage = new PageReference(keyPrefix);
		try {
		    string strRtnUrl;
		    if(ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL') != '') {
            	strRtnUrl = ApexPages.currentPage().getParameters().get('retURL');
            	networkInfoPage.getParameters().put('retURL',strRtnUrl);
    		}
    		if(ApexPages.currentPage().getParameters().get('CF00N80000004ixNz_lkid') != null &&
    			ApexPages.currentPage().getParameters().get('CF00N80000004ixNz') != null &&
    			ApexPages.currentPage().getParameters().get('CF00N80000004ixNz') != '' &&
    			ApexPages.currentPage().getParameters().get('CF00N80000004ixNz_lkid') != '') {    // For Case Object
            		networkInfoPage.getParameters().put('CF00N80000004ixNz_lkid',ApexPages.currentPage().getParameters().get('CF00N80000004ixNz_lkid'));
            		networkInfoPage.getParameters().put('CF00N80000004ixNz',ApexPages.currentPage().getParameters().get('CF00N80000004ixNz'));
	        } else if(ApexPages.currentPage().getParameters().get('CF00N80000004ixNL_lkid') != null &&
    			ApexPages.currentPage().getParameters().get('CF00N80000004ixNL') != null &&
    			ApexPages.currentPage().getParameters().get('CF00N80000004ixNL') != '' &&
    			ApexPages.currentPage().getParameters().get('CF00N80000004ixNL_lkid') != '') {    // For Account Object
            		networkInfoPage.getParameters().put('CF00N80000004ixNL_lkid',ApexPages.currentPage().getParameters().get('CF00N80000004ixNL_lkid'));
            		networkInfoPage.getParameters().put('CF00N80000004ixNL',ApexPages.currentPage().getParameters().get('CF00N80000004ixNL'));
	        }
	        else if(ApexPages.currentPage().getParameters().get('CF00N80000004ixOO_lkid') != null &&
    			ApexPages.currentPage().getParameters().get('CF00N80000004ixOO') != null &&
    			ApexPages.currentPage().getParameters().get('CF00N80000004ixOO') != '' &&
    			ApexPages.currentPage().getParameters().get('CF00N80000004ixOO_lkid') != '') {    // For Implementation Object
            		networkInfoPage.getParameters().put('CF00N80000004ixOO_lkid',ApexPages.currentPage().getParameters().get('CF00N80000004ixOO_lkid'));
            		networkInfoPage.getParameters().put('CF00N80000004ixOO',ApexPages.currentPage().getParameters().get('CF00N80000004ixOO'));
            		string implementationId = ApexPages.currentPage().getParameters().get('CF00N80000004ixOO_lkid');
            		List<Implementation__c> implementationObj  = [Select Account__c,Account__r.Name From Implementation__c where Id = :implementationId limit 1];
            		if(implementationObj != null && implementationObj.size()>0) {
            			networkInfoPage.getParameters().put('CF00N80000004ixNL_lkid',implementationObj[0].Account__c);
            			networkInfoPage.getParameters().put('CF00N80000004ixNL',implementationObj[0].Account__r.Name);	
            		}
            }
	        networkInfoPage.getParameters().put('nooverride','1');
	        networkInfoPage.setRedirect(true);
	        return networkInfoPage;
	        //return null;
		} catch(Exception ex) { 
			networkInfoPage.getParameters().put('nooverride','1');
	        networkInfoPage.setRedirect(true);
	        return networkInfoPage;
		}
		return null;
	}
}