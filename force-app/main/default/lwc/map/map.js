import { LightningElement, api, wire } from 'lwc';
import getShelter from '@salesforce/apex/mapController.getShelter'

export default class Map extends LightningElement {
    @api recordId;
    mapMarkers = [];

    @wire(getShelter, {shelterId : '$recordId'})
    wiredMap({ error, data }) {
        console.log(this.recordId);
        if(data) {
            console.log(data);
            this.mapMarkers = [
                {
                    location: {
                        Street: data[0].Street__c,
                        City: data[0].City__c,
                        Country: data[0].Country__c,
                        PostalCode: data[0].PostalCode__c
                    },
                    title: data[0].Name,
                    description:
                        data[0].City__c + ', ul.' + data[0].Street__c + '. Kod pocztowy: ' + data[0].PostalCode__c,
                },
            ];
        }
        else if(error) {
            console.error(error);
        }
    }
    selectedMarkerValue = 'SF1';
    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;
    }
}