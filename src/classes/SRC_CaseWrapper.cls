/*
 * SRC_CaseWrapper.apxc
 * 2022-06-27 ver1.0 이새미
 * 설명 : ERP -> SFDC [AS정보] Interface Test 
 */
global with sharing class SRC_CaseWrapper {

    global class ReqJson {
        public String companySeq;
    }

    global class RtrnJson {

        public String crmASSeq;

        public String crtDateTime;
        public Integer companySeq;
        public Integer OrderSeq;
        public String asReqDate;
        public String recvMobileNo;
        public String recvAddr;
        public Integer itemSeq;
        public Integer umTroubleType;
        public Integer umItemType;
        public Integer umChargeType;
        public String isExchange;
        public String shipNo2;
        public String shipNo3;
        public String shipNo4;
        public String asShipNo2;
        public String returnShipNo;
        public String itemName;
        public String itemNo;
        public Integer needQty;



    }
}