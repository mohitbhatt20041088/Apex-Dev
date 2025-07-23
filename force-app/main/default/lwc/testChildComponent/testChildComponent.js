import { api, LightningElement } from 'lwc';

export default class TestChildComponent extends LightningElement {
    @api message = "This is child componenet";

    @api changeMessageHandler() {
        console.log('changeMessageHandler called');
        this.message = "This is child component changed";
        console.log('New message:', this.message);
    }
}