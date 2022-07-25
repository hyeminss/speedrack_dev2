({
    getShipNo : function(cmp) {
		console.log("[ InvoiceInquiry HELPER ]");
        
        var action = cmp.get("c.getShipNo");
        action.setParams({ recordId : cmp.get("v.recordId")});
        action.setCallback(this, function(resp){
            var state = resp.getState();
            console.log('STATE : ' + state);
            if(state == 'SUCCESS') {
                console.log(resp.getReturnValue());
                cmp.set('v.order', resp.getReturnValue());
            }
        }); // action
        $A.enqueueAction(action);
	},
})