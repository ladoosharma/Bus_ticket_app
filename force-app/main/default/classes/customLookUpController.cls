public class customLookUpController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String Fields) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name, '+ Fields+' from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    @AuraEnabled
    public static List<Bus_Trip__c> getBusTrips(String fromAddr, String toAddr){
      return [SELECT id, Bus__r.Name, Bus__r.Ticket_price__c, Trip_duration__c, Trip_timing__c, Tickets_Remaining__c, Trip_Capacity__c from Bus_Trip__c
       where From_location__c =: fromAddr AND To_location__c =: toAddr AND Cancelled__c = false];  
    }

   

    
}