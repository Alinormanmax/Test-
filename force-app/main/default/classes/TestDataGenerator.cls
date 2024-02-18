public class TestDataGenerator {

    // Method to create X number of Accounts with Agency Record Type and a test contact
    public static List<Account> createTestAccounts(Integer numberOfAccounts, String recordType) {
        //List<Account> accounts = new List<Account>();

        List<Account> accountsToInsert = new List<Account>();
        for (Integer i = 0; i < numberOfAccounts; i++) {
            Account agency = new Account(
                Name = 'Test ' + recordType,
                RecordTypeId = getRecordTypeId('Account', 'Agency')
            );
/*
            // Create a test contact associated with the agency
            Contact testContact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i,
                AccountId = agency.Id
            );*/
            accountsToInsert.add(agency);
           // agencyIds.add(agency.Id);
        }

        insert accountsToInsert;

        if (recordType == 'Agency'){

        // Create Contacts
         List<Contact> contactsToInsert = new List<Contact>();
            for(Integer i = 0; i < numberOfAccounts; i++){
                Contact testContact = new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact' + i,
                    AccountId = accountsToInsert[i].Id
                );
                contactsToInsert.add(testContact);
            }
        
        insert contactsToInsert;
        }
        return accountsToInsert;
    }

    // Method to create X number of Accounts with Insured Record Type
    public static List<Id> createTestInsureds(Integer numberOfInsureds, String recordype) {
        List<Id> insuredIds = new List<Id>();

        List<Account> insuredsToInsert = new List<Account>();
        for (Integer i = 0; i < numberOfInsureds; i++) {
            Account insured = new Account(
                Name = 'Test Insured ' + i,
                RecordTypeId = getRecordTypeId('Account', 'Insured')
            );

            insuredsToInsert.add(insured);
            insuredIds.add(insured.Id);
        }

        insert insuredsToInsert;
        return insuredIds;
    }

    // Method to generate a random policy number following the specified format
    public static String generateRandomPolicyNumber() {
        return 'NMIS-' + String.valueOf(Math.floor(Math.random() * 9000000) + 1000000);
    }

    // Method to get RecordTypeId based on object and developer name
    private static Id getRecordTypeId(String objectName, String developerName) {
        Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.RecordTypeInfo> recordTypeInfoMap = objectType.getDescribe().getRecordTypeInfosByName();
        return recordTypeInfoMap.get(developerName).getRecordTypeId();
    }

    // Method to create 15 new Test Insureds, 5 new Test Agencies, and Opportunities
    public static void createTestData() {
        // Create 15 new Test Insureds
        List<Account> insureds = createTestAccounts(15, 'Insured');

        // Create 5 new Test Agencies
        List<Account> agencies = createTestAccounts(5, 'Agency');

        System.debug('Insureds: ' + insureds);
        System.debug('Agencies: ' + agencies);

        // Create Opportunities
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
        for (Account insuredAccount : insureds) {
            if (!agencies.isEmpty()) {
                Account agencyAccount = agencies[Math.round(Math.random() * (agencies.size() - 1))];

                // Debug statement to verify randomAgencyId
                System.debug('Random Agency : ' + agencyAccount);

                // Query for Insured Account outside the loop
               // Account insuredAccount = [SELECT Name FROM Account WHERE Id = :insuredId LIMIT 1];

                // Debug statement to verify the result of the SOQL query
                System.debug('Insured Account: ' + insuredAccount);

                Opportunity opportunity = new Opportunity(
                    Name = generateRandomPolicyNumber() + ' - ' + (insuredAccount != null ? insuredAccount.Name : 'Unknown'),
                    AccountId = insuredAccount.Id,
                    Agency__c = agencyAccount.Id,
                    Policy_Number__c = generateRandomPolicyNumber(),
                    CloseDate = Date.today(),
                    Effective_Date__c = Date.today().addDays((Integer)Math.round(Math.random() * 14)),
                    Expiration_Date__c = Date.today().addYears(1),
                    Cover_Type_1__c = 'Miscellaneous',
                    Cover_Type_2__c = 'Commercial Lines',
                    Cover_Type_3__c = 'Other',
                    TRIA_Sign_Date__c = Date.today(),
                    Type_of_Insurance__c = 'Direct',
                    Location_of_Risk_Country__c = 'United States of America',
                    StageName = 'Closed Won'
                );

                opportunitiesToInsert.add(opportunity);
            } else {
                // Add a debug statement to alert if there are no agencies
                System.debug('No agencies available');
            }
        }

        if (!opportunitiesToInsert.isEmpty()) {
            insert opportunitiesToInsert;
        } else {
            System.debug('No opportunities to insert');
        }
    }
}