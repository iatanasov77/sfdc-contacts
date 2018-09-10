({
    fireSelectedRowChanged	: function( component, event, helper )
    {
        var selectedRows	= event.getParam( 'selectedRows' );
        var cmpEvent		= component.getEvent( "selectedRowChanged" );
        
        cmpEvent.setParams({
            'contactId': selectedRows[0].Id
        });
		cmpEvent.fire();
    },
    
    setData		: function( component, event )
    {
    	var args	= event.getParam( 'arguments' );
    	console.log( args.contacts );
    	component.set( 'v.data', args.contacts );
    },
    
    setColumns	: function( component, event )
    {
    	var args	= event.getParam( 'arguments' );
    	
    	component.set( 'v.columns', args.columns );
    }
})