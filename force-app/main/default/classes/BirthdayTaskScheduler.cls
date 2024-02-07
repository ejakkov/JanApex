global class BirthdayTaskScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        createBirthdayTasks();
    }

    public static void createBirthdayTasks() {
        List<Task> tasksToInsert = new List<Task>();

        Date twoDaysFromNow = Date.today().addDays(2);
        List<Contact> contacts = [SELECT Id, Name, Birthdate, OwnerId, AccountId, Account.Name, Account.Industry, MailingAddress FROM Contact];
        List<Contact> necessaryContacts = new List<Contact>();
        for (Contact con : contacts){
            if (Date.today().day() - con.Birthdate.day() <= 2){
                necessaryContacts.add(con);
            }
        }

        for (Contact con : necessaryContacts) {
            Task newTask = new Task();
            newTask.Subject = con.Name + '\'s Birthday!';
            newTask.OwnerId = con.OwnerId;
            newTask.Priority = 'Low';
            newTask.ActivityDate = con.Birthdate;
            newTask.WhatId = con.AccountId;

            String mailingAddressString = con.MailingAddress != null ? con.MailingAddress.getStreet() + ', ' +
            con.MailingAddress.getCity() + ', ' + con.MailingAddress.getState() + ', ' + con.MailingAddress.getCountry() + ', ' +
            con.MailingAddress.getPostalCode() : 'The mailing address is unknown.';
   
            String comments = 'Today is the Birthdate of ' + con.Name + '. He/She is now ' + yearsOld(con) + ' years old.';
            comments += '\nThis Contact is an employee of ' + con.Account.Name + ', part of the ' + con.Account.Industry + ' Industry. Consider making an appropriate gift.';
            comments += '\nThe Mailing Address of the Contact is: ' + (mailingAddressString != null ? mailingAddressString : 'The mailing address is unknown.');
            newTask.Description = comments;

            tasksToInsert.add(newTask);
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    public static Integer yearsOld (Contact con){
        return Date.today().year() - con.Birthdate.year();
    }

}
