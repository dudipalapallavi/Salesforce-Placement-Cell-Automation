# Placement Cell Automation using Apex Trigger

## Project Overview
This project automates the Placement Cell application process using Salesforce Apex Triggers.

## Business Requirements
- Prevent duplicate job applications.
- Validate student's CGPA.
- Reject applications after the last date.
- Automatically set the Status to "Applied".

## Objects Used
### Student__c
- Student Name
- CGPA__c

### Job__c
- Job Name
- Minimum_CGPA__c
- Last_Date__c

### Application__c
- Student__c (Lookup)
- Job__c (Lookup)
- Status__c

## Technologies Used
- Salesforce
- Apex Trigger
- Apex Classes
- SOQL
- Trigger Handler Pattern
- Collections (List, Set, Map)

## Features
- Duplicate Application Prevention
- CGPA Validation
- Last Date Validation
- Default Status = Applied

## Why Trigger?
The business logic should execute automatically whenever a new Application record is created.

## Why Before Insert?
It validates the record before saving and sets the default status without an additional DML operation.

## Bulkification
- Used Sets to collect IDs.
- Used Maps for quick lookup.
- No SOQL inside loops.
- No DML inside loops.

## Learning Outcomes
- Apex Triggers
- Trigger Handler Pattern
- Governor Limits
- Bulkification
- SOQL
- Collections (List, Set, Map)

## Author
Dudipala Pallavi
