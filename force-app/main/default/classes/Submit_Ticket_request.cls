public with sharing class Submit_Ticket_request {
    @AuraEnabled
    public static TripWrapper fetchSeatAndUserDetails(String tripInfo){
        TripWrapper wrapp = new TripWrapper();
        wrapp.userDetail.userInfo = [SELECT name from profile where id =: userInfo.getProfileId()][0].Name;
        wrapp.userDetail.userId = userInfo.getUserId();
        wrapp.seatsList = [SELECT Id, Occupied__c, Seat_Number__c, Ticket_Price__c from Seat__c WHERE Bus_Trip__c =: tripInfo ORDER BY Seat_Number__c ASC];
        wrapp.userDetail.userName = userInfo.getUserName();
        return wrapp;
    }
    @AuraEnabled
    public static string pay_And_Approve_Request(List<sObject> selectedSeats, Decimal TotalPrice, String tripId, String userId){
        List<String> seatIds = new List<String>();
        String approvalUrls ='';
        List<Access_Token__mdt> metaRecord = [SELECT Id, Bearer_Token__c from Access_Token__mdt WHERE Date_expired__c >: DateTime.now()];
        for(sObject seatId : selectedSeats){
            seatIds.add(String.ValueOf(seatId.get('Id')));
        }
        if(metaRecord.size()> 0){
            //prooced with payment request
            approvalUrls = processTransaction(metaRecord[0].Bearer_Token__c, seatIds, TotalPrice, tripId, userId);
        }else{
            //get bearer token
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Static_Utils.TOKEN_ENDPOINT);
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
                
                approvalUrls = processTransaction(body.access_token, seatIds, TotalPrice, tripId, userId);
                Create_And_deploy_MDT.createUpdateMetadata('Access_Token__mdt.test', 'test_123', JSON.serialize(keyValueMap));
            }
            
        }
        return approvalUrls;
    }
    @AuraEnabled
    public static Bus_Ticket__c createTicketDataOnSuccess(List<String> seats, String userId, String tripId, String amt, String invoice){
        AggregateResult  alreadyBooked = [SELECT Count(Id) from Bus_Ticket__c WHERE Invoice_Number__c =:invoice];
        if(alreadyBooked.get('expr0') == 0){
            Bus_Ticket__c ticket = new Bus_Ticket__c(Bus_Trip__c =tripId, user__c =userId, Invoice_Number__c= invoice, Ticket_cost__c= Decimal.valueOf(amt), Ticket_Status__c='Booked');
            insert ticket;
            if(userId != Userinfo.getUserId()){
                //share the record to user
            }
            //update seats number 
            List<Seat__c> seats_booked = new List<Seat__c>();
            Seat__c eachSeat;
            for(String seatId :seats){
                eachSeat = new Seat__c(Id =seatId, Tagged_Ticket__c =ticket.Id);
                seats_booked.add(eachSeat);
            }
            if(!seats_booked.isEmpty()){
                update seats_booked;
            }
            return [SELECT Id, Invoice_Number__c, Ticket_cost__c, Ticket_Status__c, (SELECT seat_number__c from seats__r) from Bus_Ticket__c where id =:ticket.Id]; 
        }
        return [SELECT Id, Invoice_Number__c, Ticket_cost__c, Ticket_Status__c, (SELECT seat_number__c from seats__r) from Bus_Ticket__c where Invoice_Number__c =:invoice][0];
        
    }
    private static String processTransaction(String token_access, List<String> seats, Decimal price , String tripId, string userId){
        
        string retUrl = '';
        string urlSuccess = Static_Utils.CALLBACK_ENDPOINT+'?c__status=success'+'&c__seats='+String.join(seats, ';')+'&c__tId='+tripId+'&c__amount='+price+'&c__uId='+userId+'&c__iospref=web';
        string urlFailure = Static_Utils.CALLBACK_ENDPOINT+'?c__status=failed'+'&c__iospref=web';
        Ticket_details details = new Ticket_details(price, urlSuccess, urlFailure);
        
        String body = JSON.serialize(details);
        body = body.replaceAll('currency_x', 'currency');
        String Auth_header = 'Bearer '+ token_access;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Static_Utils.PAYMENT_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', Auth_header);
        req.setBody(body);
        system.debug(body);
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if(res.getStatusCode() == 201){
            //deserializing the response 
            Payment_Callback_Class parsedObj = Payment_Callback_Class.parse(res.getBody());
            retUrl = parsedObj.links[1].href;
            system.debug('urls '+parsedObj.links[1]);
            
        }
        return retUrl;
    }
    
    public class TokenRequestBody{
        public String scope{set;get;}
        public string access_token{set;get;}
        public string token_type{set;get;}
        public String app_id{set;get;}
        public integer expires_in{set;get;}
        public String nonce{set;get;}
    }
    public class TripWrapper{
        @AuraEnabled
        public User_Details userDetail{set;get;}
        @AuraEnabled
        public List<Seat__c> seatsList{set;get;}
        public TripWrapper(){
            userDetail = new User_Details();
        }
    }
    public class User_Details{
        @AuraEnabled
        public string userInfo{set;get;}
        @AuraEnabled
        public string userId{set;get;}
        @auraEnabled
        public string userName{set;get;}
    }
}