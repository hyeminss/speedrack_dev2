@isTest
public with sharing class Test_CtiLoginPageController {
    
    
    @isTest
    static void loginTest(){
        // Test.startTest();
        System.Test.startTest();
        CtiLoginPageController clpc = new CtiLoginPageController();

        clpc.txtUserID = '';
        clpc.extension = '63810';
        clpc.loginDo();

        clpc.txtUserID = '2118240';
        clpc.extension = '';
        clpc.loginDo();

        clpc.txtUserID = '2118240';
        clpc.extension = '63810';
        
        clpc.userSetting();
        clpc.loginDo();

        clpc.txtUserID = '2118240';
        clpc.extension = '63811';
        
        clpc.loginDo();

        clpc.resetErrorMsg();

        clpc.redirect();

        clpc.moveToSoftphonPage();
        clpc.checkLogin = true;
        clpc.moveToSoftphonPage();

        // Test.stopTest();
        System.Test.stopTest();


    }

}