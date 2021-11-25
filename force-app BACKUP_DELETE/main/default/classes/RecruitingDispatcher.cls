/*
    This example apex class extends Slack.ActionDispatcher and is responsible for 
    responding to the view submission event defined in the 'create_account', 'create_contact',
    and 'create_opportunty' views.
*/
public with sharing class RecruitingDispatcher extends Slack.ActionDispatcher {
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
            // process the form data and return the modal view that corresponds to the requested object    
            String objectApiName = (String) this.parameters.get('objectApiName');
            String recordId = (String) this.parameters.get('recordId');
            String action = (String) this.parameters.get('action');

            String message = '';
            switch on objectApiName {
                when 'Interview__c' { 
                    Boolean res = interviewAction(action, recordId); 
                    if(res){
                        message = 'Thank you for confirming interview!';
                        Recruiting.sendTextWithSlackUserId(context.getUserId(), 'Interview Schedule Confirmed ');
                    }else{
                        message = 'Some error occured while confiring interview';
                    }
                }
                when else { message ='The object api name was not a valid option.'; }
            }
            System.debug(message);
            /* */
        }
    }
    private static boolean interviewAction(String action, String recordId){
        Boolean retVal = false;
        switch on action {
            when 'interview_confirm' {  
                try{
                    Interview__c rec = [select Id, Interviewer_Confirmed__c from Interview__c where Id=:recordId with SECURITY_ENFORCED];
                    rec.Interviewer_Confirmed__c = true;
                    update rec;

                    retVal = true;
                }
                catch(Exception e){
                    System.debug(e.getMessage());

                }
            }
            when else { System.debug('The action name "' + action + '" is not a valid option.'); }
        }
        return retVal;
    }
}


    /*
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
*/