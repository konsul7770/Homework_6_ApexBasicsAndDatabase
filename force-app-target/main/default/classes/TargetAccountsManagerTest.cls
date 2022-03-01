@isTest
public with sharing class TargetAccountsManagerTest {
    @isTest
    static void getAccountTest() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 150; i++) {
            Account accont = new Account(Name = 'test'+i);
            accounts.add(accont);
        }
        insert accounts;
        Test.startTest();
        List<Account> testAcounts = TargetAccountsManager.getAccount();
        Test.stopTest();
        System.assertNotEquals(null, testAcounts);
        System.assertEquals(150, testAcounts.size());
    }
    @isTest
    static void createAccountTest() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'post1 test'));
        accounts.add(new Account(Description = 'description'));
        accounts.add(new Account(Id = '0015g00000fZ061AAC',Name = 'test'));
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(accounts));
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        Test.startTest();
        TargetAccountsManager.createAccount();
        Test.stopTest();
        List<Account>testAccounts = [select Id, Name from Account];
        System.assertEquals(1, testAccounts.size());
        System.assert('post1 test'==testAccounts[0].Name);
    }
    @isTest
    static void deleteAccountTest() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='test 1'));
        accounts.add(new Account(Name='test 2'));
        insert accounts;
        Map<Id,Account> accsMap = new Map<Id,Account>();
        accsMap.putAll(accounts);
        List<Id> accountIds = new List<Id>();
        accountIds.addAll(accsMap.keySet());
        RestRequest request = new RestRequest();
        request.httpMethod = 'DELETE';
        request.requestBody = Blob.valueOf(JSON.serialize(accountIds));
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        Test.startTest();
        TargetAccountsManager.deleteAccount();
        Test.stopTest();
        List<Account> testAccounts = [select Id, Name from Account where Id IN :accountIds];
        System.assertEquals(0, testAccounts.size());
    }
    @isTest
    static void upsertTargetAccount() {
        List<Account> accounts = new List<Account>();
        List<Account> updatingAccounts = new List<Account>();
        for (Integer i = 0; i<2;i++) {
            Account ac = new Account(Name='test'+i);
            updatingAccounts.add(ac);
        }
        insert updatingAccounts;
        accounts.add(new Account(Name = 'new account'));
        accounts.add(new Account(Description = 'description'));
        accounts.add(new Account(Id = updatingAccounts[0].Id,Name = 'edited'));
        accounts.add(new Account(Id = updatingAccounts[1].Id,Name = ''));
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(accounts));
        request.httpMethod = 'PUT';
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        Test.startTest();
        TargetAccountsManager.upsertTargetAccount();
        Test.stopTest();
        List<Account>testAccounts = [select Id, Name from Account];
        System.assertEquals(3, testAccounts.size());
        List<Database.UpsertResult> result = (List<Database.UpsertResult>)JSON.deserialize(response.responseBody.toString(), List<Database.UpsertResult>.class);
        Integer count = 0;
        for (Database.UpsertResult sr : result) {
            if (sr.isSuccess()) {
                count++;
            }
        }
        System.assertEquals(2, count);
    }
    @isTest
    static void updateTargetAccountTest() {
        List<Account> accounts = new List<Account>();
        List<Account> updatingAccounts = new List<Account>();
        for (Integer i = 0; i<2;i++) {
            Account ac = new Account(Name='test'+i);
            updatingAccounts.add(ac);
        }
        insert updatingAccounts;
        accounts.add(new Account(Name = 'new account'));
        accounts.add(new Account(Id = updatingAccounts[0].Id,Name = 'edited'));
        accounts.add(new Account(Id = updatingAccounts[1].Id,Name = ''));
        RestRequest request = new RestRequest();
        request.requestBody = Blob.valueOf(JSON.serialize(accounts));
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        Test.startTest();
        TargetAccountsManager.updateTargetAccount();
        Test.stopTest();
        List<Account>testAccounts = [select Id, Name from Account];
        System.assertEquals(2, testAccounts.size());
        List<Database.SaveResult> result = (List<Database.SaveResult>)JSON.deserialize(response.responseBody.toString(), List<Database.SaveResult>.class);
        Integer count = 0;
        for (Database.SaveResult sr : result) {
            if (sr.isSuccess()) {
                count++;
            }
        }
        System.assertEquals(1, count);
    }
}
