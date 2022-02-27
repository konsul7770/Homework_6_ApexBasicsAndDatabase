public class ContactsQueryLocatorBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, MailingCity, MailingCountry, MailingLatitude, '+
            'MailingLongitude, MailingPostalCode, MailingState, MailingStreet, '+
            'AccountId, Account.Updated_By_Contact__c, Account.BillingCity, '+
            'Account.BillingCountry, Account.BillingLatitude, Account.BillingLongitude, '+
            'Account.BillingPostalCode, Account.BillingState, Account.BillingStreet '+
        'FROM Contact '+
        'WHERE Is_Synced__c = false'
        );
    }
    public void execute(Database.BatchableContext bc,List<SObject> scope) {
        List<Contact> contactsToUpdate = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();
        for (SObject s : scope) {
            Contact cont = (Contact)s;
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
        Map<Id,Account> accountsMap = new Map<Id,Account>();
        accountsMap.putAll(accountsToUpdate);

        update contactsToUpdate;
        update accountsMap.values();
    }
    public void finish(Database.BatchableContext bc) {
        
    }
}
