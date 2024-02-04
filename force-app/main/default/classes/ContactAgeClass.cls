public with sharing class ContactAgeClass {
    public static void contactAge(List<Contact> conList) {
        List<Contact> listOfContacts = conList;
        Integer legalAge;
        Map<Id, String> accIdANDCountry = getCountryMap(conList);

        for(Contact con : listOfContacts){
            if(accIdANDCountry.get(con.AccountId) == 'US'){
                legalAge = 21;
            } else{
                legalAge = 18;
            }
            if(!isAgeValid(con, legalAge)){
                con.Birthdate.addError('Contact’s age cannot be lower than the legal age');
            }
        }
    }

    public static Boolean isAgeValid(Contact con, Integer legalAge){
        Date today = Date.today();
        Date birthdate = con.Birthdate;

        if(today.year() - birthdate.year() > legalAge){
            return true;
        } else if (today.year() - birthdate.year() == legalAge ){
            if(today.Month() - birthdate.Month() > 0){
                return true;
            } else if (today.Day() - birthdate.Day() >= 0 && today.Month() - today.Month() == 0){
                return  true;
            }
        }
        return false;
    }

    public static Map<Id, String> getCountryMap(List<Contact> conList){
        List<Id> accIdList = new List<Id>();
        for (Contact con : conList){
            accIdList.add(con.AccountId);
        }
        List<Account> accList = [SELECT Id, Country__c FROM Account WHERE Id IN :accIdList];
        Map<Id, String> accIdANDCountry = new Map<Id,String>();
        for(Account acc : accList){
            accIdANDCountry.put(acc.Id, acc.Country__c);
        }
        return accIdANDCountry;
    }
    }