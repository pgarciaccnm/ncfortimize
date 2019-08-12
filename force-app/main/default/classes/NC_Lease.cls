/**
 * @File Name          : NC_Lease.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-12, 7:21:01 a.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-10, 1:54:10 p.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class NC_Lease {
    public NC_Lease() {

    }

    /**
    This calculates the Earn based on Graduated Commission and Unit
     */
    public static void calculateEarn(NC_Lease__c lease){

    }

    public static List<NC_Lease__c> getDup(List<NC_Lease__c> newLs){
        

            List<NC_Lease__c> existLs = [Select Id, Contact__c, L_Start_Date__c, L_End_Date__c from NC_Lease__c];
            
            List<NC_Lease__c>  checkedOverlap = haskOverlap(existLs, newLs);
            
 
        return checkedOverlap;
       
    }
     
    public static List<NC_Lease__c> haskOverlap(List<NC_Lease__c> existLs, List<NC_Lease__c> newLs){
        
        
        List<NC_Lease__c> gcErrorList = new List<NC_Lease__c>();
        
             for (NC_Lease__c existL : existLs) {
                for (NC_Lease__c newL : newLs) {

                    if (
                        existL.Contact__c == newL.Contact__c &&
                        (
                            (
                                newL.L_Start_Date__c >= existL.L_Start_Date__c &&
                                newL.L_Start_Date__c <= existL.L_End_Date__c
                            ) ||
                            (
                                newL.L_End_Date__c >= existL.L_Start_Date__c &&
                                newL.L_End_Date__c <= existL.L_End_Date__c
                            )
                        )
                    ) {
                        System.debug('nc2.3>>'+newL);
                        newL.addError('The Contact already has a Graduated Commission on specified dates!');
                        
                        gcErrorList.add(newL);

                    }
                }
            }
        
        return gcErrorList;
    }
}
