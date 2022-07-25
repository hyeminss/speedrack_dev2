/**
 * Created by user on 2022-07-04.
 */

public with sharing class AS_Process_New {

    public AS_Process_New(){

    }
/*    @AuraEnabled(cacheable=true)
    public static List<Account> getCustomLookupSRO (String sroNo){//AS처리
        List<Account> sroLookupList =  new List<Account>();
        if(sroNo != ''){
            sroNo = '%' + sroNo + '%';
            sroLookupList = [Select id, Name, Type, Industry, Phone, Address__c, AccountNumber, Active__c, Price__c From Account WHERE AccountNumber LIKE:sroNo];
            return sroLookupList;
        }
        return sroLookupList;
    }*/

    @AuraEnabled(cacheable=true)
    public static List<Account> getRecordOne(String keyValue){
        String key = '%' + keyValue + '%';
        return [select Id, Name, Type, Industry, Phone, Site, AccountNumber from Account where Name = :keyValue];
    }

/*    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String accountId){
        //String key = '%' + accountId + '%';
        return [select Id, Name, Type, Industry, Phone, Address__c, AccountNumber, Active__c, Price__c from Account where Id = :accountId];
    }*/


    @AuraEnabled
    public static List<Account> updateRecord(String accountId, String accountIndustries, String accountPhones, String Site) {

        Account accData = [select Id, Name, Type, Industry, Phone, Site, AccountNumber from Account where id = :accountId ];

        List<Account> updatedAccountList = new List<Account>();

        if(accountId != null){
            if(accountIndustries != null && accountPhones != null && Site != null){
                Account accObj = new Account();
                accObj.Id = accountId;
                accObj.Industry = accountIndustries;
                accObj.Phone = accountPhones;
                accObj.Site = Site;
                updatedAccountList.add(accObj);
            }
            else if(accountIndustries == null && accountPhones == null && Site == null){
                Account accObj = new Account();
                accObj.Id = accountId;
                accObj.Industry = accData.Industry;
                accObj.Phone = accData.Phone;
                accObj.Site = accData.Site;
                updatedAccountList.add(accObj);
            }
            else if(accountIndustries != null){
                Account accObj = new Account();
                accObj.Id = accountId;
                accObj.Industry = accountIndustries;
                accObj.Phone = accData.Phone;
                accObj.Site = accData.Site;
                updatedAccountList.add(accObj);
            }
            else if(accountPhones != null){
                Account accObj = new Account();
                accObj.Id = accountId;
                accObj.Industry = accData.Industry;
                accObj.Phone = accountPhones;
                accObj.Site = accData.Site;
                updatedAccountList.add(accObj);
            }
            else if(Site != null){
                Account accObj = new Account();
                accObj.Id = accountId;
                accObj.Industry = accData.Industry;
                accObj.Phone = accData.Phone;
                accObj.Site = Site;
                updatedAccountList.add(accObj);
            }
        }

        if(!updatedAccountList.isEmpty()){
            System.debug('updatedAccountList: '+ updatedAccountList);
            update updatedAccountList;
            return updatedAccountList;
        }
        return NUll;
    }


/*    @AuraEnabled
    public static integer getAccounts2(integer firstNumber, integer secondNumber){
        return (firstNumber+secondNumber);
    }
    @AuraEnabled
    public static List<Account> getAccounts3(String AS11){
        List<Account> account = new List<Account>();
        Account acc = [select id, Name, type, industry from Account WHERE Name = 'Express Logistics and Transport'];
        acc.AccountNumber = AS11;
        account.add(acc);
        INSERT account;
        return account;
    }*/


}