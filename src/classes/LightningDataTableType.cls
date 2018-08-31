global class LightningDataTableType
{
    
    public interface FieldsList { List<String> getFieldsList(); }
    
    public class Contact implements FieldsList
    {
        public List<String> getFieldsList()
        {
            return new List<String> {'Name', 'Department', 'Account.Name', 'Birthdate', 'CleanStatus'};
        }
    }
    
}
