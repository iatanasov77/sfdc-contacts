global class Utils
{
    global static String getSessionIdFromVFPage( PageReference page )
    {
        String content      = page.getContent().toString();
        List<String> res    = ( List<String> )JSON.deserialize( content, List<String>.class );
        
        return res.get( 0 );
    }
}