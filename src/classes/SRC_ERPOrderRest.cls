/**
 * SRC_ERPOrderRest.apxc
 * 2022.06.27 ver1.0 이새미
 * 설명 : ERP -> SFDC [수주정보]_Interface
 * 
 * [수정 이력]
 * 2022.06.29 ver1.1 김소연
 *  
 */
@RestResource(UrlMapping = '/sfdc/getOrder')
global with sharing class SRC_ERPOrderRest {
    
    static Map<String,String> inputMap = new Map<String,String>();
    
    @HttpPost
    global static void getErpOrder() {
        
        String responseBody = '';
        RestRequest request = RestContext.request;
        Map<Integer,String> resultMap = new Map<Integer,String>();
        List<String> IdList = new List<String>();
        List<SRC_ERPOrderWrapper.ReturnJson> rtrnList = new List<SRC_ERPOrderWrapper.ReturnJson>();
        List<SRC_ERPOrderWrapper.ReceiveJson> recvList = new List<SRC_ERPOrderWrapper.ReceiveJson>();
        List<IF_ERP_SFDC_Order_Dummy__c> asList = new List<IF_ERP_SFDC_Order_Dummy__c>();
        Integer temp = 0;

        if(RestContext.request != null) { // request
            String requestBody = request.requestBody.toString();
                if(String.isNotBlank(requestBody)) {                
                    try{
                        // deserialize
                		recvList = (List<SRC_ERPOrderWrapper.ReceiveJson>) JSON.deserialize(requestBody, List<SRC_ERPOrderWrapper.ReceiveJson>.class); 
                    }catch(Exception e){
                        System.debug('=============== JSON ERROR: ' + e.getCause());
                    }              
                
                if(recvList.size() > 0) {
                    // data dummy 생성
                    asList = insertOrderRecords(recvList);
                    Schema.SObjectField extId = IF_ERP_SFDC_Order_Dummy__c.Fields.ExternalId__c;
                    try {
                        // data upsert, UpsertResult[] 객체 반환
                        Database.UpsertResult[] saveList = Database.upsert(asList,extId,false); 
                        
                        for(Database.UpsertResult s : saveList){
                            // upsert 성공
                            if(s.isSuccess()){
                                resultMap.put(temp, 'SUCCESS');
                            }else{
                                resultMap.put(temp, 'FAIL');
                            }
                            temp++;
                        }                                             
                        
                    } catch(DMLException e) {
                        System.debug('ERROR: ' + e.getMessage());
                    }
                }
                temp = 0;
                
                // return
                for(IF_ERP_SFDC_Order_Dummy__c data : asList){
                    SRC_ERPOrderWrapper.ReturnJson output = new SRC_ERPOrderWrapper.ReturnJson();
                    output.seq = Integer.ValueOf(data.Seq__c);
                    output.orderSeq = Integer.ValueOf(data.OrderSeq__c);
                    output.orderSerl = Integer.ValueOf(data.OrderSerl__c);

                    if(resultMap.get(temp) == 'SUCCESS'){
                        output.recvYn = 'Y';
                    }else if(resultMap.get(temp) == 'FAIL'){
                        output.recvYn = 'N';
                    }
                    rtrnList.add(output);
                    temp++;
                }
                
                System.debug('RETURN: '+ rtrnList);
                System.debug('RETURN SIZE: ' + rtrnList.size());
                responseBody = JSON.serialize(rtrnList);
                
                RestContext.response.responseBody = Blob.valueOf(responseBody);
            }
        }
    } // getErpOrder()
    
    private static List<IF_ERP_SFDC_Order_Dummy__c> insertOrderRecords(List<SRC_ERPOrderWrapper.ReceiveJson> recvList) { 
        
        List<IF_ERP_SFDC_Order_Dummy__c> orderList = new List<IF_ERP_SFDC_Order_Dummy__c>();
        Integer year  = 0;
        Integer month = 0;
        Integer day   = 0;
        
        for(SRC_ERPOrderWrapper.ReceiveJson recv : recvList) {            
            IF_ERP_SFDC_Order_Dummy__c ifOrder = new IF_ERP_SFDC_Order_Dummy__c();   
            
            ifOrder.ExternalId__c       = recv.orderSeq + '' + recv.orderSerl;
            ifOrder.AUDType__c 			= recv.audType;
            ifOrder.CompanySeq__c   	= recv.companySeq;
            ifOrder.Seq__c 				= recv.seq;
            ifOrder.RecvYn__c 		 	= 'Y';

            recv.crtDateTime = recv.crtDateTime.subString(0, 8);
            year 	= Integer.ValueOf(recv.crtDateTime.subString(0, 4));
            month 	= Integer.ValueOf(recv.crtDateTime.subString(4, 6));
            day 	= Integer.ValueOf(recv.crtDateTime.subString(6, 8));
            Date crtDate = Date.newInstance(year, month, day);
            ifOrder.CrtDateTime__c 		 = String.valueOf(crtDate);
            
            ifOrder.CustName__c 	 	= recv.custName;
            ifOrder.OnLineOrdNo__c  	= recv.onLineOrdNo;
            ifOrder.ShipNo__c 			= recv.shipNo;
            ifOrder.Remark__c 			= recv.remark;
            
            ifOrder.OrderNo__c           = recv.orderNo;
            ifOrder.OrderSeq__c			 = '' + recv.orderSeq;
            ifOrder.OrderSerl__c		 = '' + recv.orderSerl;
            ifOrder.UMDVConditionName__c = recv.umdvConditionName;
            
            year 	= Integer.ValueOf(recv.orderDate.subString(0, 4));
            month 	= Integer.ValueOf(recv.orderDate.subString(4, 6));
            day 	= Integer.ValueOf(recv.orderDate.subString(6, 8));
            ifOrder.OrderDate__c 		 = Date.newInstance(year, month, day);
            
            ifOrder.ItemSeq__c			= recv.itemSeq;
            ifOrder.ItemName__c			= recv.itemName;
            ifOrder.ItemNo__c			= recv.itemNo;
            ifOrder.Spec__c				= recv.spec;
            ifOrder.CustomerName__c		= recv.customerName;
            ifOrder.CustomerPhoneNo__c	= recv.customerPhoneNo.replaceAll('-','');
            ifOrder.CustomerAmt__c		= recv.customerAmt;
            ifOrder.CustName__c			= recv.custName;
            ifOrder.UnitName__c			= recv.unitName;
            ifOrder.Qty__c				= recv.qty;
            
            ifOrder.RecvName__c 	 	= recv.recvName;
            ifOrder.RecvAddr__c			= recv.recvAddr;
            ifOrder.RecvZipCode__c		= recv.recvZipCode;
            ifOrder.RecvMobileNo__c 	= recv.recvMobileNo.replaceAll('-','');
            ifOrder.RecvPhoneNo__c	 	= recv.recvPhoneNo.replaceAll('-','');
            
            ifOrder.DelvMsg__c			= recv.delvMsg;
            ifOrder.MarketName__c		= recv.marketName;
            ifOrder.DevlTypeName__c		= recv.delvTypeName;  
            ifOrder.IsSynced__c			= False;

            orderList.add(ifOrder);
        }
        
        return orderList;
    }
}