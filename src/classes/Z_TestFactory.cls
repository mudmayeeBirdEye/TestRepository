/*   Copyright (c) 2013 Zuora, Inc.
 *
 *   Permission is hereby granted, free of charge, to any person obtaining a copy of 
 *   this software and associated documentation files (the "Software"), to use copy, 
 *   modify, merge, publish the Software and to distribute, and sublicense copies of 
 *   the Software, provided no fee is charged for the Software.  In addition the
 *   rights specified above are conditioned upon the following:
 *
 *   The above copyright notice and this permission notice shall be included in all
 *   copies or substantial portions of the Software.
 *
 *   Zuora, Inc. or any other trademarks of Zuora, Inc.  may not be used to endorse
 *   or promote products derived from this Software without specific prior written
 *   permission from Zuora, Inc.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *   FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
 *   ZUORA, INC. BE LIABLE FOR ANY DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES
 *   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 *   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  
 *
 *
 *   IN THE EVENT YOU ARE AN EXISTING ZUORA CUSTOMER, USE OF THIS SOFTWARE IS GOVERNED
 *   BY THIS AGREEMENT AND NOT YOUR MASTER SUBSCRIPTION AGREEMENT WITH ZUORA.
 */

@isTest
public class Z_TestFactory {

    /**
     * Insert a test account in the db
     
    public static Account makeAccount() {
        
        Account testAcc = new Account();
        
        testAcc.Name = 'my test account';
        
        insert testAcc;
        return testAcc;
    }
    
    
    /**
     * Insert a test contact associated with an account in the db
     *
    public static Contact makeContact(Account testAcc) {
        
        Contact testContact = new Contact();
        
        testContact.FirstName = 'firstname';
        testContact.LastName = 'lastname';
        testContact.Email = 'email@mail.me';
        
        testContact.AccountId = testAcc.Id;
        
        insert testContact;
        return testContact;
    }
    
    
    /**
     * Insert a test opportunity associated with an account
     *
    public static Opportunity makeOpportunity(Account testAcc) {
        
        Opportunity testOpp = new Opportunity();
        
        testOpp.Name = 'my test opportunity';
        testOpp.StageName = 'Closed Won';
        testOpp.CloseDate = System.today();
        
        testOpp.AccountId = testAcc.Id;
        
        insert testOpp;
        return testOpp;
    }
    
    
    /**
     * Insert a test quote based on an opportunity in the db
     *
    public static zqu__Quote__c makeQuote(Opportunity testOpp) {
        
        zqu__Quote__c testQuote = new zqu__Quote__c();
        
        testQuote.Name = 'my test quote';
        
        testQuote.zqu__Opportunity__c = testOpp.Id;
        
        insert testQuote;
        return testQuote;
    }*/

}