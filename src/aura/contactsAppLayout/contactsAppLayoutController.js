({
	doInit : function( component, event, helper )
    {
        // Retrieve contacts during component initialization
        helper.loadContacts( component );
        helper.loadAccounts( component );
    },
    
    changeFilter: function( component, event, helper )
    {
        var accountId	= event.getParam( "accountId" );
        var ldt			= component.find( 'contactsLDT' );

        ldt.setData( accountId );
	}

})
