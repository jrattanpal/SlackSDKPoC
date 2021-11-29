/*
This example apex class provides details for populating views that display a record.
For the methods that return a single sobject directly, see usage defined in 'view_contact', 'view_account', and 'view_opportunity.'
For the method that returns data in a list for an iterator, see usage in 'record_detail_message.'
*/
public with sharing class Recruiting {
    
    
    /**
Interview__c record = [Select Id from Interview__c limit 1];
Recruiting.notifyInterviewerForNewInterview(record.Id, UserInfo.getUserId(),  'New Interview Scheduled');
*/
    //Cannot make API call from trigger so have to use @future method
    @future
    public static void notifyInterviewerForNewInterviewFuture(String recordId, String salesforceUserId, String headerText ){
        notifyInterviewerForNewInterview(recordId, salesforceUserId, headerText);
    }

    public static RecruitingUtil.Message notifyInterviewerForNewInterview(String recordId, String salesforceUserId, String headerText ){
        RecruitingUtil.Message msg;
        try{

            //Check to see if the interview record exists before trying it in view
            Interview__c interview = getInterviewDetails(recordId);
            //text: "A new interview has been scheduled with {!interview.Contact__r.Name} for position {!interview.Position__r.Name} at {!interview.Date__c}"

            String message = 'A new interview has been scheduled with "' + interview.Contact__r.Name + '" for position "' + interview.Position__r.Name + '" at "' + interview.Interview_Date__c + '"';

            Slack.ViewReference viewReference = Slack.View.recruiting_interviewer_notificiation.get();
            viewReference.setParameter('headerText', headerText);
            viewReference.setParameter('recordId', recordId);
            viewReference.setParameter('message', message);
            
            RecruitingUtil.debug('viewReference:' + viewReference);
            
            RecruitingUtilSlack.sendViewWithSFUserId (salesforceUserId, viewReference);
            msg = RecruitingUtil.Message.setMsg('Success', true);
        }catch(Exception e){
            msg = RecruitingUtil.Message.setMsg(e.getMessage(), false);
        }
        return msg;
    }
    public static RecruitingUtil.Message confirmInterview(Id recordId, String status){
        Interview__c record = [Select Id, Status__c from Interview__c where Id=:recordId WITH SECURITY_ENFORCED];
        
        // Make sure we can update the database before even trying
        if (!Schema.sObjectType.Interview__c.fields.Status__c.isUpdateable()) {
            return RecruitingUtil.setMsg('You do not have permission to update Interview status', false);
        }
        record.Status__c = status;
        update record;
        return RecruitingUtil.setMsg('Interview has been confirmed', true);
    }
    
    
    
    public static Interview__c getInterviewDetails(String recordId){
        Interview__c interview = [select Id, Contact__c, Contact__r.Name , Position__c, Position__r.Name , Interview_Type__c, Interview_Date__c 
         from Interview__c where Id=:recordId WITH SECURITY_ENFORCED];
        System.debug(interview);
        return interview;
        //return [select Id, Contact__c, Contact__r.Name, Position__c, Position__r.Name, Interview_Type__c, Interview_Date__c 
           // from Interview__c where Id=:recordId WITH SECURITY_ENFORCED];
    }

    
    
    
    
}