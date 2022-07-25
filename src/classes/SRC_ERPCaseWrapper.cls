public with sharing class SRC_ERPCaseWrapper {

    public class ReceiveJson{
        public Integer seq;
        public String asReqDate;
        public String asReqNo;
        public String asSeq;
        public String asSerl;
        public String audType;
        public Integer companySeq;
        public String crmASSeq;
        public String crtDateTime;
        public String custName;
        public String deliveryAddress;
        public String isCfm;
        public String isExchange;
        public String itemName;
        public String itemNo;
        public String itemSeq;
        public String marketName;
        public Decimal needQty;
        public String onLineOrdNo;
        public String orderNo;
        public Decimal procQty;
        public String recvDateTime;
        public String recvMobileNo;
        public String recvName;
        public String recvYn;
        public String remark;
        public String salesRemark;
        public String shipNo2;
        public String shipNo3;
        public String shipNo4;
        public Integer umChargeType;
        public String umChargeTypeName;
        public String umItemName;
        public Integer umItemType;
        public String umTroubleName;
        public Integer umTroubleType;
    }

    public class ReturnJson {
        public Integer seq;
        public String recvYn;
        public Integer asSeq;
        public Integer asSerl;
    }
}