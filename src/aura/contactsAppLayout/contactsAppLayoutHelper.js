({

	// Execute an Async Action and return a Promise
	executeAction	: function( action )
	{
	    return new Promise( function( resolve, reject )
	    {
	        action.setCallback( this, function( response )
	        {
	            var state = response.getState();
	            
	            if ( state === "SUCCESS" )
	            {
	                var retVal	= response.getReturnValue();
	                resolve( retVal );
	            }
	            else if ( state === "ERROR" )
	            {
	                var errors	= response.getError();
	                if ( errors )
	                {
	                    if ( errors[0] && errors[0].message )
	                    {
	                        reject( Error( "Error message: " + errors[0].message ) );
	                    }
	                }
	                else {
	                    reject( Error( "Unknown error" ) );
	                }
	            }
	            else
	            {
	            	alert( 'UNKNOWN STATE!' );
	            }
	            
	        });
	        $A.enqueueAction( action );
	    });
	},
	
	initDataTable : function( cmp )
	{
		var action = cmp.get( "c.initDataTable" );
    	
    	// Execute the Action and get a Promise
    	var promise	= this.executeAction( action );
    	
    	// Resolve the Promise
    	promise.then(
			function( responseData )
			{
				cmp.set( 'v.columns', responseData.lstDataTableColumns );
				cmp.set( 'v.contacts', responseData.lstDataTableData );
			},
			function( error )
			{
				alert( error );
			}
    	);
    },
    
    loadAccounts : function( cmp )
    {
    	// Load all contact data
        var action = cmp.get( "c.getAccounts" );
        var promise	= this.executeAction( action );
    	
    	// Resolve the Promise
    	promise.then(
			function( responseData )
			{
				cmp.set( "v.accounts", responseData );
			},
			function( error )
			{
				alert( error );
			}
    	);
	},
	
	showStatus: function( state )
	{
		// Display toast message to indicate load status
        var toastEvent	= $A.get( "e.force:showToast" );
        if ( state === 'SUCCESS' )
        {
            toastEvent.setParams({
                "title": "Success!",
                "message": " Your contacts have been loaded successfully."
            });
        }
        else {
            toastEvent.setParams({
                "title": "Error!",
                "message": " Something has gone wrong."
            });
        }
        toastEvent.fire();
	}
})
