public class SRC_TestCreateAS {

    public static String checkUpdateAS(List<SRC_ERPCaseWrapper.ReceiveJson> asList) {
        // String result = 'SUCCESS';

        List<IF_SFDC_ERP_AS_Dummy__c> resetAUDList = new List<IF_SFDC_ERP_AS_Dummy__c>();
        List<IF_SFDC_ERP_AS_Dummy__c> sfdcASList = [SELECT NAME, SRF_AudType__c FROM IF_SFDC_ERP_AS_Dummy__c WHERE SRF_AUDType__c = 'D'];
        Map<String, String> seqMap = new Map<String, String>();

        for(IF_SFDC_ERP_AS_Dummy__c sfdcA : sfdcASList) {
            seqMap.put(sfdcA.Name, 'UnMatch');
        }

        for(SRC_ERPCaseWrapper.ReceiveJson erpA : asList) {
            seqMap.put(erpA.crmASSeq, 'Match');
        }

        
        seqMap.remove('Match');
        // List<IF_SFDC_ERP_AS_Dummy__c> resendList = [SELECT SRF_AUDType__c FROM IF_SFDC_ERP_AS_Dummy__c WHERE NAME =: seqMap.keySet()];
        // for(IF_SFDC_ERP_AS_Dummy__c seqNull : resendList) {
        //     IF_SFDC_ERP_AS_Dummy__c resendAS = new IF_SFDC_ERP_AS_Dummy__c();
        //     seqNull.SRF_AUDType__c = 'A';
        //     resetAUDList.add(seqNull);
        // }


        for(Integer i = 0; i < sfdcASList.size(); i++) {
            if(seqMap.containsKey(sfdcASList[i].Name) && seqMap.values()[i] == 'UnMatch') {
                System.debug('호호');
                IF_SFDC_ERP_AS_Dummy__c resendAS = new IF_SFDC_ERP_AS_Dummy__c();
                sfdcASList[i].SRF_AUDType__c = 'A';
                resetAUDList.add(sfdcASList[i]);   
            }

        }

        if(resetAUDList.size() > 0) {
            Update resetAUDList;
        }

        System.debug('>>>' + seqMap);

        return '';

    }
}