/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {

    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
    	String startUrl = System.currentPageReference().getParameters().get('startURL');
    	system.debug('startUrl === ' + startUrl);
    	String displayType = System.currentPageReference().getParameters().get('display');
        system.debug('displayType === ' + displayType);
        system.debug('Network.forwardToAuthPage(startUrl, displayType) === ' + Network.forwardToAuthPage(startUrl, displayType));
        return Network.forwardToAuthPage(startUrl, displayType);
    }
}