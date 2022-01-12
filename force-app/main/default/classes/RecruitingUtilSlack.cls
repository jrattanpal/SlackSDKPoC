public with sharing class RecruitingUtilSlack {
    
	public class MissingTeamIdException extends Exception {}

    public static String getTeamId(){
        Recruiting_Slack_Settings__c  rss = Recruiting_Slack_Settings__c.getInstance();
        if(rss.Team_ID__c == null){
            throw new MissingTeamIdException('Update "Recruiting Slack Settings	" custom setting with workspace ID');
        }
        return rss.Team_ID__c;
    }
    //Recruiting.notifyWithSFUserId('0050U0000076saN', 'New Interview Scheduled', 'a030U000004odv2QAA', 'Interview__c');
    public static String getSlackUserId(String salesforceUserId){
        Slack.App app = Slack.App.Recruiting.get();
        
        return app.getConnectedSlackUserId(getTeamId(), salesforceUserId);
    }

     //Build message to be send with .viewReference() method for Slack.ChatPostMessageRequest
     public static Boolean sendText(Slack.RequestContext context, String slackUserId, String message){
        Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
            .channel(slackUserId)
            .text(message)
            .build();

            return send(context.getTeamId(), req, null);
    }
    //Build message to be send with .viewReference() method for Slack.ChatPostMessageRequest
    public static Boolean sendView(String channelId, String slackUserId, Slack.ViewReference viewReference){
        System.debug(channelId + ':' + slackUserId + ':' + viewReference);
        Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
            .channel(channelId)
            .viewReference(viewReference)
            .build();
        return send(getTeamId(), req, slackUserId);
    }
    //Build message to be send with .viewReference() method for Slack.ChatPostMessageRequest
    public static Boolean sendView(Slack.RequestContext context, Slack.ViewReference viewReference){
        Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
            .channel(context.getChannelId())
            .viewReference(viewReference)
            .build();
        return send(context.getTeamId(), req, context.getUserId());
    }


    public static Boolean send(String teamId, Slack.ChatPostMessageRequest req, String slackUserId){

        Boolean retVal = false;
        Slack.App app = Slack.App.Recruiting.get();
        
        Slack.ChatPostMessageResponse response;
        try{
            
            //If null then use Bot Client
            //Else use user client
            if(slackUserId == null){
                Slack.BotClient botClient = app.getBotClientForTeam(getTeamId());

                response = botClient.ChatPostMessage(req);
            }else{
                Slack.UserClient userClient = app.getUserClientForTeam(getTeamId(), slackUserId);

                response = userClient.ChatPostMessage(req);
            }
            
        }catch(Exception e){
            RecruitingUtil.debug(e.getMessage());
        }

        RecruitingUtil.debug('response: ' + response.getError()); 
        return String.IsEmpty(response.getError());
    }

    /**  
     * create a Slack Channel 
     * System.debug(RecruitingUtilSlack.createChannel('test-channel1', false)); //public channel
     * System.debug(RecruitingUtilSlack.createChannel('test-channel2', true)); //private channel
     * 
    */

    public static Slack.ConversationsCreateResponse createChannel(String channelName, Boolean isPrivate){
        Slack.App app = Slack.App.Recruiting.get();
        Slack.BotClient botClient = app.getBotClientForTeam(getTeamId());
        Slack.ConversationsCreateRequest req = new Slack.ConversationsCreateRequest.builder()
            .isPrivate(isPrivate)
            .name(channelName)
            .teamId(getTeamId())
            .build();


        Slack.ConversationsCreateResponse res = botClient.ConversationsCreate(req);
        System.debug('ConversationsCreateResponse:' + res);
        System.debug(res.getDetail());
        return res;
    
    }

    /**
     * 
Slack.ConversationsCreateResponse res = RecruitingUtilSlack.createChannel('test-channel6', true);
//String res ='11:32:37:505 USER_DEBUG [82]|DEBUG|ConversationsCreateResponse:ConversationsCreateResponse:[delegate=ConversationsCreateResponse(ok=true, warning=null, error=null, detail=null, needed=null, provided=null, channel=Conversation(enterpriseId=null, id=C02QJ49SV4H, name=test-channel4, created=1639067557, creator=U02NAUJC1RB, unlinked=0, nameNormalized=test-channel4, pendingShared=[], lastRead=0000000000.000000, topic=Topic(value=, creator=, lastSet=0), purpose=Purpose(value=, creator=, lastSet=0), previousNames=[], numOfMembers=null, l;';

//Method to get channel information is being implemented.
//For now, parsing the string is the only way to get the channel ID
String channelId = res.toString().substringBetween('id=', ',');
System.debug(channelId);
List<String> users = new List<String>();
users.add(RecruitingUtilSlack.getSlackUserId(UserInfo.getUserId()));

Slack.ConversationsInviteResponse resInvite = RecruitingUtilSlack.inviteUserToChannel(channelId, users);
     */
    public static Slack.ConversationsInviteResponse inviteUserToChannel(String channelId, List<String> users){
        Slack.App app = Slack.App.Recruiting.get();
        Slack.BotClient botClient = app.getBotClientForTeam(getTeamId());
        Slack.ConversationsInviteRequest req = new Slack.ConversationsInviteRequest.builder()
            .channel(channelId)
            .users (users)
            .build();


        Slack.ConversationsInviteResponse res = botClient.ConversationsInvite(req);
        System.debug(res);
        return res;
    }
}