trigger NC_Lease on NC_Lease__c (before insert) {

    List<NC_Lease__c> newLeases = Trigger.New;
    
    for(NC_Lease__c newLease : NC_Lease.setAmount(newLeases)){
        
        
    }
    
    system.debug('ncLTrigger>>'+newLeases);
    

}