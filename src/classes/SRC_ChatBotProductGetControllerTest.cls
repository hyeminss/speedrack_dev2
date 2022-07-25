/**
* SRC_ChatBotProductGetController.apxc
* 2022.07.11 ver1.0 김소연
* 설명 : ChatBot Get Product Test Class
*/
@IsTest
public class SRC_ChatBotProductGetControllerTest {

    @IsTest
    static void setUp(){
        SRO_Order1__c order1 = new SRO_Order1__c(SRF_OrderOwner__c='서경준', SRF_OrderOwnPhone__c='01050336794', SRF_Product__c='제품1W160/기둥', 
                                                 SRF_Orderdetail__c='1', SRF_MasterCode__c='1', SRF_OrderDate__c=Date.valueOf('2022-06-30'));
        insert order1;
    }
    @IsTest
    private static void testInvocableMethod(){

        SRC_ChatBotProductGetController.InputBody request = new SRC_ChatBotProductGetController.InputBody();

        request.inputName = '서경준';
        request.inputPhone = '6794';

        Test.startTest();
        SRC_ChatBotProductGetController.getProduct(new List<SRC_ChatBotProductGetController.InputBody> {request});
        Test.stopTest();

    }
}