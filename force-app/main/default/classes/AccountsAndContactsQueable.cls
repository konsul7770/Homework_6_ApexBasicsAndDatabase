public class AccountsAndContactsQueable implements Queueable {
    public void execute (QueueableContext context){
        List<Account> accounts = [
            SELECT Id, Name, BillingCity, BillingCountry, BillingLatitude, BillingLongitude, BillingPostalCode, BillingState, BillingStreet
            FROM Account
            LIMIT 150
        ];
        Set<Id> accountIds = new Set<Id>();
        for (Account accont : accounts) {
            if (accont.BillingCity != null || accont.BillingCountry != null ||
            accont.BillingLatitude != null || accont.BillingLongitude != null ||
            accont.BillingPostalCode != null || accont.BillingState != null ||
            accont.BillingStreet != null) {
                accountIds.add(accont.Id);
            }
        }
        List<Contact> contactsToUpdate = [
            SELECT Id, LastName, Is_Synced__c, Processed_By_Queue__c
            FROM Contact
            WHERE AccountId IN :accountIds
        ];
        for (Contact cont : contactsToUpdate) {
            cont.Is_Synced__c = false;
            cont.Processed_By_Queue__c = true;
        }
        try {
            update contactsToUpdate;
        } catch (DMLException e) {
            System.debug(e.getMessage());
        }
    } 
}
