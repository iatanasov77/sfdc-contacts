public with sharing class MetadataServiceFactory
{

    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service    = new MetadataService.MetadataPort();
        service.SessionHeader                   = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId         = Utils.getSessionIdFromVFPage( Page.SessionId );
        
        return service;
    }
    
    public static Schema.FieldSet getFieldset( String strObjectName )
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
}