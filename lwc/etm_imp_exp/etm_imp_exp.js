/**
 * Created by anthonybarrow on 27/12/2023.
 */

import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { loadStyle } from 'lightning/platformResourceLoader';
//import fileSelectorStyle from '@salesforce/resourceUrl/fileSelectorStyle';

export default class FileUploadExample extends LightningElement {
    @api recordId;

    get acceptedFormats() {
        return ['.csv'];
    }

    connectedCallback() {
        // Promise.all([
        //     loadStyle(this, fileSelectorStyle)
        // ]);
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files.length;
        console.dir(event.detail.files);

        const evt = new ShowToastEvent({
            title: 'SUCCESS',
            message: ' File uploaded successfully - will now be processed!',
            variant: 'success',
        });
        this.dispatchEvent(evt);

        // Print file details to console
        const uploadedFile = event.detail.files[0];
        console.log('contentBodyId = ' + uploadedFile.contentBodyId);
        console.log('contentVersionId = ' + uploadedFile.contentVersionId);
        console.log('documentId = ' + uploadedFile.documentId);
        console.log('mimeType = ' + uploadedFile.mimeType);
        console.log('name = ' + uploadedFile.name);
    }
}