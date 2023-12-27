/**
 * Created by anthonybarrow on 27/12/2023.
 */

public with sharing class ETM_CSV_Util_Queueable implements Queueable, Finalizer {
    private  Id contentDocumentId = null;

    public ETM_CSV_Util_Queueable() {
    }

    public ETM_CSV_Util_Queueable(Id contentDocumentId) {
        this.contentDocumentId = contentDocumentId;
    }

    public void execute(QueueableContext context) {
        System.debug('contentDocumentId=' + this.contentDocumentId);
        // Create an instance of Finalizer and attach it
        ETM_CSV_Util_Queueable f = new ETM_CSV_Util_Queueable();
        System.attachFinalizer(f);
        f.contentDocumentId = this.contentDocumentId;

        // Get VersionData
        ContentVersion cv=[SELECT
                Id,
                ContentDocumentId,
                VersionData
        FROM ContentVersion WHERE ContentDocumentId=:this.contentDocumentId AND IsLatest = TRUE];

        Integer i = 0;
        for (List<String> csvData : CSVFileUtil.parseCSV(cv.VersionData, false)) {
            for (String csvLine : csvData) {
                System.debug(csvLine);
            }
            System.debug('########');
            if (i++ > 5) {
                break;
            }

        }

        System.debug('CPU consumed: ' + Limits.getCpuTime());
        System.debug('CPU limit: ' + Limits.getLimitCpuTime());
    }

    public void execute(FinalizerContext context) {
        System.debug('Landed in Finalizer');
        // Get the Id for our custom notification type
        CustomNotificationType notificationType = [SELECT Id, DeveloperName
            FROM CustomNotificationType
            WHERE DeveloperName='ETM_Import_Complete'];

        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        // Set the contents for the notification
        notification.setTitle('ETM Import Completed');
        notification.setBody('Here is a cool message from the Queuable processor!');

        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(this.contentDocumentId);

        // Actually send the notification
        try {
            System.debug('contentDocumentId=' + this.contentDocumentId);
            System.debug('Before sending the notification');
            notification.send(new Set<String>{UserInfo.getUserId()});
            System.debug('after sending the notification');
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}