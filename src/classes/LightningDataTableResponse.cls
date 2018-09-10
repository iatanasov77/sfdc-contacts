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
}