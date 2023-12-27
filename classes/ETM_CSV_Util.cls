/**
 * Created by anthonybarrow on 27/12/2023.
 */

public with sharing class ETM_CSV_Util {

    final Id contentDocumentId;

    public ETM_CSV_Util(Id contentDocumentId) {
        this.contentDocumentId = contentDocumentId;
    }

    public void processCSVFile() {
        System.debug('contentDocumentId=' + this.contentDocumentId);
        ContentVersion cv=[SELECT
                Id,
                ContentDocumentId,
                VersionData
        FROM ContentVersion WHERE ContentDocumentId=:this.contentDocumentId ];

// ACB commented these lines as was getting the expected "System.LimitException: Regex too complicated"
//        Blob csvFileBody = cv.VersionData;
//        String csvAsString= csvFileBody.toString();
//        List<String> csvFileLines= csvAsString.split('\n');
//
//        for (Integer i=0 ; i < 10 ; i++) {
//            System.debug(csvFileLines[i]);
//
//        }

        //System.debug(CSVFileUtil.parseCSV(cv.VersionData, false));
        Integer i = 0;
        for (List<String> csvData : CSVFileUtil.parseCSV(cv.VersionData, false)) {
            for (String csvLine : csvData) {
                System.debug(csvLine);
                if (i++ > 10) {
                    break;
                }
            }
            break;
        }
    }

    public void processCSVFileQueueable() {
        ETM_CSV_Util_Queueable etmcsvUtilQueueable = new ETM_CSV_Util_Queueable(this.contentDocumentId);
        System.enqueueJob(etmcsvUtilQueueable);
    }

}