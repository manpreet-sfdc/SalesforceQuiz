import { LightningElement ,track,api} from 'lwc';
import getQuestions from '@salesforce/apex/QuizController.getQuestions';
export default class QuizQuestions extends LightningElement {

    @track questiondata;
    @track questionCounter =0;
    @track totalQue = 5;
    @api counter;

   getQuestions(){
        getQuestions({offset:this.questionCounter})
        .then(result => {
            this.questiondata = result;
            this.error = undefined;
            console.log('#######this.questionCounter' ,this.questionCounter);
            console.log('#######this.questiondata' ,JSON.stringify(this.questiondata));
            if(this.questionCounter==this.totalQue){
                this.handleChange();

            }
        })
        .catch(error => {
            this.error = error;
            this.questiondata = undefined;
        })
    }

    connectedCallback(){
    this.getQuestions({offset:this.questionCounter});
    }
    @api handleQueCounter({counter}){
        counter = this.questionCounter++;
        this.getQuestions({offset:this.counter});
    }

    handleChange() {
        console.log('@@detail event');
        const storeEvent  = new CustomEvent('sendquecounter',
         { 
            detail: this.questionCounter
        });
            console.log('@@detail',JSON.stringify(storeEvent));
        this.dispatchEvent(storeEvent);
        }
}