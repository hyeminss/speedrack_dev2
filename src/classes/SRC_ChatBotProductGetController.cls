public class SRC_ChatBotProductGetController {
    
 /* 
  * SRC_ChatBotInvoiceInquiryController.cls
  * [작성 이력]
  * 2022.06.15 ver1.0 김소연
  * 설명: ChatBot에서 송장조회 -> 고객 정보에 따른 제품 가져오기
  * 
  * [수정 이력]
  * 2022.06.27 ver1.1 김소연
  * 
  */
    
    // Chatbot에서 Input 값 저장
    public class InputBody {
        @InvocableVariable(required=true)
        public String inputName;
        
        @InvocableVariable(required=true)
        public String inputPhone;
    }
    
    @InvocableMethod(Label ='Get Product' description='Allows to get a Order record')
    public static List<List<String>> getProduct(List<InputBody> input){

        String name = input.get(0).inputName;     // 고객 이름
        String phone = input.get(0).inputPhone;   // 고객 전화번호
        name = name.replaceAll(' ', '');          // 이름에서 띄어쓰기 제거
        phone = phone.replaceAll(' ', '');        // 번호에서 띄어쓰기 제거
        String charToAdd = '%';
        String searchName = charToAdd + name + charToAdd;                        // 쿼리에서 search할 이름 저장
        String searchPhone = charToAdd + phone;
        Date orderDate;
        String orderName;
        List<String> outputString = new List<String>();
        List<List<String>> output = new List<List<String>>();
        SRO_Order1__c result;
        List<SRO_Order1__c> productList = new List<SRO_Order1__c>();

        // 고객 정보로 수주 Object에서 제품 List 가져오기
        try{            
            result = [SELECT SRF_OrderDate__c 
                      FROM SRO_Order1__c 
                      WHERE SRF_OrderOwner__c LIKE :searchName AND SRF_OrderOwnPhone__c LIKE :searchPhone 
                      ORDER BY SRF_OrderDate__c DESC LIMIT 1];
            
            orderDate = result.SRF_OrderDate__c;           
            productList = [SELECT SRF_Product__c FROM SRO_Order1__c WHERE SRF_OrderDate__c=: orderDate];
            
        } catch(Exception e){
            system.debug('Error: ' + e.getMessage());
        }
        
        if(result == null){
            output = null;           
        }else{           
            for(SRO_Order1__c od : productList){
                outputString.add(od.SRF_Product__c);
            }
            output.add(outputString);
        }
        
        return output;
    }


}