@isTest
public class TestDataFactory {
    public static TestAccountFactory ACCOUNT = new TestAccountFactory();
    public static TestContactFactory CONTACT = new TestContactFactory();
    public static TestTaskFactory TASK = new TestTaskFactory();

    public class TestAccountFactory {
        public List<Account> createAccountsList (Integer count, String name, Boolean isInsert) {
            List<Account> accounts = new List<Account>();
            for (Integer i = 0; i < count; i++) {
                Account accont = new Account();
                accont.Name = name + (i+1);
                if (Math.mod(i, 2) == 0) {
                    accont.BillingCity = 'city';
                    accont.BillingCountry = 'country';
                    accont.BillingLatitude = 0;
                    accont.BillingLongitude = 0;
                    accont.BillingPostalCode = '12345';
                    accont.BillingState = 'state';
                    accont.BillingStreet = 'street';
                }
                accounts.add(accont);
            }
            if (isInsert) {
                insert accounts;
            }
            return accounts;
        }
    }
    public class TestContactFactory {
        public List<Contact> createContactsList(Integer count, String lastname,List<Account> accounts,Boolean isInsert){
            List<Contact> contacts = new List<Contact>();
            if (accounts != null) {
                for (Account accont : accounts) {
                    Contact cont = new Contact(LastName = lastname + accont.Name);
                    cont.AccountId = accont.Id;
                    cont.Is_Synced__c = false;
                    contacts.add(cont);
                }
            } else {
                for (Integer i = 0; i < count; i++) {
                    Contact cont = new Contact(LastName = lastname);
                    contacts.add(cont);
                }
            }
            if (isInsert) {
                insert contacts;
            }
            return contacts;
        }
    }
    public class TestTaskFactory{
        public List<Task> createTasksList(List<Account> accounts, Integer count) {
            List<Task> tasks = new List<Task>();
            if (accounts != null) {
                for(Account accont: accounts) {
                    for (Integer i = 0; i < count; i++) {
                        Task tsk = new Task();
                        tsk.Subject = 'Test task ';
                        tsk.Priority = 'Normal';
                        tsk.Status = 'Open';
                        tsk.WhatId = accont.Id;
                        tasks.add(tsk);
                    }
                }
            }
            insert tasks;
            return tasks;
        }
    }
}
