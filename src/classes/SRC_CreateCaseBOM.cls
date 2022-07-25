public with sharing class SRC_CreateCaseBOM {
    public static void createCaseBOM(List<IF_ERP_SFDC_AS_Dummy__c> asDummyList){
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
                    asCase.ContactId            = asDummy.ContactName__c;
                    asCase.RecordTypeId         = '0129D000001Qyt2QAC';
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
            Database.UpsertResult[] caseResult = Database.upsert(asCaseList, caseExtId, false);
            for(Database.UpsertResult cr : caseResult){
                system.debug(cr);
            }
            
            //AS품목처리 레코드 등록
            Schema.SobjectField caseBOMExtId = SRO_CaseBOM__c.Fields.ExternalId__c;
            Database.UpsertResult[] caseBOMResult = Database.upsert(asCaseBOMList, caseBOMExtId, false);
            for(Database.UpsertResult cbr : caseBOMResult){
                system.debug(cbr);
            }
            
            //AUDType == "D" AS처리 레코드 삭제
            List<Case> delCaseObj = new List<Case>([select Id FROM Case where SRF_ASSeq__c IN :asDeleteCase]);
            delete delCaseObj;

        }catch(Exception e){
            system.debug('Upsert Case, Ca678seBOM Records Process error');
            system.debug('ERROR: ' + e.getMessage());
        }
    }
}