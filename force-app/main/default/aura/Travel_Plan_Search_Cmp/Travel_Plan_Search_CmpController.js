({
    handleLookupData: function (component, event, helper) {
        //console.log('test');
        //debugger;
        var eventData = event.getParam("dataMap");
        if (eventData.lookupName === "TO") {
            component.set("v.ToLocation", eventData.data.Id);
        } else if (eventData.lookupName === "FROM") {
            component.set("v.FromLocation", eventData.data.Id);
        }
        //console.log(eventData);

    },
    searchHandler: function (component, event, helper) {
        var action = component.get("c.getBusTrips");
        action.setParams({
            fromAddr: component.get("v.FromLocation"),
            toAddr: component.get("v.ToLocation")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ListOfBusTravel", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

    }
    ,
    redirectToTicketBooking: function (component, event) {
        var tripDetail = event.currentTarget.dataset.id;
        if (tripDetail) {
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef: "c:Ticket_Booking_component",
                componentAttributes: {
                    tripId: tripDetail
                }
            });
            evt.fire();

        }
    }
})