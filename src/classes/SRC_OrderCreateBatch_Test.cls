/*
* SRC_OrderCreateBatch_Test.apxc
* [Create]
* 김소연 2022.07.20 ver1.0
* 설명 : [수주] SRC_OrderCreateBatch 테스트 클래스
*/
@IsTest
private class SRC_OrderCreateBatch_Test {

// 수주 dummy 데이터 생성(A,U,D type)
// Contact 생성(수주에 있는 것, 없는 것)
// 수주 dummy 데이터의 external id와 일치하는 수주 데이터 생성(dummy type U)
	
    @testSetup
    static void setup(){
        
        List<IF_ERP_SFDC_Order_Dummy__c> testDummy = new List<IF_ERP_SFDC_Order_Dummy__c>();
        for(Integer i=0; i<5; i++){
            IF_ERP_SFDC_Order_Dummy__c data = new IF_ERP_SFDC_Order_Dummy__c();
            data.Seq__c = i;
            data.AUDType__c = 'A';
            data.CompanySeq__c = 1;
            
            testDummy.add(data);
        }
        
        // Account
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        
        
    }

    
}