public with sharing class ContactTriggerHandler {

    public static void beforeInsert(List<Contact> contacts)  {
    }

    public static void afterInsert(List<Contact> contacts) {

        List<Contact> contactList = [SELECT Id, FirstName, LastName, Email, DummyJSON_Id__c FROM Contact WHERE Id IN :contacts];

         // if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value
        for(Contact contact : contactList) {
            if(contact.DummyJSON_Id__c == null) {
                Integer randomNumber = Integer.valueOf((Math.random() * 100));
                contact.DummyJSON_ID__c = String.valueOf(randomNumber);

                // if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
                if(Integer.valueOf(contact.DummyJSON_Id__c) <= 100) {
                    DummyJSONCallout.getDummyJSONUserFromId(contact.Id);
                    update contact;
                } 
            }
        }
        
    }

    
    public static void afterUpdate(List<Contact> contacts){
        // if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
        for(Contact contact : contacts){
                if(Integer.valueOf(contact.DummyJSON_Id__c) > 100) {
                    if(contact.DummyJSON_Last_Updated__c == null){
                        DummyJSONCallout.postCreateDummyJSONUser(contact.Id);
                    }
                } 
            } 

    }
}