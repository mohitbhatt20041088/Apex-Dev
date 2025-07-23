public with sharing class CountOpportunitiesHelper {
    public static void CountOpportunities(Set<Id> accountIds){
        List<Account> accounts = new List<Account>();
        if (!accountIds.isEmpty()) {
            for(Account acc : [SELECT Id,(SELECT Id FROM Opportunities) FROM Account WHERE Id IN : accountIds]){
                Account obj = new Account();
                obj.Id = acc.Id;
                obj.Total_Opportunities__c = acc.Opportunities.size();
                accounts.add(obj);
            }
        }

        if (accounts.size() > 0) {
            UPDATE accounts;
        }
    }
}