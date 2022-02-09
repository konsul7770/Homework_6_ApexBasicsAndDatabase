public class AccountUpdatingHandler {
    @invocableMethod(Label='Assign Tasks' Description='Assigning tasks related to accounts to users')
    public static void assignTasksToUsers(List<Account> accounts) {
        Set<Id> accountIds = new Set<Id>();
        for (Account accont : accounts) {
            accountIds.add(accont.Id);
        }
        List<Task> updatingTasks = new List<Task>();
        List<User> orgUsers = [
            SELECT 
                Id,
                Name 
            FROM User
            WHERE isActive = true AND UserType != 'CsnOnly' AND UserType != 'AutomatedProcess'];
        List<Task> relatedTasks = [
            SELECT 
                Id, 
                OwnerId, 
                WhatId
            FROM Task
            WHERE WhatId IN :accountIds
        ];
        Map<Id,List<Task>> accountIdsWithRespondedTasks = new Map<Id,List<Task>>();
        for (Task tsk : relatedTasks) {
            if (!accountIdsWithRespondedTasks.containsKey(tsk.WhatId)) {
                accountIdsWithRespondedTasks.put(tsk.WhatId,new List<Task>());
            }
            accountIdsWithRespondedTasks.get(tsk.WhatId).add(tsk);
        }
        for (Id accountId : accountIdsWithRespondedTasks.keySet()) {
            if (accountIdsWithRespondedTasks.get(accountId).Size() > 3) {
                User RandomUser = orgUsers[Integer.valueOf((Math.random()*(orgUsers.size()-1)))];
                System.debug('Selected user: '+RandomUser.Name);
                for (Task acTask : accountIdsWithRespondedTasks.get(accountId)) {
                    acTask.OwnerId = RandomUser.Id;
                    updatingTasks.add(acTask);
                }
            }
        }
        try {
            update updatingTasks;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}
