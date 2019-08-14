trigger NC_Lease on NC_Lease__c (before insert, after insert) {

    //@TODO afert update
    List<NC_Lease__c> newLeases = Trigger.New;
    
    if((trigger.isInsert ) && trigger.isbefore ){
        
        NC_Lease.setAmount(newLeases);

    }
    
    if((trigger.isInsert ) && trigger.isafter){
        
        List<NC_Lease__c> newLeasesList = new List<NC_Lease__c>();
        
        for(NC_Lease__c a : trigger.new){
            NC_Lease__c temp = a.clone(true,true);
            newLeasesList.add(temp);
        }
        
        
        update NC_Lease.setEarned(newLeasesList);


    }
    

    

}