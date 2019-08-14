/**
 * @File Name          : NC_Graduated_Commission.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-13, 2:15:08 p.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-11, 8:21:51 a.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class NC_Graduated_Commission {


    /**
    *   Return the Graduated Commission based on the Lease period of date
    * */
    public static NC_Graduated_Commission__c getCurrentGraduatedCommission(NC_Lease__c lease){

      
        return null;
        
    }
    
    /**
     * Retuns the Earned Bounty base on Lease
     * */
    public static Decimal calculateBoutyEarned(NC_Lease__c lease){
        
		List<NC_Bounty__c> uBounties = [Select id, Value__c from NC_Bounty__c where Unit__c = :lease.Unit__c and B_Start_Date__c <= :lease.L_Start_Date__c and B_End_Date__c > :lease.L_End_Date__c];       
        
        Decimal bountyAmount = 0.0;
        
        if(uBounties.size() > 0){
            
            bountyAmount = (decimal) uBounties[0].Value__c;
            
        }
        
        return bountyAmount; 
    }
    

    /*
     * Calculate the earned value based on Graduated Commission
     * */
    public static Decimal calculateCommission(NC_Lease__c lease){

        NC_Graduated_Commission__c gc = getCurrentGraduatedCommission(lease);
        
        Decimal currenttotal = NC_Lease.getAllRevenueByContact(gc);

        Decimal accumulatedPercentage = (currenttotal * 100)/gc.GC_Goal__c;

        List<GC_Tier__c> selectedTiers = [select id, gct_target_earned_rate__c from gc_tier__c where Graduated_Commission__c = :gc.Id and gct_target_achieved_low__c <=:accumulatedPercentage and gct_target_achieved_high__c > :accumulatedPercentage ];
        
        Decimal earnedRate = (selectedTiers.size() > 0)?(decimal) selectedTiers[0].gct_target_earned_rate__c: 0;
        
        return (Decimal) ((accumulatedPercentage * earnedRate) + calculateBoutyEarned(lease) ).setScale(2);

    }
    
    /**
     * 
     * This validates the overlapping Dates
     * One Record per Contact per Period
     * */
    public static List<NC_Graduated_Commission__c> isValid(List<NC_Graduated_Commission__c> newGC){
        

            List<NC_Graduated_Commission__c> existGC = [Select id, Contact__c, GD_Start_Date__c, GC_End_Date__c from NC_Graduated_Commission__c];
            
            List<NC_Graduated_Commission__c>  checkedOverlap = haskOverlap(existGC, newGC);
            
 
        return checkedOverlap;
       
    }
    
    public static List<NC_Graduated_Commission__c> haskOverlap(List<NC_Graduated_Commission__c> existGCs, List<NC_Graduated_Commission__c> newGCs){
        
        
        List<NC_Graduated_Commission__c> gcErrorList = new List<NC_Graduated_Commission__c>();
        
             for (NC_Graduated_Commission__c existGC : existGCs) {
                for (NC_Graduated_Commission__c newGC : newGCs) {

                    if (
                        existGC.Contact__c == newGC.Contact__c &&
                        (
                            (
                                newGC.GD_Start_Date__c >= existGC.GD_Start_Date__c &&
                                newGC.GD_Start_Date__c <= existGC.GC_End_Date__c
                            ) ||
                            (
                                newGC.GC_End_Date__c >= existGC.GD_Start_Date__c &&
                                newGC.GC_End_Date__c <= existGC.GC_End_Date__c
                            )
                        )
                    ) {
                        System.debug('nc2.3>>'+newGC);
                        newGC.addError('The Contact already has a Graduated Commission on specified dates!');
                        
                        gcErrorList.add(newGC);

                    }
                }
            }
        
        return gcErrorList;
    }
}