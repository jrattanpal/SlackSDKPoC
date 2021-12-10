public with sharing class RecruitingInterviewTriggerHandler extends TriggerHandler {
    private Map<Id, Interview__c> newMap;
    private Map<Id, Interview__c> oldMap;
    private List<Interview__c> newInterviews = new List<Interview__c>();

    public RecruitingInterviewTriggerHandler() {
        this.newMap = (Map<Id, Interview__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Interview__c>) Trigger.oldMap;
        this.newInterviews = Trigger.new;

        RecruitingUtil.debug('InterviewTriggerHandler.this.newMap: ' + this.newMap);
        RecruitingUtil.debug('InterviewTriggerHandler.this.oldMap: ' + this.oldMap);
    }
    
    public override void afterUpdate() {
        for(Interview__c rec: newInterviews){
            Interview__c recNew = this.newMap.get(rec.Id);
            Interview__c recOld = this.oldMap.get(rec.Id);
            //If update Interviewer__c is not empty and HAS changed
            if(recNew.Interviewer__c != null  && recNew.Interviewer__c != recOld.Interviewer__c){
                notifyInterviewerForNewInterview(rec.Id, recNew.Interviewer__c, 'New Interview Scheduled' );
            }
            //If candidate has been selected then create a channel and add users to it for any discussion
            //TODO: Invite external contact when Apex API is implemented
            if(recNew.Status__c != recOld.Status__c && recNew.Status__c == 'Selected'){
                //Create a private channel
                Slack.ConversationsCreateResponse res = RecruitingUtilSlack.createChannel('recruiting-' + recNew.Name.toLowerCase(), true);

                //Method to get channel information is being implemented.
                //For now, parsing the string is the only way to get the channel ID
                String channelId = res.toString().substringBetween('id=', ',');

                List<String> users = new List<String>();
                users.add(RecruitingUtilSlack.getSlackUserId(recNew.Interviewer__c));

                Slack.ConversationsInviteResponse resInvite = RecruitingUtilSlack.inviteUserToChannel(channelId, users);
            }
        }
    }
    public override void afterInsert() {
        System.debug('afterInsert: ' + newMap);
    }

    @future
    private static void notifyInterviewerForNewInterview(String recordId, String salesforceUserId, String headerText ){
        RecruitingFunctions.notifyInterviewerForNewInterview(recordId, salesforceUserId, headerText);
    }
}
