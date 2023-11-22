import { LightningElement } from 'lwc';
import gamerule1 from '@salesforce/label/c.gamerule1';
import gamerule2 from '@salesforce/label/c.gamerule2';
import gamerule3 from '@salesforce/label/c.gamerule3';
import gamerule4 from '@salesforce/label/c.gamerule4';
import gamerule5 from '@salesforce/label/c.gamerule5';

export default class GameRules extends LightningElement {

    label = {
        gamerule1,gamerule2,gamerule3,gamerule4,gamerule5
    };
}