trigger AutoSeatCreator on Bus_Trip__c (before insert , after insert, after update) {
    if(trigger.isInsert && Trigger.isAfter){
        //seats creation logic written here
        List<Seat__c> allSeats = new List<Seat__c>();
        seat__c eachSeat;
        for(Bus_Trip__c eachBus : Trigger.new){
            if(!eachBus.Cancelled__c){
                for(Integer seatNo =1; seatNo <= eachBus.Trip_Capacity__c; seatNo++){
                    eachSeat = new Seat__c(seat_number__c = seatNo, Bus_Trip__c =eachBus.Id); 
                    allSeats.add(eachSeat); 
                }
            }
        }
        if(!allSeats.isEmpty()){
            insert allSeats;
        } 
    }
    if(trigger.isUpdate){
        
    }
    if(trigger.isInsert && trigger.isBefore){
        for(Bus_Trip__c bTrip : Trigger.new){
            bTrip.Tickets_Remaining__c = bTrip.Trip_Capacity__c;
        }
    }
    
}