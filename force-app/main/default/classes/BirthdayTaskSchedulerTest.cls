@isTest
private class BirthdayTaskSchedulerTest {

    @isTest
    static void testPositive() {
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Test Industry');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Birthdate = Date.newInstance(2000, Date.today().month(), Date.today().addDays(-2).day()),
            AccountId = testAccount.Id
        );
        testContact.MailingStreet = '123 Test St';
        testContact.MailingCity = 'Test City';
        testContact.MailingState = 'Test State';
        testContact.MailingPostalCode = '12345';
        testContact.MailingCountry = 'Test Country';
        insert testContact;

        Test.startTest();
        BirthdayTaskScheduler.createBirthdayTasks();
        Test.stopTest();

        List<Task> tasks = [SELECT Id, Subject, ActivityDate, WhatId, Description FROM Task];
        System.assertEquals(1, tasks.size());

        Task createdTask = tasks[0];
        System.assertEquals(testContact.FirstName + ' ' + testContact.LastName + '\'s Birthday!', createdTask.Subject);
        System.assertEquals(testContact.Birthdate, createdTask.ActivityDate);
        System.assertEquals(testContact.AccountId, createdTask.WhatId);
        String expectedDescription = 'Today is the Birthdate of ' + testContact.FirstName + ' ' + testContact.LastName + '. He/She is now 24'  + ' years old.';
        expectedDescription += '\nThis Contact is an employee of ' + testAccount.Name + ', part of the ' + testAccount.Industry + ' Industry. Consider making an appropriate gift.';
        expectedDescription += '\nThe Mailing Address of the Contact is: 123 Test St, Test City, Test State, Test Country, 12345';
        System.assertEquals(expectedDescription, createdTask.Description);
    }

    @isTest
    static void testNegative() {
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Test Industry');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Birthdate = Date.newInstance(2000, Date.today().month(), Date.today().addDays(-4).day()),
            AccountId = testAccount.Id
        );
        testContact.MailingStreet = '123 Test St';
        testContact.MailingCity = 'Test City';
        testContact.MailingState = 'Test State';
        testContact.MailingPostalCode = '12345';
        testContact.MailingCountry = 'Test Country';
        insert testContact;

        Test.startTest();
        BirthdayTaskScheduler.createBirthdayTasks();
        Test.stopTest();

        List<Task> tasks = [SELECT Id, Subject, ActivityDate, WhatId, Description FROM Task];
        System.assertEquals(0, tasks.size());

        
    }
}
