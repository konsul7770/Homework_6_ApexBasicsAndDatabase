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

[
    SELECT Count(Id)
    FROM Task
    GROUP BY WhatId
    HAVING Count(Id) > 3]

