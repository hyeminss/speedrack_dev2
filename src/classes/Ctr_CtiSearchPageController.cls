public with sharing class Ctr_CtiSearchPageController {

    public String phoneNumber {get; set;}

    // 검색 결과
    public List<Contact> contactList {get; set;}
    public List<Lead> leadList {get; set;}
    public List<Account> accountList {get; set;}
    public List<Case> caseList {get; set;}
    public List<Opportunity> oppList {get; set;}

    // person account 추가
    public List<Account>  personAccountList{get;set;}


    // Contact/Lead 등록 버튼 표시 여부
    public Boolean warningMsg {get; set;}

    // Task 등록 시 선택한 레코드
    // public String objType {get; set;}
    // public String selectedId {get; set;}

    // Task 등록 여부 check
    public Boolean checkResult {get; set;}
    public String errorMsg {get; set;}

    // Task Picklist
    public List<SelectOption> taskPriorityList {get; set;}  // priority picklist value
    public List<SelectOption> taskStatusList {get; set;}  // status picklist value

    public List<SelectOption> objTypeList {get; set;}
    
    public List<SelectOption> clientTypeList {get; set;}
    public List<SelectOption> clientNameList {get; set;}
    
    public List<SelectOption> relatedTypeList {get; set;}
    public List<SelectOption> relatedRecordList {get; set;}

    // 관련항목 표시 여부
    public Boolean setTaskPickList {get; set;}

    // New Task
    public NewTask newTask {get; set;}

    // New Lead
    public Lead newLead {get; set;}
    public List<SelectOption> leadSourceList {get; set;}

    // New Contact
    public Contact newContact {get; set;}
    public String phoneType {get; set;}
    public String accountId {get; set;}
    public List<SelectOption> phoneTypePicklist {get; set;}
    public List<SelectOption> accountPickList {get; set;}

    // 내 작업목록_BG
    public ListView MyTaskListView {get; set;}


    // Timezone 적용
    public Double offset {
        get {
            TimeZone tz = UserInfo.getTimeZone();
            return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        }
    }

    public Ctr_CtiSearchPageController() {
        warningMsg = false;
        setTaskPickList = true;
        checkResult = false;
        errorMsg = '';

        contactList = new List<Contact>();
        leadList = new List<Lead>();
        accountList = new List<Account>();
        caseList = new List<Case>();
        oppList = new List<Opportunity>();

        newContact = new Contact();
        newLead = new Lead();

        newTask = new NewTask();

    
        // MyTaskListView 불러오기_BG
        // getMyTaskListView();
    }


    // _CS 검색 초기화 
    public void searchRefresh(){
        contactList = new List<Contact>();
        leadList = new List<Lead>();
        accountList = new List<Account>();
        caseList = new List<Case>();
        oppList = new List<Opportunity>();
        phoneNumber ='';
        warningMsg = false;
        
    }

    // 전화번호로 검색
    public void searchAction() {
        System.debug('phoneNumber : ' + phoneNumber);

        if(phoneNumber != null && phoneNumber != ''){
        contactList = new List<Contact>();
        leadList = new List<Lead>();
        accountList = new List<Account>();
        caseList = new List<Case>();
        oppList = new List<Opportunity>();
        

        //Set<Id> contactIdSet = new Set<Id>();
        //Set<Id> accountIdSet = new Set<Id>();

          


        contactList = [SELECT Id, Name, LastName, Title, AccountId, Account.Name, Phone, MobilePhone, LastModifiedDate, CreatedDate
                        FROM Contact
                        WHERE (Phone = :phoneNumber OR MobilePhone = :phoneNumber) 
                        ORDER BY LastModifiedDate DESC];
        System.debug('contactList : ' + contactList);

        leadList = [SELECT Id, Name, LastName, Company, Title, Phone, MobilePhone, LastModifiedDate, CreatedDate
                    FROM Lead
                    WHERE (Phone = :phoneNumber OR MobilePhone = :phoneNumber) AND IsConverted = false
                    ORDER BY LastModifiedDate DESC];
        System.debug('leadList : ' + leadList);

        
        /* 2022-02-15 개인 계정 검색조건 추가*/
        List<Account> liTempAccounts = [SELECT Id, Name, CreatedDate, Phone  FROM Account WHERE Phone = :phoneNumber ];
                        
        // System.debug('liTempAccounts >>> \n ' + JSON.serializePretty(liTempAccounts) );
            for(Account a : liTempAccounts){
                    accountList.add(a);
            }

                    
        // 검색결과가 없으면 Warning 메세지 -> Lead/Contact 등록 버튼 출력
        if(contactList.size() == 0 && leadList.size() == 0 && accountList.size() == 0 ) {
            warningMsg = true;
            errorMsg = '존재하지 않는 번호입니다.';
        } else {
            warningMsg = false;
            errorMsg='';
        }

    } else {
        warningMsg = true;
        errorMsg = '번호를 입력하세요.';
        
    }


        System.debug('warningMsg : ' + warningMsg);
        System.debug('errorMsg : ' + errorMsg);
    }



    // ID 와 Name 값으로 데이터 검사
    public Boolean checkIdAndNameValue(String rId, String rName){

        if(rId != null && rName != null){
        String query = 'SELECT COUNT() ';
        String sObjectName = findObjectNameFromId(rId);

        if(sObjectName == 'Case'){
            query += 'FROM ';
            query += sObjectName;
            query += ' WHERE Id = :rId AND CaseNumber = :rName ';
        } else {
            query += 'FROM ';
            query += sObjectName;
            query += ' WHERE Id = :rId AND Name = :rName ';
        }

        Integer cnt = Database.countQuery(query);


        System.debug('checkIdAndNameValue('+rId+' , '+ rName + ' ) == > ' + cnt);
        
        if(cnt > 0){
            return true;
        } else {
            return false;
        }
        } return false;
    }


    // Task 저장
    public void saveNewTask() {
        warningMsg = false;
        checkResult = false;
        errorMsg = '';


        if(!checkIdAndNameValue(newTask.whoId,newTask.whoName)){

            warningMsg = true;
            errorMsg = '선택한 고객정보와 입력된 고객정보가 일치하지 않습니다.';
            
        } 

        if (newTask.whatId != null && newTask.whatId != ''){

            if(!checkIdAndNameValue(newTask.whatId,newTask.whatName)){
                warningMsg = true;
                errorMsg = '선택한 관련항목과 입력된 관련항목이 일치하지 않습니다.';
                
            } 

        } 

        if(!warningMsg){

            try {
                String callId = newTask.callId;
                Task task;
                
                if(callId != null && callId != ''){
                    task = [SELECT Id, CallObject,Description,OwnerId FROM Task WHERE CallObject = :callId LIMIT 1];
                }
                
                DateTime dt = System.now();
                
                
                String strDt = '[' + dt.format('YYYY-MM-dd HH:mm:ss')+']';

                // System.debug('task ========> ' + task);
                String mode = '';
                if(task != null){
                    mode = 'UPDATE';
                    
                    if(task.Description != '' && task.Description != null ){
                        task.Description += '\n\n';
                        
                    } else {
                        task.Description = '';
                    }
                    task.Description += strDt;
                    /* task.Description += ' ';
                    task.Description += newTask.callType;
                    */task.Description += ' - ';
                    task.Description += UserInfo.getName();
                    task.Description += '\n';
                    task.Description += newTask.description;
                    
                    task.OwnerId = UserInfo.getUserId();
                    

                } else {
                task = new Task();
                
                mode = 'INSERT';
                
                task.Subject =  strDt + ' 상담후처리';
                /* task.Description += ' ';
                task.Description += newTask.callType; */
                task.Description = '';
                task.Description += strDt;
                task.Description += ' - ';
                task.Description += UserInfo.getName();
                task.Description += '\n';
                task.Description += newTask.description;
                task.CallType = newTask.callType;
                // Sandbox RecordTypeId 
                task.RecordTypeId = '0129D000001R2UhQAK';
                }

                
                // whoId,whatId,description,callType,callId,recURL,startTime,endtTime
                if(newTask.whoId != null && newTask.whoId != ''){
                    task.WhoId = newTask.whoId;
                    }
                    
                if(newTask.whatId != null && newTask.whatId !='' ){
                    task.WhatId = newTask.whatId;
                } else {
                    // WhoId Contact 일 경우 WhatId 선택하지 않아도 Account 자동 매핑

                    String whoIdType = findObjectNameFromId(task.WhoId);

                    /* if(whoIdType == 'Contact' && !newTask.psersonAccount){ */
                        if(whoIdType == 'Contact'){

                        Contact con = [SELECT Id, LastName, AccountId  FROM Contact WHERE ID = :task.WhoId ];
                        task.whatId = con.AccountId;
                    }

                }
                    
                    // task.Type = 'Call';
                    // task.Call_ID__c = newTask.callId;
                    task.CallObject = newTask.callId;
                    
                    // task.Rec_URL__c = newTask.recURL;
                    task.Call_StartTime__c = newTask.startTime;
                    task.Call_EndTime__c = newTask.endTime;
                    
                    // 통화결과 : none // 부재중 // 콜백필요 // 통화완료
                    if(newTask.callResult != 'none'){
                        task.Call_Result__c = newTask.callResult;
                    }

                    System.debug('saveNewTask() = > mode : ' + mode); 

                    System.debug('task >>>>');
                    System.debug(JSON.serializePretty(task));

                    upsert task;
                


                checkResult = true;

                System.debug(checkResult);
        
                newTask = new NewTask();
                //clientNameList = new List<SelectOption>();
                //relatedRecordList = new List<SelectOption>();

            } catch(Exception e) {
                errorMsg = e.getMessage();
                System.debug('Exception : ' + errorMsg);
            }

        }
    }

    // Lead 저장
    /*
    public void saveNewLead() {
        System.debug('phoneNumber : ' + phoneNumber);
        System.debug('phoneType : ' + phoneType);

        warningMsg = false;
        checkResult = false;
        errorMsg = '';

        try {
            if(phoneType.equals('phone')) {
                newLead.Phone = phoneNumber;
            } else if(phoneType.equals('mobilePhone')) {
                newLead.MobilePhone = phoneNumber;
            }

            newLead.LeadSource = 'Phone Inquiry';

            System.debug(newLead);

            insert newLead;
            checkResult = true;

            System.debug(checkResult);
    
            newLead = new Lead();

        } catch(Exception e) {
            errorMsg = e.getMessage();
            System.debug('Exception : ' + errorMsg);
        }        
    }

    */
    // Contact 저장
    /*
    public void saveNewContact() {
        System.debug('phoneNumber : ' + phoneNumber);
        System.debug('phoneType : ' + phoneType);
        System.debug('accountId : ' + accountId);

        warningMsg = false;
        checkResult = false;
        errorMsg = '';

        try {
            if(phoneType.equals('phone')) {
                newContact.Phone = phoneNumber;
            } else if(phoneType.equals('mobilePhone')) {
                newContact.MobilePhone = phoneNumber;
            }

            newContact.AccountId = accountId;

            System.debug(newContact);

            insert newContact;
            checkResult = true;

            System.debug(warningMsg);
            System.debug(checkResult);
    
            newContact = new Contact();

        } catch(Exception e) {
            errorMsg = e.getMessage();
            System.debug('Exception : ' + errorMsg);
        }        
    }
    */

    // Task Picklist 가져오기
    /*
    public void getTaskPickListValues() {

        // Priority
        Schema.DescribeFieldResult priorityResult = Schema.Task.Priority.getDescribe();
        List<Schema.PicklistEntry> priorityPickList = priorityResult.getPicklistValues();

        taskPriorityList = new List<SelectOption>();
        taskPriorityList.add(new SelectOption('', '선택해주세요.'));
        for(Schema.PicklistEntry p : priorityPickList) {
            taskPriorityList.add(new SelectOption(p.getValue(), p.getLabel()));
        }

        // Status
        Schema.DescribeFieldResult statusResult = Schema.Task.Status.getDescribe();
        List<Schema.PicklistEntry> statusPickList = statusResult.getPicklistValues();

        taskStatusList = new List<SelectOption>();
        taskStatusList.add(new SelectOption('', '선택해주세요.'));
        for(Schema.PicklistEntry p : statusPickList) {
            taskStatusList.add(new SelectOption(p.getValue(), p.getLabel()));
        }
    }
    */

    // Lead Picklist 가져오기
    /*
    public void getLeadPickListValues() {
        Schema.DescribeFieldResult leadSourceResult = Schema.Lead.LeadSource.getDescribe();
        List<Schema.PicklistEntry> leadSourcePickList = leadSourceResult.getPicklistValues();

        leadSourceList = new List<SelectOption>();
        leadSourceList.add(new SelectOption('', '선택해주세요.'));
        for(Schema.PicklistEntry p : leadSourcePickList) {
            leadSourceList.add(new SelectOption(p.getValue(), p.getLabel()));
        }
    }
    */

    // 전체 Account List 가져오기
    /*
    public void getAllAccountList() {
        List<Account> allAccountList = [SELECT Id, Name FROM Account];
        
        accountPickList = new List<SelectOption>();
        accountPickList.add(new SelectOption('', '---없음---'));
        for(Account a : allAccountList) {
            accountPickList.add(new SelectOption(a.Id, a.Name));
        }
    }

    public void setPhoneTypePickList() {
        phoneTypePicklist = new List<SelectOption>();
        phoneTypePicklist.add(new SelectOption('phone', '전화번호로 등록'));
        phoneTypePicklist.add(new SelectOption('mobilePhone', '핸드폰번호로 등록'));
    }
    */

    // 전체 리셋
    /* 
    public void resetAll() {
        System.debug('resetAll');

        newTask = new NewTask();
        objTypeList = new List<SelectOption>();

        clientTypeList = new List<SelectOption>();
        clientNameList = new List<SelectOption>();

        relatedTypeList = new List<SelectOption>();
        relatedRecordList = new List<SelectOption>();

        phoneNumber = '';
        selectedId = '';
        warningMsg = false;
        setTaskPickList = true;
        checkResult = false;
        errorMsg = '';

        contactList = new List<Contact>();
        leadList = new List<Lead>();
        accountList = new List<Account>();
        caseList = new List<Case>();
        oppList = new List<Opportunity>();

        taskPriorityList = new List<SelectOption>();
        taskStatusList = new List<SelectOption>();
        leadSourceList = new List<SelectOption>();
        accountPickList = new List<SelectOption>();
    }
    */


    /**
     * 내 작업목록 값 가져오기_BG
     * Task > List View에 아래의 목록 생성 전제
     * 
     * Type: Task
     * List Name: 내 작업목록(임의지정 가능)
     * List API Name: MyTaskListView
     */
    /*
     public void getMyTaskListView(){
        MyTaskListView = new ListView();

        MyTaskListView = [SELECT Id, Name, DeveloperName, SobjectType FROM ListView WHERE SobjectType = 'Task' AND DeveloperName = 'MyTaskListView' LIMIT 1];
        System.debug('MyTaskListView: ' + MyTaskListView);
    }
    */




    public String findObjectNameFromId(String recordIdOrPrefix){
        String objectName = '';
        //Get prefix from record ID
        //This assumes that you have passed at least 3 characters
        String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
        
        //Get schema information
        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
        
        //Loop through all the sObject types returned by Schema
        for(Schema.SObjectType stype : gd.values()){
            Schema.DescribeSObjectResult r = stype.getDescribe();
            String prefix = r.getKeyPrefix();
            //System.debug('Prefix is ' + prefix);
            
            //Check if the prefix matches with requested prefix
            if(prefix!=null && prefix.equals(myIdPrefix)){
                objectName = r.getName();
                //System.debug('Object Name! ' + objectName);
                break;
            }
        }
        return objectName;
    }


}