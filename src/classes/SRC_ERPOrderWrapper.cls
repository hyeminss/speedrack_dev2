public with sharing class SRC_ERPOrderWrapper {

    // VO
    public class ReceiveJson {
        public Integer seq;
        public String audtype;
        public String crtDateTime;
        public String recvYn;
        public Integer companySeq;
        public String orderNo;
        public Integer orderSeq;
        public Integer orderSerl;
        public String custName;
        public String umdvConditionName;
        public String orderDate;
        public Integer itemSeq;
        public String itemName;
        public String itemNo;
        public String spec;
        public String unitName;
        public Decimal qty;        
        public String onLineOrdNo;
        public String recvName;
        public String recvAddr;
        public String recvZipCode;
        public String recvPhoneNo;
        public String recvMobileNo;
        public String delvMsg;
        public String marketName;
        public String shipNo;
        public String shipNo3;
        public String shipNo4;
        public String delvTypeName;
        public String remark;        
        public String externalId;
        public String customerName;
        public String customerPhoneNo;
        public Decimal customerAmt;
    }

    public class ReturnJson {
        public Integer seq;
        public String recvYn;
        public Integer orderSeq;
        public Integer orderSerl;
    }

}