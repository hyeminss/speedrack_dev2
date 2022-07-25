/*
*   SRC_ERPCaseRest.cls
*   2022.07.06  ver0.1 김용훈 작성
*   설명: [ERP > SFDC] AS정보 수신을 위한 인터페이스
*/
@RestResource(UrlMapping = '/sfdc/getAS')
global with sharing class SRC_ERPCaseRest {

    @HttpPost
    global static void getERPCase(){
        String responseBody;
        String requestBody = RestContext.request.requestBody.toString();
        

        List<SRC_ERPCaseWrapper.ReturnJson> rtrnList = new List<SRC_ERPCaseWrapper.ReturnJson>();

        try{
            if(String.isNotBlank(requestBody)){
                List<SRC_ERPCaseWrapper.ReceiveJson> recvList = (List<SRC_ERPCaseWrapper.ReceiveJson>) JSON.deserialize(requestBody, List<SRC_ERPCaseWrapper.ReceiveJson>.class);
                List<SRC_ERPCaseWrapper.ReceiveJson> recvSuccessList = new List<SRC_ERPCaseWrapper.ReceiveJson>();
                List<IF_ERP_SFDC_AS_Dummy__c> asList = SRC_CrerateCaseDummy.crerateCaseDummy(recvList);
                List<IF_ERP_SFDC_AS_Dummy__c> asSuccessList = new List<IF_ERP_SFDC_AS_Dummy__c>();
                // List<IF_SFDC_ERP_AS_Dummy__c> recvCheckList = new List<IF_SFDC_ERP_AS_Dummy__c>();
                
                
                if(asList.size() > 0) {
                    Schema.SobjectField extId = IF_ERP_SFDC_AS_Dummy__c.Fields.ExternalId__c;
                    Database.UpsertResult[] saveList = Database.upsert(asList, extId, false);

                    for(Integer i = 0; i < saveList.size(); i++){

                        //레코드 생성 성공, 실패 여부를 회신할 JSON 데이터 생성
                        SRC_ERPCaseWrapper.ReturnJson output = new SRC_ERPCaseWrapper.ReturnJson();
                        IF_SFDC_ERP_AS_Dummy__c recvCheck = new IF_SFDC_ERP_AS_Dummy__c();//(Name=asList[i].CRMASSeq__c);

                        output.seq = Integer.ValueOf(asList[i].Seq__c);
                        output.asSeq = Integer.ValueOf(asList[i].ASSeq__c);
                        output.asSerl = Integer.ValueOf(asList[i].ASSerl__c);
                        if(saveList[i].isSuccess()){
                            output.recvYn = 'Y';
                            asSuccessList.add(asList[i]);

                            //수신 성공한 데이터에 해당하는 AS생성IF테이블 레코드값을 D로하여 배열에 저장
                            // recvCheck.SRF_CRMSeq__c = asList[i].CRMASSeq__c;
                            // recvCheck.SRF_AUDType__c = 'X';
                            // recvCheckList.add(recvCheck);
                        }else{
                            output.recvYn = 'N';
                        }

                        system.debug(saveList[i].isSuccess() + '. asList: ' + asList[i]);

                        rtrnList.add(output);
                    }
                }

                //수신 성공한 데이터에 해당하는 AS생성IF테이블 레코드값을 D로하여 업데이트
                // Schema.SobjectField extId = IF_SFDC_ERP_AS_Dummy__c.Fields.SRF_CRMSeq__c;
                // Database.UpsertResult[] recvCheckResult = Database.upsert(recvCheckList, extId, false);
                // for(Database.UpsertResult r : recvCheckResult){
                //     system.debug('R: ' + r);
                // }

                responseBody = JSON.serialize(rtrnList);
                RestContext.response.responseBody = Blob.valueOf(responseBody);
                System.debug('RETURN: '+ rtrnList);
                System.debug('RETURN SIZE: ' + rtrnList.size());
                
                try{
                    SRC_CreateCaseBOM.CreateCaseBOM(asSuccessList);
                }catch(Exception e){
                    system.debug('IF_ERP_SFDC_AS_Dummy__c to [Case, SRO_CaseBOM__c] process error');
                    system.debug('ERROR: ' + e.getMessage());
                }
            }
        }catch(Exception e){
            System.debug('ERP to IF_ERP_SFDC_AS_Dummy__c process error');
            System.debug('ERROR: ' + e.getMessage());
        }
    }
}