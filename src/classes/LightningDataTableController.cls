/**
 * @brief   Get data records for Lightning:DataTable component
 * @author  ivan.atanasov@accenture.com
 */
public virtual class LightningDataTableController
{
    /**
     *  Method Name : getRecords
     *  Purpose     : To get the wrapper of Columns and Headers
     */
    @AuraEnabled
    public static LightningDataTableResponse getRecords( String strObjectName )
    {   
        //Get the DataTable FieldSet for ObjectType Name
        Schema.FieldSet fieldSet    = getFieldset( strObjectName );
        
        return createResponse( strObjectName, fieldSet );
    }
    
    private static Schema.FieldSet getFieldset( String strObjectName )
    {
        //Get the fields from FieldSet
        Schema.DescribeSObjectResult describe   = Schema.getGlobalDescribe().get( strObjectName ).getDescribe();
        Schema.FieldSet fieldSetObj             = describe.fieldSets.getMap().get( LightningDataTableType.FieldSetName );
        
        if ( fieldSetObj == Null )
        {
            MetadataService.FieldSet fs                 = LightningDataTableType.getFieldset( strObjectName );
        
	        list<MetadataService.Metadata> metadata     = new list<MetadataService.Metadata>();
	        metadata.add( fs );
	        
	        List<MetadataService.SaveResult> results    = MetadataServiceFactory.createService().createMetadata( metadata );
	       
	        // @TODO I should try to get Schema.FieldSet from the MetaDataService result 
	        fieldSetObj                                =  Schema.getGlobalDescribe().get( strObjectName ).getDescribe()
	                                                       .fieldSets.getMap().get( LightningDataTableType.FieldSetName );
        }
        
        return fieldSetObj;
    }

    private static LightningDataTableResponse createResponse( String strObjectName, Schema.FieldSet fieldSet )
    {
        
        List<String> lstFieldsToQuery       = new List<String>();
        LightningDataTableResponse response = new LightningDataTableResponse();
        
        for( Schema.FieldSetMember eachFieldSetMember : fieldSet.getFields() )
        {
            String dataType = String.valueOf( eachFieldSetMember.getType() ).toLowerCase();
            if( dataType == 'datetime' )
            {
                dataType    = 'date';
            }
            LightningDataTableResponse.Column column    = new LightningDataTableResponse.Column( 
                                                            String.valueOf( eachFieldSetMember.getLabel() ),
                                                            String.valueOf( eachFieldSetMember.getFieldPath() ), 
                                                            String.valueOf( eachFieldSetMember.getType()).toLowerCase()
                                                        );
            response.lstDataTableColumns.add( column );
            
            lstFieldsToQuery.add( String.valueOf( eachFieldSetMember.getFieldPath() ) );
        }
        
        //Form an SOQL to fetch the data
        if( ! lstFieldsToQuery.isEmpty() )
        {
            String query                = LightningDataTableType.queryString( strObjectName, lstFieldsToQuery );
            System.debug( query );
            response.lstDataTableData   = Database.query( query );
        }
        
        return response;
    }
}