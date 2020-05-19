public with sharing class Submit_Ticket_request {
    @AuraEnabled
    public static string pay_And_Approve_Request(List<sObject> selectedSeats, Decimal TotalPrice, String tripId){
        List<Access_Token__mdt> metaRecord = [SELECT Id, Bearer_Token__c from Access_Token__mdt WHERE Date_expired__c >: DateTime.now()];
        if(metaRecord.size()> 0){
            //prooced with payment request
        }else{
            //get bearer token
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.sandbox.paypal.com/v1/oauth2/token');
            req.setMethod('POST');
            
            // Specify the required user name and password to access the endpoint
            // As well as the header and header information
        
            String username = Label.username;
            String password = Label.password;
        
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setBody('grant_type=client_credentials');
            // Create a new http object to send the request object
            // A response object is generated as a result of the request  
            Http http = new Http();
            HTTPResponse res = http.send(req);
            if(res.getStatusCode() == 200){
                //write metadata 
                //deserialize the bdy 
                TokenRequestBody body = (TokenRequestBody) JSON.deserialize(res.getBody(), TokenRequestBody.class);
                Map<String, Object> keyValueMap = new Map<String, Object>();
                keyValueMap.put('Bearer_Token__c', body.access_token);
                keyValueMap.put('Date_expired__c', Datetime.now().addSeconds(body.expires_in));
                keyValueMap.put('Date_issued__c', DateTime.now());
                keyValueMap.put('Scope__c', body.scope);
                Create_And_deploy_MDT.createUpdateMetadata('Access_Token__mdt.test', 'test1', keyValueMap);
            }
     
    }
    return null;
}

public class TokenRequestBody{
    public String scope{set;get;}
    public string access_token{set;get;}
    public string token_type{set;get;}
    public String app_id{set;get;}
    public integer expires_in{set;get;}
    public String nonce{set;get;}
}
}
