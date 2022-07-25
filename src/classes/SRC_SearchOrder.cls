public with sharing class SRC_SearchOrder {

    @AuraEnabled(Cacheable = true)
    public static list<SRO_OrderBOM__c> retriveOrder(String orderNo) {
        orderNo = '%' + orderNo + '%';
        list<SRO_OrderBOM__c> lstOrder = [SELECT Id,SRF_Bom__c,SRF_ItemCode__c,SRF_ItemName__c,SRF_ItemNo__c,SRF_OrderMaster__c, SRF_OrderDetail__c From SRO_OrderBOM__c WHERE SRF_OrderNo__r.Name LIKE :orderNo];

        if(lstOrder.isEmpty()) {
            throw new AuraHandledException('찾을 수 없습니다. 다시 입력하세요.');
        }
        return lstOrder; 
    }

    @AuraEnabled(Cacheable = true)
    public static list<SRO_Order1__c> retriveSRO(String orderNo) {
        orderNo = '%' + orderNo + '%';
        list<SRO_Order1__c> lstSRO = [SELECT Id,Name,SRF_Product__c,SRF_ProductCode__c,SRF_BOMUnderCode__c,SRF_ReceiverName__c,SRF_ReceiverPhone1__c ,SRF_ReceiverAddress__c,SRF_MasterCode__c,SRF_Orderdetail__c From SRO_Order1__c WHERE NAME LIKE :orderNo];

        if(lstSRO.isEmpty()) {
            throw new AuraHandledException('찾을 수 없습니다. 다시 입력하세요.');
        }
        return lstSRO; 
    }

    @AuraEnabled(cacheable=true)
    public static List<SRO_Order1__c> getCustomLookupSRO (String sroNo){
        List<SRO_Order1__c> sroLookupList =  new List<SRO_Order1__c>();
        if(sroNo != ''){
            sroNo = '%' + sroNo + '%';
            sroLookupList = [Select Id, Name,SRF_ReceiverName__c,SRF_RecieverPhone2__c,SRF_ReceiverAddress__c From SRO_Order1__c WHERE NAME LIKE:sroNo];
            return sroLookupList;
        }
        return sroLookupList;
    }

    @AuraEnabled(cacheable=true)
    public static List<SRO_OrderBOM__c> getCustomLookupBOM (String sroNo){
        List<SRO_OrderBOM__c> sroBOMList =  new List<SRO_OrderBOM__c>();
        if(sroNo != null){
            sroBOMList = [Select Id,SRF_OrderNo__c,SRF_ItemName__c,SRF_ItemNo__c,SRF_ItemCode__c From SRO_OrderBOM__c WHERE SRF_OrderNo__r.Name =: sroNo];
            return sroBOMList;
        }
        return sroBOMList;
    }

}