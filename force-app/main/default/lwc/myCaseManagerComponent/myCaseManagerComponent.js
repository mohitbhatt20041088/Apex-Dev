import getMyOpenCases from '@salesforce/apex/CaseManagmentHandler.getMyOpenCases';
import updateCaseAction from '@salesforce/apex/CaseManagmentHandler.updateCaseAction';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex'
import { LightningElement, wire } from 'lwc';


const action = [
    { label : "Escalate" , name : "escalate"},
    {label : "Close" , name : "close"}
];


const columns = [
    {
        label : "Case Number", 
        fieldName : "CaseNumber", 
        type : "button",
        typeAttributes: {
            label: { fieldName: 'CaseNumber' },
            name: 'view_case',
            variant: 'base'
        }
    },
    {label : "Subject" , fieldName : "Subject" , type : "text"},
    {label : "Status" , fieldName : "Status" , type : "text"},
    {label : "Priority" , fieldName : "Priority" , type : "text"},
    {label : "Date Opened" , fieldName : "CreatedDate", type : "date"},
    {
        type : "action",
        typeAttributes : {rowActions : action},
    },
];

export default class MyCaseManagerComponent extends LightningElement {
    isLoading = true;
    cases = null;
    columns = columns;
    error;
    wiredCaseResult;
    
    isModalOpen = false;
    modalHeaderText = '';
    comment = '';
    caseIdToUpdate = '';
    actionType = '';

    @wire(getMyOpenCases)
    wiredCases(result){
        this.wiredCaseResult = result;
        console.log("result" , result);
        this.isLoading = false;

        if(result.data){
            this.cases = result.data;
            this.error = undefined;
        }else if(result.error){
            this.error = result.error;
            this.cases = undefined;
        }
    }

    get noCasesFound(){
        return !this.isLoading && (!this.cases || this.cases.length === 0);
    }

    handleRowAction(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.caseIdToUpdate = row.Id;

        if(actionName === "view_case")
        {
            // Navigate to case record page
            window.open(`/lightning/r/Case/${row.Id}/view`, '_blank');
        }
        else if(actionName === "escalate")
        {
            this.actionType = "Escalate";
            this.modalHeaderText = `Escalate Case: ${row.CaseNumber}`;
            this.isModalOpen = true;
        }else if(actionName === "close")
        {
            this.actionType = "Close";
            this.modalHeaderText = `Close Case: ${row.CaseNumber}`;
            this.isModalOpen = true;
        }
    }


    closeModal(){
        this.isModalOpen = false;
        this.comment = '';
    }

    handleCommentChange(event)
    {
        this.comment = event.target.value;
    }

    submitAction(){
        this.isLoading = true;
        updateCaseAction({
            caseId : this.caseIdToUpdate,
            actionType : this.actionType,
            comment : this.comment
        })
        .then(result =>{
            this.showToast('Success', result || 'Case Updated','success');
            this.closeModal();
            return refreshApex(this.wiredCaseResult);
        })
        .catch(error=>{
            console.error('Error updating case:', error);
            this.showToast('Error', error.body?.message || error.message || 'An error occurred','error');
        })
        .finally(() => {
            this.isLoading = false;
        });
    }


    showToast(title,message,variant){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        })
        this.dispatchEvent(event);
    }

}