// recruitingInterviewNotification.js
import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import notifyInterviewerForNewInterview from '@salesforce/apex/RecruitingFunctions.notifyInterviewerForNewInterview';
import notifyInterviewerForFeedback from '@salesforce/apex/RecruitingFunctions.notifyInterviewerForFeedback';


const FIELDS = [
    'Interview__c.Status__c',
    'Interview__c.Feedback__c',
    'Interview__c.Interviewer__c'
];

export default class RecruitingInterviewNotification extends LightningElement {
    @api recordId;

    interview;
    error;
    needInterviewConfirmation = false;
    needInterviewFeedback = false;
    needNoActons = true;


    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data}){
        console.log('data', data);
        console.log('error', error);
        if (data) {
            this.interview = data;
            this.error = undefined;
            
            //Use Getters for Status, interviewer and feedback
            this.needInterviewConfirmation = (this.status == 'Interview Scheduled' && this.interviewer != null)?true:false;
            this.needInterviewFeedback = (this.status == 'Interview Completed' && this.feedback == null)?true:false;

            this.needNoActons = (this.needInterviewConfirmation || this.needInterviewFeedback)?false:true;
        } else if (error) {
            this.error = error;
            this.interview = undefined;
        }
    };



    get status() {
        return this.interview.fields.Status__c.value;
    }
    get feedback() {
        return this.interview.fields.Feedback__c.value;
    }
    get interviewer() {
        return this.interview.fields.Interviewer__c.value;
    }


    notifyForConfirmation(){
        notifyInterviewerForNewInterview({recordId: this.recordId, salesforceUserId: null, headerText: 'Confirm your interview'})
            .then((result) => {
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
            });
    }


    notifyForFeedback(){
        notifyInterviewerForFeedback({recordId: this.recordId, salesforceUserId: null, headerText: 'Provide feedback'})
            .then((result) => {
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
            });
    }
}