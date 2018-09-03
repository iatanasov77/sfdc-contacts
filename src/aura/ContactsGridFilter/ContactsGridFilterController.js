({
	fireFilterChanged : function( component, event, helper )
    {
    	var componentEvent	= component.getEvent( "filterChanged" );
        
        componentEvent.setParams({
            'accountId': event.getSource().get( "v.value" )
        });
		componentEvent.fire();
    }
})
