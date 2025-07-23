# Requirements Document

## Introduction

This feature involves creating a robust system to automatically count and maintain the total number of opportunities associated with each Account in Salesforce. The system should handle all opportunity lifecycle events (insert, update, delete, undelete) and ensure accurate counts are maintained on the Account's Total_Opportunities__c field.

## Requirements

### Requirement 1

**User Story:** As a Salesforce administrator, I want the system to automatically count opportunities for each account, so that I can have accurate reporting and visibility into account activity.

#### Acceptance Criteria

1. WHEN an opportunity is inserted THEN the system SHALL increment the Total_Opportunities__c field on the associated Account
2. WHEN an opportunity is deleted THEN the system SHALL decrement the Total_Opportunities__c field on the associated Account
3. WHEN an opportunity is undeleted THEN the system SHALL increment the Total_Opportunities__c field on the associated Account
4. WHEN an opportunity's AccountId is changed THEN the system SHALL decrement the count on the old Account and increment the count on the new Account

### Requirement 2

**User Story:** As a system administrator, I want the opportunity counting system to handle bulk operations efficiently, so that data loads and mass updates don't cause performance issues or governor limit violations.

#### Acceptance Criteria

1. WHEN multiple opportunities are processed in a single transaction THEN the system SHALL handle them in bulk without exceeding governor limits
2. WHEN processing bulk operations THEN the system SHALL aggregate updates per Account to minimize DML operations
3. WHEN the system encounters errors THEN it SHALL handle them gracefully without causing the entire transaction to fail

### Requirement 3

**User Story:** As a data quality manager, I want the opportunity counting system to maintain data integrity, so that the Total_Opportunities__c field always reflects the actual number of opportunities.

#### Acceptance Criteria

1. WHEN calculating opportunity counts THEN the system SHALL only count opportunities that have a valid AccountId
2. WHEN updating Account records THEN the system SHALL use proper exception handling to prevent data corruption
3. WHEN static variables are used THEN the system SHALL properly manage their scope to prevent cross-transaction contamination
4. WHEN the system runs THEN it SHALL maintain transactional integrity and rollback changes if errors occur

### Requirement 4

**User Story:** As a developer, I want the opportunity counting system to follow Salesforce best practices, so that the code is maintainable, testable, and follows platform conventions.

#### Acceptance Criteria

1. WHEN implementing the solution THEN the system SHALL use proper trigger patterns with handler classes
2. WHEN writing code THEN the system SHALL include comprehensive test coverage (minimum 75%)
3. WHEN designing the architecture THEN the system SHALL separate concerns between trigger logic and business logic
4. WHEN handling data operations THEN the system SHALL use bulkified patterns and avoid SOQL/DML in loops