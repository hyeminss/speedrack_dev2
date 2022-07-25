public with sharing class SRC_CrerateCaseDummy {
    public static List<IF_ERP_SFDC_AS_Dummy__c> crerateCaseDummy(List<SRC_ERPCaseWrapper.ReceiveJson> recvList) {

        List<IF_ERP_SFDC_AS_Dummy__c> erpList = new List<IF_ERP_SFDC_AS_Dummy__c>();
        List<String> orderList = New List<String>();
        // SRC_TestCreateAS.checkUpdateAS(recvList);

        //이번 배치에서 가져온 onderNo 저장
        for(SRC_ERPCaseWrapper.ReceiveJson recv : recvList){    
            IF_ERP_SFDC_AS_Dummy__c ifERP = new IF_ERP_SFDC_AS_Dummy__c();
            orderList.add(recv.orderNo);
        }
        system.debug('orderList: ' + orderList);

        // 수주 오브젝트에서 키값으로 쓸 값을 가져옴
        List<SRO_Order1__c> orderObjectList = new List<SRO_Order1__c>([SELECT Name, SRF_MasterCode__c, SRF_OrderName__c
                                                                        FROM SRO_Order1__c
                                                                        WHERE Name in :orderList
                                                                        AND SRF_Orderdetail__c = '1']);

        Map<String, String> orderMapList = new Map<String, String>();   //수주에서 가져온 키 값 목록
        Map<String, String> contactMapList = new Map<String, String>(); //수주에서 가져온 주문자 ID
        for(SRO_Order1__c orderObject  : orderObjectList){
            orderMapList.put(orderObject.Name, orderObject.SRF_MasterCode__c);
            contactMapList.put(orderObject.Name, orderObject.SRF_OrderName__c);
        }

        //AS정보IF테이블 오브젝트로 레코드를 생성
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
            ifERP.ContactName__c       = contactMapList.get(recv.orderNo);
            ifERP.AUDType__c           = recv.audType;
            ifERP.CompanySeq__c        = recv.companySeq;
            ifERP.CRMASSeq__c          = recv.crmASSeq;
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
            ifERP.UMChargeType__c      = String.Valueof(recv.umChargeType);
            ifERP.UMTroubleType__c     = String.Valueof(recv.umTroubleType);
            
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
}