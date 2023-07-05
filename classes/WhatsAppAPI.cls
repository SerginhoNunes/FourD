public class WhatsAppAPI {
    
    public static void authenticate(String authToken) {
        if (String.isBlank(authToken)) {
            throw new WhatsAppException('Token de autenticação inválido.');
        }
        
        System.debug('Autenticação na API do WhatsApp realizada com sucesso.');
    }
    
    public static boolean sendMessage(String phoneNumber, String message, String apiToken) {
        if (String.isBlank(phoneNumber)) {
            throw new WhatsAppException('Número de telefone inválido.');
        }
        
        if (String.isBlank(message)) {
            throw new WhatsAppException('Mensagem inválida.');
        }
        
        // Create an instance of the Http class
        Http http = new Http();
        
        // Create an instance of the HttpRequest class
        HttpRequest req = new HttpRequest();
        
        // Set the endpoint URL for the WhatsApp API
        req.setEndpoint('Endpoint_Whatsapp'); 
        
        // Set the necessary request headers and content type
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + apiToken);
        
        // Set the request method to POST
        req.setMethod('POST');
        
        // Construct the request body
        String requestBody = '{"messaging_product":"whatsapp", "to":"' + phoneNumber + '", "type":"template", "template":{"name":"snunes_alert","language":{"code":"en-US"}}}';
        
        // Set the request body
        req.setBody(requestBody);
        
        // Send the HTTP request and get the response
        HttpResponse res = http.send(req);
        
        // Check the response status code
        if (res.getStatusCode() == 200) {
            return true; // Message sent successfully
        } else {
            return false; // Failed to send the message
        }
    }
}