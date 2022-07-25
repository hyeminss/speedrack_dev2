@isTest
public with sharing class Test_Ctr_CtiSearchPageController {
    
    @isTest
    static void myTest(){

        // Test.startTest();
        System.Test.startTest();

        Account acct = new Account();
        acct.Name = 'TEST_ACCOUNT';
        acct.Phone = '0212345678';
        insert acct;
        
        Contact con = new Contact();
        con.LastName = 'TEST_CONTACT';
        con.MobilePhone = '01012345678';
        insert con;

        
        Task testTask = new Task();
        testTask.CallObject = '1234';
        insert testTask;

        
        Ctr_CtiSearchPageController cspc = new Ctr_CtiSearchPageController();


        cspc.taskPriorityList = new List<SelectOption>();
        cspc.taskStatusList  = new List<SelectOption>();
        cspc.objTypeList  = new List<SelectOption>();
        
        cspc.clientTypeList  = new List<SelectOption>();
        cspc.clientNameList  = new List<SelectOption>();
        
        cspc.relatedTypeList  = new List<SelectOption>();
        cspc.relatedRecordList  = new List<SelectOption>();
    



        cspc.searchRefresh();
        // 번호 미입력조회
        //System.debug('searchAction    // 번호 미입력 조회   === ');
        cspc.searchAction();

        // 없는번호 조회
        cspc.phoneNumber = '01044444444';
        //System.debug('searchAction    // 없는번호 조회   === ');
        cspc.searchAction();

        // 있는번호 조회
        cspc.phoneNumber = '01012345678';
        //System.debug('searchAction    // 있는번호 조회   === ');
        cspc.searchAction();

        //System.debug('saveNewTask    // 콜아이디없이 상담이력저장   === ');
        // 콜아이디없이 상담이력저장 
        cspc.saveNewTask();
        
        // whoid // whatid 없이 콜아이디 입력 상답이력저장 
        cspc.newTask.callId='1234';
        //System.debug('saveNewTask whoid // whatid 없이 콜아이디 입력 상답이력저장  === ');
        cspc.saveNewTask();

        // whatid 없이 상담이력 저장
        cspc.newTask.WhoId = con.Id;
        cspc.newTask.WhoName = con.LastName;
        cspc.newTask.callId='1234';
        //System.debug('saveNewTask whatid 없이 상담이력 저장 === ');
        cspc.saveNewTask();

        // 전부다 입력후 상담이력 저장
        cspc.newTask.WhatId = acct.Id;
        cspc.newTask.WhatName = acct.Name;
        cspc.newTask.callId='1234';
        cspc.newTask.callResult = '통화완료';
        //System.debug('saveNewTask 전부다 입력후 상담이력 저장 === ');
        cspc.saveNewTask();
        //System.debug('findObjectNameFromId === ');
        cspc.findObjectNameFromId(con.Id);



        // Test.stopTest();
        System.Test.stopTest();



    }
}