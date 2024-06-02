trigger AdoptionTrigger on Adoption__c (after insert, after update) {
    if (trigger.isAfter){
        if (trigger.isUpdate){
            AdoptionTriggerHandler.handleAfterUpdate(Trigger.oldMap, Trigger.new);
        }
        if (trigger.isInsert){
            AdoptionTriggerHandler.handleAfterInsert(Trigger.new);
        }
    }

    if (trigger.isBefore && trigger.isDelete) {
        AdoptionTriggerHandler.handleBeforeDelete(Trigger.oldMap);
    }
}
