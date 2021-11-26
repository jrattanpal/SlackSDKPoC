/*
    This example apex class provides details for populating views that display a record.
    For the methods that return a single sobject directly, see usage defined in 'view_contact', 'view_account', and 'view_opportunity.'
    For the method that returns data in a list for an iterator, see usage in 'record_detail_message.'
*/
public with sharing class Recruiting {
  private static String teamId = 'T02GGRQ8R0F';
  private static String channelId = 'C02GXGZJ30A';

  public static List<FieldData> getRecord(String recordId, String objectApiName) {
    Sobject record; 
    switch on objectApiName {
      when 'Interview__c' {record = getInterviewById(recordId); }
      when else { System.debug('record must be an Account, Contact, or Opportunity');}
    }
  
    Map<String,Object> fields = record.getPopulatedFieldsAsMap();
    List<FieldData> fieldsList = new List<FieldData>();
    
    for (String key : fields.keySet()) {
      FieldData fieldData = new FieldData(key, fields.get(key));
      fieldsList.add(fieldData);
    }

    System.debug(fieldsList);

    return fieldsList;
  }


  private static Interview__c getInterviewById(String recordId) {
    Interview__c obj = [
        SELECT Name
        FROM Interview__c
        WHERE Id = :recordId
        With SECURITY_ENFORCED
      ];
      return obj;
  }

  //Recruiting.notifyWithSFUserId('0050U0000076saN', 'New Interview Scheduled', 'a030U000004odv2QAA', 'Interview__c');
  public static Boolean sendTextWithSFUserId(String salesforceUserId, String message){
    Slack.App app = Slack.App.Recruiting.get();

    String slackUserId = app.getConnectedSlackUserId(teamId, salesforceUserId);
    return sendTextWithSlackUserId(slackUserId, message);
}
public static Boolean sendTextWithSlackUserId(String slackUserId, String message){
  Boolean retVal = false;
  Slack.App app = Slack.App.Recruiting.get();

  Slack.BotClient botClient = app.getBotClientForTeam(teamId);

  Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
              .channel(slackUserId)
              .text(message)
              .build();

  Slack.ChatPostMessageResponse response = botClient.ChatPostMessage(req);
  if(response.getError() != null) {
      System.debug(response.getError());
  }else{
    retVal = true;
  }
  //Slack.ChatPostMessageResponse response = botclient.chatPostMessage(req);
  System.debug('response: ' + response.isOk()); 
  return retVal;
}

public static Boolean sendViewWithSlackUserId(String slackUserId, Slack.ViewReference viewReference){
  Boolean retVal = false;
  Slack.App app = Slack.App.Recruiting.get();

  Slack.BotClient botClient = app.getBotClientForTeam(teamId);

  System.debug(viewReference);
  Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
              .channel(slackUserId)
              .viewReference(viewReference)
              .build();

  Slack.ChatPostMessageResponse response = botClient.ChatPostMessage(req);
  if(response.getError() != null) {
      System.debug(response.getError());
  }else{
    retVal = true;
  }
  //Slack.ChatPostMessageResponse response = botclient.chatPostMessage(req);
  System.debug('response: ' + response.isOk()); 
  return retVal;
}
  
  //Recruiting.notifyWithSFUserId('0050U0000076saN', 'New Interview Scheduled', 'a030U000004odv2QAA', 'Interview__c');
  public static Boolean notifyInterviewer(String salesforceUserId, String headerText, String recordId, String objectApiName){
    Slack.App app = Slack.App.Recruiting.get();

    String slackUserId = app.getConnectedSlackUserId(teamId, salesforceUserId);

    Slack.ViewReference viewReference = Slack.View.recruiting_interviewer_notificiation.get();
    viewReference.setParameter('headerText', headerText);
    viewReference.setParameter('recordId', recordId);
    viewReference.setParameter('objectApiName', objectApiName);

    return sendViewWithSlackUserId (slackUserId, viewReference);
}
/*
public static Boolean notifyWithSlackUserId(String slackUserId, String headerText, String recordId, String objectApiName){
  Slack.ViewReference viewReference = Slack.View.recruiting_interviewer_notificiation.get();
  viewReference.setParameter('headerText', headerText);
  viewReference.setParameter('recordId', recordId);
  viewReference.setParameter('objectApiName', objectApiName);

  return sendViewWithSlackUserId (slackUserId, viewReference);

}
/* */

  
}