({
	doInit : function( component, event, helper )
    {
        // Retrieve contacts during component initialization
        helper.loadContacts( component );
        helper.loadAccounts( component );
    },
    
    changeFilter: function( component, event, helper )
    {
        var accountId		= event.getParam( "accountId" );
        var cmpContactsGrid	= component.find( 'ContactsGrid' );

        cmpContactsGrid.setData( accountId );
        //alert( 'Layout filter event handler is calling with account ID: ' + accountId );
	}

})
