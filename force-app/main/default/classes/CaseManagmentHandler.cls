public with sharing class CaseManagmentHandler {
    @AuraEnabled(cacheable = true)
    public static List<Case> getMyOpenCases(){
        try {
            return [
                SELECT Id,CaseNumber,Subject,Status,Priority,CreatedDate
                FROM Case
                WHERE OwnerId =: UserInfo.getUserId() AND IsClosed = false
                ORDER BY CreatedDate Desc
            ];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
 

    @AuraEnabled 
    public static String updateCaseAction(String caseId,String actionType,String comment){
        try {


            final String ESCALATION_QUEUE_NAME = 'Case Escalated Queue';
            List<Group> queueList = [SELECT Id,Name FROM Group WHERE Type = 'Queue' AND Name =: ESCALATION_QUEUE_NAME AND Id IN (SELECT QueueId FROM QueueSobject WHERE SobjectType = 'Case') LIMIT 1];
            

            List<CaseComment> cclist = new List<CaseComment>();
            
            if (String.isNotBlank(comment)) {
                CaseComment cc = new CaseComment(
                    ParentId = caseId,
                    CommentBody = comment
                );
                insert cc;
                cclist = [SELECT Id,CommentBody FROM CaseComment WHERE ParentId =: caseId ORDER BY CreatedDate DESC LIMIT 1];
            }

            if (actionType == 'Escalate') {
                System.debug('Queue List Size: ' + queueList.size());
                if (!queueList.isEmpty()) {
                    System.debug('Queue ID: ' + queueList[0].Id);
                }
                
                Case caseToUpdate = new Case(Id = caseId, IsEscalated = true, Priority = 'High',OwnerId = queueList.size() == 1 ? queueList[0].Id : null);
                System.debug('Case Owner ID being set to: ' + caseToUpdate.OwnerId);
                
                if (caseToUpdate.OwnerId != null) {
                    update caseToUpdate;
                    System.debug('Case updated successfully');
                } else {
                    System.debug('Case not updated - OwnerId is null');
                }

                
                
                if (caseToUpdate.OwnerId != UserInfo.getUserId()) {
                    List<Case> caseDetails = [SELECT CaseNumber, Status, Priority FROM Case WHERE Id =: caseId LIMIT 1];
                
                
                Case_Escalation_log__c log = new Case_Escalation_log__C(
                    Case__c = caseId,
                    Case_Number__c = !caseDetails.isEmpty() ? caseDetails[0].CaseNumber : null,
                    Case_Status_at_Time_of_Action__c = !caseDetails.isEmpty() ? caseDetails[0].Status : null,
                    Comment__c = !cclist.isEmpty() ? cclist[0].CommentBody : null,
                    Priority__c = 'High',
                    Status__c = 'Escalated',
                    Time_Stamp__c = DateTime.now(),
                    User__c = UserInfo.getUserId(),
                    Assign_To__c = queueList[0].Name

                );
                insert log;
                String updatedCaseNumber = !caseDetails.isEmpty() ? caseDetails[0].CaseNumber : 'Unknown';
                return 'Case '+updatedCaseNumber+' has been escalated';
                }
                return 'no log created';
            }

            if (actionType == 'Close') {
                Case caseToUpdate = new Case(Id = caseId, Status = 'Closed');
                update caseToUpdate;
                
                List<Case> caseDetails = [SELECT CaseNumber, Status, Priority FROM Case WHERE Id =: caseId LIMIT 1];
                
                Case_Escalation_log__c log = new Case_Escalation_log__C(
                    Case__c = caseId,
                    Case_Number__c = !caseDetails.isEmpty() ? caseDetails[0].CaseNumber : null,
                    Case_Status_at_Time_of_Action__c = !caseDetails.isEmpty() ? caseDetails[0].Status : null,
                    Comment__c = !cclist.isEmpty() ? cclist[0].CommentBody : null,
                    Priority__c = !caseDetails.isEmpty() ? caseDetails[0].Priority : null,
                    Status__c = 'Closed',
                    Time_Stamp__c = DateTime.now(),
                    User__c = UserInfo.getUserId(),
                    Assign_To__c = queueList[0].Name
                    
                );
                insert log;
                String updatedCaseNumber = !caseDetails.isEmpty() ? caseDetails[0].CaseNumber : 'Unknown';
                return 'Case '+updatedCaseNumber+' has been closed';
            }

            return 'No Action is Performed';
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void afterUpdate(Case oldCase, Case newCase){
        final String ESCALATION_QUEUE_NAME = 'Case Escalated Queue';
        List<Group> queueList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name =: ESCALATION_QUEUE_NAME LIMIT 1];
        List<Case> casesToAssign = new List<Case>();
        
        if (queueList.size() > 0) {
            if (oldCase.IsEscalated != newCase.IsEscalated && newCase.IsEscalated == true) {
                Case caseForUpdate = new Case(
                    Id = newCase.Id,
                    OwnerId = queueList[0].Id
                );
                casesToAssign.add(caseForUpdate);
            }
        }
        if (!casesToAssign.isEmpty()) {
            update casesToAssign;
        }
    }
}
