trigger Trigger3 on Account (before update) {
    if(Trigger.isBefore && Trigger.isUpdate){
        if(!PreventRecursion.isFlag){
            TriggersHandler.updatePhoneOnAccountDesc(Trigger.new,Trigger.oldMap);
            PreventRecursion.isFlag = true;
        }
    }
    PreventRecursion.isFlag = false;
}