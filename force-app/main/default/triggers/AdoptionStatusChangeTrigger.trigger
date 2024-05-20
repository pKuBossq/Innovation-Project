//DELETE ON MERGE!

trigger AdoptionStatusChangeTrigger on Adoption__c (after update) {

    // List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    // for (Adoption__c a : [Select Person__r.Name__c, Person__r.Surname__c,Person__r.Email__c, Status__c, Animal__r.Name from Adoption__c Where Id IN : Trigger.new]) {
    //     if (Trigger.oldMap.get(a.Id).Status__c != a.Status__c) {
    //         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //         String[] email = new String[] {a.Person__r.Email__c};
    //         String firstName = a.Person__r.Name__c;
    //         String lastName = a.Person__r.Surname__c;
    //         String animalName = a.Animal__r.Name;
    //         String status = a.Status__c;
    //         String message = 'Good Morning ' + firstName + ' ' + lastName + '.\nStatus of adoption for your animal ' + animalName + ' has changed to ' + status;
    //         mail.setToAddresses(email);
    //         mail.setSubject('Change of adoption status');
    //         mail.setPlainTextBody(message);
    //         mails.add(mail);
    //     }
    // }
    // Messaging.sendEmail(mails);
}