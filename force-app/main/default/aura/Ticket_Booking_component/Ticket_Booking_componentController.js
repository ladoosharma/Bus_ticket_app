({
    fetchSeatData: function (component, event, helper) {
        var action = component.get("c.fetchSeatAndUserDetails");
        action.setParams({ tripInfo: component.get("v.tripId") });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var value = response.getReturnValue();
                var seatList =[];
                var seatObj ={};
                var listLen = value.seatsList.length;
                for(var seat of value.seatsList){
                    seatObj[seat.Id] = seat;
                }
                while(value.seatsList.length){
                    seatList.push(value.seatsList.splice(0, listLen/2))
                }
                component.set("v.seatMap", seatObj);
                component.set("v.seatList", seatList);
                component.set("v.userType", value.userDetail);
            }
        });
        $A.enqueueAction(action);
    },

    selectSeats: function (component, event, helper) {
        var source = event.getSource();
        var seatCost = component.get("v.seatList")[0][0].Ticket_Price__c;
        var selectedSeats = component.get("v.selectedSeats");
        if(source.get("v.class") === "selected"){
            if(selectedSeats.includes(source.get("v.name"))){
                selectedSeats.pop(source.get("v.name")) ;
                component.set("v.selectedSeats", selectedSeats);
                source.set("v.class", "");
            }
        }else{
            if(!selectedSeats.includes(source.get("v.name"))){
                selectedSeats.push(source.get("v.name")) ;
                component.set("v.selectedSeats", selectedSeats);
                source.set("v.class", "selected");
            }
        }
        if(selectedSeats){
            component.set("v.totalCost", (selectedSeats.length)*seatCost);
        }
    },
    payAmount : function(component, event, helper){
        var seatMap = component.get("v.seatMap");
        var occupiedSeatDetail=[];

        if(component.get("v.selectedSeats")){
            for(var item of component.get("v.selectedSeats")){
                occupiedSeatDetail.push(seatMap[item]);
            }
            var action = component.get("c.pay_And_Approve_Request");
            action.setParams({selectedSeats: occupiedSeatDetail, TotalPrice: component.get("v.totalCost"), tripId: component.get("v.tripId")});
            action.setCallback(this, function(response){
                if(response.getState()==="SUCCESS"){
                    if(response.getReturnValue()){
                        window.open(response.getReturnValue(), "_parent");
                    }
                    
                }
            });
            $A.enqueueAction(action);
        }else{
            //thow message that please select seats
        }
    }
})