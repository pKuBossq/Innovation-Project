public class AdoptionTriggerHandler {

    public static void handleAfterInsert(List<Adoption__c> newList) {
        // Logika dla triggera CalculateFreeFoodPoints
        List<Person__c> people = new List<Person__c>();
        Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SObjectType = 'Adoption__c']);
        
        for(Adoption__c adop : [SELECT RecordType.Name, Person__r.Points__c From Adoption__c where Id IN : newList]) {
            if(adop.RecordTypeId != null) {
                RecordType record = recordTypes.get(adop.RecordTypeId);
                if(record.Name == 'Virtual') {
                    adop.Person__r.Points__c += 10;
                } else if(record.Name == 'Real') {
                    adop.Person__r.Points__c += 20;
                }
                
                if(adop.Person__r.Points__c >= 30) {
                    adop.Person__r.Points__c -= 30;
                    System.debug('Otrzymujesz darmowa karme!');
                }
                
                people.add(adop.Person__r);
            }
        }
        update people;
    }

    public static void handleAfterUpdate(Map<Id, Adoption__c> oldMap, List<Adoption__c> newList) {
        // Logika dla triggera AdoptionStatusChangeTrigger
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Adoption__c a : [Select Person__r.Name__c, Person__r.Surname__c,Person__r.Email__c, Status__c, Animal__r.Name from Adoption__c Where Id IN : newList]) {
            if (oldMap.get(a.Id).Status__c != a.Status__c) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] email = new String[] {a.Person__r.Email__c};
                String message = 'Good Morning ' + a.Person__r.Name__c + ' ' + a.Person__r.Surname__c + '.\nStatus of adoption for your animal ' + a.Animal__r.Name + ' has changed to ' + a.Status__c;
                mail.setToAddresses(email);
                mail.setSubject('Change of adoption status');
                mail.setPlainTextBody(message);
                mails.add(mail);
            }
        }
        Messaging.sendEmail(mails);
    }
}
