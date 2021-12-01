public with sharing class RecruitingData {
    public static Interview__c getInterviewDetails(String recordId){
        Interview__c interview = [select Id, Contact__c, Contact__r.Name , Position__c, Position__r.Name , Interview_Type__c, Interview_Date__c 
         from Interview__c where Id=:recordId WITH SECURITY_ENFORCED];
        return interview;
        //return [select Id, Contact__c, Contact__r.Name, Position__c, Position__r.Name, Interview_Type__c, Interview_Date__c 
           // from Interview__c where Id=:recordId WITH SECURITY_ENFORCED];
    }
    //For scenarios where we want to use wrapper so we can use this method in views
    //Views don't allow us to use lookup object fields like Contact__r.Name so we have to use a wrapper
    public static InterviewWrapper getInterviewDetails(String recordId, Boolean useWrapper){
        Interview__c interview = [select Id, Status__c, Feedback__c, Contact__c, Contact__r.Name , Interviewer__c, Position__c, Position__r.Name , Interview_Type__c,Interview_Date__c
                                    from Interview__c 
                                    where Id=:recordId WITH SECURITY_ENFORCED];

        InterviewWrapper wrapper = new InterviewWrapper();
        wrapper.contactName = interview.Contact__r.Name;
        wrapper.positionName = interview.Position__r.Name;
        wrapper.status = interview.Status__c;
        wrapper.interviewType = interview.Interview_Type__c;
        wrapper.interviewDate = interview.Interview_Date__c.format('MMM d, y');
        wrapper.id = interview.Id;
        wrapper.confirmationNeeded = (interview.Interviewer__c != null && (interview.Status__c == 'Applied' || interview.Status__c == 'Interview Scheduled'))?true:false;
        wrapper.feedbackNeeded = (interview.Interviewer__c != null && interview.Status__c == 'Interview Completed' && String.isEmpty(interview.Feedback__c))?true:false;

        System.debug(wrapper);
        return wrapper;
        //return [select Id, Contact__c, Contact__r.Name, Position__c, Position__r.Name, Interview_Type__c, Interview_Date__c 
           // from Interview__c where Id=:recordId WITH SECURITY_ENFORCED];
    }
    public static List<InterviewWrapper> getInterviews(Id interviewerId, Integer numberOfRecords, Boolean showOldInterviews){
        List<Interview__c> interviews = new List<Interview__c>();
        if(showOldInterviews){

            interviews = [select Id, Status__c, Feedback__c, Contact__c, Contact__r.Name , Interviewer__c, Position__c, Position__r.Name , Interview_Type__c,Interview_Date__c
               from Interview__c                 
               where Interviewer__c=:interviewerId and Status__c in ('rejected', 'selected')  
               WITH SECURITY_ENFORCED               
               order by CreatedDate desc                
               Limit :numberOfRecords ];
        }else{
            interviews = [select Id, Status__c, Feedback__c, Contact__c, Contact__r.Name , Interviewer__c, Position__c, Position__r.Name , Interview_Type__c,Interview_Date__c
                from Interview__c 
                where Interviewer__c=:interviewerId and Status__c not in ('rejected', 'selected')
                WITH SECURITY_ENFORCED
                order by CreatedDate desc
                Limit :numberOfRecords ];
        }
        InterviewWrapper wrapper = new InterviewWrapper(interviews);

        RecruitingUtil.debug(wrapper.getInterviews());
        return wrapper.getInterviews();
    }

    public class InterviewWrapper{
        public String contactName = '';
        public String positionName = '';
        public String interviewType = '';
        public String interviewDate = '';
        public String id = '';
        public String status = '';
        public String feedback = '';
        public Boolean confirmationNeeded = false;
        public Boolean feedbackNeeded = false;

        private List<InterviewWrapper> interviews = new List<InterviewWrapper>();


        public InterviewWrapper(){

        }
        public InterviewWrapper(List<Interview__c> interviews){
            for(Interview__c interview: interviews){
                InterviewWrapper wrapper = new InterviewWrapper();
                wrapper.contactName = interview.Contact__r.Name;
                wrapper.positionName = interview.Position__r.Name;
                wrapper.status = interview.Status__c;
                wrapper.interviewType = interview.Interview_Type__c;
                wrapper.interviewDate = interview.Interview_Date__c.format('MMM d, y');
                wrapper.id = interview.Id;
                wrapper.confirmationNeeded = (interview.Interviewer__c != null && (interview.Status__c == 'Applied' || interview.Status__c == 'Interview Scheduled'))?true:false;
                wrapper.feedbackNeeded = (interview.Interviewer__c != null && interview.Status__c == 'Interview Completed' && String.isEmpty(interview.Feedback__c))?true:false;

                this.interviews.add(wrapper);
            }
        }

        public List<InterviewWrapper> getInterviews(){
            return this.interviews;
        }

    }
}