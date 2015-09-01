/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_NDA_Contract_NoteAndAttachment {

    static testMethod void myUnitTest() {
        NDA_Contract__c objNDA_Con = new NDA_Contract__c(If_Unilateral__c ='Other Party',	Name_of_Contact_Person__c='test',Date_of_Contract__c=date.newinstance(2013, 7, 17),
        													Address_of_Other_Party__c ='test',Termination_Date_of_Contract__c = date.newinstance(2013, 7, 18),Return_Destroy_Confidential_Information__c ='Either at Disclosing Party’s Election',
        													Termination_Date_Confidentiality_Period__c = date.newinstance(2013, 7, 18));
        													
        													
        insert objNDA_Con;
        NDA_Contract__c objNDA_Con1 = new NDA_Contract__c(If_Unilateral__c ='Other Party',	Name_of_Contact_Person__c='test',Date_of_Contract__c=date.newinstance(2013, 7, 17),
        													Address_of_Other_Party__c ='test',Termination_Date_of_Contract__c = date.newinstance(2013, 7, 18),Return_Destroy_Confidential_Information__c ='Either at Disclosing Party’s Election',
        													Termination_Date_Confidentiality_Period__c = date.newinstance(2013, 7, 18));
        insert objNDA_Con1;
        
        //NoteAndAttachment attach=new NoteAndAttachment();   	
    	//attach.Name='Unit Test Attachment';
    	//Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	//attach.body=bodyBlob;
        //attach.parentId=objNDA_Con.id;
        //insert attach;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(objNDA_Con);
        NDA_Contract_NoteAndAttachment objNDA = new NDA_Contract_NoteAndAttachment(controller);
        system.debug('-------------------->objNDA '+objNDA) ;
        
        ApexPages.StandardController controller1 = new ApexPages.StandardController(objNDA_Con1);
        NDA_Contract_NoteAndAttachment objNDA1 = new NDA_Contract_NoteAndAttachment(controller1); 
       	objNDA1.isAttached = false;
    }
}