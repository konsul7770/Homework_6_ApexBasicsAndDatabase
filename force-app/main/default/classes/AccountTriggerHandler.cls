public with sharing class AccountTriggerHandler {
    public static void onInsertAccounts(Map<Id,Account> accounts) {
        List<String> accountsIdsAndNames = new List<String>();
        for (Id accontId : accounts.keySet()) {
            accountsIdsAndNames.add(accontId+';'+accounts.get(accontId).Name);
        }
        AccountTriggerHandler.tasksCreationMethod(accountsIdsAndNames);
    }

    public static void onUpdateAccounts(Map<Id,Account> oldVerAccounts, Map<Id,Account> newVerAccounts) {
        Set<Id> accountsIds = new Set<Id>();
        for (Id curId : oldVerAccounts.keySet()) {
            if (oldVerAccounts.get(curId).BillingAddress != newVerAccounts.get(curId).BillingAddress) {
                accountsIds.add(curId);
            }
        }
        editRelatedContactsFutureMethod(accountsIds);
    }
    @future
    public static void tasksCreationMethod(List<String> accountsIdsAndNames) {
        List<Task> tasksList = new List<Task>();
        for (String accont : accountsIdsAndNames) {
            Task newTask = new Task();
            Integer separatorIndex = accont.indexOf(';');
            newTask.Subject = 'Nogotiation with '+accont.substring(separatorIndex+1, (accont.length()-1)-separatorIndex);
            newTask.Priority = 'Normal';
            newTask.Status = 'Open';
            newTask.WhatId = (Id) accont.substring(0,separatorIndex);
            newTask.Is_Synced__c = false;
            tasksList.add(newTask);
        }
        try {
            insert tasksList;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
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
