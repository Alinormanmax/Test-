public class RecordTypeUtils {

    public static Id getRecordTypeId(String objectApiName, String recordTypeName) {
        try {
            return [SELECT Id FROM RecordType WHERE SObjectType = :objectApiName AND DeveloperName = :recordTypeName LIMIT 1].Id;
        } catch (QueryException e) {
            System.debug('Record Type not found: ' + e.getMessage());
            return null;
        }
    }
}