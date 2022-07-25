/**
 * Created by user on 2022-06-27.
 */
@RestResource(UrlMapping = '/sfdc/createSAS')
global with sharing class SRC_ERPNewCaseRest {

    public class InputJson {
        public Integer companySeq;
    }
    
    @HttpPost
    global static void getErpAS() {

        String responseBody = '';
        RestRequest request = RestContext.request;
        if(RestContext.request != null) {
            String requestBody = request.requestBody.toString();
				
             if(String.isNotBlank(requestBody)) {
                 System.debug('isNoBlank');
                 
                 List<InputJson> inputList = (List<InputJson>)JSON.deserialize(requestBody, List<InputJson>.class);
                 
                 for(InputJson i : inputList) {
                     
                 }
                 
                 
                 
                 /*
                 List<IF_ERP_SFDC_AS_Dummy__c> asList = insertOrderRecords(recvList);
                 
                 if(asList.size() > 0) {
                     try {
                         Database.SaveResult[] saveList = Database.insert(asList, false);
                         for(Database.SaveResult s : saveList) {
                             if(s.isSuccess()) {
                         		for(IF_ERP_SFDC_AS_Dummy__c a : asList) {
                                     //IF_ERP_SFDC_AS_Dummy__c asObj = new IF_ERP_SFDC_AS_Dummy__c();
                                     SRC_ERPCaseJSONWrapper.ReturnJson rtrnData = new SRC_ERPCaseJSONWrapper.ReturnJson();
                                     
                                     rtrnData.seq = Integer.valueOf(a.Seq__c);
                                     
                                     rtrnList.add(rtrnData);
                                 }        
                             }
                         }
                     } catch(DMLException e) {
                         System.debug(e.getMessage());
                     }
                 }
                 responseBody = JSON.serialize(rtrnList);

                RestContext.response.responseBody = Blob.valueOf(responseBody);
                System.debug(Blob.valueOf(responseBody));
				*/
            }
        }
    } // getErpAs()
    
    private static List<IF_ERP_SFDC_AS_Dummy__c> insertOrderRecords(List<SRC_ERPCaseJSONWrapper.InputAS> recvList) {
        
        List<IF_ERP_SFDC_AS_Dummy__c> asList = new List<IF_ERP_SFDC_AS_Dummy__c>();
        
        for(SRC_ERPCaseJSONWrapper.InputAS recv : recvList) {
            IF_ERP_SFDC_AS_Dummy__c ifAS = new IF_ERP_SFDC_AS_Dummy__c();
          
            
        //     ifAS.Seq__c 	= recv.seq;
        //     ifAS.AUDType__c = recv.audType;
        // //    ifAS.CrtDateTime__c  = recv.crtDateTime;
        //     ifAS.RecvYn__c 		 = recv.recvYn;
        //    ifAS.RecvDateTime__c = recv.recvDateTime;
        //     ifAS.CompanySeq__c   = recv.companySeq;
        //     ifAS.IsCfm__c 		 = recv.isCfm;
        //     ifAS.CustName__c 	 = recv.custName;
        //     ifAS.SRF_ASSeq__c 		 = recv.asSeq;
        //     ifAS.SRF_ASReqNo__c 	 = recv.asReqNo;
        //    ifAS.ASReqDate__c 	 = recv.asReqDate;
        //     ifAS.OnLineOrdNo__c  = recv.onLineOrdNo;
        //     ifAS.RecvName__c 	 = recv.recvName;
        //     ifAS.RecvName__c 	 = recv.recvName;
        //     ifAS.RecvMobileNo__c = recv.recvMobileNo;
        //     ifAS.DeliveryAddress__c = recv.deliveryAddress;
        //     ifAS.MarketName__c 		= recv.marketName;
        //     ifAS.UMTroubleType__c 	= recv.umTroubleType;
        //     ifAS.UMTroubleName__c 	= recv.umTroubleName;
        //     ifAS.ShipNo2__c 		= recv.shipNo2;
        //     ifAS.Remark__c 			= recv.remark;
        //     ifAS.UMItemType__c 		= recv.umItemType;
        //     ifAS.UMItemName__c 		= recv.umItemName;
        //     ifAS.UMChargeType__c 	= recv.umChargeType;
        //     ifAS.UMChargeTypeName__c = recv.umChargeTypeName;
        //     ifAS.IsExchange__c 		 = recv.isExchange;
        //     ifAS.CRMASSeq__c 		 = recv.isExchange;   
            
            asList.add(ifAS);
            
        }
        return asList;
    }
}