public with sharing class LightningDataTableResponse
{
    public class Column
    {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        
        //Create and set three variables label, fieldname and type as required by the lightning:datatable
        public Column( String label, String fieldName, String type )
        {
            this.label      = label;
            this.fieldName  = fieldName;
            this.type       = type;
        }
    }
    
    @AuraEnabled
    public List<Column> lstDataTableColumns {get;set;}
    @AuraEnabled
    public List<sObject> lstDataTableData {get;set;}
    
    /**
     *  @brief  Main constructor
     */
    public LightningDataTableResponse()
    {
        lstDataTableColumns = new List<Column>();
        lstDataTableData    = new List<sObject>();
    }
    
    public static LightningDataTableResponse createResponse( String strObjectName, Schema.FieldSet fieldSet )
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