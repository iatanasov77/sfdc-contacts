public with sharing class MetadataServiceFactory
{

    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service    = new MetadataService.MetadataPort();
        service.SessionHeader                   = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId         = Utils.getSessionIdFromVFPage( Page.SessionId );
        
        return service;
    }
}