public class TasksIterableBatch implements Database.Batchable<Task> {
    public Iterable<Task> start(Database.BatchableContext bc) {
        return new TasksIterator();
    }
    public void execute(Database.BatchableContext bc, List<Task> scope) {
        List<Task> tasks = new List<Task>();
        List<Account> accountsToUpdate = new List<Account>();
        for (Task tsk: scope) {
            tsk.Account_Owner__c = tsk.Account.Owner.Name;
            tsk.Is_Synced__c = true;
            tasks.add(tsk);
            if (tsk.WhatId != null) {
                Account accont = new Account(Id = tsk.WhatId,Updated_By_Task__c = true);
                accountsToUpdate.add(accont);
            }
        }
        try {
            update tasks;
            update accountsToUpdate;
        } catch (DMLException e) {
            System.debug(e.getMessage());
        }
    }
    public void finish(Database.BatchableContext bc) {
        
    }
}
