

import getAccounts from '@salesforce/apex/Test.getAccounts';
import { LightningElement, track, wire } from 'lwc';


const columns = [
    {label : 'Account Name' , fieldName : 'Name'},
    {label : 'Account Number',fieldName : 'AccountNumber'},
    {label : 'Annual Revenue',fieldName : 'AnnualRevenue'}
];


export default class TestComponent extends LightningElement {
  @track columns = columns;
    @track data = [];


    
  connectedCallback(){
    getAccounts()
    .then(result=>{
        console.log(result);
        
        this.data = result;
    })
    .catch(error =>{
        console.log(error);
        
    })
  }

}