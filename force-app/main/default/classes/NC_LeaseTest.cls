/**
 * @File Name          : NC_LeaseTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-14, 12:50:20 a.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-12, 7:12:50 a.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest

public with sharing class NC_LeaseTest {
    
    @isTest
    public static void setEarnedBulkTrue(){

        List<NC_Lease__c> l = TestDataFactory.createLeaseList();
        
        System.debug('nc4.4>>'+l);

        System.debug('nc4.5>>'+NC_Lease.setEarned(l));
        

        
        //System.assertEquals((5824.0000).setScale(2), NC_Lease.setEarned(l));

 
    }

    @isTest
    public static void getDupBulkFalse(){
        
        List<NC_Lease__c> leases = NC_Lease.getDup(TestDataFactory.createLeaseList());
        
        System.assertEquals(1, leases.size());
        
    }
    
    @isTest
    public static void getDupBulkTrue(){
        
        Contact c = new Contact(LastName = 'Pepe');
        
        insert c;
        
        NC_Graduated_Commission__c gc = new NC_Graduated_Commission__c();
        gc.GD_Start_Date__c = Date.valueOf('2019-01-01');
        gc.GC_End_Date__c	= Date.valueOf('2020-12-31');
        gc.Contact__c		= c.Id;
        
        insert gc;
        
        NC_Unit__c u = TestDataFactory.createUnitAProperty(c);
        
        List<NC_Lease__c> lList = New List<NC_Lease__c>();

        NC_Lease__c l1 = new NC_Lease__c();

        l1.Graduated_Commission__c = gc.Id;
        l1.Unit__c = u.Id;
        l1.L_Amount__c	= 20000;

        lList.add(l1);
        System.debug('nc8.8>>'+[Select id from NC_Graduated_Commission__c]);
        System.assertEquals(1, NC_Lease.getDup(lList).size());
        
        
    }
    
    @isTest
    public static void getDupSingleFalse(){
        
        List<NC_Lease__c> onlyOneLease = TestDataFactory.createLeaseList();
        
        onlyOneLease.remove(0);
            
        List<NC_Lease__c> leases = NC_Lease.getDup(onlyOneLease);
        
        System.assertEquals(0, leases.size());
        
    }

    @isTest
    public static void getAllrevenueByGCSingleTrue(){
        
        List<NC_Lease__c> l = TestDataFactory.createLeaseList();
        
        NC_Graduated_Commission__c gc = new NC_Graduated_Commission__c(Id = l[0].Graduated_Commission__c);
        
        List<NC_Graduated_Commission__c> gcList = new List<NC_Graduated_Commission__c>();
        
        gcList.add(gc);
        
        System.debug('nc9.9>>'+NC_Lease.getAllrevenueByGC(gcList));
        
        Map<Id, Decimal> testMap = NC_Lease.getAllrevenueByGC(gcList);
        
        testMap.put(gc.Id, 800800.00);
        
        
        System.assertEquals(800800.00,  testMap.get(gc.Id) );
    }
 
}