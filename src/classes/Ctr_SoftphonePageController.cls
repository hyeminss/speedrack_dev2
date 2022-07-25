global with sharing class Ctr_SoftphonePageController {
    
    
    public User loginUser {get;set;}
    public String ctiUserId {get;set;}
    public String ctiExtension {get;set;}

    public NewTask newTask{get;set;}

    global Ctr_SoftphonePageController() {
    
        ctiUserId = System.currentPagereference().getParameters().get('uId');
        ctiExtension = System.currentPagereference().getParameters().get('ex');
        newTask = new NewTask();
        
    }


    

    public PageReference logoutDo(){
        PageReference requestPage = new PageReference('/apex/ctiLoginPage'); 
        requestPage.setRedirect(true);
        return requestPage;

    }


    @future(callout=true)
    public static void sendCalloutUserList(){
      try{
        
        String center = 'speedrack';
        String cmd = 'userList';
        String endPointURL = 'https://sfcc02.matrixcloud.co.kr/api?center='+center+'&cmd='+cmd;
        
        String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MzI3MTgyMjEsImV4cCI6MTk0ODA3ODIyMX0.MtBKwgMJ7h9iM3J_mo5zyrcp0CKosCrAa8cQ_Go1ms0';
        
        Httprequest request = new HttpRequest();
        Http http = new Http();
            
            request.setMethod('GET');
            request.setEndpoint(endPointURL);
            
            // request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            
            request.setHeader('Access-Control-Allow-Headers','x-access-token');
            request.setHeader('x-access-token', token);
            
            //Making call to external REST API
            HttpResponse response = http.send(request);  
            System.debug('responseBody: '+response.getBody());
            
           if(response.getStatusCode() == 200){
            

           Map<String,Object> mapRes = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
           
          System.debug(JSON.serializePretty(mapRes));
          

           }


            

        }catch(Exception e){
        System.debug('Error::'+e.getMessage());
      }



    }



    @future(callout=true)
    public static void sendCalloutCallbackList(){
      try{
        
        String center = 'mytro';
        String cmd = 'cbkList';
        String startDate = '';
        String endDate ='';

        String endPointURL = 'https://api01.matrixcloud.co.kr/api?center='+center+'&cmd='+cmd;
        
        String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MzI3MTgyMjEsImV4cCI6MTk0ODA3ODIyMX0.MtBKwgMJ7h9iM3J_mo5zyrcp0CKosCrAa8cQ_Go1ms0';
        
        Httprequest request = new HttpRequest();
        Http http = new Http();
            
            request.setMethod('GET');
            request.setEndpoint(endPointURL);
            
            // request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            
            request.setHeader('Access-Control-Allow-Headers','x-access-token');
            request.setHeader('x-access-token', token);
            
            //Making call to external REST API
            HttpResponse response = http.send(request);  
            System.debug('responseBody: '+response.getBody());
            
           if(response.getStatusCode() == 200){
            

           Map<String,Object> mapRes = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
           
          System.debug(JSON.serializePretty(mapRes));
          

           }


            

        }catch(Exception e){
        System.debug('Error::'+e.getMessage());
      }



    }



    @future(callout=true)
    public static void sendCalloutTest(){
      try{
        
        //String endPointURL = 'https://clvs-staging.herokuapp.com/clovis';
        String endPointURL = 'https://175.208.211.248:5000/clovis';
        
        // String endPointURL = 'https://clvs-staging.herokuapp.com/clovis';
        String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MzI3MTgyMjEsImV4cCI6MTk0ODA3ODIyMX0.MtBKwgMJ7h9iM3J_mo5zyrcp0CKosCrAa8cQ_Go1ms0';
        
        /* String userName = UserInfo.getUserName();
        String password = 'demo1234*';
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue); */
        
        // Specify the required user name and password to access the endpoint 
        // As well as the header and header information 
      
        Httprequest request = new HttpRequest();
        Http http = new Http();
            
            //request.setHeader('Authorization', authorizationHeader);
            //Check the client certificate
            // request.setClientCertificateName('Sample-Rest-Self-Signed');
            request.setMethod('GET');
            request.setEndpoint(endPointURL);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('x-access-token', token);


            
            //Making call to external REST API
            HttpResponse response = http.send(request);  
            System.debug('responseBody: '+response.getBody());
            System.debug(JSON.serializePretty(response.getBody()));

        }catch(Exception e){
        System.debug('Error::'+e.getMessage());
      }



    }


    
    // Task 저장
    // Call Log 저장용
    // 사용안함 --> JS에서 직접 Insert/Update
    /* public void saveCallLog(){

        String callId = newTask.callId;

        Task task = [SELECT Id, CallObject,CallType, Rec_URL__c, Call_StartTime__c, Call_EndTime__c, cphone__c FROM Task WHERE CallObject = :callId LIMIT 1];
        DateTime dt = System.now();
        if(task  != null){

        } else {
            task = new Task();
            task.CallObject = callId;
            
            task.Subject = '[' + dt.format('YYYY-MM-dd HH:mm:ss')+'] Call_Log';
            
        }
            task.CallType = newTask.callType;
            task.Rec_URL__c = newTask.recURL;

            if(newTask.startTime != null && newTask.startTime != ''){
            task.Call_StartTime__c = newTask.startTime;
            String [] timeArr = newTask.startTime.split(':');
            
            Datetime startDateTime = Datetime.newInstance(dt.year(), dt.Month(), dt.day(), Integer.valueOf(timeArr[0]), Integer.valueOf(timeArr[1]), Integer.valueOf(timeArr[2]));
            System.debug('CALL startDateTime = ' + startDateTime);

            task.Call_StartDateTime__c = startDateTime;
            }
            
            if(newTask.endTime != null && newTask.endTime != ''){
            task.Call_EndTime__c = newTask.endTime;
            String [] timeArr = newTask.endTime.split(':');
            Datetime endDateTime = Datetime.newInstance(dt.year(), dt.Month(), dt.day(), Integer.valueOf(timeArr[0]), Integer.valueOf(timeArr[1]), Integer.valueOf(timeArr[2]));
            System.debug('CALL endDateTime = ' + endDateTime);
            task.Call_EndDateTime__c = endDateTime;
            
            }

            if(newTask.cphone != null && newTask.cphone != ''){
            task.cphone__c = newTask.cphone;
            }

         
            upsert task;

            newTask = new NewTask();

    }       
 */


}