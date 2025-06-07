trigger Trigger1 on Account (before insert) {
    if (Trigger.isInsert && Trigger.isBefore) {
        if(!PreventRecursion.isFlag){
            TriggersHandler.accountRatingHot(Trigger.new);
        }
        PreventRecursion.isFlag = true;
    }
    PreventRecursion.isFlag = false;
}