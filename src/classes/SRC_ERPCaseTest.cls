/*
 * SRC_ERPCaseInterface.apxc
 * 2022-06-27 ver1.0 이새미
 * 설명 : ERP -> SFDC [AS정보] Interface Test 
 */
@RestResource(UrlMapping = '/test/getAS')
global with sharing class SRC_ERPCaseTest {

    @HttpPost
    global static void getErpAS() {
        
        String respBody = '';
        
        if(RestContext.request != null) {
            
            if(String.isNotBlank(RestContext.request.toString())) {
            
                List<SRC_CaseWrapper.ReqJson> reqList = (List<SRC_CaseWrapper.ReqJson>) JSON.deserialize(RestContext.request.toString(), List<SRC_CaseWrapper.ReqJson>.class);
                
            }
        }
        
    } // getErpAs()
    
    private static List<IF_ERP_SFDC_AS_Dummy__c> insertOrderRecords(List<SRC_ERPCaseJSONWrapper.InputAS> recvList) {
        
        List<IF_ERP_SFDC_AS_Dummy__c> asList = new List<IF_ERP_SFDC_AS_Dummy__c>();
        
        for(SRC_ERPCaseJSONWrapper.InputAS recv : recvList) {
            try {
                IF_ERP_SFDC_AS_Dummy__c ifAS = new IF_ERP_SFDC_AS_Dummy__c();                
                // ifAS.Seq__c 	= recv.seq;
                // ifAS.AUDType__c = recv.audType;
                // // ifAS.CrtDateTime__c  = date.valueOf(recv.crtDateTime);
                // ifAS.RecvYn__c 		 = 'Y';
                // // ifAS.RecvDateTime__c = date.ValueOf(recv.recvDateTime);
                // ifAS.CompanySeq__c   = recv.companySeq;
                // ifAS.IsCfm__c 		 = recv.isCfm;
                // ifAS.CustName__c 	 = recv.custName;
                // ifAS.SRF_ASSeq__c 		 = recv.asSeq;
                // ifAS.SRF_ASReqNo__c 	 = recv.asReqNo;
                // // ifAS.ASReqDate__c 	 = date.valueOf(recv.asReqDate);
                // ifAS.OnLineOrdNo__c  = recv.onLineOrdNo;
                // ifAS.RecvName__c 	 = recv.recvName;
                // ifAS.RecvName__c 	 = recv.recvName;
                // ifAS.RecvMobileNo__c = recv.recvMobileNo;
                // ifAS.DeliveryAddress__c = recv.deliveryAddress;
                // ifAS.MarketName__c 		= recv.marketName;
                // ifAS.UMTroubleType__c 	= recv.umTroubleType;
                // ifAS.UMTroubleName__c 	= recv.umTroubleName;
                // ifAS.ShipNo2__c 		= recv.shipNo2;
                // ifAS.Remark__c 			= recv.remark;
                // ifAS.UMItemType__c 		= recv.umItemType;
                // ifAS.UMItemName__c 		= recv.umItemName;
                // ifAS.UMChargeType__c 	= recv.umChargeType;
                // ifAS.UMChargeTypeName__c = recv.umChargeTypeName;
                // ifAS.IsExchange__c 		 = recv.isExchange;
                // ifAS.CRMASSeq__c 		 = recv.isExchange;   
                
                asList.add(ifAS);
                
            } catch(Exception e) {
                IF_ERP_SFDC_AS_Dummy__c ifAS = new IF_ERP_SFDC_AS_Dummy__c();
                ifAS.Seq__c 	= recv.seq;
                ifAS.RecvYn__c = 'N';
                asList.add(ifAS);
                System.debug('ERROR : ' + e.getMessage());
            }            
        }

        return asList;
    }
}