public with sharing class RecruitingUtilSlack {
    

    private static String teamId = 'T02GGRQ8R0F';

    public static String getTeamId(){
        return teamId;
    }
    //Recruiting.notifyWithSFUserId('0050U0000076saN', 'New Interview Scheduled', 'a030U000004odv2QAA', 'Interview__c');
    public static String getSlackUserId(String salesforceUserId){
        Slack.App app = Slack.App.Recruiting.get();
        
        return app.getConnectedSlackUserId(getTeamId(), salesforceUserId);
    }

     //Build message to be send with .viewReference() method for Slack.ChatPostMessageRequest
     public static Boolean sendText(String slackUserId, String message){
        Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
            .channel(slackUserId)
            .text(message)
            .build();

            return send(req, null);
    }
    //Build message to be send with .viewReference() method for Slack.ChatPostMessageRequest
    public static Boolean sendView(String channelId, String slackUserId, Slack.ViewReference viewReference){
        System.debug(channelId + ':' + slackUserId + ':' + viewReference);
        Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
            .channel(channelId)
            .viewReference(viewReference)
            .build();
        return send(req, slackUserId);
    }


    public static Boolean send(Slack.ChatPostMessageRequest req, String slackUserId){
        Boolean retVal = false;
        Slack.App app = Slack.App.Recruiting.get();
        
        System.debug('Request::' + req.toString());
        System.debug('slackUserId:: ' + slackUserId);
        Slack.ChatPostMessageResponse response;
        
        //If null then use Bot Client
        //Else use user client
        if(slackUserId == null){
            System.debug('Using Bot Client');
            Slack.BotClient botClient = app.getBotClientForTeam(getTeamId());

            response = botClient.ChatPostMessage(req);
        }else{
            System.debug('Using User Client');
            Slack.UserClient userClient = app.getUserClientForTeam(getTeamId(), slackUserId);

            response = userClient.ChatPostMessage(req);
        }
        
        RecruitingUtil.debug('response: ' + response.getError()); 
        System.debug(response);
        System.debug(response.toString());


        return String.IsEmpty(response.getError());
    }
}
