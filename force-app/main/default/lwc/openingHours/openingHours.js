import { LightningElement, wire, api } from 'lwc';
import showHours from '@salesforce/apex/HoursController.showHours';

export default class OpeningHours extends LightningElement {
    @api recordId;
    hour;

    @wire(showHours, {})
    wiredHours({ error, data }) {
        console.log("ID record: " + this.recordId);
        if (data) {
            console.log("data: " + data);
            this.hour = data;
        } else if (error) {
            console.error("Error: " + JSON.stringify(error));
        }
    }
}