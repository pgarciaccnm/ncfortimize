/**
 * @File Name          : NC_LeaseTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-12, 8:52:46 a.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-12, 7:12:50 a.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest

public with sharing class NC_LeaseTest {

    @isTest
    public static void setAmountTrue(){
        
        List<NC_Lease__c> lList = createLList();
        
        lList = NC_Lease.setAmount(lList);
        
        system.debug('nc6.6>>'+lList);
        
        System.assertEquals(450000.00, lList[0].L_Amount__c);
        
        System.assertEquals(636000.00, lList[1].L_Amount__c);
    }

    @isTest
    public static void isValidBulkTrue(){
        
        Test.startTest();
        
       
        
        NC_Lease__c insertedGC = createLList()[0];
        
       Id c = insertedGC.Contact__c;

        Test.stopTest();
 
       List<NC_Lease__c> lList = New List<NC_Lease__c>();

        NC_Lease__c l1 = new NC_Lease__c();

        l1.L_Start_Date__c = Date.valueOf('2020-09-01');
        l1.L_End_Date__c = Date.valueOf('2020-09-30');
        l1.Contact__c = c;
        

        lList.add(l1);

        NC_Lease__c l2 = new NC_Lease__c();
        l2.L_Start_Date__c = Date.valueOf('2020-10-01');
        l2.L_End_Date__c = Date.valueOf('2020-10-31');
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


        Test.stopTest();
       
        List<NC_Lease__c> lList = New List<NC_Lease__c>();

        NC_Lease__c l1 = new NC_Lease__c();

        l1.L_Start_Date__c = Date.valueOf('2018-01-10');
        l1.L_End_Date__c = Date.valueOf('2019-01-24');
        l1.Contact__c = c.Id;

        lList.add(l1);

       
      System.assertEquals(new List<NC_Lease__c>(), NC_Lease.getDup(lList));

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
   public static void calculateTotalCostSingleFalse(){

       NC_Lease__c l = TestDataFactory.createLeaseList()[0];
       
       System.debug('nc5.5>>'+l);

       Decimal totalCost = NC_Lease.calculateTotalCost(l);

       System.assertNotEquals(900, totalCost);

   }
   @isTest
   public static void calculateTotalCostSingleTrue(){

       NC_Lease__c l = createLList()[0];

       Decimal totalCost = NC_Lease.calculateTotalCost(l);

       System.assertEquals(450000, totalCost);

   }
    
    @isTest
    public static void getAllRevenueByContactSingleTrue(){
        
        List<NC_Lease__c> l = TestDataFactory.createLeaseList();
        
        Contact c = new Contact(Id = l[0].Contact__c);

        NC_Graduated_Commission__c gc = new NC_Graduated_Commission__c();
        gc.GD_Start_Date__c = Date.valueOf('2019-01-01');
        gc.GC_End_Date__c	= Date.valueOf('2019-12-31');
        gc.Contact__c		= c.Id;

        System.debug('nc6.4>>'+[Select id, L_Amount__c, Contact__c from NC_Lease__c]);
        
        System.assertEquals(20000, NC_Lease.getAllRevenueByContact(gc));
    }
    
    @isTest
    public static Contact createContact(){
        
        Contact c = new Contact(FirstName = 'Pedro', LastName='Garcia');

        insert c;
        
        return c;
    }


   public static List<NC_Lease__c> createLList(){
       
       return TestDataFactory.createLeaseList();


   }
}