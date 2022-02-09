public class AccountCreatingHandler {
    @invocableMethod(Label='Assign tasks to accounts' Description='Assigning new tasks to created accounts')
    public static void assigningTaskToCreatedAccount(List<Account> accounts) {
        List<Task> tasksList = new List<Task>();
        for (Account accont : accounts) {
            Task newTask = new Task();
            newTask.Subject = 'Nogotiation with '+accont.Name;
            newTask.Priority = 'Normal';
            newTask.Status = 'Open';
            newTask.WhatId = accont.Id;
            tasksList.add(newTask);
        }
        try {
            insert tasksList;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
}
