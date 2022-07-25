global with sharing class CtiLoginPageController {
    

    public String txtUserID{get;set;}
    public String extension{get;set;}



    public User user{get;set;}
    public String savedUserId{get;set;}
    public String savedPassword{get;set;}
    public String savedExtension {get;set;}

    public Boolean checkLogin{get;set;}
    public String errorMsg{get;set;}
    
    public CtiLoginPageController(){
        user = [SELECT Id, Phone, MobilePhone, Extension, CTI_ID__c FROM User WHERE Id =: Userinfo.getUserId()];
        checkLogin = false;
        errorMsg = '';
        System.debug('user : '+ user);
    }

    public void userSetting(){

        System.debug('CtiLoginPageController');
        System.debug('userSetting() 실행');
        
        
    }

    public PageReference redirect() { 
        String id = ApexPages.currentPage().getParameters().get('recordId');

        System.debug('redirect : ' + id);
        PageReference pgRef = new PageReference('/console#%2F' + id);
        
        pgRef.setRedirect(true);

        return pgRef; 
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////
    // ctiLoginPage 용
    public void loginDo(){
        System.debug('txtUserID : ' + txtUserID + ' //// Extension : ' + extension);
        errorMsg = '';
        checkLogin = false;

        if(txtUserID == null || txtUserID ==''){
            errorMsg = '사용자 ID를 입력하세요.';
        
        } else if(extension == null || extension ==''){
            errorMsg = '내선번호를 입력하세요.';

        }else {
            if(user.CTI_ID__c == txtUserID && user.Extension == extension){
                System.debug('user.CTI_ID__c == txtUserID && user.Extension == extension');
                checkLogin = true;
                System.debug('checkLogin = true');
                System.debug('로그인 성공');
                
             } else {
     
                 System.debug('user.CTI_ID__c != txtUserID || user.Extension != extension');
                 checkLogin = false;
                 errorMsg = '올바른 접속정보가 아닙니다.';
                 System.debug('checkLogin = false');
     
             } 
             
        
        }

    }

    public void resetErrorMsg(){
        errorMsg = '';
    }


    public Pagereference moveToSoftphonPage(){
        if(checkLogin){
        PageReference requestPage = new PageReference('/apex/ctiSoftphonePage'); 
       
            
        requestPage.getParameters().put('uId', txtUserID);
        requestPage.getParameters().put('ex', extension);
        requestPage.setRedirect(true);
        return requestPage;
        } else{
            return null;
        }
    }


}