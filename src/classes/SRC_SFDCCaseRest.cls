/*
*   SRC_SFDCCaseRest.cls
*   2022.07.07  ver0.1 김용훈 작성
*   설명: [SFDC > ERP] AS정보 송신을 위한 인터페이스
*   IF_SFDC_ERP_AS_Dummy__c 에서 가져온 값들을 하나씩 Wrapper에 삽입 후 Json으로 변환 후 전송
*       SRF_AUDType__c 값이 A 또는 U 인 경우만 진행한다.
*   전송 한 후 중복 전송을 방지하기 위해 해당 record들의 SRF_AUDType__c 값을 D로 변경한다.
*/
@RestResource(UrlMapping = '/sfdc/createAS')
global with sharing class SRC_SFDCCaseRest {

    @HttpPost
    global static void sendSFDCCase(){
        String responseBody;
        String requestBody = RestContext.request.requestBody.toString();

        List<SRC_SFDCCaseRestWrapper.ReceiveJson> recvList = (List<SRC_SFDCCaseRestWrapper.ReceiveJson>) JSON.deserialize(requestBody, List<SRC_SFDCCaseRestWrapper.ReceiveJson>.class);
        String jsonText;

        List<IF_SFDC_ERP_AS_Dummy__c> erpList = new List<IF_SFDC_ERP_AS_Dummy__c>();

        try {
            if(recvList[0].companySeq == 1){
                List<IF_SFDC_ERP_AS_Dummy__c> records = new List<IF_SFDC_ERP_AS_Dummy__c>();
                records = [SELECT Name, SRF_AUDType__c, SRF_CrtDateTime__c, SRF_CompanySeq__c,
                                SRF_CRMSeq__c, SRF_OrderSeq__c, SRF_ASReqDate__c, SRF_RecvMobileNo__c,
                                SRF_RecvAddr__c, SRF_UMTroubleType__c, SRF_UMItemType__c, SRF_UMChargeType__c,
                                SRF_IsExchange__c, SRF_ShipNo2__c, SRF_ShipNo3__c, SRF_ShipNo4__c, SRF_AsShip2__c,
                                SRF_ReturnShipno__c, SRF_ItemSeq__c, SRF_ItemName__c, SRF_ItemNo__c, SRF_BOMQty__c,
                                SRF_NeedQty__c, SRF_SalesRemark__c FROM IF_SFDC_ERP_AS_Dummy__c
                                WHERE SRF_AUDType__c IN ('A', 'U', 'D')];
                
                List<SRC_SFDCCaseRestWrapper.ReturnJson> returnRecords = new List<SRC_SFDCCaseRestWrapper.ReturnJson>();
                returnRecords = createSFDCRecords(records);
                jsonText = JSON.serialize(returnRecords, false);
                
                
                // for(IF_SFDC_ERP_AS_Dummy__c record : records){
                //     record.SRF_AUDType__c = 'D';
                //     erpList.add(record);
                // }
                
            } else {
                SRC_SFDCCaseRestWrapper.ReceiveJson returnText = new SRC_SFDCCaseRestWrapper.ReceiveJson();
                returnText.companySeq = 0;
                jsonText = JSON.serialize(returnText, false);
            }

            // Database.upsert(erpList, IF_SFDC_ERP_AS_Dummy__c.Fields.SRF_CRMSeq__c, false);
            // Database.upsert(erpList, false);

            RestContext.response.responseBody = Blob.valueOf(jsonText);
            system.debug('RETURN: '+ jsonText);

        } catch(Exception e){
            System.debug('ERROR: ' + e.getMessage());
        }
    }


    private static List<SRC_SFDCCaseRestWrapper.ReturnJson> createSFDCRecords(List<IF_SFDC_ERP_AS_Dummy__c> records){

        List<SRC_SFDCCaseRestWrapper.ReturnJson> sfdcList = new List<SRC_SFDCCaseRestWrapper.ReturnJson>();
 
        for(IF_SFDC_ERP_AS_Dummy__c record : records){
            SRC_SFDCCaseRestWrapper.ReturnJson ifSFDC = new SRC_SFDCCaseRestWrapper.ReturnJson();
            
            ifSFDC.AUDType      	=	record.SRF_AUDType__c;
            ifSFDC.CrtDateTime  	=	record.SRF_CrtDateTime__c;
            ifSFDC.CompanySeq   	=	Integer.valueOf(record.SRF_CompanySeq__c);
            ifSFDC.CRMASSeq      	=	record.Name; //record.SRF_CRMSeq__c;
            ifSFDC.OrderSeq      	=	Integer.valueOf(record.SRF_OrderSeq__c);
            ifSFDC.ASReqDate    	=	record.SRF_ASReqDate__c;
            ifSFDC.RecvMobileNo 	=	record.SRF_RecvMobileNo__c;
            ifSFDC.RecvAddr      	=	record.SRF_RecvAddr__c;
            ifSFDC.UMTroubleType	=	Integer.valueOf(record.SRF_UMTroubleType__c);
            ifSFDC.UMItemType   	=	Integer.valueOf(record.SRF_UMItemType__c);
            ifSFDC.UMChargeType 	=	Integer.valueOf(record.SRF_UMChargeType__c);
            ifSFDC.IsExchange   	=	record.SRF_IsExchange__c;
            ifSFDC.ShipNo2      	=	record.SRF_ShipNo2__c;
            ifSFDC.ShipNo3      	=	record.SRF_ShipNo3__c;
            ifSFDC.ShipNo4      	=	record.SRF_ShipNo4__c;
            ifSFDC.ASShipNo2    	=	record.SRF_AsShip2__c;
            ifSFDC.ReturnShipNo 	=	record.SRF_ReturnShipNo__c;
            ifSFDC.ItemSeq      	=	Integer.valueOf(record.SRF_ItemSeq__c);
            ifSFDC.ItemName     	=	record.SRF_ItemName__c;
            ifSFDC.ItemNo       	=	record.SRF_ItemNo__c;
            ifSFDC.BOMQty       	=	record.SRF_BOMQty__c;
            ifSFDC.NeedQty      	=	record.SRF_NeedQty__c;
            ifSFDC.SalesRemark  	=	record.SRF_SalesRemark__c;

            sfdcList.add(ifSFDC);
        }

        System.debug(sfdcList);
        return sfdcList;
    }
}