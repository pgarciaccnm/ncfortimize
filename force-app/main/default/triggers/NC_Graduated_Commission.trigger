trigger NC_Graduated_Commission on NC_Graduated_Commission__c (before insert) {
        
    List<NC_Graduated_Commission__c> dubGCs = NC_Graduated_Commission.isValid(Trigger.New);
    
    List<NC_Graduated_Commission__c> newGCs = Trigger.New;
    
    if(dubGCs.size() > 0){
        
        for(NC_Graduated_Commission__c newGC : newGCs){
            
            if(dubGCs.contains(newGC))
                newGC.addError('The Contact already has a Graduated Commission on specified dates!');

        }
    }
       

}