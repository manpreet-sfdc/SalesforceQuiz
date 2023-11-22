({
    sendGameId : function(component, mobileno, message) {
        var action = component.get("c.sendMessage");
        console.log('@@@@@Phone', mobileno);
        action.setParams({ 
            "mobileno": mobileno,
            "message": message
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
             if (state === "SUCCESS") {
                 var serverResponse = response.getReturnValue();
                 console.log('serverResponse' ,serverResponse);
                 component.set("v.FirstName", ""); 
                 component.set("v.Phone", "");
                 component.set("v.LastName", ""); 
                 component.set("v.Mobile", "");
                 component.set("v.Email", "");
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     title : 'Success',
                     message: message,
                     type: 'success',
                 });
                 toastEvent.fire();
             }
             else if (state === "INCOMPLETE") {
                console.log("No response from server or client is offline.")            }
            else if (state === "ERROR") {
                var errors = response.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                }
            } else {
                console.log("Unknown error");
            }
                // Show error message
            }
         });
     $A.enqueueAction(action)

    
},
})
