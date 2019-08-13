/**
 * @File Name          : NC_Graduated_CommissionTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-11, 2:40:46 p.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-11, 10:30:14 a.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/

@isTest
public with sharing class NC_Graduated_CommissionTest {
   

    @isTest
    public static void getCurrentGraduatedCommissionSingleTrue(){
               
        List<NC_Lease__c> l = TestDataFactory.createLeaseList();
        
        Contact c = new Contact(Id = l[0].Contact__c);

        NC_Graduated_Commission__c gc = new NC_Graduated_Commission__c();
        gc.GD_Start_Date__c = Date.valueOf('2019-01-01');
        gc.GC_End_Date__c	= Date.valueOf('2019-12-31');
        gc.Contact__c		= c.Id;
        gc.GC_Goal__c		= 200000;
        
        insert gc;

       NC_Graduated_Commission.getCurrentGraduatedCommission(l[0]);
        
        System.debug('nc8.5>>'+NC_Graduated_Commission.getCurrentGraduatedCommission(l[0]));
    }
    
    @isTest
    public static void isValidBulkTrue(){
        
        Test.startTest();
        
        insert createGCList();
        
        NC_Graduated_Commission__c insertedGC = createGCList()[0];
        
       Id c = insertedGC.Contact__c;

        Test.stopTest();
 
       List<NC_Graduated_Commission__c> gcList = New List<NC_Graduated_Commission__c>();

        NC_Graduated_Commission__c gc1 = new NC_Graduated_Commission__c();

        gc1.GD_Start_Date__c = Date.valueOf('2019-09-01');
        gc1.GC_End_Date__c = Date.valueOf('2019-09-30');
        gc1.Contact__c = c;
        gc1.GC_Goal__c = 700000;

        gcList.add(gc1);

        NC_Graduated_Commission__c gc2 = new NC_Graduated_Commission__c();
        gc2.GD_Start_Date__c = Date.valueOf('2019-10-01');
        gc2.GC_End_Date__c = Date.valueOf('2019-10-31');
        gc2.Contact__c = c;
        gc2.GC_Goal__c = 700000;

        gcList.add(gc2);
        
        System.debug('nc4.1>>'+gcList);
        System.debug('nc4.2>>'+createGCList());
        
        List<NC_Graduated_Commission__c> ncList = NC_Graduated_Commission.isValid(gcList);
        
        System.debug('nc4.3>>'+ncList);
        
        System.assertEquals(new  List<NC_Graduated_Commission__c>(), ncList);
        
    }
    
    @isTest
    public static void isValidBulkFalse(){
        
        Test.startTest();
        
        insert createGCList();

        Test.stopTest();
        
        List<NC_Graduated_Commission__c> ncList = NC_Graduated_Commission.isValid(createGCList());
        
		System.assertEquals(ncList, ncList);
        
    }
    
   @isTest
   public static void haskOverlapBulkTrue(){
       
       System.assertEquals(new List<NC_Graduated_Commission__c>(), NC_Graduated_Commission.haskOverlap(createGCList(), createGCList()));

   }
    
      @isTest
   public static void isValidSingleFalse(){
 
       Test.startTest();
		       
       Contact c = new Contact(LastName = 'Garcia', FirstName = 'Pedro');
       insert c;
       
       List<NC_Graduated_Commission__c> gcInsertedList = createGCList();
       for(NC_Graduated_Commission__c gc : gcInsertedList){
           
           gc.Contact__c = c.Id;
       }
               
       insert gcInsertedList;

        Test.stopTest();
       
        List<NC_Graduated_Commission__c> gcList = New List<NC_Graduated_Commission__c>();

        NC_Graduated_Commission__c gc1 = new NC_Graduated_Commission__c();

        gc1.GD_Start_Date__c = Date.valueOf('2018-01-10');
        gc1.GC_End_Date__c = Date.valueOf('2019-01-24');
        gc1.Contact__c = c.Id;
        gc1.GC_Goal__c = 700000;

        gcList.add(gc1);
       

       
       
      System.assertEquals(gcList, NC_Graduated_Commission.isValid(gcList));

   }
    

    
   @isTest
   public static void haskOverlapBulkFalse(){
       
       List<NC_Graduated_Commission__c> dupGC = new List<NC_Graduated_Commission__c>();
       
       for(NC_Graduated_Commission__c gc : createGCList()){

            gc.GD_Start_Date__c = Date.valueOf('2019-01-01');
            gc.GC_End_Date__c = Date.valueOf('2019-01-31');
           
           dupGC.add(gc);

       }
       
       List<NC_Graduated_Commission__c> dupGC2 = NC_Graduated_Commission.haskOverlap(dupGC, dupGC);

       System.assertNotEquals(dupGC2, dupGC);

   }

    @isTest
   public static List<NC_Graduated_Commission__c> createGCList(){

        Contact c = new Contact(FirstName = 'Pedro', LastName='Garcia');

        insert c;
        
        List<NC_Graduated_Commission__c> gcList = New List<NC_Graduated_Commission__c>();

        NC_Graduated_Commission__c gc1 = new NC_Graduated_Commission__c();

        gc1.GD_Start_Date__c = Date.valueOf('2019-01-01');
        gc1.GC_End_Date__c = Date.valueOf('2019-01-31');
        gc1.Contact__c = c.Id;
        gc1.GC_Goal__c = 700000;

        gcList.add(gc1);

        NC_Graduated_Commission__c gc2 = new NC_Graduated_Commission__c();
        gc2.GD_Start_Date__c = Date.valueOf('2019-02-01');
        gc2.GC_End_Date__c = Date.valueOf('2019-02-28');
        gc2.Contact__c = c.Id;
        gc2.GC_Goal__c = 700000;

        gcList.add(gc2);

            return gcList;


   }
}