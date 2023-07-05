@isTest
private class LeadTriggerTest {
    @TestSetup
    static void setupTestData() {
        List<Lead> leads = new List<Lead>();

        Lead lead1 = new Lead();
        lead1.LastName = 'Silva';
        lead1.Company = 'Test Company';
        lead1.PostalCode = '12345678';
        leads.add(lead1);

        Lead lead2 = new Lead();
        lead2.LastName = 'Alves';
        lead2.Company = 'Test Company';
        lead2.PostalCode = '12345678';
        leads.add(lead2);

        insert leads;
    }

    @isTest
    static void testBeforeInsert() {
        List<Lead> leads = new List<Lead>();

        // Sucesso
        Lead lead1 = new Lead();
        lead1.LastName = 'Silva';
        lead1.Company = 'Test Company';
        lead1.PostalCode = '12345678';
        leads.add(lead1);

        // Falha
        Lead lead2 = new Lead();
        lead2.LastName = 'Alves';
        lead2.Company = 'Test Company';
        lead2.PostalCode = '12A34-567';
        leads.add(lead2);

        Test.startTest();
        	insert leads;
        Test.stopTest();

        // Verifica se os CEPs foram formatados corretamente para os registros de sucesso
        List<Lead> updatedLeads = [SELECT PostalCode FROM Lead WHERE Id IN :leads];
        System.assertEquals('12345-678', updatedLeads[0].PostalCode);

        // Verifica se os erros foram emitidos corretamente para os registros de falha
        List<Lead> errorLeads = [SELECT PostalCode FROM Lead WHERE Id IN :leads AND PostalCode = '12A34-567'];
        System.assertEquals(1, errorLeads.size());
    }

    @isTest
    static void testBeforeUpdate() {
        List<Lead> leads = [SELECT Id, PostalCode FROM Lead];

        // Sucesso
        leads[0].PostalCode = '87654321';

        // Falha
        leads[1].PostalCode = '98B76@5432';

        Test.startTest();
        	update leads;
        Test.stopTest();

        // Verifica se os CEPs foram formatados corretamente para os registros de sucesso
        List<Lead> updatedLeads = [SELECT PostalCode FROM Lead WHERE Id IN :leads];
        System.assertEquals('87654-321', updatedLeads[0].PostalCode);

        // Verifica se os erros foram emitidos corretamente para os registros de falha
        List<Lead> errorLeads = [SELECT PostalCode FROM Lead WHERE Id IN :leads AND PostalCode = '98B76@5432'];
        System.assertEquals(1, errorLeads.size());
    }
}