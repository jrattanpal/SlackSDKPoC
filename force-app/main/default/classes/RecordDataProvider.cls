/*
    This example apex class provides details for populating views that display a record.
    For the methods that return a single sobject directly, see usage defined in 'view_contact', 'view_account', and 'view_opportunity.'
    For the method that returns data in a list for an iterator, see usage in 'record_detail_message.'
*/
public class RecordDataProvider {

  public static List<FieldData> getRecord(String recordId, String objectApiName) {
    Sobject record; 
    switch on objectApiName {
      when 'Account' { record = getAccountById(recordId);  }
      when 'Contact' { record = getContactById(recordId);  }
      when 'Opportunity' {record = getOpportunityById(recordId); }
      when else { System.debug('record must be an Account, Contact, or Opportunity');}
    }
  
    Map<String,Object> fields = record.getPopulatedFieldsAsMap();
    List<FieldData> fieldsList = new List<FieldData>();
    for (String key : fields.keySet()) {
      FieldData fieldData = new FieldData(key, fields.get(key));
      fieldsList.add(fieldData);
  }

    return fieldsList;
  }

  public static Contact getContactById(String recordId) {
      Contact contact = [
        SELECT Name, Id, Title, Phone, Email
        FROM Contact
        WHERE Id = :recordId
      ];
      return contact;
  }

  public static Account getAccountById(String recordId) {
      Account account = [
        SELECT Name, Id
        FROM Account
        WHERE Id = :recordId
      ];
      return account;
  }

  public static Opportunity getOpportunityById(String recordId) {
      Opportunity opportunity = [
        SELECT Name, Id, Amount, StageName, CloseDate
        FROM Opportunity
        WHERE Id = :recordId
      ];
      return opportunity;
  }
}