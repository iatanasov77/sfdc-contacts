({

	// Initialize component data
    setData		: function ( component, event, helper )
    {
    	var args	= event.getParam( 'arguments' );
    	
    	component.set( 'v.Id', args.Id );
    	component.set( 'v.Name', args.Name );
    	component.set( 'v.Email', args.Email );
    	component.set( 'v.Phone', args.Phone );
    	
    	// Enable buttons
    	var btnGo	= component.find( 'btn-go' );
    	btnGo.set( 'v.disabled', false );
    	var btnDel	= component.find( 'btn-del' );
    	btnDel.set( 'v.disabled', false );
    },
    
    // Action: Go to Record
    goToRecord	: function ( component, event, helper )
    {
        var event 		= $A.get( "e.force:navigateToSObject" );
        var contactId	= component.get( "v.Id" );
        
        if ( event )
        {
            event.setParams({
	            "recordId"		: contactId,
	            "slideDevName"	: "detail"
            }).fire();

        }
        else if ( ( typeof sforce !== 'undefined' ) && ( typeof sforce.one !== 'undefined' ) )
        {
            sforce.one.navigateToSObject( contactId );
        }
        else
        {
            window.location.href = '/' + contactId;
        }
    },
    
    // Action: Delete Record
    deleteRecord	: function( component, event, helper )
    {
    	if ( prompt( 'Realy, do you want to delete this contact?' ) )
    	{
    		component.getEvent( "deleteContact" ).setParams({
    			'contactId': component.get( "v.Id" )
    		}).fire();
    	}
    }
})
