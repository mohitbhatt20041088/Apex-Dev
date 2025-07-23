
public with sharing class Test {
    
    @AuraEnabled
    public static List<Account> getAccounts(){
        try {
            List<Account> accounts = [SELECT Id,Name,AccountNumber,AnnualRevenue FROM Account];
            return accounts;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

 
}