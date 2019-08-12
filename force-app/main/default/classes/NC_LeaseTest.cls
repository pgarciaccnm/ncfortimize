/**
 * @File Name          : NC_LeaseTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-12, 7:46:36 a.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-12, 7:12:50 a.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest

public with sharing class NC_LeaseTest {


    @isTest
    public static void isValidBulkTrue(){
        
        Test.startTest();
        
        insert createLList();
        
        NC_Lease__c insertedGC = createLList()[0];
        
       Id c = insertedGC.Contact__c;

        Test.stopTest();
 
       List<NC_Lease__c> lList = New List<NC_Lease__c>();

        NC_Lease__c l1 = new NC_Lease__c();

        l1.L_Start_Date__c = Date.valueOf('2019-09-01');
        l1.L_End_Date__c = Date.valueOf('2019-09-30');
        l1.Contact__c = c;
        

        lList.add(l1);

        NC_Lease__c l2 = new NC_Lease__c();
        l2.L_Start_Date__c = Date.valueOf('2019-10-01');
        l2.L_End_Date__c = Date.valueOf('2019-10-31');
        l2.Contact__c = c;
      

        lList.add(l2);
        
        System.debug('nc4.1>>'+lList);
        System.debug('nc4.2>>'+createLList());
        
        List<NC_Lease__c> dupList = NC_Lease.getDup(lList);
        
        System.debug('nc4.3>>'+dupList);
        
        System.assertEquals(new  List<NC_Lease__c>(), dupList);
        
    }
    
    @isTest
    public static void isValidBulkFalse(){
        
        Test.startTest();
        
        insert createLList();

        Test.stopTest();
        
        List<NC_Lease__c> lList = NC_Lease.getDup(createLList());
        
		System.assertEquals(lList, lList);
        
    }
    
   @isTest
   public static void haskOverlapBulkTrue(){
       
       System.assertEquals(new List<NC_Lease__c>(), NC_Lease.haskOverlap(createLList(), createLList()));

   }
    
      @isTest
   public static void isValidSingleFalse(){
 
       Test.startTest();
		       
       Contact c = new Contact(LastName = 'Garcia', FirstName = 'Pedro');
       insert c;
       
       List<NC_Lease__c> gcInsertedList = createLList();
       for(NC_Lease__c gc : gcInsertedList){
           
           gc.Contact__c = c.Id;
       }
               
       insert gcInsertedList;

        Test.stopTest();
       
        List<NC_Lease__c> lList = New List<NC_Lease__c>();

        NC_Lease__c l1 = new NC_Lease__c();

        l1.L_Start_Date__c = Date.valueOf('2018-01-10');
        l1.L_End_Date__c = Date.valueOf('2019-01-24');
        l1.Contact__c = c.Id;

        lList.add(l1);

       
      System.assertEquals(lList, NC_Lease.getDup(lList));

   }
    

    
   @isTest
   public static void haskOverlapBulkFalse(){
       
       List<NC_Lease__c> dupL = new List<NC_Lease__c>();
       
       for(NC_Lease__c gc : createLList()){

            gc.L_Start_Date__c = Date.valueOf('2019-01-01');
            gc.L_End_Date__c = Date.valueOf('2019-01-31');
           
           dupL.add(gc);

       }
       
       List<NC_Lease__c> dupl2 = NC_Lease.haskOverlap(dupL, dupL);

       System.assertNotEquals(dupl2, dupL);

   }

     @isTest
   public static List<NC_Lease__c> createLList(){

        Contact c = new Contact(FirstName = 'Pedro', LastName='Garcia');

        insert c;

        NC_Property__c p = new NC_Property__c();

        p.Contact__c = c.Id;

        insert p;

        NC_Unit__c u = new NC_Unit__c();
        u.Property__c = p.Id;
        u.Revenue__c  = 3000;

        insert u;
        
        List<NC_Lease__c> lList = New List<NC_Lease__c>();

        NC_Lease__c l1 = new NC_Lease__c();

        l1.L_Start_Date__c = Date.valueOf('2019-01-01');
        l1.L_End_Date__c = Date.valueOf('2019-01-31');
        l1.Contact__c = c.Id;
        l1.Unit__c = u.Id;

        lList.add(l1);

        NC_Lease__c l2 = new NC_Lease__c();
        l2.L_Start_Date__c = Date.valueOf('2019-02-01');
        l2.L_End_Date__c = Date.valueOf('2019-02-28');
        l2.Contact__c = c.Id;
        l2.Unit__c = u.Id;

        lList.add(l2);

        return lList;


   }
}
