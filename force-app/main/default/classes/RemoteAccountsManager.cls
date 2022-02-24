public with sharing class RemoteAccountsManager {
    private static Map<String,String> getAuthenticationToken() {
        String AccessToken = null;
        Id profileId = UserInfo.getProfileId();
        Authentification_Settings__c authSettings = Authentification_Settings__c.getInstance(profileId);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token'+
        '?grant_type=password'+
        '&client_id='+authSettings.ClientId__c+
        '&client_secret='+authSettings.ClientSecret__c+
        '&username='+authSettings.Username__c+
        '&password='+authSettings.Password__c);
        request.setMethod('POST');
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String,String> authObj = (Map<String,String>)JSON.deserialize(response.getBody(), Map<String,String>.Class);
            return authObj;
        }
        return null;
    }
    public static HttpResponse getTargetAccounts() {
        return formRequest(null, null, 'GET');
    }
    public static HttpResponse createTargetAccount(List<Account> accounts) {
        return formRequest(accounts, null, 'POST');
    }
    public static HttpResponse deleteTargetAccount(List<Id> accountIds) {
        return formRequest(null, accountIds, 'DELETE');
    }
    public static HttpResponse upsertTargetAccount(List<Account> accounts) {
        return formRequest(accounts, null, 'PUT');
    }
    public static HttpResponse updateTargetAccount(List<Account> accounts) {
        return formRequest(accounts, null, 'PATCH');
    }
    private static HttpResponse formRequest(List<Account> accounts, List<Id> accountIds, String httpMethod) {
        Map<String,String> authObj = getAuthenticationToken();
        if (authObj==null) {
            System.debug('Authorisation failed');
            return null;
        }
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint(authObj.get('instance_url')+'/services/apexrest/Accounts/');
        request.setHeader('Authorization', 'Bearer '+authObj.get('access_token'));
        request.setHeader('Content-type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setMethod(httpMethod);
        if (httpMethod == 'POST'|| httpMethod == 'PUT' || httpMethod == 'PATCH') {
            request.setBody(JSON.serialize(accounts));
        }
        if (httpMethod == 'DELETE') {
            request.setBody(JSON.serialize(accountIds));
        }
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('Fetch data from remote org failed');
            return response;
        }
        if (response.getStatusCode() == 200) {
            if (httpMethod == 'GET') {
                List<Account> responseAccounts = (List<Account>)JSON.deserialize(response.getBody(), List<Account>.Class);
                for (Account account : responseAccounts) {
                    System.debug('Id: '+account.Id+' Name: '+account.Name);
                }
            }
            if (httpMethod == 'POST' || httpMethod == 'PATCH') {
                Database.SaveResult[] saveResult = (Database.SaveResult[])JSON.deserialize(response.getBody(), Database.SaveResult[].Class);
                for (Database.SaveResult sr : saveResult) {
                    if (sr.isSuccess()) {
                        System.debug('Id: '+sr.getId()+' successfuly saved');
                    } else {
                        System.debug('Id: '+sr.getId()+' saving failed');
                        for (Database.Error srError : sr.errors) {
                            System.debug(srError.getMessage());
                        }
                    }
                }
            }
            if (httpMethod == 'PUT') {
                Database.UpsertResult[] upsertResult = (Database.UpsertResult[])JSON.deserialize(response.getBody(), Database.UpsertResult[].Class);
                for (Database.UpsertResult upres : upsertResult) {
                    if (upres.isSuccess()) {
                        System.debug('Id: '+upres.getId()+' successfuly upsert');
                    } else {
                        System.debug('Id: '+upres.getId()+' upserting failed');
                        for (Database.Error upresError : upres.errors) {
                            System.debug(upresError.getMessage());
                        }
                    }
                }
            }
            if (httpMethod == 'DELETE') {
                Database.DeleteResult[] deleteResult = (Database.DeleteResult[])JSON.deserialize(response.getBody(), Database.DeleteResult[].Class);
                for (Database.DeleteResult dr : deleteResult) {
                    if (dr.isSuccess()) {
                        System.debug('Id: '+dr.getId()+' successfuly deleted');
                    } else {
                        System.debug('Id: '+dr.getId()+' deliting failed');
                        for (Database.Error drError : dr.errors) {
                            System.debug(drError.getMessage());
                        }
                    }
                }
            }
        }
        return response;
    }
}
