@isTest
public with sharing class AllTestsForApexAsyncTask {
    //AccountTrigerHandler
    //onInsertAccounts
    @isTest
    static void onUpdateAccountsTest() {
        List<Account> accounts = TestDataFactory.ACCOUNT.createAccountsList(50, 'test name', true);
        TestDataFactory.CONTACT.createContactsList(0, 'name for', accounts, true);
        for (Integer i = 0; i < accounts.size(); i++) {
            if (Math.mod(i,2) == 0) {
                accounts[i].BillingCountry = 'another country';
            }
        }
        update accounts;

        List<Contact> contactsAfterUpdate = [
            SELECT Id, Processed_By_Queue__c, Is_Synced__c
            FROM Contact
            WHERE Is_Synced__c = false AND Processed_By_Queue__c = true
        ];
        System.assertNotEquals(25, contactsAfterUpdate.size());
    }
    //UpdateRelatedtoAcccountsContacts
    @isTest
    static void UpdateRelatedtoAcccountsContactsTest() {
        List<Account> accounts = TestDataFactory.ACCOUNT.createAccountsList(20, 'testname', true);
        TestDataFactory.CONTACT.createContactsList(0, 'contactname', accounts, true);
        Set<Id> accountsIds = new Set<Id>();
        for (Integer i = 0;i < 20; i++) {
            if (Math.mod(i,2) == 0) {
                accountsIds.add(accounts[i].Id);
            }
        }
        UpdateRelatedtoAcccountsContacts updater = new UpdateRelatedtoAcccountsContacts(accountsIds);
        Test.startTest();
        System.enqueueJob(updater);
        Test.stopTest();
        List<Contact> contactList = [
            SELECT Id, Is_Synced__c, Processed_By_Queue__c
            FROM Contact
            WHERE Processed_By_Queue__c = true AND Is_Synced__c = false
        ];
        System.assertNotEquals(null, contactList);
        System.assertEquals(10,contactList.size());
    }
    //AccountsAndContactsFuture
    @isTest
    static void updateRelatedContactsTest(){
        List<Account> accounts = TestDataFactory.ACCOUNT.createAccountsList(20, 'testname', true);
        TestDataFactory.CONTACT.createContactsList(0, 'contactname', accounts, true);

        Test.startTest();
        AccountsAndContactsFuture.updateRelatedContacts();
        Test.stopTest();
        List<Contact> contactsAfterTest = [
            SELECT Id, LastName, Is_Synced__c, Processed_By_Future__c 
            FROM Contact
            WHERE Is_Synced__c = false AND Processed_By_Future__c = true];
        System.assertEquals(10, contactsAfterTest.size());
    }
    //AccountsAndContactsQueable
    @isTest
    static void AccountsAndContactsQueableTest(){
        List<Account> accounts = TestDataFactory.ACCOUNT.createAccountsList(20, 'testname', true);
        TestDataFactory.CONTACT.createContactsList(0, 'contactname', accounts, true);
        AccountsAndContactsQueable updater = new AccountsAndContactsQueable();
        Test.startTest();
        System.enqueueJob(updater);
        Test.stopTest();
        List<Contact> contactsAfterTest = [
            SELECT Id, LastName, Is_Synced__c, Processed_By_Queue__c 
            FROM Contact
            WHERE Is_Synced__c = false AND Processed_By_Queue__c = true];
        System.assertEquals(10, contactsAfterTest.size());
    }
    //ContactsAndAccountsFieldsUpdaterBatch
    @isTest
    static void ContactsAndAccountsFieldsUpdaterBatchTest() {
        List<Account> accounts = TestDataFactory.ACCOUNT.createAccountsList(20, 'testname', true);
        TestDataFactory.CONTACT.createContactsList(0, 'contactname', accounts, true);
        
        Test.startTest();
        ContactsAndAccountsFieldsUpdaterBatch batch = new ContactsAndAccountsFieldsUpdaterBatch();
        Id jobId = Database.executeBatch(batch);
        Test.stopTest();
        System.assertEquals(20, [
            SELECT Id, Account.Updated_By_Contact__c, Account.BillingCountry, MailingCountry
            FROM Contact
            WHERE Is_Synced__c = true AND Account.Updated_By_Contact__c = true
        ].size());
    }
    //ContactsQueryLocatorBatchTest
    @isTest
    static void ContactsQueryLocatorBatchTest() {
        List<Account> accounts = TestDataFactory.ACCOUNT.createAccountsList(20, 'testname', true);
        TestDataFactory.CONTACT.createContactsList(0, 'contactname', accounts, true);
        
        Test.startTest();
        ContactsQueryLocatorBatch batch = new ContactsQueryLocatorBatch();
        Id jobId = Database.executeBatch(batch);
        Test.stopTest();
        System.assertEquals(20, [
            SELECT Id, Account.Updated_By_Contact__c, Account.BillingCountry, MailingCountry
            FROM Contact
            WHERE Is_Synced__c = true AND Account.Updated_By_Contact__c = true
        ].size());
    }
    //TasksAndAccountsFieldsUpdaterBatchTest
    @isTest
    static void TasksAndAccountsFieldsUpdaterBatchTest() {
        User user = [SELECT Id, Name FROM User WHERE UserType = 'Standard' Limit 1];
        List<Account> accounts = TestDataFactory.ACCOUNT.createAccountsList(5, 'test account', true);
        for (Account accont : accounts) {
            accont.OwnerId = user.Id;
        }
        TestDataFactory.TASK.createTasksList(accounts, 1);
        Test.startTest();
        TasksAndAccountsFieldsUpdaterBatch tasksBatch = new TasksAndAccountsFieldsUpdaterBatch();
        Id jobId = Database.executeBatch(tasksBatch);
        Test.stopTest();
        List<Task> tasksAfterBatch = [
            SELECT Id, Subject, Is_Synced__c, Account_Owner__c, Account.Updated_By_Task__c 
            FROM Task 
            WHERE Subject = 'Test task'AND Is_Synced__c = true AND Account.Updated_By_Task__c = true];
        for (Task t : tasksAfterBatch) {
            System.debug(t.Account_Owner__c);
        }
        System.assertEquals(5,tasksAfterBatch.size());
    }
    //ScheduleBatchJobs
    @isTest
    static void ScheduleBatchJobsTest() {
        String CRON_EXP = '0 30 * * * ?';
        String JOB_NAME = 'ScheduledBatches';
        Test.startTest();
        List<Account> accounts = TestDataFactory.ACCOUNT.createAccountsList(20, 'testname', true);
        List<Contact> contacts = TestDataFactory.CONTACT.createContactsList(0, 'contactname', accounts, true);
        List<Task> tasks = TestDataFactory.TASK.createTasksList(accounts, 1);
        Id jobId = System.schedule(JOB_NAME, CRON_EXP, new ScheduleBatchJobs());
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger 
            WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-03-01 12:30:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
    @isTest
    static void ScheduleTaskContactsBatchesTest(){
        String CRON_EXP = '0 30 * * * ?';
        String JOB_NAME = 'ScheduleTaskContactsBatches';
        Test.startTest();
        List<Account> accounts = TestDataFactory.ACCOUNT.createAccountsList(20, 'testname', true);
        List<Contact> contacts = TestDataFactory.CONTACT.createContactsList(0, 'contactname', accounts, true);
        List<Task> tasks = TestDataFactory.TASK.createTasksList(accounts, 1);
        Id jobId = System.schedule(JOB_NAME, CRON_EXP, new ScheduleTaskContactsBatches());
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger 
            WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-03-01 12:30:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}
