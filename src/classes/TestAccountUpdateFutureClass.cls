@isTest
private class TestAccountUpdateFutureClass {

    static testMethod void myUnitTest() {
        Test.startTest();
            
            /*UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            system.debug('portalRole is ' + portalRole);
            
            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
            );
            Database.insert(portalAccountOwner1);
        
            System.runAs ( portalAccountOwner1 ) {
                RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Account' Limit 1];
                
                //Create account
                Account accObj = new Account();
                accObj.Name = 'TestAccount';
                accObj.Number_of_DL_s__c = 5;
                accObj.RecordTypeId = rt.Id;
                accObj.Type ='Partner';
                accObj.OwnerId = portalAccountOwner1.Id;
                TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
                insert accObj;
                TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
            
                //Create contact
                Contact contactObj = new Contact();
                contactObj.AccountId =  accObj.Id;
                contactObj.Email = System.now().millisecond() + 'test@test.com';
                contactObj.Phone = '9910106804';
                contactObj.LastName = 'TestLast';
                TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
                insert contactObj;
                TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
            
                //Create user
                UserRole portalRole1 = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                system.debug('portalRole is ' + portalRole1);
                Profile portalProfile = [SELECT Id FROM Profile Limit 1];
                User userObj = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                UserRoleId = portalRole1.Id,
                ContactId = contactObj.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
                );
                Database.insert(userObj);
                
                AccountUpdateFutureClass.updateAccountAndContact(userObj.Id);
            }*/
            
            /*Profile guestUserProf  = [select id from profile where name ='RCPartner Profile'];
            User userObj = new User(firstname='testGuest12', lastname='testGuestLN12', alias = 'test12g', email='testGuest12@ringcentral.com', 
            emailencodingkey='UTF-8', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = guestUserProf.Id, ContactId = contactObj.Id,
            timezonesidkey='America/Los_Angeles', username='testGuest12@test.com');
            insert userObj;*/
            
            Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
            RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Partner Account' Limit 1];
            
            Account accObj = new Account();
            accObj.Name = 'TestAccount';
            accObj.Number_of_DL_s__c = 5;
            accObj.RecordTypeId = rt.Id;
            accObj.Type ='Partner';
            accObj.Partner_ID__c = '12345';
            TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
            insert accObj;
            TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
            
            Contact contactObj = new Contact();
            contactObj.AccountId =  accObj.Id;
            contactObj.Email = System.now().millisecond() + 'test@test.com';
            contactObj.Phone = '9910106804';
            contactObj.LastName = 'TestLast';
            TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
            insert contactObj;
            TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
            
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
             
            System.runAs ( thisUser ) {
                UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
                Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
                 
                User newUser = new User(
                    //UserRoleId = ur.Id,
                    profileId = p.id,
                    username = System.now().millisecond() + 'test12345@test.com',
                    email = 'pb@ff.com',
                    emailencodingkey = 'UTF-8',
                    localesidkey = 'en_US',
                    languagelocalekey = 'en_US',
                    timezonesidkey = 'America/Los_Angeles',
                    alias='nuser',
                    lastname='lastname',
                    contactId = contactObj.id
                );
                insert newUser;
                
                RecordType rt1 = [select id,Name from RecordType where SobjectType='Account' and Name='Customer Account' Limit 1];
                
                Account accObj1 = new Account();
                accObj1.Name = 'TestAccount';
                accObj1.Number_of_DL_s__c = 5;
                accObj1.RecordTypeId = rt1.Id;
                accObj1.Type ='Partner';
                accObj1.Partner_ID__c = '12345';
                TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = true;
                insert accObj1;
                TriggerHandler.BY_PASS_ACCOUNT_ON_INSERT = false;
                
                Contact contactObj1 = new Contact();
                contactObj1.AccountId =  accObj1.Id;
                contactObj1.Email = System.now().millisecond() + 'test@test.com';
                contactObj1.Phone = '9910106804';
                contactObj1.LastName = 'TestLast';
                TriggerHandler.BY_PASS_CONTACT_ON_INSERT = true;
                insert contactObj1;
                TriggerHandler.BY_PASS_CONTACT_ON_INSERT = false;
                
                AccountUpdateFutureClass.updateAccountAndContact(newUser.Id);  
            }
            
            
        Test.stopTest();        
    }
}