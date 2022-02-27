public with sharing class AccountTriggerHandler {
    public static void onInsertAccounts(Map<Id,Account> accounts) {
        AccountTriggerHandler.tasksCreationMethod(accounts.keySet());
    }

    public static void onUpdateAccounts(Map<Id,Account> oldVerAccounts, Map<Id,Account> newVerAccounts) {
        Set<Id> accountsIds = new Set<Id>();
        for (Id curId : oldVerAccounts.keySet()) {
            if (oldVerAccounts.get(curId).BillingCity != newVerAccounts.get(curId).BillingCity ||
                oldVerAccounts.get(curId).BillingCountry != newVerAccounts.get(curId).BillingCountry ||
                oldVerAccounts.get(curId).BillingLatitude != newVerAccounts.get(curId).BillingLatitude ||
                oldVerAccounts.get(curId).BillingLongitude != newVerAccounts.get(curId).BillingLongitude ||
                oldVerAccounts.get(curId).BillingPostalCode != newVerAccounts.get(curId).BillingPostalCode ||
                oldVerAccounts.get(curId).BillingState != newVerAccounts.get(curId).BillingState ||
                oldVerAccounts.get(curId).BillingStreet != newVerAccounts.get(curId).BillingStreet)  {
                    accountsIds.add(curId);
            }
        }
        if (!accountsIds.isEmpty()) {
            //editRelatedContactsFutureMethod(accountsIds);
            UpdateRelatedtoAcccountsContacts updCont = new UpdateRelatedtoAcccountsContacts(accountsIds);
            Id jobId = System.enqueueJob(updCont);
        }
    }
    @future
    public static void tasksCreationMethod(Set<Id> accountsIds) {
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Id IN :accountsIds
        ];
        List<Task> tasksList = new List<Task>();
        for (Account accont : accounts) {
            Task newTask = new Task();
            newTask.Subject = 'Nogotiation with '+accont.Name;
            newTask.Priority = 'Normal';
            newTask.Status = 'Open';
            newTask.WhatId = accont.Id;
            newTask.Is_Synced__c = false;
            tasksList.add(newTask);
        }
        insert tasksList;
    }
    @future
    public static void editRelatedContactsFutureMethod(Set<Id> accountIds) {
        List<Contact> relatedContacts = [
            SELECT Id, accountId, Is_Synced__c, Processed_By_Future__c 
            FROM Contact 
            WHERE AccountId IN :accountIds];
        for (Contact cont : relatedContacts) {
            cont.Is_Synced__c = false;
            cont.Processed_By_Future__c = true;
        }
        try {
            update relatedContacts;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}
