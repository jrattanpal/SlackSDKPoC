/*
    This example apex class is responsible for responding to the App Home Opened event
*/
public class RecruitingAppHomeOpened extends Slack.EventDispatcher {

      public override Slack.ActionHandler invoke(Slack.EventParameters parameters, Slack.RequestContext context) {
        return Slack.ActionHandler.ack(new Handler(parameters, context));
    }

    public class Handler implements Slack.RunnableHandler {      
        
        Slack.EventParameters parameters;
        Slack.RequestContext context;
        
        public Handler (Slack.EventParameters parameters, Slack.RequestContext context){
            this.parameters = parameters;
            this.context = context;
        }
        
        public void run () {
            //name must match the DeveloperName of your SlackApp.
            Slack.App app = Slack.App.Recruiting.get();
            Slack.BotClient botClient = app.getBotClientForTeam(context.getTeamId());
            // TODO we should support a less cumbersome way to get userId
            String event = String.valueOf(parameters.getEvent());
        	String userId = event.substringBetween('user=', ',');
            
            Slack.ViewReference viewReference = Slack.View.app_home.get();
            viewReference.setParameter('headerText', 'Welcome to the Apex Slack App Example.');
            viewReference.setParameter('bodyText', 'To see how this custom home view was created, see the AppHomeOpened apex class.');
            Slack.HomeView homeView = new Slack.HomeView.builder()
                .viewReference(viewReference)
                .build(); 
            
            Slack.ViewsPublishRequest req = new Slack.ViewsPublishRequest.builder()
                .userId(userId)
                .view(homeView)
                .build();
                      
        Slack.ViewsPublishResponse response = botClient.ViewsPublish(req);
        if(response.getError() != null) {
            System.debug(response.getError());
        }
      }
    }   
}