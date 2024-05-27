import { LightningElement, wire, api } from 'lwc';
import showHours from '@salesforce/apex/HoursController.showHours';

export default class OpeningHours extends LightningElement {
    @api recordId;
    hour;
    weekendHour;

    @wire(showHours, {shelterId : '$recordId'})
    wiredHours({ error, data }) {
        console.log(this.recordId);
        if (data) {
            console.log(data);
            this.hour = data[0];
            this.weekendHour = data[1];
        } else if (error) {
            console.error(error);
        }
    }
}