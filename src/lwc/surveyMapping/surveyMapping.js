/**
 * Created by user on 2022-07-04.
 */

import { LightningElement, wire, track, api } from 'lwc';
import surveyCustomerMapping from '@salesforce/apex/SRC_SurveyCustomerController.surveyCustomerMapping';
//@wire(surveyCustomerMapping, {})
export default class SurveyMapping extends LightningElement {



    nameField = '';
    phoneField = '';
    lookupField = '';
    objectName = '';
    error;
    resultText = '';
    nameFieldChange(event) {
        this.nameField = event.target.value;
    }

    phoneFieldChange(event) {
        this.phoneField = event.target.value;
    }

    lookupFieldChange(event) {
        this.lookupField = event.target.value;
    }

    objectNameChange(event) {
        this.objectName = event.target.value;
    }

    mapping() {
//        this.template
//        if(this.nameField.substr(-3, 3) != '__c') {
//            this.resultText = '고객 필드명이 잘 못 되었습니다.';
//        }
//        if(this.phoneField.substr(-3, 3) != '__c') {
//            this.resultText = '휴대폰 필드명이 잘 못 되었습니다.';
//        }
//        if(this.lookupField.substr(-3, 3) != '__c') {
//            this.resultText = '매핑 필드명이 잘 못 되었습니다.';
//        }
//        if(this.objectName.substr(-3, 3) != '__c') {
//            this.resultText = '오브젝트명이 잘 못 되었습니다.';
//        }
        surveyCustomerMapping({ phone : this.phoneField, name : this.nameField, lkId : this.lookupField, obj : this.objectName})
        .then(result=> {
            this.resultText = result;
        }).catch((error) => {
            this.error = error;
        });
    }

} // export