public class AccountUpdatingHandler {
    @invocableMethod(Label='Assign Tasks' Description='Assigning tasks related to accounts to users')
    public static void assignTasksToUsers(List<InputProps> inputs) {
        List<Id> accountIds = new List<Id>();
        for (InputProps input : inputs) {
            accountIds.add(input.updatedAccounts[0].Id);
        }
        List<Task> updatingTasks = new List<Task>();
        List<User> orgUsers = [SELECT 
            Id,
            Name 
            FROM User
            WHERE isActive = true];
        List<Account> accountsFromOrg = [SELECT
            Id,
            Name,
            (SELECT Id, OwnerId, WhatId FROM Tasks)
            FROM Account
            WHERE Id IN :accountIds];
        for (Account accont : accountsFromOrg) {
            if (accont.Tasks.Size() > 3) {
                User RandomUser = orgUsers[Integer.valueOf((Math.random()*(orgUsers.size()-1)))];
                System.debug('Selected user: '+RandomUser.Name);
                for (Task acTask : accont.Tasks) {
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
    public class InputProps {
        @invocablevariable
        public List<Account> updatedAccounts;
    }
}
