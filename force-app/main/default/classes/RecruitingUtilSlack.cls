public with sharing class RecruitingUtilSlack {
    

    private static String teamId = 'T02GGRQ8R0F';
    private static String channelId = 'C02GXGZJ30A';
    
    //Recruiting.notifyWithSFUserId('0050U0000076saN', 'New Interview Scheduled', 'a030U000004odv2QAA', 'Interview__c');
    public static Boolean sendTextWithSFUserId(String salesforceUserId, String message){
        Slack.App app = Slack.App.Recruiting.get();
        
        String slackUserId = app.getConnectedSlackUserId(teamId, salesforceUserId);
        return sendTextWithSlackUserId(slackUserId, message);
    }
    //Build message to be send with .text() method for Slack.ChatPostMessageRequest
    public static Boolean sendTextWithSlackUserId(String slackUserId, String message){
        Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
            .channel(slackUserId)
            .text(message)
            .build();
        return sendWithBotClient(teamId, req);
    }

    //Recruiting.notifyWithSFUserId('0050U0000076saN', 'New Interview Scheduled', 'a030U000004odv2QAA', 'Interview__c');
    public static Boolean sendViewWithSFUserId(String salesforceUserId, Slack.ViewReference viewReference){
        Slack.App app = Slack.App.Recruiting.get();
        
        String slackUserId = app.getConnectedSlackUserId(teamId, salesforceUserId);
        return sendViewWithSlackUserId(slackUserId, viewReference);
    }
    //Build message to be send with .viewReference() method for Slack.ChatPostMessageRequest
    public static Boolean sendViewWithSlackUserId(String slackUserId, Slack.ViewReference viewReference){
        Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
            .channel(slackUserId)
            .viewReference(viewReference)
            .build();
        return sendWithBotClient(teamId, req);
    }

    public static Boolean sendWithBotClient(String teamId, Slack.ChatPostMessageRequest req){
        Boolean retVal = false;
        Slack.App app = Slack.App.Recruiting.get();
        
        Slack.BotClient botClient = app.getBotClientForTeam(teamId);

        Slack.ChatPostMessageResponse response = botClient.ChatPostMessage(req);
        if(response.getError() != null) {
            RecruitingUtil.debug(response.getError());
        }else{
            retVal = true;
        }
        //Slack.ChatPostMessageResponse response = botclient.chatPostMessage(req);
        RecruitingUtil.debug('response: ' + response.isOk()); 
        return retVal;
    }
}
