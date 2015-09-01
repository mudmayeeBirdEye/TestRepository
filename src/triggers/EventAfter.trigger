trigger EventAfter on Event (after insert, after delete) {
    /*
    if(trigger.isDelete){
     set<String> eventId = new set<String>();
        for(Event ev : trigger.new){
            system.debug('ev---------------->'+ev);
            eventId.add(ev.id);
        }
       
        for(EventRelation thisEventRelation : [SELECT EventId,Id,RelationId,Status FROM EventRelation 
                                                   //WHERE RelationId IN: ResourcesId AND Status != 'Declined']){
                                                   WHERE EventId IN: setEventId AND Status != 'Declined']){
                                               }
        }
                                                
                                            
    }*/
}