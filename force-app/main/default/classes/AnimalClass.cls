public class AnimalClass {
    @AuraEnabled
    public static List<Animal__c> getAnimals(String breedFilter, String ageFilter, String sexFilter, String shelterFilter) 
    {
        String query = 'SELECT Id, Name, Age__c, Breed__c, Photo__c, Sex__c, Shelter__r.Name FROM Animal__c';
        List<String> filters = new List<String>();

        if (!String.isBlank(breedFilter)) 
        {
            filters.add('Breed__c = :breedFilter');
        }

        if (!String.isBlank(ageFilter)) 
        {
            String ageCondition;
            if (ageFilter == 'do 5 lat') 
            {
                ageCondition = 'Age__c <= 5';
            } 
            else if (ageFilter == 'do 10 lat') 
            {
                ageCondition = 'Age__c <= 10';
            } 
            else 
            {
                ageCondition = 'Age__c > 10';
            }
            filters.add(ageCondition);
        }

        if (!String.isBlank(sexFilter)) 
        {
            filters.add('Sex__c = :sexFilter');
        }

        if (!String.isBlank(shelterFilter)) 
        {
            filters.add('Shelter__r.Name = :shelterFilter');
        }

        if (!filters.isEmpty()) 
        {
            query += ' WHERE ' + String.join(filters, ' AND ');
        }
        return Database.query(query);
    }

    @AuraEnabled
    public static List<String> getBreeds() 
    {
        Set<String> breedSet = new Set<String>();
        for (Animal__c animal : [SELECT Breed__c FROM Animal__c]) 
        {
            if (!String.isBlank(animal.Breed__c)) 
            {
                breedSet.add(animal.Breed__c);
            }
        }
        return new List<String>(breedSet);
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getShelters() {
        List<Map<String, String>> shelters = new List<Map<String, String>>();
        Set<Id> shelterIds = new Set<Id>();
        
        for (Animal__c animal : [SELECT Shelter__c FROM Animal__c WHERE Shelter__c != NULL]) 
        {
            shelterIds.add(animal.Shelter__c);
        }
        
        for (Shelter__c shelter : [SELECT Id, Name FROM Shelter__c WHERE Id IN :shelterIds]) 
        {
            shelters.add(new Map<String, String>{
                'label' => shelter.Name,
                'value' => shelter.Name
            });
        }
        
        return shelters;
    }
}