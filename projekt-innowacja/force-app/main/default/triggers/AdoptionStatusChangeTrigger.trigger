trigger AdoptionStatusChangeTrigger on Adoption__c (after update) {
    for (Adoption__c adoption : Trigger.new) {
        if (Trigger.oldMap.get(adoption.Id).Status__c != adoption.Status__c) {
            Id contactId = adoption.Contact__c;
            Contact relatedContact = [SELECT Email, FirstName, LastName FROM Contact WHERE Id = :contactId];
            String email = relatedContact.Email;
            String firstName = relatedContact.FirstName;
            String lastName = relatedContact.LastName;
            Id animalId = adoption.Animal__c;
            Animal__c relatedAnimal = [SELECT Name FROM Animal__c WHERE Id = :animalId];
            String animalName = relatedAnimal.Name;
            String message = 'Good Morning ' + firstName + ' ' + lastName + '. Status of adoption for your animal ' + animalName + ' has changed to ' + adoption.Status__c;
            EmailManager.sendMail(email, 'Adoption status changed', message);
        }
    }
}