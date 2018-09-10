public class ContactController extends LightningDataTableController
{
  
	@AuraEnabled
    public static List<Contact> getContacts( String accountId )
    {
        List<Contact> contacts	= [SELECT Id, Name, MailingStreet, Phone, Email, LeadSource FROM Contact WHERE accountId = :accountId];

        //Add isAccessible() check
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
            Database.DeleteResult res    = Database.delete( contact );
            response    = new DeleteResponse( false, 'SUCCESS!' );
        }
        catch ( DmlException e )
        {
            response    = new DeleteResponse( true, e.getMessage() );
        }
        
        return JSON.serialize( response );
    }
    
    @AuraEnabled
    public static String testRemoveContact( String contactId )
    {
        return JSON.serialize( new DeleteResponse( true, 'You have not permission to delete this record!' ) );
    }
}