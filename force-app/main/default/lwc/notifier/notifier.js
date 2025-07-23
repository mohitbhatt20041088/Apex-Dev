import { LightningElement } from 'lwc';

export default class Notifier extends LightningElement {
    notificationMessage = "";

    handleMessageChange = (event)=>{
        this.notificationMessage = event.target.value;
        console.log(this.notificationMessage);
    }

    handleSuccessClick = ()=>{
        this.template.querySelector('c-toast-display').showNotification(
            'Success',
            this.notificationMessage,
            'success'
        );
    }

    handleErrorClick = ()=>{
        this.template.querySelector('c-toast-display').showNotification(
            'Error',
            this.notificationMessage,
            'error'
        );
    }
}