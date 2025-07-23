import { api, LightningElement } from 'lwc';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class ToastDisplay extends LightningElement {
    @api showNotification = (varTitle,varMessage,varVariant)=>{
        const event = new ShowToastEvent({
            title : varTitle,
            message : varMessage,
            variant : varVariant
        })
        this.dispatchEvent(event);
    }
}