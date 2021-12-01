/*
    This example apex class is responsible for responding to data provider requests
    for looking up account records. See usage defined in the 'create_contact' view.
*/
public with sharing class RecruitingLookupDataProvider {
    public static Slack.OptionDataResponse getAccountByName(String value) {
        String name = '%'+ value + '%';
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE :name
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
        List<Slack.Option> options = new List<Slack.Option>();
        for(Account a: Accounts) {
            Slack.Option option = new Slack.Option(a.Name, a.Id);   
            options.add(option);
        } 
        return new Slack.OptionDataResponse(options);
    }

    public static Slack.OptionDataResponse getContactByName(String value) {
        String name = '%'+ value + '%';
        List<Contact> contacts = [
            SELECT Id, Name
            FROM Contact
            WHERE Name LIKE :name
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
        List<Slack.Option> options = new List<Slack.Option>();
        for(contact c: contacts) {
            Slack.Option option = new Slack.Option(c.Name, c.Id);   
            options.add(option);
        } 
        return new Slack.OptionDataResponse(options);
    }


    public static Slack.OptionDataResponse getPositionByName(String value) {
        String name = '%'+ value + '%';
        List<Position__c> positions = [
            SELECT Id, Name
            FROM Position__c
            WHERE Name LIKE :name
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
        List<Slack.Option> options = new List<Slack.Option>();
        for(position__c p: positions) {
            Slack.Option option = new Slack.Option(p.Name, p.Id);   
            options.add(option);
        } 
        return new Slack.OptionDataResponse(options);
    }

}