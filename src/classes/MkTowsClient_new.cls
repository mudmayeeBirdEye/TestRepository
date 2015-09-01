public with sharing class MkTowsClient_new {
    
    public static MkTows.MktowsApiSoapPort getPort() {
        String mktowsUserId = 'ringcentral1_048895184C2B5DCC5C7E70';
        String encKey = '246594827245224744CC22BB55DDCCDE55CDC0DD3545';
        MarketoClient client = new MarketoClient(mktowsUserId, encKey);
        MkTows.MktowsApiSoapPort port =  client.prepareSoapPort(); 
        port.timeout_x=10000;   
        return port;
    }

    public static void invoke(){
        MkTows.MktowsApiSoapPort port =  getPort();    
         Mktows.ResultListMObjects res = port.listMObjects();   
         Mktows.LeadKey objLeadKey=new Mktows.LeadKey();
         objLeadKey.keyType='EMAIL';
         objLeadKey.keyValue='kanishk.singh@simplion.com';
         Mktows.ResultGetLead result=port.getLead(objLeadKey);
         
            system.debug( ' >>>>>>>>>>> '+ result.count);
         for (Mktows.LeadRecord  s : result.leadRecordList.leadRecord) {
                /*Mktows.LeadRecord[] leadRecord =s.leadRecord;
              for(Mktows.LeadRecord objLeadRecord :leadRecord ){
                    system.debug( ' >> '+ objLeadRecord.Id);
                    system.debug( ' >> '+ objLeadRecord.Email);
    
              }*/
                system.debug( ' >> '+ s.Id);
                    system.debug( ' >> '+ s.Email);
            
            
         }


    }
}