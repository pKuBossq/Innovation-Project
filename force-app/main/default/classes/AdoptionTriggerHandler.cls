public with sharing class AdoptionTriggerHandler {
    public static void handleAfterInsert(List<Adoption__c> newList) {
        FreeFoodService.calculateFreeFoodPoints(newList);
    }

    public static void handleAfterUpdate(Map<Id, Adoption__c> oldMap, List<Adoption__c> newList) {
        EmailService.sendAdoptionStatusChangeEmails(oldMap, newList);
    }
}
