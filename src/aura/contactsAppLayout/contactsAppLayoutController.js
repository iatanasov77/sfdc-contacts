({
	doInit 			: function( component, event, helper )
    {
        helper.loadAccounts( component );
        helper.initDataTable( component );
    },
    
    changeFilter	: function( component, event, helper )
    {
        // Init an Async Action
    	var action	= component.get( "c.getContacts" );
    	var params	= event.getParams();
    	if ( params.accountId === 'All' )
    	{
    		params.accountId	= null;
    	}
    	action.setParams( params );
    	
    	// Execute the Action and get a Promise
    	var promise	= helper.executeAction( action );
    	
    	// Resolve the Promise
    	promise.then(
			function( contacts )
			{
				var ldt			= component.find( 'contacts-ldt' );
				ldt.setData( contacts );
			},
			function( error )
			{
				alert( error );
			}
    	);
	},
    
    showDetails		: function ( component, event, helper )
    {
    	// Init an Async Action
    	var action	= component.get( "c.getContact" );
    	var params	= {
    		"contactId"	: event.getParam( 'contactId' )
    	};
    	action.setParams( params );
    	
    	// Execute the Action and get a Promise
    	var promise	= helper.executeAction( action );
    	
    	// Resolve the Promise
    	promise.then(
			function( contact )
			{
				var detailsBox	= component.find( 'contacts-detail-mini-box' );
				detailsBox.setData( contact.Id, contact.Name, contact.Email, contact.Phone );
			},
			function( error )
			{
				alert( error );
			}
    	);
    },
    
    deleteContact	: function ( component, event, helper )
    {
    	// Init an Async Action
    	var action	= component.get( "c.removeContact" );
    	
    	var params	= {
    		"contactId"	: event.getParam( 'contactId' )
    	};
    	action.setParams( params );
    	
    	// Execute the Action and get a Promise
    	var promise	= helper.executeAction( action );
    	
    	// Resolve the Promise
    	promise.then(
			function( response )
			{
				var res	= JSON.parse( response );
				
				alert( res.message );
				$A.get( 'e.force:refreshView' ).fire();
			},
			function( error )
			{
				alert( error );
			}
    	);
    }
})
