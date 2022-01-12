/*
    This example apex class extends Slack.ShortcutDispatcher and is responsible for 
    responding to both global and message shortcuts registered with the Slack application.
*/
public class RecruitingShortcutDispatcher extends Slack.ShortcutDispatcher {
  
    public override Slack.ActionHandler invoke(Slack.ShortcutParameters parameters, Slack.RequestContext context) {

        System.debug('parameters'  +parameters);
        System.debug('context'  +context);
        // the slack action handler should immediately be returned 
        return Slack.ActionHandler.modal(new Handler(parameters, context), 'Recruiting');
    }
    
    public class Handler implements Slack.ModalHandler {
        
        Slack.ShortcutParameters parameters;
        Slack.RequestContext context;
        
        public Handler (Slack.ShortcutParameters parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }
        
        public Slack.ModalView call () {   
            System.debug('context::' + context); 
            Slack.ViewReference viewReference;
            Slack.ModalView modalView;

            String callbackId = this.parameters.getCallbackId();
            System.debug(this.parameters);
            System.debug(this.context);
            
            switch on callbackId {
                when 'recruiting-interview-review-message-shortcut'{
                    viewReference = Slack.view.recruiting_refer_friend.get();
                    viewReference.setParameter('channelId', context.getchannelId());
                    modalView = new Slack.ModalView.builder()
                         .viewReference(viewReference)
                         .build(); 
                }
                when 'recruiting-interview-review-global-shortcut'{
                    viewReference = Slack.view.recruiting_refer_friend.get();
                    viewReference.setParameter('channelId', context.getchannelId());
                    modalView = new Slack.ModalView.builder()
                         .viewReference(viewReference)
                         .build(); 
                }
                when else { 
                    modalView = RecruitingMessageModal.getMessageModalView(
                        'Invalid Parameters',
                        'Select a correct shortcut'
                    );
                }
            }
            return modalView;
        }
    }
    
}