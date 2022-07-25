/*
 *  SRC_DynSurveyTest.cls
 *  2022.07.04 ver1.0 이새미
 *  설명 : SOQL 동적 필드 test
 */
public class SRC_DynSurveyTest {
    
    public static void testQuery(String phone, String name, String lkId, String obj) {
        
        String query = 'SELECT ID, ' + name + ', ' + phone + ', ' + lkId + ' FROM ' + obj; 
        List<String> nameList  = new List<String>();
        List<String> phoneList = new List<String>();
        List<Id> idList = new List<Id>();
        sObject sObj = Schema.getGlobalDescribe().get(obj).newSObject();
        
        List<sObject> survList = new List<sObject>();
        List<sObject> survUpsertList = new List<sObject>();
        survList.add(sObj);
        
        try {
            
            survList = Database.query(query);

            for(sObject s : survList) {
                idList.add(s.get('id').toString());
                nameList.add(s.get(name).toString());
                phoneList.add(s.get(phone).toString());
            }          
        
            
            List<Contact> listContact = [SELECT ID FROM CONTACT WHERE NAME =: nameList AND mobilePhone =: phoneList];

            for(Integer i = 0; i < listContact.size(); i++) {
                sObject ss = Schema.getGlobalDescribe().get(obj).newSObject();
                ss.put('Id', idList.get(i));
                ss.put(lkId, listContact.get(i).Id);
                survUpsertList.add(ss);
            }
            
            Database.UpsertResult[] resultList = Database.upsert(survUpsertList);
            // 실패값 어케 알리지..
            
        } catch(Exception e) {
            
            System.debug('ERROR : ' + e.getLineNumber() + ', ' +  e.getMessage());
        }       
        
    }
    
}