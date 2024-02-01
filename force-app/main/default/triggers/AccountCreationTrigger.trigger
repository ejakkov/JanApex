trigger AccountCreationTrigger on Account (before insert) {
    List<Account> accList = Trigger.new;
    List<Case> caseList = new List<Case>();
    for (Account acc : accList){
        Case newCase = new Case(OwnerId = acc.OwnerId, Origin = 'System', Priority = acc.CustomerPriority__c, Subject = acc.Name + '- Onboarding');
        caseList.add(newCase);
    }

    insert caseList;
}