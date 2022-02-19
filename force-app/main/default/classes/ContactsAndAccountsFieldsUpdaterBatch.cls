public class ContactsAndAccountsFieldsUpdaterBatch implements Database.Batchable<Contact> {
    public Iterable<Contact> start(Database.BatchableContext bc) {
        return new ContactsIterator();
    }
    public void execute (Database.BatchableContext bc, List<Contact> scope) {
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();
        for (Contact cont : scope) {
            cont.Is_Synced__c = true;
            cont.MailingCity = cont.Account.BillingCity;
            cont.MailingCountry = cont.Account.BillingCountry;
            cont.MailingLatitude = cont.Account.BillingLatitude;
            cont.MailingLongitude = cont.Account.BillingLongitude;
            cont.MailingPostalCode = cont.Account.BillingPostalCode;
            cont.MailingState = cont.Account.BillingState;
            cont.MailingStreet = cont.Account.BillingStreet;
            contactsToUpdate.add(cont);
            if (cont.AccountId != null) {
                Account accont = new Account(Id = cont.AccountId, Updated_By_Contact__c = true);
                accountsToUpdate.add(accont);
            }
        }
        try {
            update contactsToUpdate;
            update new Map<Id,Account>(accountsToUpdate).values();
        } catch (DMLException e) {
            System.debug(e.getMessage());
        }
    }
    public void finish(Database.BatchableContext bc) {

    }
}
