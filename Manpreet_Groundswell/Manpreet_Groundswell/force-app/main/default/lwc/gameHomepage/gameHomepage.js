import { LightningElement,api ,track} from 'lwc';
import sendGameInvite from '@salesforce/apex/WhatsAppMessageService.sendMessage';
import getPhoneNo from '@salesforce/apex/QuizController.getLeadPhone';
import gameInvite from '@salesforce/label/c.gameInvite';
import getGameId from '@salesforce/apex/WhatsAppMessageService.getResponsefromWhatsapp';

export default class GameHomepage extends LightningElement {


error;
quizSession;
quizSettings;
questionPhase;
@track clickedButtonLabel = 'Show Participants';  
@track gamerule =true;
phone;
@track invitesent = false;
@track showParticiapants =false;
@track questionPhase =false;
@track showQuizWinner =false;
@track questionCounter = 1;

label = {
    gameInvite
};
handleResetClick() {
    // eslint-disable-next-line no-alert
    if (window.confirm('Delete game data (players and answers)?')) {
        resetGame().then(() => {
            window.location.reload();
        });
    }
}

handleNextPhaseClick(event) {
    const label = event.target.label; 
    if ( label === 'Show Participants' ) {  
        this.gamerule = false;
        this.showParticiapants = true;
        this.sendGameInvite();
    } 
    if(this.invitesent && label === 'Start Game'){ // to be udpated as when isparticipant is true on contact
        this.questionPhase = true;
        this.gamerule = false;
        this.showParticiapants = false;
        this.clickedButtonLabel = 'Next';
         
    } 
    if(this.questionPhase && label === 'Next'){
        console.log('########questionCounter' ,this.questionCounter);
        this.template.querySelector('c-quiz-Questions').handleQueCounter(this.questionCounter);
    }
 
    
    if(this.questionCounter==5){
        this.questionPhase = false;
        this.gamerule = false;
        this.showParticiapants = false;
        this.showQuizWinner = true;
        this.clickedButtonLabel = 'Results';
    }   
}

sendGameInvite(){
    sendGameInvite({ mobileno: this.phone,  message: gameInvite})
    .then(result => {
        this.invitesent = true;
        this.clickedButtonLabel = 'Start Game';  
        this.error = undefined;

        if(this.invitesent){
           // window.setTimeout((this.getGameId),
           // 10000)
                }
    })
    .catch(error => {
        this.error = error;
        this.invitesent = undefined;
    })
}

connectedCallback(){
    getPhoneNo()
        .then(result => {
            this.phone = result;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.phone = undefined;
        });
   }  
   
   getGameId(){
    getGameId()
    .then(result => {
        this.showParticiapants = true;
        this.error = undefined;
    })
    .catch(error => {
        this.error = error;
        this.showParticiapants = undefined;
    })
}

handlesendQueCounter(event){
    console.log('eventfromparent',event.detail);
    this.questionCounter = event.detail;
    if(this.questionCounter==5){
        this.questionPhase = false;
        this.gamerule = false;
        this.showParticiapants = false;
        this.showQuizWinner = true;
        this.clickedButtonLabel = 'Results';
    }   
    }
}
