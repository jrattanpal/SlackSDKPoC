/*
    This example apex class extends Slack.ShortcutDispatcher and is responsible for 
    responding to both global and message shortcuts registered with the Slack application.
*/
public class RecruitingShortcutDispatcher extends Slack.ShortcutDispatcher {
  
    public override Slack.ActionHandler invoke(Slack.ShortcutParameters parameters, Slack.RequestContext context) {

        System.debug('parameters'  +parameters);
        System.debug('context'  +context);
        // the slack action handler should immediately be returned 
        return Slack.ActionHandler.modal(new Handler(parameters, context), 'Create Record');
    }
    
    public class Handler implements Slack.ModalHandler {
        
        Slack.ShortcutParameters parameters;
        Slack.RequestContext context;
        
        public Handler (Slack.ShortcutParameters parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }
        
        public Slack.ModalView call () {      
            // return the modal view for the 'create_record' view defiition
            Slack.ViewReference viewReference = Slack.View.message_modal.get();
            viewReference.setParameter('title', 'test');
            viewReference.setParameter('message', 'test');
            Slack.ModalView modalView = new Slack.ModalView.builder()
                .viewReference(viewReference)
                .build(); 
            return modalView;
        }
    }
    
}