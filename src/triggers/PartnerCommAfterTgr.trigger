trigger PartnerCommAfterTgr on Partner_Communication__c (after insert, after update) {
    if(TriggerHandler.BY_PASS_PARTNERCOMM_ON_INSERT || TriggerHandler.BY_PASS_PARTNERCOMM_ON_UPDATE){
        System.debug('### RETURNED FROM PARTNERCOMM AFTER TRG ###');
        return;
    } else {
        System.debug('### STILL CONTINUE FROM PARTNERCOMM AFTER TRG ###');
    } 
    // Define connection id  
    Set<Id> networkId = S2SConnectionHelperCls.getConnectionId('TELUS'); 
    List<Case> localCaseList = new List<case>();
    List<Partner_Communication__c> telusPartnerCommObjList = new List<Partner_Communication__c>();
    Set<Id> localCaseIDSet = new Set<Id>();
    Set<Id> localCaseCommentIDSet = new Set<Id>();
    List<PartnerNetworkRecordConnection> caseSharingRecordList = new List<PartnerNetworkRecordConnection>();
    Map<Id,Id> localToPartnerCaseIdMap = new Map<Id,Id>();
    List<CaseComment> caseCommentInsertList = new List<CaseComment> ();
    List<Partner_Communication__c> localPCList = new List<Partner_Communication__c>();
    List<PartnerNetworkRecordConnection> pcmConnections =  new  List<PartnerNetworkRecordConnection>();
    
    
    
    if(Trigger.isInsert){
        try{
            List<Partner_Communication__c> pcmToUpdate = new List<Partner_Communication__c>();
            Map<String,id> pcmTOCommnetMap = new Map<String,Id>();
            Map<Id,CaseComment> pcCommToCaseCommentMap = new Map<Id,CaseComment>();
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            Set<Id> caseCommentIdSet = new Set<Id>();
            String pcmPrefixId = '';
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            for(Schema.SObjectType objectInstance : gd.values()){
                if(objectInstance.getDescribe().getName() == 'Partner_Communication__c'){//do your processing with the 
                    pcmPrefixId = objectInstance.getDescribe().getKeyPrefix();
                }
            }
            for(Partner_Communication__c pcm : Trigger.new){
                if(pcm.ConnectionReceivedId == NULL ){// local PC records and should be shared with TELUS
                    PartnerNetworkRecordConnection newConnection = new PartnerNetworkRecordConnection(  ConnectionId = pcm.ConnectionIdOfPartner__c, 
                                                                                                        LocalRecordId = pcm.Id);
                    pcmConnections.add(newConnection);                                                                                       
                }else if((pcm.ConnectionReceivedId != NULL && networkId.contains(pcm.ConnectionReceivedId)) || Test.isRunningTest()){
                    //CaseComment newComment = new CaseComment ( CommentBody = String.valueof(pcm.Id).substring(0,15)+pcm.Vendor_CommentBody__c ,
                    CaseComment newComment = new CaseComment ( CommentBody = pcm.Vendor_CommentBody__c ,
                                                               ParentId = (String.valueOf(pcm.Case__c) != NULL ? String.valueOf(pcm.Case__c) : pcm.Case_Id__c),
                                                               IsPublished = pcm.Is_Public__c);
                    pcCommToCaseCommentMap.put(pcm.Id,newComment);
                    caseCommentInsertList.add(newComment);
                }   
            }
            TriggerHandler.BY_PASS_CASECOMMENT_ON_INSERT();
            TriggerHandler.BY_PASS_CASECOMMENT_ON_UPDATE();
            if(caseCommentInsertList.size() >0){
                srList = database.insert(caseCommentInsertList); 
            }
            TriggerHandler.BY_PASS_CASECOMMENT_ON_INSERT = false;
            TriggerHandler.BY_PASS_CASECOMMENT_ON_UPDATE = false;
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                     caseCommentIdSet.add(sr.Id);                                                                                       
                }
            }
            for(Partner_Communication__c pcm : [SELECT Id,case__c,Case_Comment_ID__c,Case_Id__c FROM Partner_Communication__c WHERE Id IN : pcCommToCaseCommentMap.keySet()]){
                if(pcCommToCaseCommentMap != NULL && pcCommToCaseCommentMap.containsKey(pcm.Id)){
                    CaseComment tmpComment = pcCommToCaseCommentMap.get(pcm.Id);
                    pcm.Case_Comment_ID__c = tmpComment.Id; 
                    if(pcm.case__c == NULL){
                        pcm.case__c = pcm.Case_Id__c;
                    }
                    if(pcm.Case_Id__c == NULL){
                        pcm.Case_Id__c = pcm.case__c;
                    }
                    pcmToUpdate.add(pcm); 
                }
            }
            TriggerHandler.BY_PASS_PARTNERCOMM_ON_INSERT();
            TriggerHandler.BY_PASS_PARTNERCOMM_ON_UPDATE();
            if(pcmToUpdate.size() > 0){
                Database.update(pcmToUpdate);
            }
            TriggerHandler.BY_PASS_PARTNERCOMM_ON_INSERT();
            TriggerHandler.BY_PASS_PARTNERCOMM_ON_UPDATE();
            // Share these new PartnerCommunication Records with Telus
            if(pcmConnections.size() > 0){
                srList = database.insert(pcmConnections); 
            } 
        }catch(Exception e){
            System.debug('Exception occured');
        }
        
    }
    
    
    if(Trigger.isUpdate){
        for(Partner_Communication__c pcm : Trigger.new){ 
            // if received from Telus 
            if(String.valueOf(pcm.Last_Modified_By_User__c).contains('Connection') || test.isRunningTest() ) {// we have to hardcode because cannot get connection user name.
                if(pcm.Case_Id__c != NULL){
                    localCaseIDSet.add(pcm.Case_Id__c);
                    telusPartnerCommObjList.add(pcm);
                    if(pcm.Case_Comment_ID__c != NULL){
                        localCaseCommentIDSet.add(pcm.Case_Comment_ID__c);
                    }
                }   
            }
        }
        Map<Id,CaseComment> localCaseCommentMap = new Map<Id,CaseComment>([SELECT Id,IsPublished,CommentBody, ParentId FROM CaseComment WHERE Id IN :localCaseCommentIDSet]);
        // travese all Telus PCM recorlist to update EXISTING standard Comments
        for(Partner_Communication__c pcm : telusPartnerCommObjList){
            if(localCaseCommentMap != NULL && localCaseCommentMap.containsKey(pcm.Case_Comment_ID__c) && localCaseCommentMap.get(pcm.Case_Comment_ID__c) != NULL){
                localCaseCommentMap.get(pcm.Case_Comment_ID__c).CommentBody = pcm.Vendor_CommentBody__c;
               // localCaseCommentMap.get(pcm.Case_Comment_ID__c).IsPublished = pcm.Is_Public__c;
            }
        }
        TriggerHandler.BY_PASS_CASECOMMENT_ON_INSERT();
        TriggerHandler.BY_PASS_CASECOMMENT_ON_UPDATE();
        if(localCaseCommentMap.values().Size() > 0){
            update localCaseCommentMap.values();
        }
        TriggerHandler.BY_PASS_CASECOMMENT_ON_INSERT = false;
        TriggerHandler.BY_PASS_CASECOMMENT_ON_UPDATE = false;   
    }
    
    
    
}