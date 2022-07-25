/*
* SRC_OrderCreateBatch.apxc
* [Create]
* 김소연 2022.07.13 ver1.0
* 설명 : [수주정보IF] -> [수주] Batch
*/

global class SRC_OrderCreateBatch implements Database.Batchable<sObject>, Database.stateful {

    global SRC_OrderCreateBatch () {

    }
    
    static Integer TOTAL_SIZE = 0;
    static Integer CREATECONTACT_SIZE = 0;
    static Integer UPDATE_SIZE = 0;
    static Integer SUCCESS_SIZE = 0;
    static Integer DELETE_SIZE = 0;
    
    /*
    	start
    */
    global Database.QueryLocator start(Database.BatchableContext bc){
        System.debug('-----------------------------------START-----------------------------------');
        // 수주 dummy에서 모든 필드 가져옴
        String query = 'SELECT Id, AUDType__c, OrderSeq__c, OrderSerl__c, OrderNo__c, CustName__c, UMDVConditionName__c,' +
                'RecvName__c, RecvAddr__c, RecvZipCode__c, RecvPhoneNo__c, RecvMobileNo__c,CustomerName__c, MarketName__c,'+
                'OrderDate__c, ItemSeq__c, ItemName__c, ItemNo__c, Spec__c, UnitName__c, Qty__c, OnLineOrdNo__c,'+
                'ShipNo__c, ShipNo3__c, ShipNo4__c, DevlTypeName__c, Remark__c, DelvMsg__c,CustomerAmt__c,'+
                'CustomerPhoneNo__c, ExternalId__c FROM IF_ERP_SFDC_Order_Dummy__c '+
				'WHERE IsSynced__c = FALSE';                

        return Database.getQueryLocator(query);
    }

    /*
    	execute
    */
    global void execute(Database.BatchableContext bc, List<IF_ERP_SFDC_Order_Dummy__c> orderDummyList){

        List<IF_ERP_SFDC_Order_Dummy__c> updateList = new List<IF_ERP_SFDC_Order_Dummy__c>();
        List<IF_ERP_SFDC_Order_Dummy__c> deleteList = new List<IF_ERP_SFDC_Order_Dummy__c>();
        List<IF_ERP_SFDC_Order_Dummy__c> tobeCreatedList = new List<IF_ERP_SFDC_Order_Dummy__c>();
        List<IF_ERP_SFDC_Order_Dummy__c> checkSyncedList = new List<IF_ERP_SFDC_Order_Dummy__c>();
        List<SRO_Order1__c> tobeInsertedList = new List<SRO_Order1__c>();
        List<SRO_Order1__c> tobeUpdatedList = new List<SRO_Order1__c>();
        List<SRO_Order1__c> tobeDeletedList = new List<SRO_Order1__c>();
        List<Contact> contacts = new List<Contact>();
        List<String> extIdList = new List<String>();
        List<Id> successList = new List<Id>();
        
        Map<String, Id> acc = new Map<String, Id>();
        Map<String, Id> custKeyMap = new Map<String, Id>();
        Map<String, Id> tempMap = new Map<String, Id>();
        Map<String, Id> extIdMap = new Map<String, Id>();
        Map<String, Id> contactMap = new Map<String, Id>();
        
        System.debug('-----------------------------------EXECUTE-----------------------------------');
        System.debug('====== DUMMY SIZE: ' + orderDummyList.size());
        
        // Contact과 lookup할 Account 정보(Id)
        Id accId = [SELECT Id FROM Account WHERE Name='주문고객관리'].Id;
        
        for(IF_ERP_SFDC_Order_Dummy__c orderDummy : orderDummyList){
            
            // Batch check field: IsSynced__c = true 업데이트
            orderDummy.IsSynced__c = TRUE;
            
            // 주문자 정보가 있으면 -> 주문자 정보로 Contact 생성
            // 주문자 정보 없고 수취인 정보 있으면 -> 수취인 정보로 Contact 생성
            if(orderDummy.CustomerName__c != null && orderDummy.CustomerPhoneNo__c != null){
                custKeyMap.put(orderDummy.CustomerName__c+orderDummy.CustomerPhoneNo__c, null);
            } else if(orderDummy.RecvName__c != null && orderDummy.RecvMobileNo__c != null){
                custKeyMap.put(orderDummy.RecvName__c+orderDummy.RecvMobileNo__c, null);
            } else{       
                TOTAL_SIZE++;
                
                continue;
            }
            
            // Type 판별
            if(orderDummy.AUDType__c == 'A'){
                tobeCreatedList.add(orderDummy);
            }else if(orderDummy.AUDType__c == 'U'){
                updateList.add(orderDummy);				
                extIdList.add(orderDummy.ExternalId__c);
            }else{
                deleteList.add(orderDummy);	
                extIdList.add(orderDummy.ExternalId__c);
            }
            
            TOTAL_SIZE++;
            checkSyncedList.add(orderDummy);
        } 
        update checkSyncedList;
        
        System.debug('====== Batch Size :' + TOTAL_SIZE);        
        System.debug('====== Type: Add ' + tobeCreatedList.size());        
        System.debug('====== Type: Update ' + updateList.size());    
        System.debug('====== Type: Delete ' + deleteList.size());    
        
        // Contact에서 Customer Key 가져옴
        for(Contact c : [SELECT ExternalId__c,id FROM Contact WHERE ExternalId__c =: custKeyMap.keySet()]){
            contactMap.put(c.ExternalId__c, c.Id);	
            tempMap.put(c.ExternalId__c, c.Id);
        }

        System.debug('====== 기존 Contact : ' + contactMap.size());    

        // Type Add에서 Contact이 없는 경우 Contact 생성
        for(IF_ERP_SFDC_Order_Dummy__c data : tobeCreatedList) {        

            String key;         
            Boolean isCust;            
            if(data.CustomerName__c != null && data.CustomerPhoneNo__c != null){
                key = data.CustomerName__c+data.CustomerPhoneNo__c;     
                isCust = True;
            }else if(data.RecvName__c != null && data.RecvMobileNo__c != null){
                key = data.RecvName__c+data.RecvMobileNo__c;      
                isCust = False;
            }else{

                continue;
            }        
            // 수주 레코드 : 수주번호 똑같은 고객정보 2개 , 
            // 
            if(!tempMap.containsKey(key)){
                
                Contact con = new Contact();
                con.AccountId = accId;        
                
                if(isCust){                 
                    con.LastName = data.CustomerName__c;
                    con.MobilePhone = data.CustomerPhoneNo__c;
                    con.ExternalId__c = data.CustomerName__c + data.CustomerPhoneNo__c;                        
                }else{
                    con.LastName = data.RecvName__c;
                    con.MobilePhone = data.RecvMobileNo__c;
                    con.ExternalId__c = data.RecvName__c + data.RecvMobileNo__c;  
                }
                tempMap.put(key, null);			// CustomerKey 중복 방지
                
                contacts.add(con);
            }
        }
        System.debug('To be Inserted Contact: ' + contacts.size());
        
        // Contact 생성
        if(contacts.size() > 0){
            try{
                Schema.SObjectField extId = Contact.Fields.ExternalId__c;
                Database.SaveResult[] insertResult = Database.insert(contacts, false);                
                for(Database.SaveResult con : insertResult){
                    if(con.isSuccess()){
                        successList.add(con.getId());

                        CREATECONTACT_SIZE++;
                    }else{
                        System.debug('================= Insert Contact Failed: ' + con.getErrors());
                    }
                }                
                System.debug('================= insert Contact SUCCESS: ' + CREATECONTACT_SIZE);
            }catch(DmlException e){
                System.debug('================= insert Contact ERROR: ' + e.getMessage());
            }
        }
        
        // 새로 생성된 Contact 정보 추가            
        if(successList.size() > 0){
            try{                
                for(Contact con : [SELECT Id, ExternalId__c FROM Contact WHERE Id =: successList]){
                    contactMap.put(con.ExternalId__c, con.Id);
                }
            }catch(DmlException e){
                System.debug('================= ' + e.getMessage());
            }
        }   

        System.debug('====== 생성 후 Contact Size: ' + contactMap.size());
        
        // Update, Delete -> External Id 기준으로 레코드 id 가져오기
        if(extIdList.size() > 0){
            
            for(SRO_Order1__c order : [SELECT External_Id__c, Id FROM SRO_Order1__c WHERE External_Id__c =: extIdList]){
                if(!extIdMap.containsKey(order.External_Id__c)) extIdMap.put(order.External_Id__c, order.Id);
            }
            
            for(Integer i = 0; i < updateList.size(); i++){
                if(extIdMap.containsKey(updateList[i].ExternalId__c)){
                    tobeCreatedList.add(updateList[i]);
                }
            }
            
            for(Integer i = 0; i < deleteList.size(); i++){
                if(extIdMap.containsKey(deleteList[i].ExternalId__c)){
                    System.debug('DELETE RECORDS: ' + deleteList[i]);
                    tobeDeletedList.add(new SRO_Order1__c(Id = extIdMap.get(deleteList[i].ExternalId__c)));
                }
            }
            
            System.debug(tobeCreatedList.size());
            System.debug(tobeDeletedList.size());
        }

        // 수주 object 생성
        if(tobeCreatedList.size() > 0){
            System.debug('========================== 수주 생성 =============================');
            
            for(IF_ERP_SFDC_Order_Dummy__c data : tobeCreatedList){
                SRO_Order1__c order = new SRO_Order1__c();
                
                String conKey;
                
                if(data.CustomerName__c == null && data.CustomerPhoneNo__c == null){
                    conKey = data.RecvName__c + data.RecvMobileNo__c;
                }else{
                    conKey = data.CustomerName__c + data.CustomerPhoneNo__c;
                }               

                order.SRF_MasterCode__c = data.OrderSeq__c;
                order.SRF_Orderdetail__c    = data.OrderSerl__c;
                order.Name              = data.OrderNo__c;
                order.SRF_Account__c    = data.CustName__c;
                order.SRF_OrderType__c  = data.UMDVConditionName__c;
                order.SRF_OrderDate__c  = data.OrderDate__c;
                order.SRF_BOMUnderCode__c   = String.valueOf(data.ItemSeq__c);
                order.SRF_Product__c = data.ItemName__c;
                order.SRF_ProductCode__c = data.ItemNo__c;
                order.SRF_ProductSpec__c = data.Spec__c;
                order.SRF_ProductUnit__c = data.UnitName__c;
                order.SRF_ProductAmount__c = data.Qty__c;
                order.SRF_OnlieOrderNo__c = data.OnLineOrdNo__c;
                order.SRF_ReceiverName__c = data.RecvName__c;
                order.SRF_ReceiverAddress__c = data.RecvAddr__c;
                order.SRF_ReceiverPostNo__c = data.RecvZipCode__c;
                order.SRF_ReceiverPhone1__c = data.RecvPhoneNo__c;
                order.SRF_RecieverPhone2__c = data.RecvMobileNo__c;
                order.SRF_Message__c = data.DelvMsg__c;
                order.SRF_Channel__c = data.MarketName__c;
                order.SRF_InvoiceNo1__c = data.ShipNo__c;
                order.SRF_InvoiceNo2__c = data.ShipNo3__c;
                order.SRF_InvoiceNo3__c = data.ShipNo4__c;
                order.SRF_ShipMethod__c = data.DevlTypeName__c;
                order.SRF_Comment__c = data.Remark__c;
                order.SRF_TotalCurr__c = data.CustomerAmt__c;
                order.SRF_OrderOwner__c = data.CustomerName__c;
                order.SRF_OrderOwnPhone__c = data.CustomerPhoneNo__c;
                order.External_Id__c = data.ExternalId__c;
                order.SRF_OrderName__c = contactMap.get(conKey);                
                
                if(data.AUDType__c == 'A'){                   
                    tobeInsertedList.add(order);
                }else{
                    order.Id = extIdMap.get(conKey);
                    tobeUpdatedList.add(order);
                }
            }
            System.debug('======= 수주 INSERT SIZE: ' + tobeInsertedList.size());
            System.debug('======= 수주 UPDATE SIZE: ' + tobeUpdatedList.size());
        }

        // 수주 생성
        if(tobeInsertedList.size() > 0){
            try{
                insert tobeInsertedList;            
                System.debug('================= insert Order SUCCESS: ' + tobeInsertedList.size());
            }catch(DmlException e){
                System.debug('================= insert Order ERROR: ' + e.getMessage());
            }
        }

        // 수주 업데이트
        if(tobeUpdatedList.size() > 0){
            try{
                Schema.SObjectField extId = SRO_Order1__c.Fields.External_Id__c;
                Database.UpsertResult[] upsertResult = Database.upsert(tobeUpdatedList, extId, false);
                UPDATE_SIZE = tobeUpdatedList.size();
                System.debug('================= update Order SUCCESS: ' + tobeUpdatedList.size());
            }catch(DmlException e){
                System.debug('================= update Order ERROR: ' + e.getMessage());
            }
        }

        // 수주 삭제
        if(tobeDeletedList.size() > 0){
            try{   
                delete tobeDeletedList;
                DELETE_SIZE = tobeDeletedList.size();
                System.debug(tobeDeletedList);
                System.debug('================= delete Order SUCCESS: ' + tobeDeletedList.size());
            }catch(DmlException e){
                System.debug('================= delete Order ERROR: ' + e.getMessage());
            }
        }           
    }

    /*
    	finish
    */
    global void finish(Database.BatchableContext bc){
        System.debug('-----------------------------------FINISH-----------------------------------');
        System.debug('Record Total Count = ' + TOTAL_SIZE);
        System.debug('Contact Create Count = ' + CREATECONTACT_SIZE);
        System.debug('Record Success Count = ' + SUCCESS_SIZE);
        System.debug('Record Update Count = ' + UPDATE_SIZE);
        System.debug('Record Delete Count = ' + DELETE_SIZE);
    }

}