public with sharing class addContactToRelatedCasesClass {
    public static void addContactToRelatedCases(List<Contact> conList) {
        List<Id> accId = new List<Id>();
        Map<Id, Id> conAndAcc = new Map<Id, Id>();
        List<Case> casesToUpdate = new List<Case>();
        for (Contact con : conList){
            if (con.Level__c == 'Primary'){
                accId.add(con.AccountId);
                conAndAcc.put(con.AccountId, con.Id);
            }
        }   

        if (!accId.isEmpty()) {
            List<Case> caseList = [SELECT Id, AccountId, ContactId FROM Case WHERE AccountId IN :accId];
            for (Case thisCase : caseList){
                if(thisCase.ContactId == null && conAndAcc.containsKey(thisCase.AccountId)){
                    thisCase.ContactId = conAndAcc.get(thisCase.AccountId);
                    casesToUpdate.add(thisCase);
                }
            }
        }
            if (!casesToUpdate.isEmpty()) {
                update casesToUpdate;
            }
        }
    }
