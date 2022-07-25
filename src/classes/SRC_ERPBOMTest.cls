/*
 * SRC_ERPBOMTest.apxc
 * 2022-06-27 ver1.0 이새미
 * 설명 : ERP -> SFDC [제품정보] Interface Test 
 */

@RestResource(UrlMapping = '/sfdc/getBOM/Test')
global with sharing class SRC_ERPBOMTest {


    @HttpPost
    global static void getERPCase() {
        RestRequest req = RestContext.request;
        String respBody = '';
        
        if(RestContext.request != null) {
            System.debug('!= NULL');
            String reqBody = RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(reqBody)) {
                System.debug('!= BLANK');
            
                try {

                    List<SRC_ERPBOMJsonWrapper.ReceiveJson> recvList = (List<SRC_ERPBOMJsonWrapper.ReceiveJson>) JSON.deserialize(reqBody, List<SRC_ERPBOMJsonWrapper.ReceiveJson>.class);
                    List<SRC_ERPBOMJsonWrapper.returnJson> returnList = new List<SRC_ERPBOMJsonWrapper.returnJson>();
                    
                    
                    System.debug('Receiver List : ' + recvList.size());
                    // dummy에 넣고 문제 없이 들어갔다면 Y 리턴
                    if(recvList.size() != 0) {
                         for(SRC_ERPBOMJsonWrapper.ReceiveJson i : recvList) {
                             SRC_ERPBOMJsonWrapper.returnJson returnJson = new SRC_ERPBOMJsonWrapper.returnJson();
                             returnJson.seq = i.seq;
                             returnJson.recvYn = 'Y';
                             returnJson.orderSeq = i.orderSeq;
                             returnJson.orderSerl = i.orderSerl;
                             returnList.add(returnJson);
                         }
                    }

                    respBody = JSON.serialize(returnList);

                } catch(Exception e) {
             
                    System.debug(e.getMessage());
                
                }

                System.debug('Response Body : ' + respBody);
                RestContext.response.responseBody = Blob.valueOf(respBody);
                
            }
        }
    } // getERPCase
    /*
    private static List<IF_ERP_SFDC_BOM_Dummy__c> insertOrderRecords(List<SRC_ERPBOMJSONWrapper.InputAS> recvList) {
        
        List<IF_ERP_SFDC_BOM_Dummy__c> asList = new List<IF_ERP_SFDC_BOM_Dummy__c>();
        
        for(SRC_ERPBOMJSONWrapper.InputAS recv : recvList) {
            IF_ERP_SFDC_BOM_Dummy__c ifBOM = new IF_ERP_SFDC_BOM_Dummy__c();
          
			ifBOM.;
            public String crtDateTime;
            public String recvYn;
            public String recvDateTime;
            public Integer companySeq;
            public Integer orderSeq;
            public Integer orderSerl;
            public String orderNo;
            public Integer itemSeq;
            public String itemNo;
            public String bomLevel;
            public Integer matItemSeq;
            public String matItemNo;
            public String matItemSpec;
            public String matBOMRev;
            public String assetName;
            public Integer qty;            
            asList.add(ifAS);
            
        }
        return asList;
    }
*/
}