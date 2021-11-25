/*
    This example apex class extends Slack.ActionDispatcher and is responsible for 
    responding to the button click events in the 'create_record' view.
*/
public class createRecord extends Slack.ActionDispatcher {

    public override Slack.ActionHandler invoke(Map<String, Object> parameters, Slack.RequestContext context) {
        // the slack action handler should immediately be returned 
        if (parameters.containsKey('pushModal') && (Boolean) parameters.get('pushModal')) {
            return Slack.ActionHandler.pushModal(new Handler(parameters, context));
        }
        return Slack.ActionHandler.updateModal(new Handler(parameters, context));
    }

    public class Handler implements Slack.ModalHandler {

        Map<String, Object> parameters;
        Slack.RequestContext context;

        public Handler (Map<String, Object> parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }

        public Slack.ModalView call () {
            // return the modal view that corresponds to the requested object
            String objectApiName = (String) parameters.get('objectApiName');
            Slack.ViewReference viewReference;
            if ('Account'.equals(objectApiName)) {
                viewReference = Slack.View.create_account.get();
            } 
            else if ('Contact'.equals(objectApiName)) {
                viewReference = Slack.View.create_contact.get();
            } 
            else if ('Opportunity'.equals(objectApiName)) {
                viewReference = Slack.View.create_opportunity.get();
            } 
            else {
                viewReference = Slack.View.message_modal.get();
                viewReference.setParameter('title', 'Invalid Object');
                viewReference.setParameter('message', 'The object api name was not a valid option.');
            }
            Slack.ModalView modalView = new Slack.ModalView.builder()
                .viewReference(viewReference)
                .build(); 
            return modalView;   
        }

    }
}