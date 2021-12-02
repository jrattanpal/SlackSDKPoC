/*
    This example apex class extends Slack.ActionDispatcher and is responsible for 
    responding to the view submission event defined in the 'create_account', 'create_contact',
    and 'create_opportunty' views.
*/
public class submitRecord extends Slack.ActionDispatcher {

    public override Slack.ActionHandler invoke(Map<String, Object> parameters, Slack.RequestContext context) {
        // the slack action handler should immediately be returned 
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
            // process the form data and return the modal view that corresponds to the requested object    
            String objectApiName = (String) parameters.get('objectApiName');
            Slack.ModalView modalView;
            switch on objectApiName {
                when 'Account' { modalView = submitAccount(); }
                when 'Contact' { modalView = submitContact(); }
                when 'Opportunity' { modalView = submitOpportunity(); }
                when else { modalView = MessageModal.getMessageModalView('Invalid Object', 'The object api name was not a valid option.'); }
            }
            return modalView;
        }

        private Slack.ModalView submitAccount () {
            try {
                Map <String, Object> formData = context.getFormData();
                Account account = new Account();
                account.Name = (String) formData.get('Name');
                insert account;
                return MessageModal.getMessageModalView('Record Created', 'Your account was created: ' + formData.get('Name'));
            } catch (Exception e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
                return MessageModal.getMessageModalView('Error Occurred', 'There was a problem creating your account.');
            }
        }

        private Slack.ModalView submitContact () {
            try {
                Map <String, Object> formData = context.getFormData();
                Contact contact = new Contact();
                contact.FirstName = (String) formData.get('FirstName');
                contact.LastName = (String) formData.get('LastName');
                contact.Phone = (String) formData.get('Phone');
                contact.Email = (String) formData.get('Email');
                insert contact;
                return MessageModal.getMessageModalView('Record Created', 'Your contact was created: ' + formData.get('FirstName'));
            } catch (Exception e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
                return MessageModal.getMessageModalView('Error Occurred', 'There was a problem creating your contact.');
            }
        }

        private Slack.ModalView submitOpportunity () {
            try {
                Map <String, Object> formData = context.getFormData();
                Opportunity oppty = new Opportunity();
                oppty.Name = (String) formData.get('Name');
                oppty.Amount = Double.valueOf(formData.get('Amount'));
                oppty.StageName = (String) formData.get('StageName');
                oppty.CloseDate = Date.valueOf( (String) formData.get('CloseDate'));
                insert oppty;
                return MessageModal.getMessageModalView('Record Created', 'Your opportunity was created: ' + formData.get('Name'));
            } catch (Exception e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
                return MessageModal.getMessageModalView('Error Occurred', 'There was a problem creating your opportunity.');
            }
        }

    }

}