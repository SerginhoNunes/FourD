public class WhatsAppController {
    
    public ApexPages.StandardController stdController { get; set; }
    public String leadId { get; set; }
    public String mensagemResult { get; set; }
    public String errorMessage { get; set; }
    
    public WhatsAppController(ApexPages.StandardController controller) {
        stdController = controller;
    }
    
    public void enviarMensagem() {
        leadId = stdController.getId();
        
        if (String.isBlank(leadId)) {
            errorMessage = 'ID do Lead não foi fornecido.';
            mensagemResult = '';
            return;
        }
        
        try {
            String apiToken = 'Whatsapp_Token';
            
            WhatsAppAPI.authenticate(apiToken);
            
            Lead lead = [SELECT Id, FirstName, LastName, Phone FROM Lead WHERE Id = :leadId LIMIT 1];
            //String phoneNumber = lead.Phone;
            String message = 'Olá ' + lead.FirstName + ' ' + lead.LastName + ', tudo bem? Informamos que já estamos analisando seu cadastro para se tornar um de nossos clientes. Em breve retornaremos o contato.';
            
            boolean isMessageSent = WhatsAppAPI.sendMessage(lead.Phone, message, apiToken);
            
            if (isMessageSent) {
                mensagemResult = 'Mensagem enviada com sucesso para o número ' + lead.Phone + '.';
                errorMessage = '';
            } else {
                errorMessage = 'Ocorreu um erro ao enviar a mensagem.';
                mensagemResult = '';
            }
        } catch (Exception e) {
            errorMessage = 'Ocorreu um erro: ' + e.getMessage();
            mensagemResult = '';
        }
    }
}