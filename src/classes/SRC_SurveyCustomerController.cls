/*
 *  SRC_SurveyCustomerController
 *  2022.07.04 이새미 ver1.0
 *  설명 : SurveyCustomerMapping LWC Controller
 */
public with sharing class SRC_SurveyCustomerController {
    
    @AuraEnabled 
    public static String surveyCustomerMapping(String phone, String name, String lkId, String obj) {
		
        String result = '';
        // 필드명이 바뀐 경우
        // 필드명에 __c가 붙지 않은 경우
        
        // Dynamic Query
        String query = 'SELECT ID, ' + name + ', ' + phone + ', ' + lkId + ' FROM ' + obj; 
        
        List<String> nameList  = new List<String>();
        List<String> phoneList = new List<String>();
        List<Id> idList = new List<Id>();
        
        // Object 생성
        sObject sObj = Schema.getGlobalDescribe().get(obj).newSObject();
        
        List<sObject> survList 		 = new List<sObject>();
        List<sObject> survUpsertList = new List<sObject>();
        survList.add(sObj);
        survList = Database.query(query);
            
        for(sObject s : survList) {
            idList.add(s.get('id').toString());
            nameList.add(s.get(name).toString());
            phoneList.add('%' + s.get(phone).toString().subString(7, 11));
        }          
        
        try {
            
			System.debug('SURVEY LIST : ' + survList);            
            List<Contact> listContact = [SELECT ID, NAME FROM CONTACT WHERE NAME = :nameList AND mobilePhone LIKE :phoneList];
            System.debug('LIST CONTACT : ' + listContact);
            for(Integer i = 0; i < listContact.size(); i++) {
                sObject surveyCustObj = Schema.getGlobalDescribe().get(obj).newSObject();
                surveyCustObj.put('Id', idList.get(i));
                surveyCustObj.put(lkId, listContact.get(i).Id);
                survUpsertList.add(surveyCustObj);
            }
            
            System.debug('PHONE : ' + phoneList);
            System.debug('NAME : ' + nameList);
            System.debug('NAME : ' + survUpsertList);
            if(survUpsertList.size() == 0) { result = '에러 : 필드명을 다시 확인하세요.'; }
            Database.UpsertResult[] resultList = Database.upsert(survUpsertList);
            for(Database.UpsertResult r : resultList) {
                if(r.isSuccess()) {
                    System.debug('와오아아ㅘ ' + r.getId());
                    result = '저장 되었습니다.';
                } else {
                    for(Database.Error err : r.getErrors()) {
                        System.debug('ERRRRRR : ' + err.getMessage());
                    }
                    
                }
            }
            // 실패값 어케 알리지..
            
        } catch(Exception e) {
            
            System.debug('ERROR : ' + e.getLineNumber() + ', ' +  e.getMessage());
        }       
        
        return result;
    }
}