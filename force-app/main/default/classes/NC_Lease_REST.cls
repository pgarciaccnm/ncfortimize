/**
 * @File Name          : NC_Lease_REST.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2019-08-14, 9:31:32 a.m.
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-08-14, 9:31:32 a.m.   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@RestResource(urlMapping='/Account/*')
global with sharing class NC_Lease_REST {

    @HttpDelete
    global static void doDelete() {
//@TODO
    }
  
    @HttpGet
    global static NC_Lease__c doGet() {
//@TODO
		return null;
    }
  
  @HttpPost
    global static String doPost(NC_Lease__c lease) {
//@TODO this return the inserted object
		return null;
    }
}