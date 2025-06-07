trigger AccountDDescriptionUpdate on Contact (after update) {


    if( Trigger.isUpdate && Trigger.isAfter ){ 
         Demo.updateAccountDescriptionByChild(Trigger.new, Trigger.oldMap);
     }
}