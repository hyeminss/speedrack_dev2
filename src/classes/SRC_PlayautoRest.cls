/*
 * SRC_PlayautoRest.cls
 * 오시우 2022-07-11 ver1.0
 * 설명 : Playauto -> SFDC [고객문의정보]_Interface
 */

global class SRC_PlayautoRest {
    global SRC_PlayautoRest() {}

    global static SRC_PlayautoRest playauto = null;
    global static SRC_PlayautoRest getInstance(){
        playauto = new SRC_PlayautoRest();

        return playauto;
    }

    // 연결해서 데이터 받기
    global String callInterfaceData(){

        DateTime newDate = DateTime.Now();                       //현재
        DateTime newDate2 = DateTime.Now().AddDays(-90);//-9     //그전의 날짜
        String dateAfter = string.valueof(newDate);
        String dateBefore = string.valueof(newDate2);
        system.debug('Time = ' + dateBefore);
        system.debug('Time = ' + dateAfter);

        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();

        request.setTimeout(120000);
        request.setMethod('POST');
        request.setHeader('x-api-key', '8ZjKfNY3wdaLBO8pZHccl4nmXc7kxbq11BnLlol3');
        request.setEndpoint('https://openapi.playauto.io/api/auth');
        String reqBody = 'email=sam96@solomontech.net&password=boolean123!';
        request.setBody(reqBody);
        response = http.send(request);

        String gResponseBody;
        if(response.getStatusCode() == 200){
            gResponseBody = response.getBody();
        }

        List<SRC_PlayautoWrapper.OAuth2> p_OAuth = new List<SRC_PlayautoWrapper.OAuth2>();
        if (String.isNotBlank(gResponseBody)) {
            p_OAuth = (List<SRC_PlayautoWrapper.OAuth2>) JSON.deserialize(gResponseBody, List<SRC_PlayautoWrapper.OAuth2>.class);//deserialize 할때 key 이름은 꼭 맞춰야됨.
        }

        HttpRequest requestCall = new HttpRequest();
        HttpResponse responseCall = new HttpResponse();

        requestCall.setTimeout(120000);
        requestCall.setMethod('POST');
        requestCall.setHeader('x-api-key', '8ZjKfNY3wdaLBO8pZHccl4nmXc7kxbq11BnLlol3');
        requestCall.setHeader('Authorization', 'Token ' + p_OAuth[0].token);
        requestCall.setEndpoint('https://openapi.playauto.io/api/inquirys');
        requestCall.setBody('date_type=wdate&sdate='+ dateBefore + '&edate=' + dateAfter);
        //requestCall.setBody('date_type=wdate&sdate=2022-06-29 16:10:00&edate=2022-07-01 16:20:00');
        responseCall = http.send(requestCall);
        String gResponseBody2;

        try {

            if(responseCall.getStatusCode() == 200) {
                gResponseBody2 = responseCall.getBody();
            }
            System.debug('gResponseBody2:' + gResponseBody2);
            
        } catch (Exception ex) {

            System.debug('ERROR : ' + ex.getMessage());    

        } 

        return gResponseBody2;
    }

    // 데이터 역직열화
    global List<SRC_PlayautoWrapper.InputBody> getData(){

        SRC_PlayautoRest interfaceData = new SRC_PlayautoRest();
        List<SRC_PlayautoWrapper.InputBody> deserializeAllData = new List<SRC_PlayautoWrapper.InputBody>();
            
        try {

            String stringData = interfaceData.callInterfaceData();
            System.debug(' stringData : '+stringData);
            String split = stringData.substring(1, stringData.length() -1);
            String split2 = split.replace('"results":','');
            System.debug(' split2 : '+split2);
            System.debug(LoggingLevel.Debug, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
            
            deserializeAllData = (List<SRC_PlayautoWrapper.InputBody>)JSON.deserialize(split2, List<SRC_PlayautoWrapper.InputBody>.class);
            System.debug(' deserializeAllData[0].shop_ord_no : '+ deserializeAllData[0].shop_ord_no );
            System.debug(' deserializeAllData.size() : ' + deserializeAllData.size() );
            
        } catch (Exception ex) {
                System.debug('ERROR : ' + ex.getMessage());
        }

        return deserializeAllData;
    }

    // 데이터 데미 테이블 저장
    global List<IF_Playauto_SFDC_Inquirys__c> insertData(){//void를 붙이지 않아도 상관없음?

        SRC_PlayautoRest interfaceData = new SRC_PlayautoRest();
        List<IF_Playauto_SFDC_Inquirys__c> playauto = new List<IF_Playauto_SFDC_Inquirys__c>();

        try {

            List<SRC_PlayautoWrapper.InputBody> interfaceAllData = interfaceData.getData();
            System.debug('getAllData : ' + interfaceAllData);

            for( SRC_PlayautoWrapper.InputBody playauto1 : interfaceAllData ){
                if( playauto1.shop_ord_no != null && playauto1.shop_ord_no != '' && playauto1.shop_ord_no != '상품문의' ){
                    IF_Playauto_SFDC_Inquirys__c playauto2  = new IF_Playauto_SFDC_Inquirys__c();
                    playauto2.ShopOrdNo__c  = playauto1.shop_ord_no;
                    playauto2.ShopName__c   = playauto1.shop_name;
                    playauto2.InqContent__c = playauto1.inq_content;
                    playauto2.InqName__c    = playauto1.inq_name;
                    playauto2.InqStatus__c  = playauto1.inq_status;
                    playauto2.InqTime__c    = date.valueof(playauto1.inq_time);
                    playauto2.InqTitle__c   = playauto1.inq_title;
                    playauto2.InqType__c    = playauto1.inq_type;
                    playauto.add(playauto2); 
                    }
                }            

                insert playauto;
                //List<IF_Playauto_SFDC_Inquirys__c> conList = [SELECT id FROM IF_Playauto_SFDC_Inquirys__c where InqStatus__c = '신규문의'];
                //delete(conList);
                //List<SRO_Inquiry1__c> conList2 = [SELECT id FROM SRO_Inquiry1__c where SRF_InqStatus__c = '신규문의'];
                //delete(conList2);
                
                System.debug('playauto:'+playauto);
                
        } catch (Exception ex) {

            System.debug('ERROR : ' + ex.getMessage());
        }
            return playauto;

    }
}