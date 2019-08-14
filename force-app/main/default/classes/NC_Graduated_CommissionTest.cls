/**
 * @File Name          : NC_Graduated_CommissionTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-13, 2:11:28 p.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-11, 10:30:14 a.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/

@isTest
public with sharing class NC_Graduated_CommissionTest {
    /*
   @isTest
    public static void calculateBoutyEarnedSingleTrue(){
        
        List<NC_Lease__c> ls = TestDataFactory.createLeaseList();
        
        
        for(NC_Lease__c l : ls){
            
            Decimal earnedbounty = NC_Graduated_Commission.calculateBoutyEarned(l);
            
            System.debug('nc0.5>>'+earnedbounty+' - '+l.L_Start_Date__c+' - '+l.L_End_Date__c);
            
            if(l.L_Start_Date__c == Date.valueOf('2019-01-01')){
                
                System.assertEquals(300, earnedbounty);
            }
            else{
                System.assertEquals(0, earnedbounty);
                
            }
            
        }    
    }
    @isTest
    public static void calculateCommissionSingleTrue(){
        

        List<NC_Lease__c> l = TestDataFactory.createLeaseList();
        
        Contact c = new Contact(Id = l[0].Contact__c);

        NC_Graduated_Commission__c gc = new NC_Graduated_Commission__c();
        gc.GD_Start_Date__c = Date.valueOf('2019-01-01');
        gc.GC_End_Date__c	= Date.valueOf('2019-12-31');
        gc.Contact__c		= c.Id;
        gc.GC_Goal__c		= 80000;
        
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
        System.debug('nc8.57>>'+NC_Graduated_Commission.calculateCommission(l[0]));
        
        //current Earned percent: 25
        System.assertEquals(((100 * 25.00)+300).setScale(2), NC_Graduated_Commission.calculateCommission(l[0]));
        
        gc.GC_Goal__c		= 27000;
        update gc;
        //current Earned percent: 74.07
        System.assertEquals(((150 * 74.0740741).setScale(2)+300), NC_Graduated_Commission.calculateCommission(l[0]));
        
              
        gc.GC_Goal__c		= 100000;
        update gc;
        //current Earned percent: 20
        System.assertEquals(300, NC_Graduated_Commission.calculateCommission(l[0]));
        

        
    }

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
   */
}