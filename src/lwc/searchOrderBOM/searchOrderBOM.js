import { LightningElement,track, wire } from 'lwc';
import searchOrder from '@salesforce/apex/SRC_SearchOrder.retriveOrder';//수주제품
import searchSRO from '@salesforce/apex/SRC_SearchOrder.retriveSRO';//수주

import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns1 = [//수주
    { label: '수주번호', fieldName: 'Name'}, 
    { label: '품명',fieldName: 'SRF_Product__c'}, 
    { label: '품번', fieldName: 'SRF_ProductCode__c'}, 
    { label: '품목내부코드', fieldName: 'SRF_BOMUnderCode__c', type: 'text'},
    { label: '수취인명', fieldName: 'SRF_ReceiverName__c', type: 'text'},
    { label: '수취인전화번호', fieldName: 'SRF_ReceiverPhone1__c', type: 'text'},
    { label: '수취인주소', fieldName: 'SRF_ReceiverAddress__c', type: 'text'},
    { label: '수주마스터코드', fieldName: 'SRF_MasterCode__c', type: 'text', editable: true},
    { label: '수주디테일코드', fieldName: 'SRF_Orderdetail__c', type: 'text', editable: true}
];

const columns = [//수주제품
    { label: '요청수량', fieldName: 'SRF_OrderCount__c', editable: true}, 
    { label: '수주참조',fieldName: 'SRF_OrderNo__c'}, 
    { label: '자재코드', fieldName: 'SRF_ItemCode__c'}, 
    { label: '품명', fieldName: 'SRF_ItemName__c', type: 'text'},//자재명
    { label: '자재번호', fieldName: 'SRF_ItemNo__c', type: 'text'},
    { label: '수주마스터코드', fieldName: 'SRF_OrderMaster__c', type: 'text'},
    { label: '수주디테일코드', fieldName: 'SRF_OrderDetail__c', type: 'text'}
];

export default class DynamicSearchInLWC extends LightningElement {

    @track searchData;
    @track searchSdata;
    columns = columns;//수주제품
    columns1 = columns1;//수주
    errorMsg = '';
    strSearchOrderNo = '';
    @track draftValues = [];

    handleOrderNo(event) {
        this.errorMsg = '';
        this.strSearchOrderNo = event.currentTarget.value;
    }

    handleSearch() {
        if(!this.strSearchOrderNo) {
            this.errorMsg = '수주번호를 다시 입력하십시오.';
            this.searchData = undefined;
            return;
        }

        searchOrder({orderNo : this.strSearchOrderNo})
        .then(result => {
            this.searchData = result;
        })
        .catch(error => {
            this.searchData = undefined;
            if(error) {
                if (Array.isArray(error.body)) {
                    this.errorMsg = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    this.errorMsg = error.body.message;
                }
            }
        }) 

        searchSRO({orderNo : this.strSearchOrderNo})
        .then(result => {
            this.searchSdata = result;
        })
        .catch(error => {
            this.searchSdata = undefined;
            if(error) {
                if (Array.isArray(error.body)) {
                    this.errorMsg = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    this.errorMsg = error.body.message;
                }
            }
        }) 

    }
    handleSave(event) {
        const recordInputs =  event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
   
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
       
        Promise.all(promises).then(res => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records Updated Successfully!!',
                    variant: 'success'
                })
            );
             // Clear all draft values
             this.draftValues = [];
             return this.refresh();
             // Display fresh data in the datatable
             //return refreshApex(this.searchData);
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An Error Occured!!',
                    variant: 'error'
                })
            );
        }).finally(() => {
            this.draftValues = [];
        });
    }
    async refresh(){
        await refreshApex(this.searchData);
        await refreshApex(this.searchSdata);
    }
}