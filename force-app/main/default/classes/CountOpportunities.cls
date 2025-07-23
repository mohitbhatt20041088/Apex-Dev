public with sharing class CountOpportunities {
    public static Set<Id> accIds = new Set<Id>();
    public static void afterInsert(Opportunity opp){
        List<Account> acclist = new List<Account>();
        if(opp.AccountId != null){
            accIds.add(opp.AccountId);
        }

        CountOpportunitiesHelper.CountOpportunities(accIds);

    }
    public static void afterUpdate(Opportunity oppNew , Opportunity oppOld){
        if(oppNew.AccountId != oppOld.AccountId)
        {
            if(oppNew != null){
                accIds.add(oppNew.AccountId);
            }
            if(oppOld != null){
                accIds.add(oppOld.AccountId);
            }
        }

        CountOpportunitiesHelper.CountOpportunities(accIds);

    }

    public static void afterDelete(Opportunity opp){
        if (opp.AccountId != null) {
            accIds.add(opp.AccountId);
        }
        CountOpportunitiesHelper.CountOpportunities(accIds);
    }
}