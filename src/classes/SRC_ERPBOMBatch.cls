/*
* SRC_ERPBOMBatch.apxc
* 2022.07.20 ver1.0 
* 작성자: 최신욱
* 설명 : ERP -> SFDC [제품정보] SRC_ERPBOMBatch
*/
global with sharing class SRC_ERPBOMBatch implements Database.Batchable<sObject>, Database.Stateful {
    
   	public static List<IF_ERP_SFDC_BOM_Dummy__c> bomDummyList;
    
    public static List<SRO_OrderBOM__c> sro_orderBom;
   
    /*
        start
    */
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('==================BOM batch job started==========================');
        String query = 'SELECT External_Id__c,Id FROM SRO_Order1__c';
        return Database.getQueryLocator(query);
    }
        
    /*
        execute
    */    
    global void execute(Database.BatchableContext BC, List<SRO_Order1__c> orderDummyList){
    	system.debug('==================BOM batch job executed==========================');
        Map<String, Id> orderMap = new Map<String, Id>();
        try{
            for(SRO_Order1__c ord : orderDummyList){
                orderMap.put(ord.External_Id__c, ord.Id);
            }
            
            bomDummyList = [SELECT ExternalId__c, Seq__c, OrderSeq__c, OrderSerl__c, OrderNo__c, ItemSeq__c, ItemName__c,ItemNo__c, BOMLevel__c,
                           MatItemSeq__c, MatItemName__c, MatItemNo__c, MatItemSpec__c, MatBOMRev__c, AssetName__c, Qty__c, IsSynced__c
                           FROM IF_ERP_SFDC_BOM_Dummy__c 
                           WHERE seqSerl__c = :orderMap.keySet() AND IsSynced__c = False];
            
            Map<String, IF_ERP_SFDC_BOM_Dummy__c> BomMap = new Map<String, IF_ERP_SFDC_BOM_Dummy__c>();
            for(IF_ERP_SFDC_BOM_Dummy__c bom : bomDummyList){
                String bomKey = bom.OrderSeq__c + '' + bom.OrderSerl__c;
                BomMap.put(bomKey, bom);
            }
                
            List<SRO_OrderBOM__c> sro_orderBom = new List<SRO_OrderBOM__c>();
            
            for(IF_ERP_SFDC_BOM_Dummy__c bod : bomDummyList){
                String bomKey = bod.OrderSeq__c + '' + bod.OrderSerl__c;    
                if(orderMap.containsKey(bomKey)){  
                    SRO_OrderBOM__c bom = new SRO_OrderBOM__c();

                    bom.SRF_OrderMaster__c = String.valueOf(bod.OrderSeq__c);
                    bom.SRF_OrderDetail__c = String.valueOf(bod.OrderSerl__c);
                    bom.SRF_OrderNo__c = orderMap.get(bomKey); // get한 record id 인서트 하는 것으로 수정
	                bom.SRF_BomLevel__c = bod.BOMLevel__c;
                    
                    bom.SRF_ItemCode__c = String.valueOf(bod.MatItemSeq__c);
                    bom.SRF_ItemName__c = bod.MatItemName__c;
                    bom.SRF_ItemSpec__c = bod.MatItemSpec__c;
                    bom.SRF_ItemNo__c = bod.MatItemNo__c;
                    
                    bom.SRF_AssetName__c = bod.AssetName__c;
                    bom.SRF_Quantity__c  = bod.Qty__c;
                    bom.SRF_Bom__c = Decimal.valueOf(bod.BOMLevel__c);
                        
                    sro_orderBom.add(bom);
                }
                bod.IsSynced__c = True;
             }
            
             update bomDummyList;

                if(sro_orderBom.size() >0){
                    System.debug('size check');
                    try{
                        Database.SaveResult[] InsertResult = Database.insert(sro_orderBom, false);
                        //insert sro_orderBom;
                        for(Database.SaveResult i : InsertResult){
                            if(i.isSuccess()){
                                System.debug('=====================SUCCESS: ' + i.id);
                            } else {
                                System.debug('=====================Error ' + i.getErrors());
                            }
                        }
                    }catch(DMLException e){
                        system.debug('sro_orderBom에 데이터가 정상적으로 insert되지 않았습니다.' + e.getMessage()+e.getLineNumber());   
                    }

                }   
        }catch(Exception e){
              system.debug('sro_orderBom에 데이터가 정상적으로 insert되지 않았습니다.');   
        }
    }
    
    /*
        finish
    */
   global void finish(Database.BatchableContext BC){
        system.debug('==================BOM batch job finished==========================');
   }
}