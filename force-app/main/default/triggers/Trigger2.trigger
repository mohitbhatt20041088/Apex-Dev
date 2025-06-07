trigger Trigger2 on Account (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        if(!PreventRecursion.isFlag){
            TriggersHandler.createRelatedChildContact(Trigger.new);
            PreventRecursion.isFlag = true;
        }
    }
    PreventRecursion.isFlag = false;
}