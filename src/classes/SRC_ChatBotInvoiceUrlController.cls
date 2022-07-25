/* 
* SRC_ChatBotInvoiceUrlController.cls
* [작성 이력]
* 김소연_2022.06.15_ver1.0
* 
*/
public class SRC_ChatBotInvoiceUrlController {
    
    @InvocableMethod(Label ='Get Invoice Url' description='Allows to get a Invoice Url')
    public static List<String> getInvoiceUrl(List<String> input){
        
        String invoiceNo = input.get(0);										// 송장번호 저장
        Integer startNum = Integer.valueOf(invoiceNo.substring(0, 1));			// 택배사 구별할 시작번호
        List<String> output = new List<String>();

        // 송장조회 url
        try{
            SRO_Logistic1__c result = [SELECT SRF_InvoiceUrl__c FROM SRO_Logistic1__c WHERE SRF_StartNum__c =: startNum];  
            output.add(result.SRF_InvoiceUrl__c + invoiceNo);
        } catch(Exception e){
            System.debug('ERROR: ' + e.getMessage());
        }

        return output;
    }
}