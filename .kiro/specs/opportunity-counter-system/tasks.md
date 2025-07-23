# Implementation Plan

- [x] 1. Create OpportunityCountService class with core business logic



  - Implement static methods for calculating count changes per Account
  - Add bulk update method for Account records with error handling
  - Include helper methods for data validation and aggregation
  - _Requirements: 2.2, 2.3, 3.2, 4.4_

- [ ] 2. Create OpportunityTriggerHandler class
  - Implement handler methods for each trigger event (insert, update, delete, undelete)
  - Add logic to collect affected Account IDs from opportunity records
  - Integrate with OpportunityCountService for count updates
  - Handle account changes in update scenarios (old vs new AccountId)
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.1, 4.1_

- [ ] 3. Update opportunity trigger to use new handler pattern
  - Modify existing trigger to call OpportunityTriggerHandler methods
  - Remove direct calls to old CountOpportunities class
  - Ensure all trigger events are properly handled (after insert, update, delete, undelete)
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 4.1_

- [ ] 4. Create comprehensive test class for OpportunityCountService
  - Write unit tests for count calculation methods
  - Test bulk Account update functionality with various scenarios
  - Add negative test cases for error handling and edge cases
  - Test scenarios with null AccountIds and data validation
  - _Requirements: 3.1, 3.2, 4.2_

- [ ] 5. Create comprehensive test class for OpportunityTriggerHandler
  - Write tests for each trigger event type with single and bulk records
  - Test account change scenarios in update operations
  - Add integration tests that verify end-to-end functionality
  - Test governor limit scenarios with 200+ records
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 4.2_

- [ ] 6. Create integration test class for complete trigger functionality
  - Write end-to-end tests that exercise the full trigger and handler flow
  - Test mixed operations (insert, update, delete in same transaction)
  - Verify data integrity and accurate count maintenance
  - Add performance tests for bulk operations
  - _Requirements: 2.1, 2.2, 3.3, 4.2_

- [ ] 7. Remove deprecated CountOpportunities class
  - Delete the old CountOpportunities.cls file after verifying new implementation works
  - Clean up any remaining references to the old class
  - Update any documentation or comments that reference the old implementation
  - _Requirements: 4.1, 4.3_