public class ScheduleTaskContactsBatches implements Schedulable{
    public void execute(SchedulableContext sc) {
        ContactsQueryLocatorBatch contBatch = new ContactsQueryLocatorBatch();
        Database.executeBatch(contBatch);
        TasksIterableBatch taskBatch = new TasksIterableBatch();
        Database.executeBatch(taskBatch);
    }
}
