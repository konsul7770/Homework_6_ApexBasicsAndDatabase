@isTest
public with sharing class AccountCreatingHandlerTest {
    @isTest
    public static void assigningTaskToCreatedAccountTest() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'test account'));
        insert accounts;

        Test.startTest();
        AccountCreatingHandler.assigningTaskToCreatedAccount(accounts);
        Test.stopTest();

        Task tsk = [SELECT Id, Subject, Priority, Status, WhatId
        FROM Task
        WHERE WhatId = :accounts[0].Id AND Priority = 'Normal' AND Status = 'Open' LIMIT 1];
        System.AssertNotEquals(null,tsk);
    }
}
