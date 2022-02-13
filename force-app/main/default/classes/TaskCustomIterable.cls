public class TaskCustomIterable implements Iterator<Task> {
    List<Task> tasks;
    Integer i;
    public TaskCustomIterable() {
        tasks = [
            SELECT Id, WhatId, Is_Synced__c, Account.Owner.Name, Account.Updated_By_Task__c
            FROM Task
            WHERE Is_Synced__c = false
        ];
        i = 0;
    }
    public Boolean hasNext() {
        if (i >= tasks.size()) {
            return false;
        } else {
            return true;
        }
    }
    public Task next() {
        if (i == 200) {
            return null;
        }
        i++;
        return tasks[i-1];
    }
}
