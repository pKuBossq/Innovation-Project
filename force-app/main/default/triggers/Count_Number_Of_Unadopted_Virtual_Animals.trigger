trigger Count_Number_Of_Unadopted_Virtual_Animals on Adoption__c (after update, after insert, before delete) {
    
    List<Adoption__c> adoptions;

    if(!trigger.isdelete) 
    {
        adoptions = new List<Adoption__c>([SELECT Status__c, Animal__r.Shelter__c, RecordType.Name FROM Adoption__c WHERE Id IN: Trigger.new]);
    }
    else 
    {
       adoptions = new List<Adoption__c>([SELECT Status__c, Animal__r.Shelter__c, RecordType.Name FROM Adoption__c WHERE Id IN: Trigger.old]);
    }

    List<Id> SheltersId = new List<Id>();

    for(Adoption__c a: adoptions) 
    {
        SheltersId.add(a.Animal__r.Shelter__c);
    }

    List<Shelter__c> Shelter = new List<Shelter__c>([SELECT Id, Number_Of_Unadopted_Virtual_Animals__c FROM Shelter__c WHERE Id IN: SheltersId]);
    
    for (Adoption__c a : adoptions) 
    {
         if(a.Status__c == 'In progress' && a.RecordType.Name == 'Virtual') 
         {
             for(Shelter__c sh: Shelter) 
             {
                 if(a.Animal__r.Shelter__c == sh.ID && !trigger.isdelete) 
                 {
                     sh.Number_Of_Unadopted_Virtual_Animals__c +=1;
                 }
                 else if(a.Animal__r.Shelter__c == sh.ID && trigger.isdelete)
                 {
                     sh.Number_Of_Unadopted_Virtual_Animals__c -=1;
                 }
             }
         }
         else if(a.Status__c == 'Approved' && a.RecordType.Name == 'Virtual' && trigger.isupdate) 
         {
             for(Shelter__c sh: Shelter) 
             {
                 if(a.Animal__r.Shelter__c == sh.ID) 
                 {
                     sh.Number_Of_Unadopted_Virtual_Animals__c -=1;
                 }
             }
         }
        
    }
    update Shelter;
}