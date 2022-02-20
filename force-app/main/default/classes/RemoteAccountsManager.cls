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
    public static void getTargetAccounts() {
        formRequest(null, null, 'GET');
    }
    public static void createTargetAccount(List<Account> accounts) {
        formRequest(accounts, null, 'POST');
    }
    public static void deleteTargetAccount(List<Id> accountIds) {
        formRequest(null, accountIds, 'DELETE');
    }
    public static void upsertTargetAccount(List<Account> accounts) {
        formRequest(accounts, null, 'PUT');
    }
    public static void updateTargetAccount(List<Account> accounts) {
        formRequest(accounts, null, 'PATCH');
    }
    private static void formRequest(List<Account> accounts, List<Id> accountIds, String httpMethod) {
        Map<String,String> authObj = getAuthenticationToken();
        if (authObj==null) {
            System.debug('Authorisation failed');
            return;
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
        } else if (httpMethod == 'DELETE') {
            request.setBody(JSON.serialize(accountIds));
        }
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            System.debug('Fetch data from remote org failed');
            return;
        }
        if (response.getStatusCode() == 200) {
            if (httpMethod != 'DELETE') {
                List<Account> accountsFromRemoteOrg = (List<Account>)JSON.deserialize(response.getBody(), List<Account>.Class);
                for (Account accont : accountsFromRemoteOrg) {
                    System.debug('Id: '+accont.Id+' Name: '+accont.Name);
                }
            }
        }
    }
}
