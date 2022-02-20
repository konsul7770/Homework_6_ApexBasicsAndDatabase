@RestResource(urlMapping='/Accounts/*')
global with sharing class TargetAccountsManager {
    @HttpGet
    global static List<Account> getAccount() {
        return [
            SELECT Id, Name
            FROM Account
            LIMIT 200
        ];
    }
    @HttpPost
    global static List<Account> createAccount() {
        RestRequest request = RestContext.request;
        List<Account> accounts = (List<Account>)JSON.deserialize(request.requestBody.toString(), List<Account>.Class);
        Database.SaveResult[] results = Database.insert(accounts,false);
        return savedRecords(results, accounts);
    }
    @HttpDelete
    global static void deleteAccount() {
        RestRequest Request = RestContext.request;
        List<Id> accountIds = (List<Id>)JSON.deserialize(request.requestBody.toString(), List<Id>.Class);
        List<Account> deletingAccounts = [
            SELECT Id
            FROM Account
            WHERE Id IN :accountIds
        ];
        if (!deletingAccounts.isEmpty()) {
            delete deletingAccounts;
        }
    }
    @HttpPut
    global static List<Account> upsertTargetAccount() {
        RestRequest request = RestContext.request;
        List<Account> accounts = (List<Account>)JSON.deserialize(request.requestBody.toString(), List<Account>.Class);
        Database.UpsertResult[] results = Database.upsert(accounts,false);
        Integer i = 0;
        List<Account> upsertAccounts = new List<Account>();
        for (Database.UpsertResult upRes : results) {
            if (upRes.isSuccess()) {
                upsertAccounts.add(accounts.get(i));
            }
            i++;
        }
        return upsertAccounts;
    }
    @HttpPatch
    global static List<Account> updateTargetAccount() {
        RestRequest request = RestContext.request;
        List<Account> accounts = (List<Account>)JSON.deserialize(request.requestBody.toString(), List<Account>.Class);
        Database.SaveResult[] results = Database.update(accounts,false);
        return savedRecords(results, accounts);
    }
    private static List<Account> savedRecords(Database.SaveResult[] results,List<Account> accounts) {
        Integer i = 0;
        List<Account> savedAccounts = new List<Account>();
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                savedAccounts.add(accounts.get(i));
            }
            i++;
        }
        return savedAccounts;
    }
}