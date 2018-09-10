public class DeleteResponse
{
    Boolean error;
    String message;
    
    public DeleteResponse( Boolean err, String msg )
    {
        this.error      = err;
        this.message    = msg;
    }
    
    public override String toString()
    {
        return JSON.serialize( this );
    }
}
