/**
 * Created by user on 2022-07-07.
 */

public with sharing class searchOrderNoTest {

    @AuraEnabled(Cacheable = true)
    public static List<SRO_Order1__c> getOrderNo(String orderNo){
        List<SRO_Order1__c> orderNoList = new List<SRO_Order1__c>();
        try{
            orderNoList = [SELECT SRF_Product__c, SRF_ProductCode__c, Name
            From SRO_Order1__c WHERE NAME =: orderNo order by SRF_OrderDate__c limit 1 ];
        }catch(Exception e){
            System.debug(e.getMessage());
        }

        return orderNoList;
    }
}