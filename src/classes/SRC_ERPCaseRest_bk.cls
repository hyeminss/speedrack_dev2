/*
*   SRC_ERPCaseRest.cls
*   2022.07.06  ver0.1 김용훈 작성
*   설명: [ERP > SFDC] AS정보 수신을 위한 인터페이스
*/
@RestResource(UrlMapping = '/sfdc/getAS3')
global with sharing class SRC_ERPCaseRest_bk {

    @HttpPost
    global static void getERPCase(){
        String responseBody;
        String requestBody = RestContext.request.requestBody.toString();

        List<SRC_ERPCaseWrapper.ReturnJson> rtrnList = new List<SRC_ERPCaseWrapper.ReturnJson>();

        try{
            if(String.isNotBlank(requestBody)){
                List<SRC_ERPCaseWrapper.ReceiveJson> recvList = (List<SRC_ERPCaseWrapper.ReceiveJson>) JSON.deserialize(requestBody, List<SRC_ERPCaseWrapper.ReceiveJson>.class);
                List<SRC_ERPCaseWrapper.ReceiveJson> recvSuccessList = new List<SRC_ERPCaseWrapper.ReceiveJson>();
                List<IF_ERP_SFDC_AS_Dummy__c> asList = insertERPRecords(recvList);
                List<IF_ERP_SFDC_AS_Dummy__c> asSuccessList = new List<IF_ERP_SFDC_AS_Dummy__c>();
                
                Schema.SobjectField extId = IF_ERP_SFDC_AS_Dummy__c.Fields.ExternalId__c;
                
                if(asList.size() > 0) {
                    Database.UpsertResult[] saveList = Database.upsert(asList, extId, false);
                    for(Integer i = 0; i < saveList.size(); i++){
                        SRC_ERPCaseWrapper.ReturnJson output = new SRC_ERPCaseWrapper.ReturnJson();
                        output.seq = Integer.ValueOf(asList[i].Seq__c);
                        output.asSeq = Integer.ValueOf(asList[i].ASSeq__c);
                        output.asSerl = Integer.ValueOf(asList[i].ASSerl__c);
                        if(saveList[i].isSuccess()){
                            output.recvYn = 'Y';
                            asSuccessList.add(asList[i]);
                        }else{
                            output.recvYn = 'N';
                        }
                        rtrnList.add(output);
                    }
                }

                responseBody = JSON.serialize(rtrnList);                
                RestContext.response.responseBody = Blob.valueOf(responseBody);
                System.debug('RETURN: '+ rtrnList);
                System.debug('RETURN SIZE: ' + rtrnList.size());
                
                // try{
                //     insertASCases(asSuccessList);
                // }catch(Exception e){
                //     system.debug('IF_ERP_SFDC_AS_Dummy__c to [Case, SRO_CaseBOM__c] process error');
                //     system.debug('ERROR: ' + e.getMessage());
                // }
            }
        }catch(Exception e){
            System.debug('ERP to IF_ERP_SFDC_AS_Dummy__c process error');
            System.debug('ERROR: ' + e.getMessage());
        }
    }

    private static List<IF_ERP_SFDC_AS_Dummy__c> insertERPRecords(List<SRC_ERPCaseWrapper.ReceiveJson> recvList){

        List<IF_ERP_SFDC_AS_Dummy__c> erpList = new List<IF_ERP_SFDC_AS_Dummy__c>();
        List<String> orderList = New List<String>();
        
        //이번 배치에서 가져온 onderNo 저장
        for(SRC_ERPCaseWrapper.ReceiveJson recv : recvList){    
            IF_ERP_SFDC_AS_Dummy__c ifERP = new IF_ERP_SFDC_AS_Dummy__c();
            orderList.add(recv.orderNo);
        }
        system.debug('orderList: ' + orderList);

        // 수주 오브젝트에서 키값으로 쓸 값 가져옴
        List<SRO_Order1__c> orderObjectList = new List<SRO_Order1__c>([SELECT Name, SRF_MasterCode__c, SRF_Orderdetail__c, SRF_Seq__c, SRF_OrderName__c
                                                                        FROM SRO_Order1__c
                                                                        WHERE Name in :orderList
                                                                        AND SRF_Orderdetail__c = '1']);
        system.debug('orderObjectList: ' + orderObjectList);

        Map<String, String> orderMapList = new Map<String, String>();
        Map<String, String> contactMapList = new Map<String, String>();
        for(SRO_Order1__c orderObject  : orderObjectList){
            orderMapList.put(orderObject.Name, orderObject.SRF_MasterCode__c+orderObject.SRF_Orderdetail__c);
            contactMapList.put(orderObject.Name, orderObject.SRF_OrderName__c);
        }
        //0039D00000IWRsUQAX
        //0039D00000IWRsUQAX
        //a019D000002m7efQAA
        //AS정보IF테이블 오브젝트로 생성
        for(SRC_ERPCaseWrapper.ReceiveJson recv : recvList){
            IF_ERP_SFDC_AS_Dummy__c ifERP = new IF_ERP_SFDC_AS_Dummy__c();
            ifERP.ExternalId__c        = String.valueOf(recv.ASseq) + String.valueOf(recv.ASSerl);
            ifERP.Seq__c               = recv.seq;
            Integer ye = Integer.valueof((recv.ASReqDate.substring(0, 4)));
            Integer mo = Integer.valueof((recv.ASReqDate.substring(4, 6)));
            Integer da = Integer.valueof((recv.ASReqDate.substring(6, 8)));
            ifERP.ASReqDate__c         = Date.newInstance(ye, mo, da);
            ifERP.ASReqNo__c           = recv.asReqNo;
            ifERP.ASSeq__c             = recv.asSeq;
            ifERP.ASSerl__c            = recv.asSerl;
            ifERP.ForeignId__c         = orderMapList.get(recv.orderNo);
            system.debug('CONTACT_ID: ' + contactMapList.get(recv.orderNo));
            // ifERP.ContactName__r       = new Contact(Id=contactMapList.get(recv.orderNo));
            ifERP.ContactName__r       = new Contact(Id=Id.valueOf('0039D00000IWRsUQAX'));
            system.debug('CONTACT_Object: ' + ifERP.ContactName__r);
            ifERP.AUDType__c           = recv.audType;
            ifERP.CompanySeq__c        = recv.companySeq;
            // ifERP.CRMASSeq__c          = recv.crmASSeq;
            ifERP.CrtDateTime__c       = recv.crtDateTime;
            ifERP.CustName__c          = recv.custName;
            ifERP.DeliveryAddress__c   = recv.deliveryAddress;
            ifERP.ItemName__c          = recv.itemName;
            ifERP.ItemNo__c            = recv.itemNo;
            ifERP.ItemSeq__c           = String.valueOf(recv.itemSeq);
            ifERP.MarketName__c        = recv.marketName;
            ifERP.NeedQty__c           = recv.needQty;
            ifERP.OnLineOrdNo__c       = recv.onLineOrdNo;
            ifERP.OrderNo__c           = recv.orderNo;
            ifERP.ProcQty__c           = recv.procQty;
            ifERP.RecvDateTime__c      = Date.today();
            ifERP.RecvMobileNo__c      = recv.recvMobileNo;
            ifERP.RecvName__c          = recv.recvName;
            ifERP.RecvYn__c            = 'Y';
            ifERP.Remark__c            = recv.remark;
            ifERP.SalesRemark__c       = recv.salesRemark;
            ifERP.ShipNo2__c           = recv.shipNo2;
            ifERP.ShipNo3__c           = recv.shipNo3;
            ifERP.ShipNo4__c           = recv.shipNo4;
            ifERP.UMChargeTypeName__c  = recv.umChargeTypeName;
            ifERP.UMItemName__c        = recv.umItemName;
            ifERP.UMTroubleName__c     = recv.umTroubleName;
            ifERP.UMItemType__c        = String.Valueof(recv.umItemType);
            ifERP.UMChargeType__c     = String.Valueof(recv.umChargeType);
            ifERP.UMTroubleType__c   = String.Valueof(recv.umTroubleType);

            if(recv.IsExchange=='1'){
                ifERP.IsExchange__c = true;    
            } else {
                ifERP.IsExchange__c = false;
            }

            if(recv.IsCfm=='1'){
                ifERP.IsCfm__c = true;    
            } else {
                ifERP.IsCfm__c = false;    
            }

            erpList.add(ifERP);
        }

        return erpList;
    }

    private static void insertASCases(List<IF_ERP_SFDC_AS_Dummy__c> asDummyList){
        List<Case> asCaseList = new List<Case>();
        List<SRO_CaseBOM__c> asCaseBOMList = new List<SRO_CaseBOM__c>();
        List<String> asDeleteCase = new List<String>();
        for(IF_ERP_SFDC_AS_Dummy__c asdummy : asDummyList){
            if(asDummy.AUDType__c == 'D' ){
                asDeleteCase.add(asDummy.ASSeq__c);
                continue;
            }
            if(asDummy.ASSerl__c == '1'){
                try{
                    //AS품목 레코드 데이터 생성
                    Case asCase = new Case();
                    asCase.SRF_OrderNo__r        = new SRO_Order1__c(External_Id__c=asdummy.ForeignId__c);
                    asCase.SRF_CustName__c      = asDummy.CustName__c;
                    asCase.SRF_ASSeq__c         = asDummy.ASSeq__c;
                    asCase.SRF_ASReqNo__c       = asDummy.ASReqNo__c;
                    asCase.RecordTypeId         = '0129D000001Qyt2QAC';
                    // asCase.ContactId            = asDummy.ContactName__c;
                    asCase.SRF_ASReqDate__c     = asDummy.ASReqDate__c;
                    asCase.SRF_OnlineOrdNo__c   = asDummy.OnLineOrdNo__c;
                    asCase.SRF_RecvName__c      = asDummy.RecvName__c;
                    asCase.SRF_RecvMobileNo__c  = asDummy.RecvMobileNo__c;
                    asCase.SRF_DeliveryAddress__c = asDummy.DeliveryAddress__c;
                    asCase.SRF_MarketName__c    = asDummy.MarketName__c;
                    asCase.SRF_UMTroubleType__c = asDummy.UMTroubleType__c;
                    asCase.SRF_ShipNo2__c       = asDummy.ShipNo2__c;
                    asCase.SRF_ShipNo3__c       = asDummy.ShipNo3__c;
                    asCase.SRF_ShipNo4__c       = asDummy.ShipNo4__c;
                    asCase.SRF_Remark__c        = asDummy.Remark__c;
                    asCase.SRF_UMItemType__c    = asDummy.UMItemType__c;
                    asCase.SRF_UMChargeType__c  = asDummy.UMChargeType__c;
                    asCase.SRF_SaelsRemark__c   = asDummy.SalesRemark__c;
                    asCase.SRF_IsChange__c      = asDummy.IsExchange__c;
                    asCase.SRF_IsCfm__c         = asDummy.IsCfm__c;
                    asCaseList.add(asCase);
                }catch(Exception e){
                    system.debug('Create Case object Process error');
                    system.debug('ERROR: ' + e.getMessage());
                }
            }

            try{
                //AS품목처리 레코드 데이터 생성
                SRO_CaseBOM__c asCaseBOM = new SRO_CaseBOM__c();
                
                asCaseBOM.SRF_LookupAS__r = new Case(SRF_ASSeq__c=asDummy.asSeq__c);
                asCaseBOM.SRF_ASSeq__c    = asDummy.ASSeq__c;
                asCaseBOM.SRF_ASSerl__c   = asDummy.ASSerl__c;
                asCaseBOM.SRF_ItemSeq__c  = asDummy.ItemSeq__c;
                asCaseBOM.SRF_ItemName__c = asDummy.ItemName__c;
                asCaseBOM.SRF_ItemNo__c   = asDummy.ItemNo__c;
                asCaseBOM.SRF_NeedQty__c  = asDummy.NeedQty__c;
                asCaseBOM.SRF_ProcQty__c  = asDummy.ProcQty__c;
                asCaseBOM.ExternalId__c   = asDummy.ASSeq__c + asDummy.ASSerl__c;

                asCaseBOMList.add(asCaseBOM);

            }catch(Exception e){
                system.debug('Create CaseBOM object Process error');
                system.debug('ERROR: ' + e.getMessage());
            }
        }

        try{
            //AS처리 레코드 등록
            Schema.SobjectField caseExtId = Case.Fields.SRF_ASSeq__c;
            if(asCaseList.size() > 0){
                Database.UpsertResult[] caseResult = Database.upsert(asCaseList, caseExtId, false);
            }
            
            //AS품목처리 레코드 등록
            Schema.SobjectField caseBOMExtId = SRO_CaseBOM__c.Fields.ExternalId__c;
            if(asCaseBOMList.size() > 0){
                Database.UpsertResult[] caseBOMResult = Database.upsert(asCaseBOMList, caseBOMExtId, false);
            }
            
            //AUDType == "D" AS처리 레코드 삭제
            List<Case> delCaseObj = new List<Case>([select Id FROM Case where SRF_ASSeq__c IN :asDeleteCase]);
            if(delCaseObj.size() > 0){
                delete delCaseObj;
            }

        }catch(Exception e){
            system.debug('Upsert Case, Ca678seBOM Records Process error');
            system.debug('ERROR: ' + e.getMessage());
        }
    }
}