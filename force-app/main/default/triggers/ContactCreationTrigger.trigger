trigger ContactCreationTrigger on Contact (after insert, after update) {
    addContactToRelatedCasesClass.addContactToRelatedCases(Trigger.new);
}