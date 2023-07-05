public class TesteFourD {
    public static void bloqueiaIntegracao(List<Opportunity> opps) {
        Set<Id> opportunityIds = new Set<Id>();
        
        for (Opportunity opp : opps) {
            opportunityIds.add(opp.Id);
        }

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
            SELECT Id
            FROM Opportunity
            WHERE Id IN :opportunityIds
            AND Id NOT IN (
                SELECT OpportunityId
                FROM OpportunityContactRole
                WHERE Role = 'Responsável Financeiro'
            )
        ]);

        for (Opportunity opp : opps) {
            if (oppMap.containsKey(opp.Id)) {
                opp.addError('É necessário ter o papel financeiro alinhado na oportunidade.');
            }
        }
    }
}