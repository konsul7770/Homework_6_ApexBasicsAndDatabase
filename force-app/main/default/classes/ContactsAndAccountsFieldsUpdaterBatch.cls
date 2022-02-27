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
                Account accont = new Account();
                accont.Id = cont.AccountId;
                accont.Updated_By_Contact__c = true;
                accountsToUpdate.add(accont);
            }
        }
        Map<Id,Account> acccountsMap = new Map<Id,Account>();
        acccountsMap.putAll(accountsToUpdate);

        update contactsToUpdate;
        update acccountsMap.values();

    }
    public void finish(Database.BatchableContext bc) {

    }
}
