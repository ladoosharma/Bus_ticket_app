trigger SeatCreation on Bus__c (after insert) {
    List<Seat__c> allSeats = new List<Seat__c>();
    seat__c eachSeat;
    for(Bus__c eachBus : Trigger.new){
        if(eachBus.Is_operational__c){
            for(Integer seatNo =1; seatNo <= eachBus.Total_capacity__c; seatNo++){
                eachSeat = new Seat__c(seat_number__c = seatNo, Bus__c =eachBus.Id); 
                allSeats.add(eachSeat); 
            }
        }
    }
    if(!allSeats.isEmpty()){
        insert allSeats;
    }
}