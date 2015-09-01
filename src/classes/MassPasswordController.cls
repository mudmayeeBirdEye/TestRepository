public with sharing class MassPasswordController {
    public String usernames {get;set;}
    public String newPassword {get;set;}
    public Boolean isAdmin {get;set;}
    
    public MassPasswordController(){
    	try{
	        usernames = '';
	        newPassword = '';
	        isAdmin = false;
	        User loginUser = [SELECT Profile.Name FROM User WHERE Id = :Userinfo.getUserId()];
			String loginUserProfile = loginUser.Profile.Name;
			if('System Administrator'.equalsIgnoreCase(loginUserProfile)){
				isAdmin = true;
			}
    	}catch(Exception ex){
    		isAdmin = false;
    	}
		
    }
    
    public PageReference updatePassword(){
    	try{        
	        if(isEmpty(usernames) || isEmpty(newPassword))
	        {
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Username and Password should not be blank.'));
	        }else{
	            List<String> lstUsernames = new List<String>();
	            usernames = usernames.replaceAll('(\\s+)', '');
	            lstUsernames = usernames.split(',');
	            if(lstUsernames != null && lstUsernames.size() > 0){
	                if(lstUsernames.size() > 10){
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Max 10 users password can be reset at one time.'));
	                    return null;
	                }else{            
	                    List<User> userList = [SELECT Id, Name, Username, isActive, Profile.IsSsoEnabled, Profile.Name, Email FROM User 
	                    					   WHERE Username IN :lstUsernames AND isActive = true];
	                    if(userList != null && userList.size() > 0){
	                        Map<String,User> usersMap = new Map<String,User>();
	                        
	                        for(User userObj : userList){
	                            usersMap.put(userObj.username.trim().toLowerCase(),userObj);
	                        }
	                        
	                        for(String username : lstUsernames){
	                            username = username.trim().toLowerCase();                       
	                            if(usersMap.containsKey(username)){
	                                User objUser = usersMap.get(username);
	                                Boolean checkSSO = objUser.Profile.IsSsoEnabled; // Checked for Single Sign-On
	                                String profileName = objUser.Profile.Name;
	                                profileName = profileName.trim();
	                                if(checkSSO){
	                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Single Sign-On is Enabled for Username ' + username));
	                                }else if('System Administrator'.equalsIgnoreCase(profileName)){
	                                	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Username ' + username +' can\'t update System Administrator password.'));
	                                }else{                          
	                                    try{
	                                        system.setPassword(objUser.Id,newPassword); // Updating User's Password
	                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Password updated successfully for username ' + username));
	                                    }catch(Exception ex){
	                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error occured while updating password for username ' + username));
	                                    }
	                                }
	                            }else{
	                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Username '+username + ' not exist or is inactive'));
	                            }
	                        }
	                    }else{
	                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No User found.'));
	                    }
	                }
	            }else{
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Username should not be blank'));
	            }
	        }
    	}catch(Exception ex){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Exception while processing the request.'));
    	}
        return null;
    }
    
    Boolean isEmpty(String value) {
        return (value == null || value.trim() == '' ? true : false);
    }
}