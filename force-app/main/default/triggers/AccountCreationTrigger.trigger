trigger AccountCreationTrigger on Account (after insert) {
        createCases.createCases(Trigger.new);
}