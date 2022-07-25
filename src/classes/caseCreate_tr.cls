public with sharing class caseCreate_tr extends TriggerHandler {
    // private List<Case> listCase = trigger.new;
    // //private List<Case> listCase = trigger.old;
    
    // public override void afterInsert(){
        
    //     try {
    //         //case에 있는 수주번호 = 수주제품에 있는 수주참조
    //         //List<Case> listCase = [SELECT Id,SRF_OrderNum__r.Name,CaseNumber FROM Case];//AS처리
    //         List<SRO_OrderBOM__c> listBomName = [SELECT SRF_OrderNo__r.Name,SRF_ItemCode__c,SRF_ItemName__c,SRF_ItemNo__c FROM SRO_OrderBOM__c];//수주제품
    //         List<SRO_CaseBOM__c> listBom = new List<SRO_CaseBOM__c> ();//as품목처리
    //         System.debug('하아아아ㅏ : ' + listCase);
    //         System.debug('하아아아ㅏ : ' + listBomName);[]
            
    //         for(SRO_OrderBOM__c bom:listBomName){
    //             for(Case cas:listCase){
    //                 if(cas.SRF_OrderNum__r.Name == bom.SRF_OrderNo__r.Name){
    //                     SRO_CaseBOM__c test = new SRO_CaseBOM__c();
    //                     test.ItemSeq__c  = bom.SRF_ItemCode__c;
    //                     test.ItemName__c = bom.SRF_ItemName__c;
    //                     test.ProcQty__c     = Integer.valueOf(bom.SRF_ItemNo__c);
    //                     //test.SRF_LookupAS__r.CaseNumber = cas.recordId;
    //                     listBom.add(test);
    
    //                 }
    //             }
    //         }
            
    //         System.debug('하아아아ㅏ : ' + listBom);
            
    //         List<SRO_CaseBOM__c> listBomIn = new List<SRO_CaseBOM__c>(listBom);//AS품목처리
    //         Database.SaveResult[] save = Database.insert(listBomIn);
    //         for(Database.SaveResult s : save) {
    //             //System.debug(s.isSuccess().;
    //         }
    //         //insert(listBomIn);
    //     } catch(Exception e) {
    //         System.debug('에에에에러 : ' + e.getMessage() + e.getLineNumber());
    //     }
        

    // }
}