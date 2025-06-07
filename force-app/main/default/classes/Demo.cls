public class Demo {
    public static void isPhoneBlank(List<Account> accList){
        if( accList.size() > 0 ){
            for( Account acc : accList) {
                if(String.isBlank(acc.Phone)){
                    acc.Phone.addError('You cannot left the phone filed empty!!!');
                }
            }
        }
    }
    
    
    public static void updateAccountPhoneAndContactphone(List<Account> accNewList , Map<Id,Account> accOldMap)
    {
        
        Map<Id, Account> updatedAccounts = new Map<Id, Account>();
        if( accNewList.size() > 0 && !accOldMap.isEmpty() ){
            for (Account acc : accNewList) {
                String oldPhone = accOldMap.get(acc.Id).Phone != null ? accOldMap.get(acc.Id).Phone.trim() : '';
                String newPhone = acc.Phone != null ? acc.Phone.trim() : '';
                
                if( oldPhone != newPhone ){
                    updatedAccounts.put(acc.Id, acc);
                }
            }
            List<Contact> conList = new List<Contact>();
            for( Contact con : [SELECT AccountId, Id, Phone FROM Contact WHERE AccountId IN : updatedAccounts.keySet()]) {
                con.Phone = updatedAccounts.get(con.AccountId).Phone;
                conList.add(con);
            }
            
            if( !conList.isEmpty() ){
                UPDATE conList;
            }
        }
    }
    
    public static void updateAccountDescriptionByChild(List<Contact> conNewList , Map<Id,Contact> conOldMap) {
        Set<Id> accIds = new Set<Id>();
        if( conNewList.size() > 0 && !conOldMap.isEmpty() ){
            for (Contact con : conNewList) {
                String oldDescription = conOldMap.get(con.Id).Description != null ?  conOldMap.get(con.Id).Description.trim() : '';
                String newDescription = con.Description != null ? con.Description.trim() :'';
                
                if( oldDescription != newDescription ){
                    accIds.add(con.AccountId);
                }
            }
        }
        List<Account> updatedAccounts = new List<Account>();
        Map<Id, Account> accMap = new Map<Id, Account>();
        
        /*if( !conNewList.isEmpty() ){
            for (Account acc : [SELECT Id, Description FROM Account WHERE Id IN : accIds]) {
                for (Contact con : conNewList) {
                    acc.Description = con.Description;
                    updatedAccounts.add(acc);
                }
            }
        }*/
        
        for(Account acc : [SELECT Id, Description FROM Account WHERE Id IN : accIds]){
            accMap.put(acc.Id, acc);
        }
        
        for (Contact con : conNewList) {
            Account acc = accMap.get(con.AccountId);
            acc.Description = con.Description;
            updatedAccounts.add(acc);
        }
        
        
        
        if( !updatedAccounts.isEmpty() ){
            UPDATE updatedAccounts;
        }
    }
    
    
    
    
    
    
    public static void countContactsRollup(List<Contact> conList , Map<Id,Contact> conMap) {
        
        Set<Id> accIds = new Set<Id>();
        
        if( !conList.isEmpty() && conMap == null ){ //* for insert case
            for (Contact con : conList) {
                if( con.AccountId != null ){
                    accIds.add(con.AccountId);
                }
            }
        }
        else if( !conList.isEmpty() && !conMap.isEmpty() ){ //* for update and re-parenting case
            for (Contact con : conList) {
                if( con.AccountId != conMap.get(con.Id).AccountId ){
                    accIds.add(con.AccountId);
                } if( con.AccountId != null ){
                    accIds.add(con.AccountId);
                }if( conMap.get(con.Id).AccountId != null){
                    accIds.add(conMap.get(con.Id).AccountId);
                }
            }
        }

        List<Account> updatedAccounts = new List<Account>();

        if( !accIds.isEmpty() ){ 
             for (Account acc : [SELECT Id,Count_Contacts__c,(SELECT Id FROM Contacts) FROM Account WHERE Id IN : accIds]) {
                acc.Count_Contacts__c = acc.Contacts.size();
                updatedAccounts.add(acc);
             }
         }

         if( !updatedAccounts.isEmpty() ){ 
             UPDATE updatedAccounts;
          }



        
    }
    
    
}