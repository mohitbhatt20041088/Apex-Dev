trigger AccountDDescriptionUpdate on Contact (after update,after insert,after delete,after undelete) {


    if( Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete) ){ 
         Demo.countContactsRollup(Trigger.new,null);
     }



    if( Trigger.isUpdate && Trigger.isAfter ){ 
        // Demo.updateAccountDescriptionByChild(Trigger.new, Trigger.oldMap);
         Demo.countContactsRollup(Trigger.new, Trigger.oldMap);
     }

     if( Trigger.isAfter && Trigger.isDelete){ 
         Demo.countContactsRollup(Trigger.old,null);
      }
}