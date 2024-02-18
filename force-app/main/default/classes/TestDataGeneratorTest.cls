@isTest
private class TestDataGeneratorTest {

    @isTest
    static void testCreateTestAgencies() {
        // Test creating 3 agencies
        List<Id> agencyIds = TestDataGenerator.createTestAgencies(3);
        System.assertNotEquals(0, agencyIds.size(), 'Agency creation failed');
    }

    @isTest
    static void testCreateTestInsureds() {
        // Test creating 2 insureds
        List<Id> insuredIds = TestDataGenerator.createTestInsureds(2);
        System.assertNotEquals(0, insuredIds.size(), 'Insured creation failed');
    }

    @isTest
    static void testGenerateRandomPolicyNumber() {
        // Test generating a random policy number
        String policyNumber = TestDataGenerator.generateRandomPolicyNumber();
        System.assertNotEquals(null, policyNumber, 'Policy number generation failed');
    }

    @isTest
    static void testCreateTestData() {
        // Start test execution
        Test.startTest();

        // Test creating test data
        TestDataGenerator.createTestData();

        // Add assertions to verify the data creation
        List<Opportunity> opportunities = [SELECT Id, Name, AccountId, Agency__c, Policy_Number__c,
                                           CloseDate, Effective_Date__c, Expiration_Date__c,
                                           Cover_Type_1__c, Cover_Type_2__c, Cover_Type_3__c,
                                           TRIA_Sign_Date__c, Type_of_Insurance__c, Location_of_Risk_Country__c,
                                           StageName
                                           FROM Opportunity];

        System.assertNotEquals(0, opportunities.size(), 'No opportunities were created');

        for (Opportunity opp : opportunities) {
            System.assertEquals('Closed Won', opp.StageName, 'Opportunity is not in Closed Won stage');
            System.assertNotEquals(null, opp.Effective_Date__c, 'Effective Date is not set');
            System.assertNotEquals(null, opp.Expiration_Date__c, 'Expiration Date is not set');
            // Add more assertions as needed for other fields
        }

        // Stop test execution
        Test.stopTest();
    }

}