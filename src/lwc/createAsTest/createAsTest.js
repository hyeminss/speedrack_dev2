/**
 * Created by user on 2022-07-07.
 */

import {LightningElement, track} from 'lwc';
import getOrderNo from '@salesforce/apex/searchOrderNoTest.getOrderNo';

export default class CreateAsTest extends LightningElement {

    @track sroName;
    @track orderInfo;



    handleChange(event){
        this.orderNo = event.target.value;
    }

    handleEnter(event){
        console.log('ENTER');
        if(event.target.value !== null){
            getOrderNo(this.orderNo)
                .then(result => {
                    this.orderInfo = result;
                    console.log(result);
                })
                .catch(error => {
                   console.log(error);
                });
        }
    }
}