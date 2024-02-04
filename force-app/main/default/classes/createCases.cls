public with sharing class createCases {
    public static void createCases(List<Account> accList) {
        List<Case> caseList = new List<Case>();
        for (Account acc : accList){
            Case newCase = new Case(OwnerId = acc.OwnerId, Origin = 'System', Priority = acc.CustomerPriority__c, Subject = acc.Name + '- Onboarding', AccountId = acc.Id);
            caseList.add(newCase);
        }
        insert caseList;
    }
}