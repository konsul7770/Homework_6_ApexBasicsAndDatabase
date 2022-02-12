public class TasksAndAccountsFieldsUpdaterBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, WhatId, Is_Synced__c, Account.Owner.Name, Account.Updated_By_Task__c '+
            'FROM Task '+
            'WHERE Is_Synced__c = false'
        );
    }
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Task> tasks = new List<Task>();
        List<Account> accountsToUpdate = new List<Account>();
        for (SObject s: scope) {
            Task tsk = (Task)s;
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
