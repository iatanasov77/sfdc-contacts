({
	doInit					: function ( component, event, helper )
	{
		helper.getData( component, event );
    },
    
    fireSelectedRowChanged	: function( component, event, helper )
    {
        var selectedRows	= event.getParam( 'selectedRows' );
        var cmpEvent		= component.getEvent( "selectedRowChanged" );
        
        cmpEvent.setParams({
            'contactId': selectedRows[0].Id
        });
		cmpEvent.fire();
    }
})