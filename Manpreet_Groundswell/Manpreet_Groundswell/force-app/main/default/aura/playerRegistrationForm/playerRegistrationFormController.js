({
    submitAction : function(component, event, helper) {
            var action = component.get("c.createContact");
            var FirstName = component.get('v.FirstName');
            var LastName = component.get('v.LastName');
            var Mobile = component.get('v.Mobile');
            var Email = component.get('v.Email');            
        
            action.setParams({ 
                "FirstName": FirstName,
                "LastName": LastName,
                "Mobile": Mobile,
                "Email": Email
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                 if (state === "SUCCESS") {
                     var serverResponse = response.getReturnValue();
                     console.log('serverResponse' ,serverResponse);
                    var gameid  = serverResponse[0].GameId__c;
                    var mobileno = serverResponse[0].Phone;               
                    var message = 'You have sucesfully Signed Up.Use this Game id' + '-- ' + gameid +'  to particapte in the game.';
                    helper.sendGameId(component, mobileno,message);
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
         $A.enqueueAction(action);

    },

})
