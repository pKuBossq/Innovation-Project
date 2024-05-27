public with sharing class mapController {
    @AuraEnabled(Cacheable = true)
    public static List<Shelter__c> getShelters() {
        return [SELECT Name, Country__c, City__c, PostalCode__c, Street__c FROM Shelter__c];
    }
}