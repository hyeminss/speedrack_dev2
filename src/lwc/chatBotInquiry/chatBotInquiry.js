import { LightningElement, track } from 'lwc';

export default class ChatBotInquiry extends LightningElement {
    @track name;
    @track phone;
    @track email;
    @track description;

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
}