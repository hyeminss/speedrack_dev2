/*
*   SRC_TestCreateAS2.cls
*   2022.07.06 ver1.0 이새미 작성
*   설명   : 신규 AS문의 작성 화면용 Controller
*   LWC명 :  CreateNewAS.html/.js
*/
public with sharing class SRC_TestCreateAS2 {
    public class CaseBOMValue {
        // 품명, 규격, 요청수량, 품번, 단위, 수량, 처리수량
        @AuraEnabled
        public String id       {get; set;}
        @AuraEnabled
        public String itemSpec {get; set;}
        @AuraEnabled
        public String itemUnit {get; set;}
        @AuraEnabled
        public String itemCode {get; set;}
        @AuraEnabled
        public String itemName {get; set;}
        @AuraEnabled
        public String itemNo   {get; set;}
        @AuraEnabled
        public Decimal itemQty {get; set;}
        @AuraEnabled
        public Decimal itemNeedQty {get; set;}
    }

    public class CodeTypes {
        @AuraEnabled
        public List<Map<String, String>> claimCodeList {get; set;}   // 클레임 분류
        @AuraEnabled
        public List<Map<String, String>> itemTypeList  {get; set;}   // 제품 분류
        @AuraEnabled
        public List<Map<String, String>> chargeTypeList  {get; set;} // 유무상 분류
    }

    public class CaseInfoValue {
        @AuraEnabled
        public String seq             {get; set;} // 수주 시퀀스
        @AuraEnabled
        public String orderSeq        {get; set;} // 수주 마스터 
        @AuraEnabled
        public String orderSerl       {get; set;} // 수주 디테일
        @AuraEnabled
        public String account         {get; set;} // 거래처(= 스피드랙 온라인지점)
        @AuraEnabled
        public String itemName        {get; set;} // 제품명
        @AuraEnabled
        public Date orderDate         {get; set;} // 수주일
        @AuraEnabled
        public String onlineOrdNo     {get; set;} // 온라인주문번호
        @AuraEnabled
        public String shipNo          {get; set;} // 송장번호1
        @AuraEnabled
        public String shipNo2         {get; set;} // 송장번호2
        @AuraEnabled
        public String shipNo3         {get; set;} // 송장번호3
        @AuraEnabled
        public String receiverName    {get; set;} // 수취인명
        @AuraEnabled
        public String receiverAddress {get; set;} // 수취인 주소
        @AuraEnabled
        public String receiverPhone   {get; set;} // 수취인 휴대전화번호
        @AuraEnabled
        public String onlineMarket    {get; set;} // 온라인 마켓(채널)
        @AuraEnabled
        public String claimType       {get; set;} // 클레임 유형
        @AuraEnabled
        public String umChargeType    {get; set;} // 유무상
        @AuraEnabled
        public String umItemType      {get; set;} // 제품 분류
        @AuraEnabled
        public Boolean isChange       {get; set;} // 맞교환
        @AuraEnabled
        public String salesRemark     {get; set;} // 영업 전달 사항
        @AuraEnabled
        public String orderName       {get; set;} // 주문자명
        @AuraEnabled
        public String id              {get; set;} // 수주 레코드 아이디
        @AuraEnabled
        public String asReqDate       {get; set;} // AS 요청일
    }
    

    /* [ 수주 정보 ] */
    @AuraEnabled(cacheable=true)
    public static List<CaseInfoValue> getCaseRecord(String orderNo){

        System.debug('오다남바 : ' + orderNo);
        List<SRO_Order1__c> orderList = new List<SRO_Order1__c>();
        List<CaseInfoValue> caseInfoList = new List<CaseInfoValue>();
        
        try {
            
            orderList = [SELECT SRF_Seq__c, SRF_MasterCode__c, SRF_Orderdetail__c, SRF_ACCOUNT__C,                  // 수주시퀀스, 수주마스터, 수주디테일, 거래처
                                SRF_ONLIEORDERNO__C, ID, SRF_ORDERDATE__C, SRF_RECEIVERNAME__C, SRF_PRODUCT__C,     // 온라인주문번호, 수주일, 수취인명, 제품명
                                SRF_ORDEROWNER__C, SRF_INVOICENO1__C, SRF_INVOICENO2__C, SRF_INVOICENO3__C,         // 주문자명, 송장번호1, 2, 3
                                SRF_PRODUCTCODE__C, SRF_RECIEVERPHONE2__C, SRF_RECEIVERADDRESS__C, SRF_CHANNEL__C   // 제품코드, 수취인 전화번호, 수취인주소, 온라인마켓(채널)
                         FROM SRO_ORDER1__C WHERE NAME =: orderNo LIMIT 1];

            System.debug('수주 정보 : ' + orderList);

            CaseInfoValue caseInfo = new CaseInfoValue();
            caseInfo.seq                = orderList[0].SRF_Seq__c; 
            caseInfo.orderSerl          = orderList[0].SRF_Orderdetail__c;
            caseInfo.orderSeq           = orderList[0].SRF_MasterCode__c;
             
            caseInfo.account            = orderList[0].SRF_ACCOUNT__C;
            caseInfo.itemName           = orderList[0].SRF_PRODUCT__C;
            caseInfo.orderDate          = orderList[0].SRF_ORDERDATE__C;
            caseInfo.onlineOrdNo        = orderList[0].SRF_ONLIEORDERNO__C;

            caseInfo.receiverName       = orderList[0].SRF_RECEIVERNAME__C;
            caseInfo.receiverPhone      = orderList[0].SRF_RECIEVERPHONE2__C;
            caseInfo.receiverAddress    = orderList[0].SRF_RECEIVERADDRESS__C;
            
            caseInfo.onlineMarket       = orderList[0].SRF_CHANNEL__C;
            caseInfo.shipNo             = orderList[0].SRF_INVOICENO1__C;
            caseInfo.shipNo2            = orderList[0].SRF_INVOICENO2__C;
            caseInfo.shipNo3            = orderList[0].SRF_INVOICENO3__C; 
            
            caseInfo.orderName          = orderList[0].SRF_ORDEROWNER__C;
            caseInfo.id                 = orderList[0].ID;

            Datetime asReqDate          = Datetime.now();
            String asReqDateStr         = asReqDate.format('yyyy-MM-dd hh:mm:ss');
            System.debug('아오아오!아 : ' + asReqDateStr);
            caseInfo.asReqDate          = asReqDateStr;

            caseInfo.umChargeType       = '';
            caseInfo.umItemType         = '';
            caseInfo.claimType          = '';
            caseInfo.isChange           = False;

            caseInfoList.add(caseInfo);

            System.debug('우르롹' + caseInfoList);

        } catch (Exception e) {

            System.debug('ERROR : ' + e.getMessage());
        
        }

        return caseInfoList;
        
    } // getCaseRecord()

    /* [ 제품 정보 ] */
    @AuraEnabled
    public static List<CaseBOMValue> getCaseBOMRecord(String orderNo) {

        System.debug('ORDER NO : ' + orderNo);
        List<CaseBOMValue> cList = new List<CaseBOMValue>();
        List<SRO_OrderBOM__C> bomList = [SELECT SRF_ITEMNAME__C, SRF_ITEMNO__C, SRF_ITEMCODE__C, SRF_ORDERNO__C, SRF_ITEMSPEC__C, SRF_QUANTITY__C
										 FROM SRO_ORDERBOM__C WHERE SRF_ORDERnO__C IN (SELECT ID FROM SRO_ORDER1__C WHERE NAME =: orderNo)];
        
        for(SRO_OrderBOM__C c : bomList) {
            CaseBOMValue cWrap = new CaseBOMValue();
            cWrap.id            = c.id;
            cWrap.itemCode      = c.srf_itemCode__c;
            cWrap.itemName      = c.srf_itemName__c;
            cWrap.itemNo        = c.srf_itemNo__c;
            cWrap.itemSpec      = c.srf_itemSpec__c;
            cWrap.itemNeedQty   = 0.0;
            cWrap.itemQty       = c.srf_quantity__c;
            cList.add(cWrap);
        }
        
        return cList;

    } // getCaseBOMRecord()
    
    @AuraEnabled(cacheable = true)
    public static CodeTypes getOptionList(){

        // System.debug('코드 내놔요');
        
        // List<codeTypes> codeTypeList = new List<codeTypes>();
        CodeTypes codeTypes = new CodeTypes();
        codeTypes.claimCodeList = new List<Map<String, String>>();
        codeTypes.itemTypeList  = new List<Map<String, String>>();
        codeTypes.chargeTypeList  = new List<Map<String, String>>();

        try {
           
            List<SRO_ClaimCodes__c> claimCodeList = [SELECT NAME, SRF_UMTroubleType__c FROM SRO_ClaimCodes__c WHERE NAME != 'Null' ORDER BY ID];
            List<SRO_BOMCodes__c>   itemTypeList  = [SELECT Name, SRF_UMItemType__c FROM SRO_BOMCodes__c WHERE NAME != 'Null' ORDER BY ID];
            List<SRO_IsFreeCodes__c> chargeTypes  = [SELECT NAME, SRF_UMChargeType__c FROM SRO_IsFreeCodes__c WHERE NAME != 'Null' ORDER BY ID];

            // 클레임 분류
            for(SRO_ClaimCodes__c c : claimCodeList) {
                Map<String, String> m = new Map<String, String>();
                m.put('label', c.Name);
                m.put('value', c.SRF_UMTroubleType__c);
                codeTypes.claimCodeList.add(m);
            }

            // 제품 분류
            for(SRO_BOMCodes__c b : itemTypeList) {
                Map<String, String> m = new Map<String, String>();
                m.put('label', b.Name);
                m.put('value', b.SRF_UMItemType__c);
                codeTypes.itemTypeList.add(m);
            }     

            // 유무상 구분
            for(SRO_IsFreeCodes__c c : chargeTypes) {
                Map<String, String> m = new Map<String, String>();
                m.put('label', c.Name);
                m.put('value', c.SRF_UMChargeType__c);
                codeTypes.chargeTypeList.add(m);
            }     
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return codeTypes;

    } // getOptionList()

    /* [ 신규 AS용 인터페이스 작성 ] */
    @AuraEnabled
    public static String saveCaseRecord(CaseInfoValue caseInfo, List<CaseBOMValue> caseBOMInfo) {

        String result = 'FAIL';
        System.debug('리스트 : ' + caseInfo);
        System.debug('리스트 : ' + caseBOMInfo);

        List<IF_SFDC_ERP_AS_Dummy__c> ifASList = new List<IF_SFDC_ERP_AS_Dummy__c>();

        try {

            for(CaseBOMValue cb : caseBOMInfo) {

                if(cb.itemNeedQty != 0) {

                    IF_SFDC_ERP_AS_Dummy__c ifAS = new IF_SFDC_ERP_AS_Dummy__c();

                    ifAS.SRF_AUDType__c       = 'A';                                    // aud type         
                    ifAS.SRF_CrtDateTime__c   = caseInfo.asReqDate;                     // 생성일시
                    ifAS.SRF_CompanySeq__c    = 1;                                      // 법인 코드
                    
                    ifAS.SRF_OrderSeq__c      = Decimal.ValueOf(caseInfo.orderSeq);     // 수주내부코드
                    Datetime tempReqDate      = Datetime.ValueOf(caseInfo.asReqDate);
                    ifAS.SRF_ASReqDate__c     = tempReqDate.format('yyyyMMddhhmmss');   // as접수일
                    ifAS.SRF_RecvMobileNo__c  = caseInfo.receiverPhone;                 // 소비자 연락처
                    ifAS.SRF_RecvAddr__c      = caseInfo.receiverAddress;               // 출고주소

                    // ifAS.SRF_UMItemType__c    = Decimal.ValueOf(caseInfo.umItemType);   // 품목 내부 umItemType
                    ifAS.SRF_UMTroubleType__c = Decimal.ValueOf(caseInfo.claimType);     // 클레임 분류 코드
                    ifAS.SRF_UMChargeType__c  = Decimal.ValueOf(caseInfo.UMChargeType);      // 유무상 구분
                    ifAS.SRF_UMItemType__c    = Decimal.ValueOf(caseInfo.umItemType);   // 제품 분류Decimal.ValueOf(caseInfo.claimType); 

                    if(!caseInfo.isChange) { ifAS.SRF_IsExchange__c = '0'; }
                    else { ifAS.SRF_IsExchange__c    = '1'; }                           // 맞교환여부

                    ifAS.SRF_ShipNo2__c       = caseInfo.shipNo;                        // 송장번호1
                    ifAS.SRF_ShipNo3__c       = caseInfo.shipNo2;                       // 송장번호2
                    ifAS.SRF_ShipNo4__c       = caseInfo.shipNo3;                       // 송장버호3
                    
                    // as 송장번호(sf 내에서 처리 x)
                    // 회수 송장 번호(sf 내에서 처리 x)
                    ifAS.SRF_ItemSeq__c  = Decimal.ValueOf(cb.itemCode);                // 제품코드
                    ifAS.SRF_ItemName__c = cb.itemName;                                 // 제품명
                    ifAS.SRF_itemNo__c   = cb.itemNo;                                   // 제품번호

                    ifAS.SRF_BOMQty__c   = cb.itemQty;                                  // bom 소요량
                    ifAS.SRF_NeedQty__c  = cb.itemNeedQty;                              // 요청 수량
                    ifAS.SRF_SalesRemark__c   = caseInfo.salesRemark;                   // 영업전달사항
                    
                    ifASList.add(ifAS);  

                }  

            }

            Database.SaveResult[] saveIFAS = Database.insert(ifASList, true);

            for(Integer i = 0; i < saveIfAS.size(); i++) {
                if(!saveIfAS[i].isSuccess()) {
                    System.debug('ERROR : ' + saveIFAS[i].getErrors()[i]);
                    break;
                } else {
                    result = 'SUCCESS';
                }
            }
                 
        } catch(Exception e) {

            System.debug('ERROR LINE : '+ e.getLineNumber() + ' ' + e.getMessage());
       
        } // try catch   

        System.debug('RESULT : ' + result);
        
        return result;

    } // saveCaseRecord()
   
}