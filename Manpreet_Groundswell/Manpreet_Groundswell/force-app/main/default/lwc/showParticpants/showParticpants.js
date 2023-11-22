import { LightningElement, track,wire } from 'lwc';
import fetchParticipants from '@salesforce/apex/showParticipantList.getParticipantsList';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
export default class ShowParticpants extends LightningElement {

    @track participants;
    subscription = {};
    CHANNEL_NAME = '/event/UpdateParticipantTable__e';
    data = [];
    error;

fetchParticipants() {
    fetchParticipants()
            .then(result => {
                this.participants = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.participants = undefined;
            });
    }
 

    connectedCallback() {
        this.fetchParticipants();
        subscribe(this.CHANNEL_NAME, -1, this.refreshList).then(response => {
            this.subscription = response;
        });
        onError(error => {
            console.error('Server Error--->'+error);
        });
    }


    refreshList = ()=> {
        this.fetchParticipants();
    }
}