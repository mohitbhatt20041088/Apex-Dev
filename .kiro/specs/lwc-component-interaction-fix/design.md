# Design Document

## Overview

This design addresses the broken `onClickHandler` functionality in the testComponent and improves the parent-child component interaction pattern. The main issues identified are:

1. Incorrect component selector in `querySelector` (using 'c-test-component' instead of 'c-test-child-component')
2. Method name mismatch ('changeMessageHanlder' vs 'changeMessageHandler')
3. Missing error handling for component interactions
4. Inconsistent coding patterns (mixing arrow functions and regular functions)

## Architecture

The solution maintains the existing Lightning Web Component architecture while fixing the interaction patterns:

```
TestComponent (Parent)
├── Toast Notification System
├── Event Handlers
└── Child Component Communication
    └── TestChildComponent (Child)
        └── Public API Methods
```

## Components and Interfaces

### TestComponent (Parent)
- **Purpose**: Main container component with toast functionality and child interaction
- **Key Methods**:
  - `handleOnClick()`: Triggers toast notification
  - `onClickHandler()`: Communicates with child component (FIXED)
  - `showToast()`: Displays toast notifications
- **Interactions**: Communicates with TestChildComponent via DOM queries and public API

### TestChildComponent (Child)
- **Purpose**: Child component with changeable message
- **Public API**:
  - `@api message`: Public property for message content
  - `@api changeMessageHandler()`: Public method to change message (FIXED NAME)
- **Interactions**: Receives calls from parent component

## Data Models

### Toast Configuration
```javascript
{
  title: string,
  message: string,
  variant: 'success' | 'error' | 'warning' | 'info'
}
```

### Component State
```javascript
// Parent Component
{
  myTitle: string,
  myMessage: string,
  myvarient: string // Note: keeping existing typo for backward compatibility
}

// Child Component
{
  message: string
}
```

## Error Handling

### Component Interaction Errors
1. **Child Component Not Found**: Display error toast if querySelector returns null
2. **Method Not Available**: Check if method exists before calling
3. **Method Execution Errors**: Wrap method calls in try-catch blocks

### Toast Notification Errors
1. **Invalid Parameters**: Provide default values for missing parameters
2. **Event Dispatch Errors**: Handle ShowToastEvent creation failures

## Testing Strategy

### Unit Tests
1. **Toast Functionality**: Test showToast method with various parameters
2. **Component Interaction**: Mock child component and test communication
3. **Error Handling**: Test scenarios where child component is unavailable
4. **Event Handlers**: Test both handleOnClick and onClickHandler methods

### Integration Tests
1. **Parent-Child Communication**: Test full interaction flow
2. **DOM Queries**: Verify correct component selection
3. **Toast Display**: Verify toast events are properly dispatched

## Implementation Fixes

### Primary Issues to Address
1. **Selector Fix**: Change `'c-test-component'` to `'c-test-child-component'`
2. **Method Name Fix**: Correct `changeMessageHanlder` to `changeMessageHandler`
3. **Error Handling**: Add null checks and try-catch blocks
4. **Code Consistency**: Standardize on arrow functions or regular functions

### Code Quality Improvements
1. **Typo Fix**: Consider fixing `myvarient` to `myVariant` (optional for backward compatibility)
2. **Method Consistency**: Standardize function declaration patterns
3. **Error Messages**: Add meaningful error messages for debugging