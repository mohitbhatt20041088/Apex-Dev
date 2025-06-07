trigger MarketplaceTrigger on MarketPlace__c (after insert,after update,after delete) {

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    {
        MarketplaceHandler.marketplaceInsertOrUpdate(Trigger.new);
    }

    else if(Trigger.isAfter && Trigger.isDelete){
        MarketplaceHandler.marketplaceDelete(Trigger.old);
    }

    
    
    
    
}