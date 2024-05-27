public with sharing class HoursController {
    @AuraEnabled(Cacheable=true)
    public static String showHours() {
        List<Shelter__c> shelters = [SELECT Time_Opened__c FROM Shelter__c];
        if (shelters.isEmpty()) {
            return null;
        }
        Shelter__c shelter = shelters[0];
        if (shelter.Time_Opened__c == null) {
            return null;
        }
        return String.valueOf(shelter.Time_Opened__c);
    }
}