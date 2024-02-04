@isTest

private with sharing class ContactTriggerTest {
    
    private static Integer numOfAcc = 100;
    private static Integer numOfCases = 3;
    @testSetup static void setup() {

        List<Account> testAccts = new List<Account>();
        List<Case> testCases = new List<Case>();

        for(Integer i=0;i<numOfAcc; i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i));
        }
        insert testAccts;        

        testAccts = [SELECT Id FROM Account];

        for (Account acc : testAccts){
            for(Integer i=0; i<numOfCases; i++){
                Case newCase = new Case(Status= 'New', Origin='Web', AccountId = acc.Id);
                testCases.add(newCase);
            }
        }
        insert testCases;
    }

    @isTest
    private static void checkPositive(){
        List<Account> accList = [SELECT Id, Name FROM Account];
        List<Case> casesList = [SELECT Id FROM Case];

        List<Contact> conList = new List<Contact>();
        for (Account acc : accList){
            Contact newCon = new Contact(LastName = 'test' + acc.Name, AccountId = acc.Id, Level__c = 'Primary');
            conList.add(newCon);
        }
    
        Test.startTest();
        insert conList;
        Test.stopTest();
    
        casesList = [SELECT Id FROM Case WHERE ContactId != null];
        List<AggregateResult> results = [SELECT ContactId, COUNT(Id) recordCount FROM Case WHERE ContactId != null GROUP BY ContactId];
        for (AggregateResult result : results){
            System.assertEquals(result.get('recordCount'), 4); 
        }
        System.assertEquals(casesList.size(), numOfAcc * numOfCases + numOfCases);
 
    }

    @isTest
    private static void checkNegative(){
        List<Account> accList = [SELECT Id, Name FROM Account];
        List<Case> casesList = [SELECT Id FROM Case];

        List<Contact> conList = new List<Contact>();
        for (Account acc : accList){
            Contact newCon = new Contact(LastName = 'test' + acc.Name, AccountId = acc.Id, Level__c = 'Secondary');
            conList.add(newCon);
        }
    
        Test.startTest();
        insert conList;
        Test.stopTest();
    
        casesList = [SELECT Id FROM Case WHERE ContactId != null];
        System.assertEquals(casesList.size(), 0); 
    }


    @isTest
    private static void checkAlreadyAssignedCases(){
        List<Account> accList = [SELECT Id, Name FROM Account];
        List<Case> casesList = [SELECT Id, ContactId FROM Case LIMIT 10];
        List<Case> casesToUpdate = new List<Case>();
        for (Case c : casesList){
            c.ContactId = '0032o00003XeSXIAA3';
            casesToUpdate.add(c);
        }

        update casesToUpdate;

        List<Contact> conList = new List<Contact>();
        for (Account acc : accList){
            Contact newCon = new Contact(LastName = 'test' + acc.Name, AccountId = acc.Id, Level__c = 'Primary');
            conList.add(newCon);
        }
    
        Test.startTest();
        insert conList;
        Test.stopTest();
    
        casesList = [SELECT Id FROM Case WHERE ContactId =:'0032o00003XeSXIAA3' ];
        System.assertEquals(casesList.size(), 10); // make sure that already populated fields were not overwritten


    }
}