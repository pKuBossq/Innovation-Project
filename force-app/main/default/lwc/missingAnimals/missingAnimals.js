import { LightningElement, api, wire } from 'lwc';
import getAllAnimalPhotos from '@salesforce/apex/MissingAnimals.getAllAnimalPhotos';

export default class GetDayDelta extends LightningElement {
  amount = 1;
  mapaData = new Map();
  mappedData = [];

  handleAmountChange(e) {
    this.amount = parseInt(e.detail.value, 10);
    console.log(this.amount);
  }

  @wire(getAllAnimalPhotos, { day: '$amount' })
  wiredAnimals({ error, data }) {
    if (data) {
      const parsedData = JSON.parse(JSON.stringify(data));
      this.mapaData = new Map(Object.entries(parsedData));
      console.log(this.mapaData);
      this.mappedData = Array.from(this.mapaData, ([key, value]) => ({ key, value }));
    } else if (error) {
      console.error('Error:', error);
    }
  }
}
