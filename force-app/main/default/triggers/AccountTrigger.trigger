trigger AccountTrigger on Account (after insert, after update) {
    if (Trigger.isInsert && Trigger.isAfter) {
        AccountTriggerHandler.onInsertAccounts(Trigger.newMap);
    }
    if (Trigger.isUpdate && Trigger.isAfter) {
        AccountTriggerHandler.onUpdateAccounts(Trigger.oldMap, Trigger.newMap);
    }
}