/*
    This example apex class extends Slack.SlashCommandDispatcher and is responsible for 
    responding to the Slack slash command registered with the Slack application.
*/
public class CreateRecordCommandDispatcher extends Slack.SlashCommandDispatcher {
  
    public override Slack.ActionHandler invoke(Slack.SlashCommandParameters parameters, Slack.RequestContext context) {
        // the slack action handler should immediately be returned 
        return Slack.ActionHandler.modal(new Handler(parameters, context), 'Create Record');
    }
    
    public class Handler implements Slack.ModalHandler {       
        
        Slack.SlashCommandParameters parameters;
        Slack.RequestContext context;
        
        public Handler (Slack.SlashCommandParameters parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }
        
        public Slack.ModalView call () {      
            // return the modal view for the 'create_record' view defiition
            Slack.ViewReference viewReference = Slack.View.create_record.get();
            Slack.ModalView modalView = new Slack.ModalView.builder()
                .viewReference(viewReference)
                .build(); 
            return modalView;
        }
    }
    
}