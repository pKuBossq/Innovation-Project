import { LightningElement, api, wire } from 'lwc';
import getShelters from '@salesforce/apex/mapController.getShelters'

export default class Map extends LightningElement {
    @api recordId;
    mapMarkers = [];

    @wire(getShelters, {})
    wiredAccount({ error, data }) {
        if(data) {
            console.log(data);
            this.mapMarkers = [];
            data.forEach((element) => {
                console.log(element.City__c);
                this.mapMarkers.push({location:{City: element.City__c, Country: element.Country__c, PostalCode: element.PostalCode__c, Street: element.Street__c}, title: element.Name})
            });
            console.log(this.mapMarkers);
        }
        else if(error) {
            console.log(error);
        }
    }
    listView = 'visible';
    selectedMarkerValue = 'SF1';
    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;
    }
}