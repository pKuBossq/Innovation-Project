public with sharing class ShelterCountService {
    public static void updateShelterCount(List<Adoption__c> adoptions, Boolean isDelete) {
        Map<Id, Shelter__c> shelterMap = new Map<Id, Shelter__c>();

        for (Adoption__c a : adoptions) {
            if (a.Animal__r.Shelter__r != null) {
                Id shelterId = a.Animal__r.Shelter__r.Id;
                if(shelterMap.containsKey(shelterId)) {
                    if(a.Status__c == 'In progress' && a.RecordType.Name == 'Virtual') {
                        if(isDelete) {
                            shelterMap.get(shelterId).Number_Of_Unadopted_Virtual_Animals__c--;
                        } else {
                            shelterMap.get(shelterId).Number_Of_Unadopted_Virtual_Animals__c++;
                        }
                    } else if(a.Status__c == 'Approved' && a.RecordType.Name == 'Virtual') {
                        if(!isDelete) {
                            shelterMap.get(shelterId).Number_Of_Unadopted_Virtual_Animals__c--;
                        }
                    }
                } else {
                    Shelter__c shelter = a.Animal__r.Shelter__r;
                    if(a.Status__c == 'In progress' && a.RecordType.Name == 'Virtual') {
                        if(isDelete) {
                            shelter.Number_Of_Unadopted_Virtual_Animals__c--;
                        } else {
                            shelter.Number_Of_Unadopted_Virtual_Animals__c++;
                        }
                    } else if(a.Status__c == 'Approved' && a.RecordType.Name == 'Virtual') {
                        if(!isDelete) {
                            shelter.Number_Of_Unadopted_Virtual_Animals__c--;
                        }
                    }
                    shelterMap.put(shelterId, shelter);
                }
            }
        }

        if (!shelterMap.isEmpty()) {
            update shelterMap.values();
        }
    }
}
