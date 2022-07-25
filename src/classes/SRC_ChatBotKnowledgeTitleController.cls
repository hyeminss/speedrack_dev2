public class SRC_ChatBotKnowledgeTitleController {
    
 /* 
  * SRC_ChatBotInvoiceUrlController.cls
  * [작성 이력]
  * 김소연_2022.06.13_ver1.0
  * 
  */    
    
    @InvocableMethod(Label ='Get Knowledge Title' description='Allows to get a Knowledge record')
    public static List<List<String>> getKnowledgeTitle(List<String> input){
        
        String categoryName = input.get(0);   
        List<String> idList = new List<String>();
        List<List<String>> output = new List<List<String>>();  // Return
        List<Knowledge__DataCategorySelection> result;         // Object List : DataCategory
        List<Knowledge__kav> titleList;                        // Object List : Knowledge__kav
        List<String> outputTitle = new List<String>();         // Title 담을 List

        try{          
            // DataCategorySelection에서 CategoryName,Id 가져오기
            result = [SELECT DataCategoryName, ParentId FROM Knowledge__DataCategorySelection];

            // result에서 CategoryName과 input(Chatbot에서 입력된 CategoryName)을 비교, 해당 Id값 add
            for(Knowledge__DataCategorySelection k : result){
                if(k.DataCategoryName == categoryName) idList.add(k.ParentId);
            }

            // Id로 Knowledge의 제목 가져오기
            titleList = [SELECT Title FROM Knowledge__kav WHERE Id IN :idList AND PublishStatus = 'online'];
            
            for(Knowledge__kav a : titleList){
                outputTitle.add(a.Title);
            }           

        } catch(Exception e){
            
            System.debug('ERROR : ' + e.getMessage());
            
        }       
        output.add(outputTitle);

        return output;
    }  

}