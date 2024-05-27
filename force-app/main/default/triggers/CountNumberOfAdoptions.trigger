trigger CountNumberOfAdoptions on Adoption__c (after update) {

    Map<Id, Shelter__c> shelterMap = new Map<Id, Shelter__c>();
    List<Adoption__c> adoptions = [SELECT Status__c, Animal__r.Shelter__r.Id, Animal__r.Shelter__r.Number_Of_Adoptions__c 
                                   FROM Adoption__c WHERE Id IN :Trigger.new];

    for (Adoption__c a : adoptions) {
        if (a.Status__c == 'Approved' && a.Status__c != Trigger.oldMap.get(a.Id).Status__c) {
            if (a.Animal__r.Shelter__r != null) {
                Id shelterId = a.Animal__r.Shelter__r.Id;
                if (shelterMap.containsKey(shelterId)) {
                    shelterMap.get(shelterId).Number_Of_Adoptions__c++;
                } else {
                    Shelter__c shelter = a.Animal__r.Shelter__r;
                    shelter.Number_Of_Adoptions__c++;
                    shelterMap.put(shelterId, shelter);
                }
            }
        }
    }

    if (!shelterMap.isEmpty()) {
        update shelterMap.values();
    }

}