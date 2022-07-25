/**
 * Created by user on 2022-07-13.
 */

import { LightningElement } from 'lwc';
import { createRecord } from "lightning/uiRecordApi";
import CHATBOTCASE_OBJECT from '@salesforce/schema/SRO_ChatbotCase__c';
import NAME_FIELD from '@salesforce/schema/SRO_ChatbotCase__c.SRF_Name__c';
import EMAIL_FIELD from '@salesforce/schema/SRO_ChatbotCase__c.SRF_Email__c';
import PHONE_FIELD from '@salesforce/schema/SRO_ChatbotCase__c.SRF_Phone__c';

export default class InquiryChatBot extends LightningElement {

    objectApiName = CHATBOTCASE_OBJECT;
    fields = [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD];
    name;
    phone;
    email;
    description;

    inputChange(event){
        if(event.target.name == 'name'){
            this.name = event.target.value;
        }
        if(event.target.phone == 'phone'){
            this.phone = event.target.value;
        }
        if(event.target.email == 'email'){
            this.email = event.target.value;
        }
        if(event.target.description == 'description'){
            this.description = event.target.value;
        }
    }

    handleCreateCase(event){
        var fields = {};
    }
}