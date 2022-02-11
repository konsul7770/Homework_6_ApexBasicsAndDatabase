public with sharing class AccountTriggerHandler {
    public static void onInsertAccounts(Map<Id,Account> accounts) {
        List<String> accountsIdsAndNames = new List<String>();
        for (Id accontId : accounts.keySet()) {
            accountsIdsAndNames.add(accontId+';'+accounts.get(accontId).Name);
        }
        AccountTriggerHandler.tasksCreationMethod(accountsIdsAndNames);
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
}
