public class TasksIterator implements Iterable<Task> {
    public Iterator<Task> Iterator() {
        return new TaskCustomIterable();
    }
}
