/**
* SRC_ChatBotInvoiceInquiryController.apxc
* 2022.07.11 ver1.0 김소연
* 설명 : 챗봇 수주번호 서치
*/
public class SRC_ChatBotInvoiceInquiryController {

    public class InputBody {
        @InvocableVariable(required=true)
        public String inputName;
        
        @InvocableVariable(required=true)
        public String inputPhone;
        
        @InvocableVariable(required=true)
        public String inputProduct;
    }
    
    @InvocableMethod(Label ='Get Invoice Number' description='Allows to get a Order record')
    public static List<List<String>> getInvoiceNumber(List<InputBody> input){
        
        String charToAdd = '%';
        String name = input.get(0).inputName;					// 고객 이름
        String product = input.get(0).inputProduct;				// 선택한 제품
        String phone = charToAdd + input.get(0).inputPhone;		// 번호 뒷자리
        List<SRO_Order1__c> result = new List<SRO_Order1__c>();	// 쿼리 결과 받을 List
        List<String> invoiceNo = new List<String>();			// 송장번호
        List<List<String>> output = new List<List<String>>();
        
        try{
            result = [SELECT SRF_InvoiceNo1__c, SRF_InvoiceNo2__c, SRF_InvoiceNo3__c
                     FROM SRO_Order1__c
                     WHERE SRF_OrderName__r.Name =:name AND SRF_OrderName__r.MobilePhone  LIKE :phone AND SRF_Product__c =:product
                     ORDER BY SRF_OrderDate__c DESC
                     LIMIT 1];
            
        } catch(Exception e){
            
            System.debug('ERROR: '+ e.getMessage());
            
        }
        // result length체크: null이거나 ,(취소된 송장)로 시작하면 null값 리턴
        if(result == null || result.get(0).SRF_InvoiceNo1__c.substring(0,1).equals(',')){            
            output = null;    
        }else{            
            if(result.get(0).SRF_InvoiceNo1__c != null) InvoiceNo.addAll(result.get(0).SRF_InvoiceNo1__c.split(','));
            if(result.get(0).SRF_InvoiceNo2__c != null) InvoiceNo.addAll(result.get(0).SRF_InvoiceNo2__c.split(','));
            if(result.get(0).SRF_InvoiceNo3__c != null) InvoiceNo.addAll(result.get(0).SRF_InvoiceNo3__c.split(','));  
            output.add(invoiceNo);
        }
        
        return output;
    }

}