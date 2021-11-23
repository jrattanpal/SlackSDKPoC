/*
    This example apex class is responsible for responding to data provider requests
    for looking up account records. See usage defined in the 'create_contact' view.
*/
public class AccountLookupDataProvider {

    public static Slack.OptionDataResponse getAccountsByName(String value) {
        String name = '%'+ value + '%';
        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE :name
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
        List<Slack.Option> accountOptions = new List<Slack.Option>();
        for(Account account: accounts) {
            Slack.Option option = new Slack.Option(account.Name, account.Id);   
            accountOptions.add(option);
        } 
        return new Slack.OptionDataResponse(accountOptions);
    }

}