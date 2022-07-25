public class SRC_ChatbotInquiryMappController {

  /* 
  * SRC_ChatbotInquiryMappController
  * 2022.07.08 서경준 ver 1.0
  * 
  * [수정이력]
  * 2022.07.08 이새미 ver1.1
  */
    
    // Input Phone Number
    public class InputPhone {
        @InvocableVariable(required=true)
        public String inputPhone;
    }

    // 뒷번호 4자리만 추출
    @InvocableMethod(label = 'Four digit Phone')
    public static List<String> getLast4phoneNumber(List<InputPhone> inputPhone){
        
		String answer ;
        
        for(InputPhone i : inputPhone) {
            answer = i.inputPhone;
        }
        
        answer = answer.substring(answer.length() - 4, answer.length());
        
        System.debug(answer);
        
        List<String> result = new List<String>();
        result.add(answer);
        
        return result;        
    }   
    
}