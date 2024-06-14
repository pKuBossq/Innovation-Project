public with sharing class MissingAnimals {

    private static String token = '';
    private static String client_id = '3MVG9KlmwBKoC7U0tQGO2yaWKdVkrhut3PJ.Z.dw3qjvqP0Y.fjc_lO_vj3782NIru2vJv9Nheuo4.w7UpDTo';
    private static String client_secret = 'B4B01B6A629E8543BF6156676991E29F0CED4C6830A6FDCDDC315AB4725A2836';
    private static String username = 'restuser@innowacja.rest.inn';
    private static String password = 'restInnowacja123ySNFCDdZkdKBOB7POKaZp9Sx4';

    public static String getToken() {
        String URL = 'https://test.salesforce.com/services/oauth2/token';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL);
        request.setMethod('POST');
        String requestBody = 'grant_type=password&client_id=' + client_id + '&client_secret=' + client_secret + '&username=' + username + '&password=' + password;
        request.setBody(requestBody);
    
        Http http = new Http();
        HttpResponse response = new HttpResponse();
        try {
            response = http.send(request);
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            if (response.getStatusCode() == 200) {
                return (String) results.get('access_token');
            } else {
                System.debug('Error during token retrieval. Status code: ' + response.getStatusCode() + ', response: ' + response.getBody());
                throw new CalloutException('FAILED TO GET TOKEN: ' + response.getStatusCode() + ' - ' + response.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            throw new CalloutException('FAILED TO GET TOKEN: ' + e.getMessage());
        }
    }
    
    public static List<String> getAnimalIds(integer day) {
        token = getToken();
        SYstem.debug(token);
        String endpoint = 'https://cw-inn--inn.sandbox.my.salesforce.com/services/apexrest/MissingAnimals?dayDelta=' + day + '&groupId=G1';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);

        Http http = new Http();
        HttpResponse response = http.send(request);

        List<String> idList = new List<String>();
        if(response.getStatusCode() == 200) {
            String id = response.getBody();
            id = id.substring(2, id.length() - 2);
            String clean = id.replaceAll('[\\\\"]', '');
            idList = clean.split(',');
        } else {
            idList.add('Wystąpił błąd: ' + response.getStatusCode());
        }
        
        return idList;
    }

    public static String getAnimalPhotoURL(String animalId) {
        String endpoint = 'https://cw-inn--inn.sandbox.my.salesforce.com/services/apexrest/MissingAnimals/' + animalId;

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);

        Http http = new Http();
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) { return response.getBody(); }
        else {
            System.debug('Error durring retrieving access token. Status code: ' + response.getStatusCode());
            return null;
        }
    }

    @AuraEnabled(Cacheable = true)
    public static Map<String, String> getAllAnimalPhotos(integer day) {
        Map<String, String> photosMap = new Map<String, String>();
        for (String Id : getAnimalIds(day)) {
            System.debug('Id zwierzaka: ' + Id);
            String photoURL = getAnimalPhotoURL(Id);
            if (photoURL != null) { photosMap.put(Id, photoURL); }
        }
        return photosMap;
    }
}