List<User> users = [SELECT Id, Name
FROM User
WHERE isActive=true];
for (User u : users) {
    System.debug(u.Name);
}
Account accont1 = new Account(Name='Account test update1');
Account accont2 = new Account(Name='Account test update2');
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
    accont.Name = accont.Name.substring(0,20) + ' edited';
}
update accFromOrg;



List<Task> tasks = [
    SELECT Id, WhatId, Account.Owner.Name
    FROM Task
];
for (Task t : tasks) {
    System.debug(t.Account.Owner.Name);
}

Id BatchJobId = Database.executeBatch(new TasksAndAccountsFieldsUpdaterBatch());

List<Account> accs = [select Name, BillingAddress from Account];
for (Account  ac : accs) {
    System.debug(ac.Name+' '+ac.BillingAddress);
}
Id BatchJobId1 = Database.executeBatch(new ContactsAndAccountsFieldsUpdaterBatch());

AccountsAndContactsFuture.updateRelatedContacts();

Sch
System.Schedule('job-name','0 30 0 * * * ?', )