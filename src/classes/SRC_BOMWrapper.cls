global with sharing class SRC_BOMWrapper {

    global class InputCase {
        public Decimal seq;
        public String crtDateTime;
        public Decimal recvYn;
        public Decimal companySeq;
        public String orderNo;
        public Decimal itemSeq;
        public String itemName;
        public String itemNo;
        public String bomLevel;
        public Decimal matItemSeq;
        public String matItemNo;
        public String MatBOMRev;
        public String AssetName;
        public Decimal qty;
    }

    global class returnValue {
        public Decimal seq;
        public Decimal recvYn;
        public String itemNo;
        public String bomLevel;
        public Decimal matItemSeq;
        public String matItemNo;
        public String MatBOMRev;
        public String AssetName;
        public Decimal Qty;
    }
}