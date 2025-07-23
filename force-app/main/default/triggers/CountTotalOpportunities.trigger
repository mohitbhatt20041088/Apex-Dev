trigger CountTotalOpportunities on Opportunity (after insert,after update,after delete,after undelete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUndelete) {
            for (Opportunity opp : Trigger.new) {
                CountOpportunities.afterInsert(opp);
            }
        }

        if (Trigger.isUpdate) {
            for(Opportunity opp : Trigger.new){
                CountOpportunities.afterUpdate(opp, Trigger.oldMap.get(opp.Id));
            }
        }

        if (Trigger.isDelete) {
            for (Opportunity opp : Trigger.old) {
                CountOpportunities.afterDelete(opp);
            }
        }
    }
}