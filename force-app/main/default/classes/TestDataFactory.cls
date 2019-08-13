@isTest
public class TestDataFactory {
    

    public static NC_Graduated_Commission__c createGC(Contact c){
        
        NC_Graduated_Commission__c gc = new NC_Graduated_Commission__c();
        gc.GD_Start_Date__c = Date.valueOf('2019-01-01');
        gc.GC_End_Date__c	= Date.valueOf('2020-12-31');
        gc.Contact__c		= c.Id;
        
        insert gc;
        
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
        
        List<NC_Lease__c> lList = New List<NC_Lease__c>();

        NC_Lease__c l1 = new NC_Lease__c();

        l1.L_Start_Date__c 	= Date.valueOf('2019-01-01');
        l1.L_End_Date__c 	= Date.valueOf('2019-05-31');
        l1.Contact__c = c.Id;
        l1.Unit__c = u.Id;
        l1.L_Amount__c	= 20000;

        lList.add(l1);

        NC_Lease__c l2 = new NC_Lease__c();
        l2.L_Start_Date__c 	= Date.valueOf('2019-06-01');
        l2.L_End_Date__c 	= Date.valueOf('2019-12-30');
        l2.Contact__c = c.Id;
        l2.Unit__c = u.Id;
       	//l2.L_Amount__c	= NC_Lease.calculateTotalCost( l2);
		l2.L_Amount__c	= 40000;
        
        lList.add(l2);
        
        insert lList;
        
        return lList;
    }
    
   
    public static NC_Unit__c createUnitAProperty(Contact c){
        
        NC_Property__c p = new NC_Property__c();

        p.Contact__c = c.Id;

        insert p;

        NC_Unit__c u = new NC_Unit__c();
        u.Property__c = p.Id;
        u.Revenue__c  = 3000;
        
        insert u;
        
        return u;
    }

}