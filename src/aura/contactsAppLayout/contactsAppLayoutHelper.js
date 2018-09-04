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
	
	loadContacts	: function( cmp )
    {
        // Load all contact data
        var action = cmp.get( "c.getContacts" );
        action.setCallback( this, function( response ) 
        {
            var state	= response.getState();
            if ( state === "SUCCESS" )
            {
                var today	= new Date();
                
                cmp.set( "v.currentYear", today.getFullYear() );
                cmp.set( "v.contacts", response.getReturnValue() );
                cmp.set( "v.contactList", response.getReturnValue() );
                
                //this.showStatus( status );
                //this.updateTotal( cmp );
            }
        });
        $A.enqueueAction( action );
    },
    
    loadAccounts : function( cmp )
    {
    	// Load all contact data
        var action = cmp.get( "c.getAccounts" );
        action.setCallback( this, function( response )
        {
            var state	= response.getState();
            if ( state === "SUCCESS" )
            {
                cmp.set( "v.accounts", response.getReturnValue() );
            }

        });
        $A.enqueueAction( action );
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