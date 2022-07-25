public with sharing class ConvertsObjectToJSON
{
    //Return the JSON string from record Id
    public static string ConvertsObjectToJSON(Id recordId)
    {
        String jsonData = '';
        try{
            if(String.isNotBlank(recordId))
            {
                String sObjectFields = '';
                 
                //Get sObject Name
                String objName = recordId.getSObjectType().getDescribe().getName();
                 
                //Getting the fields information
                Map<String, Schema.sObjectField> sObjectFieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
                 
                //Map key is the field API name and value is the field data type.
                Map<String, String> fieldMap = new Map<String, String>();
                 
                for(Schema.SObjectField sfield: sObjectFieldMap.Values()){
                    Schema.DescribeFieldResult fieldDesc = sfield.getDescribe();
                    fieldMap.put(fieldDesc.getName(), fieldDesc.getType().name());
                }
                 
                //Create query with all fields
                for(String field: fieldMap.keySet()){
                    sObjectFields += field+',';
                }
                sObjectFields = sObjectFields.removeEnd(',');
                 
                //Dynamic SOQL Query with all fields
                String soqlQuery = 'SELECT '+ sObjectFields +' FROM '+objName+' WHERE Id =: recordId';
                 
                //Execute the SOQL query
                sObject sObj = Database.Query(soqlQuery);
                 
                //Create JSON
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartArray();
                gen.writeStartObject();
                gen.writeFieldName('attributes');
                gen.writeStartObject();
                gen.writeStringField('type', objName);
                gen.writeEndObject();
                gen.writeFieldName('fields');
                gen.writeStartObject();
                 
                for(String field: fieldMap.keySet()){
                    if(sObj.get(field) != null){
                        gen.writeStringField(field, String.ValueOf(sObj.get(field)));
                    }
                    else{
                        gen.writeStringField(field, '');
                    }
                }
                 
                gen.writeEndObject();
                gen.writeEndObject();
                gen.writeEndArray();
                //Getting the JSON String Data
                jsonData = gen.getAsString();
            }
        }
        catch(Exception ex){
             
        }
        return jsonData;
    }
}

// String jsonData = ConvertsObjectToJSON.getJsonFromSObject('001B000000pA7sV');
// system.debug('jsonData-' + jsonData);