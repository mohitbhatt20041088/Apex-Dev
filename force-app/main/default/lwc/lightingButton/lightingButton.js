import { LightningElement , track} from 'lwc';

export default class LightingButton extends LightningElement {
    @track buttonlabel = 'Show';
    @track tableVisible = false;

    handleOnClick = (event)=>{

        const label = event.target.label;

        if(label === 'Show'){
            this.buttonlabel = 'Hide';
            this.tableVisible = true;
        }
        else if(label === 'Hide'){
            this.buttonlabel = 'Show';
            this.tableVisible = false;
        }
    }
}