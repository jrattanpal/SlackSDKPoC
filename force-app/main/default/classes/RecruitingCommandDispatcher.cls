/*
This example apex class extends Slack.SlashCommandDispatcher and is responsible for 
responding to the Slack slash command registered with the Slack application.

This command will open a modal to view record details for Accounts, Contacts, and Opportunities

sample command:
/recruiting-view-past-interviews

If you run the command in a slack channel, you will see the option to post a message with record details there.
*/
public class RecruitingCommandDispatcher extends Slack.SlashCommandDispatcher {
    
    public override Slack.ActionHandler invoke(Slack.SlashCommandParameters parameters, Slack.RequestContext context) {
        //return Slack.ActionHandler.modal(new Handler(parameters, context));
        return Slack.ActionHandler.ack(new Handler(parameters, context));
    }
    
    //public class Handler implements Slack.ModalHandler {   
    public class Handler implements Slack.RunnableHandler {    
        
        Slack.SlashCommandParameters parameters;
        Slack.RequestContext context;
        
        public Handler (Slack.SlashCommandParameters parameters, Slack.RequestContext context) {
            this.parameters = parameters;
            this.context = context;
        }
        
        public void run () {    
            String commandText = parameters.getText();
            String[] commandSegments = (commandText != null)?commandText.split(' '):new List<String>();
            
            
            System.debug('commandText:: ' + commandText);
            System.debug('commandSegments:: ' + commandSegments);
            System.debug('context:: ' + this.context);
            System.debug('parameters:: ' + this.parameters); 
            
            
            
            //If no params or "/recruiting help" is used then show possible commands
            if (commandSegments.size() <= 0 || commandSegments[0] == 'help') {
                generateHelp(context);
            }else{

            }
        }
        
        
        private void generateHelp(Slack.RequestContext context){
            Slack.ViewReference viewReference = Slack.View.recruiting_help.get();
            
            RecruitingUtil.debug('viewReference:' + viewReference);
            
            //Use User client because message is started by user
            //RecruitingUtilSlack.sendView(false, context.getChannelId(), viewReference);
            RecruitingUtilSlack.sendView(context.getChannelId(), context.getUserId(), viewReference);
        }
        
        private Slack.ModalView viewRecord(String objectApiName, String recordId) {
            Slack.ViewReference viewReference;
            switch on objectApiName {
                when 'Account' { viewReference = Slack.View.view_account.get(); }
                when 'Contact' { viewReference = Slack.View.view_contact.get(); }
                when 'Opportunity' { viewReference = Slack.View.view_opportunity.get(); }
                when else { return MessageModal.getMessageModalView(
                    'Invalid Object', 
                    'The objectApiName was not a valid option. The view record command supports Account, Contact, and Opportunity'); }
            }
            System.debug('context.getchannelId(): ' + context.getchannelId() );
            System.debug('context.getUserId():' +  context.getUserId() );
            viewReference.setParameter('recordId', recordId);
            viewReference.setParameter('channelId', context.getchannelId());
            Slack.ModalView modalView = new Slack.ModalView.builder()
                .viewReference(viewReference)
                .build(); 
            return modalView;
        }
    }
}