import { api, LightningElement, track, wire } from 'lwc';
import getCaseRelatedInquiry from '@salesforce/apex/SRC_GetInquiry.getCaseRelatedInquiry';
export default class GetInquiry extends LightningElement {
    @api recordId;
    @track contact;
    @track columns = [
        {label :'고객문의번호', fieldName :'nameUrl', type: 'url',
        typeAttributes: {label: { fieldName: 'Name' }, target: '_parent'},sortable: true},
        {label :'문의타입', fieldName :'SRF_InqType__c'},
        {label : '문의제목', fieldName : 'SRF_InqTitle__c'},
        {label : '거래처', fieldName : 'SRF_ShopName__c'},
        {label : '문의시간', fieldName : 'SRF_InqTime__c'}
    ];

    @track error;
    @track inquirys = [];

    @wire(getCaseRelatedInquiry,{contactId:'$recordId'})
    ContactRecords(result){
        const {data, error} =result;
        if(data){
            let nameUrl;
            this.inquirys = data.map(row => {
                nameUrl = `/${row.Id}`;
                return {...row , nameUrl} 
            })
            this.error = null;
            
        }
        else{
            this.error=error;
            this.inquirys=undefined;
        }
    }
}