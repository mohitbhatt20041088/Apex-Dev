trigger DemoTrigger_1 on Account(before insert,after update){
    if( Trigger.isInsert && Trigger.isBefore ){ 
        Demo.isPhoneBlank(Trigger.new);
    }

    else if( Trigger.isUpdate && Trigger.isAfter ){ 
         Demo.updateAccountPhoneAndContactphone(Trigger.new, Trigger.oldMap);
     }
}