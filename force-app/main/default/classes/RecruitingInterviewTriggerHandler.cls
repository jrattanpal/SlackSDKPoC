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
        }
    }
    public override void afterInsert() {
        System.debug('afterInsert: ' + newMap);
    }

    @future
    private static void notifyInterviewerForNewInterview(String recordId, String salesforceUserId, String headerText ){
        RecruitingUtil.Message msg;
        try{

            //Check to see if the interview record exists before trying it in view
            Interview__c interview = RecruitingData.getInterviewDetails(recordId);
            //text: "A new interview has been scheduled with {!interview.Contact__r.Name} for position {!interview.Position__r.Name} at {!interview.Date__c}"

            String message = UserInfo.getName() +', a new interview has been scheduled with "' + interview.Contact__r.Name + '" for position "' + interview.Position__r.Name + '" at "' + interview.Interview_Date__c + '"';

            Slack.ViewReference viewReference = Slack.View.recruiting_interviewer_notificiation.get();
            viewReference.setParameter('headerText', headerText);
            viewReference.setParameter('recordId', recordId);
            viewReference.setParameter('message', message);
             
            RecruitingUtilSlack.sendView(RecruitingUtilSlack.getSlackUserId(salesforceUserId), null, viewReference);
            msg = RecruitingUtil.Message.setMsg('Success', true);
        }catch(Exception e){
            msg = RecruitingUtil.Message.setMsg(e.getMessage(), false);
        }
        
    }
}
