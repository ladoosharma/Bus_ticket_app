({
    fetchSeatData : function(component, event, helper) {
        var action = component.get("c.fetchSeatAndUserDetails");
        action.setParams({tripInfo : component.get("v.tripId")});
        action.setCallback(this, function(response){
          if(response.getState() === "SUCCESS")  {
              var value = response.getReturnValue();
              component.set("v.seatList", value.seatsList);
              component.set("v.userType", value.userInfo);
          }
        });
        $A.enqueueAction(action);
    }
})
