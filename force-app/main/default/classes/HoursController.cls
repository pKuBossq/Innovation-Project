public with sharing class HoursController {
    @AuraEnabled(Cacheable = true)
    public static List<String> showHours(String shelterId) {
        List<Shelter__c> shelters = [SELECT Time_Opened__c, Time_Opened_On_Weekend__c FROM Shelter__c WHERE Id =: ShelterId];
        List<String> hours = new List<String>();
        if (shelters.isEmpty()) {
            hours.add('Unavaliable');
            hours.add('Unavaliable');
            return hours;
        }
        Shelter__c shelter = shelters[0];
        if (shelter.Time_Opened__c == null || shelter.Time_Opened_On_Weekend__c == null) {
            hours.add('Unavaliable');
            hours.add('Unavaliable');
            return hours;
        }
        hours.add(shelter.Time_Opened__c);
        hours.add(shelter.Time_Opened_On_Weekend__c);
        return hours;
    }
}