/**
 * Created by user on 2022-06-27.
 */

public with sharing class SRC_ERPCaseJSONWrapper {

    public class InputAS {
        public Integer seq;
        public String audtype;
        public Datetime crtDateTime;
        public String recvYn;
        public String recvDateTime;
        public Integer companySeq;
        public String isCfm;
        public String custName;
        public Integer asSeq;
        public String asReqNo;
        public String asReqDate;
        public String onLineOrdNo;
        public String orderNo;
        public String recvName;
        public String recvMobileNo;
        public String deliveryAddress;
        public String marketName;
        public Id umTroubleType;
        public String umTroubleName;
        public String shipNo2;
        public String remark;
        public Id umItemType;
        public String umItemName;
        public Id umChargeType;
        public String umChargeTypeName;
        public String isExchange;
        public String crmASSeq;
    }

    public class ReturnJson {
        public Integer seq;
        public String recvYn;
        public Integer asSeq;
    }
}