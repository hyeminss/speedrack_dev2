public with sharing class SRC_GetInquiry {
   /* 
    * SRC_GetInquiry.cls
    * [작성 이력]
    * 이혜민_2022.07.12_ver1.0   
    * 
    */
	@AuraEnabled(cacheable=true)
    public static List<SRO_Inquiry1__c> getCaseRelatedInquiry(String contactId){
        //1) CONTACT에서 ID 가져오기
        system.debug('contactId >> ' + contactId);
        List<String> OrderIds = new List<String>();
           
        //2)CONTACT ID를 기준으로 수주에서 수주번호 찾기 =>Name
        List<SRO_Order1__c> listOrder1 = [SELECT id, Name FROM SRO_Order1__c WHERE SRF_OrderName__c =: contactId];
        system.debug('listOrder1 >> ' + listOrder1);
        for(SRO_Order1__c order : listOrder1){
			OrderIds.add(order.Name);            
        }
        system.debug('OrderIds(수주번호) >> ' + OrderIds);
        
        //3) 수주번호 기준으로 고객수주문의 출력
        List<SRO_Inquiry1__c> listInquiry = [SELECT id, Name, SRF_InqType__c, SRF_InqTitle__c, SRF_ShopName__c, SRF_InqTime__c,SRF_LookupOrd__r.Name FROM SRO_Inquiry1__c WHERE SRF_LookupOrd__r.Name =: OrderIds];
        system.debug('listInquiry >> ' + listInquiry);
        return listInquiry;
    }
}