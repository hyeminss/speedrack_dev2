/* SRC_ERPBOMJsonWrapper.apxc
 * 2022-07-06 ver1.0 최신욱 
 * 설명: ERP에서 넘어오는 Json 형태의 데이터를 receive, return하는 wrapper 클래스
 */
global with sharing class SRC_ERPBOMJsonWrapper {
	
    //영림원 ERP에서 SFDC로 수신하는 JSON 정보 
    global class ReceiveJson {
        public Integer seq;
        public String crtDateTime;			// Datetime으로 받을지 or String으로 받을지 data type 다시 확인!
        public String recvYn; 				// 수신여부 (api전송 후 완료 리스트에 대해서만 y값 리턴) -> true or false? (boolean)
        public String recvDateTime;			// 수신일시 (null값?)
        public Integer companySeq;
        public Integer orderSeq;			// primary key (수주 마스터 코드)
        public Integer orderSerl;			// primary key (수주 디테일 코드)
        public String orderNo;
        public Integer itemSeq;
        public String itemName;
        public String itemNo;
		public String bomLevel;				// 1. 수주 품목, 2. 하위 반제품 
		public Integer matItemSeq;
        public String matItemName;
        public String matItemNo;
        public String matItemSpec;          // blank or null 가능 
        public String matBOMRev;
        public String assetName;
        public Decimal qty;					
    }
	
    //영림원 ERP에서 SFDC로 데이터 수신 후, SFDC에서 영림원 ERP로 return하는 JSON 정보 
    global class ReturnJson {
        public Integer seq;
        public String recvYn;
        public Integer orderSeq;
        public Integer orderSerl;
    }
}