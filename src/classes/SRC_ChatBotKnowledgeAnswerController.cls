public class SRC_ChatBotKnowledgeAnswerController {

 /* 
  * SRC_ChatBotInvoiceUrlController.cls
  * [작성 이력]
  * 김소연_2022.06.14_ver1.0
  * 
  */
    
    @InvocableMethod(Label ='Get Knowledge Answer' description='Allows to get a Knowledge record')
    public static List<String> getKnowledgeAnswer(List<String> input){
        
        String title = input.get(0);
        String answer;
        Knowledge__kav result = new Knowledge__kav();
        List<String> output = new List<String>(); // Return        

        try{
            // Knowledge에서 Answer 가져오기
            result = [SELECT Answer__c FROM Knowledge__kav WHERE Title =: title AND PublishStatus = 'online'];
            // html 요소 제거
            answer = result.Answer__c.replaceAll('<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>','').replaceAll('&gt;', '>');
            output.add(answer);

        } catch(Exception e){           
            system.debug(e.getCause());            
        }

        return output;
    }
}