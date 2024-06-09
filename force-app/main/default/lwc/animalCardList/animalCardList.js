import { LightningElement, track } from 'lwc';
import getAnimals from '@salesforce/apex/AnimalClass.getAnimals';
import getBreeds from '@salesforce/apex/AnimalClass.getBreeds';
import getShelters from '@salesforce/apex/AnimalClass.getShelters';

export default class AnimalCardList extends LightningElement 
{
    @track animals;
    @track breeds = [];
    @track ages = [
        { label: 'do 5 lat', value: 'do 5 lat' },
        { label: 'do 10 lat', value: 'do 10 lat' },
        { label: 'powyżej 10 lat', value: 'powyżej 10 lat' }
    ];
    @track sexes = [
        { label: 'Male', value: 'Male' },
        { label: 'Female', value: 'Female' }
    ];
    @track shelters = [];
    @track error;
    @track breedFilter = '';
    @track ageFilter = '';
    @track sexFilter = '';
    @track shelterFilter = '';
    @track isSearchNotAvailable = false;

    connectedCallback() 
    {
        this.loadBreeds();
        this.loadShelters();
        this.loadAnimals();
    }

    handleBreedChange(event) 
    {
        this.breedFilter = event.target.value;
        this.loadAnimals();
    }

    handleAgeChange(event) 
    {
        this.ageFilter = event.target.value;
        this.loadAnimals();
    }

    handleSexChange(event) 
    {
        this.sexFilter = event.target.value;
        this.loadAnimals();
    }

    handleShelterChange(event) 
    {
        this.shelterFilter = event.target.value;
        this.loadAnimals();
    }

    loadAnimals() {
        getAnimals({ breedFilter: this.breedFilter, ageFilter: this.ageFilter, sexFilter: this.sexFilter, shelterFilter: this.shelterFilter })
            .then(result => {
                this.animals = result;
                if (this.animals.length > 0) {
                    this.isSearchNotAvailable = false;
                } else {
                    this.isSearchNotAvailable = true;
                }
            })
            .catch(error => {
                this.isSearchNotAvailable = false;
                this.error = error;
            });
    }

    loadBreeds() {
        getBreeds()
            .then(result => {
                this.breeds = result.map(breed => ({ label: breed, value: breed }));
            })
            .catch(error => {
                this.error = error;
            });
    }

    loadShelters() {
        getShelters()
            .then(result => {
                this.shelters = result;
            })
            .catch(error => {
                this.error = error;
            });
    }
    
    resetFilters() {
        this.breedFilter = '';
        this.ageFilter = '';
        this.sexFilter = '';
        this.shelterFilter = '';
        this.loadAnimals();
    }
}
