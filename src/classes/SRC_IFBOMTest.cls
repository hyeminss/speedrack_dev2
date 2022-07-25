/*
*   SRC_IFBOMTest.cls
*   2022.07.20 ver1.0 이새미 작성
*   설명 : ERP 수주제품 정보 수신 Interface
*/
@RestResource(UrlMapping='/test/getBOM')
global with sharing class SRC_IFBOMTest {
    @HttpPost
    global static void getERPBOMTest() {

        String responseBody = '';
        RestRequest req = RestContext.request;
        Map<Integer, String> resultMap = new Map<Integer, String>();
        List<SRC_ERPBOMJsonWrapper.ReturnJson> returnList = new List<SRC_ERPBOMJsonWrapper.ReturnJson>();

        if(req != null) {
            
            try {
                String requestBody = req.requestBody.toString();
                // Input Data Deserialize()
                List<SRC_ERPBOMJsonWrapper.ReceiveJson> receiveList = (List<SRC_ERPBOMJsonWrapper.ReceiveJson>)JSON.deserialize(requestBody, List<SRC_ERPBOMJsonWrapper.ReceiveJson>.class);                

                if(String.isNotBlank(requestBody)) {

                    List<IF_ERP_SFDC_BOM_Dummy__c> bomList = insertBomRecords(receiveList);
                    if(bomList.size() > 0) {
                        Database.SaveResult[] saveList = Database.insert(bomList, false);
                        for(Integer i = 0; i < saveList.size(); i++) {
                            if(saveList[i].isSuccess()) {
                                resultMap.put(i, 'SUCCESS');
                            } else {
                                resultMap.put(i, 'FAIL');
                            }
    
                            System.debug(saveList[i].getErrors());
                        }
    
                        System.debug('RESULT MAP : ' + resultMap);
    
                        for(Integer i = 0; i < bomList.size(); i++ ) {
                            SRC_ERPBOMJsonWrapper.ReturnJson respJson = new SRC_ERPBOMJsonWrapper.ReturnJson();
                            respJson.seq = Integer.ValueOf(bomList[i].Seq__c);
                            respJson.orderSeq = Integer.ValueOf(bomList[i].OrderSeq__c);
                            respJson.orderSerl = Integer.ValueOf(bomList[i].OrderSerl__c);
    
                            if(resultMap.get(i) == 'SUCCESS') {
                                respJson.recvYn = 'Y';
                            } else if(resultMap.get(i) == 'FAIL') {
                                respJson.recvYn = 'N';
                            }
    
                            returnList.add(respJson);                    
    
                        }
    
                        responseBody = JSON.serialize(returnList);
                        System.debug('REPONSE BODY : ' + responseBody);
                    }
                    
                }

            } catch (Exception e) {
            
                responseBody = '[ ERROR ] : ' + e.getCause();
                System.debug('ERROR : ' + e.getCause());
                          
            } // try catch

            if(String.isNotBlank(responseBody)) {
                RestContext.response.responseBody = Blob.valueOf(responseBody);  
            }
        } // req != null

    } // getERPBomTest()

    private static List<IF_ERP_SFDC_BOM_Dummy__c> insertBomRecords(List<SRC_ERPBOMJsonWrapper.ReceiveJson> receiveList) {


        List<IF_ERP_SFDC_BOM_Dummy__c> bomList = new List<IF_ERP_SFDC_BOM_Dummy__c>();
    
        // Map<String, String> map = new Map<String, String>();
        Map<String, String> m = new Map<String, String>();

        for(SRC_ERPBOMJsonWrapper.ReceiveJson r : receiveList) {
            
            m.put(r.orderSeq + '' + r.orderSerl, 'UNMATCH');

        }

        List<IF_ERP_SFDC_Order_Dummy__c> ordList = [SELECT OrderSeq__c, OrderSerl__c FROM IF_ERP_SFDC_Order_Dummy__c WHERE ExternalId__c =: m.keySet()];

        for(IF_ERP_SFDC_Order_Dummy__c o : ordList) {
            System.debug(' dhkdkr');
            m.put(o.OrderSeq__c + o.OrderSerl__c + '', 'MATCH');
        }

        for(String key : m.keySet()) {
            System.debug('호로롥' + m);
        }

        String tempKey;
        for(SRC_ERPBOMJsonWrapper.ReceiveJson r : receiveList) {
            IF_ERP_SFDC_BOM_Dummy__c ifBOM = new IF_ERP_SFDC_BOM_Dummy__c();

                tempKey = r.orderSeq + '' + r.orderSerl;

                ifBOM.Seq__c         = r.Seq;            // 시퀀스
                ifBOM.CrtDateTime__c = r.CrtDateTime;    // 생성일
                ifBOM.CompanySeq__c  = r.companySeq;     // companySeq

                ifBOM.OrderSeq__c    = r.orderSeq + '';       // 오더 마스터
                ifBOM.OrderSerl__c   = r.orderSerl + '';      // 오더 디테일
                ifBOM.OrderNo__c     = r.orderNo;        // 수주 번호

                ifBOM.BOMLevel__c    = r.bomLevel;       // BOM Level
                ifBOM.ItemSeq__c     = r.itemSeq;        // 제품 내부코드 == 세트
                ifBOM.ItemName__c    = r.itemName;       // 제품명
                ifBOM.ItemNo__c      = r.itemNo;         // 제품번호

                ifBOM.MatItemSeq__c  = r.matItemSeq;     // 자재 내부코드
                ifBOM.MatItemName__c = r.matItemName;    // 자재명
                ifBOM.MatItemNo__c   = r.matItemNo;      // 자재번호
                ifBOM.MatItemSpec__c = r.matItemSpec;    // 자재 규격

                ifBOM.BOMLevel__c    = r.bomLevel;       // BOM 하위 차수
                ifBOM.AssetName__c   = r.assetName;      // 재고 자산 분류
                ifBOM.Qty__c         = r.qty;            // 수량

            if(m.containsKey(tempKey) && m.get(tempKey) == 'MATCH') {
                
                ifBOM.RecvYn__c      = 'Y';             // recvYn = 수주와 일치하지 않으면 Y                
                ifBOM.ExternalId__c  = r.seq + tempKey;
                
            } else {
                ifBOM.RecvYn__c      = 'N';             // recvYn = 수주와 일치하지 않으면 Y
                
            }
            bomList.add(ifBOM);       
        }

        System.debug('제품 리스트 : ' + bomList);

        return bomList;
    }

} // class{}