public class RecruitingMessageModal {
    public static Slack.ModalView getMessageModalView (String title, String message) {
        Slack.ViewReference viewReference = Slack.View.message_modal.get();
        viewReference.setParameter('title', title);
        viewReference.setParameter('message', message);
        Slack.ModalView modalView = new Slack.ModalView.builder()
            .viewReference(viewReference)
            .build(); 
        return modalView;
    }
}