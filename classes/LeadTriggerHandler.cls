public with sharing class LeadTriggerHandler {
    public static void onBeforeInsert(List<Lead> newLeads) {
        validatePostalCodes(newLeads);
    }
    
    public static void onBeforeUpdate(Map<Id, Lead> updatedLeads) {
        validatePostalCodes(updatedLeads.values());
    }
    
    private static void validatePostalCodes(List<Lead> leads) {
        for (Lead lead : leads) {
            if (lead.PostalCode != null) {
                String postalCode = lead.PostalCode.trim();
                
                if (!isValidPostalCode(postalCode)) {
                    lead.addError('CEP inválido. Insira um CEP válido no formato XXXXX-XXX ou XXXXXXXX apenas números.');
                } else {
                    lead.PostalCode = formatPostalCode(postalCode);
                }
            }
        }
    }
    
    private static Boolean isValidPostalCode(String postalCode) {
        // Verifica se o CEP possui o formato correto
        // (XXXXX-XXX ou XXXXXXXX apenas números)
        String postalCodePattern = '^\\d{5}-\\d{3}$|^\\d{8}$';
        return Pattern.matches(postalCodePattern, postalCode);
    }
    
    private static String formatPostalCode(String postalCode) {
        // Formata o CEP no formato XXXXX-XXX
        if (postalCode.length() == 8) {
            return postalCode.substring(0, 5) + '-' + postalCode.substring(5);
        }
        return postalCode;
    }
}