/*
    This example apex class extends Slack.ActionDispatcher and is responsible for 
    responding to the view submission event defined in the 'create_account', 'create_contact',
    and 'create_opportunty' views.
*/
public with sharing class RecruitingActionDispatcher extends Slack.ActionDispatcher {
    public override Slack.ActionHandler invoke(Map<String, Object> parameters, Slack.RequestContext context) {
        String dispatcher = (parameters.containsKey('dispatcher'))?(String) parameters.get('dispatcher'):'ack';

        switch on dispatcher{
            when 'modal' {
                return Slack.ActionHandler.modal(new HandlerModal(parameters, context));
            }
            when else{
                return Slack.ActionHandler.ack(new HandlerAck(parameters, context));
            }            
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
            System.debug('context::' + context);
            // process parameters to see which action to perform
            String recordId = (String) this.parameters.get('recordId');
            String action = (String) this.parameters.get('action'); 
            RecruitingUtil.Message msg;
            switch on action {
                when 'interview_confirm' {
                    msg = confirmInterview(recordId, 'Interview Confirmed');
                }
                when 'interview_feedback' {
                    msg = submitInterviewFeedback(context, recordId);
                }
                when 'refer_friend' {
                    msg = referFriend(context, recordId);
                }
                when else { msg = RecruitingUtil.Message.setMsg('The action is not valid', false); }
            }
            
            //For some actions, like interview_feedback, use the channel ID provided in paramters
            //This is because the response came from a modal and chanellID is not set in context

            String channelId = (context.getChannelId()==null)?context.getUserId():context.getChannelId();
            System.debug('channelId::' + channelId);
            if(context.getChannelId() == null && this.parameters.containsKey('channelId') && (this.parameters.get('channelId') != null)){
                channelId = (String) this.parameters.get('channelId');
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
            Slack.ViewReference viewReference;

            System.debug('this.parameters: ' + this.parameters);
            String recordId = (String) this.parameters.get('recordId');
            String action = (String) this.parameters.get('action'); 

            switch on action {
                when 'interview_feedback' {
                    viewReference = Slack.view.recruiting_interview_feedback.get();
                    viewReference.setParameter('recordId', recordId);
                    viewReference.setParameter('channelId', context.getchannelId());
                    modal = new Slack.ModalView.builder()
                        .viewReference(viewReference)
                        .build(); 
                }
                when 'refer_friend' {
                    viewReference = Slack.view.recruiting_refer_friend.get();
                    viewReference.setParameter('channelId', context.getchannelId());
                    modal = new Slack.ModalView.builder()
                        .viewReference(viewReference)
                        .build(); 
                }
                when else { 
                    modal = MessageModal.getMessageModalView(
                        'Invalid Parameters',
                        'The view record command requires 2 arguments: action and dispatcher=[ack|modal].'
                    );
                }
            }
            return modal;
        }
    }

    public static RecruitingUtil.Message confirmInterview(Id recordId, String status){
        Interview__c interview = RecruitingData.getInterviewDetails(recordId);
        
        // Make sure we can update the database before even trying
        if (!Schema.sObjectType.Interview__c.fields.Status__c.isUpdateable()) {
            return RecruitingUtil.setMsg('You do not have permission to update Interview status', false);
        }
        interview.Status__c = status;
        update interview;

        
        return RecruitingUtil.setMsg('Interview with "' + interview.Contact__r.Name + '" for position "' + interview.Position__r.Name + '" at "' + interview.Interview_Date__c + '" has been Confirmed.', true);
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
        
        
        msg = RecruitingUtil.setMsg('Feedback for interview with "' + interview.Contact__r.Name + '" for position "' + interview.Position__r.Name + '" at "' + interview.Interview_Date__c + '" has been submitted.', true);
        return msg;
    }
    private static RecruitingUtil.Message referFriend (Slack.RequestContext context, String recordId) {
        RecruitingUtil.Message msg;
        // Make sure we can update the database before even trying
        if (!Schema.sObjectType.Referral__c.isCreateable() || !Schema.sObjectType.Referral__c.fields.Contact__c.isCreateable() ||
        !Schema.sObjectType.Referral__c.fields.Position__c.isCreateable() ||
        !Schema.sObjectType.Referral__c.fields.user__c.isCreateable()) {
            return RecruitingUtil.setMsg('You do not have permission to submit referral', false);
        }
        Map <String, Object> formData = context.getFormData();

        System.debug('formData:' + formData);
        Referral__c referral = new Referral__c();
        referral.Contact__c = (String) formData.get('contact_lookup');
        referral.Position__c = (String) formData.get('position_lookup');
        referral.User__c = UserInfo.getUserId();
        insert referral;
        
        msg = RecruitingUtil.setMsg('Referral has been submitted', true);
        return msg;
    }
}