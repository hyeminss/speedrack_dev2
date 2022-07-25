/**
 * Created by user on 2022-07-04.
 */

    import { LightningElement, track, api, wire } from 'lwc';
    //import { updateRecord } from 'lightning/uiRecordApi';
    import { refreshApex } from '@salesforce/apex';
    import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

    import { getSObjectValue } from '@salesforce/apex';
    //import getAccounts from '@salesforce/apex/AS_Process_New.getAccounts';
    import getRecordOne from '@salesforce/apex/AS_Process_New.getRecordOne';
    import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
    import PHONE_FIELD from '@salesforce/schema/Account.Phone';
    import SITE_FIELD from '@salesforce/schema/Account.Site';
    import updateRecord from '@salesforce/apex/AS_Process_New.updateRecord';
    import { ShowToastEvent } from 'lightning/platformShowToastEvent';



    export default class AS_Process_New extends LightningElement {
     @track greetings;
     @track result;
     @api recordId;
     @api objectApiName;
     @track data;
     @track fNumber;
     @track sNumber;
     @track sum;
     @track errors;
     @track AS1;
     @track AS2;
     @track AS3;

     @track keyValue;
     @track keyValue1=[];
     @track keyId;

     accountId;
     accountIndustry;
     accountPhone;
     Site;



/*      searchRecord1(){
          getRecordOne( {keyValue: this.keyValue} )
              .then(result => {
                  this.
              })
              .catch(error => {
                  this.error = error;
              })
          }*/

    inputKey(event){
        //if(event.target.name = "searchRecord"){
            this.keyValue = event.target.value;
        //}
    }
     @wire(getRecordOne,{keyValue:'$keyValue'}) searchRecords({error,data}){
          if(data){
              this.keyValue1 = data;
              this.keyId = data[0].Id;
              //console.log('this.data[0].Id:'+this.data[0].Id);
          }
          else if (error){
             this.keyValue1 = undefined;
          }
      }

/*
    @wire(getAccounts,{accountId: '$recordId'}) accountRlecords({error,data}){
         if(data){
             this.data = data;
         }
         else if (error){
            this.data = undefined;
         }
     }
*/


    handleIndustryChange(event){
        this.accountIndustry = event.target.value;
        console.log( "this.accountIndustry :" + JSON.stringify( this.accountIndustry ))
    }

    handlePhoneChange(event){
        this.accountPhone = event.target.value;
        console.log( "this.accountPhone :" + JSON.stringify( this.accountPhone ))
    }
    handleAddressChange(event){
        this.Site = event.target.value;
        console.log( "this.Site :" + JSON.stringify( this.Site ))
    }
    onUpdateRecord(){
        try {
        updateRecord( {accountId : this.keyId, accountIndustries : this.accountIndustry, accountPhones : this.accountPhone, Site : this.Site} )
        .then( accountDetails => {
            console.log("accountDetails:"+JSON.stringify(accountDetails))
            const event = new ShowToastEvent({
                title: 'Success',
                message: 'Account Updated',
                //message: "Contact Record:" +event.detail.field.LastName.value + " is successfully Updated",
                variant: 'success',
            });
            this.dispatchEvent(event);
        })
        .catch( error => {
            console.error("error"+JSON.stringify(error))
            const evt = new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body.message,
                    variant: 'error',
            });
            this.dispatchEvent(evt);
        })
        } catch (error) {
          console.log("###Error : " + JSON.stringify(error));
        }

    }

         value = [' '];
         get option() {
             return [{ label: '접수여부', value: 'option1' }];
         }
         get selectedValues() {
             return this.value.join(',');
         }
         handleCheckboxChange(e) {
             this.value = e.detail.value;
         }

 }