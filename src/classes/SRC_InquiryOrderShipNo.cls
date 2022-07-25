public with sharing class SRC_InquiryOrderShipNo {
    
    @AuraEnabled
    public static List<Map<String,String>> getShipNo(String recordId) {
        List<Map<String, String>> result = new List<Map<String, String>>();
        List<SRO_Order1__c> ordList = [SELECT SRF_InvoiceNo1__c, SRF_InvoiceNo2__c, SRF_InvoiceNo3__c 
                                       FROM   SRO_ORDER1__C 
                                       WHERE  ID =: recordId];

        List<String> shiPNos = new List<String>();
        List<String> shiPNos2 = new List<String>();
        List<String> shiPNos3 = new List<String>();

        try {

            System.debug('>>>');
            if(ordList[0].get('SRF_InvoiceNo1__c') != null ) shiPNos  = ordList[0].get('SRF_InvoiceNo1__c').toString().split(',');
            if(ordList[0].get('SRF_InvoiceNo2__c') != null ) shiPNos2 = ordList[0].get('SRF_InvoiceNo2__c').toString().split(',');
            if(ordList[0].get('SRF_InvoiceNo3__c') != null ) shiPNos3 = ordList[0].get('SRF_InvoiceNo3__c').toString().split(',');
            
            
            String url = 'https://tracker.delivery/#/kr.';
            for(String s : shiPNos) {
                Map<String, String> m = new Map<String, String>();
                if(s.substring(0, 1) == '3') { m.put('SRF_InvoiceNo1__c', s); m.put('ShipNoURL', url + 'cjlogistics' + s); }
                if(s.substring(0, 1) == '5') { m.put('SRF_InvoiceNo1__c', s); m.put('ShipNoURL', url + 'kdexp ' + s); }
                if(s.substring(0, 1) == '6') { m.put('SRF_InvoiceNo1__c', s); m.put('ShipNoURL', url + 'chunilps ' + s); }

                result.add(m);
            }
            
            System.debug('RESULT : ' + result);

            for(String s : shiPNos2) {
                Map<String, String> m = new Map<String, String>();
                if(s.substring(0, 1) == '3') { m.put('SRF_InvoiceNo2__c', s); m.put('ShipNoURL', url + 'cjlogistics' + s); }
                if(s.substring(0, 1) == '5') { m.put('SRF_InvoiceNo2__c', s); m.put('ShipNoURL', url + 'kdexp ' + s); }
                if(s.substring(0, 1) == '6') { m.put('SRF_InvoiceNo2__c', s); m.put('ShipNoURL', url + 'chunilps ' + s); }

                result.add(m);
            }
            
            System.debug('RESULT : ' + result);
            
            for(String s : shiPNos3) {
                Map<String, String> m = new Map<String, String>();
                if(s.substring(0, 1) == '3') { m.put('SRF_InvoiceNo3__c', s); m.put('ShipNoURL', url + 'cjlogistics' + s); }
                if(s.substring(0, 1) == '5') { m.put('SRF_InvoiceNo3__c', s); m.put('ShipNoURL', url + 'kdexp ' + s); }
                if(s.substring(0, 1) == '6') { m.put('SRF_InvoiceNo3__c', s); m.put('ShipNoURL', url + 'chunilps ' + s); }
                result.add(m);
            }
            
            System.debug('RESULT : ' + result);
            
        } catch(Exception e) {
            System.debug('ERROR : ' + e.getMessage());
        }
        
        
        return result;
    }
}