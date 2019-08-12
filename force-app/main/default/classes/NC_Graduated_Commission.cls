/**
 * @File Name          : NC_Graduated_Commission.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-12, 7:12:08 a.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-11, 8:21:51 a.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class NC_Graduated_Commission {


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