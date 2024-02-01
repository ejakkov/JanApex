@isTest
public with sharing class casesAfterAcctTriggerTest {
    @isTest
    public static void testCases(){
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<150; i++){
            Account newAcc = new Account(Name = 'Test' + i, CustomerPriority__c = 'High');
            accList.add(newAcc);
        }
        for(Integer i=0; i<150; i++){
            Account newAcc = new Account(Name = 'Test' + i + 149, CustomerPriority__c = 'Low');
            accList.add(newAcc);
        }

        Test.startTest();
        insert accList;
        Test.stopTest();

        List<Case> caseListLow = [SELECT Id FROM Case WHERE Origin = 'System' AND Priority = 'Low'];

        List<Case> caseListHigh = [SELECT Id FROM Case WHERE Origin = 'System' AND Priority = 'High'];
        System.assertEquals(caseListLow.size(), 150);
        System.assertEquals(caseListHigh.size(), 150);
        System.assertEquals(caseListLow.size() + caseListHigh.size(), accList.size());


    }
}