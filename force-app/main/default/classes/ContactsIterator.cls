public class ContactsIterator implements Iterable<Contact> {
    public Iterator<Contact> Iterator() {
        return new ContactsCustomIterable();
    }
}
