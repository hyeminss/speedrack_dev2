/*
* SRC_ChatBotInvoiceInquiryController_Test.apec
* [Test]
* 김소연 2022.07.11 ver1.0
* 설명: 챗봇 수주번호 조회 Test Class
*/
@IsTest(SeeAllData=true)
private class SRC_ChatBotInvoiceInquiryControllerTest {
// data 만들음(static) -> 이 데이터를 controller에 보냄 -> database다녀옴
    @IsTest
    static void setUp1(){
        SRO_Order1__c order1 = new SRO_Order1__c(SRF_OrderOwner__c='서경준', SRF_OrderOwnPhone__c='01050336794', SRF_Product__c='제품1W160/기둥', SRF_Orderdetail__c='1', SRF_MasterCode__c='1');
        insert order1;
    }

    @IsTest
    private static void testMethod1(){

        List<SRC_ChatBotInvoiceInquiryController.InputBody> invoiceVariables = new List<SRC_ChatBotInvoiceInquiryController.InputBody>();
        SRC_ChatBotInvoiceInquiryController.InputBody invoiceVar = new SRC_ChatBotInvoiceInquiryController.InputBody();

        invoiceVar.inputName = '서경준';
        invoiceVar.inputPhone = '6794';
        invoiceVar.inputProduct = '제품1W160/기둥';

        invoiceVariables.add(invoiceVar);

        //Test.startTest();
		SRC_ChatBotInvoiceInquiryController.getInvoiceNumber(invoiceVariables);
        //Test.stopTest();        
        
    }
}