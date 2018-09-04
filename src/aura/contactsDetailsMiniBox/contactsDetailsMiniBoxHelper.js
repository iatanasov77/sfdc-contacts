({
	load	: function( contactId, component )
	{
		var action	= cmp.get( "c.getContacts" );
        action.setCallback( this, function(response ) 
        {
            var state	= response.getState();
            if ( state === "SUCCESS" )
            {
                cmp.set( "v.currentYear", today.getFullYear() );
            }
        });
        $A.enqueueAction( action );
	}
})