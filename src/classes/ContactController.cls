public class ContactController
{

   @AuraEnabled
    public static LightningDataTableResponse initDataTable()
    {   
        String strObjectName        = 'Contact';
        
        //Get the DataTable FieldSet for ObjectType Name
        Schema.FieldSet fieldSet    = MetadataServiceFactory.getFieldset( strObjectName );
        
        return LightningDataTableResponse.createResponse( strObjectName, fieldSet );
    }
    
	@AuraEnabled
    public static List<Contact> getContacts( String accountId )
    {
        List<String> fieldsList                 = LightningDataTableType.fieldsList( 'Contact' );
        LightningDataTableType.Filter filter    = new LightningDataTableType.Filter( 'accountId', accountId, '=' );
        
        String query            = LightningDataTableType.queryString( 'Contact', fieldsList, filter );
        List<Contact> contacts	= ( List<Contact> ) Database.query( query );

        return contacts;
    }
    
    @AuraEnabled
    public static List<Account> getAccounts()
    {
        List<Account> accounts	= [SELECT Id, Name FROM Account];

        return accounts;
    }
    
    @AuraEnabled
    public static Contact getContact( String contactId )
    {
        Contact contact = [SELECT Id, Name, Email, Phone FROM Contact WHERE Id = :contactId];

        return contact;
    }
    
    @AuraEnabled
    public static String removeContact( String contactId )
    {
        DeleteResponse response;
        
        Id userId                   = UserInfo.getUserId();
        List<UserRecordAccess> ura  = [SELECT HasDeleteAccess, RecordId FROM UserRecordAccess 
                                        WHERE RecordId = :contactId AND UserId = :userId];
        if ( ! ura[0].HasDeleteAccess )
        {
            response    = new DeleteResponse( true, 'You have not permission to delete this record!' );
        }
        
        Contact contact = [SELECT Id FROM Contact WHERE Id = :contactId];

        try {
            Database.DeleteResult res   = Database.delete( contact );
            response                    = new DeleteResponse( false, 'SUCCESS!' );
        }
        catch ( DmlException e )
        {
            response    = new DeleteResponse( true, e.getMessage() );
        }
        
        return JSON.serialize( response );
    }
}