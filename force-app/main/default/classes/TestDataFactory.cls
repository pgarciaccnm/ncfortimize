/**
 * @File Name          : TestDataFactory.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-13, 2:15:55 p.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-13, 2:15:55 p.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest
public class TestDataFactory {
    

    public static NC_Graduated_Commission__c createGC(Contact c){
        
        NC_Graduated_Commission__c gc = new NC_Graduated_Commission__c();
        gc.GD_Start_Date__c = Date.valueOf('2019-01-01');
        gc.GC_End_Date__c	= Date.valueOf('2019-12-31');
        gc.Contact__c		= c.Id;
        gc.GC_Goal__c		= 2000000;
        
        insert gc;
        
        GC_Tier__c t1 = new  GC_Tier__c();
        t1.GCT_Target_Achieved_Low__c 	= 25;
        t1.GCT_Target_Achieved_High__c 	= 50;
        t1.GCT_Target_Earned_Rate__c	= 100;
        t1.Graduated_Commission__c		= gc.Id;
        
        insert t1;
        
        GC_Tier__c t2 = new  GC_Tier__c();
        t2.GCT_Target_Achieved_Low__c 	= 50;
        t2.GCT_Target_Achieved_High__c 	= 75;
        t2.GCT_Target_Earned_Rate__c	= 150;
        t2.Graduated_Commission__c		= gc.Id;
        
        insert t2;
       
        GC_Tier__c t3 = new  GC_Tier__c();
        t3.GCT_Target_Achieved_Low__c 	= 75;
        t3.GCT_Target_Achieved_High__c 	= 100;
        t3.GCT_Target_Earned_Rate__c	= 200;
        t3.Graduated_Commission__c		= gc.Id;
        
        insert t3;
        
        return gc;
        
    }
    

    public static Contact createContact(){
        
        Contact c = new Contact(FirstName = 'Pedro', LastName='Garcia');

        insert c;
        
        return c;
 
    }
    
  
    public static List<NC_Lease__c> createLeaseList(){
        
        Contact c = createContact();
        NC_Unit__c u = createUnitAProperty(c);
        
        NC_Graduated_Commission__c gc = createGC(c);
        
        List<NC_Lease__c> lList = New List<NC_Lease__c>();

        NC_Lease__c l1 = new NC_Lease__c();

        l1.L_Start_Date__c 	= Date.valueOf('2019-01-01');
        l1.L_End_Date__c 	= Date.valueOf('2019-05-31');
        l1.Graduated_Commission__c = gc.Id;
        l1.Unit__c = u.Id;
        //l1.L_Amount__c	= 20000;

        lList.add(l1);

        NC_Lease__c l2 = new NC_Lease__c();
        l2.L_Start_Date__c 	= Date.valueOf('2019-06-01');
        l2.L_End_Date__c 	= Date.valueOf('2019-12-30');
        l2.Graduated_Commission__c = gc.Id;
        l2.Unit__c = u.Id;
       	//l2.L_Amount__c	= NC_Lease.calculateTotalCost( l2);
		//l2.L_Amount__c	= 40000;
        
        //lList.add(l2);
        
        insert lList;
        
        return lList;
    }
    
   
    public static NC_Unit__c createUnitAProperty(Contact c){
        
        NC_Property__c p = new NC_Property__c();

        p.Contact__c = c.Id;

        insert p;

        NC_Unit__c u = new NC_Unit__c();
        u.Property__c = p.Id;
        u.Revenue__c  = 2200;
        
        insert u;
        
        NC_Bounty__c b = new NC_Bounty__c();
        b.Unit__c = u.Id;
        b.B_Start_Date__c 	= Date.valueOf('2019-01-01');
        b.B_End_Date__c		= Date.valueOf('2019-07-01');
        b.Value__c			= 300;
        b.Measure_Unit__c	= 'Fixed quantity';
        
        insert b;
        
        return u;
    }

}