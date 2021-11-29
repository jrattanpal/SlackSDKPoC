public with sharing class InterviewTriggerHandler extends TriggerHandler {
    private Map<Id, Interview__c> newMap;
    private Map<Id, Interview__c> oldMap;
    private List<Interview__c> newInterviews = new List<Interview__c>();

    public InterviewTriggerHandler() {
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
                    Recruiting.notifyInterviewerForNewInterviewFuture(rec.Id, recNew.Interviewer__c, 'New Interview' );
            }
        }
    }
    public override void afterInsert() {
        System.debug('afterInsert: ' + newMap);
    }
}
