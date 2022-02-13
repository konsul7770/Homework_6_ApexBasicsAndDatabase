public class ContactsCustomIterable implements Iterator<Contact> {
    List<Contact> contacts {get; set;}
    Integer i {get; set;}

    public ContactsCustomIterable() {
        contacts = [
            SELECT Id, MailingCity, MailingCountry, MailingLatitude, 
                MailingLongitude, MailingPostalCode, MailingState, MailingStreet,
                AccountId, Account.Updated_By_Contact__c, Account.BillingCity,
                Account.BillingCountry, Account.BillingLatitude, Account.BillingLongitude,
                Account.BillingPostalCode, Account.BillingState, Account.BillingStreet
            FROM Contact
            WHERE Is_Synced__c = false
        ];
        i = 0;
    }
    public Boolean hasNext() {
        if (i >= contacts.size()) {
            return false;
        } else {
            return true;
        }
    }
    public Contact next() {
        if (i == 200) {
            return null;
        }
        i++;
        return contacts[i-1];
    }
}