/*
    This example apex class extends Slack.ActionDispatcher and is responsible for 
    responding to the view submission event defined in the 'create_account', 'create_contact',
    and 'create_opportunty' views.
*/
public with sharing class RecruitingActionDispatcher extends Slack.ActionDispatcher {
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

            RecruitingUtil.Message msg;
            switch on objectApiName {
                when 'Interview__c' {
                    msg = interviewAction(action, recordId);
                }
                when else { msg = RecruitingUtil.Message.setMsg('The object api name was not a valid option.', false); }
            }
            RecruitingUtilSlack.sendTextWithSlackUserId(context.getUserId(), msg.message);
            /* */
        }
    }
    private static RecruitingUtil.Message interviewAction(String action, String recordId){
        RecruitingUtil.Message msg;
        switch on action {
            when 'interview_confirm' {  
                try{
                    msg = Recruiting.confirmInterview(recordId, 'Interview Confirmed');
                }
                catch(Exception e){
                    System.debug(e.getMessage());
                    msg = RecruitingUtil.Message.setMsg(e.getMessage(), false);
                }
            }
            when else { msg = RecruitingUtil.Message.setMsg('The action name "' + action + '" is not a valid option.', false);}
        }
        return msg;
    }
}