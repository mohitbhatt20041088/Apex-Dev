public with sharing class OpportunityCountService {
    
    /**
     * Updates Account opportunity counts based on the provided count changes
     * @param accountCountChanges Map of Account ID to count change (positive or negative)
     */
    public static void updateAccountCounts(Map<Id, Integer> accountCountChanges) {
        if (accountCountChanges == null || accountCountChanges.isEmpty()) {
            return;
        }
        
        try {
            // Query current Account records to get existing counts
            Map<Id, Account> accountsToUpdate = new Map<Id, Account>([
                SELECT Id, Total_Opportunities__c 
                FROM Account 
                WHERE Id IN :accountCountChanges.keySet()
            ]);
            
            // Calculate new counts for each Account
            List<Account> accountsForUpdate = new List<Account>();
            for (Id accountId : accountCountChanges.keySet()) {
                Account acc = accountsToUpdate.get(accountId);
                if (acc != null) {
                    Integer currentCount = (acc.Total_Opportunities__c != null) ? 
                        Integer.valueOf(acc.Total_Opportunities__c) : 0;
                    Integer countChange = accountCountChanges.get(accountId);
                    Integer newCount = Math.max(0, currentCount + countChange); // Ensure count never goes negative
                    
                    acc.Total_Opportunities__c = newCount;
                    accountsForUpdate.add(acc);
                }
            }
            
            // Bulk update with partial success handling
            if (!accountsForUpdate.isEmpty()) {
                Database.SaveResult[] results = Database.update(accountsForUpdate, false);
                logUpdateErrors(results, accountsForUpdate);
            }
            
        } catch (Exception e) {
            System.debug('Error in OpportunityCountService.updateAccountCounts: ' + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Calculates count changes for opportunities with a given multiplier
     * @param opportunities List of opportunities to process
     * @param multiplier 1 for increment, -1 for decrement
     * @return Map of Account ID to count change
     */
    public static Map<Id, Integer> calculateCountChanges(List<Opportunity> opportunities, Integer multiplier) {
        Map<Id, Integer> accountCountChanges = new Map<Id, Integer>();
        
        if (opportunities == null || opportunities.isEmpty()) {
            return accountCountChanges;
        }
        
        for (Opportunity opp : opportunities) {
            if (opp.AccountId != null) {
                Integer currentChange = accountCountChanges.get(opp.AccountId);
                if (currentChange == null) {
                    currentChange = 0;
                }
                accountCountChanges.put(opp.AccountId, currentChange + multiplier);
            }
        }
        
        return accountCountChanges;
    }
    
    /**
     * Handles account changes during opportunity updates
     * @param newOpportunities List of new opportunity records
     * @param oldOpportunities List of old opportunity records
     * @return Map of Account ID to count change
     */
    public static Map<Id, Integer> calculateAccountChangeCountUpdates(List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities) {
        Map<Id, Integer> accountCountChanges = new Map<Id, Integer>();
        
        if (newOpportunities == null || oldOpportunities == null || 
            newOpportunities.size() != oldOpportunities.size()) {
            return accountCountChanges;
        }
        
        for (Integer i = 0; i < newOpportunities.size(); i++) {
            Opportunity newOpp = newOpportunities[i];
            Opportunity oldOpp = oldOpportunities[i];
            
            // Check if AccountId changed
            if (newOpp.AccountId != oldOpp.AccountId) {
                // Decrement old account (if it exists)
                if (oldOpp.AccountId != null) {
                    Integer oldAccountChange = accountCountChanges.get(oldOpp.AccountId);
                    if (oldAccountChange == null) {
                        oldAccountChange = 0;
                    }
                    accountCountChanges.put(oldOpp.AccountId, oldAccountChange - 1);
                }
                
                // Increment new account (if it exists)
                if (newOpp.AccountId != null) {
                    Integer newAccountChange = accountCountChanges.get(newOpp.AccountId);
                    if (newAccountChange == null) {
                        newAccountChange = 0;
                    }
                    accountCountChanges.put(newOpp.AccountId, newAccountChange + 1);
                }
            }
        }
        
        return accountCountChanges;
    }
    
    /**
     * Logs errors from Database.update operations
     * @param results SaveResult array from Database.update
     * @param accounts List of accounts that were updated
     */
    private static void logUpdateErrors(Database.SaveResult[] results, List<Account> accounts) {
        for (Integer i = 0; i < results.size(); i++) {
            Database.SaveResult result = results[i];
            if (!result.isSuccess()) {
                Account failedAccount = accounts[i];
                System.debug('Failed to update Account ' + failedAccount.Id + ': ' + 
                    result.getErrors()[0].getMessage());
            }
        }
    }
}