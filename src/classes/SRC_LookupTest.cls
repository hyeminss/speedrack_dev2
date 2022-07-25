/**
 * Created by user on 2022-07-08.
 */

public with sharing class SRC_LookupTest {

    @AuraEnabled(cacheable=true)
    public static void getLookupRecord(Id recordId) {
        if (!String.isBlank(recordId)) {
            Schema.SObjectType sObjectType = recordId.getSobjectType();
            String queryString = String.format('SELECT Id, Name FROM {0} WHERE Id =: recordId FOR VIEW', new List<Object>{sObjectType});
            Database.query(queryString);
        }
    }
}