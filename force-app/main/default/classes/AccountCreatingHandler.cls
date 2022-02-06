public class AccountCreatingHandler {
    @invocableMethod(Label='Assign tasks to accounts' Description='Assigning new tasks to created accounts')
    public static void assigningTaskToCreatedAccount(List<InputProps> inputs) {
        List<Account> accList = new List<Account>();
        for (InputProps input : inputs) {
            accList.add(input.createdAccount[0]);
        }
        List<Task> tasksList = new List<Task>();
        for (Account accont : accList) {
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
    public class InputProps {
        @invocablevariable
        public List<Account> createdAccount;
    }
}
