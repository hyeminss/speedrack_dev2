@isTest
public with sharing class Test_Ctr_SoftphonePageController {

    

    @isTest
    static void myTest(){

        // Test.startTest();
        System.Test.startTest();
        Ctr_SoftphonePageController spc = new Ctr_SoftphonePageController();

        // Test.setCurrentPageReference(new PageReference('ctiSoftphonePage')); 
        System.Test.setCurrentPageReference(new PageReference('ctiSoftphonePage')); 
        System.currentPageReference().getParameters().put('uId', '2118240');
        System.currentPageReference().getParameters().put('ex', '63810');
        spc.loginUser = new User();

        Ctr_SoftphonePageController.sendCalloutCallbackList();
        Ctr_SoftphonePageController.sendCalloutTest();
        Ctr_SoftphonePageController.sendCalloutUserList();

        spc.logoutDo();
        NewTask nt = new NewTask();
        nt.Subject='';
        nt.description='';
        nt.whoId='';
        nt.whoName='';
        nt.whoIdType='';
        nt.whatId='';
        nt.whatName='';
        nt.whatIdType='';
        nt.priority='';
        nt.status='';
        nt.selectObjType='';
        nt.callId='';
        nt.callType='';
        nt.recURL='';
        nt.startTime='';
        nt.endTime='';
        nt.cphone='';
        nt.callResult='';

        // Test.stopTest();
        System.Test.stopTest();


        
    }

}