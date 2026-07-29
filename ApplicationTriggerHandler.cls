public with sharing class ApplicationTriggerHandler {

    public static void beforeInsert(List<Application__c> applications) {

        // Collect Student and Job IDs
        Set<Id> studentIds = new Set<Id>();
        Set<Id> jobIds = new Set<Id>();

        for (Application__c app : applications) {

            if (app.Student__c != null) {
                studentIds.add(app.Student__c);
            }

            if (app.Job__c != null) {
                jobIds.add(app.Job__c);
            }
        }

        // Query Students
        Map<Id, Student__c> studentMap = new Map<Id, Student__c>(
            [
                SELECT Id, CGPA__c
                FROM Student__c
                WHERE Id IN :studentIds
            ]
        );

        // Query Jobs
        Map<Id, Job__c> jobMap = new Map<Id, Job__c>(
            [
                SELECT Id,
                       Minimum_CGPA__c,
                       Last_Date__c
                FROM Job__c
                WHERE Id IN :jobIds
            ]
        );

        // Query Existing Applications (Duplicate Check)
        Set<String> existingApplications = new Set<String>();

        for (Application__c app : [
            SELECT Student__c, Job__c
            FROM Application__c
            WHERE Student__c IN :studentIds
            AND Job__c IN :jobIds
        ]) {

            existingApplications.add(app.Student__c + '-' + app.Job__c);
        }

        // Apply Business Rules
        for (Application__c app : applications) {

            Student__c student = studentMap.get(app.Student__c);
            Job__c job = jobMap.get(app.Job__c);

            // Rule 1: Duplicate Application
            String key = app.Student__c + '-' + app.Job__c;

            if (existingApplications.contains(key)) {
                app.addError('Student has already applied for this job.');
                continue;
            }

            // Rule 2: CGPA Validation
            if (student != null &&
                job != null &&
                student.CGPA__c < job.Minimum_CGPA__c) {

                app.addError('Student is not eligible. CGPA is below minimum requirement.');
                continue;
            }

            // Rule 3: Last Date Validation
            if (job != null &&
                job.Last_Date__c < Date.today()) {

                app.addError('Application deadline has passed.');
                continue;
            }

            // Rule 4: Default Status
            app.Status__c = 'Applied';
        }

    }

}

