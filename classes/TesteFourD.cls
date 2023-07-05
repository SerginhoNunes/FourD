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
// A alteração realizada pensando em melhor eficiência, desempenho, utilização dos recursos e escalabilidade     
// Retirado a consulta de dentro do loop FOR
// Utilização do Set para armazenar os IDs das oportunidades
// Utilização de Map 
// Execução de apenas uma consulta
}