/**
 * Created by user on 2022-07-08.
 */
import { LightningElement, api } from 'lwc';
import getLookupRecord from '@salesforce/apex/SRC_LookupTest.getLookupRecord';
export default class LookupTest extends LightningElement {
    @api name;
    @api variant = "label-hidden";
    @api fieldLabel;
    @api childObjectApiName;
    @api targetFieldApiName;
    @api value;
    @api required = false;
    @api addToRecent = false;
    handleChange(event) {
        let selectedEvent = new CustomEvent('valueselected', {detail: event.detail.value[0]});
        this.dispatchEvent(selectedEvent);
        if (this.addToRecent) {
            if (event.detail.value.length > 0 && event.detail.value[0].length > 0) {
                addToRecentItems({
                    recordId: event.detail.value[0]
                })
                    .catch(error => {
                        console.log(error);
                    });
            }
        }
    }
    @api reportValidity() {
        if(this.required) {
            this.template.querySelector('lightning-input-field').reportValidity();
        }
    }
}