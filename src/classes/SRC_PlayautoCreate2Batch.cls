/*
 * SRC_PlayautoCreate2Batch.cls
 * 오시우 2022-07-11 ver1.0
 * 설명 : DummyData -> Batch2
 */
global class SRC_PlayautoCreate2Batch implements Database.Batchable<SObject> {

    global SRC_PlayautoCreate2Batch(){}

    //batch start   
    global Database.QueryLocator start(Database.BatchableContext BC){

        System.debug('----------------------------------batchStart!!---------------------------------------------------------');
		String query = 'SELECT Id, SRF_OnlieOrderNo__c FROM SRO_Order1__c WHERE SRF_OrderDate__c >= LAST_90_DAYS ORDER BY SRF_OrderDate__c';
        //String query = 'SELECT Id, SRF_OnlieOrderNo__c FROM SRO_Order1__c WHERE SRF_OrderDate__c >= LAST_MONTH AND SRF_OrderDate__c <= TODAY ORDER BY SRF_OrderDate__c';
        return Database.getQueryLocator( query );

    }

    //batch execute
    global void execute(Database.BatchableContext BC, List<SRO_Order1__c> orderScopeList){


        system.debug('-----------------------------scope.size() : ------------------------------------' + orderScopeList.size());        
        List<IF_Playauto_SFDC_Inquirys__c> insertAllDummyData = new List<IF_Playauto_SFDC_Inquirys__c>();
        List<IF_Playauto_SFDC_Inquirys__c> tobeUpdate = new List<IF_Playauto_SFDC_Inquirys__c>();
    	List<SRO_Inquiry1__c> insertAllFinishData = new List<SRO_Inquiry1__c>();
        List<SRO_Order1__c> splitOrderScopeList = new List<SRO_Order1__c>();

        String regExp = '[a-zA-Z]';
        String shopOrdNo;


        for( SRO_Order1__c orderScopeList2: orderScopeList ){
            SRO_Order1__c orderScopeList3 = new SRO_Order1__c();

            if( orderScopeList2.SRF_OnlieOrderNo__c.contains('Z') ){
                orderScopeList3.SRF_OnlieOrderNo__c = orderScopeList2.SRF_OnlieOrderNo__c.remove('Z');
                orderScopeList3.Id = orderScopeList2.Id;

            } else {
                orderScopeList3.SRF_OnlieOrderNo__c = orderScopeList2.SRF_OnlieOrderNo__c;
                orderScopeList3.Id = orderScopeList2.Id;
            }

            splitOrderScopeList.add(orderScopeList3);

        }

        System.debug('-----------------splitOrderScoperList : -------------------------' + splitOrderScopeList);

        for(SRO_Order1__c orderScope : splitOrderScopeList){
            
            String query = 'SELECT Id, ShopOrdNo__c, ShopName__c, InqName__c, InqTitle__c, InqType__c, InqStatus__c, InqTime__c, InqContent__c FROM IF_Playauto_SFDC_Inquirys__c WHERE IsCreated__c = FALSE AND ShopOrdNo__c LIKE  \'%' + orderScope.SRF_OnlieOrderNo__c + '%\'' ;                 
            insertAllDummyData = database.query(query); 
            
            for(IF_Playauto_SFDC_Inquirys__c dummyData : insertAllDummyData){
             
                if( dummyData.ShopOrdNo__c.contains('-') ) {

                    shopOrdNo = dummyData.ShopOrdNo__c.remove('-');

                } else if(dummyData.ShopOrdNo__c.contains(' ')) {

                    shopOrdNo = dummyData.ShopOrdNo__c.remove(' ');

                } else {
                    shopOrdNo = dummyData.ShopOrdNo__c;
                }


                SRO_Inquiry1__c insertAllFinishData1 = new SRO_Inquiry1__c();
                insertAllFinishData1.SRF_LookupOrd__c    =    orderScope.Id;
                insertAllFinishData1.SRF_ShopOrdNo__c    =    shopOrdNo;
                insertAllFinishData1.SRF_ShopName__c     =    dummyData.ShopName__c;
                insertAllFinishData1.SRF_InqName__c      =    dummyData.InqName__c;
                insertAllFinishData1.SRF_InqTitle__c     =    dummyData.InqTitle__c;
                insertAllFinishData1.SRF_InqType__c      =    dummyData.InqType__c;
                insertAllFinishData1.SRF_InqStatus__c    =    dummyData.InqStatus__c;
                insertAllFinishData1.SRF_InqTime__c      =    String.valueOf(dummyData.InqTime__c);
                insertAllFinishData1.SRF_InqContent__c   =    dummyData.InqContent__c; 
                insertAllFinishData.add(insertAllFinishData1);

                
                dummyData.IsCreated__c = TRUE;
                tobeUpdate.add(dummyData);
            }
        }

        if( tobeUpdate.size() > 0 ){

            try {
                update tobeUpdate;

            } catch (Exception ex) {

                System.debug('ERROR : ' + ex.getMessage());
            }

        }

        if( insertAllFinishData.size() > 0){

            try {
                insert insertAllFinishData;

            } catch (Exception ex) {
                
                System.debug('ERROR : ' + ex.getMessage());
            }

        }

        System.debug('--------------------------------------scope---------------------------------------:' + orderScopeList);
        System.debug('--------------------------------------insertAllFinishData-------------------------:' + insertAllFinishData);

    }

    //batch finish
    global void finish(Database.BatchableContext BC){

		System.debug('--------------------------------------finish--------------------------------------');

    }
    
}