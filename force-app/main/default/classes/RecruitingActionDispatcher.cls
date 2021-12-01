/*
    This example apex class extends Slack.ActionDispatcher and is responsible for 
    responding to the view submission event defined in the 'create_account', 'create_contact',
    and 'create_opportunty' views.
*/
public with sharing class RecruitingActionDispatcher extends Slack.ActionDispatcher {
    public override Slack.ActionHandler invoke(Map<String, Object> parameters, Slack.RequestContext context) {
        Boolean useModal = (parameters.containsKey('useModal') && parameters.get('useModal') == true)?true:false;
        if(useModal){
            return Slack.ActionHandler.modal(new HandlerModal(parameters, context));
        }else{
            return Slack.ActionHandler.ack(new HandlerAck(parameters, context));
        }
    }

    //Ack Handler
    public class HandlerAck implements Slack.RunnableHandler {
        Map<String, Object> parameters;
        Slack.RequestContext context;

        public HandlerAck (Map<String, Object> parameters, Slack.RequestContext context){
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
                    msg = RecruitingActionDispatcher.interviewAction(context, action, recordId);
                }
                when else { msg = RecruitingUtil.Message.setMsg('The object api name was not a valid option.', false); }
            }
            
            //For some actions, like interview_feedback, use the channel ID provided in paramters
            //This is because the response came from a modal and chanellID is not set in context

            String channelId = context.getChannelId();
            if(context.getChannelId() == null && this.parameters.containsKey('channelId')){
                channelId = (String) this.parameters.get('channelId');
            }else if(context.getChannelId() == null ){
                channelId = context.getUserId();
            }

            RecruitingUtilSlack.sendText(channelId, msg.message);
            /* */
        }
    }

    //Modal Handler
    public class HandlerModal implements Slack.ModalHandler {       
      
        Map<String, Object> parameters;
        Slack.RequestContext context;
        
        public HandlerModal (Map<String, Object> parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }
        
        public Slack.ModalView call () {      
            Slack.ModalView modal;

            String objectApiName = (String) this.parameters.get('objectApiName');
            String recordId = (String) this.parameters.get('recordId');
            String channelId = (String) this.parameters.get('recordId');
            String action = (String) this.parameters.get('action'); 
            switch on objectApiName {
                when 'Interview__c' {
                    modal = RecruitingActionDispatcher.interviewActionModal(context, action, recordId);
                }
                when else { 
                    modal = MessageModal.getMessageModalView(
                        'Invalid Parameters',
                        'The view record command requires 2 arguments: objectApiName and recordId.'
                    );
                }
            }
            return modal;
        }
    }
    private static Slack.ModalView interviewActionModal(Slack.RequestContext context, String action, String recordId){
        Slack.ViewReference viewReference;
        Slack.ModalView modalView;
        switch on action {
            when 'interview_feedback' { 
                viewReference = Slack.view.recruiting_interview_feedback.get();
                viewReference.setParameter('recordId', recordId);
                viewReference.setParameter('channelId', context.getchannelId());
                modalView = new Slack.ModalView.builder()
                    .viewReference(viewReference)
                    .build(); 
            }
        }
        
        
        return modalView;
    }

    private static RecruitingUtil.Message interviewAction(Slack.RequestContext context, String action, String recordId){
        RecruitingUtil.Message msg;
        switch on action {
            when 'interview_confirm' {  
                try{
                    msg = confirmInterview(recordId, 'Interview Confirmed');
                }
                catch(Exception e){
                    System.debug(e.getMessage());
                    msg = RecruitingUtil.Message.setMsg(e.getMessage(), false);
                }
            }
            when 'interview_feedback' {  
                try{
                    System.debug('recordId:' + recordId);
                    msg = submitInterviewFeedback(context, recordId);
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

    public static RecruitingUtil.Message confirmInterview(Id recordId, String status){
        Interview__c record = RecruitingData.getInterviewDetails(recordId);
        
        // Make sure we can update the database before even trying
        if (!Schema.sObjectType.Interview__c.fields.Status__c.isUpdateable()) {
            return RecruitingUtil.setMsg('You do not have permission to update Interview status', false);
        }
        record.Status__c = status;
        update record;
        return RecruitingUtil.setMsg('Interview has been confirmed', true);
    }   
    private static RecruitingUtil.Message submitInterviewFeedback (Slack.RequestContext context, String recordId) {
        RecruitingUtil.Message msg;
        // Make sure we can update the database before even trying
        if (!Schema.sObjectType.Interview__c.fields.Feedback__c.isUpdateable() &&
        !Schema.sObjectType.Interview__c.fields.Status__c.isUpdateable()) {
            return RecruitingUtil.setMsg('You do not have permission to update Interview feedback', false);
        }
        Map <String, Object> formData = context.getFormData();

        Interview__c interview = RecruitingData.getInterviewDetails(recordId);
        interview.Feedback__c = (String) formData.get('Feedback__c');
        interview.Status__c = 'Feedback Gathered';
        update interview;
        
        msg = RecruitingUtil.setMsg('Interview feedback has been submitted', true);
        return msg;
    }
}