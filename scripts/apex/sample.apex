List<User> users = [SELECT Id, Name, UserType
FROM User
WHERE isActive=true AND UserType != 'CsnOnly' AND UserType != 'AutomatedProcess'];
for (User u : users) {
    System.debug(u.Name+' user type '+u.UserType);
}
Account accont1 = new Account(Name='Account test create1');
Account accont2 = new Account(Name='Account test create2');
List<Account> accountList = new List<Account>();
accountList.add(accont1);
accountList.add(accont2);
insert accountList;
for (Account ac : accountList) {
    System.debug(ac.Id);
}

List<Account> accFromOrg = [
    SELECT Id, Name
    FROM Account
    WHERE Name LIKE 'Account test update%'
];
List<Task> taskToIsert = new List<Task>();
for (Account accont : accFromOrg) {
    for (Integer i = 0; i < 5;i++) {
        Task tsk = new Task();
        tsk.Subject = 'test task '+(i+1)+' for '+accont.Name;
        tsk.Priority = 'Normal';
        tsk.Status = 'Open';
        tsk.WhatId = accont.Id;
        taskToIsert.add(tsk);
    }
}
insert taskToIsert;

List<Account> accFromOrg = [
    SELECT Id, Name
    FROM Account
    WHERE Name LIKE 'Account test update%'
];
for (Account accont : accFromOrg) {
    accont.Name = accont.Name.substring(0,20) + ' changed';
}
update accFromOrg;
// remote accounts task
RemoteAccountsManager.getTargetAccounts();

List<Account> accs = new List<Account>();
for(Integer i = 0; i<2; i++) {
    Account accont = new Account(Name='Test remote'+i+1);
    accs.add(accont);
}
RemoteAccountsManager.createTargetAccount(accs);

List<Id> ids = new List<Id>();
ids.add('0015g00000fZ1GkAAK');
ids.add('0015g00000fZ1GjAAK');
RemoteAccountsManager.deleteTargetAccount(ids);

List<Account> putAccounts = new List<Account>();
putAccounts.add(new Account(Name='Test put method'));
putAccounts.add(new Account(Id='0015g00000fZ03RAAS',Name='changed by upsert'));
RemoteAccountsManager.upsertTargetAccount(putAccounts);


List<Account> patchAccount = new List<Account>();
patchAccount.add(new Account(Id='0015g00000fZ0h2AAC',Name='valid name'));
RemoteAccountsManager.updateTargetAccount(patchAccount);