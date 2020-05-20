({
    onPageReferenceChange : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var action= component.get("c.createTicketDataOnSuccess");
        var spinner = component.find("spinner");
        if(pageRef.state.c__status === "success"){
            var state = pageRef.state;
            var seatsList = state.c__seats.split(";");
            var tripId = state.c__tId;
            var amount = state.c__amount;
            var userId = state.c__uId;
            var invoice = state.c__invoice;
            action.setParams({seats : seatsList, userId : userId, tripId: tripId, amt: amount, invoice: invoice});
            action.setCallback(this, function(response){
                if(response.getState() === "SUCCESS"){
                    component.set("v.paymentStatus", true);
                    spinner.set("v.class", "slds-hide");
                    component.set("v.ticket", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
            
            
        }else {
            spinner.set("v.class", "slds-hide");
        }
    },
    goToSearch : function(component){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "lightning/page/home"
        });
        urlEvent.fire();
    }
})