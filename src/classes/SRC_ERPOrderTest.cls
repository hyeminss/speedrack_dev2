/* 
 * SRC_ERPOrderTest.apxc
 * 2022.06.27 ver1.0 이새미
 * 설명 : ERP -> SFDC [수주정보]_Interface Test 
 */
@RestResource(UrlMapping = '/test/getOrder')
global with sharing class SRC_ERPOrderTest {

    @HttpPost
    global static void getErpOrder() {

        String respBody = '';											// 응답 변수
        Integer tempSeq = 0; 											// 임시 시퀀스
        // List<String> resultList = new List<String>();				
        Map<Integer, String> resultMap = new Map<Integer, String>();	// DML 결과만 담을 List
        
        if(RestContext.request != null) { 
            
            // System.debug('[ Request is not null ]');
            String requestBody = RestContext.request.requestBody.toString();
            
            if(String.isNotBlank(requestBody)) {
                
                // System.debug('[ Request Body is not blank ]');
                
                try {
                    // Deserialize
                    List<SRC_ERPOrderWrapper.ReceiveJson> recvList = (List<SRC_ERPOrderWrapper.ReceiveJson>) JSON.deserialize(requestBody, List<SRC_ERPOrderWrapper.ReceiveJson>.class);
                    
                    // Dummy Insert 전 전체 데이터
                    List<IF_ERP_SFDC_Order_Dummy__c> orderList = insertOrderRecords(recvList);
                    
                    // External Id
                    Schema.SObjectField extId = IF_ERP_SFDC_Order_Dummy__c.Fields.ExternalId__c;
                    // Insert Result
                    Database.UpsertResult[] saveList = Database.upsert(orderList, extId, false);
					
                    List<SRC_ERPOrderWrapper.ReturnJson> rtrnList = new List<SRC_ERPOrderWrapper.ReturnJson>();
                    
                    for(Database.UpsertResult s : saveList) {                 
                        if(s.isSuccess()) {
                            resultMap.put(tempSeq, 'SUCCESS');
                            // resultList.add('SUCCESS');

                        } else {
                            // System.debug('TEMP INTEGER FAIL: ' + tempSeq);
                            resultMap.put(tempSeq, 'FAIL');
                            // resultList.add('FAIL');
                        }
                        
                        tempSeq++;
                    }

                    /*
					for(Integer i = 0; i < saveList.size(); i++) {
                        if(saveList.get(i).isSuccess()) {
							resultMap.put(i, 'SUCCESS');
                        } else {
							resultMap.put(i, 'FAIL');
                            // get(1)부터 List Exception 
                            System.debug('DML ERROR : ' + saveList.get(i).getErrors().get(i).getFields());
                        }
                    }
                    */
                    
                    tempSeq = 0;
                    // System.debug('RESULT MAP : ' + resultMap);
                    for(IF_ERP_SFDC_Order_Dummy__c o : orderList) {
                        SRC_ERPOrderWrapper.ReturnJson rtrn = new SRC_ERPOrderWrapper.ReturnJson();   
                        rtrn.seq = Integer.valueOf(o.Seq__c);
                        rtrn.orderSeq = Integer.valueOf(o.OrderSeq__c);
                        rtrn.orderSerl = Integer.valueOf(o.OrderSerl__c);
                        
                        if(resultMap.get(tempSeq) == 'SUCCESS') {
                            // System.debug('SEQ FAIL : ' + o.Seq__c);
                            rtrn.recvYn = 'Y';
                        } else if(resultMap.get(tempSeq) == 'FAIL') {
                            // System.debug('SEQ SUCCESS : ' + o.Seq__c);
                            rtrn.recvYn = 'N';
                        }
                        rtrnList.add(rtrn);
                        tempSeq++;
                    }
                    
                    // 결과 Response
                    respBody = JSON.serialize(rtrnList);
                    
                } catch(Exception e) {
                    
                    System.debug('ERROR LINE ' + e.getLineNumber() + ' : ' + e.getMessage());
                    respBody = '[ Exception ] : ' + e.getTypeName();
                    
                } // try catch
                
                RestContext.response.responseBody = Blob.valueOf(respBody);
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
            
            // external Id
            ifOrder.ExternalId__c 			 = recv.orderNo + '' + recv.orderSerl;
            
            ifOrder.Seq__c 				 = recv.seq;
            ifOrder.AUDType__c 			 = recv.audType;
            ifOrder.CrtDateTime__c  	 = recv.crtDateTime;
            recv.crtDateTime = recv.crtDateTime.subString(0, 8);

            year 	= Integer.ValueOf(recv.crtDateTime.subString(0, 4));
            month 	= Integer.ValueOf(recv.crtDateTime.subString(4, 6));
            day 	= Integer.ValueOf(recv.crtDateTime.subString(6, 8));
            Date crtDate = Date.newInstance(year, month, day);
            
            ifOrder.CrtDateTime__c 		 = String.valueOf(crtDate);
            ifOrder.RecvYn__c 		 	 = 'Y'; 		
            ifOrder.CompanySeq__c   	 = recv.companySeq;
            
            ifOrder.OrderSeq__c			 = '' + recv.orderSeq;
            ifOrder.OrderSerl__c		 = '' + recv.orderSerl;
            ifOrder.OrderNo__c           = recv.orderNo;
            ifOrder.CustName__c 	 	 = recv.custName;
            ifOrder.UMDVConditionName__c = recv.umdvConditionName;
            //ifOrder.OrderDate__c 		 = recv.orderDate;
            
            ifOrder.ItemSeq__c			 = recv.itemSeq;
            ifOrder.ItemName__c			 = recv.itemName;
            ifOrder.ItemNo__c			 = recv.itemNo;
            ifOrder.Spec__c				 = recv.spec;
            ifOrder.UnitName__c			 = recv.unitName;
            ifOrder.Qty__c				 = recv.qty;
            
            ifOrder.OnLineOrdNo__c  	 = recv.onLineOrdNo;            
            ifOrder.RecvName__c 	 	 = recv.recvName;
            ifOrder.RecvAddr__c			 = recv.recvAddr;
            ifOrder.RecvZipCode__c		 = recv.recvZipCode;
            
            if(String.isNotBlank(recv.recvMobileNo) && !(recv.recvMobileNo.replace('-', '')).isNumeric()) {
                ifOrder.AUDType__c = null;
            } else { ifOrder.RecvMobileNo__c = recv.recvMobileNo; }

            if(String.isNotBlank(recv.recvPhoneNo) && !(recv.recvPhoneNo.replace('-', '')).isNumeric()) {
                ifOrder.AUDType__c = null;
            } else { ifOrder.RecvPhoneNo__c	 = recv.recvPhoneNo; }

            ifOrder.DelvMsg__c			 = recv.delvMsg;
            ifOrder.MarketName__c		 = recv.marketName;
            ifOrder.ShipNo__c 			 = recv.shipNo;
            // shipNo3, 4 추가
           
            ifOrder.DevlTypeName__c		= recv.delvTypeName;  
            ifOrder.Remark__c 			 = recv.remark;
            
            orderList.add(ifOrder);  
        }
        
        return orderList;
        
    } // insertOrderRecords()
}