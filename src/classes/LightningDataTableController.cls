/**
 * @brief   Get data records for Lightning:DataTable component
 * @author  ivan.atanasov@accenture.com
 */
public abstract class LightningDataTableController
{
    private static String strFieldSetName = 'LightningDataTable';
    
    /**
     *  Method Name : getRecords
     *  Purpose     : To get the wrapper of Columns and Headers
     */
    @AuraEnabled
    public static DataTableResponse getRecords( String strObjectName )
    {   
        //Get the fields from FieldSet
        Schema.DescribeSObjectResult describe   = Schema.getGlobalDescribe().get( strObjectName ).getDescribe();
        Schema.FieldSet fieldSetObj             = describe.fieldSets.getMap().get( strFieldSetName );
        if ( fieldSetObj == Null )
        {
            fieldSetObj = createFieldset( strObjectName );
        }
        
        //To hold the table hearders 
        List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
        
        //Field to be queried - fetched from fieldset
        List<String> lstFieldsToQuery = new List<String>();
        
        //The final wrapper response to return to component
        DataTableResponse response = new DataTableResponse();
        
        if( fieldSetObj != null )
        {
            for( Schema.FieldSetMember eachFieldSetMember : fieldSetObj.getFields() )
	        {
	            String dataType = String.valueOf(eachFieldSetMember.getType()).toLowerCase();
	            //This way we can set the type of a column
	            //We do not get the exact type from schema object which matches to lightning:datatable component structure
	            if(dataType == 'datetime')
	            {
	                dataType = 'date';
	            }
	            //Create a wrapper instance and store label, fieldname and type.
	            DataTableColumns datacolumns = new DataTableColumns( String.valueOf(eachFieldSetMember.getLabel()) , 
	                                                                String.valueOf(eachFieldSetMember.getFieldPath()), 
	                                                                String.valueOf(eachFieldSetMember.getType()).toLowerCase() );
	            lstDataColumns.add( datacolumns );
	            lstFieldsToQuery.add( String.valueOf( eachFieldSetMember.getFieldPath() ) );
	        }
        }
        
        //Form an SOQL to fetch the data - Set the wrapper instance and return as response
        if( ! lstDataColumns.isEmpty() )
        {
            response.lstDataTableColumns = lstDataColumns;
            String query = 'SELECT Id, ' + String.join( lstFieldsToQuery, ',' ) + ' FROM ' + strObjectName;
            System.debug(query);
            response.lstDataTableData = Database.query(query);
        }
        
        return response;
    }
    
    //Wrapper class to hold Columns with headers
    public class DataTableColumns
    {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        
        //Create and set three variables label, fieldname and type as required by the lightning:datatable
        public DataTableColumns(String label, String fieldName, String type)
        {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;            
        }
    }
    
    //Wrapper calss to hold response - This response is used in the lightning:datatable component
    public class DataTableResponse
    {
        @AuraEnabled
        public List<DataTableColumns> lstDataTableColumns {get;set;}
        @AuraEnabled
        public List<sObject> lstDataTableData {get;set;}                
        
        public DataTableResponse()
        {
            lstDataTableColumns = new List<DataTableColumns>();
            lstDataTableData = new List<sObject>();
        }
    }
    
    private static Schema.FieldSet createFieldset( String strObjectName )
    {
        MetadataService.FieldSet fieldSet   = new MetadataService.FieldSet();
        
        fieldSet.fullName       = strObjectName + '.' + strFieldSetName;
        fieldSet.label          = strFieldSetName;
        fieldSet.description    = 'Used by Lightning DataTable component';
        
        for ( String field : getFieldsList( strObjectName ) )
        {
            fieldSet.availableFields                        = new List<MetadataService.FieldSetItem>();
            MetadataService.FieldSetItem availableField     = new MetadataService.FieldSetItem();
	        availableField.field                            = field;
	        //availableField.isFieldManaged                 = false;
	        //availableField.isRequired                     = false;
	        
	        fieldSet.availableFields.add( availableField );
        }
    
        // Create 
        list<MetadataService.Metadata> metadata = new list<MetadataService.Metadata>();
        metadata.add( fieldSet );
        List<MetadataService.SaveResult> results   = createService().createMetadata( metadata );
        
        // @TODO I should try to get Schema.FieldSet from the MetaDataService result
        
        return Schema.getGlobalDescribe().get( strObjectName ).getDescribe().fieldSets.getMap().get( strFieldSetName );
    }
    
    private static List<String> getFieldsList( String strObjectName )
    {
        Type t                                      = Type.forName( 'LightningDataTableType.' + strObjectName );
        LightningDataTableType.FieldsList fieldsList = ( LightningDataTableType.FieldsList )t.newInstance();
        
        return fieldsList.getFieldsList();
    }
    
    public static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service    = new MetadataService.MetadataPort();
        service.SessionHeader                   = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId         = UserInfo.getSessionId();
        
        return service;
    }
}
