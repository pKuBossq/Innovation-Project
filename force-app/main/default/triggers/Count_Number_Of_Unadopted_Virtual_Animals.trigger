trigger Count_Number_Of_Unadopted_Virtual_Animals on Adoption__c (after update, after insert, before delete) {
    Map<Id, Shelter__c> shelterMap = new Map<Id, Shelter__c>();    
	List<Adoption__c> adoptions;
    
    if(!trigger.isdelete) 
    {
        adoptions = new List<Adoption__c>([SELECT Status__c, Animal__r.Shelter__r.Id,Animal__r.Shelter__r.Number_Of_Unadopted_Virtual_Animals__c, RecordType.Name FROM Adoption__c WHERE Id IN: Trigger.new]);
    }
    else 
    {
       adoptions = new List<Adoption__c>([SELECT Status__c, Animal__r.Shelter__r.Id,Animal__r.Shelter__r.Number_Of_Unadopted_Virtual_Animals__c, RecordType.Name FROM Adoption__c WHERE Id IN: Trigger.old]);
    }
	
    for (Adoption__c a : adoptions) {
        
        if (a.Animal__r.Shelter__r  != null) 
        {
            Id shelterId = a.Animal__r.Shelter__r.Id;
            if(shelterMap.containsKey(shelterId))
            {
                if(a.Status__c == 'In progress' && a.RecordType.Name == 'Virtual')
                {
                    if(trigger.isDelete)
                    {
                        shelterMap.get(shelterId).Number_Of_Unadopted_Virtual_Animals__c--;
                    }
                    else
                    {
                        shelterMap.get(shelterId).Number_Of_Unadopted_Virtual_Animals__c++;
                    }
                }
                else if(a.Status__c == 'Approved' && a.RecordType.Name == 'Virtual' && trigger.isupdate)
                {
                    shelterMap.get(shelterId).Number_Of_Unadopted_Virtual_Animals__c--;
                }
            }
            else
            {
                Shelter__c shelter = a.Animal__r.Shelter__r;
                if(a.Status__c == 'In progress' && a.RecordType.Name == 'Virtual')
                {
                    if(trigger.isDelete)
                    {
                        shelter.Number_Of_Unadopted_Virtual_Animals__c--;
                    }
                    else
                    {
                        shelter.Number_Of_Unadopted_Virtual_Animals__c++;
                    }
                }
                else if(a.Status__c == 'Approved' && a.RecordType.Name == 'Virtual' && trigger.isupdate)
                {
                    shelter.Number_Of_Unadopted_Virtual_Animals__c--;
                }
                shelterMap.put(shelterId, shelter);
            }
        }
    }

    if (!shelterMap.isEmpty()) {
        update shelterMap.values();
    }
    
}