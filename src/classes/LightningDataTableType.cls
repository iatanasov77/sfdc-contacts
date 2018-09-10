global class LightningDataTableType
{
    
    public static String FieldSetName = 'LightningDataTable';
    
    public static MetadataService.FieldSet getFieldset( String objectName )
    {
        FieldsetParams fp                   = ( FieldsetParams )Type.forName( 'LightningDataTableType.' + objectName )
                                                                    .newInstance();
        MetadataService.FieldSet fieldSet   = new MetadataService.FieldSet();
        
        fieldSet.fullName                   = fp.fullName();
        fieldSet.label                      = fp.name();
        fieldSet.description                = 'Used by Lightning DataTable component';
        
        fieldSet.displayedFields            = new List<MetadataService.FieldSetItem>();
        for ( String field : fp.fieldsList() )
        {
            MetadataService.FieldSetItem fieldItem  = new MetadataService.FieldSetItem();
            fieldItem.field                         = field;
            
            fieldSet.displayedFields.add( fieldItem );
        }
        
        return fieldSet;
    }
    
    public interface FieldsetParams
    {
        List<String> fieldsList();
        String name();
        String fullName();
    }
    
    public class Contact implements FieldsetParams
    {
        public List<String> fieldsList()
        {
            return new List<String> {'Name', 'Department', 'Account.Name', 'Birthdate', 'CleanStatus'};
        }
        
        public String name()
        {
            return FieldSetName;
        }
        
        public String fullName()
        {
            return 'Contact.' + FieldSetName;
        }
    }
}