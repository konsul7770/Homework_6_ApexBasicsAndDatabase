public class ScheduleBatchJobs implements Schedulable{
    public void execute(SchedulableContext sc) {
        TasksAndAccountsFieldsUpdaterBatch tUpdater = new TasksAndAccountsFieldsUpdaterBatch();
        Database.executeBatch(tUpdater);
        ContactsAndAccountsFieldsUpdaterBatch contUpdater = new ContactsAndAccountsFieldsUpdaterBatch();
        Database.executeBatch(contUpdater);
    }
}
