({
	getData : function( component, event )
	{
        var action = component.get( "c.getRecords" );
        //Set the Object parameters and Field Set name
        action.setParams({
            strObjectName	: 'Contact',
            strFieldSetName	: 'DataTableFieldSet'
        });
        
        action.setCallback( this, function( response )
        {
            var state	= response.getState();
            
            if( state === 'SUCCESS' )
            {
            	var responseData	= response.getReturnValue();
            	console.log( responseData.lstDataTableColumns );
            	
                component.set( "v.columns", responseData.lstDataTableColumns );
                component.set( "v.data", responseData.lstDataTableData );
            }
            else if ( state === 'ERROR' )
            {
                var errors	= response.getError();
                if (errors)
                {
                    if ( errors[0] && errors[0].message )
                    {
                        console.log( "Error message: " + errors[0].message );
                    }
                } else {
                    console.log( "Unknown error" );
                }
            }
            else
            {
                console.log( 'Something went wrong, Please check with your admin' );
            }
        });
        $A.enqueueAction( action );	
    }
})