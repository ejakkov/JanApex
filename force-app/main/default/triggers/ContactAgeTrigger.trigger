trigger ContactAgeTrigger on Contact (before insert, before update) {
    ContactAgeClass.contactAge(Trigger.new);
}