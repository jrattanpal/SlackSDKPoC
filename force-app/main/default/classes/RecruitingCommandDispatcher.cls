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
            System.debug('context::' + context);
            try{
                String commandText = parameters.getText();
                String[] commandSegments = (commandText != null)?commandText.split(' '):new List<String>();
                
                /*
                System.debug('commandText:: ' + commandText);
                System.debug('commandSegments:: ' + commandSegments);
                System.debug('context:: ' + this.context);
                System.debug('parameters:: ' + this.parameters); 
                System.debug('UserInfo.getUserId():' + UserInfo.getUserId());
                System.debug('UserInfo.getName():' + UserInfo.getName());
                /* */
                
                
                //If no params or "/recruiting help" is used then show possible commands
                String cmd =  (commandSegments.size() <= 0)?'help': commandSegments[0];

                ///recruiting interviews
                switch on cmd {
                    when 'interviews' {
                        Boolean showOldInterviews = (commandSegments.size() >= 2 && commandSegments[1] =='old')?true:false;
                        //If 3rd argument is a number 0 then use that number but cap it at 25 as there can be MANY old interviews
                        //If 3rd argument not specified then use 10
                        Integer numberOfInterviews = (commandSegments.size() >= 3 && Integer.valueOf(commandSegments[2]) >0)?Integer.valueOf(commandSegments[2]):10;
                        numberOfInterviews = (numberOfInterviews >25)?25:numberOfInterviews;
                        RecruitingFunctions.cmdInterviews(context, numberOfInterviews, showOldInterviews);
                    }
                    when else { RecruitingFunctions.generateHelp(context); }
                }
            }catch(Exception e){
                RecruitingUtil.debug(e.getMessage());
            }
        }
        
        
        
    }
}