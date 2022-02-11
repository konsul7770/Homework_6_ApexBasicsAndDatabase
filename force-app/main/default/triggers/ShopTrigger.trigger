trigger ShopTrigger on Shop__c (before update) {
    if (Trigger.isUpdate && Trigger.isBefore) {
        if (CheckTriggersRecurcive.ShopTriggerFirstImplement) {
            CheckTriggersRecurcive.ShopTriggerFirstImplement = false;
            System.debug('ShopTrigger in before update context is implemented');
        }
    }
}