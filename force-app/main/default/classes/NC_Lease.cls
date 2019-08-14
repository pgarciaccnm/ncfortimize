/**
 * @File Name          : NC_Lease.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-14, 12:47:17 a.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-10, 1:54:10 p.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class NC_Lease {


    public static Map<Id, Decimal> getAllrevenueByGC(List<NC_Graduated_Commission__c> gcs){
        
        Set<Id> gcIds = new Set<Id>();
        
        for(NC_Graduated_Commission__c gc : gcs){
            gcIds.add(gc.Id);
        }
        
        Map<Id, Decimal> gcMap = new Map<Id, Decimal>();
        
        for(NC_Lease__c lease : [Select Id, Graduated_Commission__c, L_Amount__c from NC_Lease__c where Graduated_Commission__c = :gcIds]){
            
            gcMap.put(lease.Graduated_Commission__c, (decimal) lease.L_Amount__c);
        }
        
        
        return gcMap;
    }
 /*
        public static Decimal getAllRevenueByContact(NC_Graduated_Commission__c gc){

        List<NC_Lease__c> agLease = [Select L_Amount__c from NC_Lease__c where Graduated_Commission__c = :gc.Id ];

        Decimal currentTotal = 0;

        System.debug('nc9.1>>'+agLease);
        
        for (NC_Lease__c ar : agLease)  {
          
            System.debug('nc9.2>>'+ar.L_Amount__c);
            if(ar.L_Amount__c != null){
                
                
                currentTotal = currentTotal + (decimal) ar.L_Amount__c;
            }
        }
        return currentTotal;
    } 

    /**
    This calculates the total cost based of leased unit
     */
    public static Decimal calculateTotalCost(NC_Lease__c lease){

        Integer numberDaysDue = lease.L_Start_Date__c.daysBetween(lease.L_End_Date__c);

        NC_Unit__c unit = [Select id, Revenue__c from NC_Unit__c Where Id =: lease.Unit__c];

        return (numberDaysDue * unit.Revenue__c);

    }
    
    
    /**
    * Set the Graduated Commission after the Lease is saved
     */
    public static List<NC_Lease__c> setEarned(List<NC_Lease__c> leaseList){
        
        Set<Id> gcIds = new Set<Id>();

        Map<Id, NC_Lease__c> gcLease = new Map<Id, NC_Lease__c>();

        //Group the Lease by GC
        for(NC_Lease__c lease : leaseList){

            gcLease.put(lease.Graduated_Commission__c, lease);

        }

        gcIds = gcLease.keySet();

        Map<Id, NC_Graduated_Commission__c> gcMap = new Map<Id, NC_Graduated_Commission__c>([Select Id, GC_Goal__c, (Select Id,  GCT_Target_Achieved_Low__c, GCT_Target_Achieved_High__c, GCT_Target_Earned_Rate__c  from GC_Tiers__r) from NC_Graduated_Commission__c where Id in :gcIds]);

        //Collect the Current Total by GC
        List<AggregateResult> aggregateResultList = [select  sum(l_amount__c) currenttotal, Graduated_Commission__c from nc_lease__c  where Graduated_Commission__c in :gcIds group by Graduated_Commission__c ];
                        
        Decimal accumulatedPercentage = 0;
        
        if(aggregateResultList != null && aggregateResultList.size() > 0){
           

            for(AggregateResult aggr:aggregateResultList){  
              
                if(gcMap.get((String) aggr.get('Graduated_Commission__c')).GC_Goal__c != null){

                	accumulatedPercentage = ((decimal) aggr.get('currenttotal') * 100)/ (decimal) gcMap.get((String) aggr.get('Graduated_Commission__c')).GC_Goal__c;

                    for(GC_Tier__c tier : gcMap.get((String) aggr.get('Graduated_Commission__c')).GC_Tiers__r){
   
                        if(accumulatedPercentage >= tier.GCT_Target_Achieved_Low__c  && accumulatedPercentage < tier.GCT_Target_Achieved_High__c ){

                            NC_Lease__c updateLease = gcLease.get((String) aggr.get('Graduated_Commission__c'));
                            
                            updateLease.L_Earned__c = (decimal) tier.GCT_Target_Earned_Rate__c * accumulatedPercentage;
                        }
    
                    }    
                }//end if 
            }

        }

        
        return gcLease.values();
    }
    
    /**
     * Set the Total amount per lease
     * */
    public static List<NC_Lease__c> setAmount(List<NC_Lease__c> leaseList){
        
        Set<Id> unitIds = new Set<Id>();
        
        Set<Id> gcIds = new Set<Id>();
        
        for(NC_Lease__c lease : leaseList){
            
            unitIds.add(lease.Unit__c);
            gcIds.add(lease.Graduated_Commission__c);
        }
        
        Map<Id, NC_Graduated_Commission__c> gcMap = new Map<Id, NC_Graduated_Commission__c>([Select id, GD_Start_Date__c, GC_End_Date__c from NC_Graduated_Commission__c where Id in :gcIds ]);
        

        Map<ID, NC_Unit__c> unitMap = new Map<ID, NC_Unit__c>([Select id, Revenue__c from NC_Unit__c Where Id in :unitIds]);
        
        for(NC_Lease__c lease : leaseList){
           
            Integer numberDaysDue 	= gcMap.get(lease.Graduated_Commission__c).GD_Start_Date__c.daysBetween(gcMap.get(lease.Graduated_Commission__c).GC_End_Date__c);
            
            lease.L_Start_Date__c 	= gcMap.get(lease.Graduated_Commission__c).GD_Start_Date__c;
            
            lease.L_End_Date__c		= gcMap.get(lease.Graduated_Commission__c).GC_End_Date__c;
            
            lease.L_Amount__c 		= numberDaysDue * unitMap.get(lease.Unit__c).Revenue__c;
  
        }
        
        return leaseList;

        
    }

    /**
     * Retuns dups Lease
     * */
    public static List<NC_Lease__c> getDup(List<NC_Lease__c> newLs){
        
            Set<Id> gcIds = new Set<Id>();

            for(NC_Lease__c lease : newLs){
                gcIds.add(lease.Graduated_Commission__c);
            }
            
            Map<String, NC_Lease__c> existMap = new Map<String, NC_Lease__c>();

            for(NC_Lease__c lease : [Select Graduated_Commission__c from NC_Lease__c where Graduated_Commission__c in :gcIds]){

                existMap.put(lease.Graduated_Commission__c, lease );
            }

            if(existMap.size() > 0){

                for(NC_Lease__c newLease :newLs){

                    if(existMap.get(newLease.Graduated_Commission__c) != null){

                        newLease.addError('There is another leased with te same Graduated Commission');
                    }
                }

            }
  
 
        return newLs;
       
    }
     
    /**
     * Find and returns dups with overlap based on dates and contact in two List
     * */
    public static List<NC_Lease__c> haskOverlap(List<NC_Lease__c> existLs, List<NC_Lease__c> newLs){
        
        
        List<NC_Lease__c> gcErrorList = new List<NC_Lease__c>();
        
             for (NC_Lease__c existL : existLs) {
                for (NC_Lease__c newL : newLs) {

                    if (existL.id == newL.id) {
                        System.debug('nc2.3>>'+newL);
                        newL.addError('The Contact already has a Graduated Commission on specified dates!');
                        
                        gcErrorList.add(newL);

                    }
                }
            }
        
        return gcErrorList;
    }
}