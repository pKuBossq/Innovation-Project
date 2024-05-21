trigger CountNumberOfAdoptions on Adoption__c (after update) {

    List<Shelter__c> shelters = new List<Shelter__c>();
    List<Adoption__c> adoptions = [SELECT Status__c, Animal__r.Shelter__r.Number_Of_Adoptions__c FROM Adoption__c WHERE Id IN :Trigger.new];

    for (Adoption__c a : adoptions) {
        if (a.Status__c == 'Approved' && a.Status__c != Trigger.oldMap.get(a.Id).Status__c) {
            if (a.Animal__r.Shelter__r != null) {
                a.Animal__r.Shelter__r.Number_Of_Adoptions__c++;
                shelters.add(a.Animal__r.Shelter__r);
            }
        }
    }

    update shelters;

}