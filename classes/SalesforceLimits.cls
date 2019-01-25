public with sharing class SalesforceLimits {

    public void Task1() {
        List<Contact> firstContacts = [SELECT Name FROM Contact LIMIT 200];
    }

    public void Task2() {
        List <Contact> con = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            con.add(new Contact(LastName = 'test', FirstName = 'test' + i));
        }
        insert con;
    }

    public void task3() {
        Set<String> allNames = new Set<String>();
        List<Contact> allContacts = [SELECT firstName FROM Contact LIMIT 50000];

        for (Contact contactItem: allContacts) {
            allNames.add(contactItem.firstName);
        }
        system.debug(allNames);
    }

    //task4
    public static void infect(List<Contact> ListContact) {
        Contact agentSmith = [SELECT Id FROM Contact LIMIT 1];
        for (Contact target : ListContact) {
            target.Description = agentSmith.id;
        }
    }



}