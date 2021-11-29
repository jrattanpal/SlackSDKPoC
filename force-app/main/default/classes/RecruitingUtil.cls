public with sharing class RecruitingUtil {
    public static void debug(Object message){
        System.debug(message);
    }
    public static RecruitingUtil.Message setMsg(String message, Boolean isOk){
        debug(message +' :::' + isOk);
        return new RecruitingUtil.Message(message, isOk);
    }
    
    public class Message{
        public string message = '';
        public boolean isOk = false;
        public Message(String message, boolean isOk){
            this.message = message;
            this.isOk = isOk;
        }
    }
    

}
