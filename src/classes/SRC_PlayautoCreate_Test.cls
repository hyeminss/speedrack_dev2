/*
 * SRC_PlayautoScheduledTest.cls
 * 오시우 2022-07-11 ver1.0
 * 설명 : DummyData -> Batch
 */
//@isTest(SeeAllData=true) 데비안에 모든 데이터를 보이게
@isTest
Private with sharing class SRC_PlayautoCreate_Test{

    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    //SRC_PlayautoInterface playautotest = new SRC_PlayautoInterface();

    static testmethod void testShecduledJob(){
        // Create some out of date ** Records
        List<IF_Playauto_SFDC_Inquirys__c> playauto = new List<IF_Playauto_SFDC_Inquirys__c>();
        for(Integer i=0; i<200; i++){
            IF_Playauto_SFDC_Inquirys__c l = new IF_Playauto_SFDC_Inquirys__c();
                l.ShopOrdNo__c  = '2022062749560570:' + i;
                l.ShopName__c   = '스마트스토어' + i;
                l.InqName__c    = '임동탁' + i;
                l.InqTitle__c   = '[고객문의]반품건';
                l.InqType__c    = '상품문의';
                l.InqTime__c    = date.valueof('2022-06-29 19:21:32');
                l.InqStatus__c  = '신규문의';
                l.InqContent__c = '안녕하세요';                                                                                                                            
            	playauto.add(l);
        }


            //Test.startTest();
            insert playauto;
            // Schedule the test job
            //String jobId = System.schedule('ScheduledApexTest7', CRON_EXP, new SRC_PlayautoInterface());
            //System.debug('jobId : '+jobId);
            //Test.stopTest();

            // Now that the scheduled job has executed,
            // check that we have 200 Record
            List<IF_Playauto_SFDC_Inquirys__c> check = new List<IF_Playauto_SFDC_Inquirys__c>();
            check = [select id from IF_Playauto_SFDC_Inquirys__c where InqStatus__c = '신규문의'];
            System.assertEquals(200, check.size(), 'Record were not created');
        }

}