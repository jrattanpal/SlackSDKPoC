public with sharing class RecruitingFunctions {
    @AuraEnabled
    public static RecruitingUtil.Message notifyInterviewerForNewInterview(String recordId, String salesforceUserId, String headerText ){
        RecruitingUtil.Message msg;

        try{
            System.debug('salesforceUserId:' + salesforceUserId);
            System.debug('salesforceUserId:' + String.isEmpty(salesforceUserId));
            salesforceUserId = (String.isEmpty(salesforceUserId))?Userinfo.getUserId():salesforceUserId;
            System.debug('salesforceUserId:' + salesforceUserId);

            //Check to see if the interview record exists before trying it in view
            Interview__c interview = RecruitingData.getInterviewDetails(recordId);
            //text: "A new interview has been scheduled with {!interview.Contact__r.Name} for position {!interview.Position__r.Name} at {!interview.Date__c}"

            String message = UserInfo.getName() +', a new interview has been scheduled with "' + interview.Contact__r.Name + '" for position "' + interview.Position__r.Name + '" at "' + interview.Interview_Date__c + '"';

            Slack.ViewReference viewReference = Slack.View.recruiting_interviewer_notificiation.get();
            viewReference.setParameter('headerText', headerText);
            viewReference.setParameter('recordId', recordId);
            viewReference.setParameter('message', message);
            viewReference.setParameter('label', 'Confirm Interview');
            viewReference.setParameter('action', 'interview_confirm');
            viewReference.setParameter('dispatcher', 'ack');
             
            RecruitingUtilSlack.sendView(RecruitingUtilSlack.getSlackUserId(salesforceUserId), null, viewReference);
            msg = RecruitingUtil.Message.setMsg('Success', true);
        }catch(Exception e){
            msg = RecruitingUtil.Message.setMsg(e.getMessage(), false);
        }
        return msg;
    }
    @AuraEnabled
    public static RecruitingUtil.Message notifyInterviewerForFeedback(String recordId, String salesforceUserId, String headerText ){
        RecruitingUtil.Message msg;
        try{
            salesforceUserId = (String.isEmpty(salesforceUserId))?Userinfo.getUserId():salesforceUserId;

            //Check to see if the interview record exists before trying it in view
            Interview__c interview = RecruitingData.getInterviewDetails(recordId);
            //text: "A new interview has been scheduled with {!interview.Contact__r.Name} for position {!interview.Position__r.Name} at {!interview.Date__c}"

            String message = UserInfo.getName() +', provide feedback for your interview with "' + interview.Contact__r.Name + '" for position "' + interview.Position__r.Name + '" at "' + interview.Interview_Date__c + '"';

            Slack.ViewReference viewReference = Slack.View.recruiting_interviewer_notificiation.get();
            viewReference.setParameter('headerText', headerText);
            viewReference.setParameter('recordId', recordId);
            viewReference.setParameter('message', message);
            viewReference.setParameter('label', 'Provide Feedback');
            viewReference.setParameter('action', 'interview_feedback');
            viewReference.setParameter('dispatcher', 'modal');
             
            RecruitingUtilSlack.sendView(RecruitingUtilSlack.getSlackUserId(salesforceUserId), null, viewReference);
            msg = RecruitingUtil.Message.setMsg('Success', true);
        }catch(Exception e){
            msg = RecruitingUtil.Message.setMsg(e.getMessage(), false);
        }
        return msg;
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
    public static RecruitingUtil.Message submitInterviewFeedback (Slack.RequestContext context, String recordId) {
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
    public static RecruitingUtil.Message referFriend (Slack.RequestContext context, String recordId) {
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
        
        msg = RecruitingUtil.setMsg('Referral has been submitted: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + referral.Id, true);
        return msg;
    }

    public static void generateHelp(Slack.RequestContext context){
        Slack.ViewReference viewReference = Slack.View.recruiting_help.get();
        
        //Use User client because message is started by user
        //RecruitingUtilSlack.sendView(false, context.getChannelId(), viewReference);
        RecruitingUtilSlack.sendView(context.getChannelId(), context.getUserId(), viewReference);
    }

    public static void cmdInterviews(Slack.RequestContext context, Integer numberOfInterviews, Boolean showOldInterviews){

        Slack.ViewReference viewReference = Slack.View.recruiting_cmd_interviews.get();
        
        viewReference.setParameter('interviewerId', UserInfo.getUserId());
        viewReference.setParameter('showOldInterviews', showOldInterviews);
        viewReference.setParameter('numberOfInterviews', numberOfInterviews);

        //Use User client because message is started by user
        //RecruitingUtilSlack.sendView(false, context.getChannelId(), viewReference);
        RecruitingUtilSlack.sendView(context.getChannelId(), context.getUserId(), viewReference);
    }
}
