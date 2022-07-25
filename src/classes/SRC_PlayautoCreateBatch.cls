/*
 * SRC_PlayautoCreateBatch.cls
 * 오시우 2022-07-11 ver1.0
 * 설명 : Playauto_Interface -> Batch
 */
global class SRC_PlayautoCreateBatch implements Database.Batchable<SObject>, Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        System.debug('batchStart!!');

        SRC_PlayautoRest interfaceData = new SRC_PlayautoRest();

        if (interfaceData.insertData() == null) {
            
            System.debug(' We can\'t get any datas! ');

        } else {

            interfaceData.insertData(); 
        }

        return Database.getQueryLocator( [select Id from Account] );

    }


    global void execute(Database.BatchableContext BC, List<SRO_Order1__c> scope){

    }

    global void finish(Database.BatchableContext BC){

    }
    
}