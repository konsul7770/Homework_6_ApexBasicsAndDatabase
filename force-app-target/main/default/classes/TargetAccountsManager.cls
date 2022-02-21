@RestResource(urlMapping='/Accounts/*')
global with sharing class TargetAccountsManager {
    @HttpGet
    global static List<Account> getAccount() {
        return [
            SELECT Id, Name
            FROM Account
        ];
    }
    @HttpPost
    global static void createAccount() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        List<Account> accounts = (List<Account>)JSON.deserialize(request.requestBody.toString(), List<Account>.Class);
        Database.SaveResult[] results = Database.insert(accounts,false);
        response.responseBody = Blob.valueOf(JSON.serialize(results));
    }
    @HttpDelete
    global static void deleteAccount() {
        RestRequest Request = RestContext.request;
        RestResponse response = RestContext.response;
        List<Id> accountIds = (List<Id>)JSON.deserialize(request.requestBody.toString(), List<Id>.Class);
        List<Account> deletingAccounts = [
            SELECT Id
            FROM Account
            WHERE Id IN :accountIds
        ];
        Database.DeleteResult[] results = Database.Delete(deletingAccounts,false);
        response.responseBody = Blob.valueOf(JSON.serialize(results));
    }
    @HttpPut
    global static void upsertTargetAccount() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        List<Account> accounts = (List<Account>)JSON.deserialize(request.requestBody.toString(), List<Account>.Class);
        Database.UpsertResult[] results = Database.upsert(accounts,false);
        response.responseBody = Blob.valueOf(JSON.serialize(results));
    }
    @HttpPatch
    global static void updateTargetAccount() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        List<Account> accounts = (List<Account>)JSON.deserialize(request.requestBody.toString(), List<Account>.Class);
        Database.SaveResult[] results = Database.update(accounts,false);
        response.responseBody = Blob.valueOf(JSON.serialize(results));
    }
}