public with sharing class SRC_CreateIFAS {
    public static String createInterfaceSFDCAS(Id caseId, List<Id> bomIdList) {


        // String ifResult = 'FAIL';
        // System.debug('안뇽');
        // // CRMAS내부번호(AS품목처리 AUTO), 수주내부코드(수주디테일), AS접수일, 소비자연락처, 출고주소, 클레임분류
        // // 제품분류코드, 유무상구분코드, 맞교환여부, 송장번호1, 송장번호2, 송장번호3, A/S 송장번호, 회수송장번호
        // // 제품코드, 제품명, 제품번호, BOM수량, 요청수량, 영업전달사항

        // List<Case> caseList = [SELECT SRF_RecvMobileNo__c, SRF_DeliveryAddress__c, SRF_UMTroubleType__c, SRF_UMItemType__c, SRF_IsChange__c,
        //                               SRF_UMChargeType__c, SRF_ShipNo2__c, SRF_ShipNo3__c, SRF_ShipNo4__c, SRF_SaelsRemark__c, SRF_ASReqDate__c
        //                        FROM Case WHERE ID = :caseId];
        // List<SRO_CaseBOM__c> caseBOMList = [SELECT NAME, SRF_ItemSeq__c, SRF_ItemName__c, SRF_itemNo__c, SRF_NeedQty__c, SRF_BOMQty__c
        //                                     FROM SRO_CaseBOM__c WHERE ID = :bomIdList];
        // List<IF_SFDC_ERP_AS_Dummy__c> ifASList = new List<IF_SFDC_ERP_AS_Dummy__c>();
        // System.debug('AS리스트 : '   + caseList);
        // System.debug('제품리스트 : ' + caseBOMList);

        // try {
        //     for(SRO_CaseBOM__c cb : caseBOMList) {
            
        //         IF_SFDC_ERP_AS_Dummy__c ifAS = new IF_SFDC_ERP_AS_Dummy__c();
    
        //         ifAS.SRF_CRMSeq__c        = cb.Name;
        //         ifAS.SRF_RecvMobileNo__c  = caseList[0].SRF_RecvMobileNo__c;
        //         ifAS.SRF_RecvAddr__c      = caseList[0].SRF_DeliveryAddress__c;
        //         ifAS.SRF_UMTroubleType__c = Decimal.ValueOf(caseList[0].SRF_UMTroubleType__c);
        //         ifAS.SRF_UMItemType__c    = Decimal.ValueOf(caseList[0].SRF_UMItemType__c);
                
        //         if(caseList[0].SRF_UMChargeType__c == 'false') { ifAS.SRF_UMChargeType__c  = 0; }
        //         else { ifAS.SRF_UMChargeType__c    = 1; }

        //         if(!caseList[0].SRF_IsChange__c) { ifAS.SRF_IsExchange__c = '0'; }
        //         else { ifAS.SRF_IsExchange__c    = '1'; }
                
        //         ifAS.SRF_ShipNo2__c       = caseList[0].SRF_ShipNo2__c;
        //         ifAS.SRF_ShipNo3__c       = caseList[0].SRF_ShipNo3__c;
        //         ifAS.SRF_ShipNo4__c       = caseList[0].SRF_ShipNo4__c;
    
        //         ifAS.SRF_SalesRemark__c   = caseList[0].SRF_SaelsRemark__c;
    
        //         ifAS.SRF_ItemSeq__c  = Decimal.ValueOf(cb.SRF_ItemSeq__c);
        //         ifAS.SRF_ItemName__c = cb.SRF_ItemName__c;
        //         ifAS.SRF_itemNo__c   = cb.SRF_itemNo__c;
        //         ifAS.SRF_BOMQty__c   = cb.SRF_BOMQty__c; 
        //         ifAS.SRF_NeedQty__c  = cb.SRF_NeedQty__c;  
                
    
        //         ifASList.add(ifAS);   
        //     }

        //     for(Integer i = 0; i < ifASList.size(); i++) {
        //         System.debug('인터페이스 생성~' + ifASList[i]);
        //     }

        //     Database.SaveResult[] resultList = Database.insert(ifASList, true);
        //     for(Database.SaveResult s : resultList) {
        //         if(s.isSuccess()) {
        //             ifResult = 'SUCCESS';
        //         }
        //     }
            
        // } catch(Exception e) {

        //     System.debug('ERROR : ' + e.getMessage() + e.getLineNumber());

        // }
        

        // System.debug('RESULT : ' + ifResult);

        return '';
    }
}