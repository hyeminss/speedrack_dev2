import { LightningElement, track, wire } from 'lwc';
import getCustomLookupSRO from '@salesforce/apex/SRC_SearchOrder.getCustomLookupSRO';
export default class CustomLookupLwc extends LightningElement {

 @track sroName='';
 @track sroList=[];
 @track objectApiName='SRO_Order1__c';
 @track sroId;
 @track isShow=false;
 @track messageResult=false;
 @track isShowResult = true;
 @track showSearchedValues = false;
 @wire(getCustomLookupSRO,{sroNo:'$sroName'})
 retrieveSRO ({error,data}){
     this.messageResult=false;
     if(data){
         console.log('data## ' + data.length);
         if(data.length>0 && this.isShowResult){
            this.sroList =data;
            this.showSearchedValues=true;
            this.messageResult=false;
            console.log('sroList>>'+this.sroList);
         }
         else if(data.length == 0){
            this.sroList=[];
            this.showSearchedValues=false;
            if(this.sroName != ''){
               this.messageResult=true;
            }
         }
         else if(error){
             this.sroId='';
             this.sroName='';
             this.sroList=[];
             this.showSearchedValues=false;
             this.messageResult=true;
         }
     }
 }

handleClick(event){
  this.isShowResult = true;
  this.messageResult = false;
}

handleKeyChange(event){
  this.messageResult=false;
  this.sroName = event.target.value;
}

handleParentSelection(event){        
    
    this.showSearchedValues = false;
    this.isShowResult = false;
    this.messageResult=false;
    //값 저장
    this.sroId =  event.target.dataset.value;
    this.sroName =  event.target.dataset.label;  
    this.receiveName = event.target.dataset.rname;
    this.receivePhone = event.target.dataset.rphone;
    this.receiveAdress = event.target.dataset.radress;

    console.log('sroName::'+this.sroName);     
    console.log('sroId::'+this.sroId);   
    console.log('receiveName::'+this.receiveName);   
    console.log('receivePhone::'+this.receivePhone);  
    console.log('receiveAdress::'+this.receiveAdress);    
    var temp = {Id : this.sroId, Name : this.sroName, recName : this.receiveName, recPhone : this.receivePhone, recAdress : this.receiveAdress};
    const selectedEvent = new CustomEvent('selected', { detail: temp }); //담아!
        // Dispatches the event.
    this.dispatchEvent(selectedEvent);    
}
handleOpenModal(event){
    this.isshow = true;
    console.log('balaji:::');
}

handleReset(event) {
    const inputFields = this.template.querySelectorAll(
        'lightning-input-field'
    );
    if (inputFields) {
        inputFields.forEach(field => {
            field.reset();
        });
    }
     this.isshow = false;
}



}