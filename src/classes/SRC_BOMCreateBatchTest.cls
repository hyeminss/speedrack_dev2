global class SRC_BOMCreateBatchTest implements Database.Batchable<sObject>, Database.Stateful {
    global SRC_BOMCreateBatchTest() {

    }

    global Database.QueryLocator start(Database.BatchableContext bc) {

        System.debug(' [ BOM BATCH START() ] ');

        String query = 'SELECT Seq__c, OrderSeq__c, OrderSerl__c, OrderNo__c, ItemSeq__c, ItemName__c,ItemNo__c, BOMLevel__c, MatItemSeq__c, MatItemName__c, MatItemNo__c, MatItemSpec__c, MatBOMRev__c, AssetName__c, Qty__c, IsSynced__c FROM IF_ERP_SFDC_BOM_Dummy__c';

        System.debug('콰리 : ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<IF_ERP_SFDC_BOM_Dummy__c> bomDummyList) {

        System.debug(' [ BOM BATCH EXECUTE() ] ');

        Map<String, String> m = new Map<String, String>();
        List<SRO_OrderBOM__c> bomList = new List<SRO_OrderBOM__c>();

        try {

            // d
            for(IF_ERP_SFDC_BOM_Dummy__c b : bomDummyList) {            
                m.put(b.OrderSeq__c + b.OrderSerl__c, null);
            }   

            List<SRO_Order1__c> ordList = [SELECT External_Id__c, Id FROM SRO_Order1__C WHERE External_Id__c = :m.keySet()];

            for(SRO_Order1__C o : ordList) {
                m.put(o.External_Id__c, o.Id);
            }

            for(String key : m.keySet()) {
                if(m.get(key) != null) {
                    // System.debug('하이~' + key);
                } else {
                    System.debug('없다고');
                }
            }

            for(Integer i = 0; i < bomDummyList.size(); i++) {
                SRO_OrderBOM__c oBOM = new SRO_OrderBOM__c();

                if(m.keySet() != null) {
                    // oBOM.SRF_OrderMaster__c = 
                }
            }

            System.debug('ORDER MAP : ' + m);
        } catch(Exception e) {
            System.debug('ERROR : ' + e.getLineNumber() + ' ' + e.getMessage());
        }

    }

    global void finish(Database.BatchableContext BC) {
        System.debug(' [ BOM BATCH FINISH() ]');
    }
}