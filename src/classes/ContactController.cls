public with sharing class ContactController
{
    class DeleteResponse
    {
        Boolean error;
        String message;
        public DeleteResponse( Boolean err, String msg )
        {
            this.error      = err;
            this.message    = msg;
        }
    }

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
    public static String deleteContact( String contactId )
    {System.debug( 'Delete Contact: ' + contactId );
        //Contact contact = [SELECT Id FROM Contact WHERE Id = :contactId];

        try {
            return 'SUCCESS';
            //Database.delete( contact );
        }
        catch ( DmlException e )
        {
            
            //return new DeleteResponse( true, e.getMessage() );
        }
        return 'SUCCESS';
        //return new DeleteResponse( false, 'SUCCESS!' );
    }
}
