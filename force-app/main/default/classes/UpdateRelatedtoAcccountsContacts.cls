public class UpdateRelatedtoAcccountsContacts implements Queueable{
    private Set<Id> accountIds;
    public UpdateRelatedtoAcccountsContacts(Set<Id> accountIds) {
        this.accountIds = accountIds;
    }
    public void execute(QueueableContext context) {
        List<Contact> relatedContacts = [
            SELECT Id, accountId, Is_Synced__c, Processed_By_Future__c 
            FROM Contact 
            WHERE AccountId IN :accountIds];
        for (Contact cont : relatedContacts) {
            cont.Is_Synced__c = false;
            cont.Processed_By_Queue__c = true;
        }

        update relatedContacts;

    }
}
