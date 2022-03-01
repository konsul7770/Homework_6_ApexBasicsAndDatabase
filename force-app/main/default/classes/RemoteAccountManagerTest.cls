@isTest
public with sharing class RemoteAccountManagerTest {
    private static final String getResponse = '[{"attributes":{"type":"Account","url":"/services/data/v52.0/sobjects/Account/1"},"Id":"1","Name":"Target Test account06"},{"attributes":{"type":"Account","url":"/services/data/v52.0/sobjects/Account/2"},"Id":"2","Name":"Target Test account36"}]';
    private static final String postResponse = '[{"id":"0015g00000fZfOKAA0","success":true,"errors":[]},{"success":false,"errors":[{"statusCode":"REQUIRED_FIELD_MISSING","message":"Required fields are missing: [Name]","fields":["Name"]}]},{"success":false,"errors":[{"statusCode":"INVALID_FIELD_FOR_INSERT_UPDATE","message":"cannot specify Id in an insert call","fields":["Id"]}]}]';
    private static final String deleteResponse = '[{"id":"0015g00000WSdVSAA1","success":true,"errors":[]}]';
    private static final String putResponse = '[{"id":"0015g00000fZfOZAA0","success":true,"errors":[],"created":true},{"success":false,"errors":[{"statusCode":"REQUIRED_FIELD_MISSING","message":"Required fields are missing: [Name]","fields":["Name"]}],"created":true},{"id":"0015g00000fZ061AAC","success":true,"errors":[],"created":false},{"success":false,"errors":[{"statusCode":"REQUIRED_FIELD_MISSING","message":"Required fields are missing: [Name]","fields":["Name"]}],"created":false}]';
    private static final String patchResponse = '[{"id":"0015g00000fZ061AAC","success":true,"errors":[]},{"success":false,"errors":[{"statusCode":"REQUIRED_FIELD_MISSING","message":"Required fields are missing: [Name]","fields":["Name"]}]},{"success":false,"errors":[{"statusCode":"MISSING_ARGUMENT","message":"Id not specified in an update call","fields":[]}]}]';
    @TestSetup
    static void makeData(){
        Authentification_Settings__c authSettings = new Authentification_Settings__c();
        authSettings.ClientId__c = '3MVG9fe4g9fhX0E5qtf_fFde_HBUiKhCxvZPXal5Z8VvYuhDpbmSbjoB98Vjk0B0yLbuAi_QnYRGTTCOlQsxX';
        authSettings.ClientSecret__c = '34299BE783ADDEBA0AC0184AD88E70973C5D3C1805A2FC6803D97393CF398981';
        authSettings.Username__c = 'alex-konsul7770@yandex.ru';
        authSettings.Password__c = 'A128362dN!yx1kuUFKpoI0iWwmRkAqiUa8New';
        authSettings.SetupOwnerId = UserInfo.getProfileId();
        insert authSettings;
    }
    @isTest
    static void getTargetAccountsTest() {
        MultiRequestMock multiMock = getMock(getResponse);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiMock);
        HttpResponse response = RemoteAccountsManager.getTargetAccounts();
        Test.stopTest();
        List<Account> accs = (List<Account>)JSON.deserialize(response.getBody(), List<Account>.class);
        system.assert(response.getStatusCode() == 200);
        System.assertEquals(2, accs.size());
    }
    @isTest
    static void createTargetAccountTest() {
        MultiRequestMock multiMock = getMock(postResponse);
        List<Account> accounts = new List<Account>();
        List<Account> accs = new List<Account>();
        accs.add(new Account(Name = 'post1 test'));
        accs.add(new Account(Description = 'description'));
        accs.add(new Account(Id = '0015g00000fZ061AAC',Name = 'tats'));
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiMock);
        HttpResponse response = RemoteAccountsManager.createTargetAccount(accounts);
        Test.stopTest();
        List<Database.SaveResult> results = (List<Database.SaveResult>)JSON.deserialize(response.getBody(), List<Database.SaveResult>.class);
        Integer successCount = 0;
        for (Database.SaveResult sr: results) {
            if (sr.isSuccess()) {
                successCount++;
            }
        }
        System.assert(response.getStatusCode() == 200);
        System.assertEquals(1, successCount);
    }
    @isTest
    static void deleteTargetAccountTest() {
        MultiRequestMock multiMock = getMock(deleteResponse);
        List<Id> accountIds = new List<Id>();
        accountIds.add('0015g00000WSdVSAA1');
        accountIds.add('0015g00000WSdVSAA1');
        accountIds.add(null);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiMock);
        HttpResponse response = RemoteAccountsManager.deleteTargetAccount(accountIds);
        Test.stopTest();
        List<Database.DeleteResult> results = (List<Database.DeleteResult>)JSON.deserialize(response.getBody(), List<Database.DeleteResult>.class);
        Integer successCount = 0;
        for (Database.DeleteResult dr: results) {
            if (dr.isSuccess()) {
                successCount++;
            }
        }
        System.assert(response.getStatusCode() == 200);
        System.assertEquals(1, successCount);
    }
    @isTest
    static void upsertTargetAccountTest() {
        MultiRequestMock multiMock = getMock(putResponse);
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'new account'));
        accounts.add(new Account(Description = 'description'));
        accounts.add(new Account(Id='0015g00000fZ061AAC',Name='putnamechange'));
        accounts.add(new Account(Id='0015g00000fZ064AAC',Name = ''));
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiMock);
        HttpResponse response = RemoteAccountsManager.upsertTargetAccount(accounts);
        Test.stopTest();
        List<Database.UpsertResult> results = (List<Database.UpsertResult>)JSON.deserialize(response.getBody(), List<Database.UpsertResult>.class);
        Integer successCount = 0;
        for (Database.UpsertResult sr: results) {
            if (sr.isSuccess()) {
                successCount++;
            }
        }
        System.assert(response.getStatusCode() == 200);
        System.assertEquals(2, successCount);
    }
    @isTest
    static void updateTargetAccountTest() {
        MultiRequestMock multiMock = getMock(patchResponse);
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Id='0015g00000fZ061AAC',Name='valid name'));
        accounts.add(new Account(Id='0015g00000fZ064AAC',Name = ''));
        accounts.add(new Account(Name = 'patch'));
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multiMock);
        HttpResponse response = RemoteAccountsManager.updateTargetAccount(accounts);
        Test.stopTest();
        List<Database.SaveResult> results = (List<Database.SaveResult>)JSON.deserialize(response.getBody(), List<Database.SaveResult>.class);
        Integer successCount = 0;
        for (Database.SaveResult sr: results) {
            if (sr.isSuccess()) {
                successCount++;
            }
        }
        System.assert(response.getStatusCode() == 200);
        System.assertEquals(1, successCount);
    }
    private static MultiRequestMock getMock(String respBody) {
        Authentification_Settings__c authSettings = Authentification_Settings__c.getInstance(UserInfo.getProfileId());
        StaticResource st = [select body from StaticResource where name = 'AuthResponse' limit 1];
        SingleRequestMock authMock = new SingleRequestMock(200, 'Complete', st.body.toString(), null);
        SingleRequestMock respMock = new SingleRequestMock(200, 'Complete',respBody, null);
        Map<String,HttpCalloutMock> request = new Map<String,HttpCalloutMock>();
        String authEndpoint = 'https://login.salesforce.com/services/oauth2/token'+
        '?grant_type=password'+
        '&client_id='+authSettings.ClientId__c+
        '&client_secret='+authSettings.ClientSecret__c+
        '&username='+authSettings.Username__c+
        '&password='+authSettings.Password__c;
        request.put(authEndpoint,authMock);
        request.put('https://thecompany-6b-dev-ed.my.salesforce.com/services/apexrest/Accounts/',respMock);
        MultiRequestMock multiMock = new MultiRequestMock(request);
        return multiMock;
    }
}
