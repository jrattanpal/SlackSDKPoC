/*
    This example apex class extends Slack.ActionDispatcher and is responsible for 
    responding to the post message event defined in the 'view_opportuniy', 'view_account',
    and 'view_contact' views.
*/
public class PostRecordDetailMessage extends Slack.ActionDispatcher {
      
      public override Slack.ActionHandler invoke(Map<String, Object> parameters, Slack.RequestContext context) {
        return Slack.ActionHandler.ack(new Handler(parameters, context));
    }

    public class Handler implements Slack.RunnableHandler {      
        
        Map<String, Object> parameters;
        Slack.RequestContext context;
        
        public Handler (Map<String, Object> parameters, Slack.RequestContext context){
            this.parameters = parameters;
            this.context = context;
        }
        
        public void run () {
            //name must match the DeveloperName of your SlackApp.
            Slack.App app = Slack.App.Recruiting.get();
            Slack.UserClient userClient = app.getUserClientForTeam(context.getTeamId(), context.getUserId());
            
            String recordId = (String) parameters.get('recordId');
            String objectApiName = (String) parameters.get('objectApiName');
            Slack.ViewReference viewReference = Slack.View.record_detail_message.get();
            viewReference.setParameter('headerText', objectApiName + ' Record Details');
            viewReference.setParameter('recordId', recordId);
            viewReference.setParameter('objectApiName', objectApiName);
            
            Slack.ChatPostMessageRequest req = new Slack.ChatPostMessageRequest.builder()
                .channel((String) parameters.get('channelId'))
                //TODO should text be required if you are setting a view reference?
                .text('Details for record id' + recordId)
                .viewReference(viewReference)
                .build();
                      
        Slack.ChatPostMessageResponse response = userClient.ChatPostMessage(req);
        if(response.getError() != null) {
            System.debug(response.getError());
        }
      }
    }   
}