/**
 * @File Name          : NC_Lease.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-12, 4:29:41 p.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-10, 1:54:10 p.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class NC_Lease {


    public static Decimal getAllRevenueByContact(NC_Graduated_Commission__c gc){
System.debug('nc9.0>>'+gc);
        List<NC_Lease__c> agLease = [Select L_Amount__c, Contact__c from NC_Lease__c where L_Start_Date__c <= :gc.GD_Start_Date__c and L_End_Date__c <= :gc.GC_End_Date__c and Contact__c =: gc.Contact__c];

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
    This calculates the total cost based of leasing unit
     */
    public static Decimal calculateTotalCost(NC_Lease__c lease){

        Integer numberDaysDue = lease.L_Start_Date__c.daysBetween(lease.L_End_Date__c);

        NC_Unit__c unit = [Select id, Revenue__c from NC_Unit__c Where Id =: lease.Unit__c];

        return (numberDaysDue * unit.Revenue__c);

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