import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import CASE_OBJECT from '@salesforce/schema/Case';
import AS_MASTER_NUM from '@salesforce/schema/Case.SRF_ASSeq__c';
import AS_ORDER_NUM from '@salesforce/schema/Case.SRF_ASReqNo__c';
import SROID_FIELD from '@salesforce/schema/Case.SRF_OrderNo__c';

import AS_DATE from '@salesforce/schema/Case.SRF_ASReqDate__c';
import AS_CLAIMTYPE from '@salesforce/schema/Case.SRF_UMTroubleType__c';
import AS_BOM_TYPE from '@salesforce/schema/Case.SRF_UMItemType__c';
import AS_IS_FREE from '@salesforce/schema/Case.SRF_UMChargeType__c';
export default class CreateASCustomLookupLwc extends NavigationMixin(LightningElement) {    
    
    @track receveName;//수취인명
    @track recevePhone;//수취인번호
    @track receveAdress;//수취인주소
    @track selectedOrderNum; //수주번호 recordId
    @track caseId;
    
    receveName = '';
    recevePhone = '';
    receveAdress = '';
    master_num = '';
    order_num = ''; //접수번호
    as_order_num = '';

    as_date='';
    claimtype='';
    bom_type='';
    is_free='';
    handleChange(event) {//값입력
        console.log('label>>>'+event.target.label);
        console.log('value>>>'+event.target.value);   
        if(event.target.label=='AS접수마스터코드'){
            this.master_num = event.target.value;
        } 
        if(event.target.label=='AS접수번호'){
            this.as_order_num = event.target.value;
        }
        if(event.target.label=='AS접수일'){
            this.as_date = event.target.value;
        }      
        if(event.target.label=='클래임분류'){
            this.claimtype = event.target.value;
        }           
        if(event.target.label=='제품분류'){
            this.bom_type = event.target.value;
        }
        if(event.target.label=='유무상'){
            this.is_free = event.target.value;
        }            
    }
    createContact(){
        console.log('ordernum>>>>'+this.selectedOrderNum);
        const fields = {};
        fields[CASE_OBJECT.fieldApiName] = this.AS_Id;
        fields[AS_MASTER_NUM.fieldApiName] = this.master_num;
        fields[AS_ORDER_NUM.fieldApiName] = this.as_order_num;
        fields[SROID_FIELD.fieldApiName] = this.selectedOrderNum;

        fields[AS_DATE.fieldApiName] = this.as_date;
        fields[AS_CLAIMTYPE.fieldApiName] = this.claimtype;
        fields[AS_BOM_TYPE.fieldApiName] = this.bom_type;
        fields[AS_IS_FREE.fieldApiName] = this.is_free;
        console.log('free>>'+this.is_free);
        const recordInput = { 'apiName': CASE_OBJECT.objectApiName, 'fields':fields };
        createRecord(recordInput)
            .then(response => {
                this.caseId = response.id;
                console.log('AS 생성 Id:', this.caseId);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'AS created',
                        variant: 'success',
                    }),
                );
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: response.id,
                        objectApiName: 'Case',
                        actionName: 'view'
                    },
                });

            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
    handleSelected(event){
        console.log('이건 뭐냐>>>'+event.detail);
        this.selectedOrderNum = event.detail.Id; //수주와 LOOKUP
        
        this.receveName = event.detail.recName;
        this.recevePhone = event.detail.recPhone;
        this.receveAdress = event.detail.recAdress;
    }

}