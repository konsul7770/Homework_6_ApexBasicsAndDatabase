@isTest
public with sharing class AccountUpdatingHandlerTest {
    @IsTest
    public static void assignTasksToUsersTest() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'test 1'));
        accounts.add(new Account(Name = 'test 2'));
        insert accounts;

        List<Task> tskList = new List<Task>();
        for (Integer i = 0; i < 4; i++) {
            Task tsk = new Task();
            tsk.WhatId = accounts[0].Id;
            tsk.Subject = 'Test task '+ (i+1);
            tsk.Priority = 'Normal';
            tsk.Status = 'Open';
            tskList.add(tsk);
        }
        insert tskList;
        //one task creating and assining to account for future method calling from trigger
        Test.startTest();
        AccountUpdatingHandler.assignTasksToUsers(accounts);
        Test.stopTest();

        AggregateResult[] results = [SELECT count(OwnerId) FROM Task WHERE WhatId = :accounts[0].Id];
        AggregateResult[] results1 = [SELECT count(OwnerId) FROM Task WHERE WhatId = :accounts[1].Id];
        System.assertEquals(5, results[0].get('expr0'));
        System.assertEquals(1, results1[0].get('expr0'));
    }
}
