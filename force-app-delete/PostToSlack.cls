public with sharing class PostToSlack {

    //PostToSlack.interviewNotification('0050U0000076saN', 'New Interview Scheduled', 'a030U000004odv2QAA', 'Interview__c');
    public static void interviewNotification(String interviewerUserId, String headerText, String recordId, String objectApiName){
        Slack.App app = Slack.App.Recruiting.get();
        String teamId = 'T02GGRQ8R0F';
        String slackUserId = app.getConnectedSlackUserId(teamId, interviewerUserId);


        Slack.BotClient botClient = app.getBotClientForTeam(teamId);

        Slack.ViewReference viewReference = Slack.View.recruiting_interviewer_notificiation.get();
        viewReference.setParameter('headerText', 'New Interview Notification');
        viewReference.setParameter('recordId', recordId);
        viewReference.setParameter('objectApiName', objectApiName);

        Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
                    .channel(slackUserId)
                    //.viewReference(viewReference)
                    .text('You have a new interview')
                    .build();

        Slack.ChatPostMessageResponse response = botClient.ChatPostMessage(req);
        if(response.getError() != null) {
            System.debug(response.getError());
        }
        //Slack.ChatPostMessageResponse response = botclient.chatPostMessage(req);
        System.debug('response: ' + response.isOk());      

    }
    public void sendMessage() {
        Slack.App app = Slack.App.Recruiting.get();
        String teamId = 'T02GGRQ8R0F';
        String channelId = 'C02GXGZJ30A';
        //String userId = 'U02HM6HQYCQ';
        String slackUserId = app.getConnectedSlackUserId(teamId, UserInfo.getUserId());
        String recordId = '0010U00001DmMpoQAF';
        System.debug(app);
System.debug(slackUserId);
        
        System.debug(app.getAppKey());
        
	    Slack.AppClient appClient = app.getAppClient();
        Slack.BotClient botClient = app.getBotClientForTeam(teamId);
        Slack.UserClient userClient = app.getUserClientForTeam(teamId, slackUserId);
        
        //System.debug(app.getAppClient());
        System.debug(userClient);
        
        
        Slack.ViewReference viewReference = Slack.View.record_detail_message.get();
        viewReference.setParameter('headerText', 'Header Text');
        viewReference.setParameter('recordId', recordId);
        viewReference.setParameter('objectApiName', 'Account');

Slack.ChatPostEphemeralRequest reqEph = new Slack.ChatPostEphemeralRequest.builder()
                    .channel(slackUserId)
				    .user(slackUserId)
    				.viewReference(viewReference)
                    .build();
  SYstem.debug(reqEph);
        Slack.ChatPostEphemeralResponse  responseEph = botClient.ChatPostEphemeral (reqEph);
                if(responseEph.getError() != null) {
                    System.debug(responseEph.getError());
                }
                //Slack.ChatPostMessageResponse response = botclient.chatPostMessage(req);
                System.debug('responseEph: ' + responseEph.isOk());

        /*
        // Post a message
        //        Slack.ViewReference view = Slack.View.message_withblocks.get();
        //        view.setParameter('text', 'Hello from apex');
                Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
                    //.channel(channelId)
                    .user('jrattanpal')
                    .viewReference(viewReference)
                    .build();
        SYstem.debug(req);
        Slack.ChatPostMessageResponse response = userClient.ChatPostMessage(req);
                if(response.getError() != null) {
                    System.debug(response.getError());
                }
                //Slack.ChatPostMessageResponse response = botclient.chatPostMessage(req);
                System.debug('response: ' + response.isOk());
/* */
        
    }

    //REQUIRES User:read.email BOT& User tokens

    public void searchSlackUserByEmail(){
        Slack.App app = Slack.App.Recruiting.get();
        String teamId = 'T02GGRQ8R0F';
        String channelId = 'C02GXGZJ30A';
        //String userId = 'U02HM6HQYCQ';
        String slackUserId = app.getConnectedSlackUserId(teamId, UserInfo.getUserId());
        String recordId = '0010U00001DmMpoQAF';
        System.debug(app);
System.debug(slackUserId);

		//Slack.AppClient appClient = app.getAppClient();
        Slack.BotClient botClient = app.getBotClientForTeam(teamId);
        Slack.UserClient userClient = app.getUserClientForTeam(teamId, slackUserId);
        
Slack.UsersLookupByEmailRequest req = new Slack.UsersLookupByEmailRequest.builder()
            .email('jrattanpal@gmail.com')
            .build();
        
Slack.UsersLookupByEmailResponse response = botClient.usersLookupByEmail(req);

system.debug(response);
system.debug(response.getNeeded());
system.debug(response.getProvided());

String responseString = String.valueOf(response);
        	//String userId = event.substringBetween('user=(Id=', ',');
//system.debug(userId);
    }
}
