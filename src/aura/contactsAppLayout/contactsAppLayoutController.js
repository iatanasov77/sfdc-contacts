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
        var ldt			= component.find( 'contacts-ldt' );

        ldt.setData( accountId );
	},
    
    showDetails	: function ( component, event, helper )
    {
    	var contactId	= event.getParam( 'contactId' );
    	var detailsBox	= component.find( 'contacts-detail-mini-box' );
    	
    	detailsBox.setData( contactId )
    }
})