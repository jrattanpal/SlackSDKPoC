trigger Interview on Interview__c (after update, after insert) {
    new RecruitingInterviewTriggerHandler().run();
}