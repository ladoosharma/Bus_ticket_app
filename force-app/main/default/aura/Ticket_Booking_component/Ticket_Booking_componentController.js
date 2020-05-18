({
    fetchSeatData: function (component, event, helper) {
        var action = component.get("c.fetchSeatAndUserDetails");
        action.setParams({ tripInfo: component.get("v.tripId") });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var value = response.getReturnValue();
                var seatList =[];
                var listLen = value.seatsList.length;

                while(value.seatsList.length){
                    seatList.push(value.seatsList.splice(0, listLen/2))
                }
                component.set("v.seatList", seatList);
                component.set("v.userType", value.userInfo);
            }
        });
        $A.enqueueAction(action);
    },

    selectSeats: function (component, event, helper) {
        var source = event.getSource();
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
    }
})
